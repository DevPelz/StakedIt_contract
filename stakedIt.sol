// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

interface OFWStake {
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 amount) external returns (bool);
}

contract StakedIt is ERC20("STAKING_REWARDS_TOKEN", "SRT") {
    OFWStake immutable tokenContract;
    uint256 public contractBalance;
    uint256 min_stake_duration = 60 minutes;
    uint8 rate = 3;
    uint8 percentage = 100;

    struct Stakers {
        uint256 stakedAmount;
        uint256 stakeTime;
    }

    mapping(address => Stakers) stakers;
    event Staked(uint256 amount, uint256 totalAmountStaked, uint256 time);

    constructor(address _tokenContract) {
        tokenContract = OFWStake(_tokenContract);
    }

    function stake(uint256 _amount) external {
        OFWStake ofwStake = OFWStake(tokenContract);
        uint256 balance = ofwStake.balanceOf(msg.sender);
        require(balance >= _amount, "Insufficient Balance");
        require(_amount >= 1_000_000, "Minimum Stake amount is 1_000_000!!!");
        bool status = ofwStake.transferFrom(msg.sender, address(this), _amount);
        require(!status, "Transfer Failed");
        stakers[msg.sender].stakedAmount += _amount;
        contractBalance += _amount;
        stakers[msg.sender].stakeTime = block.timestamp;
        emit Staked(_amount, stakers[msg.sender].stakedAmount, block.timestamp);
    }

    function withdraw() external {
        uint withdrawableBalance = stakers[msg.sender].stakedAmount;
        uint256 _stakeTime = stakers[msg.sender].stakeTime;
        uint256 _stakeWithdrawalTime = _stakeTime + min_stake_duration;

        if (_stakeWithdrawalTime > block.timestamp) {
            revert("Withdrawal time not reached");
        } else {
            require(withdrawableBalance > 0, "Insufficient staked balance");

            uint256 stakeCalculation = (withdrawableBalance * rate) /
                percentage;
            uint256 stakeDuration = (block.timestamp - _stakeTime) /
                min_stake_duration;
            uint256 stakeReward = stakeDuration * stakeCalculation;
            tokenContract.transfer(msg.sender, withdrawableBalance);
            emit Transfer(address(this), msg.sender, withdrawableBalance);
            _mint(msg.sender, stakeReward);

            contractBalance -= stakers[msg.sender].stakedAmount;
            stakers[msg.sender].stakedAmount = 0;
        }
    }

    function getStakedAmount(address _staker) external view returns (uint) {
        return stakers[_staker].stakedAmount;
    }

    function getExpectedReward(
        uint _amount,
        uint256 _time
    ) external view returns (uint) {
        uint exRwd = (_amount * rate) / 100;
        uint rwdTime = (_time) / min_stake_duration;
        return exRwd * rwdTime;
    }
}
