package platform
import "../common"
foreign import "platform_wasm"
foreign platform_wasm {
	draw_rectangle_lines :: proc "contextless" (box: common.Rectangle, thickness: f32) ---
	draw_text :: proc "contextless" (text: cstring, x, y, size: i32, color: u32) ---
	draw_text_and_number :: proc "contextless" (text: cstring, x, y, size: i32, color: u32, number: i32) ---
	draw_texture :: proc "contextless" (tex_kind: common.TextureKind, x, y, rotation, scale: f32) ---
	draw_rectangle_rounded :: proc "contextless" (x, y, h, w: f32, roundness: f32, color: u32) ---
	read_highest_score :: proc "contextless" () -> i32 ---
	save_highest_score :: proc "contextless" (score: i32) ---
	sound_play :: proc "contextless" (sound: common.Sound) ---
	sin :: proc "contextless" (a: f32) -> f32 ---
	rand_int :: proc "contextless" (min, max: u32) -> u32 ---
}
