// SPDX-License-Identifier: AGPL-3.0-only

pragma solidity ^0.8.4;

library Merkle {
	function verify(
		bytes32[] memory _proof,
		bytes32 _root,
		bytes32 _leaf
	) internal pure returns (bool) {
		return processProof(_proof, _leaf) == _root;
	}

	function processProof(
		bytes32[] memory _proof,
		bytes32 _leaf
	) internal pure returns (bytes32) {
		bytes32 computedHash = _leaf;
		for (uint256 i = 0; i < _proof.length; i++) {
			bytes32 proofElement = _proof[i];
			if (computedHash <= proofElement) {
				computedHash = _efficientHash(computedHash, proofElement);
			} else {
				computedHash = _efficientHash(proofElement, computedHash);
			}
		}
		return computedHash;
	}

	function _efficientHash(
		bytes32 _a,
		bytes32 _b
	) private pure returns (bytes32 value) {
		assembly {
			mstore(0x00, _a)
			mstore(0x20, _b)
			value := keccak256(0x00, 0x40)
		}
	}
}
