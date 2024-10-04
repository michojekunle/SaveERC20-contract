// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

contract StakingERC20 {
    address owner;
    uint8 constant APY = 7;
    uint32 constant MAX_DURATION = 2.628e6;

    // struct
    struct Stake {
        uint256 amount;
        uint256 endReward;
        bool isWithdrawn;
        uint256 endTime;
        uint256 startTime;
    }

    // mapppings
    mapping(address => Stake[]) stakes;

    // events

    // errors
    error ZeroAmountNotAllowed();
    error ZeroAddressNotAllowed();
    error StakeTimeHasNotEnded();
    error UserHasNoStakes();
    error StakeAlreadyWithdraw();
    error MaximumNumberOfStakesForUserReached();
    error MaximumNumbeOfStakersReached();
    error MaximumStakingDurationExceeded();
    error WithdrawalFailed();
    error StakeAlreadyWithdrawn();

    // contructors
    constructor() payable {
        owner = msg.sender;
        if (msg.value <= 0) revert ZeroAmountNotAllowed();
    }

    function stake(uint64 _duration) external payable {
        if (msg.sender == address(0)) revert ZeroAddressNotAllowed();
        if (msg.value < 0) revert ZeroAmountNotAllowed();
        if (stakes[msg.sender].length > 3)
            revert MaximumNumberOfStakesForUserReached();
        if (_duration > MAX_DURATION) revert MaximumStakingDurationExceeded();

        Stake memory newStake = Stake(
            msg.value,
            calculateReward(msg.value, APY, block.timestamp + _duration),
            false,
            block.timestamp + _duration,
            block.timestamp
        );

        stakes[msg.sender].push(newStake);
    }

    function withdraw(uint8 _userStakeId) external {
        if (msg.sender == address(0)) revert ZeroAddressNotAllowed();
        if (
            stakes[msg.sender].length < 1 ||
            _userStakeId > stakes[msg.sender].length
        ) revert UserHasNoStakes();

        Stake memory userStake = stakes[msg.sender][_userStakeId]; 
        if(userStake.isWithdrawn) revert StakeAlreadyWithdrawn();  

        userStake.isWithdrawn = true;     

        (bool sent, ) = msg.sender.call{value: userStake.endReward}("");
        if(!sent) revert WithdrawalFailed();
    }

    function getCurrentStakeBalance(
        uint8 _userStakeId
    ) external view returns (uint256) {
        if (msg.sender == address(0)) revert ZeroAddressNotAllowed();
        if (
            stakes[msg.sender].length < 1 ||
            _userStakeId > stakes[msg.sender].length
        ) revert UserHasNoStakes();
        Stake memory userStake = stakes[msg.sender][_userStakeId];
        if (userStake.endTime < block.timestamp) revert StakeTimeHasNotEnded();

        uint256 time = userStake.startTime + block.timestamp;
        if (userStake.endTime > block.timestamp) time = userStake.endTime;
        return calculateReward(userStake.amount, APY, time);
    }

    function getUserStakes() external view returns (Stake[] memory stakes_) {
        if (msg.sender == address(0)) revert ZeroAddressNotAllowed();
        if (stakes[msg.sender].length < 1) revert UserHasNoStakes();

        stakes_ = stakes[msg.sender];
    }

    function calculateReward(
        uint256 _p,
        uint8 _r,
        uint256 _t
    ) private pure returns (uint256 reward_) {
        reward_ = _p + (_p * _r * _t) / 100;
    }
}
