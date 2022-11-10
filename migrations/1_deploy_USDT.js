const MyUSDT = artifacts.require("MyUSDT");

module.exports = function (deployer) {
    deployer.deploy(MyUSDT);
}


// Remember: artifacts.require take the name of the contract not the name of file.sol