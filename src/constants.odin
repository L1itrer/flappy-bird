package main

WINDOW_HEIGHT            : i32        :  660
WINDOW_WIDTH             : i32        :  500
WINDOW_TITLE             : cstring    :  "Flappy bird"
PLAYER_VELOCITY_INCREASE : f64        :  0.8
PLAYER_VELOCITY_TERMINAL : f64        :  20.0
PLAYER_JUMP_VELOCITY     : f64        : -15.0
PLAYER_TEXTURE_SCALE     : f64        :  1.5

PIPE_WIDTH               :            : 52.0 * SCALE
PIPE_HEIGHT              :            : 300.0 * SCALE
PIPE_SCORE_HEIGHT        : f64        : 200.0
PIPE_VELOCITY            : f64        : 3.0
PIPE_NEXT_DISTANCE       :            : 300
PIPE_FIRST_STATE_Y : f64 : -400.0
FACTOR :: f64(WINDOW_HEIGHT)/6
PIPE_POSSIBLE_YS :: [?]f64{PIPE_FIRST_STATE_Y,
    PIPE_FIRST_STATE_Y + FACTOR,
    PIPE_FIRST_STATE_Y + FACTOR*2,
    PIPE_FIRST_STATE_Y + FACTOR*3}

SCALE                    : f64        : 1.5