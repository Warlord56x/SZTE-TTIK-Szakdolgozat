extends Node


#region Recipe Region
const TEST_RECIPE_1 = preload("res://assets/data/recipes/test_recipe1.tres")
const TEST_RECIPE_2 = preload("res://assets/data/recipes/test_recipe2.tres")
const TEST_RECIPE = preload("res://assets/data/recipes/test_recipe.tres")
#endregion

#region Loot Region
const BOW = preload("res://assets/data/items/bow.tres")
const COIN := preload("res://assets/data/items/coin.tres")
const HEALTH_POTION := preload("res://assets/data/items/health_potion.tres")
#endregion


const BASE_LOOT_TABLE := [BOW, COIN, HEALTH_POTION]
const ALL_RECIPES := [TEST_RECIPE, TEST_RECIPE_1, TEST_RECIPE_2]
