//
//  MainViewController.m
//  AccelActions
//
//  Created by Antonio Cabezuelo Vivo on 23/11/08.
//  Copyright Taps and Swipes 2008. All rights reserved.
//

#import "MainViewController.h"
#import "MainView.h"

@interface MainViewController (PrivateMethods)

- (void) clearLabel:(NSTimer*)theTimer;

@end


@implementation MainViewController

@synthesize infoLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
	[[AccelerometerActions sharedAccelerometerActions] setDelegate:self];
	[[AccelerometerActions sharedAccelerometerActions] startSendingActions];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


- (void) devicePerformedAccelerometerAction:(AccererometerAction)theAction {
	switch (theAction) {
		case AccelerometerActionMoveToLeft:
			infoLabel.text = @"Moved to the left";
			break;
		case AccelerometerActionMoveToRight:
			infoLabel.text = @"Moved to the right";
			break;
		case AccelerometerActionMoveUp:
			infoLabel.text = @"Moved up";
			break;
		case AccelerometerActionMoveDown:
			infoLabel.text = @"Moved down";
			break;
		case AccelerometerActionRotateToLeft:
			infoLabel.text = @"Rotated to the left";
			break;
		case AccelerometerActionRotateToRight:
			infoLabel.text = @"Rotated to the right";
			break;
		case AccelerometerActionShake:
			infoLabel.text = @"Shaked";
			break;
		default:
			infoLabel.text = @"Unknown action";
			break;
	}
	[NSTimer scheduledTimerWithTimeInterval: 0.5 target:self selector:@selector(clearLabel:) userInfo:nil repeats:NO];
}

- (void) clearLabel:(NSTimer*)theTimer {
	infoLabel.text = @"No action";
}

@end
