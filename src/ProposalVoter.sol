// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

/**
 * @title ProposalVoter
 * @dev A contract for creating and voting on proposals
 */
contract ProposalVoter {
    struct Proposal {
        string title;
        string description;
        uint256 yesVotes;
        uint256 noVotes;
    }
    mapping(address => mapping(uint256 => bool)) public hasVoted;

    Proposal[] public proposals;

    event ProposalCreated(string title, string description);
    event VoteCast(address voter, uint256 proposalId, bool vote);

    /**
     * @dev Create a new proposal
     * @param _title The title of the proposal
     * @param _description The description of the proposal
     */
    function createProposal(
        string memory _title,
        string memory _description
    ) public {
        Proposal memory newProposal = Proposal({
            title: _title,
            description: _description,
            yesVotes: 0,
            noVotes: 0
        });

        proposals.push(newProposal);

        emit ProposalCreated(_title, _description);
    }

    /**
     * @dev Read all proposals
     * @return An array of all proposals
     */
    function readProposals() public view returns (Proposal[] memory) {
        return proposals;
    }

    /**
     * @dev Get the number of proposals
     * @return The number of proposals
     */
    function getProposalsCount() public view returns (uint256) {
        return proposals.length;
    }

    /**
     * @dev Vote on a proposal
     * @param _proposalId The ID of the proposal
     * @param _voteYes Whether to vote "yes" or "no"
     */
    function vote(uint256 _proposalId, bool _voteYes) public {
        require(_proposalId < proposals.length, "Invalid proposal ID");
        require(
            !hasVoted[msg.sender][_proposalId],
            "You have already voted on this proposal"
        );

        if (_voteYes) {
            proposals[_proposalId].yesVotes++;
        } else {
            proposals[_proposalId].noVotes++;
        }

        hasVoted[msg.sender][_proposalId] = true;

        emit VoteCast(msg.sender, _proposalId, _voteYes);
    }
}
