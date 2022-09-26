// SPDX-License-Identifier: AGPL-3.0-only

pragma solidity ^0.8.4;

import "../ERC721.sol";
import "../../interface/metadata/IERC721Metadata.sol";
import "../../library/Strings.sol";
import "../../library/Base64.sol";

contract ERC721Metadata is ERC721, IERC721Metadata {
    string private _name;
    string private _symbol;
    string private _description;
    string private _defaultExtension;
    mapping(uint256 => string) private _customExtension;

    constructor(
        string memory name_,
        string memory symbol_,
        string memory description_,
        // Use "" to void extended json and exclude {}
        string memory extension_
    ) {
        _name = name_;
        _symbol = symbol_;
        _description = description_;
        _defaultExtension = extension_;
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
        bytes memory _core = abi.encodePacked(
            '"name":"',
            name(),
            " #",
            Strings.toString(_tokenId),
            '","description":"',
            _description,
            '"'
        );
        string memory extension = _ext(_tokenId);
        bytes memory data = abi.encodePacked("{", _core, extension, "}");
        if (ownerOf(_tokenId) == address(0)) {
            return "INVALID_ID";
        } else {
            return
                string(
                    abi.encodePacked(
                        "data:application/json;base64,",
                        Base64.encode(data)
                    )
                );
        }
    }

    function _setExtension(string memory _json, uint256 _tokenId)
        internal
        virtual
    {
        _customExtension[_tokenId] = _json;
    }

    function _customIdExtension(uint256 _tokenId)
        internal
        view
        virtual
        returns (string memory)
    {
        return _customExtension[_tokenId];
    }

    function _extension(uint256 _tokenId)
        internal
        view
        virtual
        returns (string memory)
    {
        return string(abi.encodePacked(",", _customIdExtension(_tokenId)));
    }

    function _ext(uint256 _tokenId) private view returns (string memory) {
        string memory extension;
        if (
            keccak256(abi.encodePacked(_customExtension[_tokenId])) ==
            keccak256(abi.encodePacked(""))
        ) {
            if (
                keccak256(abi.encodePacked(_defaultExtension)) ==
                keccak256(abi.encodePacked(""))
            ) {
                delete extension;
            } else {
                extension = string(abi.encodePacked(",", _defaultExtension));
            }
        } else {
            extension = _extension(_tokenId);
        }
        return extension;
    }
}
