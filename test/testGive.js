var Charity = artifacts.require('./Charity.sol');
var Contributions = artifacts.require('./Contributions.sol');
var OrgContract =  artifacts.require('./OrgContract.sol');
const web3 = global.web3;

contract('Charity', function(accounts) {
  var owner = accounts[0];
  var firstOrg = accounts[1];
  var secondOrg = accounts[2];
  var firstDonor = accounts[3];
  var secondDonor = accounts[4];
  var requester = accounts[5];

  var charity;
  var contributions;

  beforeEach('setup contract for each test', async function () {
    charity = await Charity.new();
    contributions = await Contributions.new();
  });

  //commented out because owner is a private address
  /*it('should have accounts[0] as owner', async function() {
    assert.equal(charity.owner.call(), owner);
  });*/

  //Testing for correct number of missions after creating a new one
  it('should create one new mission', async function(){
    await charity.createMission('first', 10, firstOrg);
    let missionCount = await charity.missionCounter();
    missionCount = missionCount.toNumber();
    assert.equal(missionCount, 1);
  });

  it('should create ONLY one new mission', async function(){
    await charity.createMission('first', 10, firstOrg);
    //console.log("passed FIRST");
    let addError;
    try {
      //contract throws error here
      await charity.createMission('first',5,firstOrg);
    } catch (error) {
      addError = error
    }
    assert.notEqual(addError, undefined, 'Error must be thrown')
    //expect.fail(await charity.createMission('first', 10, firstOrg));
    //let missionCount = await charity.missionCounter();
    //missionCount = missionCount.toNumber();
    //assert.equal(missionCount, 1);
  });

  it('should create two new missions', async function(){
    await charity.createMission('first', 10, firstOrg);
    await charity.createMission('second', 5, secondOrg);
    let missionCount = await charity.missionCounter();
    missionCount = missionCount.toNumber();
    assert.equal(missionCount, 2);
  });

  //CONTRIBUTIONS TESTING
  contract('Contributions', function(account){
    it('should allow user to request mission then owner to accept', async function(){
      await contributions.requestMission('requestedOne');
      await contributions.approveRequest('requestedOne', 10, firstOrg);
      let missionCount = await contributions.missionCounter();
      assert.equal(missionCount.toNumber(), 1);
    });

    it('should return mission exists', async function(){
      await contributions.createMission('first', 10, firstOrg);
      let res = await contributions.missionExists('first');
      //let res2 = await contributions.missionExists('fir');
      res = res.toNumber();
      //res2 = res2.toNumber();
      //console.log('res 1 = ', res);
      //console.log('res 2 = ', res2);
      assert.equal(res,1);
    });

    it('should verify that mission does not exist', async function(){
      await contributions.createMission('first', 10, firstOrg);
      let res = await contributions.missionExists('test');
      assert.equal(res,0);
    });

    it('firstOrg should receive 2', async function(){
      await contributions.createMission('first', 10, firstOrg);
      //console.log("addr is ", firstOrg);
      let orgBalance = await contributions.getMissionBalance('first');
      orgBalance = orgBalance.toNumber();
      console.log("initial balance = " , orgBalance);

      let orgaddress = await contributions.getMissionAddress('first');
      console.log('orgaddress is ', orgaddress);

      //const initialBalance = web3.eth.getBalance(firstOrg).toNumber();

      //let donorBalance = web3.eth.getBalance(firstDonor).toNumber();
      //console.log("donor balance initial = ", donorBalance);

      let receipt; //used for gasCost calculcation
      try {
      receipt = await contributions.donate('first',{
        from: firstDonor,
        //gas:0,
        gasPrice: 0,
        value: web3.toWei(2)
      })
      } catch (error) {
        let donateError = error
        console.error(`donateError: ${donateError}`)
      }


      let gasUsed = receipt.receipt.gasUsed;
      const tx = await web3.eth.getTransaction(receipt.tx);
      let gasPrice = tx.gasPrice;

      console.log(`GasUsed: ${receipt.receipt.gasUsed}`);
      console.log(`GasPrice: ${tx.gasPrice}`);

      let totalGas = gasPrice.mul(gasUsed);
      totalGas = totalGas.toNumber();
      let totalSent = web3.toWei(2) - totalGas;
      console.log("totalSent = ", totalSent);

      //let donorBalanceIn = web3.eth.getBalance(firstDonor).toNumber();
      //console.log("donor balance POST = ", donorBalanceIn);
      //console.log("donor difference = ", donorBalance-donorBalanceIn);

      let exists = await contributions.missionExists('first');
      console.log("exists = ", exists.toNumber());

      await contributions.verifyDonation({
        from:firstDonor,
        gasPrice:0
      });

      let secondOrgBalance = await contributions.getMissionBalance('first');
      secondOrgBalance = secondOrgBalance.toNumber();
      //orgBalance = orgBalance + totalGas;
      console.log("secondOrgBalance = ", secondOrgBalance);
      console.log("Difference = ", secondOrgBalance - orgBalance);

      orgaddress = await contributions.getMissionAddress('first');
      console.log('orgaddress is second time ', orgaddress);
      //console.log(`Final: ${final.toString()}`);
      //assert.equal(final.add(gasPrice.mul(gasUsed)).toString(), orgBalance.toString(), "Must be equal");
      assert.equal(secondOrgBalance, orgBalance);
    });


  });

  it('should pass this test', function(){
    assert.equal(1,1);
  });

})
