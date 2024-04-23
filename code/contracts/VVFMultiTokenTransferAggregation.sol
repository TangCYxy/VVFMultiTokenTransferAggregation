// SPDX-License-Identifier: MIT
pragma solidity 0.7.5;
pragma abicoder v2;

import "./lib/TransferWithAuthorizationInterface.sol";
import "./lib/MetaTransactionInterface.sol";
import "./lib/IERC20.sol";
import "./lib/SafeMath.sol";

contract VVFMultiTokenTransferAggregation {
    enum CoinTypeSupported {
        USDC_POLYGON,   // polygon链上的usdc合约类型
        USDT_POLYGON    // polygon链上的usdt合约类型
    }

    using SafeMath for uint256;

    // 允许一个交易里进行usdc和usdt的支付
    struct TokenTransferParams {
        // coin通用属性
        CoinTypeSupported coinType;
        address coinAddress;
        // 支付参数
        address payFrom;
        address payTo;
        uint256 payAmount;
        // usdc转账的额外参数
        uint256 validAfter;
        uint256 validBefore;
        bytes32 nonce;
        // usdt转账的签名
        uint8 pv;
        bytes32 pr;
        bytes32 ps;
    }

    function batchTokenTransfer(TokenTransferParams[] memory transfers) public {
        // 权限校验
        require(msg.sender != address(this), "Caller is this contract");
        for (uint256 i = 0;i < transfers.length;i++) {
            TokenTransferParams memory params = transfers[i];
            require(params.coinAddress != address(0) && params.coinAddress != address(this), "coinAddress can not be 0 or this contract");
            // 资金转账
            if (params.coinType == CoinTypeSupported.USDC_POLYGON) {
                TransferWithAuthorizationApi(params.coinAddress).transferWithAuthorization(params.payFrom, params.payTo, params.payAmount, params.validAfter, params.validBefore, params.nonce, params.pv, params.pr, params.ps);
            } else if (params.coinType == CoinTypeSupported.USDT_POLYGON) {
                bytes memory signature = abi.encodeWithSelector(bytes4(0xa9059cbb), params.payTo, params.payAmount);
                NativeMetaTransactionApi(params.coinAddress).executeMetaTransaction(params.payFrom, signature, params.pr, params.ps, params.pv);
            } else {
                revert("unsupported coin type for batch transfer");
            }
        }
    }
}