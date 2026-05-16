package cardgen

import clay "clay-odin"
import "core:fmt"

clay_ability :: proc(ability: Card_Ability) {
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
        cornerRadius = clay.CornerRadiusAll(10),
        backgroundColor = card_ability_background_colors[ability.kind],
    }) {
        clay.TextDynamic(ability.text, clay.TextConfig({
            fontId = 0,
            fontSize = 80,
            textColor = {0, 0, 0, 255},
        }))
    }
}

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
        backgroundColor = {150, 130, 150, 255},
    }) {
        if clay.UI()({  // Top Bar
            layout = {
                sizing = {
                    clay.SizingGrow(),
                    clay.SizingFit(),
                },
                childAlignment = {
                    y = .Center,
                },
                padding = clay.PaddingAll(20),
                layoutDirection = .LeftToRight,
            },
            cornerRadius = clay.CornerRadiusAll(90),
            backgroundColor = {180, 180, 180, 255},
        }) {
            if clay.UI()({  // Slot Icon
                layout = {
                    sizing = { clay.SizingFixed(140), clay.SizingFixed(140) },
                },
                image = {
                    &slot_images[the_card.slots[0]],
                },
            }) {}
            if clay.UI()({  // Spacer
                layout = {
                    sizing = {clay.SizingGrow(), clay.SizingFit()}
                }
            }) {}
            if clay.UI()({  // Centred Title
                floating = {
                    attachTo = .Parent,
                    attachment = {
                        element = .CenterCenter,
                        parent = .CenterCenter,
                    },
                },
            }) {
                clay.TextDynamic(the_card.name, clay.TextConfig({
                    fontId = 0,
                    fontSize = 100,
                    textColor = {0, 0, 0, 255},
                }))
            }
            if clay.UI()({  // Weight icon & number
                layout = {
                    sizing = {
                        clay.SizingFit(),
                        clay.SizingGrow(),
                    },
                    padding = clay.PaddingAll(20),
                    childAlignment = {
                        y = .Center,
                    },
                },
                backgroundColor = {120, 120, 120, 255},
                cornerRadius = clay.CornerRadiusAll(100),
            }) {
                if clay.UI()({
                    layout = {
                        sizing = { clay.SizingFixed(80), clay.SizingFixed(80) },
                    },
                    image = {
                        &font_icon_images[.Weight],
                    },
                }) {}
                clay.TextDynamic(fmt.tprintf("%d", the_card.weight), clay.TextConfig({
                    fontId = 0,
                    fontSize = 90,
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
            clay_ability(ability)
        }
        if clay.UI()({  // Bottom bar
            layout = {
                sizing = {
                    clay.SizingGrow(),
                    clay.SizingFit(),
                },
                childAlignment = {y = .Center},
                layoutDirection = .LeftToRight,
            },
        }) {
            if clay.UI() ({
                layout = {
                    padding = clay.PaddingAll(20),
                    childAlignment = {
                        x = .Center, y = .Center,
                    }
                },
                cornerRadius = clay.CornerRadiusAll(100),
                backgroundColor = {200, 255, 200, 255},
            }) {
                clay.TextDynamic(fmt.tprintf("$%d", the_card.price), clay.TextConfig({
                    fontId = 0,
                    fontSize = 100,
                    textColor = {0, 0, 0, 255},
                }))
            }
            if clay.UI()({  // Bottom bar spacer
                layout = {
                    sizing = {
                        clay.SizingGrow(),
                        clay.SizingFit(),
                    },
                },
            }) {}
            if clay.UI()({
                layout = {
                    sizing = {
                        clay.SizingFixed(140), clay.SizingFixed(140),
                    },
                    childAlignment = {
                        x = .Center, 
                        y = .Center,
                    }
                },
                image = {
                    &font_icon_images[.HP],
                },
            }) {
                clay.TextDynamic(fmt.tprintf("%d", the_card.max_hp), clay.TextConfig({
                    fontId = 0,
                    fontSize = 120,
                    textColor = {0, 0, 0, 255},
                }))
            }
        }
    }
}