extends CanvasLayer

# ═══════════════════════════════════════════════
# MainMenu — скрипт главного меню
# Управляет кнопками и переходами между сценами

@onready var new_game_button = $TextureButton_NewGame/Button_NewGame  # Первая кнопка
@onready var load_button =  $TextureButton_LoadGame/Button_LoadGame # Вторая кнопка
@onready var settings_button = $TextureButton_Settings/Button_Settings# Третья кнопка
@onready var quit_button = $TextureButton_QuitGame/Button_QuitGame     # Четвёртая кнопка


func _ready():
	new_game_button.pressed.connect(_on_new_game_pressed)
	load_button.pressed.connect(_on_load_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	quit_button.pressed.connect(_on_quit_pressed)


func _on_new_game_pressed():
	# Переключаемся на игровую сцену
	# Пока просто выводим сообщение в консоль
	print("Запуск новой игры...")
	get_tree().change_scene_to_file("res://scenes/game/game_level.tscn")

# ─────────────────────────────────────────────
# Кнопка "Загрузить игру"
# ─────────────────────────────────────────────
func _on_load_pressed():
	# Здесь будет загрузка сохранения
	print("Загрузка игры...")

# ─────────────────────────────────────────────
# Кнопка "Настройки"
# ─────────────────────────────────────────────
func _on_settings_pressed():
	# Переходим на сцену настроек
	get_tree().change_scene_to_file("res://scenes/settings/settings_menu.tscn")

# ─────────────────────────────────────────────
# Кнопка "Выйти из игры"
# ─────────────────────────────────────────────
func _on_quit_pressed():
	# Закрываем игру
	get_tree().quit()
