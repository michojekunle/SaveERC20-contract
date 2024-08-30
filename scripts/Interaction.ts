import { ethers } from "hardhat";

async function main() {
  const web3CXITokenAddress = "0x072D37C74404d375Fa8B069C8aF50C0950DbF351";
  const web3CXI = await ethers.getContractAt("IERC20", web3CXITokenAddress);

  const saveERC20ContractAddress = "0x96255F7A011E9a0c495Eb480f5f33Ff8A5543715";
  const saveERC20 = await ethers.getContractAt(
    "ISaveERC20",
    saveERC20ContractAddress
  );

  // Approve savings contract to spend token
  const approvalAmount = ethers.parseUnits("1000", 18);
  const approveTx = await web3CXI.approve(saveERC20, approvalAmount);
  approveTx.wait();

  const contractBalanceBeforeDeposit = await saveERC20.getContractBalance();

  console.log("Contract balance before deposit", contractBalanceBeforeDeposit);

  const depositAmount = ethers.parseUnits("150", 18);
  const depositTx = await saveERC20.deposit(depositAmount);
  //   console.log(depositTx);
  depositTx.wait();

  const contractBalanceAfterDeposit = await saveERC20.getContractBalance();
  console.log("Contract balance After deposit", contractBalanceAfterDeposit);

  const withdrawalAmount = ethers.parseUnits("30", 18);
  const withdrawalTx = await saveERC20.withdraw(withdrawalAmount);
  console.log(withdrawalTx);
  withdrawalTx.wait();

  const contractBalanceAfterWithdrawal = await saveERC20.getContractBalance();
  console.log(
    "Contract balance After withdraw",
    contractBalanceAfterWithdrawal
  );
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
