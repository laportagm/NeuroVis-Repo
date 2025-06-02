# Minimal test to check if ResponsiveComponent can be preloaded
extends Control

const ResponsiveComponentTest = preload("res://ui/components/core/ResponsiveComponent.gd")

func _ready():
	print("ResponsiveComponent preload test successful")