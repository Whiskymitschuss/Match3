"""RF Worlds original deterministic synthesized combat accents. No third-party samples."""
import math, random, struct, wave
from pathlib import Path
out=Path(__file__).resolve().parents[1]/'assets/audio'
for name,duration in [('crit_punch',.22),('coin_epic',.55),('signature_blast',.42)]:
 rng=random.Random(320);frames=[];rate=22050
 for i in range(int(rate*duration)):
  t=i/rate;env=min(1,t/.004)*(1-t/duration)**2
  if name=='crit_punch':v=.55*math.sin(2*math.pi*(145*t-170*t*t))+.25*rng.uniform(-1,1)*math.exp(-t*28)
  elif name=='coin_epic':
   note=[659.25,830.61,987.77,1318.51][min(3,int(t/.09))];v=.35*math.sin(2*math.pi*note*t)+.12*math.sin(2*math.pi*note*2*t)
  else:v=.45*math.sin(2*math.pi*(85*t-40*t*t))+.2*rng.uniform(-1,1)+.14*math.sin(2*math.pi*(460*t-450*t*t))
  frames.append(struct.pack('<h',int(max(-.9,min(.9,v*env))*32767)))
 with wave.open(str(out/(name+'.wav')),'wb') as w:
  w.setparams((1,2,rate,0,'NONE','not compressed'));w.writeframes(b''.join(frames))
