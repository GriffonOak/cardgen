package cardgen

import clay "clay-odin"
import rl "vendor:raylib"
import "base:runtime"
import "core:strings"
import "core:reflect"
import "core:os"
import "core:fmt"
import "core:encoding/csv"
import "core:strconv"

_ :: runtime
_ :: strings

Vec2 :: [2]f32

Mode :: enum {
    Card_Beeg,
    Card_Smol,
    Graph,
}

mode: Mode = .Card_Beeg

Font_ID :: enum u16 {
    Default,
    Italic,
    Bold,
}

card_fonts: [Font_ID]rl.Font

Slot_Kind :: enum {
    Head,
    Torso,
    Hand,
    Legs,
    Mod,
}

Targeting_Kind :: enum {
    None,
    Self,
    Adjacent,
    Surrounding,
    Straight,
    Ballistic,
}

Font_Icon_Kind :: enum {
    Weight,
    Hp,
    Energy,
    Damage,
    Block,
    Counter,
    Precision,
    Slot_Head,
    Slot_Torso,
    Slot_Hand,
    Slot_Legs,
    Slot_Mod,
    Targeting_Self,
    Targeting_Adjacent,
    Targeting_Surrounding,
    Targeting_Straight,
    Targeting_Ballistic,
    Phase_1,
    Phase_2,
    Phase_3,
}

Icon_Token :: struct {
    icon_kind: Font_Icon_Kind,
    text: Maybe(string),
}

Text_Token :: union {
    string,
    Icon_Token,
}

Card_Ability_Kind :: enum {
    Attack,
    Movement,
    Utility,
    Passive,
}

card_ability_background_colors := #partial [Card_Ability_Kind]clay.Color {
    .Attack = {230, 160, 150, 255},
    .Utility = {150, 160, 230, 255},
    .Movement = {120, 200, 130, 255},
    .Passive = {230, 170, 230, 255},
}

Card_Ability_Targeting :: struct {
    kind: Targeting_Kind,
    range: int,
}

Card_Ability_Timing :: enum {
    None,
    Phase_1,
    Phase_2,
    Phase_3,
}

Card_Ability :: struct {
    name: string,
    text: string,
    reminder: string,
    kind: Card_Ability_Kind,
    timing: Card_Ability_Timing,
    targeting: []Card_Ability_Targeting,
    
}

Card :: struct {
    name: string,
    slots: []Slot_Kind,
    weight, max_hp, price: int,
    abilities: []Card_Ability,
    flavour: string,
}


font_icons := #load_directory("assets/font_icons")
font_icon_images: [Font_Icon_Kind]rl.Texture2D

split_font_string_into_tokens :: proc(str: string) -> []Text_Token {
    arr := make([dynamic]Text_Token, context.temp_allocator)

    text_string := str
    run_length := 0

    for i := 0; i < len(str); i += 1 {
		if str[i] == '[' {
			if run_length > 0 {
				append(&arr, text_string[:run_length])
                run_length = 0
			}

            i += 1
            icon_name := str[i:]
            icon_name_length := 0
			for ; i < len(str) && str[i] != ']'; i += 1 {
                icon_name_length += 1
            }
			if i >= len(str) || str[i] != ']' {
				fmt.println("Unterminated bracket in font icon string!!!", str)
                return {}
			}

            icon_name = icon_name[:icon_name_length]
            icon_name_tokens := strings.split(icon_name, ":", context.temp_allocator)
            icon_number: Maybe(string) = nil
            if len(icon_name_tokens) > 1 {
                icon_number = icon_name_tokens[1]
            } 
            icon_enum, ok := reflect.enum_from_name(Font_Icon_Kind, icon_name_tokens[0])
            if !ok {
                fmt.println("Unknown icon name: ", icon_name)
                return {}
            }
            append(&arr, Icon_Token{icon_enum, icon_number})
			text_string = str[i+1:]
		} else {
			run_length += 1
		}
	}
	if run_length > 0 {
		append(&arr, text_string[:run_length])
	}
    return arr[:]
}

WIDTH :: 1000
HEIGHT :: 1400

GRAPH_WINDOW_SIZE :: Vec2{1000, 1000}

