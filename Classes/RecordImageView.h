//
//  RecordImageView.h
//  AGiftPaid
//
//  Created by Nelson on 4/18/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordImage.h"
#import "RecordImageFront.h"

@class MusicGalleryScrollView;
@class MusicSelectionController;

@interface RecordImageView : UIView {
	
	MusicGalleryScrollView *owner;
	MusicSelectionController *mainController;
	
	RecordImage *recordImagePresenter;
	
	RecordImageFront *frontImage;
	
	//music name label
	UILabel *recordNameLabel;
	
	BOOL isSelected;
	
	//index
	NSUInteger index;

}

@property (nonatomic, assign) MusicGalleryScrollView *owner;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) MusicSelectionController *mainController;
@property (nonatomic, retain) RecordImage *recordImagePresenter;
@property (nonatomic, retain) RecordImageFront *frontImage;
@property (nonatomic, retain) UILabel *recordNameLabel;
@property (nonatomic, assign) NSUInteger index;


-(void)didSelected;
-(void)deSelected;
-(void)destroy;

@end
