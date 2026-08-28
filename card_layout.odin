package cardgen

import clay "clay-odin"
import "core:fmt"
import "core:reflect"
import "core:strings"

CARD_DEFAULT_BACKGROUND_COLOR :: clay.Color{250, 250, 250, 255}
CARD_BAR_BACKGROUND_COLOR :: clay.Color{180, 180, 180, 255}
CARD_BAR_PADDING :: 20
CARD_BAR_BOUNDARY_HEIGHT :: 10
CARD_BAR_BOUNDARY_COLOR :: clay.Color{100, 100, 100, 255}
CARD_BAR_ICON_SIZE :: 140
CARD_BAR_SECONDARY_ICON_SIZE :: 120
CARD_BAR_TITLE_FONT_SIZE :: 80
CARD_BAR_ICON_FONT_SIZE :: 100
CARD_BAR_WEIGHT_BACKGROUND_COLOR :: clay.Color{100, 100, 100, 255}

CARD_ABILITY_REGION_PADDING :: 20

ABILITY_MIN_HEIGHT :: 150
ABILITY_PADDING_VERTICAL :: 20
ABILITY_PADDING_HORIZONTAL :: 30
ABILITY_CHILD_GAP :: 10
ABILITY_BORDER_WIDTH :: 10
ABILITY_FONT_SIZE :: 75
ABILITY_REMINDER_FONT_SIZE :: 60

Custom_Data :: union {
    Card_Ability_Kind,
}

clay_corner_aligner :: proc(alignment: clay.LayoutAlignmentY) -> clay.ElementDeclaration {
    return {
        layout = {
            sizing = {
                clay.SizingFit(),
                clay.SizingGrow(),
            },
            childAlignment = {
                y = alignment,
            },
        },
    }
}

