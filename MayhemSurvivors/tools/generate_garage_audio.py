"""Original case, workbench and spell synthesis; no samples or dependencies."""
from pathlib import Path
import math,random,wave,struct
out=Path(__file__).resolve().parents[1]/'assets/audio';rate=44100
for name,duration in [('case_open',1.0),('case_reveal',.7),('garage_upgrade',.45),('garage_equip',.16),('spell_heal_pulse',.5),('spell_frost_nova',.6),('spell_phase_blink',.4)]:
 rng=random.Random(180);buf=[];low=0.
 for i in range(round(duration*rate)):
  t=i/rate;x=t/duration;low=.9*low+.1*rng.uniform(-1,1);env=math.sin(math.pi*x)**.7
  f=160 if name=='case_open' else (440 if name in ['case_reveal','garage_upgrade'] else (660 if name=='spell_heal_pulse' else 270))
  v=(.22*math.sin(2*math.pi*(f*t+100*t*t))+.12*math.sin(2*math.pi*f*1.5*t)+low*(.8 if 'spell' in name else .3))*env
  if name=='garage_equip':v=(.28*math.sin(t*math.pi*1400)+low)*math.exp(-t*22)
  fade=max(0,min(1,t/.005,(duration-t)/.02));buf.append(struct.pack('<h',round(math.tanh(v)*.8*fade*32767)))
 with wave.open(str(out/(name+'.wav')),'wb') as w:w.setparams((1,2,rate,0,'NONE','not compressed'));w.writeframes(b''.join(buf))
print('Generated7 original garage and spell cues')