main :: proc() {

    cards_bytes, _ := os.read_entire_file("cards.csv", context.allocator)
    cards_string := string(cards_bytes)
    
    min_memory_size := clay.MinMemorySize()
    memory := make([^]u8, min_memory_size)
    arena: clay.Arena = clay.CreateArenaWithCapacityAndMemory(uint(min_memory_size), memory)
    clay.Initialize(arena, {WIDTH, HEIGHT}, {})
    clay.SetMeasureTextFunction(measure_text, nil)

    switch mode {
    case .Card_Beeg:
        rl.InitWindow(WIDTH, HEIGHT, "Card")
    case .Card_Smol:
        rl.InitWindow(WIDTH / 2, HEIGHT / 2, "Card")
    case .Graph:
        rl.InitWindow(i32(GRAPH_WINDOW_SIZE.x), i32(GRAPH_WINDOW_SIZE.y), "Card")
    }

    main_texture := rl.LoadRenderTexture(1000, 1400)

    for dir_file in font_icons {
        image := rl.LoadImageFromMemory(".png", raw_data(dir_file.data), i32(len(dir_file.data)))
        texture := rl.LoadTextureFromImage(image)
        prefix := strings.to_ada_case(strings.split(dir_file.name, ".", context.temp_allocator)[0], context.temp_allocator)
        enum_value, ok := reflect.enum_from_name(Font_Icon_Kind, prefix)
        if !ok {
            fmt.println("Unable to parse enum name!", prefix)
        } else {
            font_icon_images[enum_value] = texture
        }
    }

    regular_font := rl.LoadFontEx("assets/NotoSans-Regular.ttf", 200, nil, 0)
    italic_font := rl.LoadFontEx("assets/NotoSans-LightItalic.ttf", 200, nil, 0)
    semibold_font := rl.LoadFontEx("assets/NotoSans-SemiBold.ttf", 200, nil, 0)
    append(&raylib_fonts, Raylib_Font{u16(Font_ID.Default), regular_font})
    append(&raylib_fonts, Raylib_Font{u16(Font_ID.Italic), italic_font})
    append(&raylib_fonts, Raylib_Font{u16(Font_ID.Bold), semibold_font})

    card_index: int = len(cards) - 1

    for !rl.WindowShouldClose() {

        the_card := cards[card_index]

        set_mode_smol :: proc() {
            mode = .Card_Smol
            rl.SetWindowSize(WIDTH / 2, HEIGHT / 2)
        }

        set_mode_beeg :: proc() {
            mode = .Card_Beeg
            rl.SetWindowSize(WIDTH, HEIGHT)
        }

        set_mode_graph :: proc() {
            mode = .Graph
            rl.SetWindowSize(i32(GRAPH_WINDOW_SIZE.x), i32(GRAPH_WINDOW_SIZE.y))
        }

        for key := rl.GetKeyPressed(); key != .KEY_NULL; key = rl.GetKeyPressed() {
            #partial switch key {
            case .SPACE:
                if mode == .Card_Beeg || mode == .Card_Smol {
                    image := rl.LoadImageFromTexture(main_texture.texture)
                    rl.ImageFlipVertical(&image)
                    rl.ExportImage(image, fmt.ctprintf("output/%v.png", strings.to_snake_case(the_card.name)))
                }
            case .LEFT:
                if (mode == .Card_Beeg || mode == .Card_Smol) && card_index > 0 {
                    card_index -= 1
                }
            case .RIGHT:
                if (mode == .Card_Beeg || mode == .Card_Smol) && card_index < len(cards) - 1 {
                    card_index += 1
                }
            case .MINUS:
                if mode != .Card_Smol {
                    set_mode_smol()
                }
            case .EQUAL:
                if mode != .Card_Beeg {
                    set_mode_beeg()
                }
            case .G:
                if mode != .Graph {
                    set_mode_graph()
                }
            }
        }

        clay.BeginLayout()

        card_layout(the_card)

        commands := clay.EndLayout()

        rl.BeginDrawing(); {
            defer rl.EndDrawing()

            rl.BeginTextureMode(main_texture); {
                defer rl.EndTextureMode()

                rl.ClearBackground(rl.WHITE)

                clay_raylib_render(&commands)
            }

            rl.ClearBackground(rl.MAGENTA)

            switch mode {
            case .Card_Beeg, .Card_Smol:
                dest_rect: rl.Rectangle = {0, 0, WIDTH / 2, HEIGHT / 2} if mode == .Card_Smol else {0, 0, WIDTH, HEIGHT}
                rl.SetTextureFilter(main_texture.texture, .BILINEAR)
                rl.DrawTexturePro(main_texture.texture, {0, 0, 1000, -1400}, dest_rect, {}, 0, rl.WHITE)
            case .Graph:
                graph_origin := Vec2{100, 900}
                rl.ClearBackground(rl.WHITE)
                rl.DrawCircleV(graph_origin, 4, rl.BLACK)
                rl.DrawLineV({graph_origin.x, 0}, graph_origin, rl.BLACK)
                rl.DrawLineV(graph_origin, {1000, graph_origin.y}, rl.BLACK)
                graph_increment: f32 = 50

                transform_pos :: proc(stats: Vec2, graph_origin: Vec2, graph_increment: f32) -> Vec2{
                    return stats * graph_increment * {1, -1} + graph_origin
                }
                for card in cards {
                    if card.max_hp == 0 do continue
                    pos := transform_pos(Vec2{f32(card.weight), f32(card.max_hp)} + {1, 1}, graph_origin, graph_increment)
                    rl.DrawCircleV(pos, 5, rl.RED)
                }

                for i in 0..=15 {
                    pos1 := transform_pos(Vec2{f32(i), 0}, graph_origin, graph_increment)
                    pos2 := transform_pos(Vec2{0, f32(i)}, graph_origin, graph_increment)
                    rl.DrawCircleV(pos1, 5, rl.BLACK)
                    rl.DrawCircleV(pos2, 5, rl.BLACK)
                }
            }
        }
        

        free_all(context.temp_allocator)
    }

    rl.CloseWindow()


}