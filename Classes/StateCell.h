//
//  StateCell.h
//  AGiftPaid
//
//  Created by Nelson on 5/11/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StateCell : UITableViewCell {
	
	UILabel *sentTimeLabel;
	UILabel *receiveTimeLabel;
	UILabel *openedTimeLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *sentTimeLabel;
@property (nonatomic, retain) IBOutlet UILabel *receiveTimeLabel;
@property (nonatomic, retain) IBOutlet UILabel *openedTimeLabel;

@end
