import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const tokenAddress = "";

const StakingERC20Module = buildModule("StakingERC20Module", (m) => {

  const staking = m.contract("StakingERC20", [tokenAddress]);

  return { staking };
});

export default StakingERC20Module;