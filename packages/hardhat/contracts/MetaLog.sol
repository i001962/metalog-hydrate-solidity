// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.4;

import "prb-math/contracts/PRBMathSD59x18.sol";

contract MetaLog {
    using PRBMathSD59x18 for int256; 
    // GLOBALS
    //0x06f05b59d3b20000 === 0.5 //0x0c59ea48da190000 === 0.89
    //["-0x062838e0865204ea","0x045c937afddaa9d2","-0x06632bf1c33f2d08","0x074b2caf2eb6469c","0x1d5c4ea2451ac020"]
    int256[] internal coeffs;

    struct BasisDefaults {
        int256 half;
        int256 one; 
        int256 two; 
        int256 three;
        int256 four; 
        int256 five; 
        int256 six;
        int256 eight;
    }

 // FUNCTIONS
    function setACoeffs(int256[] memory theCoeffs) external {
        require (theCoeffs.length >= 2 && theCoeffs.length <= 16, 'too many or few coeefs'); 
        coeffs = theCoeffs;
    }

    function getACoeffs() external view returns (int256[] memory) {
        return coeffs;
    }    

    function basis(int256 y, int256 t) internal view returns (int256)
        {
            BasisDefaults memory basis;
            basis.half = 0x06f05b59d3b20000;       
            basis.one = 0x0de0b6b3a7640000;
            basis.two = 0x1bc16d674ec80000;
            basis.three = 0x29a2241af62c0000;
            basis.four = 0x3782dace9d900000;
            basis.five = 0x4563918244f40000;
            basis.six = 0x53444835ec580000;
            int256 result = 0;  
            int256 oneMinusY = basis.one - y; // 50000 
            int256 yDivOneMinusY = y.div(oneMinusY);
            int256 yMinusHalf = y - basis.half;

            // F me hack, cant figure out int to int256 conversion for 1 = 0x0de0b6b3a7640000
            int256 newT = 0;
            if (t == 1) {
                newT = basis.one;
            } else if (t == 2) {
                newT = basis.two;
            } else if (t == 3) {
                newT = basis.three;
            } else if (t == 4) {
                newT = basis.four;
            } else if (t == 5) {
                newT = basis.five;
            } else if (t == 6) {
                newT = basis.six;
            } else { newT = 0;} // will need to go to 16
            int256 tMinusOne = newT - basis.one; // uuuugh newT not t
            // End F me hack,

            int256 tMnusOneDivTwo = tMinusOne.div(basis.two);
            int256 yDivOneMinusYLn = yDivOneMinusY.ln();

            if (t == 1) {
                result = basis.one;
            } else if (t == 2) { 
                result = yDivOneMinusY.ln();  
            } else if (t == 3) {
                result = yMinusHalf.mul(yDivOneMinusYLn);
            } else if (t == 4) {
                result = yMinusHalf;
            } else if (t >= 5 && t % 2 == 1) { // t is odd
                int256 floorTMinusOneDivTwo = tMnusOneDivTwo.floor();
                result = yMinusHalf.pow(floorTMinusOneDivTwo);
            } else if (t >= 6 && t % 2 == 0) {
                int256 floorTMinusOneDivTwo = tMnusOneDivTwo.floor();
                int256 almostThere = yMinusHalf.pow(floorTMinusOneDivTwo);
                result = almostThere.mul(yDivOneMinusYLn);
            }
            return result;
        }    
    
    function getQuantile(int256 forProbability) external view returns (int256) { 
            //int256[] memory storedCoeffs = getACoeffs();
            int256[] memory storedCoeffs = coeffs;
            int256[] memory vectorLocal = new int256[](storedCoeffs.length);
            int256 answer;
            
            for (uint256 n = 0; n < storedCoeffs.length; n++) { //
                 int256 coeffPosition = int256(n+1);  // basis is 1 indexed, converting explicitly here couldn't get next line to work otherwise
                // ?? why is int256(i) showing 1 vs 100000000
                answer += (basis(forProbability, coeffPosition)) * storedCoeffs[n];
            }
            return answer / (10 ** 18); // convert to decimal
    }
}
