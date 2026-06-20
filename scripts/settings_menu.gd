extends Node2D

# ═══════════════════════════════════════════════
# SettingsMenu — скрипт меню настроек
# Управляет громкостью музыки и возвратом в меню
# ═══════════════════════════════════════════════

# Ссылки на узлы (назначаются через @onready)
@onready var volume_slider = $VBoxContainer/HSlider
@onready var back_button = $VBoxContainer/Button_Back

# ─────────────────────────────────────────────
# Вызывается при загрузке сцены
# ─────────────────────────────────────────────
func _ready():
	# Устанавливаем значение ползунка из глобального менеджера музыки
	# MusicManager хранит громкость от 0.0 до 1.0, а у нас шкала от 0 до 10
	var saved_volume = MusicManager.get_volume()
	volume_slider.value = saved_volume * 10  # Переводим 0.5 → 5
	
	# Подключаем сигналы
	volume_slider.value_changed.connect(_on_volume_changed)
	back_button.pressed.connect(_on_back_pressed)

# ─────────────────────────────────────────────
# Срабатывает при изменении ползунка громкости
# value — текущее значение от 0 до 10
# ─────────────────────────────────────────────
func _on_volume_changed(value: float):
	# Переводим значение из шкалы 0-10 в 0.0-1.0
	var volume_normalized = value / 10.0
	
	# Обновляем громкость в глобальном менеджере
	MusicManager.set_volume(volume_normalized)

# ─────────────────────────────────────────────
# Кнопка "Назад" — возвращает в главное меню
# ─────────────────────────────────────────────
func _on_back_pressed():
	# Переключаемся обратно на главное меню
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
