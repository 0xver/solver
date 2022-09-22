// SPDX-License-Identifier: AGPL-3.0-only

pragma solidity ^0.8.4;

import "../interface/IERC165.sol";
import "../auth/Master.sol";
import "../token/metadata/ERC20Metadata.sol";

abstract contract ERC20Supports is IERC165, Master, ERC20Metadata {
    function supportsInterface(bytes4 interfaceId)
        public
        pure
        override(IERC165)
        returns (bool)
    {
        return
            interfaceId == type(IERC20).interfaceId ||
            interfaceId == type(IERC165).interfaceId ||
            interfaceId == type(IERC173).interfaceId;
    }
}
