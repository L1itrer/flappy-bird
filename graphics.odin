package main

import "vendor:raylib"
import "core:fmt"

draw :: proc(texture: raylib.Texture2D)
{
    using raylib

    BeginDrawing()
    ClearBackground(BLACK)
    DrawTexture(texture, cast(i32)g_player.pos_x, cast(i32)g_player.pos_y, WHITE)
    EndDrawing()
}

poll :: proc(action: ^Action)
{
    switch 
    {
        case raylib.IsKeyPressed(raylib.KeyboardKey.SPACE):
            action^ = Action.Jump
            fmt.println("Jumped: ", action^)
        case:
            action^ = Action.None
    }
    // if raylib.IsKeyPressed(raylib.KeyboardKey.SPACE)
    // {
    //     action^ = Action.Jump
    // }
    // else
    // {
    //     action^ = Action.None
    // }
}