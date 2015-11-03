//
//  Orientation.m
//

#import "Orientation.h"

@implementation AppDelegate (Orientation)

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
  UIDeviceOrientation orientation = [Orientation getOrientation];
  switch (orientation) {
    case UIDeviceOrientationPortrait:
      return UIInterfaceOrientationMaskPortrait;
    case UIDeviceOrientationLandscapeLeft:
      return UIInterfaceOrientationMaskLandscape;
    default:
      return UIInterfaceOrientationMaskPortrait;
  }
}

@end


@implementation Orientation

@synthesize bridge = _bridge;

static UIDeviceOrientation _orientation = UIDeviceOrientationPortrait;

+ (void)setOrientation: (UIDeviceOrientation)orientation {
  NSNumber *value = [NSNumber numberWithInt:orientation];
  [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
  [UIViewController attemptRotationToDeviceOrientation];
  _orientation = orientation;
}

+ (int)getOrientation {
  return _orientation;
}

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

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(getOrientation:(RCTResponseSenderBlock)callback)
{
  UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
  NSString *orientationStr = [self getOrientationStr:orientation];
  callback(@[[NSNull null], orientationStr]);
}

RCT_EXPORT_METHOD(lockToPortrait)
{
  NSLog(@"Locked to Portrait");
  [Orientation setOrientation:UIDeviceOrientationPortrait];
//  AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//  delegate.orientation = 1;

}

RCT_EXPORT_METHOD(lockToLandscape)
{
  NSLog(@"Locked to Landscape");
  [Orientation setOrientation:UIDeviceOrientationLandscapeLeft];
//  AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//  delegate.orientation = 2;

}

@end
