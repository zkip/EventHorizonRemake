extends SlotProtocol
class_name Component


func _ready():
	$protocols/item.tag_set.add("component")

	type_slots.visible = false
	if kind_slots:
		kind_slots.queue_free()
