package main

import "core:math/rand"
import "core:math"

g_frame_counter := 0

//DONE: Add loopable ground
//DONE: Player dies when falling to the ground
//DONE: What the hell happens when player tries to go above the pipes
//DONE: Add background
//DONE: Tracking Highest Score
//DONE: Add game over screen
//DONE: Improve game menu
//DONE: Add pause menu
//DONE: Add sounds

Rectangle :: struct {
    x,y, width, height : f32
}

Point :: struct {
    x, y: f32
}

rectangle_check_collision :: proc(rec1, rec2: Rectangle) -> bool
{
    return (rec1.x < (rec2.x + rec2.width) && (rec1.x + rec1.width) > rec2.x) &&
    (rec1.y < (rec2.y + rec2.height) && (rec1.y + rec1.height) > rec2.y)
}

Player :: struct {
    hitbox : Rectangle,
    velocity_y: f32,
    current_action: Action,
    score: i32,
    highest_score : i32,
    current_frame: i32,
    frame_counter: i32
}

Game :: struct {
    ground: [4]Rectangle,
    pipes : [4]Pipe,
    player : Player,
    background: [3]Point,
    current_state: GameState,

}

Pipe :: struct {
    upper_hitbox : Rectangle,
    score_hitbox : Rectangle,
    lower_hitbox : Rectangle,
    pos_x, pos_y : f32,
    scored: bool
}

Action :: enum{
    NONE,
    JUMP,
    PAUSE,
}

GameState :: enum {
    GAME_PLAYING,
    MAIN_MENU,
    GAME_OVER,
    GAME_PAUSE,
}

pipes_init :: proc(pipes: []Pipe)
{
    for i : i32 = 0;i < i32(len(pipes));i += 1
    {
        possible_ys := PIPE_POSSIBLE_YS
        magic_y := rand.choice(possible_ys[:])
        x := f32(WINDOW_WIDTH + i * PIPE_NEXT_DISTANCE)
        pipes[i] = Pipe{
            pos_x = x,
            pos_y = magic_y,
            upper_hitbox = Rectangle{
                x,
                magic_y,
                PIPE_WIDTH,
                PIPE_HEIGHT
            },
            score_hitbox = Rectangle{
                x,
                magic_y + PIPE_HEIGHT,
                PIPE_WIDTH,
                PIPE_SCORE_HEIGHT
            },
            lower_hitbox = Rectangle{
                x,
                magic_y + PIPE_HEIGHT + PIPE_SCORE_HEIGHT,
                PIPE_WIDTH,
                PIPE_HEIGHT
            }
        }
    }
}

pipe_set_xy :: proc(pipe: ^Pipe, x: f32, y: f32)
{
    pipe.pos_x = x
    pipe.upper_hitbox.x = x
    pipe.score_hitbox.x = x
    pipe.lower_hitbox.x = x

    pipe.pos_y = y
    pipe.upper_hitbox.y = y
    pipe.score_hitbox.y = y + PIPE_HEIGHT
    pipe.lower_hitbox.y = y + PIPE_HEIGHT + PIPE_SCORE_HEIGHT
}

pipes_move :: proc(pipes: []Pipe)
{
    for &pipe in pipes {
        if pipe.pos_x <= -PIPE_WIDTH
        {
            possible_ys := PIPE_POSSIBLE_YS
            magic_y : f32 = rand.choice(possible_ys[:])
            pipe_set_xy(&pipe,
                f32(WINDOW_WIDTH + i32(len(pipes) - 2) * PIPE_NEXT_DISTANCE),
                magic_y
            );
            pipe.scored = false
        }
        move_by := PIPE_VELOCITY
        pipe.pos_x -= move_by
        pipe.score_hitbox.x -= move_by
        pipe.lower_hitbox.x -= move_by
        pipe.upper_hitbox.x -= move_by
    }
}

ground_init :: proc(ground: []Rectangle)
{
    ground_height :: 112
    for i := 0;i < len(ground);i += 1
    {
        ground[i].width = 336
        ground[i].x = f32(i) * ground[i].width
        ground[i].y = f32(WINDOW_HEIGHT - ground_height)
        ground[i].height = ground_height
    }
}

ground_update :: proc(ground: []Rectangle)
{
    for &ground_piece in ground
    {
        if ground_piece.x + ground_piece.width <= 0
        {
            ground_piece.x = f32(WINDOW_WIDTH)
        }
        ground_piece.x -= PIPE_VELOCITY
    }
}

background_init :: proc(background: []Point)
{
    for i := 0; i < len(background); i += 1
    {
        background[i] = Point{
            x = BACKGROUND_WIDTH * f32(i) - f32(i*1)
            // y is zero by default
        }
    }
}

background_update :: proc(background: []Point)
{
    for &background_piece in background
    {
        if background_piece.x + BACKGROUND_WIDTH <= 0
        {
            background_piece.x = f32(WINDOW_WIDTH)
        }
        background_piece.x -= BACKGROUND_VELOCITY
    }
}


