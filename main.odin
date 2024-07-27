package main

import "core:fmt"
import "vendor:raylib"


g_player : Player


main :: proc()
{
    using raylib

    
    init_player(&g_player)
    
    InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_TITLE)
    SetTargetFPS(60)
    
    player_texture := player_get_texture()
    current_action: Action

    for !WindowShouldClose() {
        poll(&current_action)

        update(current_action)

        draw(player_texture)
    }
}