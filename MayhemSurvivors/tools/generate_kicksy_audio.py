"""Original Kicksy warning and charge Foley, deterministic synthesis, no samples."""
from pathlib import Path
import math,random,struct,wave
out=Path(__file__).resolve().parents[1]/'assets/audio'
rate=44100
for name,duration in [('ability_chain_reaction',.65),('bomb_throw',.34)]:
 rng=random.Random(130);samples=[];smooth=0.
 for i in range(round(duration*rate)):
  t=i/rate;x=t/duration;smooth=.9*smooth+.1*rng.uniform(-1,1)
  env=math.sin(math.pi*x)**.8
  if name=='ability_chain_reaction':v=(.27*math.sin(2*math.pi*(160*t+80*t*t))+.12*math.sin(2*math.pi*320*t))*(.65+.35*math.sin(t*40))*env
  else:v=(smooth*1.2+.2*math.sin(2*math.pi*(140*t-100*t*t)))*env
  samples.append(struct.pack('<h',round(math.tanh(v)*.8*min(1,t/.005,(duration-t)/.012)*32767)))
 with wave.open(str(out/(name+'.wav')),'wb') as w:w.setparams((1,2,rate,0,'NONE','not compressed'));w.writeframes(b''.join(samples))
print('Generated two original Kicksy cues')
