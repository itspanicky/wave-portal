const main = async () => {
  const [deployer] = await hre.ethers.getSigners()
  const accountBalance = await deployer.getBalance()

  console.log('Deploying contracts with account: ', deployer.address)
  console.log('Account balance: ', accountBalance.toString())

  const waveContractFactory = await hre.ethers.getContractFactory('WavePortal')
  const waveContract = await waveContractFactory.deploy({
    value: hre.ethers.utils.parseEther('0.001'),
  })
  await waveContract.deployed()

  // contract address is needed to connect frontend to our wavePortal contract
  console.log('WavePortal address: ', waveContract.address)
}

const runMain = async () => {
  try {
    await main()
    process.exit(0)
  } catch (error) {
    console.error(error)
    process.exit(1)
  }
}

runMain()

// npx hardhat node
// deploys an empty blockchain with 20 dummy accounts (each with 10000 ETH)

// npx hardhat run scripts/deploy.js --network localhost
// deploys contract to the blockchain on localhost

// npx hardhat run scripts/deploy.js --network rinkeby
// deploys contract to the blockchain on rinkeby
// verify on rinkeby.etherscan.io
