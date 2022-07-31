//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


contract ERC721{

    event Transfer(address indexed from, 
    address indexed to, 
    uint256 indexed tokenId);

    event Approval(
        address indexed owner,
        address indexed approved,
        uint256 tokenId
    );

    mapping(uint => address) private _tokenOwner;
    mapping(address => uint) private _OwnedTokensCount;

    mapping(uint256 => address) private _tokenApprovals;


    function _exists(uint256 tokenId) internal view returns(bool){
        // setting address of nft owner to check mapping of address
        address owner = _tokenOwner[tokenId];
        // return truthiness that address is not zero
        return owner != address(0);

    }


    function _mint(address to, uint256 tokenId) internal virtual {
        // requires that the address is not zero
        require(to != address(0)); // not invalid address
        // require that token does not already exist
        require(!_exists(tokenId), 'ERC721: token already minted');
        // we are adding a new address with a token id for minting
        _tokenOwner[tokenId] = to;
        _OwnedTokensCount[to] += 1;
        emit Transfer(address(0), to, tokenId);
    }

    function balanceOf(address _owner) public view returns(uint256){
        require(_owner != address(0));
        return _OwnedTokensCount[_owner];

    }

    function ownerOf(uint256 _tokenId) public view returns(address){
        require(_exists(_tokenId));
        return _tokenOwner[_tokenId];
        
    }


    function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
        require(ownerOf(_tokenId) == _from);
        require(_to != address(0));
        
        _OwnedTokensCount[_from] -= 1;
        _OwnedTokensCount[_to] += 1;
        _tokenOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);

    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public {
        require(isApprovedOrOwner(_from, _tokenId));
        _transferFrom(_from, _to, _tokenId);
    }

    function approve(address _to, uint256 _tokenId) public {
        address owner = ownerOf(_tokenId);
        require(_to != owner);
        require(msg.sender == owner);
        _tokenApprovals[_tokenId] = _to;
        emit Approval(owner, _to, _tokenId);


    }

    function isApprovedOrOwner(address spender, uint256 _tokenId) view internal returns(bool){
        require(_exists(_tokenId));
        address owner = ownerOf(_tokenId);
        return(spender == owner || _tokenApprovals[_tokenId] == spender);
    }




    
}