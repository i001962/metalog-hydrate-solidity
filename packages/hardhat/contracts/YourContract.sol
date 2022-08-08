// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.4;

import "hardhat/console.sol";

// import "@openzeppelin/contracts/access/Ownable.sol";
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

contract YourContract {
    event SetPurpose(address sender, string purpose);
    event SetQuantile(address sender, string quantile);

    string public purpose = "Building Ethereum Apps!!!";
    string public quantile = "Building Metalog Apps!!!";

    constructor() payable {
        // what should we do on deploy?
    }

    function setPurpose(string memory newPurpose) public {
        purpose = newPurpose;
        console.log(msg.sender, "set purpose to", purpose);
        emit SetPurpose(msg.sender, purpose);
    }

    function setQuantile(string memory newQuantile) public {
        quantile = newQuantile;
        console.log(msg.sender, "set quantile to", quantile);
        emit SetQuantile(msg.sender, quantile);
    }

    // to support receiving ETH by default
    receive() external payable {}

    fallback() external payable {}
}
