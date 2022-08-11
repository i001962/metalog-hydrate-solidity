// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.4;

import "prb-math/contracts/PRBMathSD59x18.sol";
import "hardhat/console.sol";

contract Structs {
    struct Coeff {
        int256 a;
        int256 b;
    }

    struct Dist {
            string distName;
            mapping (uint => Coeff) aCoeffs;
            }
    
    mapping (uint => Dist) public distributions;    

    //0x06f05b59d3b20000 === 0.5
    uint numCoeffs;
    function addCoeffs(string memory _distName, int256 _value) public returns (uint distId) {
        distId = numCoeffs++;
        Dist storage r = distributions[distId];
        r.distName = _distName;
        r.aCoeffs[numCoeffs++] = Coeff({a: _value, b: _value});
        //r.distribution[_id] = r;
            
        console.log("distId");
        console.logUint(distId);
        //distribution[_id] = Coeffs(_distName, _aCoeffs);

    }
        
}