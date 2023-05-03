// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import {FlashLoanSimpleReceiverBase} from "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

interface IDEX {
    function depositUSDC(uint256 _amount) external;

    function depositDAI(uint256 _amount) external;

    function buyDAI() external;

    function sellDAI() external;
}

contract ArbitrageFlashLoan is FlashLoanSimpleReceiverBase {
    address payable owner;
    address private constant daiAddress =
        0xDF1742fE5b0bFc12331D8EAec6b478DfDbD31464;
    address private constant usdcAddress =
        0xA2025B15a1757311bfD68cb14eaeFCc237AF5b43;

    IERC20 private dai;
    IERC20 private usdc;
    IDEX private dex;

    constructor(
        address _providerAddress,
        address _dexAddress
    ) FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_providerAddress)) {
        owner = msg.sender;
        dai = IERC20(daiAddress);
        usdc = IERC20(usdcAddress);
        dex = IDex(_dexAddress);
    }

    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
        dex.depositUSDC(1000000000);
        dex.buyDAI();
        dex.depositDAI(dai.balanceOf(address(this)));
        dex.sellDAI();

        IERC20(asset).approve(address(POOL), amount + premium);
        return true;
    }

    function flashLoan(address _token, uint256 _amount) external {
        POOL.flashLoanSimple(address(this), _token, _amount, "", 0);
    }

    function getBalance(address _token) external view returns (uint256) {
        return IERC20(_token).balanceOf(address(this));
    }

    function withdraw(address _token) external onlyOwner {
        IERC20 token = IERC20(_token);
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }

    function approveUSDC(uint256 _amount) external returns (bool) {
        return usdc.approve(dexContractAddress, _amount);
    }

    function approveDAI(uint256 _amount) external returns (bool) {
        return dai.approve(dexContractAddress, _amount);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only for owner");
        _;
    }
}
