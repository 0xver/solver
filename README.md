# Solver

[![License: AGPL v3](https://img.shields.io/badge/License-AGPL_v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)

Basic building blocks for smart contract development

## Module Directory

```ml
auth
│  ├─ extensions
│  │  ├─ Operator — "Operator extension for the ERC173 implementation"
├─ ERC173 — "Implementation of the ERC173 standard"
interface
│  ├─ errors
│  │  ├─ extensions
│  │  │  ├─ IOperatorErrors — "ERC173 operator extension errors interface"
│  │  ├─ IERC173Errors — "ERC173 errors interface"
│  │  ├─ IERC721Errors — "ERC721 errors interface"
│  ├─ extensions
│  │  ├─ IOperator — "ERC173 operator extension interface"
│  ├─ metadata
│  │  ├─ IERC20Metadata — "ERC20Metadata standard interface"
│  │  ├─ IERC721Metadata — "ERC721Metadata standard interface"
│  ├─ receiver
│  │  ├─ IERC721Receiver — "ERC721Receiver standard interface"
├─ IERC20 — "ERC20 standard interface"
├─ IERC165 — "ERC165 standard interface"
├─ IERC173 — "ERC173 standard interface"
├─ IERC721 — "ERC721 standard interface"
library
├─ Encode — "Encoding operations"
├─ Log — "Log operations"
├─ Merkle — "Merkle proof"
supports
├─ ERC165 — "Implementation of the ERC165 standard"
token
├─ metadata
│  ├─ ERC20Metadata — "Implementation of the ERC20Metadata standard"
│  ├─ ERC721Metadata — "Implementation of the ERC721Metadata standard"
├─ ERC20 — "Implementation of the ERC20 standard"
├─ ERC721 — "Implementation of the ERC721 standard"
```

## NFT Smart Contract Example

```
// SPDX-License-Identifier: AGPL-3.0-only

pragma solidity ^0.8.4;

import "../supports/ERC165.sol";
import "../auth/extensions/Operator.sol";
import "../token/metadata/ERC721Metadata.sol";

contract NFT is ERC165, Operator, ERC721Metadata {
	error QuantityLimit(
		uint256 quantity,
		uint256 txnLimit,
		uint256 totalSupplyLimit
	);

	uint256 userTxnLimit = 10;
	uint256 authTxnLimit = 100;
	uint256 totalSupplyLimit = 10000;

	constructor()
		ERC721Metadata("Non-fungible Token", "NFT")
		Operator(msg.sender)
	{}

	function mint(uint256 _quantity) public {
		_eoaOnly();
		if (
			_quantity + totalSupply() > totalSupplyLimit ||
			_quantity > userTxnLimit
		) {
			revert QuantityLimit(_quantity, userTxnLimit, totalSupplyLimit);
		}
		_mint(msg.sender, _quantity);
	}

	function airdrop(address _to, uint256 _quantity) public operatorship {
		if (
			_quantity + totalSupply() > totalSupplyLimit ||
			_quantity > authTxnLimit
		) {
			revert QuantityLimit(_quantity, authTxnLimit, totalSupplyLimit);
		}
		_mint(_to, _quantity);
	}

	function supportsInterface(
		bytes4 interfaceId
	) public pure virtual override(ERC165) returns (bool) {
		return
			interfaceId == type(IERC173).interfaceId ||
			interfaceId == type(IERC721).interfaceId ||
			interfaceId == type(IERC721Receiver).interfaceId ||
			interfaceId == type(IERC721Metadata).interfaceId ||
			super.supportsInterface(interfaceId);
	}
}
```

## Safety

It is important to consider all security risks when coding a smart contract, such as reentrancy attacks. The ERC721 and ERC20 implementations come with built-in externally owned account (EOA) only checks called `_eoaOnly()`, which should be used in most cases for public mint functions. Here is an example using an ERC721 implementation:

```
function mint() public {
	_eoaOnly();

	/// Mint logic

	_safeMint(msg.sender);
}
```

Major improvements for this software begin at version 10.0.0. **Only use version 10.0.0 or later** for production. **ALWAYS** review contracts before using as they are not audited.

This is **experimental software** and is provided on an "as is" and "as available" basis.

We **do not give any warranties** and **will not be liable for any loss** incurred through any use of this codebase.

## Installation

Install **Solver**:

```
npm install --save-dev @0xver/solver
```

Install [**Hardhat**](https://github.com/NomicFoundation/hardhat):

```
npm install --save-dev hardhat
```

## Acknowledgements

These contracts were inspired by or directly modified from many sources, primarily:

- [OpenZeppelin](https://github.com/OpenZeppelin/openzeppelin-contracts)
- [Solmate](https://github.com/transmissions11/solmate)
