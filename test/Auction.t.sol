// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Auction.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";


contract nestNFT is ERC721("TESTNFT", "TNF") {
    constructor(){
    _mint(address(0x01), 9);
    }
}

 contract AuctionTest is Test {

    NFT_Auction public auction;
    nestNFT public testNFT;
    function setUp() public {
        testNFT = new nestNFT();
        auction = new NFT_Auction(address(0x01), address(testNFT), 9);
        vm.prank(address(0x01));
        testNFT.approve(address(auction),9);

    }

    function testStart() public{
        vm.prank(address(0x01));
        auction.start(100);
    }

    function placeBid (address bidder, uint bid) internal{
       vm.deal(bidder, bid);
       vm.prank(bidder);
       auction.placeBid{value: bid}();

    }

    function testPlaceBid() public {
       testStart();
       placeBid(address(0x02), 200);
       placeBid(address(0x03), 300);
       placeBid(address(0x04), 400);

    }

    function testWithdrawBid() public {
        testPlaceBid();
        vm.prank(address(0x03));
        auction.withdrawBid();
    }

    function testEndAuction() public {
        testPlaceBid();
        vm.warp(8 days);
        auction.endAuction();
    }
 }