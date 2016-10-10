extends Reference

const DATA_FILE = "user://save.bin"

func set_total_levels(total):
	# Save the total level to file
	var file = File.new()
	var error = file.open_encrypted_with_pass(DATA_FILE, File.WRITE, OS.get_unique_ID()) # Saves cannot be shared
	file.store_var(total)
	file.close()

func get_total_levels():
	# Load the total level from file
	var file = File.new()
	var error = file.open_encrypted_with_pass(DATA_FILE, File.READ, OS.get_unique_ID())
	var total_levels = file.get_var()
	file.close()
	return total_levels