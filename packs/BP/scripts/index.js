import * as mc from "@minecraft/server";
import vote from "./ui/vote";

mc.world.events.itemUse.subscribe((event) => {
    const player = event.source.nameTag;
    const item = event.item.typeId;
    if (item === "evil:vote") {
        vote(player);
    }
});