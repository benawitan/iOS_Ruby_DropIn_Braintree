@import UIKit;

#import "BTVenmoAppSwitchRequestURL.h"
#import "BTURLUtils.h"

#define kXCallbackTemplate @"scheme://x-callback-url/path"
#define kVenmoScheme @"com.venmo.touch.v1"

@implementation BTVenmoAppSwitchRequestURL

+ (BOOL)isAppSwitchAvailable {
    NSURL *url = [self appSwitchBaseURLComponents].URL;
    return [[UIApplication sharedApplication] canOpenURL:url];
}

+ (NSURL *)appSwitchURLForMerchantID:(NSString *)merchantID returnURLScheme:(NSString *)scheme offline:(BOOL)offline {
    NSMutableDictionary *appSwitchParameters = [@{@"x-success": [self returnURLWithScheme:scheme result:@"success"],
                                                  @"x-error": [self returnURLWithScheme:scheme result:@"error"],
                                                  @"x-cancel": [self returnURLWithScheme:scheme result:@"cancel"],
                                                  @"x-source": [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
                                                  @"braintree_merchant_id": merchantID,
                                                  } mutableCopy];
    if (offline) {
        appSwitchParameters[@"offline"] = @1;
    }

    NSURLComponents *components = [self appSwitchBaseURLComponents];
    components.percentEncodedQuery = [BTURLUtils queryStringWithDictionary:appSwitchParameters];
    return components.URL;
}

#pragma mark Internal Helpers

+ (NSURL *)returnURLWithScheme:(NSString *)scheme result:(NSString *)result {
    NSURLComponents *components = [NSURLComponents componentsWithString:kXCallbackTemplate];
    components.scheme = scheme;
    components.percentEncodedPath = [NSString stringWithFormat:@"/vzero/auth/venmo/%@", result];
    return components.URL;
}

+ (NSURLComponents *)appSwitchBaseURLComponents {
    NSURLComponents *components = [NSURLComponents componentsWithString:kXCallbackTemplate];
    components.scheme = kVenmoScheme;
    components.percentEncodedPath = @"/vzero/auth";
    return components;
}

@end
