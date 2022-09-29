import json, strutils, os

const timerPath = "./data/timer/intervals.json"
let times = timerPath.readFile().parseJson()["intervals"]
var controls: seq[string]

proc parseTime(t: string): int=
    if t.endsWith("t"):
        result = t[0..t.len() - 2].parseInt()
    elif t.endsWith("s"):
        result = t[0..t.len() - 2].parseInt() * 20
    elif t.endsWith("m"):
        result = t[0..t.len() - 2].parseInt() * (20 * 60)
    elif t.endsWith("d"):
        result = t[0..t.len() - 2].parseInt() * ((20 * 60) * 20)

var id = -1
for k in times.keys:
    id.inc(1)
    let dur = k.parseTime()
    let run = times[k]
    echo "(" & $id & ") " & $dur & ": " & $run
    controls.add("scoreboard players add t_" & $id & " timer 1")
    for r in run:
        controls.add("execute as @r at @s if score t_" & $id & " timer matches " & $dur & ".. run function " & r.to(string) )
    controls.add("execute as @r at @s if score t_" & $id & " timer matches " & $dur & ".. run scoreboard players set t_" & $id & " timer 0" )

for c in controls:
    echo c

if not dirExists("./BP/functions/timer"):
    createDir("./BP/functions/timer")

writeFile("./BP/functions/timer/timer.mcfunction", controls.join("\n"))
writeFile("./BP/functions/tick.json", parseJson("""{"values": ["timer/timer"]}""").pretty())