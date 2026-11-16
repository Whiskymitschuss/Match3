"""Original final UI SVG assets: consistent enamel/metal badges, no font/emoji dependency."""
from pathlib import Path
import json
ROOT=Path(__file__).resolve().parents[1]
P={
'play':'<path d="M49 34L94 64 49 94Z"/>',
'characters':'<circle cx="64" cy="44" r="16"/><path d="M36 100V83Q36 66 64 66Q92 66 92 83V100Z"/><path d="M31 47a12 12 0 0 0 0 24M97 47a12 12 0 0 1 0 24M27 79q-10 0-10 20h14m70-20q10 0 10 20H97" fill="none"/>',
'stats':'<path d="M27 100V73h16v27m13 0V53h16v47m13 0V31h16v69Z"/><path d="M24 51l26-19 19 7 25-18" fill="none" stroke="#ffe493"/>',
'settings':'<path d="M55 25h18l3 12 11 6 12-3 9 16-9 9v12l8 9-9 15-13-3-11 6-3 10H54l-3-12-11-6-12 3-9-16 9-9V62l-8-9 9-15 13 3 11-6Z"/><circle cx="64" cy="68" r="19" fill="#261440"/>',
'back':'<path d="M65 31L27 64l38 33V77h36V51H65Z"/>',
'next':'<path d="M63 31l38 33-38 33V77H27V51h36Z"/>',
'pause':'<rect x="37" y="31" width="20" height="67" rx="4"/><rect x="72" y="31" width="20" height="67" rx="4"/>',
'check':'<path d="M28 65l23 25 48-53-12-10-36 40-12-13Z"/>',
'close':'<path d="M36 27L64 55 92 27l10 11-28 27 28 27-10 11-28-28-28 28-11-11 28-27-28-27Z"/>',
'help':'<path d="M44 44q0-24 25-22 27 1 25 25-1 13-17 20-9 4-9 15H54q-1-20 11-27 14-7 14-13 0-10-12-10-10 0-10 12Z"/><circle cx="61" cy="99" r="8"/>',
'coins':'<ellipse cx="57" cy="88" rx="31" ry="13" fill="#c87913"/><path d="M26 72v16q31 21 62 0V72Z" fill="#e59d26"/><ellipse cx="57" cy="72" rx="31" ry="14"/><circle cx="78" cy="48" r="28"/><circle cx="78" cy="48" r="20" fill="none" stroke="#ad6611"/><path d="M78 34v28m8-23H74q-10 0-6 9l17 2q9 9-4 10H69" fill="none" stroke="#b36a12"/>',
'xp':'<path d="M64 20L95 62 64 108 33 62Z"/><path d="M64 20v88M33 62h62" fill="none" stroke="#ffffff"/><path d="M64 20L48 62l16 46" fill="#ffffff" opacity=".35"/>',
'vital':'<path d="M64 104L26 65Q10 36 35 27q18-6 29 12 12-18 29-12 25 9 9 38Z"/><path d="M30 66h19l8-18 13 34 8-16h20" fill="none" stroke="#fff"/>',
'damage':'<path d="M31 24l38 28-13 13-28-38Zm66 0L59 52l13 13 28-38ZM35 104l30-36 7 7-25 36Zm58 0L63 68l-7 7 25 36Z"/><path d="M32 72l25 22m39-22L71 94" stroke="#ffc14a"/>',
'rapid':'<path d="M49 89V45l8-16 8 16v44ZM77 80V36l8-16 8 16v44Z"/><path d="M22 54h18M17 72h23m-9 18h9" fill="none" stroke="#ffe2a5"/>',
'speed':'<path d="M55 27h24l-5 40 26 17-3 18H41V86l9-20Z"/><path d="M23 43h22M17 60h24m-16 18h14" fill="none" stroke="#fff1bf"/><path d="M43 92h50" fill="none" stroke="#3c2548"/>',
'crit':'<path d="M18 65Q64 10 110 65 64 120 18 65Z"/><circle cx="64" cy="65" r="22" fill="#2c1844"/><circle cx="64" cy="65" r="11" fill="#fff3d0"/><path d="M64 24v17m0 48v16M21 65h17m51 0h17" fill="none" stroke="#ffdb5d"/>',
'armor':'<path d="M64 22L101 36v31q0 25-37 43-37-18-37-43V36Z"/><path d="M64 30v68M38 44l26-10 26 10" fill="none" stroke="#fff5c5"/>',
'magnet':'<path d="M31 26h21v44q0 17 12 17t12-17V26h21v47q-1 36-33 36T31 73Z"/><path d="M31 49h21m24 0h21" fill="none" stroke="#fff"/><path d="M16 69l8-8m80 0 8 8M18 90l9-3m74 0 9 3" fill="none" stroke="#ffc653"/>',
'projectile':'<path d="M83 22q24 3 22 25L70 83 46 58Z"/><path d="M46 58l-20 9 7 20 18-9m19 5-9 20-20-7 10-18"/><circle cx="82" cy="45" r="9" fill="#28153f"/><path d="M38 89l-15 17 21-8" fill="#ffb43c"/>',
'heal':'<rect x="27" y="40" width="75" height="62" rx="9"/><path d="M45 40V28h38v12" fill="none"/><path d="M57 51h15v14h14v15H72v14H57V80H43V65h14Z" fill="#fff9e8" stroke="#fff9e8"/>',
'multi':'<path d="M55 92V40l9-17 9 17v52ZM25 92V54l8-15 8 15v38Zm62 0V54l8-15 8 15v38Z"/><path d="M26 104h76" fill="none" stroke="#ffe8a5"/>',
'shop':'<path d="M26 50h76l-6 57H32Z"/><path d="M45 52V37q0-20 19-20t19 20v15" fill="none" stroke="#fff3bb"/><circle cx="64" cy="79" r="14" fill="#714314"/><path d="M64 69v20m-7-10h14" stroke="#ffe889"/>',
'reroll':'<rect x="31" y="31" width="66" height="66" rx="12" transform="rotate(12 64 64)"/><g fill="#28153f" stroke="none"><circle cx="49" cy="45" r="5"/><circle cx="79" cy="51" r="5"/><circle cx="64" cy="65" r="5"/><circle cx="48" cy="78" r="5"/><circle cx="78" cy="84" r="5"/></g>',
'weapon':'<path d="M24 48h67v8h15v17H72l-9 28H43l7-28H24Z"/><path d="M34 39h37v9m-35 9h40" fill="none" stroke="#fff3c0"/><path d="M83 56h12" stroke="#fb58e5"/>',
'items':'<path d="M25 40l39-19 39 19v52l-39 19-39-19Z"/><path d="M25 40l39 19 39-19M64 59v52M44 31l39 19v21" fill="none" stroke="#fff0c4"/>',
'sets':'<path d="M42 25L64 38v26L42 77 20 64V38Zm44 26 22 13v26l-22 13-22-13V64Z"/><path d="M51 54l27 16" stroke="#fff8dc" stroke-width="10"/>',
'upgrade':'<path d="M23 65L64 26l41 39-15 15-26-25-26 25Zm0 31 15 15 26-25 26 25 15-15-41-40Z"/>',
'salvage':'<path d="M29 40h70l-6 66H35Z"/><path d="M21 29h86M48 29V19h32v10M49 54v36m15-36v36m15-36v36" fill="none"/>',
'lock':'<rect x="30" y="54" width="68" height="52" rx="9"/><path d="M42 54V39q0-23 22-23t22 23v15" fill="none" stroke="#ffeab0" stroke-width="10"/><circle cx="64" cy="77" r="9" fill="#27163d"/><path d="M64 80v13" stroke="#27163d" stroke-width="9"/>',
'clock':'<circle cx="64" cy="67" r="37"/><path d="M64 40v28l19 12M52 17h24" fill="none" stroke="#2b193f" stroke-width="8"/>',
'trophy':'<path d="M43 23h42v35q-2 25-21 25T43 58Z"/><path d="M43 33H25v14q0 19 20 19m40-33h18v14q0 19-20 19M64 83v19m-21 6h42" fill="none" stroke="#ffe2a0"/>',
'skull':'<path d="M31 66V48q0-30 33-30t33 30v18L85 79v25H43V79Z"/><g fill="#251437" stroke="#251437"><ellipse cx="49" cy="57" rx="10" ry="12"/><ellipse cx="79" cy="57" rx="10" ry="12"/><path d="M64 67l-6 10h12Z"/><path d="M55 90v15m18-15v15"/></g>',
'volume':'<path d="M24 51h18l25-24v75L42 78H24Z"/><path d="M80 47q19 17 0 35m11-48q34 30 0 61" fill="none" stroke="#ffe6b0"/>',
'music':'<path d="M52 91V37l45-12v55" fill="none" stroke-width="10"/><ellipse cx="39" cy="94" rx="16" ry="12"/><ellipse cx="84" cy="83" rx="16" ry="12"/><path d="M52 51l45-12" stroke="#fff2be"/>',
'haptic':'<rect x="42" y="22" width="44" height="84" rx="8"/><path d="M49 33h30v55H49Z" fill="#38234f"/><path d="M24 41l-7 13 7 13-7 13m87-39 7 13-7 13 7 13" fill="none" stroke="#ffe9ad"/>',
'fx':'<path d="M64 19l9 29 29-11-13 27 22 16-31 4-5 27-15-25-28 15 7-29-24-10 28-11Z"/>',
'world':'<circle cx="64" cy="64" r="40"/><ellipse cx="64" cy="64" rx="18" ry="40" fill="none" stroke="#322044"/><path d="M25 64h78M32 41h64M32 87h64" fill="none" stroke="#322044"/>',
'history':'<path d="M33 22h65v84H33q-15-1-15-14 0-13 15-14Z"/><path d="M33 22v56h65M33 93h52M48 40h33M48 55h24" fill="none" stroke="#392344"/>',
'grip':'<path d="M47 20h33v16l-6 8v56H50V44l-7-8Z"/><path d="M50 51h24M50 64h24M50 77h24M44 100h36" stroke="#301b36"/><path d="M53 25h21" stroke="#fff0c0"/>',
'plate':'<path d="M64 22l36 17-9 57-27 14-27-14-9-57Z"/><path d="M38 47l26-13 26 13-7 40-19 11-19-11Z" fill="#342544"/><path d="M64 38v53m-21-29h42" stroke="#ffd177"/>',
'battery':'<path d="M48 18h32v12H48Z"/><rect x="35" y="30" width="58" height="78" rx="8"/><path d="M68 39L48 70h17l-5 29 24-38H66Z" fill="#241535" stroke="#f3ffcb"/>',
'coolant':'<path d="M47 21h34v19l16 49q4 19-13 19H44q-17 0-13-19l16-49Z"/><path d="M42 77h44l9 24H34Z" fill="#8cf9ed"/><path d="M51 47h16M47 60h16" stroke="#31214d"/>',
'boots':'<path d="M48 23h35l-7 45 25 16v22H30V86l15-18Z"/><path d="M48 39h30M46 53h30M34 95h63" stroke="#39213e"/><path d="M59 72l17 11" stroke="#fff0d6"/>',
'lens':'<path d="M20 48l15-12h59l14 12v40H20Z"/><circle cx="64" cy="66" r="27" fill="#2c184b"/><circle cx="64" cy="66" r="18" fill="#83e5ff"/><path d="M53 58l10-7" stroke="#fff"/><path d="M28 52h9m54 0h9" stroke="#fff2cd"/>',
'pack':'<rect x="32" y="36" width="64" height="72" rx="9"/><path d="M49 36V24h30v12" fill="none"/><path d="M56 49h16v16h16v16H72v16H56V81H40V65h16Z" fill="#fff8d5"/>',
'shockwave':'<path d="M44 24h53v31H44Z"/><path d="M59 55h18v47H59Z"/><path d="M26 72q-17 19 4 33M98 72q17 19-4 33" fill="none" stroke="#fff1b9"/>',
'impulse':'<circle cx="64" cy="74" r="32"/><path d="M54 26h23v20H54Z"/><path d="M78 27l18 16M49 53l30 40m-31-1 29-40" stroke="#fff2ca"/><path d="M95 19l10-10m-6 23h17" stroke="#ffb43c"/>',
'shadow_step':'<path d="M52 24Q82 20 96 55L80 102H38L26 55Z"/><path d="M39 57l42-5-12 29-22-2Z" fill="#26123c"/><path d="M43 61l13 5m21-8-12 7M16 41h22M14 82h19" stroke="#fff0e0"/>',
}
COLORS={'vital':'#ff638c','heal':'#56e5a0','coins':'#ffd465','xp':'#44f5dc','armor':'#8cc4fa','crit':'#dd8cff','shadow_step':'#c577ff','impulse':'#4fe4d3','shockwave':'#ffad4f'}
# Every file contains actual illustrated geometry. Gradients and glints remain sharp at Android sizes.
def svg(name,shape,color=None):
 c=color or COLORS.get(name,'#d4a2ff')
 return f'''<svg xmlns="http://www.w3.org/2000/svg" width="128" height="128" viewBox="0 0 128 128"><defs><linearGradient id="base" x2="0" y2="1"><stop stop-color="#483063"/><stop offset="1" stop-color="#120e23"/></linearGradient><linearGradient id="enamel" x2="0.3" y2="1"><stop stop-color="#fff5dc"/><stop offset=".43" stop-color="{c}"/><stop offset="1" stop-color="{c}"/></linearGradient></defs><path d="M24 7h80l17 17v80l-17 17H24L7 104V24Z" fill="#090712" stroke="{c}" stroke-opacity=".35" stroke-width="4"/><path d="M26 11h76l15 15v76l-15 15H26l-15-15V26Z" fill="url(#base)" stroke="#74568e" stroke-width="2"/><path d="M29 16h69m-77 9v17" stroke="#cf98ef" stroke-opacity=".48" stroke-width="2"/><g fill="url(#enamel)" stroke="{c}" stroke-width="4" stroke-linejoin="round" stroke-linecap="round">{shape}</g><path d="M21 108h12m62 0h12" stroke="{c}" stroke-opacity=".65" stroke-width="3"/></svg>'''
