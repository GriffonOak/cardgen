package cardgen

import clay "clay-odin"
import rl "vendor:raylib"
import "base:runtime"
import "core:strings"
import "core:os"
import "core:fmt"
import "core:encoding/csv"

_ :: runtime
_ :: strings


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

Card_Ability :: struct {
    name: string,
    text: string,
    kind: Card_Ability_Kind,
}

Card :: struct {
    name: string,
    slots: []Slot_Kind,
    weight, max_hp: int,
    abilities: []Card_Ability,
}

big_gun_card := Card {
    name = "Big Gun",
    slots = {.Hand},
    weight = 8,
    max_hp = 6,
    abilities = {
        Card_Ability {
            text = "2[Energy] => 1[Damage]",
        },
    },
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

main :: proc() {

    cards_bytes, _ := os.read_entire_file("cards.csv", context.allocator)
    cards_string := string(cards_bytes)
    fmt.println(cards_string)
    
    records, _ := csv.read_all_from_string(cards_string)
    fmt.println(records[1])

    min_memory_size := clay.MinMemorySize()
    memory := make([^]u8, min_memory_size)
    arena: clay.Arena = clay.CreateArenaWithCapacityAndMemory(uint(min_memory_size), memory)
    clay.Initialize(arena, {1000, 1400}, {})
    clay.SetMeasureTextFunction(measure_text, nil)

    rl.InitWindow(1000, 1400, "Card")

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
        }
    }

    // text_string: cstring = "Big Gun ->→😭"
    // count: i32
    // codepoints := rl.LoadCodepoints(text_string, &count)

    font := rl.LoadFontEx("NotoSans-Regular.ttf", 200, nil, 0)
    append(&raylib_fonts, Raylib_Font{0, font})

    toggle: bool

    the_card := big_gun_card

    for !rl.WindowShouldClose() {

        if rl.IsKeyPressed(.SPACE) {
            toggle = !toggle
            fmt.println("pressed")
        }

        clay.BeginLayout()

        if clay.UI()({
            layout = {
                sizing = {
                    clay.SizingGrow(),
                    clay.SizingGrow(),
                },
                childAlignment = {
                    x = .Center,
                    y = .Top,
                },
                padding = clay.PaddingAll(10),
                childGap = 10,
                layoutDirection = .TopToBottom,
            },
            backgroundColor = {255, 255, 255, 255},
        }) {
            if clay.UI()({
                layout = {
                    sizing = {
                        clay.SizingGrow(),
                        clay.SizingFixed(160),
                    },
                    childAlignment = {
                        x = .Center,
                        y = .Center,
                    },
                },
                cornerRadius = clay.CornerRadiusAll(90),
                backgroundColor = {180, 180, 180, 255},
            }) {
                if clay.UI()({  // Slot Icon
                    layout = {
                        padding = clay.PaddingAll(20)
                    },
                    floating = {
                        attachTo = .Parent,
                        attachment = {
                            element = .LeftCenter,
                            parent = .LeftCenter,
                        },
                    },
                }) {
                    if clay.UI()({
                        layout = {
                            sizing = { clay.SizingFixed(120), clay.SizingFixed(120) },
                        },
                        image = {
                            &slot_images[the_card.slots[0]],
                        },
                    }) {}
                }
                clay.TextDynamic(the_card.name, clay.TextConfig({
                    fontId = 0,
                    fontSize = 125,
                    textColor = {0, 0, 0, 255},
                }))
                if clay.UI()({  // Weight icon & number
                    layout = {
                        padding = {
                            left = 20,
                            top = 20,
                            right = 20,
                            bottom = 20,
                        },
                        childAlignment = {
                            y = .Center,
                        },
                    },
                    border = {
                        color = {0, 0, 0, 255},
                        width = {
                            right = 10 if toggle else 0,
                            bottom = 10 if toggle else 0,
                        },
                    },
                    floating = {
                        attachTo = .Parent,
                        attachment = {
                            element = .RightCenter,
                            parent = .RightCenter,
                        },
                        offset = {-20, 0},
                    },
                }) {
                    if clay.UI()({
                        layout = {
                            sizing = { clay.SizingFixed(100), clay.SizingFixed(100) },
                        },
                        image = {
                            &font_icon_images[.Weight],
                        },
                    }) {}
                    clay.TextDynamic(fmt.tprintf("%d", the_card.weight), clay.TextConfig({
                        fontId = 0,
                        fontSize = 120,
                        textColor = {0, 0, 0, 255},
                    }))
                }
            }
            if clay.UI()({
                layout = {
                    sizing = {
                        clay.SizingGrow(),
                        clay.SizingGrow(),
                    },
                },
            }) {}
            for ability in the_card.abilities {
                if clay.UI()({
                    layout = {
                        sizing = {
                            clay.SizingGrow(),
                            clay.SizingFit({min = 200}),
                        },
                        childAlignment = {
                            x = .Center,
                            y = .Center,
                        },
                    },
                    backgroundColor = card_ability_background_colors[ability.kind],
                }) {
                    clay.TextDynamic(ability.text, clay.TextConfig({
                        fontId = 0,
                        fontSize = 80,
                        textColor = {0, 0, 0, 255},
                    }))
                }
            }
        }

        commands := clay.EndLayout()

        rl.BeginDrawing()

        rl.ClearBackground(rl.MAGENTA)

        // rl.BeginTextureMode(texture)

        rl.ClearBackground(rl.WHITE)

        clay_raylib_render(&commands)

        // rl.DrawLineEx({20, 20}, {20, 20 + 128}, 5, rl.MAGENTA)

        // rl.EndTextureMode()

        // rl.DrawTexturePro(texture.texture, {0, 0, 125, -175}, {0, 0, 1000, 1400}, {}, 0, rl.WHITE)

        rl.EndDrawing()

        free_all(context.temp_allocator)
    }

    rl.CloseWindow()


}