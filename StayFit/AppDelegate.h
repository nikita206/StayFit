//
//  AppDelegate.h
//  StayFit
//
//  Created by Nikita Agarwal on 7/8/22.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import <CoreData/CoreData.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>
@property (readonly, strong) NSPersistentContainer *persistentContainer;
- (void)saveContext;

@end

