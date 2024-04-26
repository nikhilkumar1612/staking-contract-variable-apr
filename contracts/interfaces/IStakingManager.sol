// SPDX-License-Identifier: Unlicensed
pragma solidity 0.8.17;

interface IStakingManager {
    /**
     * @notice Function to change number of days for which user can stake.
     * @param _newStakingDays - Number of days in seconds for which user can stake.
     */
    function updateStakingDays(uint256 _newStakingDays) external;

    /**
     * @notice Function to change the number of days for which the rewards are available.
     * @param _newRewardDays - Number of days in seconds for which rewards are available.
     */
    function updateRewardDays(uint256 _newRewardDays) external;

    /**
     * @notice Function to change % slashing in case of early withdrawal.
     * @param _newEarlyWithdraw - Percentage decrease in case of early withdrawal.
     */
    function updateEarlyWithdraw(uint256 _newEarlyWithdraw) external;
}