package main

import rl "vendor:raylib"

main :: proc() {
    rl.InitWindow(1280, 720, "My First Game")
    defer rl.CloseWindow()

    player_pos := rl.Vector2 { 640, 320 }
    for !rl.WindowShouldClose() {
        rl.BeginDrawing()

        rl.ClearBackground(rl.BLUE)

        if rl.IsKeyDown(.LEFT) {
            player_pos.x -= 400*rl.GetFrameTime()
        }
        if rl.IsKeyDown(.RIGHT) {
            player_pos.x += 400*rl.GetFrameTime()
        }
        rl.DrawRectangleV(player_pos, {64, 64}, {255, 180, 0, 255})

        rl.EndDrawing()
    }
}
