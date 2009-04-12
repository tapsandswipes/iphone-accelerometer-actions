//
//  AccelActionsAppDelegate.h
//  AccelActions
//
//  Created by Antonio Cabezuelo Vivo on 23/11/08.
//  Copyright Taps and Swipes 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AccelActionsAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    RootViewController *rootViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;

@end

