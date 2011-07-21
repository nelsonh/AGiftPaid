//
//  Class.h
//  AGiftPaid
//
//  Created by JamesC on 2011/7/14.
//  Copyright 2011年 aSQUARE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AGiftWebService.h"
#import "GiftHistoryInfo.h"

@interface SendGift : UIViewController <UIAlertViewDelegate, AGiftWebServiceDelegate>{
	
	UIButton *sendGiftButton;
    UIView *sendingGiftView;
	GiftHistoryInfo *historyInfo;
	UIAlertView *sendSuccessAlert;
	UIImageView *naviTitleView;
}

@property (nonatomic, retain) IBOutlet UIButton *sendGiftButton;
@property (nonatomic, retain) IBOutlet UIView *sendingGiftView;
@property (nonatomic, retain) GiftHistoryInfo *historyInfo;
@property (nonatomic, retain) UIAlertView *sendSuccessAlert;
@property (nonatomic, retain) UIImageView *naviTitleView;

-(IBAction)sendGiftButtonPressed:(id)sender;

-(void)sendGiftOut;

@end
