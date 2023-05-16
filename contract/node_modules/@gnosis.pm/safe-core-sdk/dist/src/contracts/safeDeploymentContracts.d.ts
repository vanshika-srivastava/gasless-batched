import { EthAdapter, GnosisSafeContract, GnosisSafeProxyFactoryContract, MultiSendContract, SafeVersion } from '@gnosis.pm/safe-core-sdk-types';
import { SingletonDeployment } from '@gnosis.pm/safe-deployments';
import { ContractNetworkConfig } from '../types';
interface GetContractInstanceProps {
    ethAdapter: EthAdapter;
    safeVersion: SafeVersion;
    chainId: number;
    customContracts?: ContractNetworkConfig;
}
interface GetSafeContractInstanceProps extends GetContractInstanceProps {
    isL1SafeMasterCopy?: boolean;
    customSafeAddress?: string;
}
export declare function getSafeContractDeployment(safeVersion: SafeVersion, chainId: number, isL1SafeMasterCopy?: boolean): SingletonDeployment | undefined;
export declare function getMultiSendContractDeployment(safeVersion: SafeVersion, chainId: number): SingletonDeployment | undefined;
export declare function getSafeProxyFactoryContractDeployment(safeVersion: SafeVersion, chainId: number): SingletonDeployment | undefined;
export declare function getSafeContract({ ethAdapter, safeVersion, chainId, customSafeAddress, isL1SafeMasterCopy, customContracts }: GetSafeContractInstanceProps): Promise<GnosisSafeContract>;
export declare function getProxyFactoryContract({ ethAdapter, safeVersion, chainId, customContracts }: GetContractInstanceProps): Promise<GnosisSafeProxyFactoryContract>;
export declare function getMultiSendContract({ ethAdapter, safeVersion, chainId, customContracts }: GetContractInstanceProps): Promise<MultiSendContract>;
export {};
