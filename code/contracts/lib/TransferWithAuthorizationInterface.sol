// SPDX-License-Identifier: MIT

pragma solidity 0.7.5;

interface TransferWithAuthorizationApi {
    function transferWithAuthorization(
        address from,
        address to,
        uint256 value,
        uint256 validAfter,
        uint256 validBefore,
        bytes32 nonce,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external ;
}