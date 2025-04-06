package main

import "core:fmt"
import ray "vendor:raylib"
import "core:os"


TARGET_FPS :: 60
TARGET_FRAME_TIME : f64 : 1.0/TARGET_FPS



game_update_highest_score :: proc(score: i32)
{
    file_handle, err := os.open("highscore.txt", mode = os.O_WRONLY)
    defer os.close(file_handle)
    if err != nil
    {
        file_handle, err = os.open("highscore.txt", mode = os.O_WRONLY | os.O_CREATE)
        if err != nil
        {
            os.exit(1)
        }
    }
    fmt.fprintf(file_handle, "%v", score)
}

main :: proc()
{
    fmt.printfln("Let the show begin! %s", os.args[0])
    when ODIN_DEBUG {
        fmt.println("...with Debugging!")
    }
    game: Game


    data, error := os.read_entire_file_from_filename_or_err("highscore.txt")
    if error != nil
    {
        fmt.println("Creating highest score")
        game_update_highest_score(0)
        game.player.highest_score = 0
    }
    else
    {
        game.player.highest_score = ray.TextToInteger(cstring(raw_data(data)))
    }
    defer delete(data)
    game_init(&game)


    ray.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_TITLE)
    ray.SetExitKey(ray.KeyboardKey.KEY_NULL)
    ray.SetTargetFPS(TARGET_FPS)

    textures := textures_load()



    for !ray.WindowShouldClose() {
        poll(&game.player.current_action)

        update(&game)

        draw(&game, textures)
    }

    ray.CloseWindow()
    textures_unload(textures)
    fmt.printfln("Your highest score was: %v!", game.player.highest_score)
}