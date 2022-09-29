import os

for f in os.walkDirRec(os.getCurrentDir()):
    if f.fileExists():
        var readF = f.readFile()
        if readF == "":
            os.removeFile(f)