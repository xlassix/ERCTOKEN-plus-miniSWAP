pragma solidity ^0.8.3;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SpaceToken is ERC20 {

    constructor() ERC20("SpaceToken", "SPC") {
        _mint(msg.sender, 1000 * 10**18);
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }
}

contract ExchangeICO {
    mapping(address => uint) public rates;
    address _owner;
    uint256 balance;

    event SwapEvent(
        address indexed contactAddress,
        address indexed to,
        uint256 value,
        uint256 rate,
        uint256 indexed timestamp
    );

    constructor() {
        _owner = msg.sender;
    }

    function setRate(address contactAddress, uint256 _rate) external {
        require(msg.sender ==_owner,"Unauthorised");
        rates[contactAddress] = _rate;
    }

    function swap(address contactAddress) external payable {
        require(msg.value > 1, "cant transfer Nothing");
        require(rates[contactAddress] > 0, "Rate  Not Set");
        uint256 tokenToTransfer = msg.value * rates[contactAddress];
        require(
            IERC20(contactAddress).balanceOf(address(this)) > tokenToTransfer,
            "Not enough coins to exchange"
        );
        balance += msg.value;
        IERC20(contactAddress).transfer(
            msg.sender,
            tokenToTransfer
        );
        emit SwapEvent(
            contactAddress,
            msg.sender,
            msg.value,
            rates[contactAddress],
            block.timestamp
        );
    }
}
