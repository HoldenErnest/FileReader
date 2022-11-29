extends ItemList

var OSdate = OS.get_date()
var dateLine = String(OSdate.month) + "/" + String(OSdate.day) + "/" + String(OSdate.year)

func create_media():
	Global.Items.mediaObjects[Global.Items.mediaObjects.size()-1].queue_free() # remove last item textures(--,--,--,--,--)
	
	var clone
	clone = Global.Items.media_dupe.instance()
	Global.Items.add_child(clone)
	clone.set_title($TitleEdit.get_text())
	clone.set_tags($TagsEdit.get_text())
	clone.set_desc($DescEdit.get_text().replace("\n", ". "))
	clone.set_rating($RatingEdit.get_text())
	clone.set_link($LinkEdit.get_text())
	clone.set_image($ImageEdit.get_text())
	clone.set_date($DateCreated.get_text())
	clone.set_number(int(Global.Items.mediaObjects.size()))
	clone.show_changes()
	
	Global.Items.mediaObjects[int(clone.num)-1] = clone
	Global.Items.mediaObjects.resize(Global.Items.mediaObjects.size()+1)#add (--) to end of list
	
	var last
	last = Global.Items.media_dupe.instance()
	Global.Items.add_child(last)
	last.set_title("--")
	last.set_tags("--")
	last.set_desc("--")
	last.set_rating("--")
	last.set_link("--")
	last.set_image("--")
	last.set_number(int(Global.Items.mediaObjects.size()))
	last.show_changes()
	
	Global.Items.mediaObjects[int(last.num)-1] = last


func _on_Tabs_tab_selected(tab):
	if tab == 2:
		$TitleEdit.set_text("")
		$TagsEdit.set_text("")
		$DescEdit.set_text("")
		$RatingEdit.set_text("")
		$LinkEdit.set_text("")
		$ImageEdit.set_text("")
		$DateCreated.set_text(dateLine)


func _on_AddButton_button_down():
	$ConfirmationPopup.popup()

func _on_DateChangeButton_button_down():
	$DateChangeWindow.popup()
	$DateChangeWindow/LineEdit.set_text(dateLine)

func _on_date_save_button_down():
	$DateCreated.set_text($DateChangeWindow/LineEdit.get_text())
	$DateChangeWindow.hide()
