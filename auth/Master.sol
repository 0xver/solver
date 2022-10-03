// SPDX-License-Identifier: AGPL-3.0-only

pragma solidity ^0.8.4;

import "../interface/IERC173.sol";
import "../interface/errors/IERC173Errors.sol";

contract Master is IERC173, IERC173Errors {
    address private _master;
    address private _getApprovedMaster;

    constructor(address master_) {
        _transferMaster(master_);
    }

    modifier master() {
        if (owner() != msg.sender) {
            revert NonMaster(owner(), msg.sender);
        }
        _;
    }

    function owner() public view virtual override(IERC173) returns (address) {
        return _master;
    }

    function transferOwnership(address _to)
        public
        virtual
        override(IERC173)
        master
    {
        if (_to == address(0)) {
            revert TransferMasterToZeroAddress(owner(), _to);
        }
        _transferMaster(_to);
    }

    function approveMaster(address _approved) public virtual master {
        _getApprovedMaster = _approved;
    }

    function getApprovedMaster() public view virtual returns (address) {
        return _getApprovedMaster;
    }

    function _isApprovedMasterOrMaster(address _address)
        internal
        view
        virtual
        returns (bool)
    {
        return _getApprovedMaster == _address || _master == _address;
    }

    function _transferMaster(address _to) internal virtual {
        address _from = _master;
        _master = _to;
        emit OwnershipTransferred(_from, _to);
    }
}
