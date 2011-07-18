//
//  HistoryTableCell.h
//  AGiftPaid
//
//  Created by Nelson on 3/28/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiftHistoryInfo.h"

@interface HistoryTableCell : UITableViewCell {
	
	UILabel *receiverNameLabel;
	UILabel *sendDateLabel;
	UIImageView *giftStatusImageView;
	UIImageView *canOpenTimeStatusImageView;
	UIButton *cancelGiftButton;
	UIButton *deleteGiftButton;
	UIActivityIndicatorView *updatingIndicator;
	
	NSIndexPath *index;
	GiftHistoryInfo *historyInfo;

}

@property (nonatomic, retain) IBOutlet UILabel *receiverNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *sendDateLabel;
@property (nonatomic, retain) IBOutlet UIImageView *giftStatusImageView;
@property (nonatomic, retain) IBOutlet UIImageView *canOpenTimeStatusImageView;
@property (nonatomic, retain) IBOutlet UIButton *cancelGiftButton;
@property (nonatomic, retain) IBOutlet UIButton *deleteGiftButton;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *updatingIndicator;
@property (nonatomic, assign) GiftHistoryInfo *historyInfo;
@property (nonatomic, assign) NSIndexPath *index;


-(IBAction)cancelGiftButtonPressed;
-(IBAction)deleteGiftButtonPressed;


@end