game_init :: proc(game: ^Game)
{
    player_init(&game.player)
    pipes_init(game.pipes[:])
    ground_init(game.ground[:])
    background_init(game.background[:])
    game.current_state = GameState.MAIN_MENU
}

player_init :: proc(player: ^Player)
{
    player.hitbox = Rectangle{
        x = 100.0,
        y = f32(WINDOW_HEIGHT/2) - 100,
        width = 34.0,
        height = 30.0,
        // a value i pulled out of nowhere
    }

    player.current_action = Action.NONE
    player.score = 0 // explicit initialization because this function may be called more than once
    player.velocity_y = 0
}

player_jump :: proc(player: ^Player)
{
    player.velocity_y = PLAYER_JUMP_VELOCITY
}

player_play_animation :: proc(player: ^Player)
{
    player.frame_counter = (player.frame_counter + 1) % PLAYER_ANIM_SPEED
    if player.frame_counter == 0 do player.current_frame = (player.current_frame + 1) % PLYER_ANIM_FRAME_COUNT
}

player_apply_gravity :: proc(player: ^Player, ground: []Rectangle)
{
    for ground_piece in ground
    {
        if rectangle_check_collision(player.hitbox, ground_piece)
        {
            player.velocity_y = 0
            player.hitbox.y = f32(WINDOW_HEIGHT) - ground_piece.height - player.hitbox.height
            return
        }
    }
    player.hitbox.y += player.velocity_y
    player.velocity_y += PLAYER_VELOCITY_INCREASE
    if player.velocity_y > PLAYER_VELOCITY_TERMINAL
    {
        player.velocity_y = PLAYER_VELOCITY_TERMINAL
    }
}


game_playing :: proc(game: ^Game)
{
    action := game.player.current_action
    when ODIN_DEBUG || GODMODE == true{
        if i32(game.player.hitbox.y) > WINDOW_HEIGHT
        {
            action = Action.JUMP
        }
    }


    pipes_move(game.pipes[:])

    player_apply_gravity(&game.player, game.ground[:])
    player_play_animation(&game.player)
    switch action
    {
        case .JUMP:
            player_jump(&game.player)
            sound_play(Sound.JUMP_SOUND)
        case .PAUSE:
            game.current_state = GameState.GAME_PAUSE
            return
        case .NONE:
        case:
    }

    for &pipe in game.pipes
    {
        if rectangle_check_collision(game.player.hitbox, pipe.score_hitbox) && !pipe.scored
        {
            game.player.score += 1
            pipe.scored = true
            sound_play(Sound.SCORE_SOUND)
            //PIPE_VELOCITY += 10 :D
        }
        when GODMODE == false {
            if rectangle_check_collision(game.player.hitbox, pipe.lower_hitbox) ||
            rectangle_check_collision(game.player.hitbox, pipe.upper_hitbox)
            {
                game.current_state = GameState.GAME_OVER
                sound_play(Sound.DEATH_SOUND)
            }
        }
    }
    when GODMODE == false{
        for ground_piece in game.ground
        {
            if rectangle_check_collision(game.player.hitbox, ground_piece)
            {
                game.current_state = GameState.GAME_OVER
                game.player.velocity_y = 0
                game.player.hitbox.y = f32(WINDOW_HEIGHT) - ground_piece.height - game.player.hitbox.height
                sound_play(Sound.DEATH_SOUND)
            }
        }
    }

    ground_update(game.ground[:])
    background_update(game.background[:])
}

main_menu :: proc(game: ^Game)
{
    action := game.player.current_action
    player_play_animation(&game.player)
    game.player.hitbox.y += math.sin_f32(f32(g_frame_counter/20))
    switch action
    {
        case .JUMP:
            game.current_state = GameState.GAME_PLAYING
            game_playing(game)
        case .NONE, .PAUSE:
        case:
    }
}

game_reset :: proc(game: ^Game)
{
    pipes_init(game.pipes[:])
    ground_init(game.ground[:])
    background_init(game.background[:])
    player_init(&game.player)
}



game_over :: proc(game: ^Game)
{
    action := game.player.current_action
    player_apply_gravity(&game.player, game.ground[:])
    switch action
    {
        case .JUMP:
            game_reset(game)
            game.current_state = GameState.MAIN_MENU
            game_playing(game)
        case .NONE, .PAUSE:
        case:
    }
}

game_pause :: proc(game: ^Game)
{
    action := game.player.current_action
    switch action
    {
        case .JUMP:
            game.current_state = GameState.GAME_PLAYING
            game.player.current_action = Action.JUMP
            game_playing(game)
        case .PAUSE:
            game.current_state = GameState.GAME_PLAYING
            game.player.current_action = Action.NONE
        case .NONE:

    }
}

update :: proc(game: ^Game)
{
    g_frame_counter += 1
    switch game.current_state
    {
        case .MAIN_MENU:
            main_menu(game)
        case .GAME_PLAYING:
            game_playing(game)
        case .GAME_OVER:
            if game.player.score > game.player.highest_score
            {
                game.player.highest_score = game.player.score
                game_update_highest_score(game.player.score)
            }
            game_over(game)
        case .GAME_PAUSE:
            game_pause(game)
    }

}