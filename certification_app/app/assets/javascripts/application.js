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

tokens = ["18f9090ae22541768e5311cfa19fe96c", "403f37d1cfd74ce9ad6622e9f0a8207f"]
token = tokens[0]
url = "https://api.blockcypher.com/v1/eth/main/addrs"
final_url = url+"?token=" + token

fetch(final_url, {method: 'POST'}).then( res => res.json()).then(res => console.log(res))
