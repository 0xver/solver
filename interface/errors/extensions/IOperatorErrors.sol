// SPDX-License-Identifier: AGPL-3.0-only

pragma solidity ^0.8.4;

interface IOperatorErrors {
	error NonOperatorshipNonOwnership(
		address _operator,
		address _owner,
		address _sender
	);
}
