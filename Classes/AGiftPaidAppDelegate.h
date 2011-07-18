//
//  AGiftPaidAppDelegate.h
//  AGiftPaid
//
//  Created by Nelson on 3/21/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "BackViewController.h"
#import "CoreDataManager.h"
#import "AGiftWebService.h"
#import "Reachability.h"
#import "MessageEditView.h"
#import "MessageEditViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AddressBook/AddressBook.h>

extern NSString *const RegisterStatusFileName;
extern NSString *const RegisterUserName;
extern NSString *const RegisterPhoneNumber;
extern NSString *const RegisterPhotoImage;
extern NSString *const RegisterAuthorizedKey;
extern NSString *const VerifyName;
extern NSString *const VerifyCode;

@interface AGiftPaidAppDelegate : NSObject <UITabBarDelegate, UIApplicationDelegate, AGiftWebServiceDelegate, UIAlertViewDelegate> {
    
    UIWindow *window;
	
	UIButton *tryAgainButton;
	UIImageView *noConnectionImageView;
	
	//back view
	BackViewController *backViewController;
	
	//AGift root 
	UITabBarController *rootController;
	
	//instruction
	UIView *instructionView;
	
	//store user reigster info storage
	NSMutableDictionary *registerStatus;

	
	//user's info temp
	NSString *userName;
	NSString *userPhoneNumber;
	NSData *userPhotoImage;
	NSString *userAuthorizedKey;
	
	//verify
	NSString *verifyUserName;
	NSString *verifyPassword;
	
	//core data manager
	CoreDataManager *dataManager;
	
	//message edit view
	MessageEditViewController *msgEditView;
	
	NSUInteger activityInvockCount;
	
	NSOperationQueue *mainOpQueue;
	
	BOOL firstRegister;
    
@private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet BackViewController *backViewController;
@property (nonatomic, retain) IBOutlet UITabBarController *rootController;
@property (nonatomic, retain) IBOutlet MessageEditViewController *msgEditView;
@property (nonatomic, retain) IBOutlet UIButton *tryAgainButton;
@property (nonatomic, retain) IBOutlet UIImageView *noConnectionImageView;
@property (nonatomic, retain) IBOutlet UIView *instructionView;
@property (nonatomic, retain) NSMutableDictionary *registerStatus;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *userPhoneNumber;
@property (nonatomic, retain) NSData *userPhotoImage;
@property (nonatomic, retain) NSString *userAuthorizedKey;
@property (nonatomic, retain) NSString *verifyUserName;
@property (nonatomic, retain) NSString *verifyPassword;
@property (nonatomic, retain) NSOperationQueue *mainOpQueue;
@property (nonatomic, assign) BOOL firstRegister;

@property (nonatomic, retain) CoreDataManager *dataManager;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;
- (void)syncDataAndInfo;
- (BOOL)hasFileInPath:(NSString*)fileDirectoryPath FileName:(NSString*)fileName FileFormat:(NSString*)fileFormat;
- (NSMutableDictionary*)registerStatusInfo;
- (void)fetchVerifyInfo;
- (void)fetchRegisterInfo;
- (void)fetchCoreData;
- (BOOL)saveRegisterInfo;
- (void)checkRegisterStatus;
- (void)presentAGiftRootView;
- (void)presentAGiftRootViewMultiTask;
- (BOOL)isNetworkVaild;
- (void)createCoreDataManager;
- (void)presentNewController:(UIViewController*)newController animated:(BOOL)animation;
- (void)webServiceError:(NSString*)title message:(NSString*)msg;
- (void)networkConnectionError;
- (NSMutableDictionary*)registerStatusInfo;
- (void)startEditMessage:(UITextView*)inTextView;
- (void)doneEditMessage;
- (void)doneEditMessageAnimationDidStop;
- (void)startEditMessageAnimationDidStop;
- (void)startNetworkActivity;
- (void)stopNetworkActivity;
- (void)retrieveAuthorizeKey;
- (void)refreshTabbarTitle:(NSString*)title index:(NSUInteger)index;
- (void)internetFail;
- (void)startInstructionAnim;
- (void)showInstructionAnim;
- (void)instructionViewDidFinish;
- (void)dismissInstructionViewAnim;
- (void)dismissInstructionViewDidFinish;
- (IBAction)tryAgainButtonPress;
-(void)importContactList;
-(void)doImportContactList;

@end

