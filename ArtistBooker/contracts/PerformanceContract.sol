// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract PerformanceContract {

    // start a contract with venue that with an agreed upon payment, to be paid at a particular time (after performance)
    // variable - payment, time of payment

    // uint public payment;
    // uint public performanceTime;

    uint payment;
    uint time;
    bool public agreed;
    
    string venueName;
    string artistName;
    State public currentState;
    bool public depositPaid;
    uint agreementTime;
    bool public performanceTimePassed;

    address owner;

    bool public hasArtistAgreed;
    
    
    address payable public artist;
    address public venue; 

    
    enum State {notCompleted, bookingComplete, performanceCompleted, paymentComplete} // need to fix

    //mapping(uint => Gig) public Gigs;
    uint public gigNumber = 0;

       
   
    event bookingMade (uint _payment, uint _time, string _venueName);
    event bookingFeePaid (bool _depositPaid);

    

   

    constructor(address _owner, address payable _artist, address _venue, string memory _venueName, uint _payment, uint _time) {
        msg.sender == owner;
        venue = _venue;
        artist = _artist;
        payment = _payment;
        time = _time;
        venueName = _venueName;
        owner = _owner;


    }
        


    modifier onlyVenue() {
        require(msg.sender == venue);
        _;
    }


    modifier onlyArtist() {
        require(msg.sender == artist);
        _;
    }

    modifier onlyOwner() {  
        require(msg.sender == owner);
        _;
    }


  
    function payBookingDeposit() onlyVenue public payable {
        
        require(block.timestamp < (agreementTime + 86400)); // 24 hours to pay 
        require(msg.sender == venue);
        require(msg.value == payment / 2);
        require(agreed == true);
        depositPaid = true;
        emit bookingFeePaid(true);    
    }


    function agreement() onlyOwner public {
        
        agreed = true;
        agreementTime = block.timestamp;

        if(agreed) {
            currentState = State.bookingComplete;
        }
    }

    function hasPerformanceTimePassed() public returns(bool){
        if(block.timestamp > time){
            performanceTimePassed = true;
            return true;
        }else{
            return false;
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

    function getPaid() onlyOwner public payable {

        require(depositPaid == true);
        require(block.timestamp >= time);
        require(currentState == State.performanceCompleted);
        payable(artist).transfer(address(this).balance);
       
        
    }

    function checkBalance() public view returns(uint) {
        return address(this).balance;
    }




}
