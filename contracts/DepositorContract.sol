// SPDX-License-Identifier: MIt
pragma solidity >=0.4.22 <0.8.0;
import "./TokenInterface.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "@uniswap/v2-periphery/contracts/libraries/SafeMath.sol";

contract DepositorContract {
    using SafeMath for uint256;

    TokenInterface GLDToken;
    IUniswapV2Router02 UniswapContract;

    uint256 public totalTokensManagedByDepositor = 0; //total tokens managed by depositor contract (tokensInContract + tokensInPool)
    uint256 public totalTokensInUniswapPool = 0; //total tokens in Uniswap pool.

    address private contractGldAddr;
    address public addrUniswap = address(
        0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
    );

    mapping(address => uint256) public tokensInContract; //Tokens in Depositor Contract but not in a pool
    mapping(address => uint256) public tokensInPool; //Tokens managed by depositor contract but in Uniswap pool

    constructor(address _contractGldAddr) public {
        GLDToken = TokenInterface(_contractGldAddr);
        contractGldAddr = _contractGldAddr;
        GLDToken.approve(addrUniswap, 2**256 - 1); //We approve a large amount for Uniswap
    }

    function claimGldTokens() public {
        GLDToken = TokenInterface(contractGldAddr);
        GLDToken.claimTokens();
        tokensInContract[msg.sender] += 1000 * 10**18;
        totalTokensManagedByDepositor += 1000 * 10**18;
    }

    function withdrawGldTokens(uint256 amount) public {
        require(
            tokensInContract[msg.sender] > 0,
            "You need to claim some tokens"
        );
        require(amount <= tokensInContract[msg.sender], "Not enough tokens");
        GLDToken = TokenInterface(contractGldAddr);
        GLDToken.transfer(msg.sender, amount);
        tokensInContract[msg.sender] -= amount;
        totalTokensManagedByDepositor -= amount;
    }

    function depositGldTokens(uint256 amount) public {
        require(amount > 0, "You need to deposit some tokens");
        GLDToken = TokenInterface(contractGldAddr);
        GLDToken.setApproval(msg.sender, amount);
        GLDToken.transferFrom(msg.sender, address(this), amount);
        tokensInContract[msg.sender] += amount;
        totalTokensManagedByDepositor += amount;
    }

    function depositToUniswapPool(
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountEthMin,
        address to,
        uint256 deadline
    ) public payable {
        require(
            amountTokenDesired > 0,
            "Need to deposit some tokens in the pool"
        );
        require(
            amountTokenDesired <= tokensInContract[msg.sender],
            "Not enough tokens on Depositor Contract"
        );
        UniswapContract = IUniswapV2Router02(addrUniswap);
        UniswapContract.addLiquidityETH{value: msg.value}(
            contractGldAddr,
            amountTokenDesired,
            amountTokenMin,
            amountEthMin,
            to,
            deadline
        );
        tokensInContract[msg.sender] -= amountTokenDesired;
        tokensInPool[msg.sender] += amountTokenDesired;
        totalTokensInUniswapPool += amountTokenDesired;
    }

    function withdrawFromUniswapPool(
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountEthMin,
        address to,
        uint256 deadline
    ) public {
        UniswapContract = IUniswapV2Router02(addrUniswap);
        // UniswapContract.approve(msg.sender, liquidity); //Find a way to approve msg.sender
        UniswapContract.removeLiquidityETH(
            contractGldAddr,
            liquidity,
            amountTokenMin,
            amountEthMin,
            to,
            deadline
        );
        tokensInContract[msg.sender] += liquidity;
        tokensInPool[msg.sender] -= liquidity;
        totalTokensInUniswapPool -= liquidity;
    }
}
