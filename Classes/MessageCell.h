//
//  MessageCell.h
//  AGiftPaid
//
//  Created by Nelson on 5/11/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MessageCell : UITableViewCell {
	
	UILabel *onGiftBoxLabel;
	UILabel *onGiftLabel;

}

@property (nonatomic, retain) IBOutlet UILabel *onGiftBoxLabel;
@property (nonatomic, retain) IBOutlet UILabel *onGiftLabel;

@end
