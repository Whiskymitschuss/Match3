"""Original deterministic synth effects; Python standard library, no downloaded samples."""
import math, random, struct, wave
from pathlib import Path
OUT=Path(__file__).resolve().parents[1]/'assets/audio'
def write(name, duration, function):
    rate=22050
    rng=random.Random(204)
    frames=[]
    for i in range(int(rate*duration)):
        t=i/rate
        envelope=min(1,t/.008)*(1-t/duration)**1.6
        v=max(-1,min(1,function(t,rng)*envelope*.6))
        frames.append(struct.pack('<h',int(v*32767)))
    with wave.open(str(OUT/(name+'.wav')),'wb') as w:
        w.setparams((1,2,rate,0,'NONE','not compressed'))
        w.writeframes(b''.join(frames))
write('ability_shockwave',.42,lambda t,r:.65*math.sin(2*math.pi*(110*t-70*t*t))+.22*r.uniform(-1,1))
write('ability_impulse',.25,lambda t,r:math.sin(2*math.pi*(380*t+1400*t*t))*.7)
write('ability_explosion',.4,lambda t,r:.6*r.uniform(-1,1)+.4*math.sin(2*math.pi*65*t))
write('ability_shadow_step',.22,lambda t,r:.45*r.uniform(-1,1)+.45*math.sin(2*math.pi*(1200*t-2100*t*t)))
