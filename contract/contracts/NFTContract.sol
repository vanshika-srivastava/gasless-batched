// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


contract NFTContract is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    using Strings for uint256;
    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("NFTContract", "MTK") {}


    function generateSVG(uint256 tokenId) public pure returns(string memory){
        bytes memory svg = abi.encodePacked(
             '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 250 250">',
            '<style>.base { fill: black; font-family: serif; font-size: 14px; }</style>',
            '<rect width="100%" height="100%" fill="orange" />',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',"NFT Minted for using Biconomy SDK ",'</text>',
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "with TokenID # ",getNFTID(tokenId),'</text>',
            '</svg>'
            
        );
        return string(
            abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(svg)
            ));
    }

    function getNFTID(uint256 tokenId) public pure returns (string memory) {
        return tokenId.toString();
    }

    function getTokenURI(uint256 tokenId) public pure returns (string memory){
        bytes memory dataURI = abi.encodePacked(
            '{',
                '"name": "B-NFT #', tokenId.toString(), '",',
                '"description": "Gasless NFT Minted With Biconomy SDK",',
                '"image": "', generateSVG(tokenId), '"',
            '}'
        );
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );
    }


   function mint() public {
    _tokenIdCounter.increment();
    uint256 tokenId = _tokenIdCounter.current();
    _safeMint(msg.sender, tokenId);
    _setTokenURI(tokenId, getTokenURI(tokenId));
   }

    function transferNFT(address recipient, uint256 tokenId) public {
    require(_exists(tokenId), "ERC721: token does not exist");
    require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
    require(ownerOf(tokenId) == msg.sender, "ERC721: transfer of token that is not own");
    require(recipient != address(0), "ERC721: transfer to the zero address");

    safeTransferFrom(msg.sender, recipient, tokenId);
}



    function getOwnedNFTs() public view returns (uint256[] memory) {
        uint256[] memory ownedNFTs = new uint256[](balanceOf(msg.sender));
        for (uint i = 0; i < balanceOf(msg.sender); i++) {
            ownedNFTs[i] = tokenOfOwnerByIndex(msg.sender, i);
        }
        return ownedNFTs;
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
         return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}