clay_card_ability :: proc(ability: Card_Ability) {
    background_color := card_ability_background_colors[ability.kind]
    alt_color := background_color * {0.5, 0.5, 0.5, 1}
    custom_data: ^Custom_Data
    if ability.kind == .Attack || ability.kind == .Passive {
        custom_data = new(Custom_Data, context.temp_allocator)
        custom_data^ = ability.kind
    }
    border: clay.BorderElementConfig
    if ability.kind != .Attack && ability.kind != .Passive {
        border = {
            width = clay.BorderOutside(ABILITY_BORDER_WIDTH),
            color = alt_color,
        }
    }
    corner_radius := clay.CornerRadiusAll(ABILITY_MIN_HEIGHT / 2) if ability.kind == .Movement else {}

    if clay.UI()({
        layout = {
            sizing = {
                clay.SizingGrow(),
                clay.SizingFit({min = ABILITY_MIN_HEIGHT}),
                // clay.SizingFit(),
            },
            childAlignment = {
                x = .Center,
                y = .Center,
            },
            layoutDirection = .TopToBottom,
            padding = clay.Padding {
                top = ABILITY_PADDING_VERTICAL,
                bottom = ABILITY_PADDING_VERTICAL,
                left = ABILITY_PADDING_HORIZONTAL,
                right = ABILITY_PADDING_HORIZONTAL,
            },
            childGap = ABILITY_CHILD_GAP,
        },
        border = border,
        custom = { custom_data },
        cornerRadius = corner_radius,
        backgroundColor = card_ability_background_colors[ability.kind],
    }) {
        ability_text_config := clay.TextConfig({
            fontId = 0,
            fontSize = ABILITY_FONT_SIZE,
            textColor = {0, 0, 0, 255},
        })

        spacer_width: f32 = 0

        if clay.UI()({
            layout = {
                childAlignment = {
                    x = .Center,
                    y = .Center,
                },
                childGap = ABILITY_CHILD_GAP,
            },
            floating = {
                attachTo = .Parent,
                attachment = {
                    element = .LeftCenter,
                    parent = .LeftCenter,
                },
                offset = {
                    ABILITY_PADDING_HORIZONTAL, 0,
                }
            },
        }){
            // Timing
            if ability.timing != .None {
                timing_text := fmt.tprintf("[%v]", ability.timing)
                clay.TextDynamic(timing_text, ability_text_config)
                spacer_width += measure_text_string(timing_text, ability_text_config, nil).width
            }
    
            // Targeting
            if len(ability.targeting) > 0 {
                builder := strings.builder_make(context.temp_allocator)
                for targeting, i in ability.targeting {
                    if i != 0 do fmt.sbprintf(&builder, "/")
                    fmt.sbprintf(&builder, "[Targeting_%v", targeting.kind)
                    if targeting.range > 0 do fmt.sbprintf(&builder, ":%v", targeting.range)
                    fmt.sbprintf(&builder, "]")
                }
                if strings.builder_len(builder) > 0 {
                    fmt.sbprint(&builder, " ")
                }
                targeting_text := strings.to_string(builder)
                clay.TextDynamic(targeting_text, ability_text_config)
                if spacer_width > 0 do spacer_width += ABILITY_CHILD_GAP
                spacer_width += measure_text_string(targeting_text, ability_text_config, nil).width
            }
    
            // Precision
            if ability.precision != 0 {
                precision_text := fmt.tprintf("[Precision:%v]", ability.precision)
                clay.TextDynamic(precision_text, ability_text_config)
                if spacer_width > 0 do spacer_width += ABILITY_CHILD_GAP
                spacer_width += measure_text_string(precision_text, ability_text_config, nil).width
            }
        }


        if clay.UI ()({
            layout = {
                sizing = {
                    clay.SizingGrow(),
                    clay.SizingFit(),
                },
                childAlignment = {
                    x = .Center,
                    y = .Center,
                },
                childGap = ABILITY_CHILD_GAP,
            },
        }) {

            if clay.UI()({
                layout = {sizing = {width = clay.SizingFixed(spacer_width)}},
            }) {}


            // Growing spacer 1
            if clay.UI()({
                layout = {sizing = {width = clay.SizingGrow()}},
            }) {}

            // Sanity Check
            terms := strings.split(ability.text, "=>", context.temp_allocator)
            if len(terms) > 2 {
                fmt.println("Improperly formatted card ability!")
            }
            for &term in terms {
                term = strings.trim_space(term)
            }
            lines: []string
            if len(terms) > 1 {
                lines = strings.split(terms[1], "|")
            }
            // once_per_round := false
            // if strings.ends_with(terms[0], "1") {
            //     terms[0] = terms[0][:len(terms[0])-2]
            //     once_per_round = true
            // }

            // Ability Terms

            if clay.UI()({
                layout = {
                    layoutDirection = .TopToBottom,
                    childAlignment = {
                        x = .Center,
                    },
                },
            }) {
                if clay.UI()({
                    layout = {
                        childAlignment = {
                            y = .Center,
                        },
                        childGap = ABILITY_CHILD_GAP,
                    },
                }) {
                    clay.TextDynamic(fmt.tprintf("%v ", terms[0]), ability_text_config)
                    if len(terms) > 1 {
                        clay.Text("=> ", ability_text_config)
                    }
                    if len(lines) > 0 {
                        clay.TextDynamic(lines[0], clay.TextConfig({
                            fontId = 0,
                            fontSize = ABILITY_FONT_SIZE,
                            textColor = {0, 0, 0, 255},
                        }))
                    }
                }
                // Basically if the ability text is long we put the output on a new line. Maybe this could be cleaned up somehow.
                if len(lines) > 1 do for line in lines[1:] {
                    clay.TextDynamic(line, clay.TextConfig({
                        fontId = 0,
                        fontSize = ABILITY_FONT_SIZE,
                        textColor = {0, 0, 0, 255},
                    }))
                }
            }
            if clay.UI()({
                layout = {sizing = {width = clay.SizingGrow()}},
            }) {}
        }
        if ability.reminder != "" {
            clay.TextDynamic(ability.reminder, clay.TextConfig({
                fontId = u16(Font_ID.Italic),
                fontSize = ABILITY_REMINDER_FONT_SIZE,
                textColor = {0, 0, 0, 255},
            }))
            // clay.TextDynamic(" I", clay.TextConfig({
            //     fontId = u16(Font_ID.Italic),
            //     fontSize = ABILITY_REMINDER_FONT_SIZE,
            //     textColor = {0, 0, 0, 255},
            // }))
        }

    }
}

