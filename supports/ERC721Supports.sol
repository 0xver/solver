// SPDX-License-Identifier: AGPL-3.0-only

pragma solidity ^0.8.4;

import "../interface/IERC165.sol";
import "../auth/Master.sol";
import "../token/metadata/ERC721Metadata.sol";
import "../library/Merkle.sol";

abstract contract ERC721Supports is IERC165, Master, ERC721Metadata {
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
