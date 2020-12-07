// SPDX-License-Identifier: MIt
pragma solidity >=0.4.22 <0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GLDToken is ERC20, Ownable {
    using SafeMath for uint256;

    constructor() public ERC20("Gold", "GLD") Ownable() {
        uint256 initialSupply = 1000000 * 10**18;
        _mint(msg.sender, initialSupply);
    }

    function claimTokens() public {
        _mint(msg.sender, 1000 * 10**18);
    }

    function setApproval(address claimer, uint256 amount) public {
        _approve(claimer, msg.sender, amount);
    }
}
