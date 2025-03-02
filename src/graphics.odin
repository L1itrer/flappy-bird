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

hitbox_draw :: proc(hitbox: Rectangle, color := ray.RED)
{
    ray.DrawRectangleLines(
        i32(hitbox.x),
        i32(hitbox.y),
        i32(hitbox.width),
        i32(hitbox.height),
        color
    )
}

pipe_draw :: proc(pipe: Pipe, texture: ray.Texture2D)
{
    upside_down_angle :: 180.0
    ray.DrawTextureEx(
        texture,
        ray.Vector2{f32(pipe.score_hitbox.x + PIPE_WIDTH), f32(pipe.score_hitbox.y)},
        upside_down_angle,
        f32(SCALE),
        ray.WHITE
    )

    ray.DrawTextureEx(
        texture,
        ray.Vector2{f32(pipe.lower_hitbox.x), f32(pipe.lower_hitbox.y)},
        0.0,
        f32(SCALE),
        ray.WHITE
    )

    hitbox_draw(pipe.upper_hitbox)
    hitbox_draw(pipe.lower_hitbox)
    hitbox_draw(pipe.score_hitbox, ray.GREEN)

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

    for pipe in game.pipes {
        pipe_draw(pipe, textures.pipe_texture)
    }

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