// SPDX-License-Identifier: AGPL-3.0-only

pragma solidity ^0.8.4;

import "../interface/IERC173.sol";
import "../interface/errors/IERC173Errors.sol";

contract Owner is IERC173, IERC173Errors {
	address private _owner;
	address private _operator;

	constructor(address owner_) {
		_transferOwnership(owner_);
	}

	modifier ownership() {
		if (owner() != msg.sender) {
			revert NonOwnership(owner(), msg.sender);
		}
		_;
	}

	modifier operatorship() {
		if (owner() != msg.sender || operator() != msg.sender) {
			revert NonOperator(operator(), msg.sender);
		}
		_;
	}

	function transferOwnership(address _to)
		public
		virtual
		override(IERC173)
		ownership
	{
		if (_to == address(0)) {
			revert TransferOwnershipToZeroAddress(owner(), _to);
		}
		_transferOwnership(_to);
	}

	function setOperator(address _newOperator) public virtual ownership {
		_operator = _newOperator;
	}

	function owner() public view virtual override(IERC173) returns (address) {
		return _owner;
	}

	function operator() public view virtual returns (address) {
		return _operator;
	}

	function _transferOwnership(address _to) internal virtual {
		address _from = _owner;
		_owner = _to;
		delete _operator;
		emit OwnershipTransferred(_from, _to);
	}
}
