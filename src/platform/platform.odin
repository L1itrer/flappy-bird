#+build !wasm32
package platform

import "../common"
import "base:runtime"
import "core:fmt"
import "core:math"
import "core:math/rand"
import "core:os"
import "core:strconv"
import "core:strings"
import ray "vendor:raylib"

jump_sound, death_sound, score_sound: ray.Sound

highest_score: i32

textures: Textures

Textures :: struct {
	pipe_texture:       ray.Texture2D,
	ground_texture:     ray.Texture2D,
	player_textures:    [3]ray.Texture2D,
	background_texture: ray.Texture2D,
	game_over_texture:  ray.Texture2D,
	main_menu_texture:  ray.Texture2D,
}
textures_load :: proc "contextless" () {
	textures = {
		pipe_texture       = ray.LoadTexture("./assets/sprites/pipe-green.png"),
		ground_texture     = ray.LoadTexture("./assets/sprites/base.png"),
		player_textures    = {
			ray.LoadTexture("./assets/sprites/redbird-downflap.png"),
			ray.LoadTexture("./assets/sprites/redbird-midflap.png"),
			ray.LoadTexture("./assets/sprites/redbird-upflap.png"),
		},
		background_texture = ray.LoadTexture("./assets/sprites/background-night.png"),
		game_over_texture  = ray.LoadTexture("./assets/sprites/gameover.png"),
		main_menu_texture  = ray.LoadTexture("./assets/sprites/message.png"),
	}
}

sin :: proc "contextless" (a: f32) -> f32 {
	return math.sin_f32(a)
}

rand_int :: proc "contextless" (min, max: u32) -> u32 {
	context = runtime.default_context()
	return (rand.uint32() % max) + min
}

textures_unload :: proc "contextless" () {
	ray.UnloadTexture(textures.pipe_texture)
	for texture in textures.player_textures {
		ray.UnloadTexture(texture)
	}
}


init :: proc "contextless" () {
	jump_sound = ray.LoadSound("./assets/audio/wing.ogg")
	death_sound = ray.LoadSound("./assets/audio/hit.ogg")
	score_sound = ray.LoadSound("./assets/audio/point.ogg")
	read_highest_score()
	textures_load()
}

read_highest_score :: proc "contextless" () -> i32 {
	context = runtime.default_context()
	{
		data, error := os.read_entire_file_from_filename_or_err("highscore.txt")
		defer delete(data)
		if error != nil {
			fmt.println("Creating highest score")
			save_highest_score(0)
			highest_score = 0
		} else {
			highest_score = ray.TextToInteger(cstring(raw_data(data)))
		}
	}
	return highest_score
}

save_highest_score :: proc "contextless" (score: i32) {
	context = runtime.default_context()
	file_handle, err := os.open("highscore.txt", mode = os.O_WRONLY)
	defer os.close(file_handle)
	if err != nil {
		file_handle, err = os.open("highscore.txt", mode = os.O_WRONLY | os.O_CREATE)
		if err != nil {
			os.exit(1)
		}
	}
	fmt.fprintf(file_handle, "%v", score)
}

sound_play :: proc "contextless" (sound: common.Sound) {
	switch sound {
	case .JUMP_SOUND:
		ray.PlaySound(jump_sound)
	case .DEATH_SOUND:
		ray.PlaySound(death_sound)
	case .SCORE_SOUND:
		ray.PlaySound(score_sound)
	}
}

draw_texture :: proc "contextless" (tex_kind: common.TextureKind, x, y, rotation, scale: f32) {
	position := ray.Vector2({x, y})
	texture: ray.Texture2D
	switch (tex_kind) {
	case .PIPE:
		texture = textures.pipe_texture
	case .GROUND:
		texture = textures.ground_texture
	case .BACKGROUND:
		texture = textures.background_texture
	case .GAME_OVER:
		texture = textures.game_over_texture
	case .MAIN_MENU:
		texture = textures.main_menu_texture
	case .PLAYER1:
		texture = textures.player_textures[0]
	case .PLAYER2:
		texture = textures.player_textures[1]
	case .PLAYER3:
		texture = textures.player_textures[2]
	}
	ray.DrawTextureEx(texture, position, rotation, scale, ray.WHITE)
}

draw_rectangle_lines :: proc "contextless" (box: common.Rectangle, thickness: f32) {
	ray.DrawRectangleLinesEx(ray.Rectangle(box), thickness, ray.RED)
}

draw_rectangle_rounded :: proc "contextless" (x, y, h, w: f32, roundness: f32, color: u32) {
	rect := ray.Rectangle {
		x      = x,
		y      = y,
		height = h,
		width  = w,
	}
	ray.DrawRectangleRounded(rect, roundness, 0, transmute(ray.Color)color)
}

draw_text :: proc "contextless" (text: cstring, x, y, size: i32, color: u32) {
	ray.DrawText(text, x, y, size, transmute(ray.Color)color)
}


draw_text_and_number :: proc "contextless" (
	text: cstring,
	x, y, size: i32,
	color: u32,
	number: i32,
) {
	context = runtime.default_context()
	number := number
	buffer: [128]u8
	texts := string(text)
	length := 0
	for c in texts {
		buffer[length] = u8(c)
		length += 1
	}
	strconv.write_int(buffer[length:], i64(number), 10)
	length = 0
	for c in buffer {
		if (c == 0) do break
		length += 1
	}

	cstr := strings.clone_to_cstring(string(buffer[:length]))
	defer delete(cstr)
	draw_text(cstr, x, y, size, color)
}
