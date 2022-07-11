extends Node2D

var namex = "res://Trail.tscn"

var resources: Array = []


func simpleLoad(dirPath):
	var dir = Directory.new()
	dir.open(dirPath)
	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		if dir.current_is_dir():
			if not (file_name == "." or file_name == ".."):
				simpleLoad(dir.get_current_dir() + "/" + file_name)
		else:
			resources.append(dirPath + "/" + file_name)

		file_name = dir.get_next()


var packageLoadingResults = {}


func loadPackage(dirPath: String):
	var dir = Directory.new()
	if not dir.dir_exists(dirPath):
		dir.make_dir(dirPath)

	dir.open(dirPath)
	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		if dir.current_is_dir():
			if not (file_name == "." or file_name == ".."):
				loadPackage(dir.get_current_dir() + "/" + file_name)
		else:
			var result = ProjectSettings.load_resource_pack(dirPath + "/" + file_name, false)
			packageLoadingResults[dirPath + "/" + file_name] = result

		file_name = dir.get_next()


func _is_exist():
	var pathString = $TextEdit.text
	var exist = ResourceLoader.exists(pathString)
	if exist:
		current = ResourceLoader.load(pathString)
		pass
	$CheckBox.pressed = exist


onready var text = $ItemList/Label


func _ready():
	loadPackage("res://mods")
	print(packageLoadingResults, " :: package load results ")
	
	$ItemList.remove_child(text)
	_is_exist()
	simpleLoad("res://Drivers")
	for res in resources:
		var text_d = text.duplicate(DUPLICATE_USE_INSTANCING)
		var script = load(res)
		print(res, " ++ ", script)
		if script != null:
			var name = ""
			$CCNode.set_script(script)
			if "name_kind" in $CCNode:
				name = $CCNode.name_kind
			text_d.text = res + " -- " + name
			$ItemList.add_child(text_d)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

var current


func _on_TextEdit_gui_input(event):
	if event is InputEventKey:
		_is_exist()
	pass


func _on_Button_pressed():
	if current != null:
		if current is PackedScene:
			var ins = current.instance()
			ins.drivers[0] = load("res://Drivers/MajorPlayerDriver.gd")
			add_child(ins)

	pass
