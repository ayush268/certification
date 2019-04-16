import numpy as np
import random
import hashlib
import sys
import json

def get_hash_md5(string):
    if type(string) != "str":
        string = str(string)
    result = hashlib.md5()
    result.update(string.encode("utf-8"))
    return result.hexdigest()

def get_root_from_token(certificate, token):
    """
    Assuming token is in bottom up format
    Also, certificate is in raw form
    """
    t = get_hash_md5(certificate)
    for hash in token:
        if hash[0] == "before":
            tmp = hash[1]+t
            t = tmp
        else:
            tmp = t+hash[1]
            t = tmp
    return t

def verify():
    """
    certificate: sys.argv[1]
    tx_hash : string argv[2]
    token : argv[3]
    """
    certificate = sys.argv[1]
    token = json.loads(sys.argv[3])
    tx_hash = sys.argv[2]
    cal_root = get_root_from_token(certificate,token)
    actual_root = get_from_ethereum(tx_hash)
    if actual_root == cal_root:
        match = "1"
    else:
        match = "0"
    return 0
