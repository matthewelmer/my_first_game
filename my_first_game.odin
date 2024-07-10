package main

import rl "vendor:raylib"

SCREEN_WIDTH :: 1280
SCREEN_HEIGHT :: 720

PLAYER_START_POS :: rl.Vector2{640, 320}
PLAYER_SIZE :: rl.Vector2{64, 64}
PLAYER_SPEED :: 400
PLAYER_COLOR :: rl.ORANGE

main :: proc() {
    rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "My First Game")
    defer rl.CloseWindow()

    player_pos := PLAYER_START_POS
    for !rl.WindowShouldClose() {
        rl.BeginDrawing()

        rl.ClearBackground(rl.BLUE)

        if rl.IsKeyDown(.LEFT) {
            player_pos.x -= PLAYER_SPEED * rl.GetFrameTime()
        }
        if rl.IsKeyDown(.RIGHT) {
            player_pos.x += PLAYER_SPEED * rl.GetFrameTime()
        }
        rl.DrawRectangleV(player_pos, PLAYER_SIZE, PLAYER_COLOR)

        rl.EndDrawing()
    }
}
