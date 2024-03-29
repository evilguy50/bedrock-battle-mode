var mechs = "mechanics/"
var maps = ["cavern", "cove", "crucible"]
var settings = ["map", "spawned", "started", "start_timer", "players", "fight_timer", "fight", "lobby_start", "lobby_timer"]
definefunction <settings>:
    foreach <s set settings>:
        scoreboard players add `eval:set` settings 0
definefunction <play>:
    foreach <m map maps>:
        definefunction <`eval:map`>:
            function `eval:mechs`spawns/`eval:map`
            function `eval:mechs`start
definefunction <start>:
    scoreboard players reset * player
    foreach <s set ["start_timer", "spawned", "started", "players"]>:
        setting `eval:set` 0
    scoreboard players add @a player 0
    scoreboard players add @e[type=minecraft:armor_stand] player 0
    execute @e[scores={player=0}] ~ ~ ~ function <set>:
        scoreboard players add max player 1
        scoreboard players operation @s player = max player
    scoreboard players operation players settings = max player
    scoreboard players reset max player
    gamemode a @a
    execute @a ~~~ spawnpoint @s ~~~
    clear @a
    effect @a instant_health 1 255 true
    effect @a saturation 1 255 true
    execute if score spawned settings matches 0 run function `eval:mechs`spawns
    execute if score map settings matches 1.. run scoreboard players set spawned settings 1
    definefunction <countdown>:
        var fills = ["251 24 -6 285 36 31", "1340 -47 198 1319 -38 178", "646 6 873 671 14 900"]
        foreach <m map maps>:
            var new_m = m + 1
            var new_fill = fills[m]
            execute if score start_timer settings matches 0..6 if score map settings matches `eval:new_m` run function <`eval:map`>:
                fill `eval:new_fill` barrier 0 replace structure_void -1
                function `eval:mechs`chests/`eval:map`/empty
        execute if score start_timer settings matches 0 run scoreboard players set start_timer settings 6
        scoreboard players remove start_timer settings 1
        effect @a slowness 5 2 true
        execute @a ~ ~ ~ tp @s ~ ~ ~
        for <t 6..0 -1>:
            execute if score start_timer settings matches `eval:t` run title @a title §a`eval:t`
        execute if score start_timer settings matches 0 run function <done>:
            foreach <m map maps>:
                var new_m = m + 1
                var new_fill = fills[m]
                execute if score map settings matches `eval:new_m` run function <`eval:map`>:
                    fill `eval:new_fill` structure_void 0 replace barrier -1
                    function `eval:mechs`chests/`eval:map`/fill
            title @a title §4Fight!
            effect @a clear
            setting started 1
            setting fight_timer 15
            setting fight 0
definefunction <restart>:
    function <check>:
        setting players 0
        execute @e[type=minecraft:armor_stand] ~ ~ ~ scoreboard players add players settings 1
        for <m 0..3 1>:
            execute @a[m=`eval:m`,x=761,y=-56,z=382,rm=120] ~ ~ ~ scoreboard players add players settings 1
    execute if score players settings matches 1 run function <main>:
        kill @e[type=item]
        kill @e[type=pulsar:chest_refill]
        scoreboard players reset @a *
        scoreboard players reset @e *
        gamemode a @a
        clear @a
        replaceitem entity @a slot.hotbar 8 pulsar:vote 1 0 { "keep_on_death": {}, "item_lock": { "mode": "lock_in_slot" } }
        foreach <s set settings>:
            setting `eval:set` 0
        setting lobby_timer 30
        tag @a remove voted
        gamerule pvp false
        effect @a instant_health 1 255 true
        effect @a saturation 1 255 true
        foreach <m map maps>:
            scoreboard players set `eval:map` votes 0
            tag @a remove voted_`eval:map`
        function `eval:mechs`start
        
    
definefunction <inventory>:
    for <i 0..27 1>:
        replaceitem entity @a slot.inventory `eval:i` keep minecraft:barrier 1 0 {"keep_on_death": {},"item_lock": { "mode": "lock_in_slot" } }

