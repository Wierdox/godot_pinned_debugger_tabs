@tool
extends EditorPlugin

var time_until_open  := 0.1 #Change if needed
var pin_button :Control
var pin_button_index :int
var pin_index        :int
var pin_texture_on  :Texture2D
var pin_texture_off :Texture2D

# Editor nodes, don't free
var debugger :Node
var debugger_tabs :TabContainer


func _enter_tree() -> void:
	# Get bottom panel as ref
	var bottom_control := Control.new()
	var dumb_ref :Control= add_control_to_bottom_panel(bottom_control, "")
	# Find relative paths (use Editor Debugger plugin if you ever need to do this)
	debugger = dumb_ref.get_parent().get_parent().get_parent().get_child(1)
	debugger_tabs = debugger.get_child(0).get_child(0).get_child(0)
	remove_control_from_bottom_panel(bottom_control)
	
	debugger_tabs.tab_button_pressed.connect(_on_debugger_tab_button_pressed)
	debugger_tabs.tab_changed.connect(_on_debugger_tab_changed)
	
	pin_texture_on  = get_editor_interface().get_base_control().get_theme_icon("PinJoint2D", "EditorIcons")
	pin_texture_off = get_editor_interface().get_base_control().get_theme_icon("PinJoint3D", "EditorIcons")
	
	pin_index = -1
	
	pin_button = Control.new()
	debugger_tabs.add_child(pin_button)
	pin_button_index = debugger_tabs.get_tab_idx_from_control(pin_button)
	enable_pin()


func _on_debugger_tab_button_pressed(tab:int) -> void:
	if tab == pin_button_index:
		if debugger_tabs.get_tab_icon(pin_button_index) == pin_texture_off:
			debugger_tabs.set_tab_button_icon(pin_index, null)
			pin_index = -1
			enable_pin()
		elif pin_index == -1:
			pin_index = debugger_tabs.current_tab
			debugger_tabs.set_tab_button_icon(pin_index, pin_texture_on)
			enable_unpin()
		else:
			debugger_tabs.set_tab_button_icon(pin_index, null)
			pin_index = debugger_tabs.current_tab
			debugger_tabs.set_tab_button_icon(pin_index, pin_texture_on)
			enable_unpin()
		return
	if debugger_tabs.get_tab_button_icon(tab) == null:
		return # For some reason tabs without a texture can still emit tab_button_pressed
	debugger_tabs.set_tab_button_icon(tab, null)
	pin_index = -1
	enable_pin()


func _on_debugger_tab_changed(tab:int) -> void:
	if tab == pin_button_index:
		debugger_tabs.current_tab = debugger_tabs.get_previous_tab()
		_on_debugger_tab_button_pressed(pin_button_index)
		return
	if pin_index == -1:
		return
	if tab == pin_index:
		enable_unpin()
	else:
		enable_pin()


func enable_pin() -> void:
	if pin_index == -1:
		debugger_tabs.set_tab_title(pin_button_index, "Pin Tab")
	else:
		debugger_tabs.set_tab_title(pin_button_index, "Shift Pin")
	debugger_tabs.set_tab_icon(pin_button_index, pin_texture_on)


func enable_unpin() -> void:
	debugger_tabs.set_tab_title(pin_button_index, "Unpin")
	debugger_tabs.set_tab_icon(pin_button_index, pin_texture_off)

# Virtual called before launching game
func _build() -> bool:
	open_pinned_tab()
	return true
func open_pinned_tab() -> void:
	if pin_index == -1:
		return
	
	await get_tree().create_timer(time_until_open).timeout
	
	make_bottom_panel_item_visible(debugger)
	debugger_tabs.current_tab = pin_index


func _exit_tree() -> void:
	# Clean up
	if pin_index != -1:
		debugger_tabs.set_tab_button_icon(pin_index, null)
	debugger_tabs.tab_button_pressed.disconnect(_on_debugger_tab_button_pressed)
	debugger_tabs.tab_changed.disconnect(_on_debugger_tab_changed)
	pin_button.queue_free()
