// SPDX-License-Identifier: AGPL-3.0-only

pragma solidity ^0.8.4;

import "../ERC721.sol";
import "../../interface/metadata/IERC721Metadata.sol";
import "../../library/Strings.sol";
import "../../library/Base64.sol";

contract ERC721Metadata is ERC721, IERC721Metadata {
    string private _name;
    string private _symbol;
    string private _defaultImage;

    constructor(
        string memory name_,
        string memory symbol_,
        string memory defaultImage_
    ) {
        _name = name_;
        _symbol = symbol_;
        _defaultImage = defaultImage_;
    }

    function name()
        public
        view
        virtual
        override(IERC721Metadata)
        returns (string memory)
    {
        return _name;
    }

    function symbol()
        public
        view
        virtual
        override(IERC721Metadata)
        returns (string memory)
    {
        return _symbol;
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        virtual
        override(IERC721Metadata)
        returns (string memory)
    {
        bytes memory dataURI = abi.encodePacked(
            "{",
            '"name":"ERC721 Test #',
            Strings.toString(_tokenId),
            '",',
            '"description":"ERC721 Test"',
            '",',
            '"image":"',
            _defaultImage,
            '"}'
        );
        if (!_exists(_tokenId)) {
            return "Invalid ID";
        } else {
            return
                string(
                    abi.encodePacked(
                        "data:application/json;base64,",
                        Base64.encode(dataURI)
                    )
                );
        }
    }
}
