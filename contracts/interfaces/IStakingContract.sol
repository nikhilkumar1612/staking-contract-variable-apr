// SPDX-License-Identifier: Unlicensed
pragma solidity 0.8.17;

interface IStakingContract {
    /**
     * @notice Function to stake.
     * @param _amount - Number of tokens to ne staked.
     */
    function stake(uint256 _amount) external;

    /**
     * @notice Function to unstake.
     * @param _amount - Number of tokens to be unstaked.
     */
    function unstake(uint256 _amount) external;

    /**
     * @notice Function to be used by owner to unstake from `_staker` account
     * @param _staker - address of the staker
     */
    function ustakeByOwner(address _staker) external;

    /**
     * @notice - Funtion to get the total rewards for `_staker`.
     * @param _staker - Address of he staker.
     * @return Total rewards for `_staker`.
     */
    function getrewards(address _staker) external view returns(uint256);
}