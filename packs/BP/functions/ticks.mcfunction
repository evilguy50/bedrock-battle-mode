var mechs = "mechanics/"
var map_count = 1
definefunction <1tick>:
    # 1 tick function
definefunction <5tick>:
    # 5 tick function
    function `eval:mechs`chests/cavern/refill/particle
definefunction <10tick>:
    # 10 tick function
    execute if score spawned settings matches 1 if score started settings matches 1 run function `eval:mechs`restart
    function `eval:mechs`inventory
    function `eval:mechs`settings
definefunction <1sec>:
    # 1 second function
    execute if score spawned settings matches 1 if score started settings matches 0 if score start_timer settings matches 0..10 if score map settings matches 1..`eval:map_count` run function `eval:mechs`start/countdown
definefunction <5sec>:
    # 5 second function
definefunction <10sec>:
    # 10 second function
definefunction <30sec>:
    # 30 second function
definefunction <1min>:
    # 1 minute function
    execute if score started settings matches 1 run function `eval:mechs`refill
definefunction <5min>:
    # 5 minute function
definefunction <10min>:
    # 10 minute function
definefunction <1day>:
    # 1 day function