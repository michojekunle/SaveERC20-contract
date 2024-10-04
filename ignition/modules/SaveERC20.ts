import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const tokenAddress = "0xA2ec96B3Cc0318F5A33114E996Fb9A6a6FAe3ADC";

const SaveERC20Module = buildModule("SaveERC20Module", (m) => {
  const save = m.contract("SaveERC20", [tokenAddress]);

  return { save };
});

export default SaveERC20Module;
