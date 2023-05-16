import { MetaTransactionData, SafeTransactionDataPartial } from '@gnosis.pm/safe-core-sdk-types';
export declare function sameString(str1: string, str2: string): boolean;
export declare function isRestrictedAddress(address: string): boolean;
export declare function isMetaTransactionArray(safeTransactions: SafeTransactionDataPartial | MetaTransactionData[]): safeTransactions is MetaTransactionData[];
