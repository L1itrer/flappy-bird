package main

Rectangle :: struct {
    x,y, width, height : f64
}

Player :: struct {
    hitbox : Rectangle,
    velocity_y: f64,
    current_action: Action,
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
    pos_x, pos_y : f64
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
    magic_y : f64 = -250.0
    for i : i32 = 0;i < i32(len(pipes));i += 1
    {
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

pipe_set_x :: proc(pipe: ^Pipe, x: f64)
{
    pipe.pos_x = x
    pipe.upper_hitbox.x = x
    pipe.score_hitbox.x = x
    pipe.lower_hitbox.x = x
}

pipes_move :: proc(pipes: []Pipe)
{
    for &pipe in pipes {
        if pipe.pos_x <= -PIPE_WIDTH
        {
            pipe_set_x(&pipe, f64(WINDOW_WIDTH + i32(len(pipes) - 2) * PIPE_NEXT_DISTANCE))
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
    game.current_state = GameState.GAME_PLAYING

}

player_init :: proc(player: ^Player)
{
    player.hitbox = Rectangle{
        x = 100.0,
        y = f64(WINDOW_HEIGHT/2),
        width = 34.0,
        height = 24.0,
    }

    player.current_action = Action.NONE
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

update :: proc(game: ^Game)
{
    action := game.player.current_action
    //TODO: Debug so that no falling out of bounds
    if i32(game.player.hitbox.y) > WINDOW_HEIGHT
    {
        action = Action.JUMP
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
}