package cardgen

import clay "clay-odin"
import "core:fmt"

card_layout :: proc(the_card: Card) {
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
}