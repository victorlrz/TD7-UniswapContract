const DepositorContract = artifacts.require("./DepositorContract")
const GLDTokenAddress = "";

module.exports = function (deployer) {
    deployer.deploy(DepositorContract, GLDTokenAddress)
};
// truffle migrate -f 3 --to 3, to migrate this specific files
