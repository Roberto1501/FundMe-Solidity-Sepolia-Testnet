// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


library PriceConverter {

            function getPrice()internal view returns (uint256){
        // ABI
        //ADDRESS 0x694AA1769357215DE4FAC081bf1f309aDC325306
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);

       ( ,int256 price,,,)=  priceFeed.latestRoundData();
        //ETH in terms osf USD

        return  uint256(price * 1e10);

    }

    function getConvertionRate(uint256 ethAmount) internal view returns (uint256) {
            uint256 ethPrice = getPrice();
            uint256 ethAmountUsd = (ethPrice * ethAmount)/ 1e18;
            return  ethAmountUsd;
    }
}