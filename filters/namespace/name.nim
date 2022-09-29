import os, strutils, json

var config = readFile("./data/namespace/config.json").parseJson()
var old: seq[string]
for i in config["old"]:
    old.add(i.to(string))
var newID = config["new"].to(string)
proc rep(f: string, old: seq[string], newID: string)=
    var fStr = f.readFile()
    for i in old:
        fStr = fStr.replace(i & ":", newID & ":")
    f.writeFile(fStr)

proc recRep(p: string, old: seq[string], newID: string)=
    for i in os.walkDirRec(p):
        if i.fileExists(): rep(i, old, newID)

recRep("./BP/", old, newID); recRep("./RP/", old, newID)