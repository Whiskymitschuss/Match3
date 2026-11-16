"""RF Worlds original DSP sound design and music. No sampled/copied recordings.
Requires numpy/scipy for regeneration, not for playing/exporting the game.
Two seamless 8-bar loops, melodic stingers, layered foley/sci-fi impacts.
"""
from pathlib import Path
import math, wave, subprocess
import numpy as np
from scipy.signal import butter, sosfilt
OUT=Path(__file__).resolve().parents[1]/'assets/audio'
RATE=44100
rng=np.random.default_rng(808)
def tone(freq,t):return np.sin(2*np.pi*freq*t)
def noise(n,low=250,high=10000):
 return sosfilt(butter(2,[low,high],btype='bandpass',fs=RATE,output='sos'),rng.uniform(-1,1,n))
def write(name,y):
 y=np.asarray(y);y=np.tanh(y*1.15)*.78
 n=min(150,len(y)//4);y[:n]*=np.linspace(0,1,n);y[-n:]*=np.linspace(1,0,n)
 with wave.open(str(OUT/(name+'.wav')),'wb') as f:
  f.setparams((1,2,RATE,0,'NONE','not compressed'));f.writeframes((y*32767).astype('<i2').tobytes())
for name,kind,duration in [('blaster_fire','laser',.23),('shot','laser',.23),('splitgun_fire','gun',.25),('hammer_slam','slam',.5),('arc_zap','arc',.33),('blade_hit','blade',.24),('hit','hurt',.3),('death','splat',.28),('fx_splat','splat',.28),('fx_boom','boom',.65),('ability_explosion','boom',.65),('ability_shockwave','slam',.5),('ability_impulse','arc',.4),('ability_shadow_step','blade',.36),('spec_hammer','slam',.6),('spec_blaster','laser',.32),('spec_splitgun','gun',.4),('spec_arc','arc',.44),('spitter_fire','splat',.24)]:
 t=np.arange(int(RATE*duration))/RATE;n=len(t);env=np.exp(-t*(12 if kind in ['laser','gun'] else 7))
 if kind=='laser':y=np.sin(2*np.pi*(1000*t-1050*t*t))*env*.7+noise(n,2200,16000)*np.exp(-t*65)*.8
 elif kind=='gun':y=noise(n,700,13000)*np.exp(-t*26)*1.8+np.sin(2*np.pi*(160*t-130*t*t))*env*.8
 elif kind in ['slam','boom']:y=noise(n,45,6000)*np.exp(-t*9)*1.5+np.sin(2*np.pi*(100*t-65*t*t))*env*.85+noise(n,2000,17000)*np.exp(-t*60)*.6
 elif kind=='arc':y=(tone(780,t)+.45*tone(1169,t))*env*.35+noise(n,1400,14000)*(np.sin(t*90)**8)*env*.9
 elif kind=='blade':y=noise(n,1200,15000)*np.sin(np.pi*np.minimum(t/duration,1))**2*np.exp(-t*6)*1.4+tone(2100,t)*np.exp(-t*30)*.15
 elif kind=='hurt':y=np.sin(2*np.pi*(240*t-220*t*t))*env*.6+noise(n,400,5000)*np.exp(-t*20)*.45
 else:y=noise(n,90,4000)*env*.7+np.sin(2*np.pi*(190*t-210*t*t))*env*.6
 # Short reflective tail gives space without obscuring the attack transient.
 offset=int(.042*RATE);y[offset:]+=y[:-offset]*.16
 write(name,y)
def melody(name,notes,step,kind='bell'):
 y=np.zeros(int(RATE*(step*len(notes)+.5)))
 for i,midi in enumerate(notes):
  t=np.arange(int(RATE*.5))/RATE;f=440*2**((midi-69)/12)
  v=(tone(f,t)+.28*tone(f*2.01,t)+.12*tone(f*3,t))*np.exp(-t*10)*.45
  start=int(i*step*RATE);y[start:start+len(v)]+=v
 write(name,y)
melody('click',[76,83],.035);melody('buy',[64,71,76],.075);melody('xp',[88],.06);melody('coin',[95,102],.035)
melody('level',[60,64,67,72,76],.09);melody('spec_evolve',[48,55,60,64,67,72,79],.09)
melody('victory',[60,64,67,72,67,72,76,79,84],.17)
melody('defeat',[60,55,51,48,43],.23)
melody('boss_radial_warning',[72,72,79],.17);melody('boss_charge_warning',[48,55,60,67],.14)
melody('warning',[67,67,67],.14);melody('spitter_warning',[60,64],.1)
for name,bpm in [('menu_theme',110),('combat_theme',128)]:
 beat=60/bpm;length=beat*32;n=int(length*RATE);y=np.zeros(n)
 def add(v,start):
  # Circular placement preserves percussion tails across the loop seam.
  idx=(np.arange(len(v))+int(start*RATE))%n;np.add.at(y,idx,v)
 def note(midi,duration):
  t=np.arange(int(duration*RATE))/RATE;f=440*2**((midi-69)/12)
  return (tone(f,t)+.22*tone(f*2,t)+.1*tone(f*3,t))*np.minimum(1,t/.008)*np.exp(-t*4)
 roots=[40,40,43,38,40,40,36,38]
 for bar,root in enumerate(roots):
  for beat_i in range(4):
   start=(bar*4+beat_i)*beat
   t=np.arange(int(.27*RATE))/RATE
   if beat_i in [0,2] or name=='combat_theme':add(np.sin(2*np.pi*(48*t+8*(1-np.exp(-t*30))))*np.exp(-t*17)*.55,start)
   if beat_i in [1,3]:add(noise(len(t),1800,15000)*np.exp(-t*25)*.45+tone(180,t)*np.exp(-t*30)*.1,start)
   for half in [0,.5]:
    ht=np.arange(int(.065*RATE))/RATE;add(noise(len(ht),6000,17000)*np.exp(-ht*60)*.15,start+half*beat)
    add(note(root,.36)*(.2 if name=='combat_theme' else .14),start+half*beat)
  for step in range(8):
   intervals=[0,7,12,15,7,12,19,15]
   midi=root+24+intervals[step]
   add(note(midi,.5)*(.09 if name=='combat_theme' else .14),(bar*4+step*.5)*beat)
  # Sustained minor chord with gentle modulation; no external instrument samples.
  t=np.arange(int(beat*4*RATE))/RATE
  env=np.sin(np.pi*t/(beat*4))**2
  chord=sum(tone(440*2**((root+12+interval-69)/12),t) for interval in [0,3,7])*.035*env
  add(chord,bar*4*beat)
 # Conservative mastering leaves headroom under weapon effects.
 y=y/max(1,np.max(np.abs(y))/.7);write(name,y)
 subprocess.run(['ffmpeg','-y','-loglevel','error','-i',str(OUT/(name+'.wav')),'-c:a','libvorbis','-q:a','5',str(OUT/(name+'.ogg'))],check=True)
 (OUT/(name+'.wav')).unlink()
print('Generated 31 original effects and two 8-bar music loops at 44.1 kHz')
