//
//  OpenTimeCell.h
//  AGiftPaid
//
//  Created by Nelson on 5/11/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OpenTimeCell : UITableViewCell {
	
	UILabel *openedDateLabel;
	UILabel *openedTimeLabel;

}

@property (nonatomic, retain) IBOutlet UILabel *openedDateLabel;
@property (nonatomic, retain) IBOutlet UILabel *openedTimeLabel;

@end
