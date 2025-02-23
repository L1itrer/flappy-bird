package main

import ray "vendor:raylib"

Textures :: struct {
    player_texture, pipe_texture : ray.Texture2D
}

player_get_texture :: proc() -> ray.Texture2D
{
    player_image := ray.LoadImage("./assets/sprites/yellowbird-midflap.png")
    player_texture := ray.LoadTextureFromImage(player_image)


    ray.UnloadImage(player_image)

    return player_texture
}

pipe_draw :: proc()
{

}

textures_load :: proc() -> Textures
{
    textures := Textures{
        player_texture = ray.LoadTexture("./assets/sprites/yellowbird-midflap.png"),
        pipe_texture = ray.LoadTexture("./assets/sprites/pipe-green.png"),
    }
    return textures
}

textures_unload :: proc(textures: Textures)
{
    ray.UnloadTexture(textures.pipe_texture)
    ray.UnloadTexture(textures.player_texture)
}

draw :: proc(game: Game, textures: Textures)
{
    ray.BeginDrawing()
    ray.ClearBackground(ray.BLACK)

    player_position := ray.Vector2{f32(game.player.hitbox.x) - 5.0, f32(game.player.hitbox.y) - 5.0}
    ray.DrawTextureEx(
        textures.player_texture,
        player_position,
        rotation = 0,
        scale = f32(PLAYER_TEXTURE_SCALE),
        tint = ray.WHITE)

    ray.DrawTextureEx(
        textures.pipe_texture,
        ray.Vector2{300.0, 200.0},
        rotation = 0,
        scale = 1.5,
        tint = ray.WHITE
    )

    //DEBUG
    ray.DrawRectangleLines(i32(game.player.hitbox.x), i32(game.player.hitbox.y),
            i32(game.player.hitbox.width),i32(game.player.hitbox.height),
            ray.RED)
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