"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getMultiSendContract = exports.getProxyFactoryContract = exports.getSafeContract = exports.getSafeProxyFactoryContractDeployment = exports.getMultiSendContractDeployment = exports.getSafeContractDeployment = void 0;
const safe_deployments_1 = require("@gnosis.pm/safe-deployments");
const config_1 = require("./config");
function getSafeContractDeployment(safeVersion, chainId, isL1SafeMasterCopy = false) {
    const version = config_1.safeDeploymentsVersions[safeVersion].safeMasterCopyVersion;
    const filters = { version, network: chainId.toString(), released: true };
    if (config_1.safeDeploymentsL1ChainIds.includes(chainId) || isL1SafeMasterCopy) {
        return (0, safe_deployments_1.getSafeSingletonDeployment)(filters);
    }
    return (0, safe_deployments_1.getSafeL2SingletonDeployment)(filters);
}
exports.getSafeContractDeployment = getSafeContractDeployment;
function getMultiSendContractDeployment(safeVersion, chainId) {
    const version = config_1.safeDeploymentsVersions[safeVersion].multiSendVersion;
    return (0, safe_deployments_1.getMultiSendDeployment)({ version, network: chainId.toString(), released: true });
}
exports.getMultiSendContractDeployment = getMultiSendContractDeployment;
function getSafeProxyFactoryContractDeployment(safeVersion, chainId) {
    const version = config_1.safeDeploymentsVersions[safeVersion].safeProxyFactoryVersion;
    return (0, safe_deployments_1.getProxyFactoryDeployment)({ version, network: chainId.toString(), released: true });
}
exports.getSafeProxyFactoryContractDeployment = getSafeProxyFactoryContractDeployment;
async function getSafeContract({ ethAdapter, safeVersion, chainId, customSafeAddress, isL1SafeMasterCopy, customContracts }) {
    const singletonDeployment = getSafeContractDeployment(safeVersion, chainId, isL1SafeMasterCopy);
    const gnosisSafeContract = ethAdapter.getSafeContract({
        safeVersion,
        chainId,
        singletonDeployment,
        customContractAddress: customSafeAddress !== null && customSafeAddress !== void 0 ? customSafeAddress : customContracts === null || customContracts === void 0 ? void 0 : customContracts.safeMasterCopyAddress,
        customContractAbi: customContracts === null || customContracts === void 0 ? void 0 : customContracts.safeMasterCopyAbi
    });
    const isContractDeployed = await ethAdapter.isContractDeployed(gnosisSafeContract.getAddress());
    if (!isContractDeployed) {
        throw new Error('Safe Proxy contract is not deployed on the current network');
    }
    return gnosisSafeContract;
}
exports.getSafeContract = getSafeContract;
async function getProxyFactoryContract({ ethAdapter, safeVersion, chainId, customContracts }) {
    const proxyFactoryDeployment = getSafeProxyFactoryContractDeployment(safeVersion, chainId);
    const safeProxyFactoryContract = await ethAdapter.getSafeProxyFactoryContract({
        safeVersion,
        chainId,
        singletonDeployment: proxyFactoryDeployment,
        customContractAddress: customContracts === null || customContracts === void 0 ? void 0 : customContracts.safeProxyFactoryAddress,
        customContractAbi: customContracts === null || customContracts === void 0 ? void 0 : customContracts.safeProxyFactoryAbi
    });
    const isContractDeployed = await ethAdapter.isContractDeployed(safeProxyFactoryContract.getAddress());
    if (!isContractDeployed) {
        throw new Error('Safe Proxy Factory contract is not deployed on the current network');
    }
    return safeProxyFactoryContract;
}
exports.getProxyFactoryContract = getProxyFactoryContract;
async function getMultiSendContract({ ethAdapter, safeVersion, chainId, customContracts }) {
    const multiSendDeployment = getMultiSendContractDeployment(safeVersion, chainId);
    const multiSendContract = await ethAdapter.getMultiSendContract({
        safeVersion,
        chainId,
        singletonDeployment: multiSendDeployment,
        customContractAddress: customContracts === null || customContracts === void 0 ? void 0 : customContracts.multiSendAddress,
        customContractAbi: customContracts === null || customContracts === void 0 ? void 0 : customContracts.multiSendAbi
    });
    const isContractDeployed = await ethAdapter.isContractDeployed(multiSendContract.getAddress());
    if (!isContractDeployed) {
        throw new Error('Multi Send contract is not deployed on the current network');
    }
    return multiSendContract;
}
exports.getMultiSendContract = getMultiSendContract;
//# sourceMappingURL=safeDeploymentContracts.js.map