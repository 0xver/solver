// SPDX-License-Identifier: AGPL-3.0-only

pragma solidity ^0.8.4;

import "../interface/IERC20.sol";

contract ERC20 is IERC20 {
	uint256 private _totalSupply;
	mapping(address => uint256) private _balanceOf;
	mapping(address => mapping(address => uint256)) private _allowance;

	function decimals() public pure virtual override(IERC20) returns (uint8) {
		return 18;
	}

	function totalSupply()
		public
		view
		virtual
		override(IERC20)
		returns (uint256)
	{
		return _totalSupply;
	}

	function balanceOf(
		address _owner
	) public view virtual override(IERC20) returns (uint256) {
		return _balanceOf[_owner];
	}

	function transfer(
		address _to,
		uint256 _value
	) public virtual override(IERC20) returns (bool) {
		require(balanceOf(msg.sender) >= _value, "EXCEEDS_BALANCE");
		_transfer(msg.sender, _to, _value);
		return true;
	}

	function transferFrom(
		address _from,
		address _to,
		uint256 _value
	) public virtual override(IERC20) returns (bool) {
		require(balanceOf(_from) >= _value, "EXCEEDS_BALANCE");
		if (msg.sender != _from) {
			require(
				balanceOf(_from) >= allowance(_from, msg.sender),
				"ALLOWANCE_EXCEEDS_BALANCE"
			);
			_allowance[_from][msg.sender] -= _value;
		}
		_transfer(_from, _to, _value);
		return true;
	}

	function approve(
		address _spender,
		uint256 _value
	) public virtual override(IERC20) returns (bool) {
		require(_spender != address(0), "APPROVE_ZERO_ADDRESS");
		require(_spender != msg.sender, "APPROVE_OWNER");
		_allowance[msg.sender][_spender] = _value;
		emit Approval(msg.sender, _spender, _value);
		return true;
	}

	function allowance(
		address _owner,
		address _spender
	) public view virtual override(IERC20) returns (uint256) {
		return _allowance[_owner][_spender];
	}

	function _transfer(
		address _from,
		address _to,
		uint256 _value
	) internal virtual {
		require(_to != address(0), "TRANSFER_TO_ZERO_ADDRESS");
		_balanceOf[_from] -= _value;
		unchecked {
			_balanceOf[_to] += _value;
		}
		emit Transfer(_from, _to, _value);
	}

	function _mint(address _to, uint256 _value) internal virtual {
		require(_to != address(0), "TRANSFER_TO_ZERO_ADDRESS");
		_totalSupply += _value;
		unchecked {
			_balanceOf[_to] += _value;
		}
		emit Transfer(address(0), _to, _value);
	}

	function _burn(address _from, uint256 _value) internal virtual {
		require(_from != address(0), "BURN_FROM_ZERO_ADDRESS");
		_balanceOf[_from] -= _value;
		unchecked {
			_totalSupply -= _value;
		}
		emit Transfer(_from, address(0), _value);
	}

	function _eoaOnly() internal virtual {
		require(tx.origin == msg.sender, "TX_ORIGIN_NON_SENDER");
	}
}
