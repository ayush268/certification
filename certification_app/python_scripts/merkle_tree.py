import numpy as np
import random
import hashlib
import sys
import json

class Node():
    def __init__(self, hash_val, lc, rc):
        self.hash = hash_val
        self.left_child = lc
        self.right_child = rc
        self.parent = None

class Merkle_tree():
    def __init__(self,input_list):
        self.root = None
        self.user_input_list = input_list
        self.original_list = input_list
        self.original_list_hash = []
        
        n = len(input_list)
        if np.log2(n)%1 != 0:
            # pad with some more data to make it a power of 2
            t = int(np.log2(n))
            n_extra = 2**(t+1)-n
            self.original_list += np.random.rand(n_extra).tolist()
        
        self.token_list = []
    
    def get_hash(self,string):
        if type(string) != "str":
            string = str(string)
        result = hashlib.md5()
        result.update(string.encode("utf-8"))
        return result.hexdigest()

    def _make_tree(self,prev):
        assert(self.root == None)
        if len(prev) == 1:
            return prev[0]
        curr = []
        for i in range(0,len(prev),2):
            h1 = prev[i].hash
            h2 = prev[i+1].hash
            h = self.get_hash(h1+h2)
            new_node = Node(h,prev[i],prev[i+1])
            curr.append(new_node)
            prev[i].parent = new_node
            prev[i+1].parent = new_node
        return self._make_tree(curr)
    
    def make_tree(self):
        curr = []
        for i in range(len(self.original_list)):
            tmp = self.get_hash(self.original_list[i])
            # print ("i:",i," hash:",tmp)
            new_node = Node(tmp,None,None)
            self.original_list_hash.append(new_node)
            curr.append(new_node)
        self.root = self._make_tree(curr)
        return self.root

    def _get_token(self, hash_val):
        t = -1
        for obj in self.original_list_hash:
            if obj.hash == hash_val:
                t = obj
                break
        if t==-1:
            print(hash_val+" not among the leaves of this merkle tree")
            return []
        parent = obj.parent
        token = []
        prev_hash = hash_val
        while parent != None:
            if parent.left_child.hash == prev_hash:
                token.append(["after",parent.right_child.hash])
            else:
                token.append(["before",parent.left_child.hash])
            prev_hash = parent.hash
            parent = parent.parent
        return token
    
    def generate_token(self):
        for i in self.user_input_list:
            self.token_list.append(self._get_token(self.get_hash(str(i))))
    
    def get_token(self,roll):
        i = self.user_input_list.index(roll)
        if i == -1:
            # print(str(roll)+" not among the leaves of this merkle tree")
            return []
        return self.token_list[i]
    
    def get_nelements(self):
        return len(self.user_input_list)

if __name__ == "__main__":
    # print(len(sys.argv))
    length = len(sys.argv) - 1
    args = sys.argv[1:]
    input_list = []
    for i in range(length):
        # print(args[i])
        input_list.append(int(args[i]))
    # input_list = [1,2,3,4,5,6,7]
    # input_list_2 = deepcopy(input_list)
    mtree = Merkle_tree(input_list)
    mtree.make_tree()
    mtree.generate_token()
    # print(mtree.root.hash)
    dict_ = {}
    # sdict_[]
    dict_["rootHash"] = mtree.root.hash
    dict_["tokenList"] = {} 
    # print(input_list_2)
    for i in range(length):
        # print(mtree.get_token(input_list[i]))
        dict_["tokenList"][input_list[i]] = mtree.get_token(input_list[i])


    print(json.dumps(dict_))
