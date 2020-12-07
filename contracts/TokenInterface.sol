// SPDX-License-Identifier: MIt
pragma solidity >=0.4.22 <0.8.0;

contract TokenInterface {
    function claimTokens() public {}

    function setApproval(address claimer, uint256 amount) public {}

    function approve(address spender, uint256 amount) public {}

    function transfer(address recipient, uint256 amount) public {}

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public {}
}
