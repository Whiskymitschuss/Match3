extends RefCounted
# Bounded JSON-only graph: shared enemy references survive without loading objects.
const MAX_NODES=12000
const MAX_VALUES=120000
const MAX_DEPTH=64
var nodes:Array=[]
var containers:Array=[]
var buckets:Dictionary={}
var error=''
var budget=0
var actors_only=false
var actor_nodes:Dictionary={}
func pack(value,scene_owned_containers:bool=false) -> Dictionary:
	actors_only=scene_owned_containers
	nodes=[];containers=[];buckets={};actor_nodes={};error='';budget=0
	var root=encode(value,0)
	return {} if error!='' else {'root':root,'nodes':nodes}
func encode(value,depth:int):
	budget+=1
	if budget>MAX_VALUES or depth>MAX_DEPTH:error='Zu viele Speicherdaten.';return null
	match typeof(value):
		TYPE_NIL,TYPE_BOOL,TYPE_STRING:return value
		TYPE_STRING_NAME:return str(value)
		TYPE_INT:return ['i',str(value)]
		TYPE_FLOAT:
			if not is_finite(value):error='Ungültige Zahl.';return null
			return value
		TYPE_VECTOR2:return ['v',value.x,value.y]
		TYPE_VECTOR2I:return ['vi',value.x,value.y]
		TYPE_RECT2:return ['r',value.position.x,value.position.y,value.size.x,value.size.y]
		TYPE_COLOR:return ['c',value.r,value.g,value.b,value.a]
		TYPE_PACKED_VECTOR2_ARRAY:
			var data=[]
			for point in value:data.append(point.x);data.append(point.y)
			return ['pv',data]
		TYPE_PACKED_STRING_ARRAY:return ['ps',Array(value)]
		TYPE_ARRAY,TYPE_DICTIONARY:
			# Runtime managers own their arrays/records. Only actor dictionaries are
			# shared between shots, warnings and the live enemy list. The generic
			# mode still preserves every container alias for standalone graph use.
			var shared=not actors_only or (value is Dictionary and value.has('kind') and value.has('hp') and value.has('max_hp'))
			var actor_key=value.get('save_actor',0) if actors_only and shared and value is Dictionary else 0
			if actor_key is int and actor_key>0 and actor_nodes.has(actor_key):return ['@',actor_nodes[actor_key]]
			var signature=bucket(value) if shared and actor_key==0 else 0
			if shared and actor_key==0:
				for i in buckets.get(signature,[]):
					if is_same(value,containers[i]):return ['@',i]
			if nodes.size()>=MAX_NODES:error='Zu viele Speicherobjekte.';return null
			var id=nodes.size();containers.append(value)
			if actor_key is int and actor_key>0:actor_nodes[actor_key]=id
			if shared and actor_key==0:
				if not buckets.has(signature):buckets[signature]=[]
				buckets[signature].append(id)
			var node={'kind':'a' if value is Array else 'd','items':[],'typed':value.get_typed_builtin() if value is Array else 0}
			nodes.append(node)
			if value is Array:
				for entry in value:node.items.append(encode(entry,depth+1))
			else:
				for key in value:
					if not (key is String or key is StringName or key is int):error='Ungültiger Speicherschlüssel: '+type_string(typeof(key))+' / '+str(key);return null
					node.items.append([encode(key,depth+1),encode(value[key],depth+1)])
			return ['@',id]
		_:error='Objekte sind im Spielstand nicht erlaubt.';return null
# Non-recursive buckets avoid quadratic full-graph identity scans. Equality still
# uses is_same, so equal-but-independent empty arrays never become shared.
static func anchor(v) -> int:
	if v is String or v is StringName or v is int or v is float or v is Vector2 or v is bool:return hash(v)
	if v is Dictionary:
		var p=v.get('pos',v.get('id',v.get('kind',null)))
		if p is Vector2 or p is String or p is int:return hash(p)
	return 0
static func bucket(value) -> int:
	if value is Dictionary:
		return hash([TYPE_DICTIONARY,value.size(),hash(value.keys()),anchor(value.get('pos')),anchor(value.get('id',value.get('kind'))),anchor(value.get('life',value.get('hp')))])
	return hash([TYPE_ARRAY,value.size(),value.get_typed_builtin(),anchor(value.front()) if not value.is_empty() else 0,anchor(value.back()) if not value.is_empty() else 0])
