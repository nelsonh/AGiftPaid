//
//  RecordImage.h
//  AGiftPaid
//
//  Created by Nelson on 4/18/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@class RecordImageView;

@interface RecordImage : UIImageView {
	
	RecordImageView *owner;

}

@property (nonatomic, retain) RecordImageView *owner;

@end
