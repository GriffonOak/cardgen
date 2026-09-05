package cardgen

import "core:flags"
import "core:os"


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

main :: proc() {

    Options :: struct {
        parse_odin: bool `usage"Parse the input odin file, writing it to two .csv files."`,
        parse_csv: bool `usage"Parse the .csv files and write a new odin file to the output."`
    }

    opt: Options

    flags.parse_or_exit(&opt, os.args, .Odin)

    // fmt.printfln("%#v", opt)

    if opt.parse_odin {
        parse_odin_input()
    }

    if opt.parse_csv {
        parse_csv()
    }
}