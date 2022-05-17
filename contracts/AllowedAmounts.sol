// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.1;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

contract AllowedAmounts is Ownable {

    using SafeMath for uint;
    
    mapping(address => uint) amountsToWithdraw;

    modifier allowedToWithDraw(uint _amount) {
        require(owner() == msg.sender ||
         _amount <= amountsToWithdraw[msg.sender], "Not allowed to withdraw such amount.");
        _;
    }

    event AllowedAmountChanged(address indexed _from, address indexed _subject, uint _oldAmount, uint _newAmount);

    function changeAllowance(address _subject, uint _amount) public onlyOwner {
        emit AllowedAmountChanged(msg.sender, _subject, amountsToWithdraw[_subject], _amount);

        amountsToWithdraw[_subject] = _amount;
    }

    function reduceAmountToWithdraw(address _subject, uint _amount) internal {
        emit AllowedAmountChanged(msg.sender, _subject, amountsToWithdraw[_subject], amountsToWithdraw[_subject] - _amount);

         amountsToWithdraw[_subject] = amountsToWithdraw[_subject].sub(_amount);
    }
}
