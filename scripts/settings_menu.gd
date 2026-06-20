extends Node2D

# Ссылки на узлы (проверь имена в сцене!)
@onready var music_slider = $VBoxContainer/MusicSlider
@onready var sfx_slider = $VBoxContainer/SfxSlider2
@onready var window_mode_option = $VBoxContainer/WindowModeOption
@onready var vsync_check = $VBoxContainer/VsyncOption   
@onready var fps_option = $VBoxContainer/FpsOption
@onready var resolution_option = $VBoxContainer/ResolutionOption
@onready var reset_button = $VBoxContainer/ResetOption
@onready var back_button = $Button_Back

func _ready():
	# === Музыка ===
	music_slider.value = MusicManager.get_volume() * 10
	music_slider.value_changed.connect(_on_music_volume_changed)

	# === SFX ===
	sfx_slider.value = 5
	sfx_slider.value_changed.connect(_on_sfx_volume_changed)

	# === Режим окна ===
	window_mode_option.add_item("Оконный")
	window_mode_option.add_item("Полноэкранный")
	var current_mode = DisplayServer.window_get_mode()
	if current_mode == DisplayServer.WINDOW_MODE_WINDOWED:
		window_mode_option.selected = 0
	elif current_mode == DisplayServer.WINDOW_MODE_FULLSCREEN or current_mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		window_mode_option.selected = 1
	window_mode_option.item_selected.connect(_on_window_mode_selected)

	# === VSync ===
	var vsync_enabled = DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_ENABLED
	vsync_check.button_pressed = vsync_enabled
	vsync_check.pressed.connect(_on_vsync_toggled)

	# === FPS ===
	fps_option.add_item("30 FPS")
	fps_option.add_item("60 FPS")
	fps_option.add_item("120 FPS")
	fps_option.add_item("144 FPS")
	fps_option.add_item("Без ограничений")
	var current_fps = Engine.get_max_fps()
	match current_fps:
		30:  fps_option.selected = 0
		60:  fps_option.selected = 1
		120: fps_option.selected = 2
		144: fps_option.selected = 3
		_:   fps_option.selected = 4
	fps_option.item_selected.connect(_on_fps_selected)

	# === Разрешение ===
	var common_resolutions = [
		Vector2i(1280, 720),
		Vector2i(1366, 768),
		Vector2i(1600, 900),
		Vector2i(1920, 1080),
	]
	for size in common_resolutions:
		resolution_option.add_item(str(size.x) + "x" + str(size.y))

	var current_size = DisplayServer.window_get_size()
	var selected_index = -1
	for i in range(common_resolutions.size()):
		if common_resolutions[i] == current_size:
			selected_index = i
			break

	if selected_index == -1:
		resolution_option.add_item("Текущее: " + str(current_size.x) + "x" + str(current_size.y))
		selected_index = resolution_option.item_count - 1

	resolution_option.selected = selected_index
	resolution_option.item_selected.connect(_on_resolution_selected)

	# === Сброс ===
	reset_button.pressed.connect(_on_reset_pressed)

	# === Назад ===
	back_button.pressed.connect(_on_back_pressed)

	# === Обновить состояние опции разрешения ===
	update_resolution_option_state()


# ─── Громкость музыки ───
func _on_music_volume_changed(value: float):
	var volume_normalized = value / 10.0
	MusicManager.set_volume(volume_normalized)

# ─── Громкость SFX ───
func _on_sfx_volume_changed(value: float):
	var volume_normalized = value / 10.0
	print("SFX volume set to: ", volume_normalized)

# ─── VSync ───
func _on_vsync_toggled():
	if vsync_check.button_pressed:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

# ─── FPS ───
func _on_fps_selected(index: int):
	var fps_values = [30, 60, 120, 144, 0]
	Engine.set_max_fps(fps_values[index])

# ─── Режим окна ───
func _on_window_mode_selected(index: int):
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	update_resolution_option_state()

func update_resolution_option_state():
	var is_windowed = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED
	resolution_option.disabled = not is_windowed
	if resolution_option.disabled:
		resolution_option.modulate = Color(0.5, 0.5, 0.5, 1)
	else:
		resolution_option.modulate = Color.WHITE

# ─── Разрешение ───
func _on_resolution_selected(index: int):
	var resolution_text = resolution_option.get_item_text(index)
	var parts = resolution_text.split("x")
	if parts.size() == 2:
		var width = int(parts[0])
		var height = int(parts[1])
		# Если сейчас полноэкранный — переключаем в оконный
		if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			window_mode_option.selected = 0
			update_resolution_option_state()
		DisplayServer.window_set_size(Vector2i(width, height))

# ─── Сброс настроек ───
func _on_reset_pressed():
	music_slider.value = 5
	_on_music_volume_changed(5)
	sfx_slider.value = 5
	_on_sfx_volume_changed(5)
	window_mode_option.selected = 0
	_on_window_mode_selected(0)
	vsync_check.button_pressed = true
	_on_vsync_toggled()
	fps_option.selected = 1
	_on_fps_selected(1)
	
	var default_res = Vector2i(1280, 720)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_size(default_res)
	update_resolution_option_state()
	
	var sizes = [
		Vector2i(1280, 720),
		Vector2i(1366, 768),
		Vector2i(1600, 900),
		Vector2i(1920, 1080),
	]
	var idx = sizes.find(default_res)
	if idx != -1:
		resolution_option.selected = idx
	print("Настройки сброшены к значениям по умолчанию")

# ─── Назад ───
func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
