package game

import "../common"
import "../platform"


// player_get_texture :: proc() -> ray.Texture2D {
// 	player_image := ray.LoadImage("./assets/sprites/yellowbird-midflap.png")
// 	player_texture := ray.LoadTextureFromImage(player_image)
// 
// 
// 	ray.UnloadImage(player_image)
// 
// 	return player_texture
// }


hitbox_draw :: proc(hitbox: common.Rectangle) {
	platform.draw_rectangle_lines(hitbox, 3.0)
}

pipe_draw :: proc(pipe: Pipe) {
	upside_down_angle :: 180.0
	platform.draw_texture(
		common.TextureKind.PIPE,
		f32(pipe.score_hitbox.x + PIPE_WIDTH),
		f32(pipe.score_hitbox.y),
		f32(upside_down_angle),
		f32(SCALE),
	)

	platform.draw_texture(
		common.TextureKind.PIPE,
		f32(pipe.lower_hitbox.x),
		f32(pipe.lower_hitbox.y),
		0.0,
		f32(SCALE),
	)
	when ODIN_DEBUG {
		hitbox_draw(pipe.upper_hitbox)
		hitbox_draw(pipe.lower_hitbox)
		hitbox_draw(pipe.score_hitbox)
	}

}


ground_draw :: proc(ground: []common.Rectangle) {
	for ground_piece in ground {
		platform.draw_texture(
			common.TextureKind.GROUND,
			f32(ground_piece.x),
			f32(ground_piece.y),
			0.0,
			1.0,
		)
		when ODIN_DEBUG 
		{
			hitbox_draw(ground_piece)
		}
	}
}


background_draw :: proc(background: []common.Point) {
	for background_piece in background {
		platform.draw_texture(
			common.TextureKind.BACKGROUND,
			background_piece.x,
			background_piece.y,
			0,
			PLAYER_TEXTURE_SCALE,
		)
	}
}

@(rodata)
player_textures: [3]common.TextureKind = {
	common.TextureKind.PLAYER1,
	common.TextureKind.PLAYER2,
	common.TextureKind.PLAYER3,
}

@(export)
draw :: proc() {
	game := &g_game
	background_draw(game.background[:])

	//TODO: player drawing in a separate function
	NUDGE :: -7.5
	player_position := common.Point {
		f32(game.player.hitbox.x) + NUDGE,
		f32(game.player.hitbox.y) + NUDGE,
	}
	platform.draw_texture(
		player_textures[game.player.current_frame],
		player_position.x,
		player_position.y,
		rotation = game.player.velocity_y,
		scale = f32(PLAYER_TEXTURE_SCALE),
	)
	when ODIN_DEBUG do hitbox_draw(game.player.hitbox)

	for pipe in game.pipes {
		pipe_draw(pipe)
	}

	platform.draw_text_and_number("", 30, 30, 50, WHITE, i32(game.player.score))
	//    ray.DrawText(ray.TextFormat("FPS: %d", ray.GetFPS()), 30, 80, 20, ray.WHITE)
	ground_draw(game.ground[:])

	if game.current_state == GameState.GAME_OVER {
		platform.draw_texture(common.TextureKind.GAME_OVER, 50, 100, 0, 2)
		game_over_window: common.Rectangle = {
			x      = 50,
			y      = 200,
			width  = 400,
			height = 200,
		}
		game_over_inner_window: common.Rectangle = {
			x      = 60,
			y      = 210,
			width  = 380,
			height = 180,
		}
		platform.draw_rectangle_rounded(
			game_over_window.x,
			game_over_window.y,
			game_over_window.height,
			game_over_window.width,
			10.0,
			WHITE,
		)
		platform.draw_rectangle_rounded(
			game_over_inner_window.x,
			game_over_inner_window.y,
			game_over_inner_window.height,
			game_over_inner_window.width,
			10.0,
			LPURPLE,
		)
		platform.draw_text_and_number("Score     ", 100, 250, 40, WHITE, game.player.score)
		platform.draw_text_and_number("Highscore ", 100, 290, 40, WHITE, game.player.highest_score)
		platform.draw_text("Press SPACE to try again", 60, 430, 30, WHITE)
	}

	if game.current_state == GameState.GAME_PAUSE {
		platform.draw_text("PAUSED", WINDOW_WIDTH / 2 - 100, 430, 30, WHITE)
	}

	if game.current_state == GameState.MAIN_MENU {
		//        ray.DrawTextureEx(textures.main_menu_texture, ray.Vector2({90,100}), 0, 2, ray.WHITE)
		platform.draw_text("Flappy bird", 100, 100, 50, WHITE)
	}
}

@(export)
mouse_button_down :: proc(button: i32) {
	if (button == 0) do g_game.player.current_action = Action.JUMP
	if (button == 1) do g_game.player.current_action = Action.PAUSE
}

@(export)
key_pressed :: proc(key_code: i32) {
	switch key_code {
	case ' ':
		g_game.player.current_action = Action.JUMP
	case 27:
		g_game.player.current_action = Action.PAUSE
	}
}

@(export)
no_action :: proc() {
	g_game.player.current_action = Action.NONE
}
