# Solver

[![License: AGPL v3](https://img.shields.io/badge/License-AGPL_v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)

Basic building blocks for smart contract development

## Solidity Directory

```ml
auth
├─ Master — "Implementation of the ERC173 standard"
interface
│  ├─ errors
│  │  ├─ IERC173Errors — "ERC173 errors interface"
│  │  ├─ IERC721Errors — "ERC721 errors interface"
│  ├─ metadata
│  │  ├─ IERC20Metadata — "ERC20Metadata standard"
│  │  ├─ IERC721Metadata — "ERC721Metadata standard"
│  ├─ receiver
│  │  ├─ IERC721Receiver — "ERC721Receiver standard"
├─ IERC20 — "ERC20 standard"
├─ IERC165 — "ERC165 standard"
├─ IERC173 — "ERC173 standard"
├─ IERC721 — "ERC721 standard"
library
├─ Base64 — "Base64 encoding"
├─ Log — "Log operations"
├─ Merkle — "Merkle proof"
├─ Strings — "String from uint"
supports
├─ ERC20Supports — "ERC20 supports interface and bundling"
├─ ERC721Supports — "ERC721 supports interface and bundling"
token
├─ metadata
│  ├─ ERC20Metadata — "Implementation of the ERC20Metadata standard"
│  ├─ ERC721Metadata — "Implementation of the ERC721Metadata standard"
├─ ERC20 — "Implementation of the ERC20 standard"
├─ ERC721 — "Implementation of the ERC721 standard"
```

## Safety

This is **experimental software** and is provided on an "as is" and "as available" basis.

These contracts are **not designed with user safety** in mind:

- There are implicit invariants these contracts expect to hold.
- **You can easily shoot yourself in the foot if you're not careful.**
- You should thoroughly read each contract you plan to use top to bottom.

We **do not give any warranties** and **will not be liable for any loss** incurred through any use of this codebase.

## Installation

To install with [**Hardhat**](https://github.com/NomicFoundation/hardhat):

```
npm install @0xver/solver
```

## Acknowledgements

These contracts were inspired by or directly modified from many sources, primarily:

- [OpenZeppelin](https://github.com/OpenZeppelin/openzeppelin-contracts)
- [Solmate](https://github.com/transmissions11/solmate)
