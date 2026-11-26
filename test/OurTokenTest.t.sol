// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Test} from "forge-std/Test.sol";
import {OurToken} from "../src/OurToken.sol";
import {DeployOurToken} from  "../script/DeployOurToken.s.sol";

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer; 

    address Bill = makeAddr("Bill");
    address David = makeAddr("David");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(msg.sender);
        ourToken.transfer(Bill,STARTING_BALANCE);
    }

    function testBillsBalance() public view {
        assertEq(STARTING_BALANCE, ourToken.balanceOf(Bill));
    }

    function testAllowanceWorks() public {
        uint256 initialAllowance = 1000;

        vm.prank(Bill);
        ourToken.approve(David, initialAllowance); 

        uint256 transferAmount = 500;

        vm.prank(David);
        ourToken.transferFrom(Bill, David, transferAmount);

        assertEq(ourToken.balanceOf(David),transferAmount);
        assertEq(ourToken.balanceOf(Bill), STARTING_BALANCE - transferAmount);

    }
}