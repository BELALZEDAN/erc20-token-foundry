// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

interface MintableToken {
    function mint(address, uint256) external;
}

contract OurTokenTest is StdCheats, Test {
    OurToken public ourToken;
    DeployOurToken public deployer;
    address public user1 = address(0x1);
    address public user2 = address(0x2);

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        // Give some tokens to user1 for testing
        vm.prank(msg.sender); // deployer has INITIAL_SUPPLY
        ourToken.transfer(user1, 100 ether);
    }

    function testInitialSupply() public {
        assertEq(ourToken.totalSupply(), deployer.INITIAL_SUPPLY());
    }

    function testUsersCantMint() public {
        vm.expectRevert();
        MintableToken(address(ourToken)).mint(address(this), 1);
    }

    // -------- Transfers --------
    function testTransferUpdatesBalances() public {
        vm.prank(user1);
        ourToken.transfer(user2, 50 ether);

        assertEq(ourToken.balanceOf(user1), 50 ether);
        assertEq(ourToken.balanceOf(user2), 50 ether);
    }

    function testTransferFailsIfInsufficientBalance() public {
        vm.prank(user2); // user2 has 0
        vm.expectRevert();
        ourToken.transfer(user1, 1 ether);
    }

    function testTransferEmitsEvent() public {
        vm.prank(user1);
        vm.expectEmit(true, true, false, true);
        emit Transfer(user1, user2, 10 ether);
        ourToken.transfer(user2, 10 ether);
    }

    // -------- Allowances --------
    function testApproveAndAllowance() public {
        vm.prank(user1);
        ourToken.approve(user2, 25 ether);

        assertEq(ourToken.allowance(user1, user2), 25 ether);
    }

    function testTransferFromWorksWithinAllowance() public {
        vm.startPrank(user1);
        ourToken.approve(user2, 25 ether);
        vm.stopPrank();

        vm.prank(user2);
        ourToken.transferFrom(user1, user2, 20 ether);

        assertEq(ourToken.balanceOf(user1), 80 ether);
        assertEq(ourToken.balanceOf(user2), 20 ether);
        assertEq(ourToken.allowance(user1, user2), 5 ether); // 25 - 20
    }

    function testTransferFromFailsWithoutAllowance() public {
        vm.prank(user2);
        vm.expectRevert();
        ourToken.transferFrom(user1, user2, 10 ether);
    }

    function testTransferFromFailsIfExceedsAllowance() public {
        vm.prank(user1);
        ourToken.approve(user2, 10 ether);

        vm.prank(user2);
        vm.expectRevert();
        ourToken.transferFrom(user1, user2, 20 ether);
    }

    // -------- Edge Cases --------
    function testTransferToZeroAddressReverts() public {
        vm.prank(user1);
        vm.expectRevert();
        ourToken.transfer(address(0), 1 ether);
    }

    function testApproveEmitsEvent() public {
        vm.prank(user1);
        vm.expectEmit(true, true, false, true);
        emit Approval(user1, user2, 15 ether);
        ourToken.approve(user2, 15 ether);
    }

    // -------- Events --------
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
