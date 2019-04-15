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



const fetch = require("node-fetch");
// const crypto = require('crypto')
const crypto = require('@trust/webcrypto')
function signUp(){
    // tokens = ["18f9090ae22541768e5311cfa19fe96c", "403f37d1cfd74ce9ad6622e9f0a8207f"]
    // token = tokens[0]
    // url = "https://api.blockcypher.com/v1/eth/main/addrs"
    // final_url = url+"?token=" + token
    // fetch(final_url, {method: 'POST'}).then( res => res.json()).then(res => console.log(res))
    crypto.subtle.generateKey(
        {
            name: "RSASSA-PKCS1-v1_5",
            modulusLength: 2048, //can be 1024, 2048, or 4096
            publicExponent: new Uint8Array([0x01, 0x00, 0x01]),
            hash: {name: "SHA-256"}, //can be "SHA-1", "SHA-256", "SHA-384", or "SHA-512"
        },
        true, //whether the key is extractable (i.e. can be used in exportKey)
        ["sign", "verify"] //can be any combination of "sign" and "verify"
    )
    // .then(function(key){
    //     //returns a keypair object
    //     console.log(key);
    //     // console.log(key.publicKey);
    //     // console.log(key.privateKey);
    // })
    .then(function(key){
        crypto.subtle.exportKey(
            "jwk", //can be "jwk" (public or private), "spki" (public only), or "pkcs8" (private only)
            // publicKey //can be a publicKey or privateKey, as long as extractable was true
            key.publicKey
        )
        .then(function(keydata){
            //returns the exported key data
            console.log(keydata);
        })
        crypto.subtle.exportKey(
            "jwk", //can be "jwk" (public or private), "spki" (public only), or "pkcs8" (private only)
            // publicKey //can be a publicKey or privateKey, as long as extractable was true
            key.privateKey
        )
        .then(function(keydata){
            //returns the exported key data
            console.log(keydata);
        })
    })

    .catch(function(err){
        console.error(err);
    });
}


//  hash, user_priv_key(submit/upload),
// sign and output hash, and hash signature


function giveSignature(hash, jsonData){
    // console.log(jsonData)
    // let privatePem = fs.readFileSync('PRIVATE_KEY_FILE_PATH_GOES_HERE')
    // let key = jsonData["private"]
    key = jsonData
    // console.log(jsonData)
    var enc = new TextEncoder(); // always utf-8
    hash = enc.encode(hash);
    console.log(hash)
    hash = new ArrayBuffer(16)
    // let key = privatePem.toString('ascii')
    // let sign = crypto.createSign('RSA-SHA256')
    // sign.update(hash)
    // let signature = sign.sign(key, 'hex')
    // const signature = crypto.subtle.sign({name:"RSA-PSS", }, key, hash)
    crypto.subtle.sign(
        {
            name: "RSASSA-PKCS1-v1_5",
        },
        key, //from generateKey or importKey above
        hash //ArrayBuffer of data you want to sign
    )
    .then(function(signature){
        //returns an ArrayBuffer containing the signature
        console.log("got this", new Uint8Array(signature));
    })
    // console.log("1111")
}

// signUp()

console.log("main\n\n\n\n")
a = crypto.subtle.importKey(
    "jwk", //can be "jwk" (public or private), "spki" (public only), or "pkcs8" (private only)
    {   //this is an example jwk key, other key types are Uint8Array objects
        kty: 'RSA',
        alg: 'RS256',
        n:
         'vuRAU_9J64zAENc_OvOna1QsctCT-Jie8qxUf9k1Byr-yQ5NfcXiqP_DKyA2hFvCGO1kriGgeS87i-bEP3sOKzILt7_C4s_0hKH8poVChfDWem8uHfNMpFfJy9AF5i7aOgpqTxOQVQcXLUmMu7T5MdmSohRCKLxb-Z0FxppT9F2gcIwngpqbN28TGZocMhK-lZ-wOumTGKero8EqHQ0xCGvXC8D6quuq9XVcZ-75lblyaxaKSQ_yI86gUoLzmAFyE7xxzqaprds0HeFGtuwXI7DIOPR2wxhLn6QAWDaSm_bXW8tjo4qy97BNemNVADbwqgL7tmXcQKzr2yBkjZ8_aw',
        e: 'AQAB',
        key_ops: [ 'verify' ],
        ext: true
    },
    {   //these are the algorithm options
        name: "RSASSA-PKCS1-v1_5",
        hash: {name: "SHA-256"}, //can be "SHA-1", "SHA-256", "SHA-384", or "SHA-512"
    },
    true, //whether the key is extractable (i.e. can be used in exportKey)
    ["verify"] //"verify" for public key import, "sign" for private key imports
)

