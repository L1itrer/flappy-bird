"use strict"

let wasm = null;
const canvas = document.getElementById("game-canvas");
const ctx = canvas.getContext('2d');
const sprites = [document.getElementById("pipe"), document.getElementById("ground"), document.getElementById("player1"), document.getElementById("player2"), document.getElementById("player3"), document.getElementById("background"), document.getElementById("gameover-screen"), document.getElementById("main-menu-screen")];
const audio = [document.getElementById("jump-sound"), document.getElementById("hit-sound"), document.getElementById("score-sound")];
ctx.fillStyle = "#EE0000";

let game_update = null;
let game_draw = null;
let game_init = null;
let degree_to_radians = null;

function draw_rectangle_lines(x, y, w, h, thickness) {
  ctx.strokeRect(x, y, w, h);
}

function color_from_int(color) {
    const r = ((color>>(0*8))&0xFF).toString(16).padStart(2, '0');
    const g = ((color>>(1*8))&0xFF).toString(16).padStart(2, '0');
    const b = ((color>>(2*8))&0xFF).toString(16).padStart(2, '0');
    const a = ((color>>(3*8))&0xFF).toString(16).padStart(2, '0');
    return "#"+r+g+b+a;
}

function draw_rectangle_rounded(x, y, h, w, roundness, color) {
  ctx.fillStyle = color_from_int(color);
  ctx.beginPath();
  ctx.roundRect(x, y, w, h, roundness);
  ctx.fill();
}

function cstrlen(mem, ptr) {
    let len = 0;
    while (mem[ptr] != 0) {
        len++;
        ptr++;
    }
    return len;
}
function cstr_by_ptr(mem_buffer, ptr) {
    const mem = new Uint8Array(mem_buffer);
    const len = cstrlen(mem, ptr);
    const bytes = new Uint8Array(mem_buffer, ptr, len);
    return new TextDecoder().decode(bytes);
}

function draw_text_internal(text, x, y, size, color) {
  ctx.font = size+"px serif";
  ctx.fillStyle = color_from_int(color);
  ctx.fillText(text, x, y);
}

function draw_text(text_cstr, x, y, size, color) {
  const buffer = wasm.instance.exports.memory.buffer;
  const text = cstr_by_ptr(buffer, text_cstr);
  draw_text_internal(text, x, y, size, color);
}

function draw_text_and_number(text_cstr, x, y, size, color, number) {
  const buffer = wasm.instance.exports.memory.buffer;
  const text = cstr_by_ptr(buffer, text_cstr)+number;
  draw_text_internal(text, x, y, size, color);
}

function sin(x) {
    return Math.sin(x);
}

function clearCanvas() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
}

function draw_rectangle(x, y, w, h) {
    ctx.fillRect(x, y, w, h);
}

function draw_texture(tex_id, x, y, rotation, scale) {
  ctx.setTransform(scale, 0, 0, scale, x, y);
  ctx.rotate(degree_to_radians(rotation));
  ctx.drawImage(sprites[tex_id], -sprites[tex_id].width/2, -sprites[tex_id].height/2);
  ctx.setTransform(1, 0, 0, 1, 0, 0);
}


function sound_play(sound_id) {
  audio[sound_id].play()
}

function rand_int(min, max) {
  return Math.floor(Math.random() * max) + min;
}


function read_highest_score() {
  // TODO
}

function save_highest_score() {
  // TODO
}

function game_loop() {
    game_update();
    clearCanvas();
    game_draw();
    wasm.instance.exports.no_action();
    window.requestAnimationFrame(game_loop);
}

WebAssembly.instantiateStreaming(fetch('game.wasm'), {
    platform_wasm: {
        draw_rectangle_lines,
        draw_text,
        draw_text_and_number,
        sin,
        rand_int,
        draw_rectangle_rounded,
        draw_texture,
        sound_play,
        read_highest_score,
        save_highest_score,
    }

}).then((w) => {
    wasm = w;
    document.addEventListener("keypressed", (e) => {
        wasm.instance.exports.key_pressed(e.key.charCodeAt());
    });

    document.addEventListener("mousedown", (e) => {
        wasm.instance.exports.mouse_button_down(e.button);
    });
    game_update = wasm.instance.exports.update;
    game_draw   = wasm.instance.exports.draw;
    game_init = wasm.instance.exports.init;
    degree_to_radians = wasm.instance.exports.degree_to_radians;
    game_init()

    window.requestAnimationFrame(game_loop);
  });
