// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.4;

import "prb-math/contracts/PRBMathSD59x18.sol";

// SAMPLE DATA
//0x06f05b59d3b20000 === 0.5 //0x0c59ea48da190000 === 0.89 for the probbility input
//["-0x062838e0865204ea","0x045c937afddaa9d2","-0x06632bf1c33f2d08","0x074b2caf2eb6469c","0x1d5c4ea2451ac020"] for the aCoeffs
// https://sipmath.network/libraries/Canonical%20Library%20Page.htm  

contract MetaLog {
    using PRBMathSD59x18 for int256; 
    // GLOBALS
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

    function basis(int256 y, int256 t) internal pure returns (int256 result) {
            BasisDefaults memory basisConst;
            basisConst.half = 0x06f05b59d3b20000;       
            basisConst.one = 0x0de0b6b3a7640000;
            basisConst.two = 0x1bc16d674ec80000;
            basisConst.three = 0x29a2241af62c0000;
            basisConst.four = 0x3782dace9d900000;
            basisConst.five = 0x4563918244f40000;
            basisConst.six = 0x53444835ec580000;
            int256 oneMinusY = basisConst.one - y; // 50000 
            int256 yDivOneMinusY = y.div(oneMinusY);
            int256 yMinusHalf = y - basisConst.half;

            // F me hack, cant figure out int to int256 conversion for 1 = 0x0de0b6b3a7640000
            int256 newT = 0;
            if (t == 1) {
                newT = basisConst.one;
            } else if (t == 2) {
                newT = basisConst.two;
            } else if (t == 3) {
                newT = basisConst.three;
            } else if (t == 4) {
                newT = basisConst.four;
            } else if (t == 5) {
                newT = basisConst.five;
            } else if (t == 6) {
                newT = basisConst.six;
            } else { newT = 0;} // TODO IMPORTANT will need to go to 16 if this hack stays here
            int256 tMinusOne = newT - basisConst.one; // uuuugh newT not t
            // End F me hack

            int256 tMnusOneDivTwo = tMinusOne.div(basisConst.two);
            int256 yDivOneMinusYLn = yDivOneMinusY.ln();

            if (t == 1) {
                result = basisConst.one;
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
    
    function getQuantile(int256 forProbability, int256[] memory aCoeffs) external pure returns (int256 answer) {
            for (uint256 n = 0; n < aCoeffs.length; n++) { //
                int256 coeffPosition = int256(n+1);  // basis is 1 indexed
                answer += (basis(forProbability, coeffPosition)) * aCoeffs[n];
            }
            return answer / (10 ** 18); // convert to decimal
    }
}
