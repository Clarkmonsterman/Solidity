//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import './ERC721.sol';


contract ERC721Enumerable is ERC721 {


    uint256[] _allTokens;

    mapping(uint256 => uint256) private _allTokensIndex;
    // tokenID to position in _allTokens
    //mapping(uint256 => uint256) private _ownedTokensIndex;
    // token id index to Token ID
    mapping(address => uint256[]) private _ownedTokens;
    // owner to list of owned tokens
    

    function totalSupply() public view returns (uint256){
        return _allTokens.length;
    }


    function tokenByIndex(uint256 _index) external view returns (uint256){

    }

   
    function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256){

    }

    function _mint(address _to, uint256 _tokenId) internal override(ERC721){

        super._mint(_to, _tokenId);
        
        _addToEnumeration((_to), _tokenId);


    }

    function _addToEnumeration(address _to, uint256 _tokenId) private{
        if(_exists(_tokenId)){
            _allTokensIndex[_tokenId] = _allTokens.length;
            _allTokens.push(_tokenId);
            _ownedTokens[_to].push(_tokenId);
            //_ownedTokensIndex[_allTokens.length] = _tokenId;
           
        }

    }

    function getOwnedTokens(address _owner) external view returns(uint256[] memory Tokens){
        require(_owner != address(0), "Owner address is not valid");
        return _ownedTokens[_owner];
        
    }


    function getTokenIndex(uint256 _tokenId) external view returns(uint256 index){
        require(_exists(_tokenId), "Token ID Does not Exists");
        return _allTokensIndex[_tokenId];
        
    }


    function getTokenfromIndex(uint256 _index) external view returns(uint256 token){
        require((_index < _allTokens.length), "Index does not exists");
        return _allTokens[_index];
        
    }


    function getUserTokensByIndex(address _user, uint index) external view returns(uint256 token){
        require(_user != address(0));
        require(super.balanceOf(_user) != 0);
        return _ownedTokens[_user][index];

    }



}


