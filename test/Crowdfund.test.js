// SPDX-License-Identifier: Apache-2.0
const { waffle } = require('hardhat');
const { provider } = waffle;
const { expect } = require('chai');
const { deployImplementation } = require('../scripts/deploy');

describe('Create Crowdfund', async () => {
  let logic, factory, factory2, signer, operator, fundingRecipient;
  const name = 'Anna Test';
  const symbol = 'ATST';
  const fundingCap = 1;
  const operatorPercent = 5;

  before(async () => {
    [signer] = provider.getWallets();
    operator = signer.address;
    fundingRecipient = signer.address;

    // DEPLOY CROWDFUND LOGIC
    logic = await deployImplementation('CrowdfundLogic');

    // DEPLOY CROWDFUND FACTORIES
    factory = await deployImplementation('CrowdfundFactory', [logic.address]);
    factory2 = await deployImplementation('CrowdfundFactory2', [logic.address]);
  });

  it('Deploys a Crowdfund from original Factory', async () => {
    // DEPLOY CROWDFUND
    await expect(
      factory.createCrowdfund(
        name,
        symbol,
        operator,
        fundingRecipient,
        fundingCap,
        operatorPercent,
      ),
    ).to.emit(factory, 'CrowdfundDeployed');
  });

  it('Deploys a Crowdfund from Factory 2', async () => {
    // DEPLOY CROWDFUND
    await expect(
      factory2.createCrowdfund(
        name,
        symbol,
        operator,
        fundingRecipient,
        fundingCap,
        operatorPercent,
      ),
    ).to.emit(factory2, 'CrowdfundDeployed');
  });
});
