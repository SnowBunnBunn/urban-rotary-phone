extends Node

var inventory := {} # char_id -> { count:int, level:int, asc:int, chips:Array }
var teams := { "TeamA": [] }
var god_cards := []
var currencies := { "gems": 3000, "gold": 0 }

func add_character(char_id:String) -> void:
    if not inventory.has(char_id):
        inventory[char_id] = { "count": 1, "level": 1, "asc": 0, "chips": [] }
    else:
        inventory[char_id].count += 1

func apply_pull_results(results:Array) -> void:
    for r in results:
        add_character(r.id)

func team_power(ids:Array) -> int:
    var power := 0.0
    for cid in ids:
        if not DB.chars.has(cid): continue
        var ch := DB.chars[cid]
        var s := ch.base_stats
        power += s.atk*2.0 + s.hp*0.5 + s.def*1.2 + s.spd*1.5
    return int(power)
