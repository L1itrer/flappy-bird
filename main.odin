package main

import "core:fmt"
import "vendor:raylib"

WINDOW_HEIGHT : i32        : 960
WINDOW_WIDTH  : i32        : 500
WINDOW_TITLE  : cstring    : "Flappy bird"

draw :: proc()
{
    raylib.ClearBackground(raylib.BLACK)

    raylib.DrawText("Hello World!", WINDOW_WIDTH/2 - 100, WINDOW_HEIGHT/2, 40, raylib.GOLD)
}

main :: proc()
{
    raylib.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_TITLE)

    for !raylib.WindowShouldClose(){
        raylib.BeginDrawing()

        draw()

        raylib.EndDrawing()
    }
}