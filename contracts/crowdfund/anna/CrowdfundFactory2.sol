// SPDX-License-Identifier: GPL-3.0-or-later
// Reproduced and modified from https://github.com/mirror-xyz/crowdfund/blob/main/contracts/ under the terms of GPL-3.0
pragma solidity 0.8.4;

import {CrowdfundProxy2} from "./CrowdfundProxy2.sol";

/**
 * @title CrowdfundFactory2
 * @author Anna Carroll (modified from CrowdfundFactory by MirrorXYZ)
 */
contract CrowdfundFactory2 {
    //======== Structs ========

    struct Parameters {
        address payable operator;
        address payable fundingRecipient;
        uint256 fundingCap;
        uint256 operatorPercent;
        string name;
        string symbol;
    }

    //======== Events ========

    event CrowdfundDeployed(
        address crowdfundProxy,
        string name,
        string symbol,
        address operator
    );

    //======== Immutable storage =========

    address public immutable logic;

    //======== Mutable storage =========

    // Gets set within the block, and then deleted.
    Parameters public parameters;

    //======== Constructor =========

    constructor(address logic_) {
        logic = logic_;
    }

    //======== Deploy function =========

    function createCrowdfund(
        string calldata name_,
        string calldata symbol_,
        address payable operator_,
        address payable fundingRecipient_,
        uint256 fundingCap_,
        uint256 operatorPercent_
    ) external returns (address crowdfundProxy) {
        crowdfundProxy = address(
            new CrowdfundProxy2{
                salt: keccak256(abi.encode(name_, symbol_, operator_))
            }(
                logic,
                name_,
                symbol_,
                operator_,
                fundingRecipient_,
                fundingCap_,
                operatorPercent_
            )
        );

        emit CrowdfundDeployed(crowdfundProxy, name_, symbol_, operator_);
    }
}
