extends Label

var speak_on_state_change:bool = true
var _is_enabled_last_check:bool = false

func _ready():
	NvdaWrapper.say(self.text)

func _process(_delta):
	var is_enabled = NVDA.is_running()
	var status_text = "enabled" if is_enabled else "disabled"
	self.text = "NVDA integration %s" % status_text
	_check_for_state_changes(is_enabled)
	_is_enabled_last_check = is_enabled

func _check_for_state_changes(is_enabled:bool) -> void:
	if not speak_on_state_change:
		return
	
	var say_status = false
	if is_enabled and not _is_enabled_last_check:
		# Enabled
		say_status = true
	elif not is_enabled and _is_enabled_last_check:
		# Disabled
		say_status = true
	
	if say_status:
		NvdaWrapper.say(self.text)
