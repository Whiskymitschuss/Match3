"""Original deterministic RF Worlds synth score and layered SFX; no external samples."""
from pathlib import Path
import numpy as np, subprocess, wave
ROOT=Path(__file__).resolve().parents[1]/'assets/audio'
SR=44100

def note(m):return 440*2**((m-69)/12)
def write(name,data):
 data=np.asarray(data);data=np.tanh(data*.9);data*=.88/max(.01,np.max(np.abs(data)))
 path=ROOT/(name+'.wav')
 with wave.open(str(path),'wb') as w:
  channels=1 if data.ndim==1 else data.shape[1];w.setparams((channels,2,SR,0,'NONE','not compressed'));w.writeframes((data*32767).astype('<i2').tobytes())
 return path

def score(name,bpm,energy):
 beat=60/bpm;duration=beat*64;n=int(duration*SR);mix=np.zeros((n,2));rng=np.random.default_rng(2600+energy)
 def put(signal,when,gain=1,pan=0):
  start=int(when*SR);length=len(signal);idx=(start+np.arange(length))%n
  mix[idx,0]+=signal*gain*np.sqrt((1-pan)*.5);mix[idx,1]+=signal*gain*np.sqrt((1+pan)*.5)
 def tone(m,length,kind='pluck'):
  t=np.arange(int(length*SR))/SR;f=note(m)
  if kind=='bass':s=np.sin(2*np.pi*f*t)+.2*np.sin(2*np.pi*f*2*t);env=np.minimum(1,t/.009)*np.exp(-t*3)
  elif kind=='pad':s=sum(np.sin(2*np.pi*f*(1+d)*t) for d in [-.003,0,.003])/3;env=np.minimum(1,t/.15)*np.minimum(1,(length-t)/.2)*.35
  else:s=np.sin(2*np.pi*f*t)+.27*np.sin(2*np.pi*f*2*t)+.10*np.sin(2*np.pi*f*4*t);env=np.minimum(1,t/.006)*np.exp(-t*(5 if kind=='pluck' else 2.5))
  return s*env
 def kick():
  t=np.arange(int(.3*SR))/SR;phase=2*np.pi*(48*t+115*(1-np.exp(-t*24))/24);return np.sin(phase)*np.exp(-t*16)+rng.normal(0,.13,len(t))*np.exp(-t*120)
 def snare():
  t=np.arange(int(.2*SR))/SR;noise=rng.normal(0,1,len(t));high=noise-np.convolve(noise,np.ones(9)/9,'same');return (high*.45+np.sin(2*np.pi*185*t)*.4)*np.exp(-t*20)
 def hat():
  t=np.arange(int(.065*SR))/SR;noise=rng.normal(0,.5,len(t));return (noise-np.convolve(noise,np.ones(4)/4,'same'))*np.exp(-t*80)
 progression=[40,40,36,38,40,43,36,38]
 motif=[0,7,12,10,7,3,5,7]
 for bar in range(16):
  root=progression[bar%8];at=bar*4*beat
  for interval in [0,3,7]:put(tone(root+12+interval,4*beat,'pad'),at,.28,-.35+interval*.1)
  for step in range(8):
   when=at+step*beat/2;put(tone(root+(12 if step in [3,7] else 0),beat*.45,'bass'),when,.5 if energy else .32)
   put(hat(),when,.14 if energy else .07,(-.4 if step%2 else .4))
   if step%2==0 or energy>=2:put(tone(root+24+motif[(step+bar)%8],beat*.65,'pluck'),when,.13 if energy else .16,(-.5 if step%2 else .5))
  for step in ([0,2,3] if energy>=2 else [0,2]):put(kick(),at+step*beat,.6 if energy else .30)
  for step in [1,3]:put(snare(),at+step*beat,.35 if energy else .12)
  if energy and bar%4==3:
   for step in range(4):put(snare(),at+(3+step*.25)*beat,.10+step*.025,.15)
 # A short stereo delay creates space without masking cues; endpoints meet at a quiet zero crossing.
 dry=mix.copy();delay=int(beat*.75*SR);mix+=np.roll(dry[:,::-1],delay,axis=0)*.13
 edge=min(256,n//2);mix[:edge]*=np.linspace(0,1,edge)[:,None];mix[-edge:]*=np.linspace(1,0,edge)[:,None]
 path=write(name,mix);subprocess.run(['ffmpeg','-v','error','-y','-i',str(path),'-c:a','libvorbis','-q:a','4',str(ROOT/(name+'.ogg'))],check=True);path.unlink()
 print('SCORE',name,round(duration,2),'seconds',flush=True)

def sfx(name,kind,length=.35):
 rng=np.random.default_rng(sum(name.encode())+2600);t=np.arange(int(length*SR))/SR;noise=rng.normal(0,1,len(t));low=np.convolve(noise,np.ones(80)/80,'same');high=noise-np.convolve(noise,np.ones(7)/7,'same')
 if kind=='gun':s=high*np.exp(-t*55)*.55+low*np.exp(-t*17)*3+np.sin(2*np.pi*(58*t+6*(1-np.exp(-t*25))))*np.exp(-t*25)*.45
 elif kind=='heavy':s=low*np.exp(-t*11)*5+high*np.exp(-t*22)*.3+np.sin(2*np.pi*43*t)*np.exp(-t*12)*.7
 elif kind=='metal':s=sum(np.sin(2*np.pi*f*t)*np.exp(-t*(14+i*4)) for i,f in enumerate([230,631,1451]))*.25+high*np.exp(-t*32)*.4
 elif kind=='heal':s=sum(np.sin(2*np.pi*f*t)*np.exp(-t*5) for f in [523.25,659.25,783.99])*.23
 elif kind=='toxin':s=low*np.exp(-t*4)*2+np.sin(2*np.pi*(190*t+20*t*t))*np.exp(-t*7)*.25
 elif kind=='sonic':s=np.sin(2*np.pi*(55*t+12*(1-np.exp(-t*12))))*np.exp(-t*7)+high*np.exp(-t*18)*.2
 elif kind=='electric':s=np.sin(2*np.pi*(700*t+200*t*t))*np.exp(-t*14)*.3+high*np.exp(-t*15)*.35
 else:s=np.sin(2*np.pi*880*t)*np.exp(-t*30)*.3+high*np.exp(-t*70)*.10
 s*=np.minimum(1,t/.002);write(name,s);print('SFX',name,flush=True)

if __name__=='__main__':
 for n,b,e in [('menu_theme',104,0),('combat_theme',136,1),('boss_theme',148,2)]:score(n,b,e)
 for name,kind,length in [('blaster_fire','gun',.24),('splitgun_fire','heavy',.38),('hammer_slam','heavy',.45),('hit','metal',.19),('death','metal',.24),('arc_zap','electric',.30),('click','ui',.10),('skin_equip','electric',.30),('ability_toxin_cloud','toxin',.75),('ability_sonic_burst','sonic',.65),('ability_light_pulse','heal',.75),('ability_repair_drone','electric',.5),('crew_heal','heal',.28),('drone_pulse','gun',.14)]:sfx(name,kind,length)
