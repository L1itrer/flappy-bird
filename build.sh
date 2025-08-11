odin build src -out:flappy-bird.exe -o:speed
odin build ./src/game -no-crt -no-entry-point -no-bounds-check -o:speed -target:js_wasm32
