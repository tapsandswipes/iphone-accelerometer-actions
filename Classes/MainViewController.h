//
//  MainViewController.h
//  AccelActions
//
//  Created by Antonio Cabezuelo Vivo on 23/11/08.
//  Copyright Taps and Swipes 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccelerometerActions.h"

@interface MainViewController : UIViewController <AccelerometerActionsDelegate> {
	UILabel *infoLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *infoLabel;

@end
