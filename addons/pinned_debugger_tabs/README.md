# Godot Plugin: Pinned Debugger Tabs for 3.x and 4.x

Auto opens a pinned Debugger tab on project run.

To pin a tab, press the newly added Pin Tab button on the Debugger tab bar.
You can unpin by either pressing Unpin, or pressing the blue pin on the pinned tab.
You can also shift the pin by going to a new tab and pressing Shift Pin.

Changelog:
*1.1: For 4.4+, fixed plugin critically failing due to changes in Debugger node hierarchy. Still works with all previous versions.

This plugin overrides `run/output/always_open_output_on_play`.

If the plugin seems to fail, try editing the first variable `time_until_open`, it might depend on your PC.