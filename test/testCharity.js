/*var Charity = artifacts.require('./Charity.sol');
var Contributions = artifacts.require('./Contributions.sol');

contract('Charity', function(accounts) {
  var owner = accounts[0];
  var firstOrg = accounts[1];
  var secondOrg = accounts[2];
  var firstDonor = accounts[3];
  var secondDonor = accounts[4];
  var requester = accounts[5];

  var charity;

  beforeEach('setup contract for each test', async function () {
          charity = await Charity.deployed();
  });

  /*it('should have a valid owner', async function() {
    assert.equal(charity.owner(), owner);
  });

  //Testing for correct number of missions after creating a new one
  it('should create one new mission', async function(){
    //charity = await Charity.deployed();
    await charity.createMission('first', 10,firstOrg);
    let missionCount = await charity.missionCounter.call();
    await console.log(charity.missionCounter());
    missionCount = missionCount.toNumber();
    await assert.equal(missionCount, 1);
  });

  //CONTRIBUTIONS TESTING
  contract('Contributions', function(){

    it('should allow user to request mission then owner to accept', async function(){
      //charity = await Charity.deployed();
      let contributions = await Contributions.deployed();
      await contributions.requestMission.call('requestingMission');
      await contributions.approveRequest.call('requestingMission');
      let missionCount = await charity.missionCounter.call();
      missionCount = missionCount.toNumber();
      //await console.log(1234);
      //await console.log(missionCount);
      await assert.equal(missionCount, 1);
    });

    it('should return correct mission', async function(){
      let contributions = await Contributions.deployed();
      await contributions.requestMission.call('requesting2');
      await contributions.approveRequest.call('requesting2');
      let orgName = contributions.missions['requesting2'];
      assert.exists(orgName);
    });

  });

  it('should pass this test', function(){
    assert.equal(1,1);
  });

})
*/
