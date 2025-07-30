package main

import "core:fmt"
import "core:os"
import "game"
import "platform"
import ray "vendor:raylib"

// CLEANUP TODOS:
// TODO: pipes are barely visible when starting the game
// TODO: unhardcode the constans, make them dependant on the window width and height
// TODO: disable sound button
// TODO: add some cool font
// TODO: score on wasm is displayed with different number of spaces than on desktop
// TODO: add tint of textures to desktop (for better ground display)
// TODO: Remove single pixel gap between the pipes and the ground
// TODO: bake in all the textures into the executable for desktop


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
	icon_img := ray.LoadImageFromMemory(".png", raw_data(icon[8:]), i32(len(icon[8:])))
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
