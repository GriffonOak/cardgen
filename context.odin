package cardgen


// Slot_Kind :: enum {
//     Head,
//     Torso,
//     Hand,
//     Legs,
//     Mod,
// }

// Card_Ability_Kind :: enum {
//     Attack,
//     Movement,
//     Utility,
//     Passive,
// }

// Card_Ability_Timing :: enum {
//     None,
//     Phase_1,
//     Phase_2,
//     Phase_3,
// }

// Targeting_Kind :: enum {
//     None,
//     Self,
//     Adjacent,
//     Surrounding,
//     Straight,
//     Ballistic,
// }

// Card_Ability_Targeting :: struct {
//     kind: Targeting_Kind,
//     range: int,
// }

// Card_Ability :: struct {
//     name: string,
//     text: string,
//     reminder: string,
//     kind: Card_Ability_Kind,
//     timing: Card_Ability_Timing,
//     targeting: []Card_Ability_Targeting,
// }

// Card :: struct {
//     name: string,
//     slots: []Slot_Kind,
//     weight, max_hp, price: int,
//     abilities: []Card_Ability,
//     flavour: string,
// }