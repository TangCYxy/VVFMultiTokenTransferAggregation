// console.log(path);
const aggregations = artifacts.require("VVFMultiTokenTransferAggregation");

module.exports = function (deployer) {
  deployer.deploy(aggregations);
};
