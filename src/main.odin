package main

import "core:fmt"
import ray "vendor:raylib"


main :: proc()
{
    fmt.println("Let the show begin!")
    when ODIN_DEBUG {
        fmt.println("...with Debugging!")
    }
    game: Game
    
    game_init(&game)

    
    ray.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_TITLE)
    ray.SetExitKey(ray.KeyboardKey.KEY_NULL)
    ray.SetTargetFPS(60)

    textures := textures_load()


    for !ray.WindowShouldClose() && game.current_state != GameState.GAME_OVER {
        poll(&game.player.current_action)

        update(&game)

        draw(game, textures)
    }

    ray.CloseWindow()
    textures_unload(textures)
    fmt.printfln("Your score was: %v!", game.player.score)
}