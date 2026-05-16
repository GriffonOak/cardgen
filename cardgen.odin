package cardgen

import clay "clay-odin"
import rl "vendor:raylib"
import "base:runtime"
import "core:strings"
import "core:reflect"
import "core:os"
import "core:fmt"
import "core:encoding/csv"

_ :: runtime
_ :: strings

Vec2 :: [2]f32

Size :: enum {
    Beeg,
    Smol,
}

size: Size = .Smol

Font_ID :: enum {
    Default,
}

card_fonts: [Font_ID]rl.Font

Slot_Kind :: enum {
    Head,
    Torso,
    Hand,
    Legs,
    Mod,
}

Font_Icon_Kind :: enum {
    Weight,
    HP,
    Energy,
    Damage,
}

Text_Token :: union {
    string,
    Font_Icon_Kind,
}

Card_Ability_Kind :: enum {
    Attack,
    Movement,
    Utility,
    Passive,
}

card_ability_background_colors := #partial [Card_Ability_Kind]clay.Color {
    .Attack = {230, 160, 150, 255}
}

Targeting_Kind :: enum {
    Self,
    Adjacent,
    Surrounding,
    Straight,
    Ranged,
}

Card_Ability_Targeting :: struct {
    kind: Targeting_Kind,
    range: int,
    precision: int,
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
    kind: Card_Ability_Kind,
    timing: Card_Ability_Timing,
    targeting: Card_Ability_Targeting,
}

Card :: struct {
    name: string,
    slots: []Slot_Kind,
    weight, max_hp, price: int,
    abilities: []Card_Ability,
    flavour: string,
}

big_gun_card := Card {
    name = "Big Gun",
    slots = {.Hand},
    weight = 8,
    max_hp = 6,
    abilities = {
        {
            name = "Shoot",
            text = "2[Energy] => 1[Damage] => 3[Energy] + 2[Energy]",
            // text = "2 Energy => 1 Damage",
            kind = .Attack,
            timing = .Phase_2,
            targeting = {
                kind = .Straight,
                range = 6,
            }
        },
    },
    // flavour = "Spray and pray."
}



slot_icons := #load_directory("assets/slot_icons")
font_icons := #load_directory("assets/font_icons")

slot_images: [Slot_Kind]rl.Texture2D

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
			for ; str[i] != ']' && i < len(str); i += 1 {
                icon_name_length += 1
            }
			if str[i] != ']' {
				fmt.println("Unterminated bracket in font icon string!!!")
                return {}
			}

            icon_name = icon_name[:icon_name_length]
            icon_enum, ok := reflect.enum_from_name(Font_Icon_Kind, icon_name)
            if !ok {
                fmt.println("Unknown icon name: ", icon_name)
                return {}
            }
            append(&arr, icon_enum)
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

main :: proc() {

    fmt.println(split_font_string_into_tokens(big_gun_card.abilities[0].text))

    cards_bytes, _ := os.read_entire_file("cards.csv", context.allocator)
    cards_string := string(cards_bytes)
    
    records, _ := csv.read_all_from_string(cards_string)

    min_memory_size := clay.MinMemorySize()
    memory := make([^]u8, min_memory_size)
    arena: clay.Arena = clay.CreateArenaWithCapacityAndMemory(uint(min_memory_size), memory)
    clay.Initialize(arena, {1000, 1400}, {})
    clay.SetMeasureTextFunction(measure_text, nil)

    if size == .Beeg {
        rl.InitWindow(1000, 1400, "Card")
    } else {
        rl.InitWindow(500, 700, "Card")
    }

    main_texture := rl.LoadRenderTexture(1000, 1400)

    for dir_file in slot_icons {
        image := rl.LoadImageFromMemory(".png", raw_data(dir_file.data), i32(len(dir_file.data)))
        texture := rl.LoadTextureFromImage(image)
        switch dir_file.name {
        case "hand.png": slot_images[.Hand] = texture
        case "head.png": slot_images[.Head] = texture
        case "legs.png": slot_images[.Legs] = texture
        case "mod.png": slot_images[.Mod] = texture
        case "torso.png": slot_images[.Torso] = texture
        }
    }

    for dir_file in font_icons {
        image := rl.LoadImageFromMemory(".png", raw_data(dir_file.data), i32(len(dir_file.data)))
        texture := rl.LoadTextureFromImage(image)
        switch dir_file.name {
        case "weight.png": font_icon_images[.Weight] = texture
        case "HP.png": font_icon_images[.HP] = texture
        case "energy.png": font_icon_images[.Energy] = texture
        case "damage.png": font_icon_images[.Damage] = texture
        }
    }

    font := rl.LoadFontEx("NotoSans-Regular.ttf", 200, nil, 0)
    append(&raylib_fonts, Raylib_Font{0, font})

    toggle: bool

    for !rl.WindowShouldClose() {

        if rl.IsKeyPressed(.SPACE) {
            toggle = !toggle
            fmt.println("pressed")
        }

        clay.BeginLayout()

        card_layout(big_gun_card)

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