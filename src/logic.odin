package main
//TODO: Need my own randomness for wasm module
import "core:math/rand"


Rectangle :: struct {
    x,y, width, height : f64
}

rectangle_check_collision :: proc(rec1, rec2: Rectangle) -> bool
{
    return (rec1.x < (rec2.x + rec2.width) && (rec1.x + rec1.width) > rec2.x) &&
    (rec1.y < (rec2.y + rec2.height) && (rec1.y + rec1.height) > rec2.y)
}

Player :: struct {
    hitbox : Rectangle,
    velocity_y: f64,
    current_action: Action,
    score: i32
}

Game :: struct {
    player : Player,
    current_state: GameState,
    pipes : [4]Pipe,
}

Pipe :: struct {
    upper_hitbox : Rectangle,
    score_hitbox : Rectangle,
    lower_hitbox : Rectangle,
    pos_x, pos_y : f64,
    scored: bool
}

Action :: enum{
    NONE,
    JUMP,
}

GameState :: enum {
    GAME_PLAYING,
    MAIN_MENU,
    GAME_OVER,
}

pipes_init :: proc(pipes: []Pipe)
{
    for i : i32 = 0;i < i32(len(pipes));i += 1
    {
        possible_ys := PIPE_POSSIBLE_YS
        magic_y : f64 = rand.choice(possible_ys[:])
        x := f64(WINDOW_WIDTH + i * PIPE_NEXT_DISTANCE)
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

pipe_set_xy :: proc(pipe: ^Pipe, x: f64, y: f64)
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
            magic_y : f64 = rand.choice(possible_ys[:])
            pipe_set_xy(&pipe,
                f64(WINDOW_WIDTH + i32(len(pipes) - 2) * PIPE_NEXT_DISTANCE),
                magic_y
            );
            pipe.scored = false
        }
        pipe.pos_x -= PIPE_VELOCITY
        pipe.score_hitbox.x -= PIPE_VELOCITY
        pipe.lower_hitbox.x -= PIPE_VELOCITY
        pipe.upper_hitbox.x -= PIPE_VELOCITY
    }
}

game_init :: proc(game: ^Game)
{
    player_init(&game.player)
    pipes_init(game.pipes[:])
    game.current_state = GameState.MAIN_MENU

}

player_init :: proc(player: ^Player)
{
    player.hitbox = Rectangle{
        x = 100.0,
        y = f64(WINDOW_HEIGHT/2),
        width = 28.0,
        height = 20.0,
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

player_apply_gravity :: proc(player: ^Player)
{
    player.velocity_y += PLAYER_VELOCITY_INCREASE
    if player.velocity_y > PLAYER_VELOCITY_TERMINAL
    {
        player.velocity_y = PLAYER_VELOCITY_TERMINAL
    }
    player.hitbox.y += player.velocity_y
}


game_playing :: proc(game: ^Game)
{
    action := game.player.current_action
    when ODIN_DEBUG{
        if i32(game.player.hitbox.y) > WINDOW_HEIGHT
        {
            action = Action.JUMP
        }
    }


    pipes_move(game.pipes[:])

    player_apply_gravity(&game.player)
    switch action
    {
        case .JUMP:
            player_jump(&game.player)
        case .NONE:
        case:
    }

    for &pipe in game.pipes
    {
        if rectangle_check_collision(game.player.hitbox, pipe.score_hitbox) && !pipe.scored
        {
            game.player.score += 1
            pipe.scored = true
        }

        if rectangle_check_collision(game.player.hitbox, pipe.lower_hitbox) ||
        rectangle_check_collision(game.player.hitbox, pipe.upper_hitbox)
        {
            game.current_state = GameState.GAME_OVER
        }
    }
}

main_menu :: proc(game: ^Game)
{
    action := game.player.current_action

    switch action
    {
        case .JUMP:
            game.current_state = GameState.GAME_PLAYING
            game_playing(game)
        case .NONE:
        case:
    }
}

game_reset :: proc(game: ^Game)
{
    pipes_init(game.pipes[:])
    player_init(&game.player)
}

update :: proc(game: ^Game)
{

    switch game.current_state
    {
        case .MAIN_MENU:
            main_menu(game)
        case .GAME_PLAYING:
            game_playing(game)
        case .GAME_OVER:
            pipes_init(game.pipes[:])
            player_init(&game.player)
            game.current_state = GameState.MAIN_MENU
    }

}