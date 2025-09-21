extends Node

var chars:Dictionary = {}
var banners:Array = []
var rates:Dictionary = {}
var missions:Array = []

func _ready() -> void:
    chars = _load_json("res://data/characters.json")
    banners = _load_json("res://data/banners.json")
    rates = _load_json("res://data/rates.json")
    missions = _load_json("res://data/missions.json")

func _load_json(path:String):
    var f := FileAccess.open(path, FileAccess.READ)
    if f == null:
        push_error("Cannot open JSON: %s" % path)
        return {}
    var txt := f.get_as_text()
    f.close()
    var parsed = JSON.parse_string(txt)
    if typeof(parsed) == TYPE_NIL:
        push_error("Invalid JSON: %s" % path)
        return {}
    return parsed

func get_banner(id:String) -> Dictionary:
    for b in banners:
        if b.get("id","") == id:
            return b
    return {}

func pool_for_banner(banner:Dictionary) -> Array:
    var pool:Array = []
    for id in chars.keys():
        var ch:Dictionary = chars[id]
        if not ch.get("tags", []).has("female_only"):
            continue
        var ok := true
        if banner.has("pool_tags"):
            for t in banner.pool_tags:
                if t == "female_only":
                    continue
                if not ch.get("tags", []).has(t) and ch.get("series","") != t:
                    ok = false
                    break
        if ok and banner.has("exclude_tags"):
            for t in banner.exclude_tags:
                if ch.get("tags", []).has(t):
                    ok = false
                    break
        if ok:
            pool.append(ch)
    return pool
