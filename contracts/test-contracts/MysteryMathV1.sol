// SPDX-License-Identifier: Apache-2.0
// Reproduced from https://github.com/celo-org/optics-monorepo/ under the terms of Apache-2.0

pragma solidity >=0.6.11;

import "./MysteryMath.sol";

contract MysteryMathV1 is MysteryMath {
    uint32 public immutable version;

    constructor() {
        version = 1;
    }

    function doMath(uint256 a, uint256 b)
        external
        pure
        override
        returns (uint256 _result)
    {
        _result = a + b;
    }
}