clay_card_bar_boundary :: proc() {
    if clay.UI()({
        layout = {
            sizing = {
                clay.SizingGrow(),
                clay.SizingFixed(CARD_BAR_BOUNDARY_HEIGHT),
            },
        },
        backgroundColor = CARD_BAR_BOUNDARY_COLOR,
    }) {}
}

clay_card_weight_icon :: proc(weight: int) {
    if clay.UI()({  // Weight icon & number
        layout = {
            sizing = {
                clay.SizingFit(),
                clay.SizingFit(),
            },
            padding = clay.PaddingAll(CARD_BAR_PADDING),
            childAlignment = {
                y = .Center,
            },
        },
        backgroundColor = CARD_BAR_WEIGHT_BACKGROUND_COLOR,
        cornerRadius = clay.CornerRadiusAll(CARD_BAR_ICON_SIZE / 2),
    }) {
        if clay.UI()({
            layout = {
                sizing = {
                    clay.SizingFixed(CARD_BAR_ICON_FONT_SIZE),
                    clay.SizingFixed(CARD_BAR_ICON_FONT_SIZE),
                },
            },
            image = {
                &font_icon_images[.Weight],
            },
        }) {}
        clay.TextDynamic(fmt.tprintf("%d", weight), clay.TextConfig({
            fontId = 0,
            fontSize = CARD_BAR_ICON_FONT_SIZE,
            textColor = {0, 0, 0, 255},
        }))
    }
}

clay_card_price_icon :: proc(price: int) {
    if clay.UI() ({  // Price
        layout = {
            sizing = {
                clay.SizingFit({min = CARD_BAR_ICON_SIZE}),
                clay.SizingFixed(CARD_BAR_ICON_SIZE),
            },
            childAlignment = {
                x = .Center, y = .Center,
            },
            padding = clay.PaddingAll(CARD_BAR_PADDING),
        },
        cornerRadius = clay.CornerRadiusAll(CARD_BAR_ICON_SIZE / 2),
        // backgroundColor = {0, 80, 20, 255},
    }) {
        // clay.TextDynamic(fmt.tprintf("$%d", price), clay.TextConfig({
        //     fontId = 0,
        //     fontSize = CARD_BAR_ICON_FONT_SIZE,
        //     textColor = {255, 255, 255, 255},
        // }))
    }
}

clay_card_hp_icon :: proc(max_hp: int) {
    if clay.UI()({
        layout = {
            sizing = {
                clay.SizingFixed(CARD_BAR_ICON_SIZE), clay.SizingFixed(CARD_BAR_ICON_SIZE),
            },
            childAlignment = {
                x = .Center, 
                y = .Center,
            },
        },
        image = {
            &font_icon_images[.Hp],
        },
    }) {
        clay.TextDynamic(fmt.tprintf("%d", max_hp), clay.TextConfig({
            fontId = 0,
            fontSize = CARD_BAR_ICON_FONT_SIZE,
            textColor = {0, 0, 0, 255},
        }))
    }
}

