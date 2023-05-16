import { Signer } from "ethers";
import { Provider } from "@ethersproject/providers";
import type { IERC777Recipient, IERC777RecipientInterface } from "../IERC777Recipient";
export declare class IERC777Recipient__factory {
    static readonly abi: {
        inputs: {
            internalType: string;
            name: string;
            type: string;
        }[];
        name: string;
        outputs: never[];
        stateMutability: string;
        type: string;
    }[];
    static createInterface(): IERC777RecipientInterface;
    static connect(address: string, signerOrProvider: Signer | Provider): IERC777Recipient;
}
