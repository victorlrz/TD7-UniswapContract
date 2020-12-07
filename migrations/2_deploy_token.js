const GLDToken = artifacts.require("./GLDToken");

module.exports = function (deployer) {
    deployer.deploy(GLDToken)
};

// truffle migrate -f 1 --to 2, to migrate specific files
// let m2 = web3.utils.toWei("0.1","ether")
// let m1 = web3.utils.toWei("5","ether")
// x1.depositToUniswapPool(m1,m2,m2,"0x16f8E8a2bFF91679f81230582Ed3704Df049B06a", 1607399000)

// 100000000000000000
// 1607390000

// 0x25C56a272Ebb1eb870Bedb57675c2BC5fa2C4f1C

