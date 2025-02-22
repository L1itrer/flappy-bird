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
    
    player_texture := player_get_texture()

    for !ray.WindowShouldClose() {
        poll(&game.player.current_action)

        update(&game)

        draw(game, player_texture)
    }
}