extends RefCounted
# A packet's rarity expresses its real value. No additional reward RNG or inflation.
const NAMES=['STANDARD','UNGEWÖHNLICH','SELTEN','EPISCH']
const COLORS=[Color('#FFD166'),Color('#67ED94'),Color('#53CEFF'),Color('#E875FF')]
static func tier(value:int) -> int:return 3 if value>=25 else (2 if value>=8 else (1 if value>=4 else 0))
static func collect(game:Node,entry:Dictionary):
	var value=int(entry.get('coin',0))
	if value<=0:return
	entry.coin=0;game.coins+=value;game.earned+=value
	game.vfx.coin(entry.pos,value)
	game.sound('coin_epic' if tier(value)==3 else 'coin')
static func bank(game:Node):
	for entry in game.loot:collect(game,entry)
static func draw(game:Node,entry:Dictionary):
	var value=int(entry.get('coin',0))
	if value<=0:return
	var rank=tier(value);var color:Color=COLORS[rank];var at:Vector2=entry.pos+Vector2(13,2) if entry.xp>0 else entry.pos
	var r=8.0+rank*2;var spin=.45+.55*absf(cos(game.animation_clock*4+at.x*.03))
	game.draw_circle(at,r+7,Color(color,.09))
	if rank>=2:game.draw_arc(at,r+5,game.animation_clock,game.animation_clock+PI*1.4,16,Color(color,.6),2,true)
	game.draw_set_transform(at,0,Vector2(spin,1))
	game.draw_circle(Vector2.ZERO,r+2,Color('#14213D'));game.draw_circle(Vector2.ZERO,r,color)
	game.draw_arc(Vector2.ZERO,r-3,0,TAU,16,color.darkened(.35),2,true)
	game.draw_line(Vector2(-2,-r*.4),Vector2(-2,r*.35),Color.WHITE,2,true)
	game.draw_set_transform(Vector2.ZERO)
