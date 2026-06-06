# Twilight ERP Modular — PARKED (intentionally NOT included)

These files are the Twilight-Axis-specific ERP content that depends on systems
that **do not exist in Vanderlin** (patrons, charflaws/addictions, extra species,
dullahan heads, the temptress/martial-master combat stack, account-level
`prefs.sexable`, Twilight stress/status effects, etc.).

**None of these files are referenced by `modular_abel/__includes.dm`.** They are
preserved verbatim so the missing mechanics can be re-integrated later once the
underlying Twilight systems (or Vanderlin equivalents) are ported.

## Contents

| Path | What it is | Why parked (missing in Vanderlin) |
|---|---|---|
| `patches_original/arousal.dm` | Satisfaction points, overload, nympho/lovefiend arousal extensions, chain-orgasm, climax stress | `/datum/charflaw/addiction/*`, `/datum/patron/inhumen/baotha`, Twilight stress events |
| `patches_original/flaw.dm` | `lovefiend` addiction life-tick | charflaw system |
| `patches_original/species.dm` | gnoll species ERP hooks | `/datum/species/gnoll` |
| `patches_original/wanderer.dm` | martial_master + temptress combo-combat stack, temptress ERP-training map | `combo_core`, skills, traits, spells not in Vanderlin |
| `patches_original/mob.dm` | original mob patch (dullahan/wildshape/leprosy/defiant variants) | superseded by `erp_foundation/erp_anatomy.dm` + `erp_consent.dm` |
| `patches_original/obj.dm` `organs.dm` `preferences.dm` | original patches | superseded by `erp_foundation/*` |
| `additionals/erp_emotes.dm` | lick/spit ERP emote overrides | `iself/ishalfelf`, love_potion, `H.mouth.spitoutmouth` |
| `additionals/erp_items.dm` | sex toys / dildos content | Twilight item bases |
| `additionals/erp_modifiers.dm` | sex modifiers | Twilight |
| `additionals/erp_reagents.dm` | love_potion, salted-milk crafting, baotha/lovefiend taste | patrons/flaws/alchemy |
| `additionals/erp_status_effects.dm` | love_potion, satisfaction buff, overload debuff, relationship sync | nympho/relationships/STATKEY |
| `additionals/erp_stress_effects.dm` | nympho/vice stress events | Twilight stress base |
| `additionals/erp_decals.dm` | `coom` decal + onbite licking | superseded by clean `erp_foundation/erp_content.dm` |
| `actor/erp_dullahan_head.dm` | dullahan-head ERP actor | `/obj/item/bodypart/head/dullahan` |

The included foundation (`modular_abel/code/modules/erp_foundation/`) re-implements
the *minimum* clean, Twilight-free versions of the content the engine hard-requires
(cum/lube/milk reagents, the `coom` decal, `erp_coating`/`mouth_full`/knot statuses,
the arousal component, genital organ types).
