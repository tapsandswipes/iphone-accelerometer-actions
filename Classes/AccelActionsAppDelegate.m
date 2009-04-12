//
//  AccelActionsAppDelegate.m
//  AccelActions
//
//  Created by Antonio Cabezuelo Vivo on 23/11/08.
//  Copyright Taps and Swipes 2008. All rights reserved.
//

#import "AccelActionsAppDelegate.h"
#import "RootViewController.h"

@implementation AccelActionsAppDelegate


@synthesize window;
@synthesize rootViewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
    [window addSubview:[rootViewController view]];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [rootViewController release];
    [window release];
    [super dealloc];
}

@end
