// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import {FlashLoanSimpleReceiverBase} from "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

contract ArbitrageFlashLoan is FlashLoanSimpleReceiverBase {
   address payable owner;

   constructor(address _providerAddress) FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_providerAddress)){
    owner = msg.sender;
   }

   function executeOperation(
    address asset,
    uint256 amount,
    uint256 premium,
    address initiator,
    bytes calldata params
  ) external override returns (bool){


    IERC20(asset).approve(address(POOL), amount + premium);
    return true;
  }

  function flashLoan(address _token, uint256 _amount) external {
    POOL.flashLoanSimple(address(this), _token, _amount, '', 0);
  }

  function getBalance(address _token) external view returns(uint256){
    return IERC20(_token).balanceOf(address(this));
  }

  function withdraw(address _token) external onlyOwner {
    IERC20 token = IERC20(_token);
    token.transfer(msg.sender, token.balanceOf(address(this)));
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "Only for owner");
    _;
  }
}
