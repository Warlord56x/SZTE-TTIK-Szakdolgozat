extends Control

const RECIPES_PATH = "res://assets/data/recipes/"

const TEMP = "user://"

var recipes: Array[Recipe] = []


func _ready() -> void:
	
	var i = 1
	print(ItemLoader.ALL_RECIPES)
	for r: Recipe in ItemLoader.ALL_RECIPES:
		var ok = ResourceSaver.save(r.duplicate(true), TEMP + str(i, ".tres"))
		if ok == OK:
			print("ok")
		else:
			printerr(ok, TEMP + str(i, ".tres"))
		i += 1

	i = 1
	for r: Recipe in ItemLoader.ALL_RECIPES:
		var ok := ResourceLoader.load(TEMP + str(i, ".tres"), "Recipe") as Recipe
		print(ok, TEMP + str(i, ".tres"))
		print(ok.required_items)
		print(ok.result_item)
		i += 1
	
	#print(recipes)
