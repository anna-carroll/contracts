async function upgradeToImplementation(
  upgradeBeacon,
  signer,
  newImplementationName,
) {
  const NewImplementation = await ethers.getContractFactory(
    newImplementationName,
  );
  const newImplementation = await NewImplementation.deploy();
  await newImplementation.deployed();

  const upgradeTransaction = {
    to: upgradeBeacon.address,
    data: ethers.utils.hexZeroPad(newImplementation.address, 32),
  };

  await signer.sendTransaction(upgradeTransaction);
}

module.exports = {
  upgradeToImplementation,
};
