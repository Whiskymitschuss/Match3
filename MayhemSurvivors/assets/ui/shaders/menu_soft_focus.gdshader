shader_type canvas_item;
uniform float blur_px : hint_range(0.0,5.0)=0.0;
varying vec4 vertex_tint;
void vertex(){vertex_tint=COLOR;}
void fragment(){
 vec4 tint=vertex_tint;
 vec4 image=texture(TEXTURE,UV);
 if(blur_px>0.1){
  vec2 p=TEXTURE_PIXEL_SIZE*blur_px;
  image=(image*4.0+texture(TEXTURE,UV+vec2(p.x,0.0))+texture(TEXTURE,UV-vec2(p.x,0.0))+texture(TEXTURE,UV+vec2(0.0,p.y))+texture(TEXTURE,UV-vec2(0.0,p.y)))/8.0;
 }
 COLOR=image*tint;
}
