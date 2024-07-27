package main

import "vendor:raylib"
import "core:fmt"

player_get_texture :: proc() -> raylib.Texture2D
{
    using raylib

    player_image := LoadImage("./assets/sprites/yellowbird-midflap.png")
    player_texture : Texture2D = LoadTextureFromImage(player_image)

    UnloadImage(player_image)

    return player_texture
}

draw :: proc(player_texture: raylib.Texture2D)
{
    using raylib

    BeginDrawing()
    ClearBackground(BLACK)
    DrawTexture(player_texture, cast(i32)g_player.pos_x, cast(i32)g_player.pos_y, WHITE)
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
}