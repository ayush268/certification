pragma solidity ^0.4.25;

contract CertificateManager {
    address [] public registeredCourses;
    event ContractCreated(address contractAddress);

    function createCourse(string _courseName, string _instructorName, string _studentName, string _extraMessage, uint _date) public {
        address newCourse = new Course(msg.sender, _courseName, _instructorName, _studentName,_extraMessage, _date);
        emit ContractCreated(newCourse);
        registeredCourses.push(newCourse);
    }

    function getDeployedCourses() public view returns (address[]) {
        return registeredCourses;
    }
}

contract Course {

    event courseBells(address ringer, uint256 count);

    address public owner;

    string public studentName;
    string public instructorName;
    string public courseName;
    string public extraMessage;
    uint public Date;
    
    uint256 public bellCounter;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor(address _owner, string _courseName, string _instructorName, string _studentName, string _extraMessage, uint _date) public {
        owner = _owner;
        courseName =  _courseName; 
        studentName = _studentName;
        instructorName = _instructorName;
        extraMessage = _extraMessage;
        Date = _date;
    }

    function add(uint256 a, uint256 b) private pure returns (uint256 c) {
        c = a + b;
        assert(c >= a);
        return c;
    }

    function ringBell() public payable {
        bellCounter = add(1, bellCounter);
        emit courseBells(msg.sender, bellCounter);
    }

    function collect() external onlyOwner {
        owner.transfer(address(this).balance);
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function getCourseDetails() public view returns (
        address, string, string, string, string, uint, uint256) {
        return (
            owner,
            courseName,
            studentName,
            instructorName,
            extraMessage,
            Date,
            bellCounter
        );
    }
}
