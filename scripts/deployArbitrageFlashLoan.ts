import { ethers } from "hardhat";

const AAVE_POOL_ADDRESS_PROVIDER = '0x5E52dEc931FFb32f609681B8438A51c675cc232d'

async function main() {
  const AribtrageFlashLoan = await ethers.getContractFactory("AribtrageFlashLoan");
  const afl = await AribtrageFlashLoan.deploy(AAVE_POOL_ADDRESS_PROVIDER);

  await afl.deployed();

  console.log(afl.address)
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
