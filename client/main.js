/** Connect to Moralis server */
const serverUrl = "https://19gni7omnfcc.usemoralis.com:2053/server";
const appId = "ZJbYUZ3cIS2UmRe7LO76tNBRqefnqdrZAni3TLtP";


Moralis.start({ serverUrl, appId });
const CONTRACT_ADDRESS = "0x6AF49fbAe882a0ce6942a5252CF3D00F3a70C43f";
const web3 = new Web3("HTTP://127.0.0.1:7545"); // required without node js

/** Add from here down */
async function login() {
  let user = Moralis.User.current();
  
   try {
    if (!user) {
      user = await Moralis.authenticate({ signingMessage: "Hello World!" })
      console.log(user)
      console.log(user.get('ethAddress'))
    }
    renderGame();
   } catch(error) {
     console.log(error)
   }
  
  //renderGame();
}

async function logOut() {
  await Moralis.User.logOut();
  console.log("logged out");
}


async function  renderGame(){
    $("#login_button").hide();
    $("#pet_row").html("");
    let petId = 0;
    //window.web3 = await Moralis.Web3.enable();
    window.web3 = await Moralis.enableWeb3();
    let abi = await getAbi();
    let contract = new web3.eth.Contract(abi, CONTRACT_ADDRESS);
    //console.log(ethereum.selectedAddress);
    let cur_account = (await web3.eth.getAccounts())[0];

    let array = await contract.methods.getAllTokensForUser(cur_account).call({from: cur_account});
    console.log(contract.methods);
    if(array.length == 0) return;
    array.forEach( async (petId) => {
      let details = await contract.methods.getTokenDetails(petId).call({from: ethereum.selectedAddress});
      renderPet(petId, details);
    });
    console.log(array);
    let data = await contract.methods.getTokenDetails(petId).call({from: ethereum.selectedAddress});
    console.log(data);
    $("#game").show();

}

function getAbi(){
    return new Promise( (res) => {
    $.getJSON("Token.json", ( (json) =>{
      console.log(json.abi);
        res(json.abi);
        }))
    })
}



function renderPet(id, data){

  let deathTime = new Date((parseInt(data.lastMeal) + parseInt(data.endurance)) *1000);
    let now = new Date();
    if(now > deathTime){
      deathTime = "<b>Dead<b>";
    }

  let owl = parseInt(id) + 1;

  console.log(owl);
   

  let htmlString = `
  <div class = "col-md-4 card" id="pet-${id}">
  <img class ="card-img-top" src="owl${owl}.jpeg">
  <div class ="card-body">
      <div>Id: <span class = "pet_id">${id}</span></div>
      <div>Damage: <span class = "pet_damage">${data.damage}</span></div>
      <div>Magic: <span class = "pet_magic">${data.magic}</span></div>
      <div>Endurance: <span class = "pet_endurance">${data.endurance}</span></div>
      <div>Time to starvation: <span class = "pet_starvation">${deathTime}</span></div>
      <button data-pet-id="${id}"class = "feed_button" class ="btn btn-primary btn-blick">Feed</button>
  </div>
  </div>`;

  let element = $.parseHTML(htmlString);
  $("#pet_row").append(element);

  $(`#pet-${id} .feed_button`).click( () => {
    //let petId = $("#feed_button").attr("data-pet-id");
    feed(id);
  });

  /*
    $("#pet_id").html(id);
    $("#pet_damage").html(data.damage);
    $("#pet_magic").html(data.magic);
    $("#pet_endurance").html(data.endurance);
    $("#feed_button").attr("data-pet-id", id);
    
   
    $("#pet_starvation").html(deathTime);


    
*/
  
    
}


async function feed(petId){
  let abi = await getAbi();
  let contract = new web3.eth.Contract(abi, CONTRACT_ADDRESS);
  let cur_account = (await web3.eth.getAccounts())[0];
  console.log(cur_account);
  console.log(ethereum.selectedAddress);
  contract.methods.feed(petId).send({from: cur_account}).on("receipt", ( ()=> {
    console.log("done");
    renderGame();

  }))

}





document.getElementById("btn-login").onclick = login;
document.getElementById("btn-logout").onclick = logOut;

/** Useful Resources  */

// https://docs.moralis.io/moralis-server/users/crypto-login
// https://docs.moralis.io/moralis-server/getting-started/quick-start#user
// https://docs.moralis.io/moralis-server/users/crypto-login#metamask

/** Moralis Forum */

// https://forum.moralis.io/