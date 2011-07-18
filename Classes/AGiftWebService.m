//
//  AGiftWebService.m
//  AGiftFree
//
//  Created by Nelson on 3/7/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "AGiftWebService.h"
#import "SDZaGiftService.h"
#import "AGiftPaidAppDelegate.h"
#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"
#import "NSData+Base64.h"
#import "FriendInfo.h"
#import "SendGiftInfo.h"



@implementation AGiftWebService

@synthesize webService;
@synthesize currentRequest;
@synthesize delegate;

-(id)initAGiftWebService
{
	if(self=[super init])
	{
		SDZaGiftService *service=[[SDZaGiftService alloc] init];
		self.webService=service;
		[service release];

	}
	
	return self;
}

-(BOOL)cancelCurrentRequest
{
	return [currentRequest cancel];
}

#pragma mark web service
#pragma mark get Authorized key service and respond
-(BOOL)retrieveAuthorizedKeyWithUsername:(NSString*)username Password:(NSString*)password
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	if([appDelegate isNetworkVaild])
	{
		if(username!=nil && password!=nil)
		{
			
			//request from server
			[appDelegate startNetworkActivity];
			currentRequest=[webService Auth:self action:@selector(retrieveAuthorizedKeyRespond:) username:username passwod:password];
			
			
			return YES;
		}
	}
	else 
	{
		[appDelegate networkConnectionError];
		
		[delegate aGiftWebService:self AuthorizedKeyDictionary:nil];
		
	}
	
	return NO;
}

