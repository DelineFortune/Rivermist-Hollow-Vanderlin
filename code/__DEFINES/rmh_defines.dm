// Coin base_type identifiers.
#define CTYPE_GUILD "t"

// Smallclothes preference save keys.
#define SMALCLOTHES_RANDOM_PREFERENCES "Random Preferences"
#define SMALCLOTHES_UNDIE_PREFERENCES "Undies Preferences"
#define SMALCLOTHES_UNDIE_COLOR_PREFERENCES "Undies Color"
#define SMALCLOTHES_LEGWEAR_PREFERENCES "Legwear Preferences"
#define SMALCLOTHES_LEGWEAR_COLOR_PREFERENCES "Legwear Color"
#define SMALCLOTHES_BRA_PREFERENCES "Bra Preferences"
#define SMALCLOTHES_BRA_COLOR_PREFERENCES "Bra Color"
#define SMALCLOTHES_GARTER_PREFERENCES "Garter Preferences"
#define SMALCLOTHES_GARTER_COLOR_PREFERENCES "Garter Color"
#define SMALCLOTHES_UNDERSHIRT_PREFERENCES "Undershirt Preferences"
#define SMALCLOTHES_UNDERSHIRT_COLOR_PREFERENCES "Undershirt Color"
#define SMALCLOTHES_ARMSLEEVE_PREFERENCES "Armsleeve Preferences"
#define SMALCLOTHES_ARMSLEEVE_COLOR_PREFERENCES "Armsleeve Color"

// Arousal component tuning.
#define ARO_LOSS_COEFFICIENT 10

// Body storage layer identifiers.
#define STORAGE_LAYER_OUTER "layer_outer"
#define STORAGE_LAYER_INNER "layer_inner"
#define STORAGE_LAYER_DEEP "layer_deep"

// Body storage insertion feedback codes.
#define INSERT_FEEDBACK_OK "feedback_ok"
#define INSERT_FEEDBACK_OK_FORCE "feedback_ok_force"
#define INSERT_FEEDBACK_OK_OVERRIDE "feedback_override"
#define INSERT_FEEDBACK_ALMOST_FULL "feedback_almost"
#define INSERT_FEEDBACK_STUFFED "feedback_stuffed"
#define INSERT_FEEDBACK_TRY_FORCE "feedback_try_force"

// Body storage default capacity tuning.
#define OUTER_LAYER_DEFAULT_BULK 1
#define INNER_LAYER_DEFAULT_BULK 8
#define DEEP_LAYER_DEFAULT_BULK 15

#define HOLE_MAX_BULK_INSERT 10 //we want to have it possible that a sufficiently big insertible will trigger stretching on it's own

// Oviposition egg type identifiers.
#define OVI_EGG_NORMAL "normal_ovi"
#define OVI_EGG_AVIAN "avian_ovi"
#define OVI_EGG_SOFTSHELL "softshell_ovi"
#define OVI_EGG_PARASITIC "parasitic_ovi"
#define OVI_EGG_SPIDER "spider_ovi"
#define OVI_EGG_BOG_BUG "bog_bug_ovi"
#define OVI_EGG_HARPY "harpy_ovi"
#define OVI_EGG_EMBRYO "embryo_ovi"

// Oviposition customization and balance limits.
#define OVI_EGG_MAX_CLUTCH 30
#define OVI_EGG_DEFAULT_SCALE 1
#define OVI_EGG_MIN_SCALE 0.5
#define OVI_EGG_MAX_SCALE 2
#define OVI_EGG_MAX_CUSTOM_NAME_LENGTH 96
#define OVI_EGG_MAX_CUSTOM_DESC_LENGTH 512
#define OVI_EGG_STAGE_TIME 1 MINUTES

// Oviposition egg modifier flags.
#define OVI_EGG_TRAIT_APHRODISIAC "aphrodisiac"
#define OVI_EGG_TRAIT_POISON "poison"
#define OVI_EGG_TRAIT_PARASITE "parasite"
#define OVI_EGG_TRAIT_FAST_GROWTH "fast_growth"
