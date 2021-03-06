# Dynamic Slots
## Description
A simple dynamic slots plugin for SourceMod that relies on increasing the visible maxplayers (`sv_visiblemaxplayers` CVar) by incrementals. The incremental value must be dividable by two.

If for whatever reason the game you're using this for doesn't support `sv_visiblemaxplayers`, the plugin will not work.

## ConVars
Here is a list of the plugin's ConVars along with their descriptions and default values.

```
// This file was auto-generated by SourceMod (v1.10.0.6537)
// ConVars for plugin "dynamic_slots.smx"


// Whether to include bots in player count calculations.
// -
// Default: "0"
ds_bots_include "0"

// Enables debugging (for developer mode only). Will log a SourceMod message.
// -
// Default: "0"
ds_debug "0"

// How many slots to increase by after 'ds_min' is reached until 'ds_max'.
// -
// Default: "2"
ds_increase "2"

// The maximum player count before the plugin stops doing anything. 0 = maxplayers.
// -
// Default: "0"
ds_max "0"

// The minimum amount of players required for the plugin to do anything.
// -
// Default: "24"
ds_min "24"
```

## Credits
* [Christian Deacon](https://github.com/gamemann)