package main

import "core:fmt"
import ray "vendor:raylib"




main :: proc()
{
    fmt.println("Let the show begin!")
    game: Game
    
    game_init(&game)
    
    ray.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_TITLE)
    ray.SetTargetFPS(60)

    textures := textures_load()
    defer textures_unload(textures)

    for !ray.WindowShouldClose() {
        poll(&game.player.current_action)

        update(&game)

        draw(game, textures)
    }
}