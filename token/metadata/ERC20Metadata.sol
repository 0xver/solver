// SPDX-License-Identifier: AGPL-3.0-only

pragma solidity ^0.8.4;

import "../ERC20.sol";
import "../../interface/metadata/IERC20Metadata.sol";

contract ERC20Metadata is ERC20, IERC20Metadata {
	string private _name;
	string private _symbol;

	constructor(string memory name_, string memory symbol_) {
		_name = name_;
		_symbol = symbol_;
	}

	function name()
		public
		view
		virtual
		override(IERC20Metadata)
		returns (string memory)
	{
		return _name;
	}

	function symbol()
		public
		view
		virtual
		override(IERC20Metadata)
		returns (string memory)
	{
		return _symbol;
	}
}
