package main

import ray "vendor:raylib"

player_get_texture :: proc() -> ray.Texture2D
{
    player_image := ray.LoadImage("./assets/sprites/yellowbird-midflap.png")
    player_texture := ray.LoadTextureFromImage(player_image)

    ray.UnloadImage(player_image)

    return player_texture
}

draw :: proc(game: Game, player_texture: ray.Texture2D)
{
    ray.BeginDrawing()
    ray.ClearBackground(ray.BLACK)
    // DrawTexture(player_texture, cast(i32)g_player.pos_x, cast(i32)g_player.pos_y, WHITE)
    player_position := ray.Vector2{f32(game.player.pos_x), f32(game.player.pos_y)}
    ray.DrawTextureEx(player_texture, player_position, rotation = 0, scale = 1.5, tint = ray.WHITE)
    ray.EndDrawing()
}

poll :: proc(action: ^Action)
{
    switch 
    {
        case ray.IsKeyPressed(ray.KeyboardKey.SPACE):
            action^ = Action.JUMP
        case:
            action^ = Action.NONE
    }
}