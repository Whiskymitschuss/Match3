"""Original synthesized pneumatic drill, stone impact and undead boss cues. No samples."""
from pathlib import Path
import math, random, wave, struct
out=Path(__file__).resolve().parents[1]/'assets/audio';rate=44100
for name,duration in [('axel_warning',.65),('axel_slam',.65),('axel_drill',.48),('axel_charge',.55),('axel_rage',1.1),('axel_defeat',1.2)]:
 rng=random.Random(190);buf=[];low=0.
 for i in range(round(duration*rate)):
  t=i/rate;x=t/duration;noise=rng.uniform(-1,1);low=.94*low+.06*noise
  if name=='axel_warning':v=(math.sin(2*math.pi*(280*t+170*t*t))*.3+low*.4)*math.sin(math.pi*x)
  elif name=='axel_drill':v=(noise*.32+math.sin(2*math.pi*72*t)*.32)*(math.exp(-((t*19)%1)*7)*.8+.2)*math.exp(-t*2)
  elif name=='axel_slam':v=(math.sin(2*math.pi*(75*t-30*t*t))*.8+low*2+noise*.16)*math.exp(-t*8)
  elif name=='axel_charge':v=(low*2+math.sin(2*math.pi*(100*t+65*t*t))*.25)*math.sin(math.pi*x)
  elif name=='axel_rage':v=(math.sin(2*math.pi*(66*t+23*t*t))*.38+math.sin(2*math.pi*97*t)*.15+low*.7)*math.sin(math.pi*x)
  else:v=(math.sin(2*math.pi*(230*t-75*t*t))*.35+low*(1-x))*math.sin(math.pi*x)**1.8
  fade=max(0,min(1,t/.006,(duration-t)/.025));buf.append(struct.pack('<h',round(math.tanh(v)*.85*fade*32767)))
 with wave.open(str(out/(name+'.wav')),'wb') as w:w.setparams((1,2,rate,0,'NONE','not compressed'));w.writeframes(b''.join(buf))
print('Generated6 original Axel cues')
