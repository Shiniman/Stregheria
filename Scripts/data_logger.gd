extends Node
class_name DataLogger

# To access this .txt go to
# C:\Users\Jag\AppData\Roaming\Godot\app_userdata\Stregheria
const LOG_PATH = "user://entity_log.txt"

static func log_event(event_type: String, data: Dictionary):
	var file = FileAccess.open(LOG_PATH, FileAccess.WRITE_READ)
	if file:
		var log_entry = "[%s] %s: %s\n" % [
			Time.get_datetime_string_from_system(),
			event_type,
			JSON.stringify(data)
		]
		file.seek_end()
		file.store_string(log_entry)
		file.close()
	else:
		push_error("Failed to open log file: ", FileAccess.get_open_error())
