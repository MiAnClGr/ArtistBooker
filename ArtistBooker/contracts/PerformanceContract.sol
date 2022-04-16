// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract PerformanceContract {

    // start a contract with venue that with an agreed upon payment, to be paid at a particular time (after performance)
    // variable - payment, time of payment

    // uint public payment;
    // uint public performanceTime;

    uint payment;
    uint time;
    bool agreed;
    
    string venueName;
    string artistName;
    State currentState;
    bool depositPaid;
    uint agreementTime;

    address owner;

    bool public hasArtistAgreed;
    bool public hasVenueAgreed;
    
    address payable public artist;
    address public venue; 

    
    enum State {notCompleted, bookingComplete, performanceCompleted, paymentComplete} // need to fix

    //mapping(uint => Gig) public Gigs;
    uint public gigNumber = 0;

       
   
    event bookingMade (uint _payment, uint _time, string _venueName);
    event bookingFeePaid (bool _depositPaid);

    

   

    constructor(address payable _artist, address _venue) {
        msg.sender == owner;
        venue = _venue;
        artist = _artist;


    }
        


    modifier onlyVenue() {
        require(msg.sender == venue);
        _;
    }


    modifier onlyArtist() {
        require(msg.sender == artist);
        _;
    }

 

    function bookingRequest(uint _payment, uint _time, string memory _venueName) onlyVenue public {
    
        payment = _payment;
        time = block.timestamp + _time;
        venueName = _venueName;
        
        
    }

  
    function payBookingDeposit() onlyVenue public payable {
        
        require(block.timestamp < (agreementTime + 86400)); // 24 hours to pay 
        require(msg.sender == venue);
        require(msg.value == payment);
       // require(currentState == State.notCompleted);
        require(agreed == true);
        depositPaid = true;
        emit bookingFeePaid(true);    
    }


    function agreement() onlyArtist public {
        
        //require(msg.sender == ArtistsbyAddress[artistName]);
        agreed = true;
        agreementTime = block.timestamp;

        if(agreed && hasVenueAgreed) {
            currentState = State.bookingComplete;
        }
    }


    function confirmPerformance() public {
        
        require(msg.sender == venue);
        require(block.timestamp > time);
        require(depositPaid == true);
        require(currentState == State.bookingComplete);
        currentState = State.performanceCompleted;
        
    }


    function beenPaid() public view returns(bool) {
        
        //require(msg.sender == ArtistsbyAddress[artistName]);
        if(depositPaid == true){
            return true;
        }
        
        else {
            return false;
        }
            
        
    }

    function withdraw() onlyArtist public payable {

       
        //require(msg.sender == ArtistsbyAddress[artistName]);
        require(depositPaid == true);
        require(block.timestamp >= time);
        require(currentState == State.performanceCompleted);
        payable(msg.sender).transfer(payment);
       
        
    }

    function checkBalance() public view returns(uint) {
        return address(this).balance;
    }




}