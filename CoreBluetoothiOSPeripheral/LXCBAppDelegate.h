#import <UIKit/UIKit.h>
//#define DELEGATE (LXCBAppDelegate *)[[UIApplication sharedApplication]delegate]

@interface LXCBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

-(void)saveToUserDefaults:(NSString*)str;
- (NSString*)getSelectedItemDetails;

-(void)insertData;

@end
