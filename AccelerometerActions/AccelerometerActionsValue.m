//
//  AccelerometerActionsValue.m
//  AccelActions
//
//  Created by Antonio Cabezuelo Vivo on 24/11/08.
//  Copyright 2008 Taps and Swipes. All rights reserved.
//

#import "AccelerometerActionsValue.h"


@implementation AccelerometerActionsValue

@synthesize value;
@synthesize timestamp;

- (id) initWithValue:(UIAccelerationValue)theValue timestamp:(NSTimeInterval)theTimestamp {
	if (self = [super init]) {
        // Initialization code
		value = theValue;
		timestamp = theTimestamp;
    }
    return self;
}

@end
