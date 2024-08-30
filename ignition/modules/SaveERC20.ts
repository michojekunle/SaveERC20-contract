import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const tokenAddress = "0x072D37C74404d375Fa8B069C8aF50C0950DbF351";

const SaveERC20Module = buildModule("SaveERC20Module", (m) => {
  const save = m.contract("SaveERC20", [tokenAddress]);

  return { save };
});

export default SaveERC20Module;
