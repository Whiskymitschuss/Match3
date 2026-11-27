extends RefCounted
# Distinct silhouettes remain legible independently of colour.
static func draw(g:Node,s:Dictionary):
 var id=str(s.weapon).trim_prefix('sig_');var c=g.united.bosses.signatures.color(id)
 g.draw_set_transform(s.pos,s.vel.angle())
 g.draw_circle(Vector2.ZERO,17,Color(c,.12))
 if id in ['frost_shards','crystal_prism']:
  var points=PackedVector2Array([Vector2(18,0),Vector2(-7,-9),Vector2(-14,0),Vector2(-7,9)])
  g.draw_colored_polygon(points,Color('#14213D'));g.draw_colored_polygon(PackedVector2Array([Vector2(14,0),Vector2(-6,-5),Vector2(-10,0),Vector2(-6,5)]),c)
  g.draw_line(Vector2(-8,0),Vector2(12,0),Color.WHITE,2,true)
 elif id in ['storm_spiral','reactor_overload']:
  var points=PackedVector2Array([Vector2(-13,-7),Vector2(1,-3),Vector2(-4,3),Vector2(13,7)])
  g.draw_polyline(points,Color('#14213D'),9,true);g.draw_polyline(points,c,5,true);g.draw_polyline(points,Color.WHITE,2,true)
 elif id=='scrap_shred':
  for i in range(3):g.draw_line(Vector2(-8,-8+i*8),Vector2(8,-4+i*6),c,4,true)
 elif id=='garden_seeds':
  g.draw_colored_polygon(PackedVector2Array([Vector2(13,0),Vector2(-8,-9),Vector2(-5,0),Vector2(-8,9)]),c)
 elif id=='carnival_roulette':
  g.draw_circle(Vector2.ZERO,11,Color('#14213D'));g.draw_circle(Vector2.ZERO,8,c);g.draw_line(Vector2(-4,-4),Vector2(4,4),Color.WHITE,3,true);g.draw_line(Vector2(4,-4),Vector2(-4,4),Color.WHITE,3,true)
 else:
  g.draw_circle(Vector2.ZERO,12,Color('#14213D'));g.draw_circle(Vector2.ZERO,9,c);g.draw_circle(Vector2(2,-3),4,Color.WHITE)
  if id=='forge_embers':g.draw_colored_polygon(PackedVector2Array([Vector2(-3,-8),Vector2(-29,0),Vector2(-3,8)]),Color(c,.6))
 g.draw_set_transform(Vector2.ZERO)
