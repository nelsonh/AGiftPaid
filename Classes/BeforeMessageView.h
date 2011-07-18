//
//  BeforeMessageView.h
//  AGiftPaid
//
//  Created by Nelson on 3/23/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BeforeMessageView : UIView {
	
	UITextView *beforeMessageTextView;


}

@property (nonatomic, retain) IBOutlet UITextView *beforeMessageTextView;


-(void)WriteMessage;
-(void)endWritting;

@end
