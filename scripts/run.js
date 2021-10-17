const main = async () => {
  // In order to deploy something to the blockchain, we need:
  // 1. wallet address
  // 2. ???
  const [owner, randomPerson] = await hre.ethers.getSigners()
  const waveContractFactory = await hre.ethers.getContractFactory('WavePortal')
  const waveContract = await waveContractFactory.deploy()
  await waveContract.deployed()

  console.log('Contract deployed to:', waveContract.address)
  console.log('Contract deployed by:', owner.address)

  let waveCount
  let waveTxn

  waveCount = await waveContract.getTotalWaves()

  waveTxn = await waveContract.wave()
  await waveTxn.wait()

  waveCount = await waveContract.getTotalWaves()

  waveTxn = await waveContract.connect(randomPerson).wave()
  await waveTxn.wait()

  waveCount = await waveContract.getTotalWaves()

  waveTxn = await waveContract.connect(randomPerson).wave()
  await waveTxn.wait()

  waveCount = await waveContract.getTotalWaves()
}

const runMain = async () => {
  try {
    await main()
    process.exit(0)
  } catch (error) {
    console.log(error)
    process.exit(1)
  }
}

runMain()

// npx hardhat run scripts/run.js
// 1. creates a new local Ethereum network
// 2. deploys 'waveContract' contract
// 3. destroys local network when script ends
