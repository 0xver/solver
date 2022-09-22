// SPDX-License-Identifier: AGPL-3.0-only

pragma solidity ^0.8.4;

import "../interface/IERC165.sol";
import "../auth/Master.sol";
import "../token/metadata/ERC721Metadata.sol";
import "../library/Merkle.sol";

contract ERC721Supports is IERC165, Master, ERC721Metadata {
    event Withdrawal(address operator, address receiver, uint256 value);

    constructor()
        ERC721Metadata("ERC721 Token", "ERC721", "cid/prereveal.json")
        Master(msg.sender)
    {}

    receive() external payable {}

    fallback() external payable {}

    function withdraw(address _to) public master {
        uint256 balance = address(this).balance;
        (bool success, ) = payable(_to).call{value: address(this).balance}("");
        require(success, "MyERC20Token: ether transfer failed");
        emit Withdrawal(msg.sender, _to, balance);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        pure
        override(IERC165)
        returns (bool)
    {
        return
            interfaceId == type(IERC165).interfaceId ||
            interfaceId == type(IERC173).interfaceId ||
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            interfaceId == type(IERC721Receiver).interfaceId;
    }
}
