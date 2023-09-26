# Godot Plugin: Pinned Debugger Tabs for 3.x and 4.x

Auto opens a pinned Debugger tab on project run.

To pin a tab, press the newly added Pin Tab button on the Debugger tab bar.
You can unpin by either pressing Unpin, or pressing the blue pin on the pinned tab.
You can also shift the pin by going to a new tab and pressing Shift Pin.

This plugin overrides `run/output/always_open_output_on_play`.

If the plugin seems to fail, try editing the first variable `time_until_open`, it might depend on your PC.

For 3.x users, make note that this plugin will cancel out the yellow/red icon on Errors tab if pinned, and the pin may disapear on project run. This is only visual though. And due to the feature not existing, pressing the blue pin on a pinned tab will do nothing.