b = crypto.subtle.importKey(
    "jwk", //can be "jwk" (public or private), "spki" (public only), or "pkcs8" (private only)
    {   //this is an example jwk key, other key types are Uint8Array objects
        kty: 'RSA',
        alg: 'RS256',
        n:
         'v9w-i94DKuR3HgAvHo3lBx-OfxgQLEPvoJKnc_Gc3LNPynNvgGaQFz_nwAOIrnWRvxrXWCZ54eWPrmHayBSO6fbONNrYDtuHpx-9Huuph4Rw_gL9UHKKxka_8aNg9o_YEb6x3klnzzoTVAPp-bgcYImdeKmRwPGbdazr-EaRMD16-UM-5oCNkR6CwHuBWrVxAskcA9FGP3V1wniNvE9lihgtVSPTmRvmdxfycOu8Q_ZRsv8b72duK0kgpN4xDKFTBQpuXSAOrMmQt186DWyNcJtuR5s3QO6Jwt4DfpcgqDkC0oKwmsS9-4-mWDk0ZghuFJkI5OeusqJs2zYGiXBYhQ',
        e: 'AQAB',
        d:
         'qdkuvd_DahtroHGFRUVUteOn4LfKyYUzBDIQcEI7Hd7YCl_7G-6wLQT0Azadr-SBLG90qKMXT3ZMppIWfv5ELrfBgWUj1LNf-gHNCSyTnlcPOLAo1Skx1aoYjrCWTHC3Va4-BI1ziy7coYn9focRCB2L_KARWoAJojl9hQPj0JFxHRhjoaEmOrMFzL0FkdDMsW-gxpfvlKZmdPyM1OlKWyx-2xVmx2p7-TkN3QpO2lw_8mOhZMXHLTAPgSlpBJZfJOEMxg0Jxu7QWH9iyiSEDa66wYL9eeu9RB1PFvPTGRUdqYVwcQDo0YbW4xIftCaaPnIVI2kqURFsjz6lItrvWQ',
        p:
         '_LrGjaBgXESKzz2nmFg6eaDjSahRWW2kd3OfzN4n3ucY2z7LrE_wAFoBHmPhQ5FVBznIYTsdbERA7kgEVZi0faRwGGrs0h5x_kRyk2c3BnwsFdvgGhnyj4javFYbVSAvlqOxABlKrTerthnK3fHqI7Zk8orsZpbSuqetbYAaF-c',
        q:
         'wlfTTh4sFs6_K5L7gYRanvudyJZbuYtt8n6F3MY6zXjCA6moCV2xR8MJMGuSaO8De891_J2Byh3I5J6Ff-4ra6ZxHcwsuX1Q-6utnkSJ6xbpALfqvLpc2fRtJPOuM81CCh5NjiGLdcXBAgR7i4rrndHnk-VgpSOfWK3Zd46lDrM',
        dp:
         'bcD7K1RDpK5Ljfabiuh99IYvTrSfJ3QbIZkAA-tSa1X3EHez4dARTUXJCJadpEdAItQwNjGC9JqrjA-Qek_HymyYFbKRyCpanO7Cx0ritZlFV_TV3N_52-W2AGZwlkZVBFlwK7fQG2t60alf1YUShpHWQxKb2W2UdGUPRueD7W8',
        dq:
         'BCVHdqUiH6JtZYqPHuYp4LZRWVQLxNt6ju-v_1OjMXrf-KAH25tKCtPYQFYrG13t3xg_1hGuERetj2LqSh5UgslcJFyUn6hSr-urmnKv1nn4onFJ6pi3HlcedOlVz_kS7ZBT6zI__VUolthtoj5mZElz_S2pcBxga83Zk7lRQA0',
        qi:
         'W5TEM6zbSgJS-RUuN5tZy0gOxPeH2tyzSFbddyFxbnIyLVRRI3Ap9GqqWM0htiYxqV1uUWfPxlf0wv7-po5cAC5INyS_Qkqd7QgeJTWWHT3musTUWlrldaJ-RRtQ2JiCkll-6HRDLZV-489dnjEYl6WD77TxPCw3g3DO76cyNY8',
        key_ops: [ 'sign' ],
        ext: true 
    },
    {   //these are the algorithm options
        name: "RSASSA-PKCS1-v1_5",
        hash: {name: "SHA-256"}, //can be "SHA-1", "SHA-256", "SHA-384", or "SHA-512"
    },
    false, //whether the key is extractable (i.e. can be used in exportKey)
    ["sign"] //"verify" for public key import, "sign" for private key imports
)


// console.log(a["CryptoKey"])

// a.then(function(result){
//     // console.log("a")
//     giveSignature(hash, result)
// })

b.then(function(result){
    // console.log(result)
    giveSignature("123",result)

})

// keypair = {publicKey: a, privateKey: b}