package main

import rl "vendor:raylib"

SCREEN_WIDTH :: 1280
SCREEN_HEIGHT :: 720

BACKGROUND_COLOR :: rl.BLUE

PLAYER_START_POS :: rl.Vector2{640, 320}
PLAYER_WIDTH :: 64
PLAYER_HEIGHT :: 64
PLAYER_SIZE :: rl.Vector2{PLAYER_WIDTH, PLAYER_HEIGHT}
PLAYER_SPEED :: 400
PLAYER_JUMP_STRENGTH :: 600
PLAYER_COLOR :: rl.ORANGE

GRAVITY_STRENGTH :: 2000

player_pos := PLAYER_START_POS
player_vel : rl.Vector2
player_grounded := false

main :: proc() {
    rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "My First Game")
    defer rl.CloseWindow()

    rl.SetTargetFPS(60)

    for !rl.WindowShouldClose() {
        update_game()
        draw_game()
    }
}

update_game :: proc() {
    // Physics.
    if player_pos.y >= f32(rl.GetScreenHeight()) - PLAYER_HEIGHT {
        player_grounded = true
        player_pos.y = f32(rl.GetScreenHeight()) - PLAYER_HEIGHT
        player_vel.y = 0
    } else {
        player_grounded = false
        player_vel.y += GRAVITY_STRENGTH * rl.GetFrameTime()
    }

    // Player input.
    if rl.IsKeyDown(.LEFT) {
        player_vel.x = -PLAYER_SPEED
    } else if rl.IsKeyDown(.RIGHT) {
        player_vel.x =  PLAYER_SPEED
    } else {
        player_vel.x = 0
    }
    if player_grounded && rl.IsKeyPressed(.SPACE) {
        player_vel.y = -PLAYER_JUMP_STRENGTH
    }
    
    // Update player position.
    player_pos += player_vel * rl.GetFrameTime()
}

draw_game :: proc() {
    rl.BeginDrawing()
    defer rl.EndDrawing()

    rl.ClearBackground(BACKGROUND_COLOR)
        
    rl.DrawRectangleV(player_pos, PLAYER_SIZE, PLAYER_COLOR)
}
