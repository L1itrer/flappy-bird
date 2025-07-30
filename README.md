# Flappy bird

Yet another clone of the classic Flappy Bird game. Implemented for two platforms: desktop and a browser. Written in odinlang.

# Building

The following commands assume that you are within the game's root folder and have the odin compiler in your PATH.

## Desktop

### Windows

```cmd
odin build src -out:flappy-bird.exe -o:speed"
```

### Linux

```bash
odin build src -out:flappy-bird.out -o:speed"
```

## Browser (wasm platform)

To run the browser version you need to host an http server. The simplest way is to use python's http.server module.

```cmd
odin build ./src/game -no-crt -no-entry-point -no-bounds-check -o:speed -target:js_wasm32
python -m http.server
```
