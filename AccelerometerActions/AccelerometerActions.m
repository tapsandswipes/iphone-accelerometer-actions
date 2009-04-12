//
//  AccelerometerActions.m
//  AccelActions
//
//  Created by Antonio Cabezuelo Vivo on 23/11/08.
//  Copyright 2008 Taps and Swipes. All rights reserved.
//

#import "AccelerometerActions.h"
#import "AccelerometerActionsValue.h"

// Constant for the number of times per second (Hertz) to sample acceleration.
#define kAccelerometerFrequency     40
// Constant for maximum acceleration.
#define kMaxAcceleration 3.0
// Constant for the high-pass filter.
#define kFilteringFactor 0.1

// Constant for the waiting value for sending movements
#define kWaitTime 0.5

static AccelerometerActions *sharedAccelerometerActions = nil;

@interface AccelerometerActions ()
  @property (nonatomic) BOOL detecting;
@end

@interface AccelerometerActions (PrivateMethods)
  - (void) clearMinAndMaxValues;
  - (void) sendActionToDelegate:(AccererometerAction)theAction;
  - (void) computeMinAndMaxValuesForIndex:(NSInteger)index forValue:(UIAccelerationValue)theValue timestamp:(NSTimeInterval)theTimestamp;
@end

@implementation AccelerometerActions
@synthesize delegate;
@synthesize detecting;

#pragma mark Singleton methods
+ (AccelerometerActions *) sharedAccelerometerActions {
	@synchronized(self) {
        if (sharedAccelerometerActions == nil) {
            [[self alloc] init]; // assignment not done here
        }
    }
	
	return sharedAccelerometerActions;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (sharedAccelerometerActions == nil) {
            sharedAccelerometerActions = [super allocWithZone:zone];
            return sharedAccelerometerActions;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

- (id) init {
	if (self = [super init]) {
        // Initialization code
		self.detecting = NO;
    }
    return self;
	
}

#pragma mark control methods

- (void) startSendingActions {
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / kAccelerometerFrequency)];
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
	detecting = YES;
}

- (void) stopSendingActions {
	detecting = NO;
	[[UIAccelerometer sharedAccelerometer] setDelegate:nil];
}


#define Xmax minmaxvalues[0][0].value
#define Xmin minmaxvalues[0][1].value
#define Ymax minmaxvalues[1][0].value
#define Ymin minmaxvalues[1][1].value
#define Zmax minmaxvalues[2][0].value
#define Zmin minmaxvalues[2][1].value
#define XmaxT minmaxvalues[0][0].timestamp
#define XminT minmaxvalues[0][1].timestamp
#define YmaxT minmaxvalues[1][0].timestamp
#define YminT minmaxvalues[1][1].timestamp
#define ZmaxT minmaxvalues[2][0].timestamp
#define ZminT minmaxvalues[2][1].timestamp

