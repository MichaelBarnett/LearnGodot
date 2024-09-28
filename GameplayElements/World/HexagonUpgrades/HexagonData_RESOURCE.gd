class_name HexagonData extends Resource

@export var tilemap_id : Vector2i
@export var display : PackedScene
@export var recipes: Array[HexagonData] # What this can be turned into (get costs within)
@export var cost_to_order: int # How much gold the player must pay, to order this.
@export var cost_to_build: Array[Item] # What resources are needed to make this.
@export var cost_to_clear: Array[Item] # What resources will need to be taken away to clear this.
@export var build_points: int # How many hits with a hammer will this take to build.
