// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract VotingContract {
    address public owner;
    uint256 votings_counter;

    mapping(uint256 => Voting) private votings;

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not an owner");
        _;
    }

    struct Candidate {
        uint256 balance;
        bool isExistOnThisVoting;
    }

    struct Voting {
        bool started;
        address winner;
        uint256 start;
        uint256 bank;
        uint256 period;
        uint256 winner_balance;
        mapping(address => Candidate) candidates;
    }

    function addCandidate(uint256 _votingID, address _candidate)
        public
        onlyOwner
    {
        require(
            votings[_votingID].started == false,
            "Voting has already begun!"
        );
        votings[_votingID].candidates[_candidate].isExistOnThisVoting = true;
    }

    function createVoting(address[] calldata _candidates, uint256 _period)
        external
        onlyOwner
    {
        votings[votings_counter].period = _period;

        for (uint256 i = 0; i < _candidates.length; i++) {
            addCandidate(votings_counter, _candidates[i]);
        }
    }

    function deleteCandidate(uint256 _votingID, address _candidate)
        public
        onlyOwner
    {
        require(
            votings[_votingID].started == false,
            "Voting has already begun!"
        );
        votings[_votingID].candidates[_candidate].isExistOnThisVoting = false;
    }

    function editVotingPeriod(uint256 _votingID, uint256 _newPeriod)
        public
        onlyOwner
    {
        require(
            votings[_votingID].started == false,
            "Voting has already begun!"
        );
        votings[_votingID].period = _newPeriod;
    }

    function startVoting(uint256 _votingID) public onlyOwner {
        votings[_votingID].started = true;
        votings[_votingID].start = block.timestamp;
    }

    function checkCandidate(uint256 _votingID, address _candidate)
        public
        view
        returns (bool)
    {
        return (votings[_votingID].candidates[_candidate].isExistOnThisVoting);
    }

    function getVotingInfo(uint256 _votingID)
        public
        view
        returns (
            bool,
            uint256,
            uint256,
            uint256,
            uint256,
            address
        )
    {
        return (
            votings[_votingID].started,
            votings[_votingID].start,
            votings[_votingID].period,
            votings[_votingID].winner_balance,
            votings[_votingID].bank,
            votings[_votingID].winner
        );
    }

}
