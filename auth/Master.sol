// SPDX-License-Identifier: AGPL-3.0-only

pragma solidity ^0.8.4;

import "../interface/IERC173.sol";
import "../interface/errors/IERC173Errors.sol";

contract Master is IERC173, IERC173Errors {
    address private _master;

    modifier master() {
        if (owner() != msg.sender) {
            revert CallerIsNonContractOwner(owner());
        }
        _;
    }

    constructor(address master_) {
        _transferOwnership(master_);
    }

    function owner() public view override(IERC173) returns (address) {
        return _master;
    }

    function transferOwnership(address _newMaster)
        public
        override(IERC173)
        master
    {
        if (_newMaster == address(0)) {
            revert TransferRoleToZeroAddress(_newMaster);
        }
        _transferOwnership(_newMaster);
    }

    function _transferOwnership(address _newMaster) internal {
        address previousMaster = _master;
        _master = _newMaster;
        emit OwnershipTransferred(previousMaster, _newMaster);
    }
}
