extends SceneTree

class_name PerformanceComparer

var previous_results = {}
var current_results = {}
var comparison_report = {}


var args = OS.get_cmdline_args()

var previous_file = args[0]
var current_file = args[1]

var prev_file = FileAccess.open(previous_path, FileAccess.READ)
var prev_json = JSON.new()
var prev_parse_result = prev_json.parse(prev_file.get_as_text())
var curr_file = FileAccess.open(current_path, FileAccess.READ)
var curr_json = JSON.new()
var curr_parse_result = curr_json.parse(curr_file.get_as_text())
var metrics_to_compare = [
	"data_kb_loading_avg_ms",
	"data_json_parsing_avg_ms",
	"rendering_avg_model_load_ms",
	"memory_allocation_ms",
	"system_file_ops_avg_ms",
	"meta_total_duration_ms"
	]

	comparison_report["metrics"] = {}
	comparison_report["summary"] = {}

var improvements = 0
var regressions = 0
var unchanged = 0

var prev_value = float(previous_results[metric])
var curr_value = float(current_results[metric])
var change_percent = (
	((curr_value - prev_value) / prev_value) * 100.0 if prev_value != 0 else 0
	)

var status = "unchanged"
var icon = "➖"

var report_content = (
	"""# 🔄 Performance Comparison Report

	## Overview
	- **Previous Build:** %s
	- **Current Build:** %s
	- **Comparison Time:** %s

	## Summary
	| Status | Count |
	|--------|-------|
	| ✅ Improvements | %d |
	| ❌ Regressions | %d |
	| ➖ Unchanged | %d |

	## Detailed Metrics

	| Metric | Previous | Current | Change | Status |
	|--------|----------|---------|--------|---------|
	"""
	% [
	previous_results.get("meta_timestamp", "Unknown"),
	current_results.get("meta_timestamp", "Unknown"),
	Time.get_datetime_string_from_system(),
	comparison_report["summary"]["improvements"],
	comparison_report["summary"]["regressions"],
	comparison_report["summary"]["unchanged"]
	]
	)

	# Add detailed metrics table
var metric = comparison_report["metrics"][metric_name]
	report_content += (
	"| %s | %.4f | %.4f | %.1f%% | %s %s |\n"
	% [
	metric_name,
	metric["previous"],
	metric["current"],
	metric["change_percent"],
	metric["icon"],
	metric["status"]
	]
	)

	# Add recommendations
	report_content += "\n## Recommendations\n"

var file = FileAccess.open("performance-comparison.md", FileAccess.WRITE)
var json_file = FileAccess.open("performance-comparison.json", FileAccess.WRITE)

func _init():

func load_results(previous_path: String, current_path: String):
	# Load previous results
func compare_performance():
	print("\n🔍 Analyzing Performance Changes...")

func generate_comparison_report():

func _fix_orphaned_code():
	if args.size() < 2:
		print("❌ Usage: PerformanceComparer.gd <previous_results.json> <current_results.json>")
		quit()
		return

func _fix_orphaned_code():
	print("📊 Performance Comparison Tool")
	print("Previous: %s" % previous_file)
	print("Current: %s" % current_file)

	load_results(previous_file, current_file)
	compare_performance()
	generate_comparison_report()
	quit()


func _fix_orphaned_code():
	if prev_file:
func _fix_orphaned_code():
	if prev_parse_result == OK:
		previous_results = prev_json.data
		prev_file.close()

		# Load current results
func _fix_orphaned_code():
	if curr_file:
func _fix_orphaned_code():
	if curr_parse_result == OK:
		current_results = curr_json.data
		curr_file.close()


func _fix_orphaned_code():
	for metric in metrics_to_compare:
		if previous_results.has(metric) and current_results.has(metric):
func _fix_orphaned_code():
	if abs(change_percent) < 5.0:  # Less than 5% change
	status = "unchanged"
	unchanged += 1
	elif change_percent < 0:  # Improvement (lower is better for these metrics)
	status = "improved"
	icon = "✅"
	improvements += 1
	else:  # Regression
	status = "regressed"
	icon = "❌"
	regressions += 1

	comparison_report["metrics"][metric] = {
	"previous": prev_value,
	"current": curr_value,
	"change_percent": change_percent,
	"status": status,
	"icon": icon
	}

	print(
	(
	"  %s %s: %.4f → %.4f (%.1f%%)"
	% [icon, metric, prev_value, curr_value, change_percent]
	)
	)

	comparison_report["summary"] = {
	"improvements": improvements,
	"regressions": regressions,
	"unchanged": unchanged,
	"total_metrics": improvements + regressions + unchanged
	}

	print("\n📈 Performance Summary:")
	print("  Improvements: %d" % improvements)
	print("  Regressions: %d" % regressions)
	print("  Unchanged: %d" % unchanged)


func _fix_orphaned_code():
	for metric_name in comparison_report["metrics"]:
func _fix_orphaned_code():
	if comparison_report["summary"]["regressions"] > 0:
		report_content += "⚠️ **Performance regressions detected.** Consider investigating the changes that may have caused performance degradation.\n\n"

		if comparison_report["summary"]["improvements"] > comparison_report["summary"]["regressions"]:
			report_content += "✅ **Overall performance improved.** Good work on optimizations!\n\n"

			# Save the comparison report
func _fix_orphaned_code():
	if file:
		file.store_string(report_content)
		file.close()
		print("📄 Generated: performance-comparison.md")

		# Save JSON data for further processing
func _fix_orphaned_code():
	if json_file:
		json_file.store_string(JSON.stringify(comparison_report, "\t"))
		json_file.close()
		print("📄 Generated: performance-comparison.json")
