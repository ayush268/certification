// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .

function redirect(url) {
  console.log(url)
  document.location.href = url;
}

function signup() {

  tokens = ["18f9090ae22541768e5311cfa19fe96c", "403f37d1cfd74ce9ad6622e9f0a8207f"]
  token = tokens[0]
  url = "https://api.blockcypher.com/v1/eth/main/addrs"
  final_url = url+"?token=" + token
  
  data = new FormData();
  data.append('authenticity_token', document.getElementsByName('authenticity_token')[0].value)
  data.append('user[name]', document.getElementById('name').value);
  data.append('user[username]', document.getElementById('username').value);
  data.append('user[email]', document.getElementById('email').value);
  data.append('user[password]', document.getElementById('password').value);
  data.append('user[password_confirmation]', document.getElementById('password_confirmation').value);
  data.append('commit', 'Create my account')
  
  window.fetch(final_url, {method: 'POST', credentials: 'omit'}).then( res => res.json()).then(res => {
    data.append('user[public_key]', res['public'])
    data.append('user[public_addr]', res['address'])
    const final_data = new URLSearchParams(data);
    var blob = new Blob([JSON.stringify(res)], {'type': 'application/octet-stream'})
    var a = document.createElement('a')
    a.href = window.URL.createObjectURL(blob)
    a.download = "keep_it_safe.json"
    a.click()
    window.fetch('/signup', {method: 'POST', body: final_data}).then( res => {
      console.log(res)
      redirect_location = res.url
      console.log("Redirecting to ", redirect_location)
      setTimeout(() => redirect(redirect_location), 300)
    })
  })

}

//const EthCrypto = require('eth-crypto');
//
//const publicKey = EthCrypto.publicKeyByPrivateKey(
//      '0x59D8668F2D07D1AD8FDF2E8E224B6A8065C1006E5DE8402CBEC352182A00C35D'
//  );
//
//console.log(publicKey)
//
//const address = EthCrypto.publicKey.toAddress(
//      publicKey
//);
//
//console.log(address)
//
//const message = 'foobar';
//const messageHash = EthCrypto.hash.keccak256(message);
//const signature = EthCrypto.sign(
//    '0x59D8668F2D07D1AD8FDF2E8E224B6A8065C1006E5DE8402CBEC352182A00C35D', // privateKey
//    messageHash // hash of message
//);
