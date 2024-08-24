extends StaticBody2D
class_name ItemObj

@onready var globals = get_node("/root/Globals")
@export var item : Item

var player : CharacterBody2D 
var player_inventory : Node2D 


var picked_up : bool = false

func _ready() -> void:
	
	self.name = "Item%s" % item.name
	
	if not picked_up:
		player = get_parent().get_node("Player")
		player_inventory = get_parent().get_node("Player/Inventory")
	else:
		player = get_parent().get_parent()
		player_inventory = get_parent()
		
	var texture : Texture2D = item.sprite
	var shape : RectangleShape2D = $ItemCollision.shape
	shape.size = texture.get_size()
	
	$ItemSprite.texture = texture
	$ItemCollision.shape = shape
	$ItemCollision.position = $ItemSprite.position
	
	
	if player != null:
		player.pickup.connect(_on_player_pickup)

func _physics_process(delta: float) -> void:
	if picked_up:
		var rect : Rect2 = $ItemSprite.get_rect()
		global_position = get_parent().get_parent().get_node("ItemSpawn").global_position - rect.size / 2
	


func _on_player_pickup(body: StaticBody2D) -> void:
	if body == self:
		if player_inventory.get_child_count() < globals.INVENTORY_SIZE_MAX:
			var instance : StaticBody2D = self.duplicate()
			instance.get_node("ItemCollision").disabled = true
			instance.visible = false
			instance.picked_up = true
			player_inventory.add_child(instance)
			queue_free()
