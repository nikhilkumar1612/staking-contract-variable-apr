// SPDX-License-Identifier: Unlicensed
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {StakingManager} from "./StakingManager.sol";
import "./Errors.sol";

contract StakingContract is StakingManager{

    uint256 constant ONE_YEAR = 365 days;
    uint256 constant APR_PRECISION = 100;
    uint256 constant HUNDRED_MIL = 10 ** 8;
    uint256 constant public START_APR = 25000;
    uint256 constant public END_APR = 2500;
    uint256 constant public DIFF_APR = START_APR - END_APR;

    struct UserStake {
        uint256 amount;
        uint256 startedAt;
    }

    uint256 public totalStaked;
    uint256 public apr;
    IERC20 immutable public token;
    mapping(address => UserStake) public stakes;

    event Staked();
    event Unstaked();
    event UnstakedByOwner();

    constructor(
        IERC20 _token
    ) {
        token = _token;
    }

    /**
     * @notice Function to stake.
     * @param _amount - Number of tokens to ne staked.
     */
    function stake(
        uint256 _amount
    ) external {
        UserStake memory us = stakes[msg.sender];

        if(block.timestamp - us.startedAt > stakingDays) {
            revert StakePeriodExpired();
        }
        totalStaked += _amount;
        us.amount += _amount;
        if(us.startedAt == 0) {
            us.startedAt = block.timestamp;
        }

        stakes[msg.sender] = us;
        apr = START_APR - (totalStaked * DIFF_APR)/(HUNDRED_MIL);
        token.transferFrom(msg.sender, address(this), _amount);
        emit Staked();
    }

    /**
     * @notice Function to unstake.
     * @param _amount - Number of tokens to be unstaked.
     */
    function unstake(
        uint256 _amount
    ) external {
        UserStake memory us = stakes[msg.sender];
        if(us.amount < _amount) {
            revert InsuffucientAmount();
        }

        uint256 total;

        if(block.timestamp - us.startedAt < rewardDays) {
            total = (_amount * earlyWithdraw)/100;
        } else {
            total = _amount;
        }

        total += _getRewards(msg.sender, _amount);

        us.amount -= _amount;
        totalStaked -= _amount;

        if(us.amount == 0) {
            us.startedAt = 0;
        }
        stakes[msg.sender] = us;

        token.transfer(msg.sender, total);
        emit Unstaked();
    }

    /**
     * @notice Function to be used by owner to unstake from `_staker` account
     * @param _staker - address of the staker
     */
    function ustakeByOwner(
        address _staker
    )
        external
        onlyOwner()
    {
        UserStake memory us = stakes[_staker];
        if(us.amount > 0) {
            revert InsuffucientAmount();
        }

        uint256 total = us.amount;

        if(block.timestamp - us.startedAt < rewardDays) {
            revert OwnerCannotUnstakeNow();
        }

        total += _getRewards(msg.sender, us.amount);

        totalStaked -= us.amount;
        us.amount = 0;
        us.startedAt = 0;
        stakes[msg.sender] = us;

        token.transfer(msg.sender, total);
        emit UnstakedByOwner();
    }

    /**
     * @notice - Funtion to get the total rewards for `_staker`.
     * @param _staker - Address of he staker.
     * @return Total rewards for `_staker`.
     */
    function getrewards(
        address _staker
    )
        external
        view
        returns(uint256)
    {
        return _getRewards(_staker, stakes[_staker].amount);
    }


    function _getRewards(
        address _staker,
        uint256 _amount
    )
        internal
        view
        returns(uint256)
    {
        UserStake memory us = stakes[_staker];
        uint256 timeElapsed = (block.timestamp - us.startedAt) > rewardDays ?
                                    rewardDays :
                                    (block.timestamp - us.startedAt);
        uint256 rewards = (_amount * timeElapsed * apr)/(ONE_YEAR * APR_PRECISION * APR_PRECISION);
        return rewards;
    }
}
