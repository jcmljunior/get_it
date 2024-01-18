extends Node

var get_it = func(_storage: Array[Dictionary]):
	var storage: Array[Dictionary] = _storage
	
	return {
		"register": func(name: String, instance: Callable) -> Variant:
			if not storage.filter(func(obj: Dictionary): return obj.get("name") == name).is_empty():
				printerr("Oppss, a chave %s já existe." % name)
				return
			
			storage.append({
				"name": name,
				"instance": instance,
				"args": [],
			})
			
			return get_instance(storage),
		
		"unregister": func(name: String) -> Variant:
			if not storage.size():
				printerr("Oppss, não existe objetos a serem removidos.")
				return
			
			for i in range(storage.size() -1, -1, -1):
				if not storage[i].get("name") == name:
					continue
			
				storage.remove_at(i)
				return true
			
			return false,
		
		"with_dependencies": func(args: Array[Variant]) -> void:
			if not args.size():
				printerr("Oppss, o valor de args não pode ser vazio.")
				return
			
			storage[storage.size() -1]["args"].append_array(args),
		
		"with_properties": func(properties: Array[Variant]):
			if not properties.size():
				printerr("Oppss, o valor de properties não pode ser vazio.")
				return
			
			var obj = {}
			for i in range(properties.size()):
				obj = Collections.get("shallow_merge").call(properties[i], storage[storage.size() -1])
			
			storage[storage.size() -1] = obj,
		
		"get_storage_list": func() -> Array[Dictionary]:
			return storage,
	}


# Retorna uma instancia de get_it.
func get_instance(storage: Array[Dictionary] = []):
	return get_it.call(storage)
