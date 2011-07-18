//
//  AGiftWebService.h
//  AGiftFree
//
//  Created by Nelson on 3/7/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SoapRequest.h"

@protocol AGiftWebServiceDelegate;

@class SDZaGiftService;
@class FriendInfo;
@class SendGiftInfo;

@interface AGiftWebService : NSOperation {
	
	SDZaGiftService *webService;
	SoapRequest *currentRequest;
	id<AGiftWebServiceDelegate> delegate;

}

@property (nonatomic, retain) SDZaGiftService *webService;
@property (nonatomic, assign) SoapRequest *currentRequest;
@property (nonatomic, retain) id<AGiftWebServiceDelegate> delegate;

-(id)initAGiftWebService;
-(BOOL)cancelCurrentRequest;
-(BOOL)retrieveAuthorizedKeyWithUsername:(NSString*)username Password:(NSString*)password;
-(void)retrieveAuthorizedKeyRespond:(NSString*)jsonPackage;
-(BOOL)registerWithPhoneNumber:(NSString*)phoneNumber userName:(NSString*)username profilePhoto:(NSData*)photo deviceID:(NSString*)udid;
-(void)registerRespond:(NSString*)jsonPackage;
-(BOOL)editProfileWithPhoneNumber:(NSString*)phoneNumber userName:(NSString*)username profilePhoto:(NSData*)photo;
-(void)editProfileRespond:(NSString*)jsonPackage;
-(BOOL)ReceiveNewGiftList:(NSString*)phoneNumber;
-(void)ReceiveNewGiftListRespond:(NSString*)jsonPackage;
-(BOOL)ReceiveFirstData:(NSString*)giftID DownloadBox3DObj:(BOOL)objYesOrNo DownloadBoxVideo:(BOOL)videoYesOrNo DownloadGiftIcon:(BOOL)iconYesOrNo;
-(void)ReceiveFirstDataRespond:(NSString*)jsonPackage;
-(BOOL)ReceiveThirdData:(NSString*)giftID DownloadGift3DObj:(BOOL)objYesOrNo DownloadGiftVideo:(BOOL)videoYesOrNo;
-(void)ReceiveThirdDataRespond:(NSString*)jsonPackage;
-(BOOL)setGiftStatusWithGiftID:(NSString*)giftID Status:(NSString*)status;
-(void)setGiftStatusRespond:(NSString*)jsonPackage;
-(BOOL)ReceiveGiftBoxPickerList;
-(void)ReceiveGiftBoxPickerListDataRespond:(NSString*)jsonPackage;
-(BOOL)ReceiveGift3DBoxObject:(NSString*)boxNumber;
-(void)ReceiveGift3DBoxObjectDataRespond:(NSString*)jsonPackage;
-(BOOL)ReceiveGiftPickerList;
-(void)ReceiveGiftPickerListDataRespond:(NSString*)jsonPackage;
-(BOOL)ReceiveGift3DObject:(NSString*)giftNumber;
-(void)ReceiveGift3DObjectDataRespond:(NSString*)jsonPackage;
-(BOOL)ReceiveGiftMusicList;
-(void)ReceiveGiftMusicListDataRespond:(NSString*)jsonPackage;
-(BOOL)addFriend:(NSString*)clientPhoneNumber FriendID:(NSString*)friendID;
-(void)addFriendDataRespond:(NSString*)jsonPackage;
-(BOOL)sendGift:(SendGiftInfo*)giftInfo;
-(void)sendGiftDataRespond:(NSString*)jsonPackage;
-(BOOL)updateGiftStatus:(NSString*)giftID;
-(void)updateGiftStatusDataRespond:(NSString*)jsonPackage;
-(BOOL)cancelGiftWithGiftID:(NSString*)giftID;
-(void)cancelGiftDataRespond:(NSString*)jsonPackage;
-(BOOL)deleteGiftStatus:(NSString*)giftID;
-(void)deleteGiftStatusRespond:(NSString*)jsonPackage;
-(BOOL)userExisted:(NSString*)deviceID;
-(void)userExistedRespond:(NSString*)jsonPackage;
-(BOOL)registerDeviceToken:(NSData*)token phoneNumber:(NSString*)userPhoneNumber;
-(void)registerDeviceTokenRespond:(NSString*)jsonPackage;
-(BOOL)sendPushNotificationToReceiver:(NSString*)receiverID;
-(void)sendPushNotificationToReceiverRespond:(NSString*)jsonPackage;
-(BOOL)trackGiftStatus:(NSString*)giftID;
-(void)trackGiftStatusDataRespond:(NSString*)jsonPackage;
-(BOOL)getGiftBoxVideoUrl:(NSString*)number;
-(void)getGiftBoxVideoUrlRespond:(NSString*)jsonPackage;
-(BOOL)getGiftVideoUrl:(NSString*)number;
-(void)getGiftVideoUrlRespond:(NSString*)jsonPackage;
-(BOOL)getAvailableContactList:(NSMutableArray*)phoneList;
-(void)getAvailableContactListRespond:(NSString*)jsonPackage;

@end


@protocol AGiftWebServiceDelegate

@optional

-(void)aGiftWebService:(AGiftWebService*)webService AuthorizedKeyDictionary:(NSDictionary*)respondData;
-(void)aGiftWebService:(AGiftWebService*)webService RegisterDictionary:(NSDictionary*)respondData;
-(void)aGiftWebService:(AGiftWebService*)webService EditProfileDictionary:(NSDictionary*)respondData;
-(void)aGiftWebService:(AGiftWebService*)webService ReceiveNewGiftsArray:(NSArray*)respondData;
-(void)aGiftWebService:(AGiftWebService*)webService ReceiveFirstDataDictionary:(NSDictionary*)respondData;
-(void)aGiftWebService:(AGiftWebService*)webService ReceiveThirdDataDictionary:(NSDictionary*)respondData;
-(void)aGiftWebService:(AGiftWebService*)webService ReceiveGiftBoxPickerListArray:(NSArray*)respondData;
-(void)aGiftWebService:(AGiftWebService*)webService ReceiveGift3DBoxObjectArray:(NSArray*)respondData;
-(void)aGiftWebService:(AGiftWebService*)webService ReceiveGiftPickerListArray:(NSArray*)respondData;
-(void)aGiftWebService:(AGiftWebService*)webService ReceiveGift3DObjectArray:(NSArray*)respondData;
-(void)aGiftWebService:(AGiftWebService*)webService ReceiveGiftMusicListtArray:(NSArray*)respondData;
-(void)aGiftWebService:(AGiftWebService*)webService addFriendDictionary:(NSDictionary*)respondData;
-(void)aGiftWebService:(AGiftWebService*)webService sendGiftGiftIDDectionary:(NSDictionary*)respondData;
-(void)aGiftWebService:(AGiftWebService*)webService updateGiftStatusStatusDictionary:(NSDictionary*)respondData;
-(void)aGiftWebService:(AGiftWebService*)webService cancelGiftResult:(NSString*)respondData;
-(void)aGiftWebService:(AGiftWebService*)webService userExistedDictionary:(NSDictionary*)respondData;
-(void)aGiftWebService:(AGiftWebService*)webService trackGiftStatusStatusDictionary:(NSDictionary*)respondData;
-(void)aGiftWebService:(AGiftWebService*)webService getGiftBoxVideoUrlString:(NSString*)respondData;
-(void)aGiftWebService:(AGiftWebService*)webService getGiftVideoUrlString:(NSString*)respondData;
-(void)aGiftWebService:(AGiftWebService*)webService getAvailableContactListArray:(NSArray*)respondData;

@end
 