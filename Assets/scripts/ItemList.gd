extends VBoxContainer

var content
var path = "user://Files/file.tres"
var media = [] #media objects are to be read only, dont change this directly, instead change the item objects themselves and save the file by looping through them
var selected_media
var mediaObjects = []
var clone
var sort_by = 0 # the id for selected sort dropdown

export (PackedScene) var media_dupe

var removeInt

func _ready():
	Global.Items = self
	var dir = Directory.new()
	dir.open("user://")
	dir.make_dir("Files")
	load_file()
	$"/root/Node2D/Tabs/Read/Header/sortDropdown".add_item("Title", 0)
	$"/root/Node2D/Tabs/Read/Header/sortDropdown".add_item("Rating", 1)
	$"/root/Node2D/Tabs/Read/Header/sortDropdown".add_item("Tags", 2)
	$"/root/Node2D/Tabs/Read/Header/sortDropdown".add_item("Description", 3)

func load_file():
	var file = File.new()
	if file.file_exists(path):
		file.open(path, File.READ)
		while !file.eof_reached():
			content = file.get_csv_line()
			media.resize(media.size()+1)
			media[media.size()-1] = content #increase array size and insert next poolstringarray(next csvline)
			clone = media_dupe.instance()
			add_child(clone)
			clone.set_number(String(media.size()))
			clone.set_title(media[int(clone.num)-1][0])
			clone.set_rating(media[int(clone.num)-1][2])
			clone.set_tags(media[int(clone.num)-1][1])
			clone.set_desc(media[int(clone.num)-1][3])
			clone.set_link(media[int(clone.num)-1][4])
			clone.set_image(media[int(clone.num)-1][5])
			clone.set_date(media[int(clone.num)-1][6])
			clone.show_changes()
			mediaObjects.resize(mediaObjects.size()+1)
			mediaObjects[int(clone.num)-1] = clone
		selected_media = mediaObjects[0]
		new_selected_updates()
		file.close()
	else:
		#create a new file with the last line(--,--,--,--,--)
		file.open(path, File.WRITE)
		file.store_string("\"This list(file.tres) will always be opened first\",\"Edit items by selecting them\",\"rating\",\" Descriptions are used to store information about the item without it being displayed first-hand... for example: you can save the list as a new file or overwrite this file.  Additionaly you can edit the description/save it, open a provided website, or remove the selected item from the list all at the bottom of the window when you have the \'read\' tab selected(tabs at the top of the window).\",\" links must start with http:// or https:// -- copy and paste links to make it easier\",\"use http://{website path}.jpg files to display an image\"" + "\n--,--,--,--,--,--")
		file.close()
		load_file()

func get_media():
	return mediaObjects

func load_selection(): # load a new file with all its contents shown
	
	path = "user://Files/" + $"/root/Node2D/FileName".get_text() + ".tres"
	var file = File.new()
	if file.file_exists(path):
		for i in mediaObjects.size():
			mediaObjects[i].queue_free()
		mediaObjects.resize(0)
		media.resize(0)
		load_file()
	else:
		print("file: " + path + " is missing")

func sort(keyword): # sort_by decides what to use the keyword on(title,tags, ect..)
	# Show all media objects in the list
	#load_selection()
	
	for i in mediaObjects.size()-1:
		mediaObjects[i].visible = true
	
	var num_in_sort = 0
	
	if keyword != "":
		
		if (sort_by == 0): # sort by title------------------------------------------
			for i in mediaObjects.size()-1:
				if !(keyword.to_lower() in mediaObjects[i].title.to_lower()):
					mediaObjects[i].visible = false
				else:
					num_in_sort += 1
					mediaObjects[i].num = num_in_sort
					mediaObjects[i].show_changes()
		elif (sort_by == 1): # sort by rating---------------------------------------
			for i in mediaObjects.size()-1:
				if !(keyword.to_lower() in mediaObjects[i].rating.to_lower()):
					mediaObjects[i].visible = false
				else:
					num_in_sort += 1
					mediaObjects[i].num = num_in_sort
					mediaObjects[i].show_changes()
		elif (sort_by == 2): # sort by tags-----------------------------------------
			for i in mediaObjects.size()-1:
				if !(keyword.to_lower() in mediaObjects[i].tags.to_lower()):
					mediaObjects[i].visible = false
				else:
					num_in_sort += 1
					mediaObjects[i].num = num_in_sort
					mediaObjects[i].show_changes()
		elif (sort_by == 3): # sort by description----------------------------------
			for i in mediaObjects.size()-1:
				if !(keyword.to_lower() in mediaObjects[i].desc.to_lower()):
					mediaObjects[i].visible = false
				else:
					num_in_sort += 1
					mediaObjects[i].num = num_in_sort
					mediaObjects[i].show_changes()
	else:
		for i in mediaObjects.size()-1:
			mediaObjects[i].num = i+1
			mediaObjects[i].show_changes()
			$"/root/Node2D/Tabs/Read/Header/Label".set_text("Read List : [" + String(selected_media.num) + "] > \"" + selected_media.title.to_upper() + "\"")
	
	print("there are " + String(num_in_sort) + " items in this sort")

func button_save_desc(): # save the description from the text_edit
	if (selected_media != mediaObjects[mediaObjects.size()-1]): # dont save the last line(--,--,--,--,--)
		selected_media.set_desc($"/root/Node2D/Tabs/Read/DescriptionBox".get_text().replace("\n", ". "))

