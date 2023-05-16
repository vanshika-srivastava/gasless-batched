import { SafeVersion } from '@gnosis.pm/safe-core-sdk-types';
export declare const SAFE_LAST_VERSION: SafeVersion;
export declare const SAFE_BASE_VERSION: SafeVersion;
declare type SafeDeploymentsVersions = {
    [version: string]: {
        safeMasterCopyVersion: string;
        safeMasterCopyL2Version: string | undefined;
        safeProxyFactoryVersion: string;
        multiSendVersion: string;
    };
};
export declare const safeDeploymentsVersions: SafeDeploymentsVersions;
export declare const safeDeploymentsL1ChainIds: number[];
export {};
