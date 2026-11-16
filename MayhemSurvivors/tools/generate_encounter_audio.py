"""Original encounter accents, deterministic additive synthesis, no external samples."""
from pathlib import Path
import math,struct,wave
out=Path(__file__).resolve().parents[1]/'assets/audio'
for name,notes,step in [('elite_warning',[196,261.63,196],.15),('elite_reward',[392,493.88,587.33,783.99],.11),('boss_phase',[130.81,164.81,196,261.63],.16)]:
 rate=44100;duration=len(notes)*step+.25;data=[]
 for i in range(int(rate*duration)):
  t=i/rate;v=0.
  for j,f in enumerate(notes):
   local=t-j*step
   if local>=0:v+=(math.sin(2*math.pi*f*local)+.25*math.sin(2*math.pi*f*2*local))*math.exp(-local*9)*min(1,local/.008)*.36
  data.append(struct.pack('<h',int(math.tanh(v)*.75*min(1,(duration-t)/.012)*32767)))
 with wave.open(str(out/(name+'.wav')),'wb') as w:w.setparams((1,2,rate,0,'NONE','not compressed'));w.writeframes(b''.join(data))
print('Generated 3 original encounter cues')
