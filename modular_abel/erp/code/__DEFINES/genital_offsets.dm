// Genital offsets - separate from the clothing offsets in code/__DEFINES/mobs.dm (OFFSET_BELT etc.
// are tuned for worn items and are usually (0,0) even on short races). Genitals are drawn straight
// onto the body and need their own per-species table to track its actual proportions.
#define OFFSET_PENIS "penis"
#define OFFSET_BREASTS "breasts"
#define OFFSET_TESTICLES "testicles"
#define OFFSET_VAGINA "vagina"
/// Same idea, for smallclothes styles that have no dedicated short-race sprite and fall back to
/// the human-proportioned art (see smallclothes_dwarf_state in modular_abel/erp/code/modules/smallclothes).
#define OFFSET_SMALLCLOTHES "smallclothes"
