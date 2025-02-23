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
    pipes : [8]Pipe,
}

Pipe :: struct {
    upper_hitbox : Rectangle,
    score_hitbox : Rectangle,
    lower_hitbox : Rectangle,
    pos_x, pos_y : i32
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
    magic_y : f64 = 100.0
    single_pipe_height := 300.0 * SCALE
    single_pipe_width :=  52.0 * SCALE
    for i := 0;i < len(pipes);i += 1
    {
        x := f64(200 + i * 100)
        pipes[i] = Pipe{
            upper_hitbox = Rectangle{
                x,
                magic_y,
                single_pipe_width,
                single_pipe_height
            },
            score_hitbox = Rectangle{
                x,
                magic_y + single_pipe_height,
                single_pipe_width,
                single_pipe_height
            },
            lower_hitbox = Rectangle{
                x,
                magic_y + single_pipe_height * 2,
                single_pipe_width,
                single_pipe_height
            }
        }
    }
}

game_init :: proc(game: ^Game)
{
    player_init(&game.player)
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

    player_apply_gravity(&game.player)
    switch action
    {
        case .JUMP:
            player_jump(&game.player)
        case .NONE:
        case:
    }
}