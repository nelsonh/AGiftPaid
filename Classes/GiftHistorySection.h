//
//  GiftHistorySection.h
//  AGiftPaid
//
//  Created by Nelson on 3/28/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultiTaskProtocol.h"
#import "HistoryDetailController.h"
#import "HistoryHintController.h"

#define kTableCellHeight 70

@class GiftHistoryInfo;
@class UpdateHistoryView;

@interface GiftHistorySection : UIViewController <UITableViewDelegate, UITableViewDataSource, MultiTaskProtocol>{
	
	UITableView *table;
	UpdateHistoryView *updateView;
	UIView *gestureView;
	UIButton *hintButton;
	HistoryHintController *hintController;
	
	
	//contain GiftHistoryInfo
	NSMutableArray *tableSourceData;
	HistoryDetailController *detailController;

}

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) IBOutlet UpdateHistoryView *updateView;
@property (nonatomic, retain) IBOutlet UIButton *hintButton;
@property (nonatomic, retain) IBOutlet HistoryHintController *hintController;
@property (nonatomic, retain) UIView *gestureView;
@property (nonatomic, retain) NSMutableArray *tableSourceData;
@property (nonatomic, retain) HistoryDetailController *detailController;

-(IBAction)hintButtonPress;

-(void)reloadSourceData;
-(void)updateViewSlideIn;
-(void)updateViewSlideOut;
-(void)deleteTableCell:(UITableViewCell*)inCell;
-(void)disableHint;

@end
