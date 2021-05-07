const { waffle, ethers } = require('hardhat');
const { provider } = waffle;
const { expect } = require('chai');

const { deployUpgradeSetupAndProxy } = require('../scripts/deploy');
const { testCases } = require('./testCases/receiveAndFallback.json');

const RESULT_STRINGS = {
  receive: 'Receive function',
  fallback: 'Fallback function ',
  revert: 'Reverts ',
};

describe('Receive and Fallback', async () => {
  for (let testCase of testCases) {
    const {
      testCaseDescription,
      contractName,
      valueOnlyResult,
      dataAndValueResult,
      dataOnlyResult,
    } = testCase;

    describe(testCaseDescription, async () => {
      let proxy, signer;
      const value = ethers.BigNumber.from(1000);

      before(async () => {
        [signer] = provider.getWallets();
        const contracts = await deployUpgradeSetupAndProxy(contractName);
        proxy = contracts.proxyWithImplementation;
      });

      async function expectResult(result, transactionPromise) {
        if (result == 'receive') {
          await expect(transactionPromise).to.emit(proxy, 'Receive');
        } else if (result == 'fallback') {
          await expect(transactionPromise).to.emit(proxy, 'Fallback');
        } else if (result == 'revert') {
          await expect(transactionPromise).to.be.reverted;
        }
      }

      it(
        'Value non-zero + data null     -> ' + RESULT_STRINGS[valueOnlyResult],
        async () => {
          const transactionPromise = signer.sendTransaction({
            to: proxy.address,
            value,
          });

          await expectResult(valueOnlyResult, transactionPromise);
        },
      );

      it(
        'Value non-zero + data present  -> ' +
          RESULT_STRINGS[dataAndValueResult],
        async () => {
          const transactionPromise = signer.sendTransaction({
            to: proxy.address,
            data: '0x1234',
            value,
          });

          await expectResult(dataAndValueResult, transactionPromise);
        },
      );

      it(
        'Value zero     + data present  -> ' + RESULT_STRINGS[dataOnlyResult],
        async () => {
          const transactionPromise = signer.sendTransaction({
            to: proxy.address,
            data: '0x1234',
          });

          await expectResult(dataOnlyResult, transactionPromise);
        },
      );
    });
  }
});
