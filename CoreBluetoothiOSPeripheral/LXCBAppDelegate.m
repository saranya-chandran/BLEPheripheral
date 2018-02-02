#import "LXCBAppDelegate.h"
#import "LXCBPeripheralServer.h"
#import "LXCBViewController.h"

@interface LXCBAppDelegate () <LXCBPeripheralServerDelegate,CBPeripheralDelegate>
{
    LXCBPeripheralServer *server;
}
@property (nonatomic, strong) LXCBPeripheralServer *peripheral;
@property (nonatomic, strong) LXCBViewController *viewController;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSString *selectedString;

@end

@implementation LXCBAppDelegate

//- (void)attachUserInterface {
//  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//  self.window.backgroundColor = [UIColor whiteColor];
//
//  self.viewController = [[LXCBViewController alloc] init];
//  self.window.rootViewController = self.viewController;
//
//  [self.window makeKeyAndVisible];
//
//}


- (BOOL)application:(UIApplication *)application
        didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // If the application is in the background state, then we have been
  // woken up because of a bluetooth event. Otherwise, we can initialize the
  // UI.
  NSLog(@"didFinishedLaunching: %@", launchOptions);
  if (application.applicationState != UIApplicationStateBackground) {
//    [self attachUserInterface];
  }

    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    
    LXCBViewController *viewController = (LXCBViewController *)[storyboard instantiateViewControllerWithIdentifier:@"LXCBViewController"];
    
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    
    [self removeAllObject:@"selectedItem"];
  return YES;
}


-(void)saveToUserDefaults:(NSString*)str
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setObject:str forKey:@"selectedItem"];
    [standardUserDefaults synchronize];
}

- (NSString*)getSelectedItemDetails
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [standardUserDefaults valueForKey:@"selectedItem"];
    return str;
}

-(void)removeAllObject:(NSString *)keyValue
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MyKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  [self.peripheral applicationDidEnterBackground];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  if (!self.window) {
//    [self attachUserInterface];
  }
  [self.peripheral applicationWillEnterForeground];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
  NSLog(@"Application terminating");
  // Cry for help.
  UILocalNotification *notification = [[UILocalNotification alloc] init];
  notification.alertBody = @"I'm dying!";
  notification.alertAction = @"Rescue";
  notification.fireDate = [NSDate date];
  [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

#pragma mark - LXCBPeripheralServerDelegate

- (void)peripheralServer:(LXCBPeripheralServer *)peripheral centralDidSubscribe:(CBCentral *)central {
  [self.peripheral sendToSubscribers:[@"Testing WSP" dataUsingEncoding:NSUTF8StringEncoding]];

  [self.viewController centralDidConnect];
}

- (void)peripheralServer:(LXCBPeripheralServer *)peripheral centralDidUnsubscribe:(CBCentral *)central {
  [self.viewController centralDidDisconnect];

}

@end
