// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import {ERC20} from "../src/ERC20.sol";
import {SlashingEngine} from "../src/SlashingEngine.sol";

// TODO: learn how to test properly in foundry :')

contract SlashingEngineTest is Test {
    using stdStorage for StdStorage;

    ERC20 public gtc;
    SlashingEngine public slashingEngine;
    uint256 public constant STAKE_AMOUNT = 100e18;
    address public constant GUARDIAN_1 = address(0x1111111111111111111111111111111111111111);
    address public constant GUARDIAN_2 = address(0x2222222222222222222222222222222222222222);
    address public constant GUARDIAN_3 = address(0x3333333333333333333333333333333333333333);

    event GuardianStaked(address indexed guardian, uint256 indexed amount, uint16 indexed newRank);

    function setUp() public {
        // using a new GTC contract, because I was struggling with deal on a mainnet fork
        gtc = new ERC20("Gitcoin", "GTC", 18);
        deal(address(gtc), address(this), 10000e18, true);
        // gtc, passport, dao
        slashingEngine = new SlashingEngine(
            address(gtc), 
            0x0E3efD5BE54CC0f4C64e0D186b0af4b7F2A0e95F, 
            0x57a8865cfB1eCEf7253c27da6B4BC3dAEE5Be518
        );
    }

    function test_stake() public {        
        uint256 initialBalance = gtc.balanceOf(address(this));
        assertEq(initialBalance, 10000e18, "Incorrect initial balance");
        // Approve the slashingEngine contract to spend our GTC
        gtc.approve(address(slashingEngine), STAKE_AMOUNT);
        // Now we can stake
        slashingEngine.stake(STAKE_AMOUNT);
        assertEq(gtc.balanceOf(address(slashingEngine)), STAKE_AMOUNT);
        stdstore
            .target(address(slashingEngine))
            .sig("guardians(address)")
            .with_key(address(this))
            .depth(4);
        //assertEq(stakedAmount, STAKE_AMOUNT);
    }

    function test_unstake() public {

    }

    function test_flagSybilAccounts() public {

    }

    function test_unstakedFlaggedAccounts() public {
        
    }
}

