"""Original SVG arena equipment and three original PCM cues. Standard library only."""
from pathlib import Path
import math,random,struct,wave
root=Path(__file__).resolve().parents[1]
shapes={
 'gardens':('#A0DC58','<path d="M51 34h58v80H51z" fill="#314e43"/><path d="M57 53h46M57 69h46M57 85h46" stroke="#caff91" stroke-width="7"/><path d="M80 30c-26-26-39-9-26 8 9 10 26 4 26-8zM81 30c26-26 39-9 26 8-9 10-26 4-26-8z" fill="#9be45a"/><path d="m70 109 10-12 10 12-10 13z" fill="#e9ffa9"/>'),
 'frost':('#FFBF69','<path d="M49 112V49l20-12v75M82 112V36l27 14v62" fill="#53697a"/><path d="M57 102V55M91 102V52" stroke="#ffd37a" stroke-width="10"/><path d="M80 24c16 25-17 28 0 48-32-12-27-31 0-48z" fill="#ff8248"/><path d="m36 44 12 8m65 28 12 8M31 95l13-7" stroke="#89edff" stroke-width="5"/>'),
 'storm':('#6DC4FF','<path d="M72 125V57h16v68M42 123h76" fill="#687e94"/><path d="M42 123h76M80 124V64" stroke="#a0d6e5" stroke-width="9"/><path d="m89 21-35 46h25l-8 29 36-48H82z" fill="#ffdc72"/><path d="M42 36 29 26m94 78 12 8" stroke="#b9f6ff" stroke-width="6"/>'),
 'crystal':('#DB8AFF','<path d="m80 24 30 41-12 41H62L50 65z" fill="#c779ef"/><path d="m80 24 0 82M50 65h60M80 106l18-41" stroke="#f5c1ff" stroke-width="5"/><path d="m48 117 32-11 32 11-10 15H58z" fill="#52657d"/><path d="m29 42 5 10 11 4-11 4-5 11-4-11-10-4 10-4z" fill="#ffedaf"/>'),
 'carnival':('#FF8AC9','<path d="M49 54 78 32l31 22-8 35H59z" fill="#e575c0"/><circle cx="80" cy="83" r="30" fill="#2c3046"/><path d="M80 53c-4-16 16-13 21-25" fill="none" stroke="#ffd166" stroke-width="7"/><path d="m101 17 5 9 10 2-8 7 2 10-10-5-10 5 2-10-8-7 11-2z" fill="#ffb641"/><path d="m64 83 9 7 18-16" fill="none" stroke="#ffb8ec" stroke-width="6"/><path d="M46 119h68" stroke="#eae2ff" stroke-width="10"/>'),
 'void':('#BD79FF','<ellipse cx="80" cy="78" rx="42" ry="27" fill="#16152e" stroke="#a36cff" stroke-width="9"/><ellipse cx="80" cy="78" rx="27" ry="15" fill="#513a7b" stroke="#d5bcff" stroke-width="4"/><path d="M80 22v26M80 107v25M27 78h18M115 78h18" stroke="#efcfff" stroke-width="7"/><path d="m68 78 12-10 12 10-12 10z" fill="#50f5df"/>')}
for id,(color,shape) in shapes.items():
 svg=f'<svg xmlns="http://www.w3.org/2000/svg" width="160" height="160" viewBox="0 0 160 160"><defs><linearGradient id="metal" x2="0" y2="1"><stop stop-color="#7d8ba2"/><stop offset=".5" stop-color="#33425d"/><stop offset="1" stop-color="#16182d"/></linearGradient><radialGradient id="glow"><stop stop-color="{color}" stop-opacity=".38"/><stop offset="1" stop-color="{color}" stop-opacity="0"/></radialGradient></defs><circle cx="80" cy="80" r="78" fill="url(#glow)"/><path d="m31 24 98 0 17 24v70l-18 22H32l-18-22V48z" fill="url(#metal)" stroke="#100d23" stroke-width="8" stroke-linejoin="round"/><path d="M35 34h90M35 129h90" stroke="{color}" stroke-width="4"/><g stroke="#121124" stroke-width="5" stroke-linejoin="round">{shape}</g><g fill="#b8c8dc" stroke="#172039" stroke-width="2"><circle cx="30" cy="47" r="4"/><circle cx="130" cy="47" r="4"/><circle cx="30" cy="116" r="4"/><circle cx="130" cy="116" r="4"/></g></svg>'
 (root/'assets/environments'/('tool_'+id+'.svg')).write_text(svg)
for index,(id,duration) in enumerate([('arena_ready',.32),('arena_arm',.65),('arena_pulse',.42)]):
 rng=random.Random(2700+index);samples=[];rate=44100
 for i in range(round(rate*duration)):
  t=i/rate;u=t/duration;envelope=min(1,t/.008)*(1-u)**2
  if index==0:value=(math.sin(math.tau*(660*t+180*t*t))+.35*math.sin(math.tau*990*t))*.27
  elif index==1:value=(math.sin(math.tau*(180*t+500*t*t))+.2*rng.uniform(-1,1))*.36
  else:value=(math.sin(math.tau*(110*t-60*t*t))+.55*rng.uniform(-1,1)*math.exp(-t*11))*.48
  samples.append(struct.pack('<h',round(max(-.95,min(.95,value*envelope))*32767)))
 with wave.open(str(root/'assets/audio'/(id+'.wav')),'wb') as out:out.setparams((1,2,rate,0,'NONE','not compressed'));out.writeframes(b''.join(samples))
print('Generated six original equipment SVGs and three original finite PCM cues.')
