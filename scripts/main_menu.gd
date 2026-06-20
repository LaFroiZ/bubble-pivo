extends Node2D

# ═══════════════════════════════════════════════
# MainMenu — скрипт главного меню
# Управляет кнопками и переходами между сценами
# ═══════════════════════════════════════════════

# Ссылки на кнопки (назначаются в инспекторе или через @onready)
@onready var new_game_button = $VBoxContainer/Button_NewGame  # Первая кнопка
@onready var load_button = $VBoxContainer/Button_LoadGame     # Вторая кнопка
@onready var settings_button = $VBoxContainer/Button_Settings # Третья кнопка
@onready var quit_button = $VBoxContainer/Button_QuitGame     # Четвёртая кнопка

# ─────────────────────────────────────────────
# Вызывается при загрузке сцены
# ─────────────────────────────────────────────
func _ready():
	# Подключаем сигналы кнопок к функциям
	new_game_button.pressed.connect(_on_new_game_pressed)
	load_button.pressed.connect(_on_load_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

# ─────────────────────────────────────────────
# Кнопка "Новая игра"
# ─────────────────────────────────────────────
func _on_new_game_pressed():
	# Переключаемся на игровую сцену
	# Пока просто выводим сообщение в консоль
	print("Запуск новой игры...")
	# get_tree().change_scene_to_file("res://scenes/game/game_level.tscn")

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