out=ROOT/'assets/ui/icons';out.mkdir(exist_ok=True)
for name,shape in P.items():(out/(name+'.svg')).write_text(svg(name,shape))
# Items, active abilities and weapon evolutions use the same finished illustrated system.
for name in ['grip','plate','battery','coolant','boots','lens','magnet','pack']:
 (ROOT/'assets/ui/items'/(name+'.svg')).write_text(svg(name,P[name],json.loads((ROOT/'data/items/items.json').read_text())[name]['color']))
for name in ['shockwave','impulse','shadow_step']:(ROOT/'assets/ui/abilities'/(name+'.svg')).write_text(svg(name,P[name]))
specs=json.loads((ROOT/'data/specializations/specializations.json').read_text())
for name,d in specs.items():
 base={'hammer':'shockwave','blaster':'projectile','splitgun':'multi','arc':'rapid','orbit':'crit'}[d['weapon']]
 extra='<path d="M94 15l10 5-4 10-10-4Z" fill="#fff"/>' if list(specs).index(name)%2 else '<path d="M95 13v18m-9-9h18" stroke="#fff" stroke-width="3"/>'
 (ROOT/'assets/ui/specializations'/(name+'.svg')).write_text(svg(name,P[base]+extra,d['color']))
print('Generated',len(P),'semantic UI icons + 8 item, 3 ability and',len(specs),'evolution illustrations')
