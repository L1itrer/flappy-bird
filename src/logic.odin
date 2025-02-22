package main



Player :: struct{
    pos_x, pos_y, velocity_y: f64,
    current_action: Action,
}

Game :: struct{
    player : Player,
    current_state: GameState
}


// Pipe :: struct {
//     pox_x, pos_y: f64;
// }

Action :: enum{
    NONE,
    JUMP,
}

GameState :: enum {
    GAME_PLAYING,
    MAIN_MENU,
    GAME_OVER,
}

game_init :: proc(game: ^Game)
{
    player_init(&game.player)
    game.current_state = GameState.GAME_PLAYING

}

player_init :: proc(player: ^Player)
{
    player.pos_x = 100.0
    player.pos_y = f64(WINDOW_HEIGHT/2)
    player.current_action = Action.NONE
}

player_jump :: proc(player: ^Player)
{
    player.velocity_y = PLAYER_JUMP_VELOCITY
}

player_apply_gravity :: proc(player: ^Player)
{
    player.velocity_y += PLAYER_VELOCITY_INCREASE
    if player.velocity_y > PLAYER_VELOCITY_TERMINAL {
        player.velocity_y = PLAYER_VELOCITY_TERMINAL
    }
    player.pos_y += player.velocity_y
}

update :: proc(game: ^Game)
{
    action := game.player.current_action
    //TODO: Debug so that no falling out of bounds
    if i32(game.player.pos_y) > WINDOW_HEIGHT {
        action = Action.JUMP
    }

    player_apply_gravity(&game.player)
    switch action{
        case .JUMP:
            player_jump(&game.player)
        case .NONE:
        case:
    }
}