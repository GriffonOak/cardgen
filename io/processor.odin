package sheets

import "core:flags"
import "core:fmt"
import "core:os"
import "core:strings"
import "core:slice"

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

Card_Ability_Kind :: enum {
    Attack,
    Movement,
    Utility,
    Passive,
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
    Interrupt,
}

Card_Ability :: struct {
    kind: Card_Ability_Kind,
    timing: Card_Ability_Timing,
    targeting: []Card_Ability_Targeting,
    precision: int,
    text: string,
    reminder: string,
}

Card :: struct {
    name: string,
    slots: []Slot_Kind,
    weight, max_hp, price: int,
    abilities: []Card_Ability,
    flavour: string,
}

parse_odin_input :: proc() {
    cards_builder := strings.builder_make()
    abilities_builder := strings.builder_make()

    fmt.sbprintln(&cards_builder, "Name,Slot 1,Slot 2,Slot 3,Weight,Max HP,Price,Flavour")
    fmt.sbprintln(&abilities_builder, "Parent Card,Kind,Timing,Targeting 1,Targeting 2,Precision,Trigger,Energy Cost,Additional Cost,Effect,Reminder")

    compare_slot :: proc(a, b: Card) -> bool {
        if a.slots[0] == b.slots[0] {
            return a.name < b.name
        }
        return a.slots[0] < b.slots[0]
    }

    slice.sort_by(input_cards[:], compare_slot)

    for card in input_cards {
        // Name
        fmt.sbprintf(&cards_builder, "%v,", card.name)

        // Slots
        for slot_index in 0..<2 {
            if slot_index < len(card.slots) {
                fmt.sbprint(&cards_builder, card.slots[slot_index])
            }
            fmt.sbprint(&cards_builder, ",")
        }

        // Weight
        fmt.sbprintf(&cards_builder, "%v,", card.weight)

        // Max HP
        fmt.sbprintf(&cards_builder, "%v,", card.max_hp)

        // Price
        fmt.sbprintf(&cards_builder, "%v,", card.price)

        // Flavour
        sanitized_flavour, _ := strings.replace_all(card.flavour, "\n", "\\n")
        sanitized_flavour, _ = strings.replace_all(sanitized_flavour, "\"", "\"\"")
        fmt.sbprintf(&cards_builder, "\"%v\"", sanitized_flavour)

        // Finish card line
        fmt.sbprintln(&cards_builder)

        // Input abilities
        for ability in card.abilities {
            // Parent Card
            fmt.sbprintf(&abilities_builder, "%v,", card.name)
        }
    }

    outfile_name := "output/cards.csv"

    out_string := strings.expand_tabs(strings.to_string(cards_builder), 4)

    os.remove(outfile_name)
    outfile, err := os.open(outfile_name, os.O_WRONLY | os.O_CREATE)
    assert(err == nil)
    fmt.fprint(outfile, out_string)
}

main :: proc() {

    Options :: struct {
        parse_odin: bool `usage"Parse the input odin file, writing it to two .csv files."`,
        output_odin: bool `usage"Write a new odin file to the output"`
    }

    opt: Options

    flags.parse_or_exit(&opt, os.args, .Odin)

    // fmt.printfln("%#v", opt)

    if opt.parse_odin {
        parse_odin_input()
    }
}