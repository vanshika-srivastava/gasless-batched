// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract NFTContract is ERC721, ERC721Enumerable, ERC721URIStorage {
    using Counters for Counters.Counter;
    using Strings for uint256;

    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("NFTContract", "MTK") {}

    function generateSVG(uint256 tokenId) public pure returns (string memory) {
        bytes memory svg = abi.encodePacked(

'<svg xmlns="http://www.w3.org/2000/svg" width="624" height="625" viewBox="0 0 624 625" fill="none">''<g id="Biconomy_NFT">'
'<rect width="624" height="624" transform="translate(0 0.5)" fill="#FF4E17"/>'
'<rect id="Rectangle 349" x="16.127" y="20.4658" width="591.746" height="584.068" rx="30" fill="#1D1D1D" stroke="white" stroke-width="2"/>'
'<path id="Rectangle 311" d="M117 509L117 178C117 165.297 127.297 155 140 155L470 155C482.703 155 493 165.297 493 178L493 509C493 521.703 482.703 532 470 532L140 532C127.297 532 117 521.703 117 509Z" fill="#D9D9D9" fill-opacity="0.81" stroke="white" stroke-width="2"/>'
'<g id="Mask group">'
'<mask id="mask0_1577_6136" style="mask-type:alpha" maskUnits="userSpaceOnUse" x="183" y="289" width="391" height="278">'
'<path id="Rectangle 312" d="M207 565.736C194.297 565.736 184 555.439 184 542.736L184 313C184 300.297 194.297 290 207 290L549.899 290C562.602 290 572.899 300.297 572.899 313L572.899 542.736C572.899 555.439 562.602 565.736 549.899 565.736L207 565.736Z" fill="#D9D9D9" stroke="white" stroke-width="2"/>'
'</mask>'
'<g mask="url(#mask0_1577_6136)">''<g id="Group 8816">''<g id="Group 8813">''<g id="Group">'
'<path id="Vector" d="M571.619 532.768L582.79 529.216L586.958 590.785L506.821 553.406L571.619 532.768Z" fill="#FF4E17"/>'
'<path id="Vector_2" d="M477.332 634.92L506.82 553.407L586.957 590.786L477.92 668.101L467.314 662.619L477.332 634.92Z" fill="#FF4E17"/>'
'<path id="Vector_3" d="M396.131 427.337L339.873 557.599L338.172 463.545L396.131 427.337Z" fill="#FF4E17"/>'
'<path id="Vector_4" d="M463.932 523.147L496.292 539.873L459.396 654.474L351.189 598.547L463.932 523.147Z" fill="#FF4E17"/>'
'<path id="Vector_5" d="M456.797 387.131L463.931 523.147L351.187 598.547L348.92 559.563L353.006 549.507L399.976 433.955L404.71 422.322L456.797 387.131Z" fill="#FF4E17"/>'
'<path id="Vector_6" d="M456.795 387.131L577.195 449.361L581.258 521.677L496.288 539.872L463.929 523.147L456.795 387.131Z" fill="#FF4E17"/>'
'<path id="Vector_7" d="M496.292 539.873L581.261 521.678L571.618 532.769L506.82 553.407L477.332 634.921L459.396 654.475L496.292 539.873Z" fill="black"/>'
'<path id="Vector_8" d="M396.134 427.335L398.998 433.545L399.978 433.955L353.008 549.507L352.761 549.403L339.875 557.597L396.134 427.335Z" fill="black"/>'
'</g>''<g id="Group_2">'
'<path id="Vector_9" d="M351.189 598.547L459.396 654.474L496.292 539.873L463.932 523.147L351.189 598.547Z" stroke="white" stroke-width="2" stroke-miterlimit="10"/>'
'<path id="Vector_10" d="M351.187 598.547L348.92 559.563L353.006 549.507L399.976 433.955L404.71 422.322L456.797 387.131L463.931 523.147" stroke="white" stroke-width="2" stroke-miterlimit="10"/>'
'<path id="Vector_11" d="M496.288 539.872L581.258 521.677L577.195 449.361L456.795 387.131" stroke="white" stroke-width="2" stroke-miterlimit="10"/>'
'<path id="Vector_12" d="M396.131 427.337L338.172 463.545L339.873 557.599L396.131 427.337Z" stroke="white" stroke-width="2" stroke-miterlimit="10"/>'
'<path id="Vector_15" d="M477.332 634.92L467.314 662.619L477.92 668.101L586.957 590.786L582.79 529.217L571.619 532.769L506.82 553.407L477.332 634.92Z" stroke="white" stroke-width="2" stroke-miterlimit="10"/>'
'</g></g></g></g></g></g>'
'<style>.base { fill: black; font-family: Gill Sans; font-size: 30px; }</style>'
'<style>.base2 { fill: white; font-family: Gill Sans; font-size: 60px; }</style>'
'<text x="50%" y="15%" class="base2" dominant-baseline="middle" text-anchor="middle">',"BICONOMY", '</text>'
'<text x="50%" y="45%" class="base" dominant-baseline="middle" text-anchor="middle">',"NFT Minted with", '</text>'
'<text x="50%" y="58%" class="base" dominant-baseline="middle" text-anchor="middle">'," TokenID # ", getNFTID(tokenId) , '</text>'
'</svg>'

        );

        return string(abi.encodePacked("data:image/svg+xml;base64,", Base64.encode(svg)));
    }

    function getNFTID(uint256 tokenId) public pure returns (string memory) {
        return tokenId.toString();
    }

    function getTokenURI(uint256 tokenId) public pure returns (string memory) {
       bytes memory dataURI = abi.encodePacked(
            '{',
                '"name": "B-NFT #', tokenId.toString(), '",',
                '"description": "Gasless NFT Minted With Biconomy SDK",',
                '"image": "', generateSVG(tokenId), '"',
            '}'
        );

        return string(abi.encodePacked("data:application/json;base64,", Base64.encode(dataURI)));
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
        for (uint256 i = 0; i < balanceOf(msg.sender); i++) {
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
   override(ERC721, ERC721Enumerable, ERC721URIStorage)
   returns (bool)
 {
   return super.supportsInterface(interfaceId);
 }
}

