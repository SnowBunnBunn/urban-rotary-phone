extends Node

const SAVE_PATH := "user://save.json"

func save_all() -> void:
    var data = {
        "inventory": GameState.inventory,
        "teams": GameState.teams,
        "currencies": GameState.currencies,
        "pity": Gacha.pity_counter
    }
    var f := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
    if f:
        f.store_string(JSON.stringify(data))
        f.close()

func load_all() -> void:
    if not FileAccess.file_exists(SAVE_PATH): return
    var f := FileAccess.open(SAVE_PATH, FileAccess.READ)
    if f == null: return
    var txt := f.get_as_text()
    f.close()
    var d := JSON.parse_string(txt)
    if typeof(d) != TYPE_DICTIONARY: return
    GameState.inventory = d.get("inventory", {})
    GameState.teams = d.get("teams", { "TeamA": [] })
    GameState.currencies = d.get("currencies", { "gems": 0, "gold": 0 })
    Gacha.pity_counter = int(d.get("pity", 0))
