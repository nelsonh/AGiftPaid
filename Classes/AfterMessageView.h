//
//  AfterMessageView.h
//  AGiftPaid
//
//  Created by Nelson on 3/23/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AfterMessageView : UIView {
	
	UITextView *afterMessageTextView;


}

@property (nonatomic, retain) IBOutlet UITextView *afterMessageTextView;


-(void)WriteMessage;
-(void)endWritting;

@end
