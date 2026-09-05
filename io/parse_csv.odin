package cardgen 

import "core:os"
import "core:fmt"
import "core:strings"
import "core:slice"
import "core:strconv"
import "core:reflect"
import "core:encoding/csv"


parse_csv :: proc() {

    card_data, err1 := os.read_entire_file("output/cards.csv", context.allocator)
    assert(err1 == nil, "Failed to read card data!")

    ability_data, err2 := os.read_entire_file("output/abilities.csv", context.allocator)
    assert(err2 == nil, "Failed to read ability data!")

    card_reader, ability_reader: csv.Reader

    csv.reader_init_with_string(&card_reader, string(card_data))
    csv.reader_init_with_string(&ability_reader, string(ability_data))

    card_records, err3 := csv.read_all(&card_reader)
    ability_records, err4 := csv.read_all(&ability_reader)

    assert(err3 == nil && err4 == nil, "Error parsing csv files!")

    // fmt.println(card_records)

    field_names := card_records[0]

    b := strings.builder_make()

    fmt.sbprintln(&b, "package cardgen\n\n")
    fmt.sbprintln(&b, "cards := []Card {")

    for record in card_records[1:] {
        card: Card

        record_map: map[string]string

        for field, index in record {
            record_map[field_names[index]] = field
        }

        // card.name = card_records[1][0]
        // slot, ok := reflect.enum_from_name(Slot_Kind, card_records[1][1])
        // slot_list := [?]Slot_Kind{slot}
        // card.slots = slot_list[:]

        // Name
        fmt.sbprintfln(&b, "\tCard { name = %v,", record[0])

        // Slot 1
        fmt.sbprintf(&b, "\t\tslots = { .%v", record[1])

        // Slot 2
        if record[2] != "" {
            fmt.sbprintf(&b, ", .%v", record[2])
        }

        fmt.sbprintln(&b, " }")
    }

    // fmt.printfln("%#w", card)

}