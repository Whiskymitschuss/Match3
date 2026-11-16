extends RefCounted
# A device-independent policy; tests inject a recorder instead of vibrating hardware.
const DURATIONS={'hurt':30,'ability':45,'level':60}
var last_pulse=-1000
func request(mode:String, kind:String, now:int, emit:Callable) -> bool:
	if mode not in ['LOW','HIGH'] or not DURATIONS.has(kind) or now-last_pulse<120:return false
	last_pulse=now
	emit.call(roundi(DURATIONS[kind]*(.65 if mode=='LOW' else 1.0)),.35 if mode=='LOW' else .8)
	return true
