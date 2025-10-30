// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CharityDonation {
    address public owner;
    uint256 public totalDonations;
    mapping(address => uint256) public donations;
    mapping(address => bool) public approvedCharities;

    event DonationReceived(address indexed donor, uint256 amount);
    event CharityApproved(address indexed charity);
    event CharityRemoved(address indexed charity);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    modifier onlyApprovedCharity() {
        require(approvedCharities[msg.sender], "You are not an approved charity");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Approve a charity
    function approveCharity(address charity) external onlyOwner {
        approvedCharities[charity] = true;
        emit CharityApproved(charity);
    }

    // Remove a charity's approval
    function removeCharity(address charity) external onlyOwner {
        approvedCharities[charity] = false;
        emit CharityRemoved(charity);
    }

    // Donate to an approved charity
    function donate(address charity) external payable onlyApprovedCharity {
        require(msg.value > 0, "Donation must be greater than zero");
        donations[msg.sender] += msg.value;
        totalDonations += msg.value;
        payable(charity).transfer(msg.value);
        emit DonationReceived(msg.sender, msg.value);
    }

    // Get the total donations made by the sender
    function getDonations() external view returns (uint256) {
        return donations[msg.sender];
    }

    // Get the total funds raised
    function getTotalDonations() external view returns (uint256) {
        return totalDonations;
    }
}
