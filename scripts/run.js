const main = async () => {
  // In order to deploy something to the blockchain, we need:
  // 1. wallet address

  const [owner, randomPerson] = await hre.ethers.getSigners()
  const waveContractFactory = await hre.ethers.getContractFactory('WavePortal')
  const waveContract = await waveContractFactory.deploy({ 
    value: hre.ethers.utils.parseEther('0.1'),
  })
  await waveContract.deployed()

  console.log('Contract addy:', waveContract.address)

  let contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  console.log('Contract Balance', hre.ethers.utils.formatEther(contractBalance));

  let waveCount
  let waveTxn

  waveCount = await waveContract.getTotalWaves()

  waveTxn = await waveContract.wave('A message!')
  await waveTxn.wait()
  contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  console.log(
    'Contract balance:',
    hre.ethers.utils.formatEther(contractBalance)
  );

  waveCount = await waveContract.getTotalWaves()

  waveTxn = await waveContract.connect(randomPerson).wave('Another message!')
  await waveTxn.wait()

  waveCount = await waveContract.getTotalWaves()

  waveTxn = await waveContract.connect(randomPerson).wave('A third message!')
  await waveTxn.wait()

  waveCount = await waveContract.getTotalWaves()

  let allWaves = await waveContract.getAllWaves()
  console.log(allWaves)
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
