// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.4;

import "prb-math/contracts/PRBMathSD59x18.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract MetaLog {
    using PRBMathSD59x18 for int256; 
    event GetQuantile(address sender, int256 quantile);
    // GLOBALS
    int256 public quantile;    //0x06f05b59d3b20000 === 0.5
                               //0x0c59ea48da190000 === 0.89
//["-0x062838e0865204ea","0x045c937afddaa9d2","0x045c937afddaa9d2","0x074b2caf2eb6469c","0x1d5c4ea2451aaf2"]
    int256[] internal coeffs;
    // I haven't learned how to avoid this need for BigNumbers yet
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
    function setACoeffs(int256[] memory theCoeffs) public {
        coeffs = theCoeffs;
    }
    
    function getACoeffs() public view returns (int256[] memory) {
        return coeffs;
    }    

    function basis(int256 y, int256 t) internal view returns (int256)
        {
            console.log("basisFn: t");
            console.logInt(int256(t));
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

            int256 tMinusOne = newT - basis.one; // uuuugh netT not t
            int256 tMnusOneDivTwo = tMinusOne.div(basis.two);
            int256 yDivOneMinusYLn = yDivOneMinusY.ln();

            /*
            console.log("t is processing value  ");
            console.logInt(t);
            console.log("one - y ");
            console.logInt(oneMinusY);
            console.log("y ");
            console.logInt(y);
            console.log("yDivOneMinusY = y / oneMinusY");
            console.logInt(yDivOneMinusY);
            console.log("(t-1) / basis.two "); // just for ref
            console.logInt(tMnusOneDivTwo);
            */

            if (t == 1) { // 1
                result = basis.one;
                console.log("You are 1 coeff ");
            } else if (t == 2) { // 2      
                result = yDivOneMinusY.ln();  //20907411=ln(8090909)
                console.log("You are 2 ");            
            } else if (t == 3) {
                result = yMinusHalf.mul(yDivOneMinusYLn);
                console.log("Coeff 3 ");
            } 
            else if (t == 4) {
                result = yMinusHalf;
                console.log("coeff 4 "); // just for ref
            } else if (t >= 5 && t % 2 == 1) { // t is odd
                int256 floorTMinusOneDivTwo = tMnusOneDivTwo.floor();
                result = yMinusHalf.pow(floorTMinusOneDivTwo);
                console.log("coeff 5 "); // just for ref
            } else if (t >= 6 && t % 2 == 0) {
                int256 floorTMinusOneDivTwo = tMnusOneDivTwo.floor();
                int256 almostThere = yMinusHalf.pow(floorTMinusOneDivTwo);
                result = almostThere.mul(yDivOneMinusYLn);
                console.log("coeff 6 "); // just for ref
            }
            console.log("Returning result ");
            console.logInt(result);
            return result;
        }

    //function setLN(int256 forProbability, int256[5] calldata inputCoeffs)
    function getQuantile(int256 forProbability)
    public  { 
         int256[] memory storedCoeffs = getACoeffs();
         console.log('test ', storedCoeffs.length);
         for (uint256 n = 0; n < storedCoeffs.length; n++) {
            console.logInt(storedCoeffs[n]);
        }
    
        uint256 i = 0;
        while (i < storedCoeffs.length) {
             i++; // basis is 1 indexed
            console.log(i);
            int256 newI = int256(i); // converting explicitly here couldn't get next line to work otherwise
            quantile = basis(forProbability, newI); // ?? why is int256(i) showing 1 vs 100000000
            // need to fill array with return values of basisFn
        }
    
        emit GetQuantile(msg.sender, quantile);
    }

}
