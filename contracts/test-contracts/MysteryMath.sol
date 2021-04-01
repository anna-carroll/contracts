// SPDX-License-Identifier: Apache-2.0
// Reproduced from https://github.com/celo-org/optics-monorepo/ under the terms of Apache-2.0

pragma solidity >=0.6.11;

abstract contract MysteryMath {
    uint256 public stateVar;

    function doMath(uint256 a, uint256 b)
        external
        pure
        virtual
        returns (uint256 _result);

    function setState(uint256 _var) external {
        stateVar = _var;
    }

    function getState() external view returns (uint256) {
        return stateVar;
    }
}
