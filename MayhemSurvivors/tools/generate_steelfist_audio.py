"""Original deterministic metal, valve/water and regeneration Foley. No samples."""
from pathlib import Path
import math, random, struct, wave
out=Path(__file__).resolve().parents[1]/'assets/audio'
rate=44100
for name,duration in [('steel_swing',.36),('ability_pipe_burst',1.25),('steel_regen',.32)]:
 rng=random.Random(170);samples=[];low=0.
 for i in range(round(duration*rate)):
  t=i/rate;noise=rng.uniform(-1,1);low=.94*low+.06*noise
  if name=='steel_swing':
   env=math.exp(-t*12);v=(.18*math.sin(2*math.pi*315*t)+.12*math.sin(2*math.pi*843*t)+.07*math.sin(2*math.pi*1521*t))*env+low*.9*math.sin(math.pi*t/duration)**2
  elif name=='ability_pipe_burst':
   v=(low*1.8+noise*.09)*math.sin(math.pi*t/duration)**.7+.38*math.sin(2*math.pi*(95*t-20*t*t))*math.exp(-t*7)
   v+=.07*math.sin(2*math.pi*(700*t+160*t*t))*math.exp(-t*3)
  else:v=(.23*math.sin(2*math.pi*660*t)+.15*math.sin(2*math.pi*990*t))*math.sin(math.pi*t/duration)**1.6
  edge=max(0,min(1,t/.005,(duration-t)/.02));samples.append(struct.pack('<h',round(math.tanh(v)*.85*edge*32767)))
 with wave.open(str(out/(name+'.wav')),'wb') as w:w.setparams((1,2,rate,0,'NONE','not compressed'));w.writeframes(b''.join(samples))
print('Generated three original Steelfist cues')
