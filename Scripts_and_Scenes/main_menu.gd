extends Node2D

func _on_button_pressed() -> void:
	# Укажите точный путь к вашей сцене в кавычках
	_on_button_pressed()
	get_tree().change_scene_to_file("res://Scripts_and_Scenes/settings_menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