// UIAccelerometerDelegate method, called when the device accelerates.
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
	double x,y,z;
	if (!detecting) return;

	if (waitingSince > 0.0) {
		waitingSince -= (1.0 / kAccelerometerFrequency);
		[self clearMinAndMaxValues];
	} else {
		// apply a basic high-pass filter to remove the gravity influence from the accelerometer values
		accelerations[0] = acceleration.x * kFilteringFactor + accelerations[0] * (1.0 - kFilteringFactor);
		accelerations[1] = acceleration.y * kFilteringFactor + accelerations[1] * (1.0 - kFilteringFactor);
		accelerations[2] = acceleration.z * kFilteringFactor + accelerations[2] * (1.0 - kFilteringFactor);
		
		x = acceleration.x-accelerations[0];
		y = acceleration.y-accelerations[1];
		z = acceleration.z-accelerations[2];
		
		// if the device is stable look for the last accion performed and send it
		if (fabs(x) < 0.1 && fabs(y) < 0.1 && fabs(z) < 0.1) {
			if ( fabs(Xmax - Xmin) > 2.0 && fabs(Ymax - Ymin) > 1.0 && fabs(Zmax - Zmin) > 1.0 ) {
				[self sendActionToDelegate:AccelerometerActionShake];
			} else if (Zmax > fabs(Zmin) && fabs(Zmax - Zmin) > 1.5 && ZmaxT > ZminT) {
				[self sendActionToDelegate:AccelerometerActionMoveUp];
			} else if (Zmax < fabs(Zmin) && fabs(Zmax - Zmin) > 1.5 && ZmaxT < ZminT) { 
				[self sendActionToDelegate:AccelerometerActionMoveDown];
			} else if (fabs(Xmax - Xmin) > 1.0 && XmaxT < XminT && fabs(Xmin) > 0.8) {
				[self sendActionToDelegate:AccelerometerActionMoveToLeft];
			} else if (fabs(Xmax - Xmin) > 1.0 && XmaxT > XminT) {
				[self sendActionToDelegate:AccelerometerActionMoveToRight];
			} else if (fabs(Xmax - Xmin) > 0.4 && Xmax < 0.3 && fabs(Zmax - Zmin) > 0.2) {
				[self sendActionToDelegate:AccelerometerActionRotateToLeft];
			} else if (fabs(Xmax - Xmin) > 0.4 && Xmin > -0.3 && fabs(Zmax - Zmin) > 0.2) {
				[self sendActionToDelegate:AccelerometerActionRotateToRight];
			}
		} else {
			[self computeMinAndMaxValuesForIndex:0 forValue:x timestamp:acceleration.timestamp];
			[self computeMinAndMaxValuesForIndex:1 forValue:y timestamp:acceleration.timestamp];
			[self computeMinAndMaxValuesForIndex:2 forValue:z timestamp:acceleration.timestamp];
		}
	}
}


- (void) computeMinAndMaxValuesForIndex:(NSInteger)index forValue:(UIAccelerationValue)theValue timestamp:(NSTimeInterval)theTimestamp {
	// Compute max value
	if (minmaxvalues[index][0] == nil) {
		minmaxvalues[index][0] = [[AccelerometerActionsValue alloc] initWithValue:theValue timestamp:theTimestamp];
	} else if (minmaxvalues[index][0].value < theValue) {
		[minmaxvalues[index][0] release];
		minmaxvalues[index][0] = [[AccelerometerActionsValue alloc] initWithValue:theValue timestamp:theTimestamp];
	}
	// Compute min value
	if (minmaxvalues[index][1] == nil) {
		minmaxvalues[index][1] = [[AccelerometerActionsValue alloc] initWithValue:theValue timestamp:theTimestamp];
	} else if (minmaxvalues[index][1].value > theValue) {
		[minmaxvalues[index][1] release];
		minmaxvalues[index][1] = [[AccelerometerActionsValue alloc] initWithValue:theValue timestamp:theTimestamp];
	}
}

- (void) clearMinAndMaxValues {
	if (minmaxvalues[0][0] != nil) { 
		[minmaxvalues[0][0] release];
		minmaxvalues[0][0] = nil;
	}
	if (minmaxvalues[0][1] != nil) { 
		[minmaxvalues[0][1] release];
		minmaxvalues[0][1] = nil;
	}
	if (minmaxvalues[1][0] != nil) { 
		[minmaxvalues[1][0] release];
		minmaxvalues[1][0] = nil;
	}
	if (minmaxvalues[1][1] != nil) { 
		[minmaxvalues[1][1] release];
		minmaxvalues[1][1] = nil;
	}
	if (minmaxvalues[2][0] != nil) { 
		[minmaxvalues[2][0] release];
		minmaxvalues[2][0] = nil;
	}
	if (minmaxvalues[2][1] != nil) { 
		[minmaxvalues[2][1] release];
		minmaxvalues[2][1] = nil;
	}
}

- (void) sendActionToDelegate:(AccererometerAction)theAction {
	if (delegate != nil) {
		waitingSince = kWaitTime;
		[delegate devicePerformedAccelerometerAction:theAction];
	}
}

@end
