//
//  AccelerometerActions.h
//  AccelActions
//
//  Created by Antonio Cabezuelo Vivo on 23/11/08.
//  Copyright 2008 Taps and Swipes. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AccelerometerActionsValue;

// Types of accions tha the library wil send to the delegate
typedef enum {
	AccelerometerActionMoveToLeft,
	AccelerometerActionMoveToRight,
	AccelerometerActionMoveUp,
	AccelerometerActionMoveDown,
	AccelerometerActionRotateToLeft,
	AccelerometerActionRotateToRight,
	AccelerometerActionShake,
} AccererometerAction;


// This is the protocol tha the delegates must conform to 
@protocol AccelerometerActionsDelegate
- (void) devicePerformedAccelerometerAction:(AccererometerAction)theAction; 
@end

@interface AccelerometerActions : NSObject <UIAccelerometerDelegate> {
	id <AccelerometerActionsDelegate> delegate;
	UIAccelerationValue accelerations[3];
	AccelerometerActionsValue *minmaxvalues[3][2];
	BOOL detecting;
	NSTimeInterval waitingSince;
}

@property (nonatomic, assign) id <AccelerometerActionsDelegate> delegate;

+ (AccelerometerActions *) sharedAccelerometerActions;
- (void) startSendingActions;
- (void) stopSendingActions;

@end
