// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC721 {
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
    function ownerOf(uint256 tokenId) external view returns (address);
}

contract CryptoTreasureNFT {
    address public owner;
    uint256 public unlockTime = 1750118400;
    bytes32 public puzzleHash = 0xc533f825a4bd4a4d0c44ec8724bf12482eb4f4b2e5a0ea4b033bbef971a4d5f3;
    bool public claimed = false;

    address public nftAddress = 0x930150F7a72F95D5bE2C7357d0d9F0629AB6553B;
    uint256 public nftTokenId = 12;

    constructor() {
        owner = msg.sender;
    }

    function claim(string memory _answer) public {
        require(block.timestamp >= unlockTime, "Aún no se puede desbloquear.");
        require(!claimed, "Ya ha sido reclamado.");
        require(keccak256(abi.encodePacked(_answer)) == puzzleHash, "Respuesta incorrecta.");
        require(IERC721(nftAddress).ownerOf(nftTokenId) == address(this), "El contrato no tiene el NFT.");

        claimed = true;
        IERC721(nftAddress).safeTransferFrom(address(this), msg.sender, nftTokenId);
    }
}
