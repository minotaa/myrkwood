extends Control

# Variables for controlling the wave
var wave_amplitude = 10.0 # Height of the stadium wave
var wave_frequency = 6.0  # Speed of the wave propagation
var wave_length = 0.5     # Length of the wave (affects spacing between peaks)
var color_frequency = 0.2 # Speed of the rainbow color change
var horizontal_amplitude = 5.0 # Horizontal movement range
var scale_range = Vector2(1.0, 1.2) # Slight scaling effect

# Tracks elapsed time
var elapsed_time = 0.0

# A helper function for HSV to RGB conversion
func hsv2rgb(h, s, v):
	var i = int(h * 6.0)
	var f = h * 6.0 - i
	var p = v * (1.0 - s)
	var q = v * (1.0 - f * s)
	var t = v * (1.0 - (1.0 - f) * s)
	match i % 6:
		0: return Color(v, t, p)
		1: return Color(q, v, p)
		2: return Color(p, v, t)
		3: return Color(p, q, v)
		4: return Color(t, p, v)
		5: return Color(v, p, q)

# A helper function for the wave effect
func wave(min_val, max_val, t):
	return lerp(min_val, max_val, (sin(t) + 1.0) / 2.0)

# Main function to animate text
func _process(delta):
	# Update elapsed time
	elapsed_time += delta

	# Animate each child node
	for idx in range(get_child_count()):
		var char_node = get_child(idx)
		var offset = float(idx) * wave_length

		# Calculate wave transformations
		char_node.modulate = hsv2rgb(fmod((elapsed_time * color_frequency + offset), 1.0), 0.7, 0.8)
		char_node.position = Vector2(
			wave(-horizontal_amplitude, horizontal_amplitude, elapsed_time * wave_frequency + offset), # Horizontal oscillation
			wave(-wave_amplitude, wave_amplitude, elapsed_time * wave_frequency - offset) # Vertical wave
		)
		char_node.scale = Vector2(wave(scale_range.x, scale_range.y, elapsed_time * 3 + offset), 1)
