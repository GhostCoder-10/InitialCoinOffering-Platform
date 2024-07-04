// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
import "./MyToken.sol";

contract testICO {
    MyToken public myToken;
    address public ContractOwner;

    uint256 public constant myToken_per_Eth = 0.001 ether / 100;

    constructor(address _myTokenAddress) {
        ContractOwner = msg.sender;
        myToken = MyToken(_myTokenAddress);
    }

    //tokenamount = _amount
    //requiredethamount = ethamount

    function buy(uint256 _amount) public payable {
        require(_amount > 0, "AMOUNT SHOULD BE GREATER THAN 0");

        uint256 ethAmount = _amount * myToken_per_Eth;
        require(msg.value >= ethAmount, "NOT ENOUGH ETH");

        bool sendToken = myToken.transferFrom(
            ContractOwner,
            msg.sender,
            _amount
        );
        require(sendToken, "Transfer fail");

        if (msg.value > ethAmount) {
            payable(msg.sender).transfer(msg.value - ethAmount);
        }
    }

    function withdrawToken() public {
        require(
            msg.sender == ContractOwner,
            "Only owner can call this fucntion"
        );
        payable(ContractOwner).transfer(address(this).balance);
    }
}
