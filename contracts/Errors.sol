// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

// error thrown when staking period for a user has crossed and cannot be staked again.
error StakePeriodExpired();

// error thrown when the amount is not sufficient for unstaking.
error InsuffucientAmount();

// error thrown when owner tries to unstake before.
error OwnerCannotUnstakeNow();