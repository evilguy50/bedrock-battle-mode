var mechs = "mechanics/"
function <scoreboards>:
    foreach <b board ["timer", "player", "settings", "votes"]>:
        scoreboard objectives add `eval:board` dummy
    