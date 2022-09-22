// SPDX-License-Identifier: AGPL-3.0-only

pragma solidity ^0.8.4;

import "../interface/IERC721.sol";
import "../interface/errors/IERC721Errors.sol";
import "../interface/receiver/IERC721Receiver.sol";

contract ERC721 is IERC721, IERC721Errors {
    uint256 private _currentId;
    uint256 private _subtractId;
    mapping(address => uint256) private _balanceOf;
    mapping(uint256 => address) private _ownerOf;
    mapping(uint256 => address) private _getApproved;
    mapping(address => mapping(address => bool)) private _isApprovedForAll;

    function _safeMint(address _to, uint96 _quantity) internal virtual {
        _safeMint(_to, _quantity, "");
    }

    function _safeMint(
        address _to,
        uint96 _quantity,
        bytes memory _data
    ) internal virtual {
        if (!_onERC721Received(address(0), _to, _currentId, _data)) {
            revert TransferToNonERC721Receiver(_to);
        }
        _unsafeMint(_to, _quantity);
    }

    function _mint(address _to, uint96 _quantity) internal virtual {
        if (tx.origin != msg.sender) {
            revert TxOriginNonSender(tx.origin, msg.sender);
        }
        _unsafeMint(_to, _quantity);
    }

    function _unsafeMint(address _to, uint96 _quantity) private {
        if (_to == address(0)) {
            revert TransferTokenToZeroAddress(_currentId + 1, _to);
        }
        unchecked {
            _balanceOf[_to] += _quantity;
        }
        for (uint256 i = 0; i < _quantity; i = _unchecked(i)) {
            _loop(_to, _currentId + i + 1);
        }
        _currentId += _quantity;
    }

    function _unchecked(uint256 i) private pure returns (uint256) {
        unchecked {
            return i + 1;
        }
    }

    function _loop(address _to, uint256 _id) private {
        _ownerOf[_id] = _to;
        _mintHook(_id);
        emit Transfer(address(0), _to, _id);
    }

    function _burn(address _from, uint256 _tokenId) internal virtual {
        if (!_isApprovedOrOwner(msg.sender, _tokenId)) {
            revert NonApprovedNonOwner(
                _isApprovedForAll[_ownerOf[_tokenId]][msg.sender],
                _getApproved[_tokenId],
                msg.sender,
                _ownerOf[_tokenId]
            );
        }
        if (_ownerOf[_tokenId] != _from) {
            revert TransferFromNonOwner(msg.sender, _ownerOf[_tokenId]);
        }
        delete _getApproved[_tokenId];
        unchecked {
            _balanceOf[_from] -= 1;
        }
        _ownerOf[_tokenId] = address(0);
        _subtractId += 1;
        _burnHook(_tokenId);
        emit Transfer(_from, address(0), _tokenId);
    }

    function _exists(uint256 _tokenId) internal view virtual returns (bool) {
        return _ownerOf[_tokenId] != address(0);
    }

    function _currentTokenId() internal view virtual returns (uint256) {
        return _currentId;
    }

    function totalSupply() public view virtual returns (uint256) {
        return (_currentId - _subtractId);
    }

    function balanceOf(address _owner)
        public
        view
        virtual
        override(IERC721)
        returns (uint256)
    {
        return _balanceOf[_owner];
    }

    function ownerOf(uint256 _tokenId)
        public
        view
        virtual
        override(IERC721)
        returns (address)
    {
        return _ownerOf[_tokenId];
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) public virtual override(IERC721) {
        safeTransferFrom(_from, _to, _tokenId, "");
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes memory _data
    ) public virtual override(IERC721) {
        if (!_isApprovedOrOwner(msg.sender, _tokenId)) {
            revert NonApprovedNonOwner(
                _isApprovedForAll[_ownerOf[_tokenId]][msg.sender],
                _getApproved[_tokenId],
                msg.sender,
                _ownerOf[_tokenId]
            );
        }
        _transfer(_from, _to, _tokenId);
        _onERC721Received(_from, _to, _tokenId, _data);
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) public virtual override(IERC721) {
        if (!_isApprovedOrOwner(msg.sender, _tokenId)) {
            revert NonApprovedNonOwner(
                _isApprovedForAll[_ownerOf[_tokenId]][msg.sender],
                _getApproved[_tokenId],
                msg.sender,
                _ownerOf[_tokenId]
            );
        }
        _transfer(_from, _to, _tokenId);
    }

    function approve(address _approved, uint256 _tokenId)
        public
        virtual
        override(IERC721)
    {
        if (_ownerOf[_tokenId] != msg.sender) {
            revert NonOwnerApproval(msg.sender, _ownerOf[_tokenId]);
        }
        _getApproved[_tokenId] = _approved;
        emit Approval(msg.sender, _approved, _tokenId);
    }

    function setApprovalForAll(address _operator, bool _approved)
        public
        virtual
        override(IERC721)
    {
        if (msg.sender == _operator) {
            revert ApproveOwnerAsOperator(msg.sender, _operator);
        }
        _isApprovedForAll[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function getApproved(uint256 _tokenId)
        public
        view
        virtual
        override(IERC721)
        returns (address)
    {
        return _getApproved[_tokenId];
    }

    function isApprovedForAll(address _owner, address _operator)
        public
        view
        virtual
        override(IERC721)
        returns (bool)
    {
        return _isApprovedForAll[_owner][_operator];
    }

    function _isApprovedOrOwner(address _spender, uint256 _tokenId)
        internal
        view
        virtual
        returns (bool)
    {
        address tokenOwner = _ownerOf[_tokenId];
        return (_spender == tokenOwner ||
            _isApprovedForAll[tokenOwner][_spender] ||
            _getApproved[_tokenId] == _spender);
    }

    function _transfer(
        address _from,
        address _to,
        uint256 _tokenId
    ) internal virtual {
        if (_ownerOf[_tokenId] != _from) {
            revert TransferFromNonOwner(msg.sender, _ownerOf[_tokenId]);
        }
        if (_to == address(0)) {
            revert TransferTokenToZeroAddress(_tokenId, _to);
        }
        delete _getApproved[_tokenId];
        unchecked {
            _balanceOf[_from] -= 1;
            _balanceOf[_to] += 1;
        }
        _ownerOf[_tokenId] = _to;
        _transferHook(_from, _to, _tokenId);
        emit Transfer(_from, _to, _tokenId);
    }

    function _onERC721Received(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes memory _data
    ) private returns (bool) {
        if (_to.code.length > 0) {
            try
                IERC721Receiver(_to).onERC721Received(
                    msg.sender,
                    _from,
                    _tokenId,
                    _data
                )
            returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert TransferToNonERC721Receiver(_to);
                } else {
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }

    function _mintHook(uint256 _tokenId) internal virtual {}

    function _burnHook(uint256 _tokenId) internal virtual {}

    function _transferHook(
        address _from,
        address _to,
        uint256 _tokenId
    ) internal virtual {}
}
