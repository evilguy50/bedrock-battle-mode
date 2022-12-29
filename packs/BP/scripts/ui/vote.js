import * as mc from "@minecraft/server"
import * as mcui from "@minecraft/server-ui"

export default async function vote(playerName) {
    const options = ["Cove", "Cavern", "Crucible", "Clear Vote"];
    const form = new mcui.ActionFormData()
        .title("Map vote")
        .body("Vote for a map to play!");
    options.forEach((opt) => {
        form.button(opt);
    });
    mc.world.getAllPlayers().forEach(async (pl) => {
        if (pl.name === playerName) {
            const sender = pl;
            form.show(sender).then((result) => {
                if (!result.canceled) {
                    const newOption = options[result.selection].toLowerCase()
                    let commands = [];
                    if (newOption === "clear vote") {
                        options.forEach((opt) => {
                            const lowerOpt = opt.toLowerCase();
                            if (sender.hasTag(`voted_${lowerOpt}`)) {
                                commands.push(`tag ${sender.name} remove voted_${lowerOpt}`);
                                commands.push(`scoreboard players remove ${lowerOpt} votes 1`);
                            }
                        });
                        commands.push(`tag ${sender.name} remove voted`);
                    } else if (!sender.hasTag("voted")) {
                        commands.push(`execute as ${sender.name} at @s run scoreboard players add ${newOption} votes 1`);
                        commands.push(`tag ${sender.name} add voted`);
                        commands.push(`tag ${sender.name} add voted_${newOption}`);
                    }
                    commands.forEach(async (cmd) => {
                        console.log(`cmd: ${cmd}`);
                        await sender.runCommandAsync(cmd);
                    });
                    console.log("form not canceled 5");
                }
            });
        }
    });
}