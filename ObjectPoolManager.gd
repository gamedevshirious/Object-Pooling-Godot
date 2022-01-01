extends Node

var pool = {}
var register = {}

func register_obj(key, path):
	if key in pool.keys():
		print_debug("Object registered for key: "+key+"\nRegister the object with new key")
		return
		
	register[key] = {}
	register[key]["path"] = path
	
	var obj = Node.new()
	obj.name = key + "s"

	var available = Node.new()
	var used = Node.new()
	
	available.name = "available"
	used.name = "used"
	
	obj.add_child(available)
	obj.add_child(used)
	
	add_child(obj)
	
func get(key):
	if not key in register.keys():
		print_debug("No object registered for key: "+key+"\nRegister to use the object from Object Pool using register(key, path)")
		return
	
	var temp_available = get_node(key+"s/available")
	var temp_used = get_node(key+"s/used")
	
	var obj
	if temp_available.get_child_count() > 1:
		obj = temp_available.get_child(0)
		
		if obj.has_method("obj_set"):
			obj.obj_set()
	
				
		temp_available.remove_child(obj)
		temp_used.add_child(obj)
	else:
		obj = load(register[key]["path"]).instance()
		temp_used.add_child(obj)
	
	call_deferred("set_process_bit", obj, true)
	return obj.get_instance_id()

func set_process_bit(obj, value):
	obj.set_process(value)
	obj.set_physics_process(value)
	obj.set_process_input(value)
	obj.set_process_internal(value)	
	obj.set_process_unhandled_input(value)
	obj.set_process_unhandled_key_input(value)

func destroy(instance_id):
	var obj = instance_from_id(instance_id)

	var key = obj.get_parent().get_parent().name
	var temp_available = get_node(key+"/available")
	var temp_used = get_node(key+"/used")
	
	if obj.has_method("obj_reset"):
		obj.obj_reset()	
	
	call_deferred("set_process_bit", obj, false)
	
	temp_used.call_deferred("remove_child", obj)
	temp_available.call_deferred("add_child", obj)

func debug_key(key):
	if not key in register.keys():
		print_debug("No object registered for key: "+key+"\nRegister to use the object from Object Pool using register(key, path)")
		return

	print("Available: "+ str(get_node(key+"s/available").get_child_count()))
	print("Used: "+ str(get_node(key+"s/used").get_child_count()))
	
	for a in get_node(key+"s/available").get_children():
		print(a.name)
	
	for u in get_node(key+"s/used").get_children():
		print(u.name)
	
	
	
func flush(key):
	if key in pool.keys():
		pool.erase(key)
		remove_child(get_node(key + "s"))


	
		
