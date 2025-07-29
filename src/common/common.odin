package common


Sound :: enum {
	JUMP_SOUND,
	DEATH_SOUND,
	SCORE_SOUND,
}

TextureKind :: enum {
	PIPE,
	GROUND,
	PLAYER1,
	PLAYER2,
	PLAYER3,
	BACKGROUND,
	GAME_OVER,
	MAIN_MENU,
}


Rectangle :: struct {
	x, y, width, height: f32,
}

Point :: struct {
	x, y: f32,
}
