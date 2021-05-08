// SPDX-License-Identifier: GPL-3.0-or-later
// Reproduced and modified from https://github.com/mirror-xyz/crowdfund/blob/main/contracts/ under the terms of GPL-3.0
pragma solidity 0.8.4;

import {CrowdfundStorage} from "../CrowdfundStorage.sol";

interface ICrowdfundFactory {
    function mediaAddress() external returns (address);

    function logic() external returns (address);

    // ERC20 data.
    function parameters()
        external
        returns (
            address payable operator,
            address payable fundingRecipient,
            uint256 fundingCap,
            uint256 operatorPercent,
            string memory name,
            string memory symbol
        );
}

/**
 * @title CrowdfundProxy2
 * @author Anna Carroll (modified from CrowdfundProxy by MirrorXYZ)
 */
contract CrowdfundProxy2 is CrowdfundStorage {
    constructor(
        address logic_,
        string memory name_,
        string memory symbol_,
        address payable operator_,
        address payable fundingRecipient_,
        uint256 fundingCap_,
        uint256 operatorPercent_
    ) {
        // Crowdfund logic
        logic = logic_;

        // Crowdfund-specific data.
        name = name_;
        symbol = symbol_;
        operator = operator_;
        fundingRecipient = fundingRecipient_;
        fundingCap = fundingCap_;
        operatorPercent = operatorPercent_;

        // Initialize mutable storage.
        status = Status.FUNDING;
    }

    fallback() external payable {
        address _impl = logic;
        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize())
            let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)
            let size := returndatasize()
            returndatacopy(ptr, 0, size)

            switch result
                case 0 {
                    revert(ptr, size)
                }
                default {
                    return(ptr, size)
                }
        }
    }

    receive() external payable {}
}