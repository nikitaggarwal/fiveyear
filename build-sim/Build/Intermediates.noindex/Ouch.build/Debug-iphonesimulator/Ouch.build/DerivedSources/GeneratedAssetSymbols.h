#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The resource bundle ID.
static NSString * const ACBundleID AC_SWIFT_PRIVATE = @"com.ouchapp.app";

/// The "AccentColor" asset catalog color resource.
static NSString * const ACColorNameAccentColor AC_SWIFT_PRIVATE = @"AccentColor";

/// The "celebrate" asset catalog image resource.
static NSString * const ACImageNameCelebrate AC_SWIFT_PRIVATE = @"celebrate";

/// The "lock" asset catalog image resource.
static NSString * const ACImageNameLock AC_SWIFT_PRIVATE = @"lock";

/// The "moon" asset catalog image resource.
static NSString * const ACImageNameMoon AC_SWIFT_PRIVATE = @"moon";

/// The "shield" asset catalog image resource.
static NSString * const ACImageNameShield AC_SWIFT_PRIVATE = @"shield";

/// The "sunrise" asset catalog image resource.
static NSString * const ACImageNameSunrise AC_SWIFT_PRIVATE = @"sunrise";

#undef AC_SWIFT_PRIVATE
