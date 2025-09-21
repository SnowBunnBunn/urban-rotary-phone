extends Node

var _rng := RandomNumberGenerator.new()

func _ready() -> void:
    _rng.randomize()

func randf() -> float:
    return _rng.randf()

func randi_range(a:int, b:int) -> int:
    return _rng.randi_range(a,b)
