extends Reference

# All Commands
var commands = []
var node_root # Reference to root node

func _init(node):
	node_root = node
	load_commands()

# Load all commands in given directory
func load_commands():
	# Get path to /commands/ folder
	var dir = self.get_script().get_path()
	print(str(dir))
	dir = str(dir).replace("command_list.gd", "commands/")
	
	
	var directory = Directory.new()
	# Possible BUG
	# When exporting (pck, zip or exe) this returns false
	# even tough directory.open(dir) works
	# if (! directory.dir_exists(dir)):
	# 	print("Directory ", dir, " does not exist")
	# 	return
	if (directory.open(dir) == OK):
		directory.list_dir_begin()
		var file_name = directory.get_next()
		while(file_name != ""):
			if (!directory.current_is_dir()):
				print("Loading command: ", file_name)
				commands.append(load(dir + file_name).new(node_root))
			file_name = directory.get_next()
		directory.list_dir_end()
	else:
		print("Command directory \"", dir, "\" could not be opened")