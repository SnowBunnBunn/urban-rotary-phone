extends Control

@onready var single_btn:Button = $Margin/VBox/HBox/Single
@onready var ten_btn:Button = $Margin/VBox/HBox/Ten
@onready var banner_opt:OptionButton = $Margin/VBox/Banner
@onready var grid:GridContainer = $Margin/VBox/Results
@onready var back_btn:Button = $Margin/VBox/Back

var current_banner := "BNR_MULTIVERSE_MIX"

func _ready() -> void:
    _populate_banners()
    single_btn.pressed.connect(_on_single)
    ten_btn.pressed.connect(_on_ten)
    back_btn.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn"))

func _populate_banners():
    banner_opt.clear()
    var idx := 0
    for b in DB.banners:
        banner_opt.add_item("%s (%s)".sprintf([b.name, b.id]))
        banner_opt.set_item_metadata(idx, b.id)
        idx += 1
    banner_opt.item_selected.connect(func(i): current_banner = banner_opt.get_item_metadata(i))
    if idx > 0:
        banner_opt.select(0)
        current_banner = banner_opt.get_item_metadata(0)

func _on_single() -> void:
    var p := Gacha.pull_once(current_banner)
    if p.is_empty(): return
    GameState.apply_pull_results([p])
    _show_results([p])

func _on_ten() -> void:
    var rs := Gacha.pull_x10(current_banner)
    GameState.apply_pull_results(rs)
    _show_results(rs)

func _show_results(rs:Array) -> void:
    for c in grid.get_children():
        c.queue_free()
    for r in rs:
        var ch := DB.chars.get(r.id, null)
        if ch == null: continue
        var card := load("res://scenes/ui/CardGrid.tscn").instantiate()
        card.set_card(ch, r.rarity)
        grid.add_child(card)
