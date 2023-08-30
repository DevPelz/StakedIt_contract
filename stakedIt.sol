// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

interface OFWStake {
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 amount) external returns (bool);
}

contract StakedIt {
    address immutable tokenContract;
    uint256 public contractBalance;

    struct Stakers {
        uint256 stakedAmount;
        uint256 stakeTime;
    }

    mapping(address => Stakers) stakers;
    event Staked(uint256 amount, uint256 totalAmountStaked, uint256 time);
    event Transfer(address indexed from, address indexed to, uint256 value);

    constructor(address _tokenContract) {
        tokenContract = _tokenContract;
    }

    function stake(uint256 _amount) public {
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

    function withdraw(uint256 _amount) public {
        OFWStake ofwStake = OFWStake(tokenContract);
        uint withdrawableBalance = stakers[msg.sender].stakedAmount;
        require(withdrawableBalance >= _amount, "Insufficient staked amount");
        stakers[msg.sender].stakedAmount -= _amount;
        ofwStake.transfer(msg.sender, _amount);
        emit Transfer(address(this), msg.sender, _amount);
    }

    function getStakedAmount(address _staker) public view returns (uint) {
        return stakers[_staker].stakedAmount;
    }
}