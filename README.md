# Using ๐ Scaffold-ETH to create a metalog smart contract

> everything you need to build on Ethereum! ๐

๐งช Quickly experiment with Solidity using a frontend that adapts to your smart contract:

![image](https://user-images.githubusercontent.com/2653167/124158108-c14ca380-da56-11eb-967e-69cde37ca8eb.png)


# ๐โโ๏ธ Quick Start

Prerequisites: [Node (v16 LTS)](https://nodejs.org/en/download/) plus [Yarn](https://classic.yarnpkg.com/en/docs/install/) and [Git](https://git-scm.com/downloads)

> clone/fork ๐ scaffold-eth:

```bash
git clone https://github.com/scaffold-eth/scaffold-eth.git
```

> install and start your ๐ทโ Hardhat chain:

```bash
cd scaffold-eth
yarn install
yarn chain
```

> in a second terminal window, start your ๐ฑ frontend:

```bash
cd scaffold-eth
yarn start
```

> in a third terminal window, ๐ฐ deploy your contract:

```bash
cd scaffold-eth
yarn deploy
```

๐ Edit your smart contract `YourContract.sol` in `packages/hardhat/contracts`

๐ Edit your frontend `App.jsx` in `packages/react-app/src`

๐ผ Edit your deployment scripts in `packages/hardhat/deploy`

๐ฑ Open http://localhost:3000 to see the app


---

๐ Please check out [Gitcoin grant](https://gitcoin.co/grants/2851/scaffold-eth) to support scaffold-eth. They did all the hard work.

