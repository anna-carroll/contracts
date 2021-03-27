async function deployProxyWithImplementation(
  implementationName,
  initializationCallData,
) {
  const signerArray = await ethers.getSigners();
  const signer = signerArray[0];

  const Implementation = await ethers.getContractFactory(implementationName);
  const implementation = await Implementation.deploy();
  await implementation.deployed();

  // Deploy UpgradeBeacon
  const UpgradeBeacon = await ethers.getContractFactory('UpgradeBeacon');
  const upgradeBeacon = await UpgradeBeacon.deploy(
    implementation.address,
    signer.address,
  );
  await upgradeBeacon.deployed();

  // Deploy Proxy Contract (upgradeBeacon = UpgradeBeacon)
  const Proxy = await ethers.getContractFactory('UpgradeBeaconProxy');
  const proxyWithoutImplementationInterface = await Proxy.deploy(
    upgradeBeacon.address,
    initializationCallData,
  );
  await proxyWithoutImplementationInterface.deployed();

  // instantiate proxy with Proxy Contract address + Implementation interface
  const proxy = new ethers.Contract(
    proxyWithoutImplementationInterface.address,
    Implementation.interface,
    signer,
  );

  return {
    contracts: {
      implementation,
      upgradeBeacon,
      proxyWithoutImplementationInterface,
      proxy,
    },
    factories: {
      Implementation,
      UpgradeBeacon,
      Proxy,
    },
  };
}

module.exports = {
  deployProxyWithImplementation,
};
