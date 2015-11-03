//
//  Orientation.m
//

#import "Orientation.h"

@implementation AppDelegate (Orientation)

@end


@implementation Orientation

- (instancetype)init
{
  if ((self = [super init])) {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
  }
  return self;

}


- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)deviceOrientationDidChange:(NSNotification *)notification
{

  UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
  NSString *orientationStr = [self getOrientationStr:orientation];

  [self.bridge.eventDispatcher sendDeviceEventWithName:@"orientationDidChange"
                                              body:@{@"orientation": orientationStr}];
}

- (NSString *)getOrientationStr: (UIDeviceOrientation)orientation {
  NSString *orientationStr;
  switch (orientation) {
    case UIDeviceOrientationPortrait:
    case UIDeviceOrientationPortraitUpsideDown:
      orientationStr = @"PORTRAIT";
      break;
    case UIDeviceOrientationLandscapeLeft:
    case UIDeviceOrientationLandscapeRight:

      orientationStr = @"LANDSCAPE";
      break;
    default:
      orientationStr = @"UNKNOWN";
      break;
  }
  return orientationStr;
}

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(lockToPortrait)
{
  NSLog(@"Locked to Portrait");
  [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
}

RCT_EXPORT_METHOD(lockToLandscape)
{
  NSLog(@"Locked to Landscape");
  [[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationLandscapeLeft animated:YES];
}

@end
