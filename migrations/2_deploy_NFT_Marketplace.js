const NFTMarketplace = artifacts.require("NFTMarketplace");

module.exports = function (deployer) {
    deployer.deploy(NFTMarketplace, "0xC2eb01369CBC71a63a19cd726Fe62Fc9eA243C9A");
}


/**
 * before deploy this contract:
 * deploy MyUSDT contract - migrate specific file use: truffle migrate --f 2 --to 2
 * note: NFTMarketplace has two parameters so, we need to add value of the second parameters 
 * Example: deployer.deploy(NFTMarketplace, 0xC2eb01369CBC71a63a19cd726Fe62Fc9eA243C9A);
 */