definefunction <fight>:
    for <i 15..-1 -1>:
        if <i == 15>:
            execute if score fight_timer settings matches 15 run function <start>:
                gamerule pvp false
                effect @a resistance 15 255 true
        execute if score fight_timer settings matches `eval:i` run titleraw @a actionbar {"rawtext": [{"text": "Invulnerability wears off in `eval:i` seconds!"}]}
        if <i == 0>:
            execute if score fight_timer settings matches 0 run function <end>:
                gamerule pvp true
                effect @a clear
                setting fight 1
    scoreboard players remove fight_timer settings 1

definefunction <tnt>:
    summon minecraft:tnt ~ ~ ~
    clear @s pulsar:tnt 0 1
definefunction <chests>:
    var cavern = ["269 28 11", "269 28 13", "267 28 13", "267 28 11", "216 35 12", "242 43 12", "243 30 2", "250 37 33", "268 37 -31", "279 30 -37", "278 52 12", "258 52 12", "279 52 55", "254 42 65", "300 26 12", "320 34 12", "311 46 9", "294 33 -15"]
    var cavern_center = ["267 28 11", "267 28 13", "269 28 13", "269 28 11"]
    var cavern_high = ["258 52 12", "278 52 12"]
    var cavern_outer = ["216 35 12", "242 43 12", "243 30 2", "250 37 33", "268 37 -31", "279 30 -37", "279 52 55", "254 42 65", "300 26 12", "320 34 12", "311 46 9", "294 33 -15"]

    var cove = ["1330 -50 188", "1330 -50 190", "1332 -50 190", "1331 -49 189", "1332 -50 188", "1375 -27 172", "1382 -56 200", "1286 -45 198", "1365 -27 186", "1314 -31 184", "1393 -24 187", "1363 -37 190", "1358 -22 208", "1355 -50 225", "1352 -43 160", "1312 -40 187", "1297 -40 211", "1320 -31 198", "1351 -33 159", "1312 -49 149"]
    var cove_center = ["1330 -50 188", "1330 -50 190", "1332 -50 190", "1331 -49 189", "1332 -50 188"]
    var cove_high = ["1375 -27 172", "1382 -56 200", "1286 -45 198", "1365 -27 186", "1314 -31 184"]
    var cove_outer = ["1393 -24 187", "1363 -37 190", "1358 -22 208", "1355 -50 225", "1352 -43 160", "1312 -40 187", "1297 -40 211", "1320 -31 198", "1351 -33 159", "1312 -49 149"]

    var crucible = ["658 7 883", "657 7 884", "658 7 885", "659 7 884", "658 8 884", "703 -19 882", "658 -19 884", "679 -10 862", "658 -9 934", "631 -8 857", "658 10 941", "658 -19 849", "682 -13 890", "641 -19 880", "693 -14 920", "621 -14 919", "603 2 884", "618 6 844", "713 2 884", "693 -5 847"]
    var crucible_center = ["658 7 883", "657 7 884", "658 7 885", "659 7 884", "658 8 884"]
    var crucible_high = ["703 -19 882", "658 -19 884", "679 -10 862", "658 -9 934", "631 -8 857", "658 10 941"]
    var crucible_outer = ["658 -19 849", "682 -13 890", "641 -19 880", "693 -14 920", "621 -14 919", "603 2 884", "618 6 844", "713 2 884", "693 -5 847"]

    foreach <m map maps>:
        var new_m = m + 1
        execute if score map settings matches `eval:new_m` if score started settings matches 1 run function <`eval:map`>:
            definefunction <empty>:
                kill @e[type=pulsar:chest_refill]
                foreach <c chest `eval:map`>:
                    setblock `eval:chest` minecraft:barrel 
                    for <i 0..27 1>:
                        replaceitem block `eval:chest` slot.container `eval:i` air
                    execute @s `eval:chest` setblock ~ ~1 ~ air
            definefunction <fill>:
                foreach <c chest `eval:map`>:
                    loot insert `eval:chest` loot start.lt
            definefunction <refill>:
                event entity @e[type=pulsar:chest_refill] evil:despawn_ev
                foreach <c chest_c `eval:map`_center>:
                    loot insert `eval:chest_c` loot center.lt
                foreach <c chest_o `eval:map`_outer>:
                    loot insert `eval:chest_o` loot out.lt
                foreach <c chest_h `eval:map`_high>:
                    loot insert `eval:chest_h` loot high.lt
                foreach <c chest `eval:map`>:
                    summon pulsar:chest_refill `eval:chest`
                definefunction <particle>:
                    execute @e[type=pulsar:chest_refill] ~~~ particle minecraft:basic_crit_particle ~ ~1.5 ~
                    execute as @e[type=pulsar:chest_refill] at @s if block ~ ~ ~ barrel["open_bit": true] run event entity @s evil:despawn_ev
