# StakedIt Smart Contract

## Overview

This StakedIt smart contract allows users to stake a specified amount of a given token using the provided OFWStake interface. Staked amounts are tracked along with the timestamp of the stake. Users can also withdraw their staked amounts from the contract and earn an `ERC20` token also.

## Contract Details

- **Solidity Version:** 0.8.0
- **License:** MIT
- **Token Contract:** OFWStake (as specified in the interface)
- **Minimum Stake Amount:** 1,000,000 (1 million) units of the token

## Features

1. Stake: Users can stake a specified amount of the token, subject to a minimum stake amount.
2. Withdraw: Users can withdraw their staked amount from the contract if it's available.
3. Balance Tracking: The contract keeps track of staked amounts for each user along with the stake timestamp.
4. Events: The contract emits events for stake and transfer actions.

## Usage

1. Deploy the `StakedIt` contract, providing the address of the `OFWStake: 0x8Bc4b37aff83FdA8a74d2b5732437037B801183e` token contract.
2. Users can stake tokens using the `stake` function.
3. Users can withdraw staked tokens using the `withdraw` function.
4. On withdrawal users will recieve rewards if the requirements are met.
5. Retrieve staked amounts using the `getStakedAmount` function.
6. Monitor emitted events to track staking and transfer activities.


## Note

This README provides a basic understanding of the StakedIt smart contract. Before deploying or using the contract, it's recommended to review the code and conduct thorough testing.
Cheers!!

