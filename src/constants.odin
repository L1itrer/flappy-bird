package main

WINDOW_HEIGHT            : i32        :  i32(480 * SCALE)
WINDOW_WIDTH             : i32        :  i32(334 * SCALE)
WINDOW_TITLE             : cstring    :  "Flappy bird"
PLAYER_VELOCITY_INCREASE : f32        :  0.8
PLAYER_VELOCITY_TERMINAL : f32        :  20.0
PLAYER_JUMP_VELOCITY     : f32        : -15.0
PLAYER_TEXTURE_SCALE     : f32        :  SCALE
PLAYER_ANIM_SPEED : i32 : 8
PLYER_ANIM_FRAME_COUNT : i32 : 3

PIPE_WIDTH               :            : 52.0 * SCALE
PIPE_HEIGHT              :            : 300.0 * SCALE
PIPE_SCORE_HEIGHT        : f32        : 200.0
PIPE_VELOCITY            : f32        : 3.0
PIPE_NEXT_DISTANCE       :            : 300
PIPE_FIRST_STATE_Y       : f32        : -400.0
FACTOR                   : f32        : f32(WINDOW_HEIGHT)/7
PIPE_POSSIBLE_YS :: [?]f32{PIPE_FIRST_STATE_Y,
    PIPE_FIRST_STATE_Y + FACTOR,
    PIPE_FIRST_STATE_Y + FACTOR*2,
    PIPE_FIRST_STATE_Y + FACTOR*3}

BACKGROUND_VELOCITY      : f32         : PIPE_VELOCITY * 0.05
BACKGROUND_WIDTH : f32 : 288 * SCALE

SCALE                    : f32        : 1.5
GODMODE :: false