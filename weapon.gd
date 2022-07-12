extends Component
class_name Weapon


func _ready():
	$protocols/item.tag_set.add("component/weapon")

	type_slots.visible = false
	kind_slots.visible = false
