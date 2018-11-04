var Charity = artifacts.require('./Charity.sol');

contract('Charity', function(accounts) {
  var owner = accounts[0];
  var firstOrg = accounts[1];
  var secondOrg = accounts[2];
  var firstDonor = accounts[3];
  var secondDonor = accounts[4];

  //var charity;

  /*beforeEach('setup contract for each test', async function () {
          charity = await Charity.new();
  });

  it('should have a valid owner', async function() {
    assert.equal(charity.owner(), owner);
  });

  it('should create new mission', async function(){
    var first = 'first';
    await charity.createMission(first, 10, firstOrg);
    assert.equal(1,1);
  });*/

  it('should create new mission', async function(){
    let charity = await Charity.deployed();
    await charity.createMission('first', 10,firstOrg);
    let missionCount = await charity.missionCounter.call();
    console.log(charity.missionCounter());
    assert.equal(missionCount, 1);
  })

  it('should pass this test', function(){
    assert.equal(1,1);
  });

})
