extends ItemList

func _on_Tabs_tab_selected(tab):
	if tab == 1:
		if (is_instance_valid(Global.Items.selected_media)):
			$TitleEdit.set_text(Global.Items.selected_media.title)
			$TagsEdit.set_text(Global.Items.selected_media.tags)
			$DescEdit.set_text(Global.Items.selected_media.desc)
			$RatingEdit.set_text(Global.Items.selected_media.rating)
			$LinkEdit.set_text(Global.Items.selected_media.link)
			$ImageEdit.set_text(Global.Items.selected_media.image)
			$DateCreated.set_text(Global.Items.selected_media.date)

func Save_Changes_Button():
	if (Global.Items.selected_media != Global.Items.mediaObjects[Global.Items.mediaObjects.size()-1]): # dont save the last line(--,--,--,--,--)
		Global.Items.selected_media.set_title($TitleEdit.get_text())
		Global.Items.selected_media.set_tags($TagsEdit.get_text())
		Global.Items.selected_media.set_desc($DescEdit.get_text().replace("\n", ". "))
		Global.Items.selected_media.set_rating($RatingEdit.get_text())
		Global.Items.selected_media.set_link($LinkEdit.get_text())
		Global.Items.selected_media.set_image($ImageEdit.get_text())
		Global.Items.selected_media.set_date($DateCreated.get_text())
		Global.Items.selected_media.show_changes()
		Global.Items.new_selected_updates()
	else:
		print("cannot change that media(--,--,--,--,--)")
