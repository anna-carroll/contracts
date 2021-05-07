// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity >=0.6.11;

contract TestReceiveNoFallback {
    event Fallback();
    event Receive();

    // Send a call with zero data AND non-zero value; should hit receive; should emit receive event
    receive() external payable {
        emit Receive();
    }

    function double(uint256 a) external pure returns (uint256 _result) {
        _result = a + a;
    }
}

contract TestReceiveAndFallbackPayable {
    event Fallback();
    event Receive();

    // Send a call with non-zero data AND non-zero value; should hit fallback; should emit fallback event
    fallback() external payable {
        emit Fallback();
    }

    // Send a call with zero data AND non-zero value; should hit receive; should emit receive event
    receive() external payable {
        emit Receive();
    }

    function double(uint256 a) external pure returns (uint256 _result) {
        _result = a + a;
    }
}

contract TestReceiveAndFallbackNotPayable {
    event Fallback();
    event Receive();

    // Send a call with non-zero data AND non-zero value; should hit fallback; should revert because fallback not payable
    fallback() external {
        emit Fallback();
    }

    // Send a call with zero data AND non-zero value; should hit receive; should emit receive event
    receive() external payable {
        emit Receive();
    }

    function double(uint256 a) external pure returns (uint256 _result) {
        _result = a + a;
    }
}

contract TestNoReceiveAndFallbackPayable {
    event Fallback();
    event Receive();

    // Send a call with non-zero data AND non-zero value; should hit fallback; should revert because fallback not payable
    fallback() external payable {
        emit Fallback();
    }

    function double(uint256 a) external pure returns (uint256 _result) {
        _result = a + a;
    }
}

contract TestNoReceiveAndFallbackNotPayable {
    event Fallback();
    event Receive();

    // Send a call with non-zero data AND non-zero value; should hit fallback; should revert because fallback not payable
    fallback() external {
        emit Fallback();
    }

    function double(uint256 a) external pure returns (uint256 _result) {
        _result = a + a;
    }
}
