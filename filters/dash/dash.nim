import os, json, strformat
import puppy

if not dirExists("./data/dash"):
    createDir("./data/dash")

if not fileExists("./data/dash/config.json"):
    quit("Must put a dash config at data/dash/config.json")

var dashExt = ""
if ExeExt == "exe":
    dashExt = ".exe"
if not dirExists("./data/dash/deno_dash"):
    discard execShellCmd("git clone https://github.com/evilguy50/deno-dash-compiler.git ./data/dash/deno_dash")
    removeDir("./data/dash/deno_dash/.git")
if not fileExists(fmt"./data/dash/dash{dashExt}"):
    discard execShellCmd(fmt"deno compile --output ./data/dash/dash{dashExt} -A ./data/dash/deno_dash/mod.ts")

copyFile("./data/dash/config.json", "./config.json")

if dirExists("./data/dash/build"):
    removeDir("./data/dash/build")

createDir("./data/dash/build")

discard execShellCmd(fmt"{getCurrentDir()}/data/dash/dash.exe build --out ./data/dash/build")
let config = readFile("./data/dash/config.json").parseJson()

removeDir("./BP")
moveDir("./data/dash/build/builds/dist/" & config["name"].to(string) & " BP", "./BP")
removeDir("./RP")
moveDir("./data/dash/build/builds/dist/" & config["name"].to(string) & " RP", "./RP")