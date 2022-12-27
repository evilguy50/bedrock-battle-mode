var mechs = "mechanics/"
function <scoreboards>:
    foreach <b board ["timer", "player", "settings"]>:
        scoreboard objectives add `eval:board` dummy
    