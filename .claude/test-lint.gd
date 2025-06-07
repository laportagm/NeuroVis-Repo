# Test file for linting system
# This file intentionally contains various issues to test detection

extends Node


# Missing type hints
class_name EducationalTestComponent

# Misspelled medical term

const spaced_wrong = 42  # Extra spaces

var result = param1 + param2
var hipocampus_data = "Should be hippocampus"


# Performance critical function without annotation
var result_2 = ""
var node = get_node("SomePath")
node.do_something()  # Could be null


# Accessibility issue - no tooltip
var unused = 42
var used = 10

func _process(delta):
	# Missing delta usage
	position.x += 10


	# String concatenation in loop (performance issue)

func badFunction(param1, param2):
func CamelCaseFunction() -> void:
	print("This should be snake_case")


	# Missing educational metadata for educational component
func bad_performance() -> void:
func risky_function() -> void:
func unused_vars() -> void:

func _fix_orphaned_code():
	return result


	# Wrong naming convention
func _fix_orphaned_code():
	for i in range(100):
		result = result + str(i)


		# Missing error handling
func _fix_orphaned_code():
	print(used)


	# TODO: This should be flagged
	# FIXME: This too

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		print("Clicked")


		# Unused variable