definefunction <spawns>:
    execute if score map settings matches 0 run function <lobby>:
        tp @a 796.66 80.00 474.42
    var cavern_points = ["255.61 26.00 12.60", "259.60 26.00 21.47", "268.69 26.00 25.51", "277.48 26.00 21.47", "281.47 26.00 12.34", "277.42 26.00 3.57", "268.28 26.00 -0.43", "259.35 26.00 3.69"]
    var cove_points = ["1337.27 -44.00 189.45", "1335.31 -44.00 185.51", "1331.24 -44.00 183.53", "1327.42 -44.00 185.40", "1325.53 -44.00 189.71", "1327.66 -44.00 193.67", "1331.61 -44.00 195.39", "1335.53 -44.00 193.49"]
    var crucible_points = ["666.48 9.00 884.53", "664.38 9.00 878.65", "658.58 9.00 876.68", "652.71 9.00 878.71", "650.56 9.00 884.42", "652.57 9.00 890.38", "658.54 9.00 892.26", "664.41 9.00 890.40"]
    var face_points = ["268 29 12", "1331 -43 189", "658 11 884"]
    foreach <m map maps>:
        var new_m = m + 1
        var new_face = face_points[m]
        execute if score map settings matches `eval:new_m` run function <`eval:map`>:
            setting map `eval:new_m`
            execute if score spawned settings matches 0 run scoreboard players set spawned settings 1
            foreach <p pl `eval:map`_points>:
                var new_p = p + 1
                tp @e[scores={player=`eval:new_p`}] `eval:pl` facing `eval:new_face`
definefunction <refill>:
    foreach <m map maps>:
        var new_m = m + 1
        execute if score map settings matches `eval:new_m` run function `eval:mechs`chests/`eval:map`/refill

definefunction <votes>:
    definefunction <display>:
        scoreboard objectives setdisplay sidebar votes
        replaceitem entity @a slot.hotbar 8 pulsar:vote 1 0 {"item_lock": { "mode": "lock_in_slot" }, "keep_on_death": {}}
        scoreboard players reset highest votes
        scoreboard players reset high_id votes
        foreach <m map maps>:
            scoreboard players add `eval:map` votes 0
    definefunction <calc>:
        scoreboard players set highest votes 0
        scoreboard players set high_id votes 0
        var map_count = 0
        foreach <m map maps>:
            var new_m = m + 1
            var map_count = map_count + 1
            execute if score `eval:map` votes > highest votes run function <`eval:map`>:
                scoreboard players operation highest votes = `eval:map` votes
                scoreboard players set high_id votes `eval:new_m`
        execute if score high_id votes matches 0 run scoreboard players random high_id votes 1 `eval:map_count`
        foreach <m map maps>:
            var new_m = m + 1
            execute if score high_id votes matches `eval:new_m` run function `eval:mechs`play/`eval:map`

definefunction <lobby>:
    function <main>:
        function `eval:mechs`votes/display
        effect @a resistance 10 255 true
        effect @a saturation 10 255 true
        setting players 0
        execute @a ~~~ scoreboard players add players settings 1
        execute @e[type=armor_stand] ~ ~ ~ scoreboard players add players settings 1
    function <countdown>:
        execute if score players settings matches 1 run function <reset>:
            setting lobby_start 0
            setting lobby_timer 30
        execute if score players settings matches 2.. if score lobby_timer settings matches 0.. run function <run>:
            setting lobby_start 1
            titleraw @a actionbar {"rawtext": [ { "text": "Match will start in " }, { "score": {"name": "lobby_timer", "objective": "settings" }}, { "text": " seconds!" }]}
            scoreboard players remove lobby_timer settings 1
            execute if score lobby_timer settings matches -1 run function <final>:
                setting lobby_start 0
                setting lobby_timer 30
                function `eval:mechs`votes/calc

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

definefunction <bridge_test>:
    playermsg @r[type=armor_stand] "this is a custom command test"