#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RCTBridgeModule.h"
#import "RCTBridge.h"
#import "RCTEventDispatcher.h"

@interface Orientation : NSObject<RCTBridgeModule>
+ (void)setOrientation:(UIInterfaceOrientation)orientation;
+ (UIInterfaceOrientation)orientation;
@end
