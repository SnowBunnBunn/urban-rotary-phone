extends Control

@onready var gacha_btn:Button = $Center/VBox/Gacha
@onready var quit_btn:Button = $Center/VBox/Quit

func _ready() -> void:
    SaveManager.load_all()
    gacha_btn.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/ui/GachaView.tscn"))
    quit_btn.pressed.connect(_on_quit)

func _on_quit() -> void:
    SaveManager.save_all()
    get_tree().quit()
