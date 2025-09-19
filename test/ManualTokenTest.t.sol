// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {ManualToken} from "../src/ManualToken.sol";

contract ManualTokenTest is Test {
    ManualToken manual;

    address user1 = address(1);
    address user2 = address(2);

    function setUp() public {
        manual = new ManualToken();
    }

    function testNameAndDecimals() public {
        assertEq(manual.name(), "Manual Token");
        assertEq(manual.decimals(), 18);
    }

    function testTotalSupplyConstant() public {
        assertEq(manual.totalSupply(), 100 ether);
    }

    function testTransferUpdatesBalances() public {
        // give user1 some tokens manually (since ManualToken doesn't mint)
        vm.store(address(manual), keccak256(abi.encode(user1, uint256(0))), bytes32(uint256(100 ether)));

        vm.prank(user1);
        manual.transfer(user2, 40 ether);

        assertEq(manual.balanceOf(user1), 60 ether);
        assertEq(manual.balanceOf(user2), 40 ether);
    }

    function testTransferRevertsIfNotEnough() public {
        vm.prank(user1);
        vm.expectRevert();
        manual.transfer(user2, 1 ether);
    }
}
