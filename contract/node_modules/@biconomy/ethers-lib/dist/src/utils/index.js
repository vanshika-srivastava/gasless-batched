"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.toTxResult = exports.sameString = void 0;
function sameString(str1, str2) {
    return str1.toLowerCase() === str2.toLowerCase();
}
exports.sameString = sameString;
function toTxResult(transactionResponse, options) {
    return {
        hash: transactionResponse.hash,
        options,
        transactionResponse
    };
}
exports.toTxResult = toTxResult;
//# sourceMappingURL=index.js.map