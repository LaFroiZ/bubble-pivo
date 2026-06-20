extends Node2D

# Ссылки на узлы
@onready var music_slider = $VBoxContainer/HSlider
@onready var sfx_slider = $VBoxContainer/HSlider2
@onready var back_button = $Button_Back
@onready var window_mode_option = $VBoxContainer/OptionButton  
@onready var vsync_check = $VBoxContainer/CheckButton

func _ready():
	# ползунок музыки
	var saved_music = MusicManager.get_volume()
	music_slider.value = saved_music * 10
	music_slider.value_changed.connect(_on_music_volume_changed)
	# ползунок эффектов / не готов еще
	sfx_slider.value = 5
	sfx_slider.value_changed.connect(_on_sfx_volume_changed)
	
	
# выбор режима окна
	window_mode_option.add_item("Оконный")
	window_mode_option.add_item("Полноэкранный")
	
	var current_mode = DisplayServer.window_get_mode()
	if current_mode == DisplayServer.WINDOW_MODE_WINDOWED:
		window_mode_option.selected = 0
	elif current_mode == DisplayServer.WINDOW_MODE_FULLSCREEN or current_mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		window_mode_option.selected = 1
	
	window_mode_option.item_selected.connect(_on_window_mode_selected)
	
	# VSync
	var vsync_enabled = DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_ENABLED
	vsync_check.button_pressed = vsync_enabled
	vsync_check.pressed.connect(_on_vsync_toggled)
	
	
	# Остальные сигналы
	back_button.pressed.connect(_on_back_pressed)


# ─────────────────────────────────────────────
# Срабатывает при изменении ползунка музыки
# ─────────────────────────────────────────────
func _on_music_volume_changed(value: float):
	var volume_normalized = value / 10.0
	MusicManager.set_volume(volume_normalized)

# ─────────────────────────────────────────────
# Срабатывает при изменении ползунка sfx
# ─────────────────────────────────────────────
func _on_sfx_volume_changed(value: float):
	var volume_normalized = value / 10.0
	# Здесь нужно будет вызывать функцию управления громкостью SFX
	# Например: SfxManager.set_volume(volume_normalized)
	print("SFX volume set to: ", volume_normalized)
	
# ─────────────────────────────────────────────
# Обработка выбора режима окна
# ─────────────────────────────────────────────
func _on_window_mode_selected(index: int):
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

# ─────────────────────────────────────────────
# Обработка VSync
# ─────────────────────────────────────────────
func _on_vsync_toggled():
	if vsync_check.button_pressed:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)


# ─────────────────────────────────────────────
# Кнопка "Назад"
# ─────────────────────────────────────────────
func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
