import { expect } from "chai";
import { ethers } from "hardhat";
import { RPScoin } from "../typechain";

describe("RPS", () => {
  it("RPS's name is RockPaperScissorsCoin", async () => {
    const RPS = await ethers.getContractFactory("RPS");
    const rps = (await RPS.deploy()) as RPScoin;
    await rps.deployed();
    expect(await rps.name()).to.equal("RockPaperScissorsCoin");
  });

  it("Receive 100 RPS after facuet 100", async () => {
    const RPS = await ethers.getContractFactory("RPS");
    const [owner] = await ethers.getSigners();
    const rps = (await RPS.deploy()) as RPScoin;
    await rps.deployed();
    await rps.faucet(ethers.utils.parseEther("100"));
    expect(await rps.balanceOf(owner.address)).to.equal(
      ethers.utils.parseEther("100")
    );
  });
});
