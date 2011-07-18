//
//  RecordImageFront.h
//  AGiftPaid
//
//  Created by Nelson on 4/18/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RecordImageView;

@interface RecordImageFront : UIView {
	
	RecordImageView *owner;

}

@property (nonatomic, retain) RecordImageView *owner;

-(void)deSelected;
-(void)doSelected;

@end
