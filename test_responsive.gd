extends Node

func _ready():
	var test = preload("res://ui/components/core/ResponsiveComponent.gd").new()
	print("ResponsiveComponent loaded successfully")