extends RefCounted
# Hand-drawn vector motifs, one recognisable signature per fighter. No extra Nodes.
static func draw(g:Node,e:Dictionary,t:float,alpha:float):
 var c=Color(e.color,alpha);var r=e.radius*(.45+t*.5);var at:Vector2=e.pos
 var motion=0.0 if g.saved.settings.get('reduced_motion',false) else t
 match e.hero:
  'bruiser':
   for i in range(7):
    var d=Vector2.from_angle(i*TAU/7);g.draw_polyline(PackedVector2Array([at+d*r*.5,at+d*r*.8+d.orthogonal()*12,at+d*r*1.3]),c,5,true)
  'sparky','kicksy':
   var count=3 if e.hero=='kicksy' else 1
   for i in range(count):
    var p=at+Vector2.from_angle(i*TAU/count+motion)*r*.65
    g.draw_circle(p,18,Color('#14213D',alpha));g.draw_arc(p,18,0,TAU,20,c,4,true);g.draw_line(p+Vector2(0,-18),p+Vector2(10,-30),c,4,true);g.draw_circle(p+Vector2(10,-30),5,Color('#FFD166',alpha))
  'shade':
   for i in range(3):g.draw_line(at+Vector2(-r,-r*.5+i*26),at+Vector2(r,r*.4+i*26),c,6-i,true)
  'twinkle':
   for i in range(9):
    var p=at+Vector2.from_angle(i*.8+motion*3)*r*(i+1)/9;g.draw_arc(p,8+i,0,TAU,16,c,3,true)
  'steelfist':
   for side in [-1,1]:
    for i in range(4):
     var p=at+Vector2(side*(30+i*17),-i*22-motion*45);g.draw_arc(p,12+i*4,PI*.1,PI*.95,12,c,5,true)
  'cinder':
   for i in range(7):
    var d=Vector2.from_angle(i*TAU/7);g.draw_colored_polygon(PackedVector2Array([at+d*r*.5-d.orthogonal()*15,at+d*r*1.3,at+d*r*.6+d.orthogonal()*15]),c)
  'frosty':
   for i in range(6):
    var d=Vector2.from_angle(i*TAU/6);g.draw_line(at,at+d*r,c,4,true)
    for sign in [-1,1]:g.draw_line(at+d*r*.65,at+d*r*.45+d.orthogonal()*20*sign,c,3,true)
  'volt':
   for i in range(5):
    var d=Vector2.from_angle(i*TAU/5);g.draw_polyline(PackedVector2Array([at+d*20,at+d*r*.6+d.orthogonal()*15,at+d*r*.5-d.orthogonal()*12,at+d*r]),c,4,true)
  'rook':
   var p=PackedVector2Array()
   for i in range(7):p.append(at+Vector2.from_angle(i*TAU/6)*r)
   g.draw_polyline(p,c,6,true);g.draw_line(at+Vector2(0,-r*.5),at+Vector2(0,r*.5),c,5,true)
  'nyx':
   for i in range(3):g.draw_arc(at+Vector2.from_angle(i*TAU/3+motion)*r*.6,25,0,PI*1.4,20,c,5,true)
  'viper':
   for sign in [-1,1]:g.draw_colored_polygon(PackedVector2Array([at+Vector2(sign*20,-r*.6),at+Vector2(sign*45,-r*.5),at+Vector2(sign*20,r*.8)]),c)
  'echo':
   for i in range(3):g.draw_arc(at,r*(.5+i*.3),-.9,.9,24,c,5-i,true)
  'nova':
   for i in range(8):
    var d=Vector2.from_angle(i*TAU/8);g.draw_line(at+d*20,at+d*r*(1.3 if i%2==0 else .8),c,6,true)
  'rivet':
   g.draw_arc(at,r*.7,0,TAU,32,c,6,true)
   for i in range(10):
    var d=Vector2.from_angle(i*TAU/10+motion);g.draw_line(at+d*r*.65,at+d*r*.95,c,12,true)
