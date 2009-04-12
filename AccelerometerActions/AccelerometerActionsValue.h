//
//  AccelerometerActionsValue.h
//  AccelActions
//
//  Created by Antonio Cabezuelo Vivo on 24/11/08.
//  Copyright 2008 Taps and Swipes. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AccelerometerActionsValue : NSObject {
	UIAccelerationValue value;
	NSTimeInterval timestamp;
}

@property(nonatomic, readonly) UIAccelerationValue value;
@property(nonatomic, readonly) NSTimeInterval timestamp;

- (id) initWithValue:(UIAccelerationValue)theValue timestamp:(NSTimeInterval)theTimestamp;

@end