-(void)retrieveAuthorizedKeyRespond:(NSString*)jsonPackage
{
	NSError *error;
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	[appDelegate stopNetworkActivity];
	
	if(delegate!=nil)
	{
		if([jsonPackage isKindOfClass:[NSError class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@"Service has an error occurred"];
			[delegate aGiftWebService:self AuthorizedKeyDictionary:nil];
			[self cancel];
			return;
		}
		else if([jsonPackage isKindOfClass:[SoapFault class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@" Soap service fault"];
			[delegate aGiftWebService:self AuthorizedKeyDictionary:nil];
			[self cancel];
			return;
		}
		
		
		
		//deserialize
		NSData *jsonData=[jsonPackage dataUsingEncoding:NSUTF32BigEndianStringEncoding];
		NSDictionary *deserializedData=[[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
		
		
		[delegate aGiftWebService:self AuthorizedKeyDictionary:deserializedData];
	}
	
	[self cancel];
}

#pragma mark register service and respond
-(BOOL)registerWithPhoneNumber:(NSString*)phoneNumber userName:(NSString*)username profilePhoto:(NSData*)photo deviceID:(NSString*)udid
{
	NSError *error;
	
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];

	NSMutableDictionary *dataDictionary=[[[NSMutableDictionary alloc] init] autorelease];
	
	//auth key
	NSString *authKey=appDelegate.userAuthorizedKey;
	

	
	if([appDelegate isNetworkVaild])
	{
		if(authKey!=nil)
		{
			//encoding photo
			NSString *photo64Encoding=[photo base64Encoding];
			
			//fill data
			[dataDictionary setObject:phoneNumber forKey:@"PhoneNumber"];
			
			NSString *userName64=[[username dataUsingEncoding:NSUTF8StringEncoding] base64Encoding];
			[dataDictionary setObject:userName64 forKey:@"UserName"];
			[dataDictionary setObject:@"ProfilePhoto.png" forKey:@"ProfilePhotoName"];
			[dataDictionary setObject:photo64Encoding forKey:@"ProfilePhoto"];
			[dataDictionary setObject:@"IP" forKey:@"KindofPhone"];
			[dataDictionary setObject:udid forKey:@"PhoneDeviceID"];
			
			//DebugLog
			//NSLog(@"%@", photo64Encoding);
			
			//serialize
			NSData *jsonData=[[CJSONSerializer serializer] serializeDictionary:dataDictionary error:&error];
			NSString *jsonPackage=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
			
			
			//send to server
			[appDelegate startNetworkActivity];
			currentRequest=[webService Register:self action:@selector(registerRespond:) key:authKey v_jsonProfile:jsonPackage];
			
			return YES;
		}
	}
	else
	{
		[appDelegate networkConnectionError];
	}
	
	return NO;
}

-(void)registerRespond:(NSString*)jsonPackage;
{
	NSError *error;
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	[appDelegate stopNetworkActivity];
	
	if(delegate!=nil)
	{
		if([jsonPackage isKindOfClass:[NSError class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@"Service has an error occurred"];
			[self cancel];
			return;
		}
		else if([jsonPackage isKindOfClass:[SoapFault class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@" Soap service fault"];
			[self cancel];
			return;
		}
		
		//deserialize
		NSData *jsonData=[jsonPackage dataUsingEncoding:NSUTF32BigEndianStringEncoding];
		NSDictionary *deserializedData=[[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
		
		[delegate aGiftWebService:self RegisterDictionary:deserializedData];
	}
	
	[self cancel];
}

#pragma mark edit profile service and respond
-(BOOL)editProfileWithPhoneNumber:(NSString*)phoneNumber userName:(NSString*)username profilePhoto:(NSData*)photo
{
	NSError *error;
	
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];

	NSMutableDictionary *dataDictionary=[[[NSMutableDictionary alloc] init] autorelease];
	
	//auth key
	NSString *authKey=appDelegate.userAuthorizedKey;
	
	if([appDelegate isNetworkVaild])
	{
		if(authKey!=nil)
		{
			//encoding photo
			NSString *photo64Encoding=[photo base64Encoding];
			
			//fill data
			[dataDictionary setObject:phoneNumber forKey:@"PhoneNumber"];
			
			NSString *userName64=[[username dataUsingEncoding:NSUTF8StringEncoding] base64Encoding];
			[dataDictionary setObject:userName64 forKey:@"UserName"];
			[dataDictionary setObject:@"ProfilePhoto.png" forKey:@"ProfilePhotoName"];
			[dataDictionary setObject:photo64Encoding forKey:@"ProfilePhoto"];
			
			//serialize
			NSData *jsonData=[[CJSONSerializer serializer] serializeDictionary:dataDictionary error:&error];
			NSString *jsonPackage=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
			
			
			//DebugLog
			//NSLog(@"js:%@", jsonPackage);
			
			//send to server
			[appDelegate startNetworkActivity];
			currentRequest=[webService EditProfile:self action:@selector(editProfileRespond:) key:authKey v_jsonEditProfile:jsonPackage];
			
			return YES;
		}
	}
	else
	{
		[appDelegate networkConnectionError];
	}
	
	return NO;
}

-(void)editProfileRespond:(NSString*)jsonPackage
{
	NSError *error;
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	[appDelegate stopNetworkActivity];
	
	//DebugLog
	NSLog(@"%@", jsonPackage);
	
	if(delegate!=nil)
	{
		if([jsonPackage isKindOfClass:[NSError class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@"Service has an error occurred"];
			[self cancel];
			return;
		}
		else if([jsonPackage isKindOfClass:[SoapFault class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@" Soap service fault"];
			[self cancel];
			return;
		}
		
		//deserialize
		NSData *jsonData=[jsonPackage dataUsingEncoding:NSUTF32BigEndianStringEncoding];
		NSDictionary *deserializedData=[[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
		
		[delegate aGiftWebService:self EditProfileDictionary:deserializedData];
	}
	
	[self cancel];
}

#pragma mark receive new gift list service and respond
-(BOOL)ReceiveNewGiftList:(NSString*)phoneNumber
{
	NSError *error;
	
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	//auth key
	NSString *authKey=appDelegate.userAuthorizedKey;
	
	if([appDelegate isNetworkVaild])
	{
		if(authKey!=nil)
		{
			
			//serialize
			NSData *jsonData=[[CJSONSerializer serializer] serializeString:phoneNumber error:&error];
			NSString *jsonPackage=[[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
			
			
			//DebugLog
			//NSLog(@"js:%@", jsonPackage);
			
			//send to server
			[appDelegate startNetworkActivity];
			
			currentRequest=[webService GetGiftSumList:self action:@selector(ReceiveNewGiftListRespond:) key:authKey v_jsonFreeUserPhoneNumber:jsonPackage];
			
			
			return YES;
		}
	}
	else
	{
		[appDelegate networkConnectionError];
	}
	
	return NO;
}

-(void)ReceiveNewGiftListRespond:(NSString*)jsonPackage
{
	NSError *error;
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	[appDelegate stopNetworkActivity];
	
	//DebugLog
	//NSLog(@"%@", jsonPackage);
	
	if(delegate!=nil)
	{
		if([jsonPackage isKindOfClass:[NSError class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@"Service has an error occurred"];
			[self cancel];
			return;
		}
		else if([jsonPackage isKindOfClass:[SoapFault class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@" Soap service fault"];
			[self cancel];
			return;
		}
		
		//DebugLog
		//NSLog(@"%@", jsonPackage);
		
		//deserialize
		NSData *jsonData=[jsonPackage dataUsingEncoding:NSUTF32BigEndianStringEncoding];
		NSDictionary *deserializedData=[[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
		
		
		NSDictionary *giftSumlist=[deserializedData valueForKey:@"GiftSumList"];
		
		//get sum list back which has number of gifts
		NSArray *giftlist=[giftSumlist valueForKey:@"SumList"];
		

		[delegate aGiftWebService:self ReceiveNewGiftsArray:giftlist];
	}
	
	[self cancel];
}

#pragma mark receive first data and respond
-(BOOL)ReceiveFirstData:(NSString*)giftID DownloadBox3DObj:(BOOL)objYesOrNo DownloadBoxVideo:(BOOL)videoYesOrNo DownloadGiftIcon:(BOOL)iconYesOrNo
{
	NSError *error;
	
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	NSMutableDictionary *dataDictionary=[[[NSMutableDictionary alloc] init] autorelease];
	
	//auth key
	NSString *authKey=appDelegate.userAuthorizedKey;
	
	if([appDelegate isNetworkVaild])
	{
		if(authKey!=nil)
		{
			[dataDictionary setObject:giftID forKey:@"giftGUID"];
			
			if(objYesOrNo)
			{
				[dataDictionary setObject:@"Y" forKey:@"isDL3Dobj"];
			}
			else 
			{
				[dataDictionary setObject:@"N" forKey:@"isDL3Dobj"];
			}
			
			if(videoYesOrNo)
			{
				[dataDictionary setObject:@"Y" forKey:@"isDLVideo"];
			}
			else 
			{
				[dataDictionary setObject:@"N" forKey:@"isDLVideo"];
			}
			
			if(iconYesOrNo)
			{
				[dataDictionary setObject:@"Y" forKey:@"isDLSmailGiftPic"];
			}
			else 
			{
				[dataDictionary setObject:@"N" forKey:@"isDLSmailGiftPic"];
			}

			[dataDictionary setObject:@"N" forKey:@"isDLLockGiftBox"];
			
			[dataDictionary setObject:@"N" forKey:@"isDLPlayerBgPic"];

			
			//serialize
			NSData *jsonData=[[CJSONSerializer serializer] serializeDictionary:dataDictionary error:&error];
			NSString *jsonPackage=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
			
			
			//DebugLog
			//NSLog(@"js:%@", jsonPackage);
			
			//send to server
			[appDelegate startNetworkActivity];
			currentRequest=[webService GetGiftFirstMedia:self action:@selector(ReceiveFirstDataRespond:) key:authKey v_jsonDLMediaOption:jsonPackage];
			
			
			return YES;
		}
	}
	else
	{
		[appDelegate networkConnectionError];
	}
	
	return NO;
}

-(void)ReceiveFirstDataRespond:(NSString*)jsonPackage
{
	NSError *error;
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	[appDelegate stopNetworkActivity];
	
	//DebugLog
	//NSLog(@"%@", jsonPackage);
	
	if(delegate!=nil)
	{
		if([jsonPackage isKindOfClass:[NSError class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@"Service has an error occurred"];
			[self cancel];
			return;
		}
		else if([jsonPackage isKindOfClass:[SoapFault class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@" Soap service fault"];
			[self cancel];
			return;
		}
		
		//DebugLog
		//NSLog(@"%@", jsonPackage);
		
		
		//deserialize
		NSData *jsonData=[jsonPackage dataUsingEncoding:NSUTF32BigEndianStringEncoding];
		NSDictionary *deserializedData=[[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
		
		NSDictionary *firstData=[deserializedData valueForKey:@"firstPageMedia"];
		
		[delegate aGiftWebService:self ReceiveFirstDataDictionary:firstData];
	}
	
	[self cancel];
}

#pragma mark receive third data and respond
-(BOOL)ReceiveThirdData:(NSString*)giftID DownloadGift3DObj:(BOOL)objYesOrNo DownloadGiftVideo:(BOOL)videoYesOrNo
{
	NSError *error;
	
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	NSMutableDictionary *dataDictionary=[[[NSMutableDictionary alloc] init] autorelease];
	
	//auth key
	NSString *authKey=appDelegate.userAuthorizedKey;
	
	if([appDelegate isNetworkVaild])
	{
		if(authKey!=nil)
		{
			[dataDictionary setObject:giftID forKey:@"giftGUID"];
			
			if(objYesOrNo)
			{
				[dataDictionary setObject:@"Y" forKey:@"isDL3Dobj"];
			}
			else 
			{
				[dataDictionary setObject:@"N" forKey:@"isDL3Dobj"];
			}
			
			if(videoYesOrNo)
			{
				[dataDictionary setObject:@"Y" forKey:@"isDLVideo"];
			}
			else 
			{
				[dataDictionary setObject:@"N" forKey:@"isDLVideo"];
			}
			
			
			//serialize
			NSData *jsonData=[[CJSONSerializer serializer] serializeDictionary:dataDictionary error:&error];
			NSString *jsonPackage=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
			
			//DebugLog
			//NSLog(@"js:%@", jsonPackage);
			
			//send to server
			[appDelegate startNetworkActivity];
			currentRequest=[webService GetOpenGift:self action:@selector(ReceiveThirdDataRespond:) key:authKey v_jsonDLMediaOption:jsonPackage];
			
			return YES;
		}
	}
	else
	{
		[appDelegate networkConnectionError];
	}
	
	return NO;
}

-(void)ReceiveThirdDataRespond:(NSString*)jsonPackage
{
	NSError *error;
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	[appDelegate stopNetworkActivity];
	
	//DebugLog
	//NSLog(@"%@", jsonPackage);
	
	if(delegate!=nil)
	{
		if([jsonPackage isKindOfClass:[NSError class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@"Service has an error occurred"];
			[self cancel];
			return;
		}
		else if([jsonPackage isKindOfClass:[SoapFault class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@" Soap service fault"];
			[self cancel];
			return;
		}
		
		//DebugLog
		//NSLog(@"%@", jsonPackage);
		
		
		//deserialize
		NSData *jsonData=[jsonPackage dataUsingEncoding:NSUTF32BigEndianStringEncoding];
		NSDictionary *deserializedData=[[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
		
		NSDictionary *thirdData=[deserializedData valueForKey:@"GiftAnimation"];
		
		[delegate aGiftWebService:self ReceiveThirdDataDictionary:thirdData];
	}
	
	[self cancel];
}

#pragma mark update gift status and respond
-(BOOL)setGiftStatusWithGiftID:(NSString*)giftID Status:(NSString*)status
{
	NSError *error;
	
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];

	NSMutableDictionary *dataDictionary=[[[NSMutableDictionary alloc] init] autorelease];
	
	//auth key
	NSString *authKey=appDelegate.userAuthorizedKey;
	
	if([appDelegate isNetworkVaild])
	{
		if(authKey!=nil)
		{
			[dataDictionary setObject:giftID forKey:@"GiftGuid"];
			[dataDictionary setObject:status forKey:@"GiftStatus"];
			
			//serialize
			NSData *jsonData=[[CJSONSerializer serializer] serializeDictionary:dataDictionary error:&error];
			NSString *jsonPackage=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
			
			//DebugLog
			//NSLog(@"js:%@", jsonPackage);
			
			//send to server
			[appDelegate startNetworkActivity];
			currentRequest=[webService SetGiftStatus:self action:@selector(setGiftStatusRespond:) key:authKey v_jsonUpdateGiftStatusModel:jsonPackage];
			
			
			return YES;
		}
	}
	else
	{
		[appDelegate networkConnectionError];
	}
	
	return NO;
}

-(void)setGiftStatusRespond:(NSString*)jsonPackage
{
	NSError *error;
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	[appDelegate stopNetworkActivity];
	
	//DebugLog
	//NSLog(@"%@", jsonPackage);
	
	if(delegate!=nil)
	{
		if([jsonPackage isKindOfClass:[NSError class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@"Service has an error occurred"];
			[self cancel];
			return;
		}
		else if([jsonPackage isKindOfClass:[SoapFault class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@" Soap service fault"];
			[self cancel];
			return;
		}
		
		//DebugLog
		//NSLog(@"%@", jsonPackage);
		
		
		//deserialize
		NSData *jsonData=[jsonPackage dataUsingEncoding:NSUTF32BigEndianStringEncoding];
		NSDictionary *deserializedData=[[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
		
		NSLog(@"update : %@", [deserializedData valueForKey:@"resbool"]);
	}
	
	[self cancel];
}

#pragma mark get box list and respond
-(BOOL)ReceiveGiftBoxPickerList
{
	
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	//auth key
	NSString *authKey=appDelegate.userAuthorizedKey;
	
	if([appDelegate isNetworkVaild])
	{
		if(authKey!=nil)
		{
						
			//DebugLog
			//NSLog(@"js:%@", jsonPackage);
			
			//send to server
			[appDelegate startNetworkActivity];
			currentRequest=[webService GetPickGiftBoxList:self action:@selector(ReceiveGiftBoxPickerListDataRespond:) key:authKey];
			
			
			return YES;
		}
	}
	else
	{
		[appDelegate networkConnectionError];
		[delegate aGiftWebService:self ReceiveGiftPickerListArray:nil];
	}
	
	return NO;
}

-(void)ReceiveGiftBoxPickerListDataRespond:(NSString*)jsonPackage
{
	NSError *error;
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];

	
	[appDelegate stopNetworkActivity];
	
	//DebugLog
	//NSLog(@"%@", jsonPackage);
	
	if(delegate!=nil)
	{
		if([jsonPackage isKindOfClass:[NSError class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@"Service has an error occurred"];
			[delegate aGiftWebService:self ReceiveGiftBoxPickerListArray:nil];
			[self cancel];
			return;
		}
		else if([jsonPackage isKindOfClass:[SoapFault class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@" Soap service fault"];
			[delegate aGiftWebService:self ReceiveGiftBoxPickerListArray:nil];
			[self cancel];
			return;
		}
		
		//DebugLog
		//NSLog(@"%@", jsonPackage);
		
		
		//deserialize
		NSData *jsonData=[jsonPackage dataUsingEncoding:NSUTF32BigEndianStringEncoding];
		NSDictionary *deserializedData=[[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
		
		NSArray *boxListData=[deserializedData valueForKey:@"PickGiftBoxList"];
		
		[delegate aGiftWebService:self ReceiveGiftBoxPickerListArray:boxListData];
	}
	
	[self cancel];
}

#pragma mark get box 3d and respond
-(BOOL)ReceiveGift3DBoxObject:(NSString*)boxNumber
{
	
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	//auth key
	NSString *authKey=appDelegate.userAuthorizedKey;
	
	if([appDelegate isNetworkVaild])
	{
		if(authKey!=nil)
		{
			
			//DebugLog
			//NSLog(@"js:%@", jsonPackage);
			
			//send to server
			[appDelegate startNetworkActivity];
			currentRequest=[webService GetPickGiftBox3Dobj:self action:@selector(ReceiveGift3DBoxObjectDataRespond:) key:authKey v_strGiftBox3dID:boxNumber];
			
			
			return YES;
		}
	}
	else
	{
		[appDelegate networkConnectionError];
	}
	
	return NO;
}

-(void)ReceiveGift3DBoxObjectDataRespond:(NSString*)jsonPackage
{
	NSError *error;
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];

	
	[appDelegate stopNetworkActivity];
	
	//DebugLog
	//NSLog(@"%@", jsonPackage);
	
	if(delegate!=nil)
	{
		if([jsonPackage isKindOfClass:[NSError class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@"Service has an error occurred"];
			[self cancel];
			return;
		}
		else if([jsonPackage isKindOfClass:[SoapFault class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@" Soap service fault"];
			[self cancel];
			return;
		}
		
		//DebugLog
		//NSLog(@"%@", jsonPackage);
		
		
		//deserialize
		NSData *jsonData=[jsonPackage dataUsingEncoding:NSUTF32BigEndianStringEncoding];
		NSDictionary *deserializedData=[[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
		
		NSArray *box3DItems=[deserializedData valueForKey:@"PickGift3DObjList"];
		
		[delegate aGiftWebService:self ReceiveGift3DBoxObjectArray:box3DItems];
	}
	
	[self cancel];
}

#pragma mark get gift list and respond
-(BOOL)ReceiveGiftPickerList
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	//auth key
	NSString *authKey=appDelegate.userAuthorizedKey;
	
	if([appDelegate isNetworkVaild])
	{
		if(authKey!=nil)
		{
			
			//DebugLog
			//NSLog(@"js:%@", jsonPackage);
			
			//send to server
			[appDelegate startNetworkActivity];
			currentRequest=[webService GetPickGiftList:self action:@selector(ReceiveGiftPickerListDataRespond:) key:authKey];
			
			
			return YES;
		}
	}
	else
	{
		[appDelegate networkConnectionError];
		[delegate aGiftWebService:self ReceiveGiftPickerListArray:nil];
	}
	
	return NO;
}

-(void)ReceiveGiftPickerListDataRespond:(NSString*)jsonPackage
{
	NSError *error;
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];

	
	[appDelegate stopNetworkActivity];
	
	//DebugLog
	//NSLog(@"%@", jsonPackage);
	
	if(delegate!=nil)
	{
		if([jsonPackage isKindOfClass:[NSError class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@"Service has an error occurred"];
			[delegate aGiftWebService:self ReceiveGiftPickerListArray:nil];
			[self cancel];
			return;
		}
		else if([jsonPackage isKindOfClass:[SoapFault class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@" Soap service fault"];
			[delegate aGiftWebService:self ReceiveGiftPickerListArray:nil];
			[self cancel];
			return;
		}
		
		//DebugLog
		//NSLog(@"%@", jsonPackage);
		
		
		//deserialize
		NSData *jsonData=[jsonPackage dataUsingEncoding:NSUTF32BigEndianStringEncoding];
		NSDictionary *deserializedData=[[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
		
		NSArray *giftListData=[deserializedData valueForKey:@"PickGiftList"];
		
		[delegate aGiftWebService:self ReceiveGiftPickerListArray:giftListData];
		
	}
	
	[self cancel];
}

#pragma mark get gift 3d and respond
-(BOOL)ReceiveGift3DObject:(NSString*)giftNumber
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	//auth key
	NSString *authKey=appDelegate.userAuthorizedKey;
	
	if([appDelegate isNetworkVaild])
	{
		if(authKey!=nil)
		{
			
			//DebugLog
			//NSLog(@"js:%@", jsonPackage);
			
			//send to server
			[appDelegate startNetworkActivity];
			currentRequest=[webService GetPickGift3Dobj:self action:@selector(ReceiveGift3DObjectDataRespond:) key:authKey v_strGift3dID:giftNumber];
			
			
			return YES;
		}
	}
	else
	{
		[appDelegate networkConnectionError];
	}
	
	return NO;
}

-(void)ReceiveGift3DObjectDataRespond:(NSString*)jsonPackage
{
	NSError *error;
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];

	
	[appDelegate stopNetworkActivity];
	
	//DebugLog
	//NSLog(@"%@", jsonPackage);
	
	if(delegate!=nil)
	{
		if([jsonPackage isKindOfClass:[NSError class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@"Service has an error occurred"];
			[self cancel];
			return;
		}
		else if([jsonPackage isKindOfClass:[SoapFault class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@" Soap service fault"];
			[self cancel];
			return;
		}
		
		//DebugLog
		//NSLog(@"%@", jsonPackage);
		
		
		//deserialize
		NSData *jsonData=[jsonPackage dataUsingEncoding:NSUTF32BigEndianStringEncoding];
		NSDictionary *deserializedData=[[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
		
		NSArray *gift3DItems=[deserializedData valueForKey:@"PickGift3DObjList"];
		
		[delegate aGiftWebService:self ReceiveGift3DObjectArray:gift3DItems];
	}
	
	[self cancel];
}

#pragma mark get gift music and respond
-(BOOL)ReceiveGiftMusicList
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	//auth key
	NSString *authKey=appDelegate.userAuthorizedKey;
	
	if([appDelegate isNetworkVaild])
	{
		if(authKey!=nil)
		{
			
			//DebugLog
			//NSLog(@"js:%@", jsonPackage);
			
			//send to server
			[appDelegate startNetworkActivity];
			currentRequest=[webService GetPickGiftMusicList:self action:@selector(ReceiveGiftMusicListDataRespond:) key:authKey];
			
			
			return YES;
		}
	}
	else
	{
		[appDelegate networkConnectionError];
	}
	
	return NO;
}

-(void)ReceiveGiftMusicListDataRespond:(NSString*)jsonPackage
{
	NSError *error;
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];

	
	[appDelegate stopNetworkActivity];
	
	//DebugLog
	//NSLog(@"%@", jsonPackage);
	
	if(delegate!=nil)
	{
		if([jsonPackage isKindOfClass:[NSError class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@"Service has an error occurred"];
			[self cancel];
			return;
		}
		else if([jsonPackage isKindOfClass:[SoapFault class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@" Soap service fault"];
			[self cancel];
			return;
		}
		
		//DebugLog
		//NSLog(@"%@", jsonPackage);
		
		
		//deserialize
		NSData *jsonData=[jsonPackage dataUsingEncoding:NSUTF32BigEndianStringEncoding];
		NSDictionary *deserializedData=[[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
		
		NSArray *musicItems=[deserializedData valueForKey:@"PickGiftMusicList"];
		
		[delegate aGiftWebService:self ReceiveGiftMusicListtArray:musicItems];
	}
	
	[self cancel];
}

#pragma mark add friend and respond
-(BOOL)addFriend:(NSString*)clientPhoneNumber FriendID:(NSString*)friendID
{
	NSError *error;
	
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	NSMutableDictionary *dataDictionary=[[[NSMutableDictionary alloc] init] autorelease];
	
	//auth key
	NSString *authKey=appDelegate.userAuthorizedKey;
	
	if([appDelegate isNetworkVaild])
	{
		if(authKey!=nil)
		{
			[dataDictionary setObject:clientPhoneNumber forKey:@"ClientID"];
			[dataDictionary setObject:friendID forKey:@"FindID"];
			
			//serialize
			NSData *jsonData=[[CJSONSerializer serializer] serializeDictionary:dataDictionary error:&error];
			NSString *jsonPackage=[[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
			
			//DebugLog
			//NSLog(@"js:%@", jsonPackage);
			
			//send to server
			[appDelegate startNetworkActivity];
			currentRequest=[webService FindFriend:self action:@selector(addFriendDataRespond:) key:authKey v_jsonFindUser:jsonPackage];
			
			
			
			return YES;
		}
	}
	else
	{
		[appDelegate networkConnectionError];
	}
	
	return NO;
}

-(void)addFriendDataRespond:(NSString*)jsonPackage
{
	NSError *error;
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	[appDelegate stopNetworkActivity];
	
	//DebugLog
	//NSLog(@"%@", jsonPackage);
	
	if(delegate!=nil)
	{
		if([jsonPackage isKindOfClass:[NSError class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@"Service has an error occurred"];
			[self cancel];
			return;
		}
		else if([jsonPackage isKindOfClass:[SoapFault class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@" Soap service fault"];
			[self cancel];
			return;
		}
		
		//DebugLog
		//NSLog(@"%@", jsonPackage);
		
		
		//deserialize
		NSData *jsonData=[jsonPackage dataUsingEncoding:NSUTF32BigEndianStringEncoding];
		NSDictionary *deserializedData=[[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
		
		NSString *errorMsg=[deserializedData valueForKey:@"errorMsg"];
		
		if([errorMsg isEqualToString:@"success"])
		{
			NSDictionary *friendDic=[deserializedData valueForKey:@"QueryFriend"];

			[delegate aGiftWebService:self addFriendDictionary:friendDic];
		}
		else 
		{
			[delegate aGiftWebService:self addFriendDictionary:nil];
		}

		
	}
	
	[self cancel];
}

#pragma mark send gift and respond
-(BOOL)sendGift:(SendGiftInfo*)giftInfo
{
	NSError *error;
	
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	NSMutableDictionary *dataDictionary=[[[NSMutableDictionary alloc] init] autorelease];
	
	//auth key
	NSString *authKey=appDelegate.userAuthorizedKey;
	
	if([appDelegate isNetworkVaild])
	{
		if(authKey!=nil)
		{
			[dataDictionary setObject:giftInfo.senderID forKey:@"F_GSender"];
			[dataDictionary setObject:giftInfo.receiverID forKey:@"F_GReceiver"];
			[dataDictionary setObject:[NSNumber numberWithInt:[giftInfo.anonymous intValue]] forKey:@"F_AnonymousCode"];
			
			if(giftInfo.canOpenTime!=nil)
			{
				[dataDictionary setObject:giftInfo.canOpenTime forKey:@"F_strCanOpenUTCTime"];
			}
			else 
			{
				[dataDictionary setObject:[NSNull null] forKey:@"F_strCanOpenUTCTime"];
			}

			
			[dataDictionary setObject:giftInfo.giftBoxVideoID forKey:@"F_GBox"];
			[dataDictionary setObject:giftInfo.giftVideoID forKey:@"F_GGift"];
			
			//prcess message
			NSString *bMsgUtf8=[NSString stringWithUTF8String:[giftInfo.beforeMsg UTF8String]];
			NSString *aMsgUtf8=[NSString stringWithUTF8String:[giftInfo.afterMsg UTF8String]];
			
			NSString *bMsg=[[bMsgUtf8 dataUsingEncoding:NSUTF8StringEncoding] base64Encoding];
			NSString *aMsg=[[aMsgUtf8 dataUsingEncoding:NSUTF8StringEncoding] base64Encoding];
					
			[dataDictionary setObject:bMsg forKey:@"F_GBefContent"];
			[dataDictionary setObject:aMsg forKey:@"F_GAftContent"];
			
			
			if(giftInfo.giftPhoto64Encoding!=nil)
			{
				[dataDictionary setObject:giftInfo.giftPhotoFileName forKey:@"F_GPhotoFileName"];
				[dataDictionary setObject:giftInfo.giftPhoto64Encoding forKey:@"F_GPhoto"];
			}
			
			if(giftInfo.giftDefMusicID!=nil)
			{
				[dataDictionary setObject:giftInfo.giftDefMusicID forKey:@"F_GDefMusic"];
			}
			else if(giftInfo.customMusic64Encoding!=nil) 
			{
				[dataDictionary setObject:giftInfo.customMusicFileName forKey:@"F_GMusicFileName"];
				[dataDictionary setObject:giftInfo.customMusic64Encoding forKey:@"F_GMusic"];
			}


			[dataDictionary setObject:giftInfo.gift3DObjID forKey:@"F_ipGift3Dobj"];
			[dataDictionary setObject:giftInfo.giftBox3DObjID forKey:@"F_ipGiftBox3Dobj"];


			
			//serialize
			NSData *jsonData=[[CJSONSerializer serializer] serializeDictionary:dataDictionary error:&error];
			NSString *jsonPackage=[[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
			
			//process string replace 
			//NSString *jsonReplacePackage=[jsonPackage stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\\\u"];
			NSString *jsonPackageCDATA=[[@"<![CDATA[" stringByAppendingString:jsonPackage] stringByAppendingString:@"]]>"];
			
			//DebugLog
			//NSLog(@"js:%@", jsonPackage);
			//NSLog(@"jscdata:%@", jsonPackageCDATA);
			//send to server
			[appDelegate startNetworkActivity];
			currentRequest=[webService SendGift:self action:@selector(sendGiftDataRespond:) key:authKey v_jsonGiftObj:jsonPackageCDATA];
			
			return YES;
		}
	}
	else
	{
		[appDelegate networkConnectionError];
		
		if(delegate!=nil)
		{
			[delegate aGiftWebService:self sendGiftGiftIDDectionary:nil];
		}
	}
	
	return NO;
}

-(void)sendGiftDataRespond:(NSString*)jsonPackage
{
	NSError *error;
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	[appDelegate stopNetworkActivity];
	
	//DebugLog
	//NSLog(@"%@", jsonPackage);
	
	if(delegate!=nil)
	{
		if([jsonPackage isKindOfClass:[NSError class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@"Service has an error occurred"];
			NSLog(@"nserror:%@", (NSError*)jsonPackage);
			[delegate aGiftWebService:self sendGiftGiftIDDectionary:nil];
			[self cancel];
			return;
		}
		else if([jsonPackage isKindOfClass:[SoapFault class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@" Soap service fault"];
			[delegate aGiftWebService:self sendGiftGiftIDDectionary:nil];
			[self cancel];
			return;
		}
		
		//DebugLog
		//NSLog(@"%@", jsonPackage);
		
		
		//deserialize
		NSData *jsonData=[jsonPackage dataUsingEncoding:NSUTF32BigEndianStringEncoding];
		NSDictionary *deserializedData=[[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
		
		/*
		NSNumber *success=[deserializedData valueForKey:@"resInt"];
		NSString *sentGiftID=[deserializedData valueForKey:@"resString"];
		NSString *giftID=[NSString stringWithFormat:@"%@",sentGiftID];
		
		if([success integerValue]==1)
		{
			//sent success
			[delegate aGiftWebService:self sendGiftGiftIDDectionary:deserializedData];
		}
		else 
		{
			//fail
			[delegate aGiftWebService:self sendGiftGiftID:nil];
		}
		 */
		
		[delegate aGiftWebService:self sendGiftGiftIDDectionary:deserializedData];

	}
	
	[self cancel];
}

#pragma mark update gift status and respond
-(BOOL)updateGiftStatus:(NSString*)giftID
{
	NSError *error;
	
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	//NSMutableDictionary *dataDictionary=[[NSMutableDictionary alloc] init];
	
	//auth key
	NSString *authKey=appDelegate.userAuthorizedKey;
	
	if([appDelegate isNetworkVaild])
	{
		if(authKey!=nil)
		{
			//[dataDictionary setObject:giftID forKey:@"GiftGuid"];
			//[dataDictionary setObject:@"" forKey:@"GiftStatus"];
			
			//serialize
			NSData *jsonData=[[CJSONSerializer serializer] serializeString:giftID error:&error];
			NSString *jsonPackage=[[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
			
			//DebugLog
			//NSLog(@"js:%@", jsonPackage);
			
			//send to server
			[appDelegate startNetworkActivity];
			currentRequest=[webService QueryGiftStatus:self action:@selector(updateGiftStatusDataRespond:) key:authKey v_jsonGiftGuid:jsonPackage];
			
			
			//[dataDictionary release];
			
			return YES;
		}
	}
	else
	{
		[appDelegate networkConnectionError];
	}
	
	//[dataDictionary release];
	return NO;
}

-(void)updateGiftStatusDataRespond:(NSString*)jsonPackage
{
	NSError *error;
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	[appDelegate stopNetworkActivity];
	
	//DebugLog
	//NSLog(@"%@", jsonPackage);
	
	if(delegate!=nil)
	{
		if([jsonPackage isKindOfClass:[NSError class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@"Service has an error occurred"];
			[self cancel];
			return;
		}
		else if([jsonPackage isKindOfClass:[SoapFault class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@" Soap service fault"];
			[self cancel];
			return;
		}
		
		//DebugLog
		//NSLog(@"%@", jsonPackage);
		
		
		//deserialize
		NSData *jsonData=[jsonPackage dataUsingEncoding:NSUTF32BigEndianStringEncoding];
		NSDictionary *deserializedData=[[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
		
		NSDictionary *queryRespond=[deserializedData valueForKey:@"QueryGiftStatusItem"];
		
		/*
		NSNumber *status=[queryRespond valueForKey:@"GiftStatus"];
		
		NSString *strGiftStatus=[NSString stringWithFormat:@"%i", [status integerValue]];
		 */
		
		[delegate aGiftWebService:self updateGiftStatusStatusDictionary:queryRespond];
	}
	
	[self cancel];
}

#pragma mark cancel gift and respond
-(BOOL)cancelGiftWithGiftID:(NSString*)giftID
{
	NSError *error;
	
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	//NSMutableDictionary *dataDictionary=[[NSMutableDictionary alloc] init];
	
	//auth key
	NSString *authKey=appDelegate.userAuthorizedKey;
	
	if([appDelegate isNetworkVaild])
	{
		if(authKey!=nil)
		{
			//[dataDictionary setObject:giftID forKey:@"GiftGuid"];
			
			//serialize
			NSData *jsonData=[[CJSONSerializer serializer] serializeString:giftID error:&error];
			NSString *jsonPackage=[[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
			
			//DebugLog
			//NSLog(@"js:%@", jsonPackage);
			
			//send to server
			[appDelegate startNetworkActivity];
			currentRequest=[webService CancelSendGift:self action:@selector(cancelGiftDataRespond:) key:authKey v_jsonGiftGuid:jsonPackage];
			
			
			//[dataDictionary release];
			
			return YES;
		}
	}
	else
	{
		[appDelegate networkConnectionError];
	}
	
	//[dataDictionary release];
	return NO;
}

-(void)cancelGiftDataRespond:(NSString*)jsonPackage
{
	NSError *error;
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	
	[appDelegate stopNetworkActivity];
	
	//DebugLog
	//NSLog(@"%@", jsonPackage);
	
	if(delegate!=nil)
	{
		if([jsonPackage isKindOfClass:[NSError class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@"Service has an error occurred"];
			[self cancel];
			return;
		}
		else if([jsonPackage isKindOfClass:[SoapFault class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@" Soap service fault"];
			[self cancel];
			return;
		}
		
		//DebugLog
		//NSLog(@"%@", jsonPackage);
		
		
		//deserialize
		NSData *jsonData=[jsonPackage dataUsingEncoding:NSUTF32BigEndianStringEncoding];
		NSDictionary *deserializedData=[[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
		

		NSNumber *result=[deserializedData valueForKey:@"resInt"];
		
		NSString *strResult=[NSString stringWithFormat:@"%i", [result integerValue]];
		
		[delegate aGiftWebService:self cancelGiftResult:strResult];
		
		
	}
	
	[self cancel];
}

#pragma mark deleteGiftStatus and respond
-(BOOL)deleteGiftStatus:(NSString*)giftID
{
	NSError *error;
	
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	NSMutableDictionary *dataDictionary=[[[NSMutableDictionary alloc] init] autorelease];
	
	//auth key
	NSString *authKey=appDelegate.userAuthorizedKey;
	
	if([appDelegate isNetworkVaild])
	{
		if(authKey!=nil)
		{
			[dataDictionary setObject:giftID forKey:@"GiftGuid"];
			
			
			//serialize
			NSData *jsonData=[[CJSONSerializer serializer] serializeDictionary:dataDictionary error:&error];
			NSString *jsonPackage=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
			
			//DebugLog
			//NSLog(@"js:%@", jsonPackage);
			
			//send to server
			[appDelegate startNetworkActivity];
			currentRequest=[webService DeleteGiftStatus:self action:@selector(deleteGiftStatusRespond:) key:authKey v_jsonGiftGuid:jsonPackage];
			
			
			
			return YES;
		}
	}
	else
	{
		[appDelegate networkConnectionError];
	}
	
	return NO;
}

-(void)deleteGiftStatusRespond:(NSString*)jsonPackage
{
	NSError *error;
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	
	[appDelegate stopNetworkActivity];
	
	//DebugLog
	//NSLog(@"%@", jsonPackage);
	
	if(delegate!=nil)
	{
		if([jsonPackage isKindOfClass:[NSError class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@"Service has an error occurred"];
			[self cancel];
			return;
		}
		else if([jsonPackage isKindOfClass:[SoapFault class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@" Soap service fault"];
			[self cancel];
			return;
		}
		
		//DebugLog
		//NSLog(@"%@", jsonPackage);
		
		
		//deserialize
		NSData *jsonData=[jsonPackage dataUsingEncoding:NSUTF32BigEndianStringEncoding];
		NSDictionary *deserializedData=[[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
		
		
		NSNumber *result=[deserializedData valueForKey:@"resInt"];
		
		NSLog(@"delete gift status:%i", [result integerValue]);
		
	}
	
	//[self cancel];
}

#pragma mark userExisted and respond
-(BOOL)userExisted:(NSString*)deviceID
{
	NSError *error;
	
	 AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	NSMutableDictionary *dataDictionary=[[[NSMutableDictionary alloc] init] autorelease];
	
	//auth key
	NSString *authKey=appDelegate.userAuthorizedKey;
	
	if([appDelegate isNetworkVaild])
	{
		if(authKey!=nil)
		{
			[dataDictionary setObject:deviceID forKey:@"PhoneDeviceID"];
			
			//serialize
			NSData *jsonData=[[CJSONSerializer serializer] serializeDictionary:dataDictionary error:&error];
			NSString *jsonPackage=[[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
			
			//DebugLog
			//NSLog(@"js:%@", jsonPackage);
			
			//send to server
			[appDelegate startNetworkActivity];
			currentRequest=[webService UserIsExist:self action:@selector(userExistedRespond:) key:authKey v_jsonProfile:jsonPackage];
			

			
			return YES;
		}
	}
	else
	{
		[appDelegate networkConnectionError];
		
		[delegate aGiftWebService:self userExistedDictionary:nil];
	}
	
	return NO;
}

-(void)userExistedRespond:(NSString*)jsonPackage
{
	NSError *error;
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	[appDelegate stopNetworkActivity];
	
	//DebugLog
	//NSLog(@"%@", jsonPackage);
	
	if(delegate!=nil)
	{
		if([jsonPackage isKindOfClass:[NSError class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@"Service has an error occurred"];
			[delegate aGiftWebService:self userExistedDictionary:nil];
			[self cancel];
			return;
		}
		else if([jsonPackage isKindOfClass:[SoapFault class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@" Soap service fault"];
			[delegate aGiftWebService:self userExistedDictionary:nil];
			[self cancel];
			return;
		}
		
		//DebugLog
		//NSLog(@"%@", jsonPackage);
		
		
		//deserialize
		NSData *jsonData=[jsonPackage dataUsingEncoding:NSUTF32BigEndianStringEncoding];
		NSDictionary *deserializedData=[[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
		
		[delegate aGiftWebService:self userExistedDictionary:deserializedData];
		
	}
	
	[self cancel];
}

#pragma mark sendDeviceToken and respond
-(BOOL)registerDeviceToken:(NSData*)token phoneNumber:(NSString*)userPhoneNumber
{
	NSError *error;
	
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	NSMutableDictionary *dataDictionary=[[[NSMutableDictionary alloc] init] autorelease];
	
	//auth key
	NSString *authKey=appDelegate.userAuthorizedKey;
	
	if([appDelegate isNetworkVaild])
	{
		if(authKey!=nil)
		{
			[dataDictionary setObject:userPhoneNumber forKey:@"PhoneNumber"];
			
			//convert token to base64
			NSString *token64=[token base64Encoding];
			[dataDictionary setObject:token64 forKey:@"PushChannelID"];
			[dataDictionary setObject:@"Paid" forKey:@"PaidOrFree"];
			
			//serialize
			NSData *jsonData=[[CJSONSerializer serializer] serializeDictionary:dataDictionary error:&error];
			NSString *jsonPackage=[[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
			
			//DebugLog
			//NSLog(@"js:%@", jsonPackage);
			
			//send to server
			[appDelegate startNetworkActivity];
			currentRequest=[webService RegClientChannelUri:self action:@selector(registerDeviceTokenRespond:) key:authKey v_jsonChinnelUri:jsonPackage];
			
			
			return YES;
		}
	}
	else
	{
		[appDelegate networkConnectionError];
	}
	
	return NO;
}

-(void)registerDeviceTokenRespond:(NSString*)jsonPackage
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	[appDelegate stopNetworkActivity];
	
	[self cancel];
}

#pragma mark sendPushNotificationToReceiver and respond
-(BOOL)sendPushNotificationToReceiver:(NSString*)receiverID
{
	NSError *error;
	
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	NSMutableDictionary *dataDictionary=[[[NSMutableDictionary alloc] init] autorelease];
	
	//auth key
	NSString *authKey=appDelegate.userAuthorizedKey;
	
	if([appDelegate isNetworkVaild])
	{
		if(authKey!=nil)
		{
			[dataDictionary setObject:receiverID forKey:@"APReceiverPhoneNumber"];
			[dataDictionary setObject:@"PushNotifycation.wav" forKey:@"APSoundFile"];
			[dataDictionary setObject:@"You have a new gift" forKey:@"APBody"];
			[dataDictionary setObject:@"aGiftFreePushProduction" forKey:@"APKind"];
			
			
			//serialize
			NSData *jsonData=[[CJSONSerializer serializer] serializeDictionary:dataDictionary error:&error];
			NSString *jsonPackage=[[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
			
			//DebugLog
			//NSLog(@"js:%@", jsonPackage);
			
			//send to server
			[appDelegate startNetworkActivity];
			currentRequest=[webService SendAPN:self action:@selector(sendPushNotificationToReceiverRespond:) key:authKey v_jsonAPN:jsonPackage];
			
			
			return YES;
		}
	}
	else
	{
		[appDelegate networkConnectionError];
	}
	

	return NO;
}

-(void)sendPushNotificationToReceiverRespond:(NSString*)jsonPackage
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	[appDelegate stopNetworkActivity];
	
	[self cancel];
}

#pragma mark trackGiftStatus and respond
-(BOOL)trackGiftStatus:(NSString*)giftID
{
	NSError *error;
	
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	//NSMutableDictionary *dataDictionary=[[NSMutableDictionary alloc] init];
	
	//auth key
	NSString *authKey=appDelegate.userAuthorizedKey;
	
	if([appDelegate isNetworkVaild])
	{
		if(authKey!=nil)
		{
			//[dataDictionary setObject:giftID forKey:@"GiftGuid"];
			//[dataDictionary setObject:@"" forKey:@"GiftStatus"];
			
			//serialize
			NSData *jsonData=[[CJSONSerializer serializer] serializeString:giftID error:&error];
			NSString *jsonPackage=[[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
			
			//DebugLog
			//NSLog(@"js:%@", jsonPackage);
			
			//send to server
			[appDelegate startNetworkActivity];
			currentRequest=[webService QueryGiftStatus:self action:@selector(trackGiftStatusDataRespond:) key:authKey v_jsonGiftGuid:jsonPackage];
			
			
			//[dataDictionary release];
			
			return YES;
		}
	}
	else
	{
		[appDelegate networkConnectionError];
	}
	
	//[dataDictionary release];
	return NO;
}

-(void)trackGiftStatusDataRespond:(NSString*)jsonPackage
{
	NSError *error;
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	[appDelegate stopNetworkActivity];
	
	//DebugLog
	//NSLog(@"%@", jsonPackage);
	
	if(delegate!=nil)
	{
		if([jsonPackage isKindOfClass:[NSError class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@"Service has an error occurred"];
			[self cancel];
			return;
		}
		else if([jsonPackage isKindOfClass:[SoapFault class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@" Soap service fault"];
			[self cancel];
			return;
		}
		
		//DebugLog
		//NSLog(@"%@", jsonPackage);
		
		
		//deserialize
		NSData *jsonData=[jsonPackage dataUsingEncoding:NSUTF32BigEndianStringEncoding];
		NSDictionary *deserializedData=[[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
		
		NSDictionary *queryRespond=[deserializedData valueForKey:@"QueryGiftStatusItem"];
		
		
		[delegate aGiftWebService:self trackGiftStatusStatusDictionary:queryRespond];
	}
	
	[self cancel];
}

#pragma mark get gift box video url and respond
-(BOOL)getGiftBoxVideoUrl:(NSString*)number
{
	NSError *error;
	
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	//NSMutableDictionary *dataDictionary=[[NSMutableDictionary alloc] init];
	
	//auth key
	NSString *authKey=appDelegate.userAuthorizedKey;
	
	if([appDelegate isNetworkVaild])
	{
		if(authKey!=nil)
		{
			//[dataDictionary setObject:giftID forKey:@"GiftGuid"];
			//[dataDictionary setObject:@"" forKey:@"GiftStatus"];
			
			//serialize
			NSData *jsonData=[[CJSONSerializer serializer] serializeObject:[NSNumber numberWithInt:[number intValue]] error:&error];
			NSString *jsonPackage=[[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
			
			//DebugLog
			//NSLog(@"js:%@", jsonPackage);
			
			//send to server
			[appDelegate startNetworkActivity];
			currentRequest=[webService IpGetPickGiftBoxVideoUrl:self action:@selector(getGiftBoxVideoUrlRespond:) key:authKey v_jsonVideoNo:jsonPackage];
			
			
			//[dataDictionary release];
			
			return YES;
		}
	}
	else
	{
		[appDelegate networkConnectionError];
	}
	
	//[dataDictionary release];
	return NO;
}

-(void)getGiftBoxVideoUrlRespond:(NSString*)jsonPackage
{
	NSError *error;
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	[appDelegate stopNetworkActivity];
	
	//DebugLog
	//NSLog(@"%@", jsonPackage);
	
	if(delegate!=nil)
	{
		if([jsonPackage isKindOfClass:[NSError class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@"Service has an error occurred"];
			[self cancel];
			return;
		}
		else if([jsonPackage isKindOfClass:[SoapFault class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@" Soap service fault"];
			[self cancel];
			return;
		}
		
		//DebugLog
		//NSLog(@"%@", jsonPackage);
		
		
		//deserialize
		NSData *jsonData=[jsonPackage dataUsingEncoding:NSUTF32BigEndianStringEncoding];
		NSDictionary *deserializedData=[[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
		
		NSString *giftBoxVideoUrl=[deserializedData valueForKey:@"resString"];
		
		
		[delegate aGiftWebService:self getGiftBoxVideoUrlString:giftBoxVideoUrl];
	}
	
	[self cancel];
}

#pragma mark get gift video url and respond
-(BOOL)getGiftVideoUrl:(NSString*)number
{
	NSError *error;
	
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	//NSMutableDictionary *dataDictionary=[[NSMutableDictionary alloc] init];
	
	//auth key
	NSString *authKey=appDelegate.userAuthorizedKey;
	
	if([appDelegate isNetworkVaild])
	{
		if(authKey!=nil)
		{
			//[dataDictionary setObject:giftID forKey:@"GiftGuid"];
			//[dataDictionary setObject:@"" forKey:@"GiftStatus"];
			
			//serialize
			NSData *jsonData=[[CJSONSerializer serializer] serializeObject:[NSNumber numberWithInt:[number intValue]] error:&error];
			NSString *jsonPackage=[[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
			
			//DebugLog
			//NSLog(@"js:%@", jsonPackage);
			
			//send to server
			[appDelegate startNetworkActivity];
			currentRequest=[webService IpGetPickGiftVideoUrl:self action:@selector(getGiftVideoUrlRespond:) key:authKey v_jsonVideoNo:jsonPackage];
			
			
			//[dataDictionary release];
			
			return YES;
		}
	}
	else
	{
		[appDelegate networkConnectionError];
	}
	
	//[dataDictionary release];
	return NO;
}

-(void)getGiftVideoUrlRespond:(NSString*)jsonPackage
{
	NSError *error;
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	[appDelegate stopNetworkActivity];
	
	//DebugLog
	//NSLog(@"%@", jsonPackage);
	
	if(delegate!=nil)
	{
		if([jsonPackage isKindOfClass:[NSError class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@"Service has an error occurred"];
			[self cancel];
			return;
		}
		else if([jsonPackage isKindOfClass:[SoapFault class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@" Soap service fault"];
			[self cancel];
			return;
		}
		
		//DebugLog
		//NSLog(@"%@", jsonPackage);
		
		
		//deserialize
		NSData *jsonData=[jsonPackage dataUsingEncoding:NSUTF32BigEndianStringEncoding];
		NSDictionary *deserializedData=[[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
		
		NSString *giftVideoUrl=[deserializedData valueForKey:@"resString"];
		
		
		[delegate aGiftWebService:self getGiftVideoUrlString:giftVideoUrl];
	}
	
	[self cancel];
}

#pragma mark getAvailableContactList and respond
-(BOOL)getAvailableContactList:(NSMutableArray*)phoneList
{
    NSError *error;
	
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	//NSMutableDictionary *dataDictionary=[[NSMutableDictionary alloc] init];
    NSMutableArray *phoneCollection=[[[NSMutableArray alloc] init] autorelease];
	
	//auth key
	NSString *authKey=appDelegate.userAuthorizedKey;
	
	if([appDelegate isNetworkVaild])
	{
		if(authKey!=nil)
		{
			//[dataDictionary setObject:giftID forKey:@"GiftGuid"];
			//[dataDictionary setObject:@"" forKey:@"GiftStatus"];
            
            //fill phone number
            for(NSString *phoneNumber in phoneList)
            {
                NSMutableDictionary *dic=[[[NSMutableDictionary alloc] init] autorelease];
                
                [dic setObject:phoneNumber forKey:@"ContactPhoneNumber"];
                [phoneCollection addObject:dic];
            }
			
			//serialize
			NSData *jsonData=[[CJSONSerializer serializer] serializeArray:phoneCollection error:&error];
			NSString *jsonPackage=[[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
			
			//DebugLog
			//NSLog(@"js:%@", jsonPackage);
			
			//send to server
			[appDelegate startNetworkActivity];
			currentRequest=[webService GetContactList:self action:@selector(getAvailableContactListRespond:) key:authKey v_jsonContact:jsonPackage];
			
			
			//[dataDictionary release];
			
			return YES;
		}
	}
	else
	{
		[appDelegate networkConnectionError];
	}
	
	//[dataDictionary release];
	return NO;
}

-(void)getAvailableContactListRespond:(NSString*)jsonPackage
{
    NSError *error;
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	[appDelegate stopNetworkActivity];
	
	//DebugLog
	//NSLog(@"%@", jsonPackage);
	
	if(delegate!=nil)
	{
		if([jsonPackage isKindOfClass:[NSError class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@"Service has an error occurred"];
			[self cancel];
			return;
		}
		else if([jsonPackage isKindOfClass:[SoapFault class]])
		{
			[appDelegate webServiceError:@"Service fail" message:@" Soap service fault"];
			[self cancel];
			return;
		}
		
		//DebugLog
		//NSLog(@"%@", jsonPackage);
		
		
		//deserialize
		NSData *jsonData=[jsonPackage dataUsingEncoding:NSUTF32BigEndianStringEncoding];
		NSDictionary *deserializedData=[[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
		
		NSArray* contactListRespond=[deserializedData valueForKey:@"ContactList"];
		
        [delegate aGiftWebService:self getAvailableContactListArray:contactListRespond];
		
	}
	
	[self cancel];
}

-(void)dealloc
{
	if(webService)
	{
		self.webService=nil;
	}
	
	if(delegate)
	{
		self.delegate=nil;
	}
	
	[super dealloc];
}

@end
