import { EthAdapter, GnosisSafeContract, OperationType } from '@gnosis.pm/safe-core-sdk-types';
export declare function estimateTxGas(safeContract: GnosisSafeContract, ethAdapter: EthAdapter, to: string, valueInWei: string, data: string, operation: OperationType): Promise<number>;
