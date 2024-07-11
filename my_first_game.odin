package main

import "core:fmt"
import rl "vendor:raylib"

SCREEN_WIDTH :: 1280
SCREEN_HEIGHT :: 720

BACKGROUND_COLOR :: rl.Color{110, 184, 168, 255}

PLAYER_START_POS :: rl.Vector2{640, 320}
PLAYER_SPEED :: 400
PLAYER_JUMP_STRENGTH :: 600
PLAYER_RUN_NUM_FRAMES :: 4
PLAYER_RUN_FRAME_LENGTH :: f32(0.1)

GRAVITY_STRENGTH :: 2000

player_pos := PLAYER_START_POS
player_vel : rl.Vector2
player_grounded := false

player_run_texture : rl.Texture2D
player_run_width : f32
player_run_height : f32
player_run_frame_timer : f32
player_run_current_frame : int
player_flip : bool

main :: proc() {
    rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "My First Game")
    defer rl.CloseWindow()

    player_run_texture = rl.LoadTexture("cat_run.png")
    player_run_width = f32(player_run_texture.width)
    player_run_height = f32(player_run_texture.height)

    rl.SetTargetFPS(60)

    for !rl.WindowShouldClose() {
        update_game()
        draw_game()
    }
}

update_game :: proc() {
    // Physics.
    if player_pos.y >= f32(rl.GetScreenHeight()) - 64 {
        player_grounded = true
        player_pos.y = f32(rl.GetScreenHeight()) - 64
        player_vel.y = 0
    } else {
        player_grounded = false
        player_vel.y += GRAVITY_STRENGTH * rl.GetFrameTime()
    }

    // Player input.
    if rl.IsKeyDown(.LEFT) {
        player_flip = true
        player_vel.x = -PLAYER_SPEED
    } else if rl.IsKeyDown(.RIGHT) {
        player_flip = false
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

    player_run_frame_timer += rl.GetFrameTime()
    if player_run_frame_timer > PLAYER_RUN_FRAME_LENGTH {
        player_run_current_frame += 1
        player_run_frame_timer = 0
    
        if player_run_current_frame == PLAYER_RUN_NUM_FRAMES {
            player_run_current_frame = 0
        }
    }

    rl.ClearBackground(BACKGROUND_COLOR)
    
    draw_player_source := rl.Rectangle {
        x = f32(player_run_current_frame) * player_run_width / f32(PLAYER_RUN_NUM_FRAMES),
        y = 0,
        width = player_run_width / f32(PLAYER_RUN_NUM_FRAMES),
        height = player_run_height,
    }

    if player_flip {
        draw_player_source.width *= -1
    }

    draw_player_dest := rl.Rectangle {
        x = player_pos.x,
        y = player_pos.y,
        width = player_run_width * 4 / f32(PLAYER_RUN_NUM_FRAMES),
        height = player_run_height * 4,
    }

    rl.DrawTexturePro(player_run_texture, draw_player_source, draw_player_dest, 0, 0, rl.WHITE)
}
