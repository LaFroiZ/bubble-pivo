extends Node


#var music_path = "res://assets/sounds/music/menu_theme.mp3"
var music_path = "res://assets/sounds/music/nyan_cat.mp3"

# Ссылка на AudioStreamPlayer (будет создан в _ready)
var music_player: AudioStreamPlayer

# Текущая громкость (от 0.0 до 1.0, по умолчанию 0.5 = 50%)
var current_volume: float = 0.2

func _ready():
	# Создаём AudioStreamPlayer программно
	music_player = AudioStreamPlayer.new()
	
	# Загружаем музыкальный файл
	music_player.stream = load(music_path)
	
	# Ставим автозапуск (музыка начнётся сразу)
	music_player.autoplay = true
	
	# Устанавливаем громкость по умолчанию (50%)
	music_player.volume_db = linear_to_db(current_volume)
	
	# Добавляем плеер в дерево сцены
	add_child(music_player)
	
	# Запускаем музыку
	music_player.play()

# ─────────────────────────────────────────────
# Установить громкость (значение от 0.0 до 1.0)
# ─────────────────────────────────────────────
func set_volume(value: float):
	current_volume = clamp(value, 0.0, 1.0)  # Ограничиваем от 0 до 1
	music_player.volume_db = linear_to_db(current_volume)

# ─────────────────────────────────────────────
# Получить текущую громкость (от 0.0 до 1.0)
# ─────────────────────────────────────────────
func get_volume() -> float:
	return current_volume

# ─────────────────────────────────────────────
# Включить/выключить музыку (переключение)
# ─────────────────────────────────────────────
func toggle_music():
	music_player.playing = !music_player.playing

# ─────────────────────────────────────────────
# Проверить, играет ли музыка
# ─────────────────────────────────────────────
func is_playing() -> bool:
	return music_player.playing

# ─────────────────────────────────────────────
# Функция для преобразования линейного значения (0-1) в децибелы (dB)
# Нужна для AudioStreamPlayer.volume_db
# ─────────────────────────────────────────────
func linear_to_db(value: float) -> float:
	if value <= 0.0:
		return -80.0  # Полная тишина
	return 20.0 * log(value) / log(10.0)
