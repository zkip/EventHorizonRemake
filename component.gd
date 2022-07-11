extends SlotProtocol
class_name Component

onready var tag_set = utils.Set.new($protocols/item.tags)


func _ready():
	tag_set.add("component")

	type_slots.visible = false
	if kind_slots:
		kind_slots.queue_free()
