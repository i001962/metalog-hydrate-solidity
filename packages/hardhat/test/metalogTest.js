const { ethers } = require("hardhat");
const { use, expect } = require("chai");
const { solidity } = require("ethereum-waffle");

use(solidity);

describe("Metalog contract tests", function () {
  let myContract;

  // quick fix to let gas reporter fetch data from gas station & coinmarketcap
  before((done) => {
    setTimeout(done, 2000);
  });

  describe("MetaLog", function () {
    it("Should deploy MetaLog", async function () {
      const MetaLog = await ethers.getContractFactory("MetaLog");

      myContract = await MetaLog.deploy();
    });

    describe("Testing functions ", function () {
        it("getHdrRandom", async function () {
            const entityId = "0x0de0b6b3a7640000";
            const varId = "0x0de0b6b3a7640000";
            const option1 = "0x1bc16d674ec80000";
            const option2 = "0x1bc16d674ec80000";
            const pmIndex = "0x0de0b6b3a7640000";
            await myContract.getHdrRandom(entityId, varId, option1, option2, pmIndex);
            
            //expect(await myContract.getHdrRandom(entityId, varId, option1, option2, pmIndex)).to.equal("911532170604914426");
            expect(await myContract.getHdrRandom(entityId, varId, option1, option2, pmIndex)).to.equal("781865267781540751");
        });
                                                                                                        
        it("getQuantile from probability - unbounded", async function () {
            const forProbability = "0x0c59ea48da190000";
            const aCoeffs = ["-0x062838e0865204ea","0x045c937afddaa9d2","-0x06632bf1c33f2d08","0x074b2caf2eb6469c","0x1d5c4ea2451ac020"];
            const boundedness = "un";
            const lowerBound = "0x0000000000000000000000000000000000000000000000000000000000000000";
            const upperBound = "0x0000000000000000000000000000000000000000000000000000000000000000";
            await myContract.getQuantile(forProbability, aCoeffs, boundedness, lowerBound, upperBound);
            expect(await myContract.getQuantile(forProbability, aCoeffs, boundedness, lowerBound, upperBound)).to.equal("364897606973277088");
        });
        
        it("getQuantile from probability - bounded lower", async function () {
            const forProbability = "0x0c59ea48da190000";
            const aCoeffs = ["-0x062838e0865204ea","0x045c937afddaa9d2","-0x06632bf1c33f2d08","0x074b2caf2eb6469c","0x1d5c4ea2451ac020"];
            const boundedness = "bl";
            const lowerBound = "0x0000000000000000000000000000000000000000000000000000000000000000";
            const upperBound = "0x0000000000000000000000000000000000000000000000000000000000000000";
            await myContract.getQuantile(forProbability, aCoeffs, boundedness, lowerBound, upperBound);
            expect(await myContract.getQuantile(forProbability, aCoeffs, boundedness, lowerBound, upperBound)).to.equal("1440366517111041693");
        });

        it("getQuantile from probability - bounded upper", async function () {
            const forProbability = "0x0c59ea48da190000";
            const aCoeffs = ["-0x062838e0865204ea","0x045c937afddaa9d2","-0x06632bf1c33f2d08","0x074b2caf2eb6469c","0x1d5c4ea2451ac020"];
            const boundedness = "bu";
            const lowerBound = "0x0000000000000000";
            const upperBound = "0x4563918244f40000";
            await myContract.getQuantile(forProbability, aCoeffs, boundedness, lowerBound, upperBound);
            expect(await myContract.getQuantile(forProbability, aCoeffs, boundedness, lowerBound, upperBound)).to.equal("4305732264586578601");
        });

        it("getQuantile from probability - bounded", async function () {
            const forProbability = "0x0c59ea48da190000";
            const aCoeffs = ["-0x062838e0865204ea","0x045c937afddaa9d2","-0x06632bf1c33f2d08","0x074b2caf2eb6469c","0x1d5c4ea2451ac020"];
            const boundedness = "b";
            const lowerBound = "0x0000000000000000";
            const upperBound = "0x4563918244f40000";
            await myContract.getQuantile(forProbability, aCoeffs, boundedness, lowerBound, upperBound);
            expect(await myContract.getQuantile(forProbability, aCoeffs, boundedness, lowerBound, upperBound)).to.equal("2951127437234671040");
        });
    });
  });
});
