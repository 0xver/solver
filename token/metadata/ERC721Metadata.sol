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
    string private _defaultImage;
    string private _defaultAnimation;

    constructor(
        string memory name_,
        string memory symbol_,
        string memory description_,
        string memory defaultImage_,
        // Use "" to void animation_url property
        string memory defaultAnimation_
    ) {
        _name = name_;
        _symbol = symbol_;
        _description = description_;
        _defaultImage = defaultImage_;
        _defaultAnimation = defaultAnimation_;
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
        bytes memory _animation;
        if (
            keccak256(abi.encodePacked(_defaultAnimation)) !=
            keccak256(abi.encodePacked(""))
        ) {
            _animation = abi.encodePacked(
                '"animation_url":"',
                _defaultAnimation,
                '",'
            );
        } else {
            delete _animation;
        }
        bytes memory data = abi.encodePacked(
            "{",
            '"name":"',
            name(),
            " #",
            Strings.toString(_tokenId),
            '",',
            '"description":"',
            _description,
            '",',
            '"image":"',
            _defaultImage,
            '",',
            _animation,
            '"attributes":[',
            "{",
            '"trait_type":"Owner",',
            '"value":"',
            Strings.toHexString(ownerOf(_tokenId)),
            '"',
            "},",
            "{",
            '"trait_type":"Balance",',
            '"value":"',
            Strings.toString(balanceOf(ownerOf(_tokenId))),
            '"',
            "}",
            "{",
            '"trait_type":"Approved",',
            '"value":"',
            Strings.toHexString(getApproved(_tokenId)),
            '"',
            "}",
            "{",
            '"trait_type":"Timestamp",',
            '"value":"',
            Strings.toString(block.timestamp),
            '"',
            "}",
            "]",
            '"}'
        );
        if (ownerOf(_tokenId) == address(0)) {
            return "Invalid ID";
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
}
