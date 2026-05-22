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

Size :: enum {
    Beeg,
    Smol,
}

size: Size = .Smol

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

// measure_text :: proc "c" (
//     text: clay.StringSlice,
//     config: ^clay.TextElementConfig,
//     userData: rawptr,
// ) -> clay.Dimensions {
//     // clay.TextElementConfig contains members such as fontId, fontSize, letterSpacing, etc..
//     // Note: clay.String->chars is not guaranteed to be null terminated
//     // return {
//     //     width = f32(text.length * i32(config.fontSize)),
//     //     height = f32(config.fontSize),
//     // }

//     context = runtime.default_context()

//     text_string := strings.string_from_ptr(text.chars, int(text.length))
//     text_cstring := strings.clone_to_cstring(text_string, context.temp_allocator)
//     text_font_size := f32(config.fontSize)
//     text_spacing := f32(config.letterSpacing)
//     font := card_fonts[Font_ID(config.fontId)]

//     return transmute(clay.Dimensions) rl.MeasureTextEx(font, text_cstring, text_font_size, text_spacing)
// }

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

main :: proc() {

    cards_bytes, _ := os.read_entire_file("cards.csv", context.allocator)
    cards_string := string(cards_bytes)
    
    // _, _ := csv.read_all_from_string(cards_string)

    min_memory_size := clay.MinMemorySize()
    memory := make([^]u8, min_memory_size)
    arena: clay.Arena = clay.CreateArenaWithCapacityAndMemory(uint(min_memory_size), memory)
    clay.Initialize(arena, {WIDTH, HEIGHT}, {})
    clay.SetMeasureTextFunction(measure_text, nil)

    if size == .Beeg {
        rl.InitWindow(WIDTH, HEIGHT, "Card")
    } else {
        rl.InitWindow(WIDTH / 2, HEIGHT / 2, "Card")
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
        // switch dir_file.name {
        // case "weight.png": font_icon_images[.Weight] = texture
        // case "HP.png": font_icon_images[.HP] = texture
        // case "energy.png": font_icon_images[.Energy] = texture
        // case "damage.png": font_icon_images[.Damage] = texture
        // }
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

        if rl.IsKeyPressed(.SPACE) {
            image := rl.LoadImageFromTexture(main_texture.texture)
            rl.ImageFlipVertical(&image)
            rl.ExportImage(image, fmt.ctprintf("output/%v.png", strings.to_snake_case(the_card.name)))
        }
        if rl.IsKeyPressed(.LEFT) && card_index > 0 {
            card_index -= 1
        }
        if rl.IsKeyPressed(.RIGHT) && card_index < len(cards) - 1 {
            card_index += 1
        }

        clay.BeginLayout()

        card_layout(the_card)

        commands := clay.EndLayout()

        rl.BeginDrawing(); {
            defer rl.EndDrawing()

            rl.ClearBackground(rl.MAGENTA)

            rl.BeginTextureMode(main_texture); {
                defer rl.EndTextureMode()

                rl.ClearBackground(rl.WHITE)

                clay_raylib_render(&commands)
            }

            dest_rect: rl.Rectangle = {0, 0, 500, 700} if size == .Smol else {0, 0, 1000, 1400}
            rl.SetTextureFilter(main_texture.texture, .BILINEAR)
            rl.DrawTexturePro(main_texture.texture, {0, 0, 1000, -1400}, dest_rect, {}, 0, rl.WHITE)
        }

        free_all(context.temp_allocator)
    }

    rl.CloseWindow()


}