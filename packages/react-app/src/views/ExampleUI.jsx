import { Button, Card, DatePicker, Divider, Input, Progress, Slider, Spin, Switch } from "antd";
import React, { useState } from "react";
import { utils } from "ethers";
import { SyncOutlined } from "@ant-design/icons";

import { Address, Balance, Events } from "../components";
import { fromBn, toBn } from "evm-bn";
import { ln, pow, mul, exp } from "prb-math";

import { BigNumber } from "bignumber.js";

export default function ExampleUI({
  purpose,
  quantile,
  address,
  mainnetProvider,
  localProvider,
  yourLocalBalance,
  price,
  tx,
  readContracts,
  writeContracts,
}) {
  const [newLN, setNewLN] = useState(0.0);
  // just testing to from Bn
  (async function () {
    const x7 = toBn("383");
    const x8 = toBn("99991");
    const x9 = toBn("7440893");
    const x10 = toBn("7580");
    const x11 = toBn("7560584");
    const x12 = toBn("17669");
    const x13 = toBn("7440893");
    const x14 = toBn("1343");
    const x15 = toBn("4658");
    const x16 = toBn("7450581");


    //const result = ln(x);
    //console.log('result:', fromBn(result));
    let x1 = new BigNumber(123.4567);
    let y = BigNumber('8.0'); //0x6f05b59d3b200000
    console.log("x7:", x7);
    console.log("x8:", x8);
    console.log("x9:", x9);
    console.log("x10:", x10);
    console.log("x11:", x11);
    console.log("x12:", x12);
    console.log("x13:", x13);
    console.log("x14:", x14);
    console.log("x15:", x15);
    console.log("x16:", x16);
    console.log(fromBn('7142857142857142857143000'));

  })();


  return (
    <div>
      {/*
        ⚙️ Here is an example UI that displays and sets the purpose in your smart contract:
      */}
      <div style={{ border: "1px solid #cccccc", padding: 16, width: 400, margin: "auto", marginTop: 64 }}>
        <h2>Example UI:</h2>
        <h4>LN: {(quantile === undefined)?<p>Not Set Yet</p>:<p>{fromBn(quantile)}</p>}</h4>
        <Divider />
        <div style={{ margin: 8 }}>
          <Input
            onChange={e => {
              setNewLN(toBn(e.target.value.toString()));
            }}
          />
          <Button
            style={{ marginTop: 8 }}
            onClick={async () => {
              /* look how you call setPurpose on your contract: */
              /* notice how you pass a call back for tx updates too */
              const result = tx(writeContracts.MetaLog.setLN(newLN), update => {
                console.log("📡 Transaction Update:", update);
                if (update && (update.status === "confirmed" || update.status === 1)) {
                  console.log(" 🍾 Transaction " + update.hash + " finished!");
                  console.log(
                    " ⛽️ " +
                      update.gasUsed +
                      "/" +
                      (update.gasLimit || update.gas) +
                      " @ " +
                      parseFloat(update.gasPrice) / 1000000000 +
                      " gwei",
                  );
                }
              });
              console.log("awaiting metamask/web3 confirm result...", result);
              console.log(await result);
            }}
          >
            Set LN!
          </Button>
        </div>
        <Divider />
        Your Address:
        <Address address={address} ensProvider={mainnetProvider} fontSize={16} />
        <Divider />
       
        <Divider />
        
        <h2>Your Balance: {yourLocalBalance ? utils.formatEther(yourLocalBalance) : "..."}</h2>
        <Divider />
        Your Contract Address:
        <Address
          address={readContracts && readContracts.YourContract ? readContracts.YourContract.address : null}
          ensProvider={mainnetProvider}
          fontSize={16}
        />
        <Divider />

      </div>

      {/*
        📑 Maybe display a list of events?
          (uncomment the event and emit line in YourContract.sol! )
      */}
      <Events
        contracts={readContracts}
        contractName="MetaLog"
        eventName="SetLN"
        localProvider={localProvider}
        mainnetProvider={mainnetProvider}
        startBlock={1}
      />

          </div>
  );
}
