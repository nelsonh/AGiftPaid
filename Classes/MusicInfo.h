//
//  MusicInfo.h
//  AGiftPaid
//
//  Created by Nelson on 3/23/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kImageSize 64

@class MusicImageView;

@interface MusicInfo : NSObject {
	
	//music url
	NSString *musicURL;
	
	//music file name
	NSString *musicFileName;
	
	//number
	NSUInteger musicNumber;
	
	//is downloading icon
	BOOL isDownloadingMusic;
	
	//music data append
	NSMutableData *musicData;
	
	//music icon presenter
	MusicImageView *musicIconPresenter;
	
	//music name prefix
	NSString *musicPrefix;

}

@property (nonatomic, assign) NSUInteger musicNumber;
@property (nonatomic, retain) NSString *musicURL;
@property (nonatomic, retain) NSString *musicFileName;
@property (nonatomic, assign) BOOL isDownloadingMusic;
@property (nonatomic, retain) NSMutableData *musicData;
@property (nonatomic, assign) MusicImageView *musicIconPresenter;
@property (nonatomic, retain) NSString *musicPrefix;

-(void)assignNumber:(NSUInteger)number;
-(void)assignMusicFileName:(NSString*)fileName;
-(void)downloadMusic;


@end
