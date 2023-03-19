// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/KeeperCompatibleInterface.sol";

/**
 * @title The Counter contract
 * @notice  A keeper-compatible contract that increments counter variable at fixed time intervals
 */
contract KeepersCounter is KeeperCompatibleInterface {
    /**
     * Public counter variable
     */
    uint256 public counter;

    /**
     * Use an interval in seconds and a timestamp to slow execution of Upkeep
     */
    uint256 public immutable interval;
    uint256 public lastTimeStamp;

    /**
     * @notice Executes once when a contract is created to initialize state variables
     *
     * @param updateInterval - Period of time between two counter increments expressed as UNIX timestamp value
     */
    constructor(uint256 updateInterval) {
        interval = updateInterval;
        lastTimeStamp = block.timestamp;

        counter = 0;
    }

    /**
     * @notice Checks if the contract requires work to be done
     */
    function checkUpkeep(
        bytes memory /* checkData */
    )
        public
        view
        override
        returns (
            bool upkeepNeeded,
            bytes memory /* performData */
        )
    {
        upkeepNeeded = (block.timestamp - lastTimeStamp) > interval;
        // We don't use the checkData in this example. The checkData is defined when the Upkeep was registered.
    }

    /**
     * @notice Performs the work on the contract, if instructed by :checkUpkeep():
     */
    function performUpkeep(
        bytes calldata /* performData */
    ) external override {
        // add some verification
        (bool upkeepNeeded, ) = checkUpkeep("");
        require(upkeepNeeded, "Time interval not met");

        lastTimeStamp = block.timestamp;
        counter = counter + 1;
        // We don't use the performData in this example. The performData is generated by the Keeper's call to your checkUpkeep function
    }
}
