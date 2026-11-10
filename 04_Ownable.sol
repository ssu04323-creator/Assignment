// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// CONTRACT CHA: OWNABLE
contract Ownable {
    address public owner;
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
    // Nguoi deploy tro thanh Owner
    constructor() {
        owner = msg.sender;
    }
    // Modifier kiem tra quyen Owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }
    // Chuyen quyen so huu
    function transferOwnership(address newOwner)
        public
        onlyOwner
    {
        require(newOwner != address(0), "Invalid address");
        address previousOwner = owner;
        owner = newOwner;
        emit OwnershipTransferred(previousOwner, newOwner);
    }
}

// CONTRACT CON: PROTECTED VAULT
contract ProtectedVault is Ownable {

    uint256 private treasure;

    // Moi nguoi deu co the gui ETH vao ket
    function deposit() public payable {
        require(msg.value > 0, "Deposit must be greater than zero");

        treasure += msg.value;
    }

    // Chi Owner duoc phep rut ETH
    function withdraw(address payable to, uint256 amt)
        public
        onlyOwner
    {
        require(to != address(0), "Invalid recipient");
        require(amt <= address(this).balance, "Insufficient balance");

        (bool success, ) = to.call{value: amt}("");
        require(success, "Transfer failed");

        treasure = address(this).balance;
    }

    // Xem so du trong hop dong
    function contractBalance()
        public
        view
        returns (uint256)
    {
        return address(this).balance;
    }
}
