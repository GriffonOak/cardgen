package cardgen


cards := []Card {
    Card { name = "Big Gun",
        slots = {.Hand},
        weight = 8,
        max_hp = 6,
        abilities = {
            {
                text = "2[Energy] => 1[Damage]",
                kind = .Attack,
                timing = .Phase_2,
                targeting = {
                    {
                        kind = .Straight,
                        range = 6,
                    },
                },
            },
        },
        price = 1,
        // flavour = "\"Quantity has a quality all its own.\"\n    - Joseph Stalin",
        flavour = "Spray and pray.",
    },
    Card { name = "X-Ray Targeting",
        slots = {.Mod},
        weight = 0,
        price = 1,
        abilities = {
            {
                kind = .Passive,
                text = "Your [Targeting_Straight] attacks\nignore obstacles."
            },
        },
        flavour = "\"What do you mean it shot a\nmissile through a rock?\"",
    },
    Card { name = "Swarm Missiles",
        slots = {.Hand},
        weight = 8,
        price = 1,
        max_hp = 4,
        abilities = {
            {
                kind = .Attack,
                timing = .Phase_2,
                targeting = {
                    {
                        kind = .Ballistic,
                        range = 3,
                    },
                },
                text = "4[Energy] => 2[Damage]",
            },
        },
        flavour = "They always find a way.",
    },
    Card { name = "Tower Shield",
        slots = {.Hand},
        weight = 8,
        max_hp = 4,
        price = 1,
        abilities = {
            {
                kind = .Utility,
                timing = .Phase_2,
                text = "4[Energy] => 4[Block] on this part.",
            },
            {
                kind = .Passive,
                text = "While this part has any [Block], it\nmust be selected in [Precision] attacks.",
            },
        },
        flavour = "It's not cowardice if you're alive."
    },
    Card { name = "Active Suspension",
        slots = {.Mod},
        weight = 0,
        price = 1,
        abilities = {
            {
                kind = .Utility,
                timing = .Phase_2,
                targeting = {
                    {
                        kind = .Self,
                    },
                },
                text = "2[Energy] => 2[Block] on a [Slot_Hand] part."
            },
            {
                kind = .Passive,
                text = "While any [Slot_Hand] part has [Block],\ntake -1[Damage] from attacks\nfrom adjacent units.",
                reminder = "(Damage cannot be reduced below 1.)",
            },
        },
        flavour = "Bend with the wind."
    },
    Card { name = "Martial Arts Protocol",
        slots = {.Mod},
        weight = 0,
        price = 1,
        abilities = {
            {
                kind = .Passive,
                timing = .Phase_2,
                text = "The first time each round\nyou lose [Block] to a melee\nattack, deal 1[Damage][Precision:2]\nto the attacker.",
                reminder = "(Melee attacks use [Targeting_Adjacent]/[Targeting_Surrounding])",
            },
        },
        flavour = "\"I know kung fu.\"\n    - Neo"
    },
    Card { name = "Ablative Plating",
        slots = {.Mod},
        weight = 1,
        price = 1,
        max_hp = 1,
        abilities = {
            {
                kind = .Utility,
                timing = .Phase_2,
                targeting = {
                    {
                        kind = .Self,
                    },
                },
                text = "2[Energy] => 1[Damage]3[Block]on a\npart with 0[Block]."
            },
        },
        flavour = "\"That'll buff out.\""
    },
    Card { name = "Targeting Computer",
        slots = {.Mod},
        weight = 0,
        price = 1,
        abilities = {
            {
                kind = .Utility,
                timing = .Phase_2,
                text = "3[Energy] => 1[Counter] (Max 1)"
            },
            {
                kind = .Passive,
                text = "When making a ranged attack, you may remove 1[Counter] from this\npart to give the attack +1[Targeting_Straight]/[Targeting_Ballistic]\nand [Precision:3]/-2[Precision].",
                reminder = "(Ranged attacks use [Targeting_Straight]/[Targeting_Ballistic])"
            },
            {
                kind = .Passive,
                timing = .Phase_3,
                text = "Remove all [Counter] from this part.",
            },
        },
        flavour = "\"I have a visual.\""
    },
    Card { name = "Reflex Drive",
        slots = {.Mod},
        weight = 3,
        price = 1,
        abilities = {
            {
                kind = .Passive,
                text = "Each round, the first attack\nagainst you with [Precision] gains +2[Precision].",
            },
        },
        flavour = "Nice try."
    },
    Card { name = "Aggressive Armour",
        slots = {.Torso},
        weight = 7,
        max_hp = 10,
        price = 1,
        abilities = {
            {
                kind = .Passive,
                timing = .Phase_1,
                text = "Gain 10[Energy].",
            },
            {
                kind = .Passive,
                text = "Whenever you deal [Damage],\n1[Block] on this part.",
            },
        },
        flavour = "Its fuel is violence.",
    },
    Card { name = "Basic Generator",
        slots = {.Torso},
        weight = 6,
        max_hp = 10,
        price = 1,
        abilities = {
            {
                kind = .Passive,
                timing = .Phase_1,
                text = "Gain 12[Energy].",
            },
        },
        flavour = "Flashy doesn't get the job done.",
    },
    Card { name = "Overdrive Core",
        slots = {.Torso},
        weight = 6,
        max_hp = 12,
        price = 1,
        abilities = {
            {
                kind = .Passive,
                timing = .Phase_1,
                text = "Gain 8[Energy].",
            },
            {
                kind = .Utility,
                timing = .Phase_1,
                text = "1[Damage] on this part => 1[Energy].",
            },
        },
        flavour = "\"Just try to keep an eye on it\".",
    },
    Card { name = "Dirk",
        slots = {.Hand},
        weight = 2,
        max_hp = 3,
        price = 1,
        abilities = {
            {
                kind = .Attack,
                timing = .Phase_2,
                targeting = {
                    {
                        kind = .Adjacent,
                    },
                },
                text = "2[Energy] => 1[Damage]. If your WC is 3 or less, you may move 1 space.",
            },
        },
        flavour = "Cut and run.",
    },
    Card { name = "Greathammer",
        slots = {.Hand, .Hand},
        weight = 14,
        max_hp = 8,
        price = 1,
        abilities = {
            {
                kind = .Attack,
                timing = .Phase_2,
                targeting = {
                    {
                        kind = .Adjacent,
                    },
                },
                text = "6[Energy] => WC[Damage]",
            },
        },
        flavour = "Brute strength has its place.",
    },
    Card { name = "Flail",
        slots = {.Hand},
        weight = 6,
        max_hp = 4,
        price = 1,
        abilities = {
            {
                kind = .Attack,
                timing = .Phase_2,
                targeting = {
                    {
                        kind = .Surrounding,
                    },
                },
                text = "4[Energy] => 3[Damage]",
            },
            {
                kind = .Attack,
                timing = .Phase_2,
                targeting = {
                    {
                        kind = .Straight,
                        range = 2,
                    },
                },
                text = "4[Energy] => 2[Damage]",
            },
        },
        flavour = "Don't get the chain stuck.",
    },
    Card { name = "Rocket Pod",
        slots = {.Hand},
        weight = 14,
        max_hp = 4,
        price = 1,
        abilities = {
            {
                kind = .Attack,
                timing = .Phase_2,
                targeting = {
                    {
                        kind = .Straight,
                        range = 4,
                    },
                },
                text = "6[Energy] => 2[Damage],1[Damage]",
            },
        },
        flavour = "BOOM!",
    },
    Card { name = "Rapier",
        slots = {.Hand},
        weight = 6,
        max_hp = 6,
        price = 1,
        abilities = {
            {
                kind = .Attack,
                timing = .Phase_2,
                targeting = {
                    {
                        kind = .Adjacent,
                    },
                },
                text = "5[Energy] => 3[Damage].\nDeals +1[Damage] if the\nhit part has [Block].",
            },
        },
        flavour = "\"Stick it in the gaps.\"",
    },
    Card { name = "Railgun",
        slots = {.Hand},
        weight = 10,
        max_hp = 6,
        price = 1,
        abilities = {
            {
                kind = .Attack,
                timing = .Phase_2,
                targeting = {
                    {
                        kind = .Straight,
                        range = 10,
                    },
                },
                text = "10[Energy] => 10[Damage]",
            },
        },
        flavour = "\"It\'s cumbersome, yes,\nbut imagine if it hits!\"",
    },
    Card { name = "Sniper Rifle",
        slots = {.Hand},
        weight = 6,
        max_hp = 3,
        price = 1,
        abilities = {
            {
                kind = .Attack,
                timing = .Phase_2,
                targeting = {
                    {
                        kind = .Straight,
                        range = 99,
                    },
                },
                text = "4[Energy] => 2[Damage].\nHas [Precision:1] if the target is at least\n4 spaces away.",
            },
        },
        flavour = "Don't move."
    },
    Card { name = "Crossbow",
        slots = {.Hand},
        weight = 3,
        max_hp = 4,
        price = 1,
        abilities = {
            {
                kind = .Utility,
                timing = .Phase_2,
                text = "5[Energy] => 1[Counter] (Max 1)",
            },
            {
                kind = .Attack,
                timing = .Phase_2,
                targeting = {
                    {
                        kind = .Straight,
                        range = 4,
                    },
                },
                text = "1[Energy],1[Counter] => 2[Damage]",
            },
        },
        flavour = "It's got a hair trigger."
    },
    Card { name = "Assassin's Blade",
        slots = {.Hand},
        weight = 2,
        max_hp = 3,
        price = 1,
        abilities = {
            {
                kind = .Attack,
                timing = .Phase_2,
                targeting = {
                    {
                        kind = .Adjacent,
                    },
                },
                text = "3[Energy] => 1[Damage][Precision:2]",
            },
        },
        flavour = "They never notice until it's too late."
    },
    Card { name = "Buckler",
        slots = {.Hand},
        weight = 2,
        max_hp = 3,
        price = 1,
        abilities = {
            {
                kind = .Utility,
                timing = .Phase_2,
                text = "2[Energy] => 2[Block] on this part.",
            },
            {
                kind = .Passive,
                text = "Whenever you lose [Hp] to a\nmelee attack, 1[Block] on this part.",
                reminder = "(Melee attacks use [Targeting_Adjacent]/[Targeting_Surrounding])",
            },
        },
    },
}