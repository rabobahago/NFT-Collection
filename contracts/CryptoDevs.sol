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
    bool public presaleStarted;

    //timestamp for when presale will End
    uint256 public presaleEnded;
    modifier onlyWhenOwnerNotPaused() {
        require(!_pause, "Contract currently paused");
        _;
    }

    //constructor which take baseURI and whitelisContract
    //ERC721 that take in the name and a symbol
    constructor(string memory baseURI, address whitelistContract)
        ERC721("Crypto Devs", "CD")
    {
        _baseTokenURI = baseURI;
        whitelist = IWhitelist(whitelistContract);
    }

    function startPresale() public onlyOwner {
        //presaleStart
        presaleStarted = true;
        //set presaleEnded at current time plus 5minutes

        // Solidity has cool syntax for timestamps (seconds, minutes, hours, days, years)
        presaleEnded = block.timestamp + 5 minutes;
    }

    /**
     * @dev presaleMint allows a user to mint one NFT per transaction during the presale.
     */
    function presaleMint() public payable onlyWhenOwnerNotPaused {
        require(
            presaleStarted && block.timestamp < presaleEnded,
            "Presale is not running"
        );
        require(
            whitelist.whitelistedAddresses(msg.sender),
            "You are not whitelisted"
        );
        require(tokenIds < maxTokenIds, "Exceeded maximum Crypto Devs supply");
        require(msg.value >= _price, "Ether sent is not correct");
        tokenIds += 1;
        //_safeMint is a safer version of the _mint function as it ensures that
        // if the address being minted to is a contract, then it knows how to deal with ERC721 tokens
        // If the address being minted to is not a contract, it works the same way as _mint
        _safeMint(msg.sender, tokenIds);
    }
}
