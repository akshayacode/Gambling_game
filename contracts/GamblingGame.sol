// SPDX-License-Identifier: UNLICENSED
import "@openzeppelin/contracts/utils/Counters.sol";
pragma solidity ^0.8.0;

contract Gambling_game{

    address private owner;
    using Counters for Counters.Counter;

     modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can execute this function.");
        _;
    }

    constructor() {
        owner = msg.sender;  
    }

    struct Game {
    uint256 gameId;
    address[] players;
    uint256 Staking_amount;
    uint256 prize;
    address winner;
    bool isFinished;
}

    Counters.Counter private gameId;
    mapping(uint256 => Game) public gameInfo;
    mapping(uint256 => uint256) playersCount;
 

    event InitializedGame(uint256,uint256,uint256);
    mapping(address => uint) public balance;
    

    function initializeGame(uint _playersno,uint256 _Stakingamount) public onlyOwner {
        require(_playersno >= 3 , "No of Players Should be less than or equal to 3");
        require(_Stakingamount > 0, "Staking amount should be greater than 0");
        Game memory game = Game({
        gameId: gameId.current(),
        players: new address[](0),
        prize: 0,
        Staking_amount: _Stakingamount,
        winner: address(0),
        isFinished: false
        });
        gameInfo[gameId.current()] = game;
        gameId.increment();
        emit InitializedGame(game.gameId,game.Staking_amount,game.prize);

    }

    function JoinGame(uint256 _gameid,uint _amount, address _playeraddress) public payable{
        require(_amount >= gameInfo[_gameid].Staking_amount,"Amount is less than the staking value" );
        gameInfo[_gameid].players.push(msg.sender);
        balance[_playeraddress] -= _amount;
        balance[msg.sender] += _amount;

    }
    
    function getplayers(uint256 _gameid) public view returns(address[] memory)
    {
        return(gameInfo[_gameid].players);
    }



    function deposit(uint amount) public  {
        balance[msg.sender] += amount;
    }

      function withdraw(uint amount) public  {
        balance[msg.sender] -= amount;
    }
    
}