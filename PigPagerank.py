#!/usr/bin/python
import sys
from org.apache.pig.scripting import Pig

P = Pig.compileFromFile("test.pig")

rank = sys.argv[1]
edges = sys.argv[2]

params = {'r': rank, 'ed': edges}

for i in range(int(sys.argv[3])):           
    out = "out/pagerank_data_" + str(i + 1)
    params["out"] = out
    Pig.fs("rmr " + out)
    result = P.bind(params).runSingle()
    if not result.isSuccessful():
        raise Exception("Pig job failed")
    params['r'] = out