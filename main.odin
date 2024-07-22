package main

import "core:fmt"
import "vendor:raylib"

WINDOW_HEIGHT            : i32        : 960
WINDOW_WIDTH             : i32        : 500
WINDOW_TITLE             : cstring    : "Flappy bird"
PLAYER_VELOCITY_INCREASE : f64        : 0.5

Player :: struct{
    pos_x, pos_y, velocity_y: f64
}

init_player :: proc(player: ^Player)
{
    player.pos_x = 100.0
    player.pos_y = f64(WINDOW_HEIGHT/2)
}


main :: proc()
{
    using raylib
    player : Player
    init_player(&player)
    
    InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_TITLE)
    SetTargetFPS(60)
    texture := LoadTexture("assets/sprites/bluebird-midflap.png")

    for !WindowShouldClose() {

        player.pos_y += player.velocity_y
        player.velocity_y += PLAYER_VELOCITY_INCREASE

        BeginDrawing()

        ClearBackground(BLACK)
        DrawTexture(texture, cast(i32)player.pos_x, cast(i32)player.pos_y, WHITE)

        if IsKeyPressed(KeyboardKey.SPACE)
        {
            player.velocity_y = -10.0
        }

        EndDrawing()
    }
}