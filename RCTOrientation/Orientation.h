#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RCTBridgeModule.h"
#import "RCTBridge.h"
#import "RCTEventDispatcher.h"
#import "AppDelegate.h"

@interface Orientation : NSObject<RCTBridgeModule>
+ (void)setOrientation:(UIInterfaceOrientation)orientation;
+ (UIInterfaceOrientation)orientation;
@end

@interface AppDelegate (Orientation)

@end
