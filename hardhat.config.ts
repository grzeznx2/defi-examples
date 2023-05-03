import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from 'dotenv'
dotenv.config()


const config: HardhatUserConfig = {
  solidity: "0.8.10",
  networks: {
    goerli: {
      url: process.env.ALCHEMY_KEY,
      accounts: [process.env.PRIVATE_KEY!]
    }
  }
};

export default config;
