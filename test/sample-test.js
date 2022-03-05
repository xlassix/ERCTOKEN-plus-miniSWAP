const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("swap", function () {
  it(" SpaceCoin text", async function () {
    const  SpaceCoin = await ethers.getContractFactory("SpaceToken");
    const  spaceCoin = await  SpaceCoin.deploy();
    await spaceCoin.deployed();


    const  ExchangeICO= await ethers.getContractFactory("ExchangeICO");
    const  exchangeICO = await  ExchangeICO.deploy();
    await exchangeICO.deployed();

    const tokenAddress =(spaceCoin.address)

    const [seller, buyer] = await ethers.getSigners();   
    const buyerAddress = await buyer.address;
    const sellerAddress = await seller.address;

    console.debug(buyerAddress,sellerAddress);


    const exchangeAmount = ethers.utils.parseUnits("10", "ether");
    spaceCoin.transfer(exchangeICO.address,exchangeAmount);

    const rate =2
    var transaction= await exchangeICO.setRate(tokenAddress,rate)
    await transaction.wait()

    const amount = ethers.utils.parseUnits("2", "ether");


  
    transaction = await exchangeICO.connect(buyer).swap(tokenAddress,{value:amount});
    await transaction.wait()


    var buyersBalance=parseInt(await spaceCoin.balanceOf(buyerAddress))

    expect(buyersBalance).to.equal(amount*rate);


  });
});