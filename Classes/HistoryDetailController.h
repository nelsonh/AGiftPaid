//
//  HistoryDetailController.h
//  AGiftPaid
//
//  Created by Nelson on 5/11/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GiftHistoryInfo.h"
#import "MessageDetailController.h"

@interface HistoryDetailController : UIViewController <UITableViewDataSource, UITableViewDelegate, AGiftWebServiceDelegate>{
	
	UIImageView *receiverImageView;
	UILabel *receiverNameLabel;
	UILabel *receiverPhoneNumberLabel;
	UIButton *dismissButton;
	UITableView *table;
	MessageDetailController *messageController;
	GiftHistoryInfo *giftHistoryInfo;
	UIActivityIndicatorView *loadingActivity;
	UILabel *loadingLabel;
	UIImageView *smallIcon;
	
	//contain multiple cells
	NSMutableArray *tableCellArray;
}

@property (nonatomic, retain) IBOutlet UIImageView *receiverImageView;
@property (nonatomic, retain) IBOutlet UILabel *receiverNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *receiverPhoneNumberLabel;
@property (nonatomic, retain) IBOutlet UIButton *dismissButton;
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingActivity;
@property (nonatomic, retain) IBOutlet UILabel *loadingLabel;
@property (nonatomic, retain) IBOutlet UIImageView *smallIcon;
@property (nonatomic, retain) NSMutableArray *tableCellArray;
@property (nonatomic, retain) MessageDetailController *messageController;
@property (nonatomic, retain) GiftHistoryInfo *giftHistoryInfo;

-(IBAction)dismissButtonPressed;
-(void)loadHistoryInfo;
-(void)beforeMsgDidTap;
-(void)afterMsgDidTap;

@end
