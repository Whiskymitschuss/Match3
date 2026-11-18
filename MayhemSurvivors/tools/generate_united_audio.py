"""Original synth Foley for the unified weapons, abilities and boss warnings."""
from pathlib import Path
import math,random,wave,struct
root=Path(__file__).resolve().parents[1]/'assets/audio';rate=44100
names=['united_flame','united_cryo','united_tesla','united_lance','united_chakram','united_warning','united_rage','united_impact','united_pyro','ability_firestorm','ability_absolute_zero','ability_overcharge','ability_bastion','ability_phase_dance']
for k,name in enumerate(names):
 duration=.85 if name in ['united_warning','united_rage'] else .4;buf=[];rng=random.Random(210+k);low=0
 for i in range(round(rate*duration)):
  t=i/rate;x=t/duration;noise=rng.uniform(-1,1);low=.92*low+.08*noise
  freq=[95,600,330,140,450,520,75,65,90,100,720,360,160,500][k]
  envelope=math.sin(math.pi*x)**.6 if 'ability' in name or 'warning' in name or 'rage' in name else math.exp(-t*9)
  signal=(.35*math.sin(2*math.pi*(freq*t+(100 if k%2 else -20)*t*t))+.12*math.sin(2*math.pi*freq*1.5*t)+low*(2 if k in [0,7,8,9] else .4))*envelope
  if name=='united_tesla':signal+=noise*.12*envelope
  fade=max(0,min(1,t/.005,(duration-t)/.02));buf.append(struct.pack('<h',round(math.tanh(signal)*.8*fade*32767)))
 with wave.open(str(root/(name+'.wav')),'wb') as w:w.setparams((1,2,rate,0,'NONE','not compressed'));w.writeframes(b''.join(buf))
print('Generated14 original United cues')
