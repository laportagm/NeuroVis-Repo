# Minimal test to check if ResponsiveComponent can be preloaded

extends Control

const ResponsiveComponentTest = prepreload("res://ui/components/core/ResponsiveComponent.gd")


func _ready():
	print("ResponsiveComponent preload test successful")
