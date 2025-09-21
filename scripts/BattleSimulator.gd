extends Node

class Unit:
    var id:String
    var name:String
    var stats := {"atk":0,"hp":0,"def":0,"spd":100,"crit":0.05}
    var hp:int
    var path:String
    var team:int
    func _init(d:Dictionary, team:int):
        id = d.get("id","?")
        name = d.get("name","Unit")
        stats = d.get("base_stats", stats)
        hp = int(stats.hp)
        path = d.get("path","DPS")
        self.team = team

func simulate(team_a_ids:Array, team_b_power:int, god_mods:Array) -> Dictionary:
    var team_a:Array[Unit] = []
    for cid in team_a_ids:
        if not DB.chars.has(cid): continue
        var ch := DB.chars[cid]
        team_a.append(Unit.new(ch, 0))
    var team_b:Array[Unit] = _generate_enemy(team_b_power)

    for gm in god_mods:
        _apply_god_card(team_a, gm)

    var rounds := 0
    while rounds < 20 and _alive(team_a) and _alive(team_b):
        var order := _speed_order(team_a, team_b)
        for u in order:
            if u.hp <= 0: continue
            var target := _pick_target(u.team == 0 ? team_b : team_a)
            if target == null: break
            var dmg := max(1, int(u.stats.atk * 1.0) - int(target.stats.def * 0.3))
            target.hp -= dmg
        rounds += 1

    var win := _alive(team_a) and not _alive(team_b)
    var stars := win ? (rounds <= 10 ? 3 : (rounds <= 15 ? 2 : 1)) : 0
    return { "win": win, "rounds": rounds, "stars": stars }

func _alive(t:Array[Unit])->bool:
    for u in t:
        if u.hp > 0: return true
    return false

func _speed_order(a:Array[Unit], b:Array[Unit])->Array[Unit]:
    var all := a.duplicate() + b.duplicate()
    all.sort_custom(func(x,y): return x.stats.spd > y.stats.spd)
    return all

func _pick_target(team:Array[Unit])->Unit:
    var alive := []
    for u in team:
        if u.hp > 0: alive.append(u)
    if alive.is_empty(): return null
    return alive[RNG.randi_range(0, alive.size()-1)]

func _generate_enemy(power:int)->Array[Unit]:
    var out:Array[Unit] = []
    for i in 3:
        var d = {
            "id": "ENEMY_%s" % i,
            "name": "Beast %s" % i,
            "path": "DPS",
            "base_stats": {"atk": 60 + power/15, "hp": 400 + power/3, "def": 30 + power/20, "spd": 95, "crit":0.05}
        }
        out.append(Unit.new(d, 1))
    return out

func _apply_god_card(team:Array[Unit], card:String) -> void:
    match card:
        "GOD_ATK_UP":
            for u in team: u.stats.atk *= 1.2
        "GOD_SHIELD":
            for u in team: u.hp += 100
        _:
            pass
