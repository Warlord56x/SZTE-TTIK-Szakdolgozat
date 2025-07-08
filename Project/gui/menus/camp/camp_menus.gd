extends Menu
class_name CampMenus

@onready var ingredient_container: ItemList = %IngredientContainer
@onready var results_container: ItemList = %ResultsContainer
@onready var recipe_list: ItemList = %RecipeList
@onready var error_label: Label = %ErrorLabel
@onready var tab_container: TabContainer = $TabContainer
@onready var item_status: ItemStatus = %ItemStatus

var player: Player = null
var recipe: Recipe = null

var current_tab := 0:
	set = set_tab


func close() -> void:
	super.close()
	item_status.close()


func set_tab(idx: int) -> void:
	tab_container.current_tab = idx
	current_tab = idx


func disable_tab(idx: int, disable: bool) -> void:
	tab_container.set_tab_disabled(idx, disable)


func _ready() -> void:
	super._ready()

	for tab in tab_container.get_child_count():
		var title := tab_container.get_tab_title(tab)
		title = title.to_snake_case().replace("_", " ").capitalize()
		tab_container.set_tab_title(tab, title)

	for _recipe: Recipe in ItemLoader.ALL_RECIPES:
		var idx = recipe_list.add_item(_recipe.name, _recipe.icon)
		recipe_list.set_item_metadata(idx, _recipe)
	recipe_list.item_selected.connect(update_list)

	update_list(0)


func update_list(index: int) -> void:
	recipe = recipe_list.get_item_metadata(index)
	ingredient_container.clear()
	results_container.clear()

	error_label.text = ""

	for ing: Ingredient in recipe.required_items:
		ingredient_container.add_item(str(ing.item.name, " x", ing.amount), ing.item.icon, false)
		#ingredient_container.set_item_metadata(idx, ing)

	for ing: Ingredient  in recipe.result_item:
		results_container.add_item(str(ing.item.name, " x", ing.amount), ing.item.icon, false)
		#results_container.set_item_metadata(idx, ing)
	
	var first_result: Ingredient  = recipe.result_item.front()
	if first_result:
		item_status.open()
		item_status.item = first_result.item


func _on_craft_pressed() -> void:
	error_label.text = ""
	var error := recipe.craft(player.inventory)
	if error != Recipe.CraftErrors.OK:
		match error:
			Recipe.CraftErrors.MISSING_ITEMS:
				error_label.text = "Missing Items"
			Recipe.CraftErrors.EXCEEDS_STACK_SIZE:
				error_label.text = "Cannot hold more items of " + recipe.name


func _on_visibility_changed() -> void:
	if error_label:
		error_label.text = ""


func _on_tab_container_tab_changed(_tab: int) -> void:
	effect.fade(0.1)
	item_status.close()
