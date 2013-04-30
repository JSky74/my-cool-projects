//
//  MotivationAppDelegate.m
//  Motivation
//
//  Created by Jasko Demirovic on 2013-01-04.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//
#import "MotivationCVC.h"
#import "MotivationAppDelegate.h"
#import <CoreData/CoreData.h>

@interface MotivationAppDelegate ()
@property MotivationCVC *rootViewController;
@end



@implementation MotivationAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self checkiCloudAccess];
    
    if ([self.window.rootViewController isKindOfClass:[MotivationCVC class]])
    {
        _rootViewController = (MotivationCVC *) self.window.rootViewController;
        [self.rootViewController setDocument:[DocumentManager useMotivationDocument]];

        ;
    
}
    return YES;
}

    
- (void)checkiCloudAccess {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([[NSFileManager defaultManager]
             URLForUbiquityContainerIdentifier:nil] != nil)
        {
            NSLog(@"iCloud is available\n");
            id currentToken = [[NSFileManager defaultManager] ubiquityIdentityToken];
            if (currentToken != nil)
                NSLog(@"User is signed in\n");
       
        }
        else
        {
            NSLog(@"iCloud is not available.\n");
            exit(-1);
        }
        });
    
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
   
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
   if ([self.window.rootViewController isKindOfClass:[MotivationCVC class]])
       {
           
           _rootViewController = (MotivationCVC *) self.window.rootViewController;
           
                    
       }
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
     
    NSManagedObjectContext *mainThreadMOC = ((MotivationCVC *) self.window.rootViewController).context;
    [mainThreadMOC performBlock:^{
        if ([mainThreadMOC hasChanges]) {
            NSError *error = nil;
            if (![mainThreadMOC save:&error]) {
                NSLog(@"Error saving: %@", error);
                abort();
            }
        }
    }];

}

@end
