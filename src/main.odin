package main

import "core:fmt"
import "core:os"
import "game"
import "platform"
import ray "vendor:raylib"


@(rodata)
icon := #load("../assets/favicon.png")

TARGET_FPS :: 60
TARGET_FRAME_TIME: f64 : 1.0 / TARGET_FPS

poll :: proc() {
	switch {
	case ray.IsKeyPressed(ray.KeyboardKey.SPACE):
		game.key_pressed(' ')
	case ray.IsMouseButtonPressed(ray.MouseButton.LEFT):
		game.mouse_button_down(0)
	case ray.IsKeyPressed(ray.KeyboardKey.ESCAPE):
		game.key_pressed(27)
	case ray.IsMouseButtonPressed(ray.MouseButton.RIGHT):
		game.mouse_button_down(1)
	case:
		game.no_action()
	}
}

main :: proc() {
	fmt.printfln("Let the show begin! %s")
	when ODIN_DEBUG {
		fmt.println("...with Debugging!")
	}


	ray.InitWindow(game.WINDOW_WIDTH, game.WINDOW_HEIGHT, game.WINDOW_TITLE)
	ray.InitAudioDevice()
	ray.SetExitKey(ray.KeyboardKey.KEY_NULL)
	ray.SetTargetFPS(TARGET_FPS)
	icon_img := ray.LoadImageFromMemory(".png", raw_data(icon), i32(len(icon)))
	ray.SetWindowIcon(icon_img)

	game.init()
	platform.init()

	for !ray.WindowShouldClose() {
		poll()

		game.update()

		ray.BeginDrawing()
		ray.ClearBackground(ray.BLACK)
		game.draw()
		ray.EndDrawing()
	}

	ray.CloseWindow()
	platform.textures_unload()
}
