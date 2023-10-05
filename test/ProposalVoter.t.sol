// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import {Test} from "forge-std/Test.sol";
import {ProposalVoter} from "../src/ProposalVoter.sol";

contract TestProposalContract is Test {
    ProposalVoter proposalVoter;

    function setUp() public {
        proposalVoter = new ProposalVoter();
    }

    function testCreateProposal() public {
        // Test initial state
        assertEq(proposalVoter.getProposalsCount(), 0);

        // Create a proposal
        proposalVoter.createProposal(
            "Proposal 1",
            "Description for proposal 1"
        );

        // Check that the proposal was added
        string memory title;
        string memory description;
        uint256 yesVotes;
        uint256 noVotes;
        assertEq(proposalVoter.getProposalsCount(), 1);
        (title, description, yesVotes, noVotes) = proposalVoter.proposals(0);
        assertEq(title, "Proposal 1");
        assertEq(description, "Description for proposal 1");
        assertEq(yesVotes, 0);
        assertEq(noVotes, 0);
    }

    function testVote() public {
        string memory title;
        string memory description;
        uint256 yesVotes;
        uint256 noVotes;

        // Create a proposal
        proposalVoter.createProposal(
            "Proposal 1",
            "Description for proposal 1"
        );

        // Vote "yes" on the proposal
        proposalVoter.vote(0, true);

        // Check that the vote was counted
        (title, description, yesVotes, noVotes) = proposalVoter.proposals(0);
        assertEq(yesVotes, 1);
        assertEq(noVotes, 0);
        assertTrue(
            proposalVoter.hasVoted(address(this), 0),
            "User hasn't voted"
        );
    }

    function testCantVoteTwice() public {
        // Create a proposal
        proposalVoter.createProposal(
            "Proposal 1",
            "Description for proposal 1"
        );

        // Vote "yes" on the proposal
        proposalVoter.vote(0, true);

        // Try to vote again and catch the failure
        (bool success, ) = address(proposalVoter).call(
            abi.encodePacked(proposalVoter.vote.selector, abi.encode(0, true))
        );
        assertFalse(success);
    }
}
