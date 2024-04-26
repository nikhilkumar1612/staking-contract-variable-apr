// SPDX-License-Identifier: Unlicensed
pragma solidity 0.8.17;


import {Ownable2Step} from "@openzeppelin/contracts/access/Ownable2Step.sol";
import {IStakingManager} from "./interfaces/IStakingManager.sol";
contract StakingManager is IStakingManager, Ownable2Step{
    uint256 public stakingDays = 60 days;
    uint256 public rewardDays = 240 days;
    uint256 public earlyWithdraw = 50;

    /**
     * @inheritdoc IStakingManager
     */
    function updateStakingDays(
        uint256 _newStakingDays
    )
        external
        onlyOwner()
    {
        stakingDays = _newStakingDays;
    }


    /**
     * @inheritdoc IStakingManager
     */
    function updateRewardDays(
        uint256 _newRewardDays
    )
        external
    {
        rewardDays = _newRewardDays;
    }


    /**
     * @inheritdoc IStakingManager
     */
    function updateEarlyWithdraw(
        uint256 _newEarlyWithdraw
    )
        external
    {
        earlyWithdraw = _newEarlyWithdraw;
    }
}