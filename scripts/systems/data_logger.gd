extends Node
class_name DataLogger

var log_entries: Array[Dictionary] = []
var session_id: String
var log_file_path: String = "user://agent_log.csv"


func _ready():
	session_id = Time.get_datetime_string_from_system().replace(":", "-")
	log_entries.clear()
	_log_header()


func _log_header():
	log_entries.append({
		"timestamp": "timestamp",
		"event": "event",
		"data": "data",
		"session": "session"
	})


func log_event(event_type: String, data: Dictionary = {}):
	var entry = {
		"timestamp": Time.get_ticks_msec(),
		"event": event_type,
		"data": JSON.stringify(data),
		"session": session_id
	}
	log_entries.append(entry)
	if log_entries.size() > 500:
		flush_to_disk()


func flush_to_disk():
	if log_entries.size() <= 1:
		return
	var file = FileAccess.open(log_file_path, FileAccess.WRITE)
	if file:
		for entry in log_entries:
			file.store_line(JSON.stringify(entry))
		file.close()
	log_entries.clear()
	_log_header()


func get_recent_events(count: int = 20) -> Array[Dictionary]:
	var recent = log_entries.slice(max(0, log_entries.size() - count - 1), log_entries.size())
	return recent


func get_stats_summary() -> Dictionary:
	var stats = {
		"total_events": log_entries.size(),
		"agent_spawns": 0,
		"agent_deaths": 0,
		"resources_collected": 0,
		"attacks": 0,
	}
	for entry in log_entries:
		match entry.get("event", ""):
			"agent_spawned":
				stats.agent_spawns += 1
			"agent_died":
				stats.agent_deaths += 1
			"resource_collected":
				stats.resources_collected += 1
			"agent_attacked":
				stats.attacks += 1
	return stats


func _exit_tree():
	flush_to_disk()
