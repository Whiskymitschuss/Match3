extends RefCounted
# Historical mechanic fixtures deliberately exercise the pre-0.21 boss schedule.
# Current production rules, content and art are covered by united_test/soak/capture.
static func apply(game:Node2D):game.united.enabled=false
