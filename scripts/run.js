const main = async () => {
  // In order to deploy something to the blockchain, we need a wallet address
  const [owner, randomPerson] = await hre.ethers.getSigners()
  
  const waveContractFactory = await hre.ethers.getContractFactory('WavePortal')
  const waveContract = await waveContractFactory.deploy({ 
    value: hre.ethers.utils.parseEther('0.1'),
  })
  await waveContract.deployed()

  console.log('Contract addy:', waveContract.address)

  let contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  console.log('Contract Balance', hre.ethers.utils.formatEther(contractBalance));

  const waveTxn = await waveContract.connect(owner).wave('itsPanicky: This is wave #1');
  await waveTxn.wait();

  const waveTxn2 = await waveContract.connect(randomPerson).wave('Stranger 1: This is wave #2');
  await waveTxn2.wait();

  const waveTxn3 = await waveContract.connect(randomPerson).wave('Stranger 1: This is wave #3');
  await waveTxn3.wait();

  contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  console.log(
    'Contract balance:',
    hre.ethers.utils.formatEther(contractBalance)
  );

  let allWaves = await waveContract.getAllWaves();
  console.log(allWaves);
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
