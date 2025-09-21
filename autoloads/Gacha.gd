extends Node

const RARITIES := ["R","SR","SSR"]

var pity_counter := 0
var currency := { "gems": 0, "tickets": 0 }

func pull_once(banner_id:String) -> Dictionary:
    var banner := DB.get_banner(banner_id)
    var rarity := _roll_rarity()
    pity_counter += 1
    if pity_counter >= int(DB.rates.hard_pity):
        rarity = "SSR"
    if rarity == "SSR":
        pity_counter = 0

    var pool := []
    for ch in DB.pool_for_banner(banner):
        if ch.rarity == rarity:
            pool.append(ch)
    if pool.is_empty():
        push_error("Pool empty for rarity %s" % rarity)
        return {}

    # rate-up
    if rarity == "SSR" and banner.has("rate_up") and RNG.randf() < float(DB.rates.rate_up.on_banner):
        var ru_ids:Array = banner.rate_up
        var pik_id := ru_ids[RNG.randi_range(0, ru_ids.size()-1)]
        return { "rarity": rarity, "id": pik_id }

    var pick := pool[RNG.randi_range(0, pool.size()-1)]
    return { "rarity": rarity, "id": pick.id }

func pull_x10(banner_id:String) -> Array:
    var res:Array = []
    var has_sr_plus := false
    for i in 10:
        var p := pull_once(banner_id)
        if p.is_empty(): continue
        if p.rarity != "R": has_sr_plus = true
        res.append(p)
    if not has_sr_plus:
        res[res.size()-1] = _force_min_rarity(banner_id, "SR")
    return res

func _roll_rarity() -> String:
    var base := DB.rates.base
    var roll := RNG.randf()
    var ssr_base := float(base.SSR)
    var sp := DB.rates.soft_pity
    if pity_counter >= int(sp.start):
        var steps := pity_counter - int(sp.start)
        ssr_base = min(ssr_base + steps * float(sp.step), float(sp.cap))
    if roll < ssr_base:
        return "SSR"
    elif roll < ssr_base + float(base.SR):
        return "SR"
    return "R"

func _force_min_rarity(banner_id:String, rarity:String) -> Dictionary:
    var banner := DB.get_banner(banner_id)
    var pool := []
    for ch in DB.pool_for_banner(banner):
        if ch.rarity == rarity:
            pool.append(ch)
    var pick := pool[RNG.randi_range(0, pool.size()-1)]
    return { "rarity": rarity, "id": pick.id }