func new_selected_updates(): # if a new item is selected make sure to call these updates
	$"/root/Node2D/Tabs/Read/DescriptionBox".set_text(selected_media.get_desc())
	$"/root/Node2D/Tabs/Read/DateCreated".set_text("Created: " + selected_media.get_date())
	$"/root/Node2D/Tabs/Read/Header/Label".set_text("Read List : [" + String(selected_media.num) + "] > \"" + selected_media.title.to_upper() + "\"")
	# Create an HTTP request node and connect its completion signal.
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "_http_request_completed")
	
	var error
	
	if (".jpg" in selected_media.get_image()):
		error = http_request.request(selected_media.get_image())
		if error != OK:
			error = http_request.request("http://bppl.kkp.go.id/uploads/publikasi/karya_tulis_ilmiah/default.jpg")#if it fails return default
	else:
		error = http_request.request("http://bppl.kkp.go.id/uploads/publikasi/karya_tulis_ilmiah/default.jpg")#if its not a jpg file return default
		if error != OK:
			push_error("An error occurred in the HTTP request.")

func button_link(): # open the link of selected item
# warning-ignore:return_value_discarded
	if (selected_media != mediaObjects[mediaObjects.size()-1]): # dont try to open last(--,--,--,--,--)
		OS.shell_open(selected_media.get_link())

func confirmed_remove_item(): #remove selected and move all next items forward 1(update their numbers)
	if (selected_media != mediaObjects[mediaObjects.size()-1]): # cant remove last one
		removeInt = int(selected_media.num)-1
		mediaObjects.remove(removeInt)
		selected_media.queue_free()
		for i in range(removeInt, mediaObjects.size()):
			mediaObjects[i].set_number(i+1)
			mediaObjects[i].show_changes()
		if removeInt < mediaObjects.size():
			selected_media = mediaObjects[removeInt]
		elif (removeInt != 0):
			selected_media = mediaObjects[removeInt-1]
		else:
			selected_media = mediaObjects[0]
		new_selected_updates()
	else:
		print("cant remove last(--,--,--,--,--)")

func remove_button(): # ask for confirm to remove selected item
	$"/root/Node2D/Tabs/Read/RemoveConfirm".popup()

func load_selection_pop():
	$"/root/Node2D/FileNewConfirm".popup()

func load_selection_pop_file(new_text): #same as load_selection_pop but with unneeded argument
	$"/root/Node2D/FileNewConfirm".popup()

func write_file_confirmed(): # overwite/write to new file
	var write_string = ""
	var file = File.new()

	file.open(path, File.WRITE)
	for medias in mediaObjects:
		if medias.title != "":
			write_string += "\"" + medias.title + "\","
		else:
			write_string += "--,"
		if medias.tags != "":
			write_string += "\"" + medias.tags + "\","
		else:
			write_string += "--,"
		if medias.rating != "":
			write_string += "\"" + medias.rating + "\","
		else:
			write_string += "--,"
		if medias.desc != "":
			write_string += "\"" + medias.desc + "\","
		else:
			write_string += "--,"
		if medias.link != "":
			write_string += "\"" + medias.link + "\""
		else:
			write_string += "--,"
		if medias.image != "":
			write_string += ",\"" + medias.image + "\""
		else:
			write_string += "--,"
		if medias.date != "":
			write_string += ",\"" + medias.date + "\""
		else:
			write_string += ",\"" + "--" + "\""
		if medias != mediaObjects[mediaObjects.size()-1]: # make a new line if its not the last item
			write_string += "\n"
	file.store_string(write_string)
	file.close()

func _on_sortDropdown_item_selected(index): # detect when sort_by is changed
	sort_by = index
	$"/root/Node2D/Tabs/Read/Header/Keywords".set_text("")

func _on_Keywords_text_changed(new_text): # detect evertime keywords text changes
	sort($"/root/Node2D/Tabs/Read/Header/Keywords".get_text())#call sort(searching) method on the inputed text

func _on_ShowListButton_button_down():
	$"/root/Node2D/Tabs/Read/ShowListPopup".popup()
	
	var fillText = ""
	
	for item in mediaObjects:
		if item.visible:
			fillText += item.title + " - " + item.rating + "/10, \n"
	
	$"/root/Node2D/Tabs/Read/ShowListPopup/TextEdit".set_text(fillText)

func _http_request_completed(result, response_code, headers, body):
	
	var image = Image.new()
	var error = image.load_jpg_from_buffer(body)
	if error != OK:
		push_error("Couldn't load the image.")
	
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	$"/root/Node2D/Tabs/Read/Image".texture = texture

func change_date_pop():
	$"/root/Node2D/Tabs/Edit/DateChangeWindow".popup()
	$"/root/Node2D/Tabs/Edit/DateChangeWindow/LineEdit".set_text(selected_media.get_date())

func save_date_close():
	$"/root/Node2D/Tabs/Edit/DateCreated".set_text($"/root/Node2D/Tabs/Edit/DateChangeWindow/LineEdit".get_text())
	$"/root/Node2D/Tabs/Edit/DateChangeWindow".hide()


#func reorder_by_dropdown(index):
#	var mediaObjects2 = []
#
#	var lastChecked = mediaObjects[0].date.split("/")
#
#	for i in mediaObjects.size(): # look through everything to find the lowest value of sort
#		for medias in mediaObjects: # remove that lowest and search for the next lowest
#
#
#			if (index == 0):
#				var currentDate = medias.date.split("/") # get month day and year from current media
#				if (int(currentDate[2]) <= lastChecked[2]):
#					lastChecked = currentDate
#				else if (int(currentDate[1]) < lastChecked[1]):
#					lastChecked = currentDate
