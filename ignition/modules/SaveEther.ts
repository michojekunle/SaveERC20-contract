import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const tokenAddress = "0x072D37C74404d375Fa8B069C8aF50C0950DbF351";

const SaveEtherModule = buildModule("SaveEtherModule", (m) => {
  const save = m.contract("SaveEther", [tokenAddress]);

  return { save };
});

export default SaveEtherModule;
