extends WindowDialog

onready var thisMenu = $"/root/Node2D/Tabs/Read/SaveNewConfirm"

func _on_cancel_button_down():
	thisMenu.hide()


func _on_create_button_down():
	Global.Items.path = "user://Files/" + $LineEdit.text + ".tres"
	Global.Items.write_file_confirmed()
	thisMenu.hide()

func _on_SaveNewButton_button_down():
	thisMenu.popup()
	$LineEdit.text = Global.Items.path.replace("user://Files/","").replace(".tres","")
