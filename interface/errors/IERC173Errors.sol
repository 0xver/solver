// SPDX-License-Identifier: AGPL-3.0-only

pragma solidity ^0.8.4;

interface IERC173Errors {
    error TransferRoleToZeroAddress(address _newMaster);

    error CallerIsNonContractOwner(address _master);
}
