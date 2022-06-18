import { expect } from "chai";
import { ethers } from "hardhat";
import {
  RockPaperScissors as RockPaperScissorsType,
  RPS as RPSType,
} from "../typechain";
const setup = async () => {
  const RPS = await ethers.getContractFactory("RPS");
  const rps = (await RPS.deploy()) as RPSType;
  await rps.deployed();
  const GAME = await ethers.getContractFactory("RockPaperScissors");
  const tokenAddress = rps.address;
  const game = (await GAME.deploy(
    tokenAddress,
    ethers.utils.parseEther("100")
  )) as RockPaperScissorsType;
  await game.deployed();
  return {
    rps,
    game,
    tokenAddress,
  };
};
const setupWithGame = async (
  userAOption: "0" | "1" | "2",
  userBOption: "0" | "1" | "2"
) => {
  const { rps, game } = await setup();
  const [userA, userB] = await ethers.getSigners();
  await rps.faucet(ethers.utils.parseEther("100"));
  await rps.connect(userB).faucet(ethers.utils.parseEther("100"));
  await rps.approve(game.address, ethers.utils.parseEther("100000"));
  await rps
    .connect(userB)
    .approve(game.address, ethers.utils.parseEther("100000"));
  await game.setOption(userAOption);
  await game.connect(userB).setOption(userBOption);
  return {
    rps,
    game,
    userA,
    userB,
  };
};

describe("RockPaperScissors", () => {
  it("Have correct tokenAddress and betting Amount", async () => {
    const { game } = await setup();
    expect(await game.tokenAddress());
    expect(await game.bettingAmount()).to.equal(ethers.utils.parseEther("100"));
  });
  it("Contract have 100 rps, user have 0 rps, correct userA", async () => {
    const { rps, game } = await setup();
    const [userA] = await ethers.getSigners();
    await rps.faucet(ethers.utils.parseEther("100"));
    await rps.approve(game.address, ethers.utils.parseEther("100"));
    await game.setOption("1");
    expect(await rps.balanceOf(userA.address)).to.equal(
      ethers.utils.parseEther("0")
    );
    expect(await rps.balanceOf(game.address)).to.equal(
      ethers.utils.parseEther("100")
    );
    expect(await game.userA()).to.equal(userA.address);
  });
  it("Correct userA, correct userB", async () => {
    const { rps, game } = await setup();
    const [userA, userB] = await ethers.getSigners();
    await rps.faucet(ethers.utils.parseEther("100"));
    await rps.connect(userB).faucet(ethers.utils.parseEther("100"));
    await rps.approve(game.address, ethers.utils.parseEther("100"));
    await rps
      .connect(userB)
      .approve(game.address, ethers.utils.parseEther("100"));
    await game.setOption("1");
    await game.connect(userB).setOption("1");
    expect(await game.userA()).to.equal(userA.address);
    expect(await game.userB()).to.equal(userB.address);
  });
  it("(1,1) userA:100 userB:100", async () => {
    const { rps, userA, userB, game } = await setupWithGame("1", "1");
    expect(await rps.balanceOf(userA.address)).to.equal(
      ethers.utils.parseEther("100")
    );
    expect(await rps.balanceOf(userB.address)).to.equal(
      ethers.utils.parseEther("100")
    );
    expect(await rps.balanceOf(game.address)).to.equal(
      ethers.utils.parseEther("0")
    );
  });
  it("(0,1) userA:0 userB:200", async () => {
    const { rps, userA, userB, game } = await setupWithGame("0", "1");
    expect(await rps.balanceOf(userA.address)).to.equal(
      ethers.utils.parseEther("0")
    );
    expect(await rps.balanceOf(userB.address)).to.equal(
      ethers.utils.parseEther("200")
    );
    expect(await rps.balanceOf(game.address)).to.equal(
      ethers.utils.parseEther("0")
    );
  });
  it("(2,1) userA:200 userB:0", async () => {
    const { rps, userA, userB, game } = await setupWithGame("2", "1");
    expect(await rps.balanceOf(userA.address)).to.equal(
      ethers.utils.parseEther("200")
    );
    expect(await rps.balanceOf(userB.address)).to.equal(
      ethers.utils.parseEther("0")
    );
    expect(await rps.balanceOf(game.address)).to.equal(
      ethers.utils.parseEther("0")
    );
  });
});
