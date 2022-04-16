// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./PerformanceContract.sol";
import "./ArtistFactory.sol";

contract ArtistProfile {

    string public artistName;
    address payable public artistAddress;
    address public owner;
    

    PerformanceContract[] public performanceContractArray;
    
    constructor(string memory _artistName, address _owner) {
        artistName = _artistName;
        artistAddress = payable(address(this));
        owner = _owner;
    }

    modifier onlyOwner() {  
        require(msg.sender == owner);
        _;
    }

    function createPerformanceContract(address venue, string memory venueName, uint payment, uint time) public {
        PerformanceContract performanceContract = new PerformanceContract(owner, artistAddress, venue, venueName, payment, time );
        performanceContractArray.push(performanceContract);

    }

    function deposit() public payable {
        
    }

    receive() external payable {
        deposit();

    }

    function balance() public view returns(uint) {
        return address(this).balance;
    }

    function withdraw() onlyOwner public {
        payable(owner).transfer(address(this).balance);
    }
}
