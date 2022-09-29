import re, strutils, xmlparser, xmltree, json, os

proc index[T](elements: seq[T], element: T): int =
  for z in 0 ..< elements.len:
    if elements[z] == element:
      return z
  return -1

let xmlRegex = re"""<(.{1,10000})\/>"""
var commands = readFile("./data/xml_commands/commands.json").parseJson()
var cmds = commands["commands"]
for f in os.walkDirRec("./BP/functions"):
    if f.splitFile()[2] != ".mcfunction": continue
    if f.contains("_copy.mcfunction"): continue
    var fStr = f.readFile()
    let matches = fStr.findAll(xmlRegex)
    if matches.len() == 0: continue
    for m in matches:
        let x = m.parseXml()
        for c in cmds:
            if x.tag != c["name"].to(string): continue
            var xV = c["vars"]
            var sV: seq[string]
            for s in xV:
                sV.add(s.to(string))
            var xC = c["commands"]
            var sC: seq[string]
            for s in xC:
                sC.add(s.to(string))
            for v in sV:
                var newV = v
                for r in sC:
                    var newR = r
                    sC[sC.index(r)] = newR.replace("$" & newV, x.attr(newV))
            echo "\nTag: " & m & "\n" & sC.join("\n")
            fStr = fStr.replace(m, sC.join("\n"))
    writeFile(f.splitFile()[0] & "/" & f.splitFile()[1] & "_copy.mcfunction", fStr)