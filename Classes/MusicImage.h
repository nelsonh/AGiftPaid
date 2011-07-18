//
//  MusicImage.h
//  AGiftPaid
//
//  Created by Nelson on 3/23/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MusicImageView;

@interface MusicImage : UIImageView {

	MusicImageView *owner;
}

@property (nonatomic, retain) MusicImageView *owner;

@end
