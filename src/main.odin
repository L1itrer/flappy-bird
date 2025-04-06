package main

import "core:fmt"
import ray "vendor:raylib"
import "core:os"


TARGET_FPS :: 60
TARGET_FRAME_TIME : f64 : 1.0/TARGET_FPS

g_file_handle : os.Handle

game_update_highest_score :: proc(score: i32)
{
    fmt.fprintf(g_file_handle, "%v", score)
}

main :: proc()
{
    fmt.printfln("Let the show begin! %s", os.args[0])
    when ODIN_DEBUG {
        fmt.println("...with Debugging!")
    }
    err : os.Error
    g_file_handle, err = os.open("highscore.txt", mode = os.O_WRONLY)
    if err != nil
    {
        g_file_handle, err = os.open("highscore.txt", mode = os.O_WRONLY | os.O_CREATE)
        if err != nil
        {
            os.exit(1)
        }
        game_update_highest_score(0)
    }
    defer os.close(g_file_handle)

    data, error := os.read_entire_file_from_filename_or_err("highscore.txt")
    if error != nil
    {
        fmt.println("Error reading file")
        os.exit(1)
    }
    defer delete(data)
    game: Game
    game_init(&game)
    game.player.highest_score = ray.TextToInteger(cstring(raw_data(data)))


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