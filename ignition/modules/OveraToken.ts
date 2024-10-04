import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { parseUnits } from "ethers";

const OveraTokenModule = buildModule("OveraTokenModule", (m) => {

  const OveraToken = m.contract("OveraToken", [`${parseUnits("100000", 18)}`]);

  return { OveraToken };
});

export default OveraTokenModule;