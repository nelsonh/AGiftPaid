//
//  FriendInfo.h
//  AGiftPaid
//
//  Created by Nelson on 3/24/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AGiftWebService.h"

#define kImageSize 64

@class FriendImageView;

@interface FriendInfo : NSObject <AGiftWebServiceDelegate>{
	
	//friend photo url
	NSString *friendPhotoURL;
	
	//friend id
	NSString *friendID;
	
	//friend name
	NSString *friendName;
	
	//friend photo data
	NSMutableData *friendPhotoData;
	
	//friend icon presenter
	FriendImageView *friendIconPresenter;

}

@property (nonatomic, retain) NSString *friendPhotoURL;
@property (nonatomic, retain) NSString *friendID;
@property (nonatomic, retain) NSString *friendName;
@property (nonatomic, retain) FriendImageView *friendIconPresenter;
@property (nonatomic, retain) NSMutableData *friendPhotoData;


-(void)assignFriendName:(NSString*)name;
-(void)assignFriendPhotoData:(NSData*)photoData;
-(void)downloadFriendPhoto;
-(void)updateFriendInfo;
-(void)shouldDisplay;
-(void)showPhoto;
-(void)hidePhoto;

@end
