extends Menu

@onready var ingredient_container: ItemList = %IngredientContainer
@onready var results_container: ItemList = %ResultsContainer
@onready var recipe_list: ItemList = %RecipeList

var player: Player = null
var recipe: Recipe = null


func _ready() -> void:
	super._ready()
	for _recipe: Recipe in ItemLoader.ALL_RECIPES:
		var idx = recipe_list.add_item(_recipe.name, _recipe.icon)
		recipe_list.set_item_metadata(idx, _recipe)
	recipe_list.item_selected.connect(update_list)
	update_list(0)


func update_list(index: int) -> void:
	recipe = recipe_list.get_item_metadata(index)
	ingredient_container.clear()
	results_container.clear()

	for ing in recipe.required_items:
		var idx = ingredient_container.add_item(ing.name, ing.icon)
		ingredient_container.set_item_metadata(idx, ing)

	for ing in recipe.result_item:
		var idx = results_container.add_item(ing.name, ing.icon)
		results_container.set_item_metadata(idx, ing)


func _on_craft_pressed() -> void:
	recipe.craft(player.inventory)
