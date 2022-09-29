var mechs = "mechanics/"
definefunction <settings>:
    foreach <s set ["map", "spawned", "started", "start_timer", "players"]>:
        scoreboard players add `eval:set` settings 0
definefunction <start>:
    scoreboard players reset * player
    foreach <s set ["start_timer", "spawned", "started", "players"]>:
        scoreboard players set `eval:set` settings 0
    scoreboard players add @a player 0
    scoreboard players add @e[type=minecraft:armor_stand] player 0
    execute @e[scores={player=0}] ~ ~ ~ function <set>:
        scoreboard players add max player 1
        scoreboard players operation @s player = max player
    scoreboard players operation players settings = max player
    scoreboard players reset max player
    execute if score map settings matches 0 run function <lobby>:
        gamemode s @a
        tp @a 796.66 80.00 474.42
    execute if score map settings matches 1 run function <cavern>:
        foreach <p pl ["255.61 26.00 12.60", "259.60 26.00 21.47", "268.69 26.00 25.51", "277.48 26.00 21.47", "281.47 26.00 12.34", "277.42 26.00 3.57", "268.28 26.00 -0.43", "259.35 26.00 3.69"]>:
            var new_p = p + 1
            tp @e[scores={player=`eval:new_p`}] `eval:pl` facing 268 29 12
    execute @a ~~~ spawnpoint @s ~~~
    execute if score map settings matches 1.. run scoreboard players set spawned settings 1
    definefunction <countdown>:
        execute if score start_timer settings matches 0..6 run fill 251 24 -6 285 36 31 barrier 0 replace structure_void -1
        execute if score start_timer settings matches 0 if score map settings matches 1 run function `eval:mechs`chests/cavern/empty
        execute if score start_timer settings matches 0 run scoreboard players set start_timer settings 6
        scoreboard players remove start_timer settings 1
        for <t 6..0 -1>:
            execute if score start_timer settings matches `eval:t` run title @a title §a`eval:t`
        execute if score start_timer settings matches 0 run function <done>:
            fill 251 24 -6 285 36 31 structure_void 0 replace barrier -1
            title @a title §4Fight!
            execute if score map settings matches 1 run function `eval:mechs`chests/cavern/fill
            scoreboard players set started settings 1
definefunction <restart>:
    function <check>:
        scoreboard players set players settings 0
        execute @e[type=minecraft:armor_stand] ~ ~ ~ scoreboard players add players settings 1
        for <m 0..3 1>:
            execute @a[m=`eval:m`,x=761,y=-56,z=382,rm=120] ~ ~ ~ scoreboard players add players settings 1
    execute if score players settings matches 1 run function <main>:
        kill @e[type=item]
        kill @e[type=pulsar:chest_refill]
        scoreboard players reset @a *
        scoreboard players reset @e *
        gamemode s @a
        clear @a
        foreach <s set ["started", "spawned", "start_timer", "refill_timer", "map"]>:
            scoreboard players set `eval:set` settings 0
        function `eval:mechs`start
        
    
definefunction <inventory>:
    for <i 0..27 1>:
        replaceitem entity @a slot.inventory `eval:i` keep minecraft:barrier 1 0 {"keep_on_death": {},"item_lock": { "mode": "lock_in_slot" } }
definefunction <tnt>:
    summon minecraft:tnt ~ ~ ~
    clear @s pulsar:tnt 0 1
definefunction <chests>:
    execute if score map settings matches 1 if score started settings matches 1 run function <cavern>:
        var cavern = ["269 28 11", "269 28 13", "267 28 13", "267 28 11", "216 35 12", "242 43 12", "243 30 2", "250 37 33", "268 37 -31", "279 30 -37", "278 52 12", "258 52 12", "279 52 55", "254 42 65", "300 26 12", "320 34 12", "311 46 9", "294 33 -15"]
        definefunction <empty>:
            kill @e[type=pulsar:chest_refill]
            foreach <c chest cavern>:
                setblock `eval:chest` minecraft:barrel 
                for <i 0..27 1>:
                    replaceitem block `eval:chest` slot.container `eval:i` air
                execute @s `eval:chest` setblock ~ ~1 ~ air
        definefunction <fill>:
            foreach <c chest cavern>:
                loot insert `eval:chest` loot start.lt
        definefunction <refill>:
            var cavern_center = ["267 28 11", "267 28 13", "269 28 13", "269 28 11"]
            var cavern_high = ["258 52 12", "278 52 12"]
            var cavern_outer = ["216 35 12", "242 43 12", "243 30 2", "250 37 33", "268 37 -31", "279 30 -37", "279 52 55", "254 42 65", "300 26 12", "320 34 12", "311 46 9", "294 33 -15"]
            event entity @e[type=pulsar:chest_refill] evil:despawn_ev
            foreach <c chest_c cavern_center>:
                loot insert `eval:chest_c` loot center.lt
            foreach <c chest_o cavern_outer>:
                loot insert `eval:chest_o` loot out.lt
            foreach <c chest_h cavern_high>:
                loot insert `eval:chest_h` loot high.lt
            foreach <c chest cavern>:
                summon pulsar:chest_refill `eval:chest`
            definefunction <particle>:
                execute @e[type=pulsar:chest_refill] ~~~ particle minecraft:basic_crit_particle ~ ~1.5 ~
                execute as @e[type=pulsar:chest_refill] at @s if block ~ ~ ~ barrel["open_bit": true] run kill @s
definefunction <refill>:
    foreach <m map ["cavern"]>:
        var new_m = m + 1
        execute if score map settings matches `eval:new_m` run function `eval:mechs`chests/`eval:map`/refill
definefunction <lobby>:
    definefunction <reset>:
        for <c 472..477 1>:
            setblock 802 57 `eval:c` chest 0
        setblock 803 59 470 chest 0
        foreach <r red ["795 60 468", "795 59 482", "803 63 477", "805 63 476", "805 63 474", "805 63 472", "803 63 471"]>:
            setblock `eval:red` air 0
        var skulls = ["796 67 522"]
        foreach <s skull ["wither"]>:
            var new_skull = skulls[s]
            structure load `eval:skull` `eval:new_skull`