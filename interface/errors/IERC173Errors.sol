// SPDX-License-Identifier: AGPL-3.0-only

pragma solidity ^0.8.4;

interface IERC173Errors {
    error NonMaster(address _master, address _sender);

    error TransferMasterToZeroAddress(address _master, address _newMaster);
}
