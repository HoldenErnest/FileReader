extends Control

var title = ""
var rating = -1
var tags = ""
var desc = ""
var link = ""
var num = 0
var image = ""
var date = ""

func set_title(t):
	title = t

func set_rating(r):
	rating = r

func set_tags(t):
	tags = t

func set_desc(d):
	desc = d

func set_number(n):
	num = n

func set_link(l):
	link = l

func set_image(i):
	image = i

func set_date(d):
	date = d

func read():
	return ("number: " + num + "title: " + title + ". Tags: " + tags + ". Rating: " + rating + ". Description: " + desc)

func get_desc():
	return desc

func get_link():
	return link

func get_image():
	return image

func get_date():
	return date

func show_changes():
	$Item/Title.set_text(title)
	$Item/Rating.set_text(String(rating) + "/10")
	$Item/Tags.set_text(tags)
	$Item/Number.set_text(String(num))

func _on_ViewButton_button_down():
	Global.Items.selected_media = self
	Global.Items.new_selected_updates()
