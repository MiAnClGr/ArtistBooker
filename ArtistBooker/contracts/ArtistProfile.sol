// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./PerformanceContract.sol";

contract ArtistProfile {

    string public artistName;
    address payable artistAddress;

    PerformanceContract[] public performanceContractArray;
    
    constructor(string memory _artistName) {
        artistName = _artistName;
        artistAddress = payable(msg.sender);
    }

    function createPerformanceContract(address venue) public {
        PerformanceContract performanceContract = new PerformanceContract(artistAddress, venue);
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
}