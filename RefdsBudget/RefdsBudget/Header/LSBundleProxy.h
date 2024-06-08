#import <Foundation/Foundation.h>

@interface LSBundleProxy: NSObject

+ (nonnull LSApplicationProxy *)bundleProxyForCurrentProcess;

@end
