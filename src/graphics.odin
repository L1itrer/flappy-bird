package main

import ray "vendor:raylib"

Textures :: struct {
    pipe_texture : ray.Texture2D,
    ground_texture: ray.Texture2D,
    player_textures : [3]ray.Texture2D,
    background_texture: ray.Texture2D
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
    ray.DrawRectangleLinesEx(ray.Rectangle(hitbox), 3.0, color)
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
    when ODIN_DEBUG{
        hitbox_draw(pipe.upper_hitbox)
        hitbox_draw(pipe.lower_hitbox)
        hitbox_draw(pipe.score_hitbox, ray.GREEN)
    }

}

textures_load :: proc() -> Textures
{
    textures := Textures{
        pipe_texture = ray.LoadTexture("./assets/sprites/pipe-green.png"),
        ground_texture = ray.LoadTexture("./assets/sprites/base.png"),
        player_textures = {ray.LoadTexture("./assets/sprites/redbird-downflap.png"),
            ray.LoadTexture("./assets/sprites/redbird-midflap.png"),
            ray.LoadTexture("./assets/sprites/redbird-upflap.png")},
        background_texture = ray.LoadTexture("./assets/sprites/background-night.png")
    }
    return textures
}

textures_unload :: proc(textures: Textures)
{
    ray.UnloadTexture(textures.pipe_texture)
    for texture in textures.player_textures
    {
        ray.UnloadTexture(texture)
    }
}

ground_draw :: proc(ground: []Rectangle, textures: Textures)
{
    for ground_piece in ground
    {
        when ODIN_DEBUG
        {
            hitbox_draw(ground_piece)
        }
        ray.DrawTexture(textures.ground_texture, i32(ground_piece.x), i32(ground_piece.y), ray.WHITE)
    }
}


background_draw :: proc(background: []Point, texture: ray.Texture2D)
{
    for background_piece in background
    {
        ray.DrawTextureEx(texture, ray.Vector2({background_piece.x, background_piece.y}), 0, PLAYER_TEXTURE_SCALE, ray.WHITE)
    }
}

draw :: proc(game: ^Game, textures: Textures)
{
    ray.BeginDrawing()
    ray.ClearBackground(ray.BLACK)
    background_draw(game.background[:], textures.background_texture)

    //TODO: player drawing in a separate function
    NUDGE :: -7.5
    player_position := ray.Vector2{f32(game.player.hitbox.x) + NUDGE, f32(game.player.hitbox.y) + NUDGE}
    ray.DrawTextureEx(
        textures.player_textures[game.player.current_frame],
        player_position,
        rotation = 0,
        scale = f32(PLAYER_TEXTURE_SCALE),
        tint = ray.WHITE)
    when ODIN_DEBUG do hitbox_draw(game.player.hitbox, ray.WHITE)

    for pipe in game.pipes {
        pipe_draw(pipe, textures.pipe_texture)
    }

    ray.DrawText(ray.TextFormat("%d", game.player.score), 30, 30, 50, ray.WHITE)
    ray.DrawText(ray.TextFormat("FPS: %d", ray.GetFPS()), 30, 80, 20, ray.WHITE)
    ground_draw(game.ground[:], textures)
    ray.EndDrawing()
}

poll :: proc(action: ^Action)
{
    switch 
    {
        case ray.IsKeyPressed(ray.KeyboardKey.SPACE) || ray.IsMouseButtonPressed(ray.MouseButton.LEFT):
            action^ = Action.JUMP
        case:
            action^ = Action.NONE
    }
}