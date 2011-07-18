//
//  GiftSectionViewController.h
//  AGiftFree
//
//  Created by Nelson on 2/22/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendGiftInfo.h"


@interface SendGiftSectionViewController: UINavigationController <UINavigationControllerDelegate>{
	
	SendGiftInfo *giftInfoPackage;

}

@property (nonatomic, retain) SendGiftInfo *giftInfoPackage;

-(void)reset;

@end
