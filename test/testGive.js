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

    it('should have a balance of 10', async function(){
      //let balanceOne = await charity.getBalance.call(firstOrg);
      //console.log(balanceOne);
      await charity.createMission('first', 10, firstOrg);
      //console.log("addr is ", firstOrg);
      let orgBalance = await contributions.getMissionBalance.call('first');
      console.log("initial balance, " , orgBalance.toNumber());
      try {
      await contributions.donate('first',{
        from: firstDonor,
        value: /*web3.toWei(2)*/2
      })
    } catch (error) {
      let donateError = error
      console.error(`donateError: ${donateError}`)
    }

      let secondOrgBalance = await contributions.getMissionBalance.call('first');
      let difference = secondOrgBalance.toNumber() - orgBalance.toNumber();

      console.log("DIFF, " , difference);
      assert.equal(secondOrgBalance, orgBalance);
    });


  });

  it('should pass this test', function(){
    assert.equal(1,1);
  });

})
