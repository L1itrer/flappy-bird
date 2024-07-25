package main

import "core:fmt"

Player :: struct{
    pos_x, pos_y, velocity_y: f64
}

Action :: enum{
    Jump,
    None,
}

init_player :: proc(player: ^Player)
{
    g_player.pos_x = 100.0
    g_player.pos_y = f64(WINDOW_HEIGHT/2)
}

player_jump :: proc()
{
    g_player.velocity_y = PLAYER_JUMP_VELOCITY
}

player_apply_gravity :: proc()
{
    g_player.pos_y += g_player.velocity_y
    g_player.velocity_y += PLAYER_VELOCITY_INCREASE
}

update :: proc(action: Action)
{
    switch action{
        case .Jump:
            player_jump()
        case .None:
            player_apply_gravity()
        case:
            player_apply_gravity()
    }
}