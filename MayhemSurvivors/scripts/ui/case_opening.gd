extends Control
var garage
var case_id='crew'
var revision=0
var age=0.0
var done=false
func _process(dt):
 if garage.game.ui_revision!=revision:queue_free();return
 age+=dt;queue_redraw()
 if age>=1.55 and not done:done=true;garage.call_deferred('reveal')
func _draw():
 var center=Vector2(960,580);var color=Color(garage.C.catalog().cases[case_id].color)
 # The result is already committed. Reveal its true rarity, never fake near misses.
 var receipt=garage.game.saved.collection.pending
 if not receipt.is_empty():
  var source=garage.C.catalog().heroes if receipt.hero else garage.C.catalog().items
  var rarity=source[receipt.id].rarity
  color=Color('#E875FF') if rarity=='EPISCH' else (Color('#53CEFF') if rarity=='SELTEN' else Color('#FFD166'))
 var opened=clampf((age-.65)/.65,0,1);opened=1-pow(1-opened,3)
 for i in range(16):
  var dir=Vector2.from_angle(i*TAU/16+age*.15)
  draw_line(center+dir*100,center+dir*(180+opened*320),Color(color,.12+opened*.18),6,true)
 draw_arc(center,210+opened*95,0,TAU,64,Color(color,.65),4,true)
 var region=garage.Art.case_region(case_id);var cut=region.size.y*.43
 var lid=Rect2(region.position,Vector2(region.size.x,cut));var body=Rect2(region.position+Vector2(0,cut),Vector2(region.size.x,region.size.y-cut))
 var shake=sin(age*43)*(1-opened)*age*5
 draw_set_transform(center+Vector2(shake,-opened*190),-opened*.13)
 draw_texture_rect_region(garage.Art.CASES,Rect2(-420,-240,840,480*.43),lid)
 draw_set_transform(center+Vector2(shake,opened*35))
 draw_texture_rect_region(garage.Art.CASES,Rect2(-420,-240+480*.43,840,480*.57),body)
 draw_set_transform(Vector2.ZERO)
 if opened>0:
  draw_circle(center,60*opened,Color(color,opened*.2))
  draw_arc(center,25+opened*45,0,TAU,32,Color(color,opened),5,true)