card_layout :: proc(card: Card) {
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
            layoutDirection = .TopToBottom,
        },
        backgroundColor = CARD_DEFAULT_BACKGROUND_COLOR,
    }) {
        if clay.UI()({  // Top Bar
            layout = {
                sizing = {
                    clay.SizingGrow(),
                    clay.SizingFit(),
                },
                childAlignment = {y = .Center},
                // childGap = CARD_BAR_PADDING,
                padding = clay.PaddingAll(CARD_BAR_PADDING),
            },
            backgroundColor = CARD_BAR_BACKGROUND_COLOR,
        }) {
            if clay.UI()(clay_corner_aligner(.Top)) {
                if clay.UI()({
                    layout = {
                        childAlignment = {
                            y = .Center,
                        },
                    },
                }) {
                    for slot_kind, i  in card.slots {  // Slot Icons
                        font_icon_name := fmt.tprintf("Slot_%v", slot_kind)
                        font_icon, _ := reflect.enum_from_name(Font_Icon_Kind, font_icon_name)
                        size: f32 = CARD_BAR_ICON_SIZE if i == 0 else CARD_BAR_SECONDARY_ICON_SIZE
                        if i != 0 {
                            if clay.UI()({
                                layout = {
                                    sizing = {
                                        width = clay.SizingFixed(CARD_BAR_PADDING),
                                    },
                                },
                            }) {}
                        }
                        if clay.UI()({
                            layout = {
                                sizing = {
                                    clay.SizingFixed(size),
                                    clay.SizingFixed(size),
                                },
                            },
                            image = {
                                &font_icon_images[font_icon],
                            },
                        }) {}
                    }
                }
            }
            if clay.UI()({  // Spacer
                layout = {
                    sizing = {clay.SizingGrow(), clay.SizingFit()},
                    childAlignment = {
                        x = .Center, 
                        y = .Center,
                    },
                },
            }) {

            // }
            // if clay.UI()({  // Centred Title
            //     floating = {
            //         attachTo = .Parent,
            //         attachment = {
            //             element = .CenterCenter,
            //             parent = .CenterCenter,
            //         },
            //     },
            // }) {
                clay.TextDynamic(card.name, clay.TextConfig({
                    fontId = 0,
                    fontSize = CARD_BAR_TITLE_FONT_SIZE,
                    textColor = {0, 0, 0, 255},
                }))
            }
            // card_weight_icon(card.weight)
            if card.max_hp > 0 {
                if clay.UI()(clay_corner_aligner(.Top)) {
                    clay_card_hp_icon(card.max_hp)
                }
            }
        }
        clay_card_bar_boundary()
        if clay.UI()({
            layout = {
                sizing = {
                    clay.SizingGrow(),
                    clay.SizingGrow(),
                },
                childAlignment = {
                    x = .Center,
                    y = .Bottom,
                },
                layoutDirection = .TopToBottom,
                padding = clay.PaddingAll(CARD_ABILITY_REGION_PADDING),
                childGap = CARD_ABILITY_REGION_PADDING,
            },
        }) {
            for ability in card.abilities {
                clay_card_ability(ability)
            }
        }
        clay_card_bar_boundary()
        if clay.UI()({  // Bottom bar
            layout = {
                sizing = {
                    clay.SizingGrow(),
                    clay.SizingFit(),
                },
                padding = clay.PaddingAll(CARD_BAR_PADDING),
                childAlignment = {y = .Center},
                layoutDirection = .LeftToRight,
            },
            backgroundColor = CARD_BAR_BACKGROUND_COLOR,
        }) {
            if card.price != 0 {
                if clay.UI()(clay_corner_aligner(.Bottom)) {
                    clay_card_price_icon(card.price)
                }
            }
            if clay.UI()({  // Bottom bar spacer
                layout = {
                    sizing = {
                        clay.SizingGrow(),
                        clay.SizingFit(),
                    },
                    childAlignment = {
                        x = .Center,
                        y = .Center,
                    },
                },
            }) {
                clay.TextDynamic(card.flavour, clay.TextConfig({
                    fontId = 1,
                    fontSize = 55,
                    textColor = {0, 0, 0, 255},
                }))
            }
            // card_hp_icon(card.max_hp)
            if clay.UI()(clay_corner_aligner(.Bottom)) {
                clay_card_weight_icon(card.weight)
            }
        }
    }
}