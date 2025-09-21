extends Control

@onready var name_lbl:Label = $Margin/Panel/VBox/Name
@onready var rarity_lbl:Label = $Margin/Panel/VBox/Rarity
@onready var series_lbl:Label = $Margin/Panel/VBox/Series

func set_card(ch:Dictionary, rarity:String):
    name_lbl.text = ch.get("name","?")
    rarity_lbl.text = rarity
    series_lbl.text = ch.get("series","")
    modulate = _rarity_color(rarity)

func _rarity_color(r:String)->Color:
    match r:
        "SSR": return Color(1, 0.92, 0.25)
        "SR": return Color(0.7, 0.85, 1.0)
        _: return Color(1,1,1)
