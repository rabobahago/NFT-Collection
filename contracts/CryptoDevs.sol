// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "./IWhitelist.sol";

contract CryptoDevs is Ownable, ERC721Enumerable {
    string _baseTokenURI;

    //price of one crypto dev
    uint256 public _price = 0.001 ether;

    //pause the contract in case of emergency
    bool public _pause;

    // max number of cryptoDevs yet to be mint
    uint256 public maxTokenIds = 20;
    //total number of tokenIds minted;
    uint256 public tokenIds;
    //whitelist contract instance
    IWhitelist whitelist;
    //boolean to keep track of whether presale start or not
    bool public presaleStart;

    //timestamp for when presale will Ended
}
