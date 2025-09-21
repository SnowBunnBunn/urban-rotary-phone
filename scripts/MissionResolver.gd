extends Node

var sim := preload("res://scripts/BattleSimulator.gd").new()

func run_mission(mission_id:String, team_key:String, god_cards:Array=[]) -> Dictionary:
    var mission := {}
    for m in DB.missions:
        if m.get("id","") == mission_id:
            mission = m
            break
    var team_ids:Array = GameState.teams.get(team_key, [])
    var res := sim.simulate(team_ids, mission.get("recommended_power",1000), god_cards)
    if res.get("win",false):
        var gmin := int(mission.rewards.gold[0])
        var gmax := int(mission.rewards.gold[1])
        var g := RNG.randi_range(gmin, gmax)
        GameState.currencies.gold += g
    return res
