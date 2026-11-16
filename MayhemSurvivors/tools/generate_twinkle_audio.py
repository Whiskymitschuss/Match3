"""Original Twinkle Foley and accents. Deterministic synthesis, no external samples."""
from pathlib import Path
import math,random,struct,wave
out=Path(__file__).resolve().parents[1]/'assets/audio'
rate=44100
for name,duration in [('mop_swish',.32),('twinkle_heal',.65),('ability_twinkle_tornado',1.15)]:
 rng=random.Random(120);smooth=0.;samples=[]
 for i in range(round(duration*rate)):
  t=i/rate;x=t/duration;noise=rng.uniform(-1,1);smooth=.87*smooth+.13*noise
  env=math.sin(math.pi*x)**1.4
  if name=='mop_swish':
   value=((noise-smooth)*.32+smooth*.9)*env*(.7+.3*math.sin(t*37))
   value+=.13*math.sin(2*math.pi*(900*t-850*t*t))*math.exp(-t*15)
  elif name=='twinkle_heal':
   value=0
   for start,f in [(0,659.25),(.12,987.77)]:
    u=t-start
    if u>=0:value+=.35*math.sin(2*math.pi*f*u)*math.exp(-u*8)*min(1,u/.008)
  else:
   value=(smooth*.9+(noise-smooth)*.12)*env*(.7+.3*math.sin(t*45))
   value+=.12*math.sin(2*math.pi*(260*t+330*t*t))*env
   value+=.08*math.sin(2*math.pi*(520*t+500*t*t))*env
  value=math.tanh(value)*.8*min(1,t/.005,(duration-t)/.012)
  samples.append(struct.pack('<h',round(value*32767)))
 with wave.open(str(out/(name+'.wav')),'wb') as w:
  w.setparams((1,2,rate,0,'NONE','not compressed'));w.writeframes(b''.join(samples))
print('Generated original mop swish, healing chime and tornado whoosh')