static func number(v) -> bool:return (v is int or v is float) and is_finite(float(v)) and absf(float(v))<=1.0e15
static func whole(v,max_value:int) -> bool:return number(v) and v>=0 and v<=max_value and float(int(v))==float(v)
func unpack(graph) -> Dictionary:
	error='';budget=0;nodes=[];containers=[]
	if not graph is Dictionary or not graph.get('nodes') is Array or graph.nodes.size()>MAX_NODES or not graph.has('root'):return {}
	nodes=graph.nodes
	var states=[];states.resize(nodes.size());states.fill(0)
	if not validate_value(graph.root,states,0):return {}
	for node in nodes:
		if not node is Dictionary or node.get('kind') not in ['a','d'] or not node.get('items') is Array or not whole(node.get('typed'),TYPE_MAX):return {}
		if node.kind=='a':
			if int(node.typed) not in [TYPE_NIL,TYPE_STRING,TYPE_INT,TYPE_FLOAT,TYPE_VECTOR2,TYPE_DICTIONARY]:return {}
			containers.append([] if int(node.typed)==TYPE_NIL else Array([],int(node.typed),&'',null))
		else:containers.append({})
	# Populate children before typed arrays/dictionaries. Validation rejected cycles.
	states.fill(0)
	var value=decode(graph.root,states)
	if error!='':return {}
	return {'value':value}
func validate_value(v,states:Array,depth:int) -> bool:
	budget+=1
	if budget>MAX_VALUES or depth>MAX_DEPTH:return false
	if v==null or v is bool or v is String:return not v is String or v.length()<=262144
	if number(v):return true
	if not v is Array or v.is_empty() or not v[0] is String:return false
	var tag=v[0]
	if tag=='@':
		if v.size()!=2 or not whole(v[1],nodes.size()-1):return false
		var id=int(v[1])
		if states[id]==1:return false
		if states[id]==2:return true
		var node=nodes[id]
		if not node is Dictionary or node.get('kind') not in ['a','d'] or not node.get('items') is Array:return false
		states[id]=1
		for item in node.items:
			if node.kind=='d':
				if not item is Array or item.size()!=2 or not (item[0] is String or (item[0] is Array and item[0].size()==2 and item[0][0]=='i')):return false
				if not validate_value(item[0],states,depth+1) or not validate_value(item[1],states,depth+1):return false
			elif not validate_value(item,states,depth+1):return false
		states[id]=2;return true
	if tag=='i':return v.size()==2 and v[1] is String and v[1].is_valid_int() and str(int(v[1]))==v[1]
	if tag=='ps':
		if v.size()!=2 or not v[1] is Array or v[1].size()>4096:return false
		for s in v[1]:
			if not s is String or s.length()>4096:return false
		return true
	if tag=='pv':
		if v.size()!=2 or not v[1] is Array or v[1].size()>8192 or v[1].size()%2!=0:return false
		for n in v[1]:
			if not number(n):return false
		return true
	var count={'v':3,'vi':3,'r':5,'c':5}.get(tag,0)
	if count==0 or v.size()!=count:return false
	for i in range(1,v.size()):
		if not number(v[i]):return false
	return true
func decode(v,states:Array):
	if not v is Array:return v
	match v[0]:
		'i':return int(v[1])
		'v':return Vector2(v[1],v[2])
		'vi':return Vector2i(v[1],v[2])
		'r':return Rect2(v[1],v[2],v[3],v[4])
		'c':return Color(v[1],v[2],v[3],v[4])
		'ps':return PackedStringArray(v[1])
		'pv':
			var result=PackedVector2Array()
			for i in range(0,v[1].size(),2):result.append(Vector2(v[1][i],v[1][i+1]))
			return result
		'@':
			var id=int(v[1]);var result=containers[id]
			if states[id]==2:return result
			states[id]=2
			for item in nodes[id].items:
				if nodes[id].kind=='d':result[decode(item[0],states)]=decode(item[1],states)
				else:
					var entry=decode(item,states)
					if result.is_typed() and typeof(entry)!=result.get_typed_builtin():error='Ungültiger Arraytyp.';return null
					result.append(entry)
			return result
	return null
