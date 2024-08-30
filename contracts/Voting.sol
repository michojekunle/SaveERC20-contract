// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

// Voting contract Challenge within an hour from scratch
contract Voting {
    address private owner;
    uint8 private candidateId = 1;
    bool voteEnded;

    constructor() {
        owner = msg.sender;
    }

    struct Candidate {
        uint8 id;
        uint32 noOfVotes;
        string name;
    }

    struct Voter {
        string name;
        address voter_address;
        bool voted;
    }

    mapping(address => Candidate) private votes;
    mapping(uint8 => Candidate) public candidates;
    mapping(address => Voter) private voters;

    // errors
    error CustomErrorMessage(string error_message);

    // events
    event CandidateRegistered();
    event VoterRegistered();
    event Voted();
    event VoteEnded();

    // modifiers
    // onlyOwner & sanity check
    modifier onlyOwner() {
        if (msg.sender == address(0))
            revert CustomErrorMessage("zero address detected");

        if (msg.sender != owner)
            revert CustomErrorMessage("You're not the owner");
        _;
    }

    // vote ended
    modifier isVoteEnded() {
        if (voteEnded) revert CustomErrorMessage("Error, Vote Ended Already");
        _;
    }

    // Functions
    function registerCandidate(
        string memory _name
    ) external onlyOwner isVoteEnded {
        candidates[candidateId] = Candidate(candidateId, 0, _name);
        candidateId = candidateId + 1;

        emit CandidateRegistered();
    }

    function registerVoter(
        address _voterAddress,
        string memory _name
    ) external onlyOwner isVoteEnded {
        if (_voterAddress == address(0))
            revert CustomErrorMessage("Cannot register, Zero address detected");

        if (voters[_voterAddress].voter_address == _voterAddress)
            revert CustomErrorMessage("Voter already registered");

        if (_voterAddress == owner)
            revert CustomErrorMessage("Owner cannot register as a voter");

        voters[_voterAddress] = Voter(_name, _voterAddress, false);

        emit VoterRegistered();
    }

    function vote(uint8 _candidateId) external isVoteEnded {
        if (voters[msg.sender].voter_address == address(0))
            revert CustomErrorMessage("Voter is not registered");

        if (voters[msg.sender].voted)
            revert CustomErrorMessage(
                "each registered voter can only vote once"
            );

        if (msg.sender == owner) revert CustomErrorMessage("Owner cannot vote");

        Candidate memory candidate = candidates[_candidateId];

        votes[msg.sender] = candidate;
        candidate.noOfVotes = candidate.noOfVotes + 1;
        voters[msg.sender].voted = true;

        emit Voted();
    }

    function getLeadingCandidate()
        external
        view
        isVoteEnded
        returns (Candidate memory candidate_)
    {
        if (msg.sender == address(0))
            revert CustomErrorMessage("zero address detected");

        if (candidates[1].id < 1)
            revert CustomErrorMessage("No votes casted yet");

        Candidate storage _candidate = candidates[1];

        for (uint8 i = 1; i <= candidateId; i++) {
            if (candidates[i].noOfVotes > _candidate.noOfVotes)
                _candidate = candidates[i];
        }

        candidate_ = _candidate;
    }

    function getVotes() external view returns (uint32 vote_) {
        if (msg.sender == address(0))
            revert CustomErrorMessage("zero address detected");

        if (candidates[1].id < 1)
            revert CustomErrorMessage("No votes casted yet");

        uint32 _votes = 0;
        for (uint8 i = 1; i <= candidateId; i++) {
            _votes = _votes + candidates[i].noOfVotes;
        }

        vote_ = _votes;
    }

    function endVote()
        external
        onlyOwner
        returns (Candidate memory candidate_)
    {
        if (msg.sender == address(0))
            revert CustomErrorMessage("zero address detected");

        if (candidates[1].id < 1)
            revert CustomErrorMessage("No votes casted yet");

        Candidate storage _candidate = candidates[1];

        for (uint8 i = 1; i <= candidateId; i++) {
            if (candidates[i].noOfVotes > _candidate.noOfVotes)
                _candidate = candidates[i];
        }

        candidate_ = _candidate;
        emit VoteEnded();
    }

    function getWinner() public view returns (Candidate memory candidate_) {
        if (msg.sender == address(0))
            revert CustomErrorMessage("zero address detected");

        if (!voteEnded) revert CustomErrorMessage("Vote is still ongoing");

        Candidate storage _candidate = candidates[1];

        for (uint8 i = 1; i <= candidateId; i++) {
            if (candidates[i].noOfVotes > _candidate.noOfVotes)
                _candidate = candidates[i];
        }

        candidate_ = _candidate;
    }
}