const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("VIP_Bank Contract", function () {
    let vipBank;
    let manager;
    let vipUser;
    let anotherUser;

    beforeEach(async function () {
        // Deploy the VIP_Bank contract
        [manager, vipUser, anotherUser] = await ethers.getSigners();
        const VIPBank = await ethers.getContractFactory("VIP_Bank");
        vipBank = await VIPBank.deploy();
        // await vipBank.deployed();
    });

    it("should revert when a VIP user tries to withdraw if contract balance is greater than 0.5 ETH", async function () {
        // Add vipUser as a VIP
        await vipBank.addVIP(vipUser.address);

        // Deposit 0.05 ETH from vipUser
        await vipBank.connect(vipUser).deposit({ value: ethers.parseEther("0.05") });

        // Check the initial balance
        expect(await vipBank.balances(vipUser.address)).to.equal(ethers.parseEther("0.05"));

        // Increase contract balance to exceed 0.5 ETH
        await vipBank.connect(vipUser).deposit({ value: ethers.parseEther("0.05") });
        await vipBank.connect(vipUser).deposit({ value: ethers.parseEther("0.05") });
        await vipBank.connect(vipUser).deposit({ value: ethers.parseEther("0.05") });
        await vipBank.connect(vipUser).deposit({ value: ethers.parseEther("0.05") });
        await vipBank.connect(vipUser).deposit({ value: ethers.parseEther("0.05") });
        await vipBank.connect(vipUser).deposit({ value: ethers.parseEther("0.05") });
        await vipBank.connect(vipUser).deposit({ value: ethers.parseEther("0.05") });
        await vipBank.connect(vipUser).deposit({ value: ethers.parseEther("0.05") });
        await vipBank.connect(vipUser).deposit({ value: ethers.parseEther("0.05") });
        await vipBank.connect(vipUser).deposit({ value: ethers.parseEther("0.05") });
        await vipBank.connect(vipUser).deposit({ value: ethers.parseEther("0.05") });

        // Attempt to withdraw funds
        await expect(vipBank.connect(vipUser).withdraw(ethers.parseEther("0.05")))
            .to.be.revertedWith("Cannot withdraw more than 0.5 ETH per transaction");
    });
});