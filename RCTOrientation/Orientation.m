#import "Orientation.h"

@implementation AppDelegate (Orientation)

- (NSUInteger)application:(UIApplication *)application
    supportedInterfaceOrientationsForWindow:(UIWindow *)window {
  UIInterfaceOrientation orientation = [Orientation orientation];
  switch (orientation) {
    case UIInterfaceOrientationPortrait:
      return UIInterfaceOrientationMaskPortrait;
    case UIInterfaceOrientationLandscapeLeft:
      return UIInterfaceOrientationMaskLandscape;
    default:
      return UIInterfaceOrientationMaskPortrait;
  }
}

@end

@implementation Orientation

@synthesize bridge = _bridge;

static int _orientation = UIInterfaceOrientationPortrait;

+ (void)setOrientation:(UIInterfaceOrientation)orientation {
  _orientation = orientation;

  dispatch_async(dispatch_get_main_queue(), ^{
    NSNumber *value = [NSNumber numberWithInt:orientation];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    [UIViewController attemptRotationToDeviceOrientation];
  });
}

+ (UIInterfaceOrientation)orientation {
  return _orientation;
}

- (instancetype)init {
  if ((self = [super init])) {
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(deviceOrientationDidChange:)
               name:@"UIDeviceOrientationDidChangeNotification"
             object:nil];
  }
  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
  UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
  NSString *orientationStr = [self getOrientationStr:orientation];

  [self.bridge.eventDispatcher
      sendDeviceEventWithName:@"orientationDidChange"
                         body:@{
                           @"orientation" : orientationStr
                         }];
}

- (NSString *)getOrientationStr:(UIDeviceOrientation)orientation {
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

RCT_EXPORT_METHOD(lockToPortrait) {
  NSLog(@"Locked to Portrait");
  [Orientation setOrientation:UIInterfaceOrientationPortrait];
}

RCT_EXPORT_METHOD(lockToLandscape) {
  NSLog(@"Locked to Landscape");
  [Orientation setOrientation:UIInterfaceOrientationLandscapeLeft];
}

@end
