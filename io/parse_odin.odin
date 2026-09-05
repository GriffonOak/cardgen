package cardgen

import "core:os"
import "core:fmt"
import "core:strings"
import "core:slice"


NEWLINE_REPLACEMENT :: " " //"\\n"

Card_Field_Names :: enum {
    Name,
    Slot_1,
    Slot_2,
    Weight,
    Max_Hp,
    Price,
    Flavour,
}

Ability_Field_Names :: enum {
    Parent_Card,
    Kind,
    Timing,
    Targeting_1,
    Targeting_2,
    Precision,
    Energy_Cost,
    Additional_Cost,
    Effect,
    Trigger,
    Header,
    Footer,
    Reminder,
}

sanitize :: proc(input: string) -> string {
    temp, _ := strings.replace_all(input, "\n", NEWLINE_REPLACEMENT)
    temp, _ = strings.replace_all(temp, "\"", "\"\"")
    return temp
}

print_wrapped :: proc(builder: ^strings.Builder, input: string) {
    fmt.sbprintf(builder, "\"%v\"", input)
}

parse_odin_input :: proc() {
    cards_builder := strings.builder_make()
    abilities_builder := strings.builder_make()

    fmt.sbprintln(&cards_builder, "Name,Slot 1,Slot 2,Weight,Max HP,Price,Flavour")
    fmt.sbprintln(&abilities_builder, "Parent Card,Kind,Timing,Targeting 1,Targeting 2,Precision,Energy Cost,Additional Cost,Effect,Trigger,Header,Footer,Reminder")

    compare_slot :: proc(a, b: Card) -> bool {
        if a.slots[0] == b.slots[0] {
            return a.name < b.name
        }
        return a.slots[0] < b.slots[0]
    }

    slice.sort_by(cards[:], compare_slot)

    for card in cards {

        // Name
        sanitized_card_name := sanitize(card.name)
        print_wrapped(&cards_builder, sanitized_card_name)
        // if card.name == "Obtuse Emergency\nProtocols" {
        //     fmt.println(sanitize(card.name))
        // }
        fmt.sbprint(&cards_builder, ",")

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
        print_wrapped(&cards_builder, sanitize(card.flavour))

        // Finish card line
        fmt.sbprintln(&cards_builder)

        // Sort abilities by kind, then timing
        compare_kind :: proc(a, b: Card_Ability) -> bool {
            if a.kind == b.kind {
                timing_ranking := [Card_Ability_Timing]int {
                    .Phase_1 = 0,
                    .Phase_2 = 1,
                    .Phase_3 = 2,
                    .Interrupt = 3,
                    .None = 4,
                }

                return timing_ranking[a.timing] < timing_ranking[b.timing]
            }
            return a.kind < b.kind
        }

        slice.sort_by(card.abilities, compare_kind)

        // Input abilities
        for ability in card.abilities {

            // Parent Card
            fmt.sbprintf(&abilities_builder, "%v,", sanitized_card_name)

            // Kind
            fmt.sbprintf(&abilities_builder, "%v,", ability.kind)

            // Timing
            fmt.sbprintf(&abilities_builder, "%v,", ability.timing)

            // Targeting(s)
            for i in 0..<2 {
                if i < len(ability.targeting) {
                    targeting := ability.targeting[i]
                    fmt.sbprintf(&abilities_builder, "%v", targeting.kind)
                    if targeting.range > 0 do fmt.sbprintf(&abilities_builder, " %v", targeting.range)
                } 
                fmt.sbprint(&abilities_builder, ",")
            }

            // Precision
            if ability.precision > 0 {
                fmt.sbprintf(&abilities_builder, "%v", ability.precision)
            }
            fmt.sbprint(&abilities_builder, ",")

            // Text wrangling
            sanitized_text := sanitize(ability.text)
            header, trigger, total_cost, effect, footer: string
            lines := strings.split(sanitized_text, "|")

            for line, index in lines {

                // Parse trigger
                if strings.contains(line, ":") {
                    trigger_terms := strings.split(line, ":")
                    trigger = strings.trim_space(trigger_terms[0])
                    second_term := strings.trim_space(trigger_terms[1])
                    if second_term != "" {
                        effect = second_term
                    }
                
                // Parse cost
                } else if strings.contains(line, "=>") {
                    cost_terms := strings.split(line, "=>")

                    total_cost = strings.trim_space(cost_terms[0]) if len(cost_terms) > 1 else ""
                    effect = strings.trim_space(cost_terms[len(cost_terms) - 1])

                // Parse any additional text
                } else {
                    if index == 0 && len(lines) > 1 {
                        header = line
                    } else if effect == "" {
                        effect = line
                    } else {
                        footer = line
                    }
                }
            }

            // Costs
            costs := strings.split_n(total_cost, ",", 2)
            has_energy_cost := false

            // Energy Cost
            // Here we assume the first cost is always the energy cost.
            if strings.contains(costs[0], "[Energy]") {
                has_energy_cost = true
                energy_cost := strings.split(costs[0], "[")[0]
                fmt.sbprintf(&abilities_builder, "%v", energy_cost)
            }
            fmt.sbprint(&abilities_builder, ",")

            // Additional Cost
            if len(costs) > 1 || (total_cost != "" && !has_energy_cost) {
                if has_energy_cost {
                    print_wrapped(&abilities_builder, strings.trim_space(costs[1]))
                } else {
                    print_wrapped(&abilities_builder, total_cost)
                }
            }
            fmt.sbprint(&abilities_builder, ",")

            // Effect
            if effect != "" {
                print_wrapped(&abilities_builder, effect)
            }
            fmt.sbprint(&abilities_builder, ",")

            // Trigger
            if trigger != "" {
                print_wrapped(&abilities_builder, trigger)
            }
            fmt.sbprint(&abilities_builder, ",")

            // Header
            if header != "" {
                print_wrapped(&abilities_builder, header)
            }
            fmt.sbprint(&abilities_builder, ",")

            // Footer
            if footer != "" {
                print_wrapped(&abilities_builder, footer)
            }
            fmt.sbprint(&abilities_builder, ",")

            // Reminder
            print_wrapped(&abilities_builder, sanitize(ability.reminder))

            fmt.sbprint(&abilities_builder, "\n")
        }
    }

    // Write cards
    cards_outfile_name := "output/cards.csv"
    cards_out_string := strings.expand_tabs(strings.to_string(cards_builder), 4)

    os.remove(cards_outfile_name)
    cards_outfile, err1 := os.open(cards_outfile_name, os.O_WRONLY | os.O_CREATE)
    assert(err1 == nil)
    fmt.fprint(cards_outfile, cards_out_string)

    // Write abilities
    abilities_outfile_name := "output/abilities.csv"
    abilities_out_string := strings.expand_tabs(strings.to_string(abilities_builder), 4)

    os.remove(abilities_outfile_name)
    abilities_outfile, err2 := os.open(abilities_outfile_name, os.O_WRONLY | os.O_CREATE)
    assert(err2 == nil)
    fmt.fprint(abilities_outfile, abilities_out_string)
}