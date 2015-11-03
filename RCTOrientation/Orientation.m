//
//  Orientation.m
//

#import "Orientation.h"

@implementation Orientation

@synthesize bridge = _bridge;

- (instancetype)init {
  if ((self = [super init])) {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
  }
  return self;

}


- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {

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

RCT_EXPORT_MODULE();


RCT_EXPORT_METHOD(lockToPortrait)
{
  NSLog(@"Locked to Portrait");
  dispatch_async (dispatch_get_main_queue(), ^{
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    [UIViewController attemptRotationToDeviceOrientation];
  });
}

RCT_EXPORT_METHOD(lockToLandscape)
{
  NSLog(@"Locked to Landscape");
  dispatch_async (dispatch_get_main_queue(), ^{
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    [UIViewController attemptRotationToDeviceOrientation];
  });
}


@end
