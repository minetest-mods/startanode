The Minetest mod **startanode** provides the KiSS version for a singlenode mapgen. No extended features, no goals, no survival elements, just build your own world in creative from scratch. Of course the mod can be combined with other mods to get some survival elements. It is like the already known [origin](https://forum.minetest.net/viewtopic.php?f=11&t=11156) mod but with the difference each player get own origin node at first join.

Highly recommended permissions: fly, home, give, creative
Highly not recommended: destroy the node you stand on


# Features
At first login of a new player:
 - get a random position for the players singlenode in area +-500/+-30/+-500
 - spawn the node ("mapgen_stone" alias)
 - spawn the player above the node

At respawn: if sethome mod is found
 - set players home above the node
 - teleport the player to the home position each respawn
 - except teleporting if the beds mod is stores the respawn position

# Dependencies
 - sethome - optional but recommended. Is used to store the respawn position
 - beds - soft-dependency. Skip teleporting to sethome position at respawn if the player have a beds spawn position

Anti-Dependendy: nyancats and tac_nayn destroys the epic void of the singlenode world. Mods like geomoria are not the best idea too for the singlenode world oO.

# Developer Info: A small interface allow working together with other mods

Code: Select all
```
startanode = {
       min_pos = {x = -500, y = -30, z = -500 },
       max_pos = {x =  500, y =  30, z =  500 },
       node_name = "mapgen_stone", -- "default:stone"
       after_place_func = nil, -- function(player, pos) called after the node is placed
       singlenode_mode = true, -- no effect from other mods. Change is too late
       enable_bed_respawn = minetest.setting_getbool("enable_bed_respawn") -- disable respawn handling if bed respawn is set
    }
```

unternull modpack does have optional support for startanode using this interface. The give_initial_stuff chest is managed per player trough startanode in this case.


# License
LGPL-3
