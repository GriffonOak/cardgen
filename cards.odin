package cardgen


cards := []Card {
    Card { name = "Big Gun",
        slots = {.Hand},
        weight = 8,
        max_hp = 6,
        abilities = {
            {
                text = "2[Energy] => 1[Damage].",
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
        max_hp = 1,
        price = 1,
        abilities = {
            {
                kind = .Passive,
                text = "Your [Targeting_Straight] attacks\nignore obstacles.",
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
                text = "4[Energy] => 2[Damage].",
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
                text = "While this part has [Block], it\nmust be selected in [Precision] attacks.",
            },
        },
        flavour = "It's not cowardice if you're alive.",
    },
    Card { name = "Active Suspension",
        slots = {.Mod},
        weight = 0,
        max_hp = 1,
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
                text = "2[Energy] =>|2[Block] on a [Slot_Hand] part.",
            },
            {
                kind = .Passive,
                text = "While any of your [Slot_Hand] parts have [Block], take -1[Damage] from attacks from adjacent units.",
            },
        },
        flavour = "Bend with the wind.",
    },
    Card { name = "Martial Arts Protocol",
        slots = {.Mod},
        weight = 0,
        max_hp = 1,
        price = 1,
        abilities = {
            {
                kind = .Attack,
                timing = .Interrupt,
                precision = 2,
                text = "The first time each round\nyou lose [Block] to a melee\nattack:|0[Energy] => Target the\nattacker. 1[Damage].",
                reminder = "(Melee attacks use [Targeting_Adjacent]/[Targeting_Surrounding])",
            },
        },
        // flavour = "\"I know kung fu.\"\n    - Neo",
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
                text = "2[Energy] => 1[Damage]3[Block]on a\npart with 0[Block].",
            },
        },
        flavour = "\"That'll buff out.\"",
    },
    Card { name = "Targeting Computer",
        slots = {.Mod},
        weight = 0,
        max_hp = 1,
        price = 1,
        abilities = {
            {
                kind = .Passive,
                timing = .Interrupt,
                text = "When using a ranged ability:|2[Energy] =>|Give the ability +1[Targeting_Straight], +1[Targeting_Ballistic] and -2[Precision]. If it had no [Precision],\ngive it [Precision:3].",
                reminder = "(Ranged abilities use [Targeting_Straight]/[Targeting_Ballistic])"
            },
        },
        flavour = "\"I have a visual.\"",
    },
    Card { name = "Reflex Drive",
        slots = {.Mod},
        weight = 3,
        max_hp = 1,
        price = 1,
        abilities = {
            {
                kind = .Passive,
                timing = .Interrupt,
                text = "The first time each round\nyou are targeted by an\nattack with [Precision]:|The attack gains +2[Precision].",
            },
        },
        flavour = "Nice try.",
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
                timing = .Interrupt,
                text = "Whenever you deal [Damage]\nto an enemy unit:|1[Block] on this part.",
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
                text = "Gain 9[Energy]. You may take up\nto 4[Damage] on this part, then\ngain[Energy] equal to damage\ntaken.",
                reminder = "(If this part destroys itself,\ndo not gain additional [Energy].)",
            },
        },
        flavour = "Just try to keep an eye on it.",
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
                text = "2[Energy] => 1[Damage]. If your WC\nis 3 or less, 1[Movement].",
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
                text = "6[Energy] => WC[Damage].",
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
                text = "4[Energy] => 3[Damage].",
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
                text = "4[Energy] => 2[Damage].",
            },
        },
        flavour = "Don't get the chain stuck.",
    },
    Card { name = "Rocket Pod",
        slots = {.Hand},
        weight = 8,
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
                text = "6[Energy] => 2[Damage],1[Damage].",
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
                text = "This attack deals +1[Damage]\nto parts with [Block].|5[Energy] => 3[Damage]",
            },
        },
        flavour = "No defence is without weakness.",
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
                text = "10[Energy] => 10[Damage].",
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
                text = "This attack gains [Precision:1] when targeting a unit 4 or more spaces away.|4[Energy] => 2[Damage].",
            },
            // {
            //     kind = .Passive,
            //     text = "[Damage] dealt by this part has\n[Precision:1] if the target is 4 or\nmore spaces away.",
            // },
        },
        flavour = "Don't move.",
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
                text = "5[Energy] => 1[Counter] (Max 1).",
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
                text = "1[Energy], 1[Counter] => 2[Damage].",
            },
        },
        flavour = "Careful with the trigger.",
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
                precision = 2,
                targeting = {
                    {
                        kind = .Adjacent,
                    },
                },
                text = "3[Energy] => 1[Damage].",
            },
        },
        flavour = "They won't feel a thing.",
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
                timing = .Interrupt,
                text = "Whenever you lose [Hp]\nto a [Targeting_Adjacent]/[Targeting_Surrounding] attack:|1[Block] on this part.",
            },
        },
        flavour = "I hardly know 'er!",
    },
    Card { name = "Repair Tool",
        slots = {.Hand},
        weight = 4,
        max_hp = 2,
        price = 1,
        abilities = {
            {
                kind = .Utility,
                timing = .Phase_2,
                precision = 1,
                targeting = {
                    {
                        kind = .Self,
                    },
                    {
                        kind = .Adjacent,
                    },
                },
                text = "4[Energy] =>|2[Repair] on another\npart.",
            },
        },
        flavour = "Show me where it hurts.",
    },
    Card { name = "Plink Cannon",
        slots = {.Mod},
        weight = 1,
        max_hp = 1,
        price = 1,
        abilities = {
            {
                kind = .Attack,
                timing = .Phase_1,
                targeting = {
                    {
                        kind = .Ballistic,
                        range = 2,
                    },
                },
                text = "1[Energy] => 1[Damage].",
            },
        },
        flavour = "Plink!",
    },
    Card { name = "Chrome Dome",
        slots = {.Head},
        weight = 5,
        max_hp = 4,
        price = 1,
        abilities = {
            {
                kind = .Utility,
                timing = .Phase_2,
                text = "Once per combat.|8[Energy] => 3[Block] on all your parts.",
            },
        },
        flavour = "\"You will ride eternal,\nshiny and chrome.\"\n   - Immortan Joe",
    },
    Card { name = "Tesla Cranium",
        slots = {.Head},
        weight = 5,
        max_hp = 2,
        price = 1,
        abilities = {
            {
                kind = .Passive,
                timing = .Phase_1,
                text = "1[Counter] (Max 6).",
            },
            {
                kind = .Attack,
                timing = .Phase_2,
                targeting = {
                    {
                        kind = .Ballistic, range = 2,
                    },
                },
                text = "5[Energy], 6[Counter] =>|Target all valid units.\n1[Ion] on every part on\neach target.",
            },
        },
        flavour = "You may feel a slight tingling.",
    },
    Card { name = "Heat Rays",
        slots = {.Head},
        weight = 4,
        max_hp = 3,
        price = 1,
        abilities = {
            {
                kind = .Attack,
                timing = .Phase_2,
                targeting = {
                    {
                        kind = .Straight,
                        range = 6,
                    },
                },
                text = "10[Energy] =>|Ignoring obstacles, target all valid units in any one direction. 2[Fire],2[Fire],2[Fire].",
            },
        },
        flavour = "It's rude to stare.",
    },
    Card { name = "Hammer Head",
        slots = {.Head},
        weight = 9,
        max_hp = 5,
        price = 1,
        abilities = {
            {
                kind = .Passive,
                timing = .Interrupt,
                text = "Whenever you deal [Damage]\nto an enemy unit: 1[Counter]."
            },
            {
                kind = .Attack,
                timing = .Phase_2,
                targeting = {
                    {
                        kind = .Adjacent,
                    },
                },
                text = "4[Energy], X[Counter] => X[Damage].",
            },
        },
        flavour = "\"It doesn't really have\nanything to do with sharks.\"",
    },
    Card { name = "Tripedal Drive",
        slots = {.Legs, .Hand},
        weight = 10,
        max_hp = 6,
        price = 1,
        abilities = {
            {
                kind = .Movement,
                timing = .Phase_2,
                text = "3[Energy] => (10 - WC)[Movement].",
            },
        },
        flavour = "Be grateful for\nwhat you still have.",
    },
    Card { name = "Nuclear Reactor",
        slots = {.Torso},
        weight = 12,
        max_hp = 20,
        price = 1,
        abilities = {
            {
                kind = .Passive,
                timing = .Phase_1,
                text = "Gain 14[Energy].\nThis part loses [Hp:2].",
            },
        },
        flavour = "There is no Plan B.",
    },
    Card { name = "Jumping Legs",
        slots = {.Legs},
        weight = 4,
        max_hp = 4,
        price = 1,
        abilities = {
            {
                kind = .Movement,
                timing = .Phase_2,
                text = "2[Energy] => (4 - WC)[Movement].",
            },
            {
                kind = .Passive,
                text = "When using [Movement], you may\nmove through obstacles.",
            },
        },
        flavour = "\"It's a lifestyle.\"",
    },
    Card { name = "Spartan Legs",
        slots = {.Legs},
        weight = 8,
        max_hp = 4,
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
                text = "3[Energy] =>|2[Damage]. Push the target\n1 space.",
            },
            {
                kind = .Movement,
                timing = .Phase_2,
                text = "3[Energy] => (6 - WC)[Movement].",
            },
        },
        flavour = "\"Wasn't there a quote about this?\"",
    },
    Card { name = "Swift-foot Legs",
        slots = {.Legs},
        weight = 5,
        max_hp = 3,
        price = 1,
        abilities = {
            {
                kind = .Movement,
                timing = .Phase_2,
                text = "3[Energy] => (10 - 2*WC)[Movement].",
            },
        },
        flavour = "Hey, remember BEDMAS?",
    },
    Card { name = "Legs",
        slots = {.Legs},
        weight = 6,
        max_hp = 6,
        price = 1,
        abilities = {
            {
                kind = .Movement,
                timing = .Phase_2,
                text = "3[Energy] => (6 - WC)[Movement].",
            },
        },
        flavour = "Begin with a single step.",
    },
    Card { name = "Sentry Legs",
        slots = {.Legs},
        weight = 9,
        max_hp = 7,
        price = 1,
        abilities = {
            {
                kind = .Movement,
                timing = .Phase_2,
                text = "3[Energy] => (8 - WC)[Movement].",
            },
            {
                kind = .Passive,
                text = "When using [Movement], turns along your\npath cost an additional 1[Movement].",
            },
        },
        flavour = "\"You'll get the hang of it.\"",
    },
    Card { name = "Billboard",
        slots = {.Hand},
        weight = 5,
        max_hp = 4,
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
                text = "3[Energy] => 1[Damage].",
            },
            {
                kind = .Passive,
                text = "When you purchase this\npart, your team gains $10.",
            },
        },
        flavour = "Feel the power of\nthe invisible hand.",
    },
    Card { name = "Cytokine Storm",
        slots = {.Mod},
        weight = 0,
        max_hp = 1,
        price = 1,
        abilities = {
            {
                kind = .Attack,
                timing = .Interrupt,
                targeting = {{kind = .Surrounding}},
                text = "Whenever you clear 1\nor more of your status tokens:|0[Energy] => 1[Damage] for each status\ntoken cleared.",
            },
            {
                kind = .Utility,
                timing = .Phase_2,
                text = "2[Energy], take 1[Damage],1[Damage] =>|Clear all your status tokens.",
            },
        },
        flavour = "\"It's spelled how it sounds.\"",
    },
    Card { name = "Small Modular Reactor",
        slots = {.Mod},
        weight = 4,
        price = 1,
        max_hp = 1,
        abilities = {
            {
                kind = .Passive,
                timing = .Phase_1,
                text = "Gain 2[Energy].",
            },
        },
        flavour = "...but mighty.",
    },
    Card { name = "Optimized Routing",
        slots = {.Mod},
        weight = 1,
        max_hp = 1,
        price = 1,
        abilities = {
            {
                kind = .Passive,
                text = "Abilities that cost 5[Energy]\nor more cost 1[Energy] less.",
            },
        },
    },
    Card { name = "Suspension System",
        slots = {.Mod},
        weight = -2,
        price = 1,
        max_hp = 1,
        abilities = {
            {
                kind = .Passive,
                timing = .Phase_1,
                text = "Remove all [Counter] from this part. You may pay 3[Energy] to place 1[Counter] on this part.",
            },
            {
                kind = .Passive,
                text = "While this part has [Counter],\nyou have -10[Weight].",
            },
        },
    },
    Card { name = "Self-forming Structures",
        slots = {.Mod},
        weight = 4,
        price = 1,
        max_hp = 1,
        abilities = {
            {
                kind = .Passive,
                timing = .Phase_1,
                targeting = {{kind = .Self}},
                text = "1[Repair].",
            },
        },
    },
    Card { name = "Grapple Arm",
        slots = {.Hand},
        weight = 6,
        price = 1,
        max_hp = 5,
        abilities = {
            {
                kind = .Utility,
                timing = .Phase_2,
                targeting = {{kind = .Straight, range = 4}},
                text = "4[Energy] =>|Target a valid obstacle. Move in a straight line towards it until you are adjacent.\nIf it is a unit, 1[Damage].",
            },
        },
    },
    Card { name = "Arm Blades",
        slots = {.Hand},
        weight = 6,
        price = 1,
        max_hp = 5,
        abilities = {
            {
                kind = .Attack,
                timing = .Phase_2,
                targeting = {{kind = .Adjacent}},
                text = "4[Energy] => 3[Damage].",
            },
            {
                kind = .Attack,
                timing = .Phase_2,
                precision = 1,
                targeting = {{kind = .Adjacent}},
                text = "3[Energy] =>|Move 1-2 spaces in a straight line, then target a valid unit in the same direction as you moved. 1[Damage].",
                reminder = "(You must be able to do both.)"
            },
        },
    },
    Card { name = "Fire Spitter",
        slots = {.Hand},
        weight = 10,
        price = 1,
        max_hp = 5,
        abilities = {
            {
                kind = .Attack,
                timing = .Phase_2,
                targeting = {{kind = .Straight, range = 3}},
                text = "5[Energy] => 1[Fire],1[Fire].",
            },
        },
    },
    Card { name = "Bludgeon Arm",
        slots = {.Hand},
        weight = 11,
        price = 1,
        max_hp = 6,
        abilities = {
            {
                kind = .Attack,
                timing = .Phase_2,
                targeting = {{kind = .Adjacent}},
                text = "This attack deals +2[Damage] if your WC is 4 or more.|7[Energy] => WC[Damage]"
            },
        },
        flavour = "\"That ought to do the trick.\""
    },
    Card { name = "Reactive Exoskeleton",
        slots = {.Legs},
        weight = 8,
        price = 1,
        max_hp = 3,
        abilities = {
            {
                kind = .Movement,
                timing = .Phase_2,
                text = "3[Energy] => (5 - WC)[Movement]."
            },
            {
                kind = .Movement,
                timing = .Interrupt,
                text = "Once per round, after any\nactivation finishes:|WC[Energy] => 1[Movement]."
            }
        },
        flavour = "\"Phew!\""
    },
    Card { name = "Inertial Drive",
        slots = {.Torso},
        weight = 4,
        price = 1,
        max_hp = 8,
        abilities = {
            {
                kind = .Passive,
                timing = .Phase_1,
                text = "Remove all [Counter] from this\npart and gain 10[Energy].\nYou may place 1[Counter] on\nthis part to gain 4[Energy]."
            },
            {
                kind = .Passive,
                text = "While this part has [Counter], you\nget -1[Movement] from all sources."
            },
        },
    },
    Card { name = "Conserving Dynamo",
        slots = {.Torso},
        weight = 4,
        price = 1,
        max_hp = 8,
        abilities = {
            {
                kind = .Passive,
                timing = .Phase_1,
                text = "Gain 10[Energy]."
            },
            {
                kind = .Passive,
                text = "You may conserve up to\n7[Energy] between rounds."
            }
        },
        flavour = "Waste not, want not."
    },
    Card { name = "Movement Amplifier",
        slots = {.Head},
        weight = 6,
        price = 1,
        max_hp = 2,
        abilities = {
            {
                kind = .Passive,
                text = "You get +1[Movement]\nfrom all sources."
            },
        },
        flavour = "Wheeeee!"
    },
    // Card { name = "Plated Visor",
    //     slots = {.Head},
    //     weight = 5,
    //     price = 1,
    //     max_hp = 4,
    //     abilities = {
    //         {
    //             kind = .Utility,
    //             timing = .Phase_2,
    //             targeting = {{kind = .Self}},
    //             text = "2[Energy] =>|2[Block] on a non-[Slot_Hand] part.",
    //         },
    //     },
    // },
    Card { name = "Cloaking Device",
        slots = {.Mod},
        weight = 3,
        price = 1,
        max_hp = 1,
        abilities = {
            {
                kind = .Passive,
                text = "When built, 3[Counter].",
            },
            {
                kind = .Utility,
                timing = .Interrupt,
                text = "Before using [Movement]:|1[Energy], 1[Counter] =>|Ignore zone of control\nfor that movement.",
            },
        },
    },
    Card { name = "Afflictive Resonator",
        slots = {.Mod},
        weight = 1,
        max_hp = 1,
        price = 1,
        abilities = {
            {
                kind = .Passive,
                timing = .Phase_1,
                targeting = {
                    { kind = .Self, }, { kind = .Ballistic, range = 2 },
                },
                text = "You may clear 1 status token from a valid part.\nYou may add 1 status token of the same type to a valid part that already has one.",
            },
        },
        flavour = "\"I don't feel so good.\"",
    },
    Card { name = "Afterburner",
        slots = {.Hand},
        weight = 6,
        max_hp = 5,
        price = 1,
        abilities = {
            {
                kind = .Attack,
                timing = .Phase_2,
                targeting = {
                    { kind = .Straight, range = 2 },
                },
                text = "4[Energy] => 1[Fire], X[Damage].|X is the number of status tokens on the target."
            },
        },
        flavour = "Are you feeling it now?"
    },
    Card { name = "Plasma Saber",
        slots = {.Hand},
        weight = 8,
        max_hp = 6,
        price = 1,
        abilities = {
            {
                kind = .Attack,
                timing = .Phase_2,
                targeting = { { kind = .Adjacent} },
                precision = 3,
                text = "6[Energy] => 2[Fire].",
            },
            {
                kind = .Attack,
                timing = .Phase_2,
                targeting = { { kind = .Adjacent} },
                precision = 2,
                text = "4[Energy] => 1[Fire]X[Damage].|X is the number of [Fire] on the target's part with the most [Fire].",
            },
        },
    },
    Card { name = "Exhaust Vent",
        slots = {.Mod},
        weight = 2,
        max_hp = 1,
        price = 1,
        abilities = {
            {
                kind = .Attack,
                timing = .Phase_1,
                targeting = { { kind = .Adjacent} },
                text = "1[Energy] => Clear 1 of your status tokens. If you do, 1[Fire].",
            },
        },
        flavour = "Doesn't that feel better?"
    },
    Card { name = "Thermal Plating",
        slots = {.Torso},
        weight = 8,
        max_hp = 12,
        price = 1,
        abilities = {
            {
                kind = .Passive,
                timing = .Phase_1,
                text = "Gain 10[Energy]. You may take\n1[Fire] to gain 3[Energy].",
            },
            {
                kind = .Passive,
                text = "Paid abilities on your\nparts with [Fire] cost -1[Energy].",
            },
        },
        flavour = "Toasty!"
    },
    Card { name = "Obtuse Emergency\nProtocols",
        slots = {.Mod},
        weight = 1,
        max_hp = 1,
        price = 1,
        abilities = {
            {
                kind = .Passive,
                targeting = {{kind = .Self}, {kind = .Ballistic, range = 2}},
                text = "The basic action to clear status tokens costs -1[Energy] for valid allies and +1[Energy] for valid enemies.",
                reminder = "(You are your own ally.)"
            },
        },
    },
    Card { name = "Precision Disabler",
        slots = {.Hand},
        weight = 7,
        max_hp = 4,
        price = 1,
        abilities = {
            {
                kind = .Attack,
                timing = .Phase_2,
                precision = 2,
                targeting = {{kind = .Ballistic, range = 2}},
                text = "6[Energy] =>|2[Ion] on a non-[Slot_Torso]/[Slot_Legs] part. The target loses 2[Energy].",
            },
        },
        flavour = "You won't be needing that."
    },
    Card { name = "Comms Jammer",
        slots = {.Mod},
        weight = 1,
        max_hp = 1,
        price = 1,
        abilities = {
            {
                kind = .Passive,
                text = "Enemies with [Ion] may not speak during their activations.",
            },
        },
    },
    Card { name = "Stunner",
        slots = {.Hand},
        weight = 6,
        max_hp = 5,
        price = 1,
        abilities = {
            {
                kind = .Attack,
                timing = .Phase_2,
                targeting = {{kind = .Adjacent}},
                text = "5[Energy] => 1[Ion],1[Ion].",
            },
        },
        flavour = "Sparkly!"
    },
    Card { name = "Amplifying Subwoofer",
        slots = {.Mod},
        weight = 4,
        max_hp = 1,
        price = 1,
        abilities = {
            {
                kind = .Attack,
                timing = .Phase_2,
                targeting = {{kind = .Self}, {kind = .Ballistic, range = 2,}},
                text = "4[Energy] =>|1[Damage] to all valid parts with status tokens.",
            },
        },
        flavour = "Crank it up."
    },
    Card { name = "Temporal Drive",
        slots = {.Mod},
        weight = 4,
        max_hp = 1,
        price = 1,
        abilities = {
            {
                kind = .Passive,
                timing = .Phase_1,
                text = "Gain 1[Energy].",
            },
            {
                kind = .Passive,
                timing = .Interrupt,
                text = "When checking initiative,\nif you are tied for most [Energy]:|Each player tied with\nyou loses 1[Energy].",
                reminder = "(You then take the next activation.)"
            },
        },
    },
    Card { name = "Universal Joint",
        slots = {.Head},
        weight = 2,
        max_hp = 5,
        price = 1,
        abilities = {
            {
                kind = .Passive,
                text = "You get +1[Slot_Hand].",
            },
        },
        flavour = "\"We think it should be fine.\""
    },
    Card { name = "Databanks",
        slots = {.Head},
        weight = 5,
        max_hp = 5,
        price = 1,
        abilities = {
            {
                kind = .Passive,
                text = "You get +2[Slot_Mod].",
            },
        },
        flavour = "What's a few more petabytes, anyway?",
    },
    Card { name = "Self-Throwing Arm",
        slots = {.Hand},
        weight = 6,
        max_hp = 6,
        price = 1,
        abilities = {
            {
                kind = .Attack,
                timing = .Phase_2,
                targeting = {{kind = .Ballistic, range = 3}},
                text = "6[Energy] => 8[Damage]. Destroy\nthis part.",
            },
        },
        flavour = "It was holding me back."
    },
    Card { name = "Mortar",
        slots = {.Hand},
        weight = 7,
        max_hp = 5,
        price = 1,
        abilities = {
            {
                kind = .Attack,
                timing = .Phase_2,
                targeting = {{kind = .Ballistic, range = 4}},
                text = "6[Energy] => X[Damage].|X is the distance between you and the target.",
            },
        },
        flavour = "Fetchez la vache!"
    },
    Card { name = "Steamroller",
        slots = {.Legs},
        weight = 14,
        max_hp = 8,
        price = 1,
        abilities = {
            {
                kind = .Movement,
                timing = .Phase_2,
                text = "4[Energy] => (6 - WC)[Movement].",
            },
            {
                kind = .Passive,
                text = "When using [Movement], you ignore zone of control and may push units with lower [Weight] than you. Units pushed this way take 1[Damage], or 2[Damage] if you have twice their [Weight]."
            },
        },
        flavour = "Get out of my way." 
    },
    Card { name = "Pilot Light",
        slots = {.Hand},
        weight = 6,
        max_hp = 8,
        price = 1,
        abilities = {
            {
                kind = .Attack,
                timing = .Phase_2,
                targeting = {{kind = .Adjacent}},
                text = "1[Energy], take 2[Fire] => 2[Fire].",
            },
        },
    },
    Card { name = "Shinobi Skull",
        slots = {.Head},
        weight = 4,
        max_hp = 2,
        price = 1,
        abilities = {
            {
                kind = .Passive,
                timing = .Interrupt,
                text = "Whenever you use a\nmelee attack: 1[Counter].",
            },
            {
                kind = .Utility,
                timing = .Phase_2,
                text = "4[Energy], 3[Counter] => Place yourself into any empty space.",
            },
        },
        flavour = "Nothing personnel kid."
    },
}