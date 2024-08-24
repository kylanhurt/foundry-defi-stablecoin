// SPDX-LICENSE-IDENTIFIER: MIT;

pragma solidity ^0.8.18;
import {AggregatorV3Interface} from '@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol';

/**
 * @title OracleLib
 * @author Kylan Hurt
 * @notice This library is used to check the Chainlink Oracle for stale data
 * If a price is stale, the function(s) should revert and render the DSCEngine unusable
 * This is by design
 * 
 * So if the Chainlink network explodes and you have a lot in the protocol... too bad
 *
 */
library OracleLib {
    error OracleLib__StalePrice();
    uint256 private constant TIMEOUT = 3 hours;

    function staleCheckLatestRoundData (AggregatorV3Interface priceFeed) public view returns (uint80, int256, uint256, uint256, uint80) {
        (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        uint256 secondsSinceUpdated = block.timestamp - updatedAt;
        if (secondsSinceUpdated > TIMEOUT) {
            revert OracleLib__StalePrice();
        }
        return (roundId, answer, startedAt, updatedAt, answeredInRound);
    }  
}