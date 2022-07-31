//SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;


import './ERC721Connector.sol';

contract Kryptobirdz is ERC721Connector{

    // array to store our nfts
    string [] public KryptoBirdz;
    mapping(string => bool) _KryptobirdzExists; 


     constructor() ERC721Connector('KryptoBird', 'KBIRDZ'){
        
    }


    function mint(string memory _kryptoBird) public {

        require(!_KryptobirdzExists[_kryptoBird], 'Error - kryptobird already exists');

        // this is deprecated uint _id = KryptoBirdz.push(_kryptoBird);
        // .push no longer returns the length but ref to added element

        KryptoBirdz.push(_kryptoBird);
        uint _id = KryptoBirdz.length - 1;

        _mint(msg.sender,_id);
        _KryptobirdzExists[_kryptoBird] = true;


    }
    
   


}