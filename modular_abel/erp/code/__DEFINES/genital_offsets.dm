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

// Anatomical z-order for the genital overlays, mirroring Rivermist's dedicated
// ADJ_TOP(53)/ADJ_MID(55)/ADJ(56)/ADJ_LOW(57) sublayer split (code/__DEFINES/misc.dm there) with
// fractional layers inside Vanderlin's single ADJ band instead of new global defines. The port
// originally put penis/vagina on BODY_FRONT_LAYER(5) - far in front of the testicles' ADJ(41) -
// so both fully overdrew the testicle sprite (identical gonads.dmi renders fine on Rivermist).
// Bigger value = further back: breasts in front, then penis, testicles peeking behind it, vagina last.
#define GENITAL_LAYER_BREASTS   (BODY_ADJ_LAYER - 0.4)
#define GENITAL_LAYER_PENIS     (BODY_ADJ_LAYER - 0.3)
#define GENITAL_LAYER_TESTICLES (BODY_ADJ_LAYER - 0.2)
#define GENITAL_LAYER_VAGINA    (BODY_ADJ_LAYER - 0.1)
