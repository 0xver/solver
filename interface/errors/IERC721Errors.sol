// SPDX-License-Identifier: AGPL-3.0-only

pragma solidity ^0.8.4;

interface IERC721Errors {
    error TransferTokenToZeroAddress(uint256 _tokenId, address _to);

    error NonApprovedNonOwner(
        bool _isApprovedForAll,
        address _getApproved,
        address _caller,
        address _owner
    );

    error NonOwnerApproval(address _caller, address _owner);

    error ApproveOwnerAsOperator(address _caller, address _operator);

    error TransferFromNonOwner(address _caller, address _owner);

    error TransferToNonERC721Receiver(address _contract);

    error TxOriginNonSender(address _origin, address _caller);
}
