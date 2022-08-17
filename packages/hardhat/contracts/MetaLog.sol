// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.4;

import "prb-math/contracts/PRBMathSD59x18.sol";
import "hardhat/console.sol";

// SAMPLE DATA
//0x06f05b59d3b20000 === 0.5 //0x0c59ea48da190000 === 0.89 for the probbility input
//["-0x062838e0865204ea","0x045c937afddaa9d2","-0x06632bf1c33f2d08","0x074b2caf2eb6469c","0x1d5c4ea2451ac020"] for the aCoeffs
// https://sipmath.network/libraries/Canonical%20Library%20Page.htm  

contract MetaLog {
    using PRBMathSD59x18 for int256; 
    // GLOBALS
    int256[] internal coeffs;
    int256 internal TEMPCONST   = 0x0629b8ce29b60ba2340000;
    int256 internal LARGE_PRIME = 0x0de0b6b3a764000000000000;

    struct BasisDefaults {
        int256 half;
        int256 one; 
        int256 two; 
        int256 three;
        int256 four; 
        int256 five; 
        int256 six;
        int256 seven;
        int256 eight;
        int256 nine;
        int256 ten;
        int256 eleven;
        int256 twelve;
        int256 thirteen;
        int256 fourteen;
        int256 fifteen;
        int256 sixteen;
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
            basisConst.seven = 0x6124fee993bc0000;
            basisConst.eight = 0x6f05b59d3b20000;
            basisConst.nine = 0x7ce66c50e2840000;
            basisConst.ten = 0x8ac7230489e80000;
            basisConst.eleven = 0x98a7d9b8314c0000;
            basisConst.twelve = 0xa688906bd8b00000;
            basisConst.thirteen = 0xb469471f80140000;
            basisConst.fourteen = 0xc249fdd327780000;
            basisConst.fifteen = 0xd02ab486cedc0000;
            basisConst.sixteen = 0xde0b6b3a76400000;

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
            } else if (t == 7) {
                newT = basisConst.seven;
            } else if (t == 8) {
                newT = basisConst.eight;
            } else if (t == 9) {
                newT = basisConst.nine;
            } else if (t == 10) {
                newT = basisConst.ten;
            } else if (t == 11) {
                newT = basisConst.eleven;
            } else if (t == 12) {
                newT = basisConst.twelve;
            } else if (t == 13) {
                newT = basisConst.thirteen;
            } else if (t == 14) {
                newT = basisConst.fourteen;
            } else if (t == 15) {
                newT = basisConst.fifteen;
            } else if (t == 16) {
                newT = basisConst.sixteen;
            }  // IMPORTANT will need to go to 16 if this hack stays here
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
    
    function getQuantile(int256 forProbability, int256[] memory aCoeffs,string memory boundedness, int256 lowerBound, int256 upperBound) external view returns (int256 answer) {
            for (uint256 n = 0; n < aCoeffs.length; n++) { //
                int256 coeffPosition = int256(n+1);  // basis is 1 indexed
                answer += (basis(forProbability, coeffPosition)) * aCoeffs[n];
            }
            if (keccak256(bytes(boundedness)) == keccak256(bytes("bl"))){
                int256 answerHolder = answer / (10 ** 18);
                answer = lowerBound + answerHolder.exp();
            } else if (keccak256(bytes(boundedness)) == keccak256(bytes("bu"))){
                int256 answerHolder = answer / (10 ** 18);
                int256 upperBoundHolder = answerHolder.mul(-0x0de0b6b3a7640000);  // -1
                int256 upperBoundExpHolder = upperBoundHolder.exp();
                answer = upperBound - upperBoundExpHolder;
            } else if (keccak256(bytes(boundedness)) == keccak256(bytes("b"))){
                int256 answerHolder = answer / (10 ** 18);
                answer = lowerBound + (upperBound * answerHolder.exp()) / (0x0de0b6b3a7640000 + answerHolder.exp());
            } else if (keccak256(bytes(boundedness)) == keccak256(bytes("un"))){
                answer = answer / (10 ** 18);
            } 
            return answer; // / (10 ** 18); // convert to decimal
    }

    function getMod(uint256 n, uint256 m) internal pure returns (uint256) {
        uint256 remain = n % m;
        uint256 holdMeNow = 0; //remain.floor();
        return holdMeNow;
    }
    function add(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a + b;
        assert(c >= a);
        return c;
      }

    function mod(int256 numberIn, int256 divisorIn) internal view returns (int256) {
        int256 remainder = (numberIn / (10 ** 18)) % divisorIn;
        console.log("numberIn and divisorIn: " );
        console.logInt(numberIn  / (10 ** 18));
        console.logInt(divisorIn);
        console.log("remainder: " );
        console.logInt(remainder);
        return remainder;
    }

    function getHdrRandom(int256 entityId, int256 varId, int256 option1, int256 option2, int256 pmIndex) external view returns (int256 randi) { 
        // supports 4 variables for sipmath 3.0 standard
        int256 temp111 = (((pmIndex * 0x0211651be2dc371c540000) + (varId * 0x017d42a4efb5c53a2c0000) + (entityId * 0x01a79854466036d7ec0000) + (option1 * 0x017c7b79f1a774e9040000) + (option2 * 0x01e6f5ba79e9218f6c0000)) / (10 ** 18) ) % 0x0629b93d2f6ba8dd540000;
        int256 temp11 = add(TEMPCONST,(temp111.mul(0xfc82bc50dbb9880000)));
        int256 temp1Holder = 0x314dc6448d92a0198151ceb40000 % temp11;
        int256 temp1 = temp1Holder.mul(0x14c33156c76e9c0000) % 0x152c85e174fa13fc0000;
        int256 temp222 = (((pmIndex * 0x01dbb87902b1d4c69c0000) + (varId * 0x01fc37e198201d88440000) + (entityId * 0x01bce05631aafd6ef40000) + (option1 * 0x01963769fc2f1d121c0000) + (option2 * 0x01580cbc4ea4d3f2c40000)) / (10 ** 18)) % 0x0629ced08b76f71acc0000;
        int256 temp22 =(temp222.mul(0x019ae9a1af7054f00000)) + 0x0641041474852c41200000;
        int256 temp2Holder = 0x314dc6448d92a0198151ceb40000 % temp22;
        int256 temp2 = temp2Holder.mul( 0x03bdd6a1fda038f40000) % 0x0627ab9e279744f1d40000;
        int256 temp = temp1.mul(0x0627ab9e279744f1d40000) + temp2;
        int256 temper = temp * 0x48cdde787b259c0000;
        int256 finalHolder =  mod(temper,LARGE_PRIME);
        randi = finalHolder.div(LARGE_PRIME);

        return randi;
    }  
}

