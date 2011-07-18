//
//  MusicSelectionView.h
//  AGiftPaid
//
//  Created by Nelson on 3/23/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicGalleryScrollView.h"
#import "AGiftWebService.h"
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "RecordImageView.h"
#import "MusicSelectionHintController.h"

#define KRecordDuration 20.0

@interface MusicSelectionController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate, MusicGalleryScrollViewSourceDataDelegate, MusicGalleryScrollViewDelegate, AGiftWebServiceDelegate>{
	
	MusicGalleryScrollView *musicGalleryScrollView;
	
	UIButton *deSelectAllButton;
	UIButton *playPausedButton;
	UIButton *recordButton;
	UISlider *musicSlider;
	UILabel *currentPlayTimeLabel;
	UILabel *musicDurationLabel;
	NSTimer *musicCurrentPlayTimer;
	UIImageView *naviTitleView;
	NSString *recordFilePath;
	NSTimer *recordCurrentTimer;
	UIView *recordSoundReferenceView;
	RecordImageView *recordImageView;
	UIButton *hintButton;
	MusicSelectionHintController *hintController;
	NSString *customMusic64Encoding;
	UIActionSheet *processingView;
	
	NSMutableArray *scrollviewSouceData;
	AVAudioPlayer *musicPlayer;
	AVAudioRecorder *soundRecorder;
}

@property (nonatomic, retain) IBOutlet MusicGalleryScrollView *musicGalleryScrollView;
@property (nonatomic, retain) IBOutlet UIButton *deSelectAllButton;
@property (nonatomic, retain) IBOutlet UIButton *playPausedButton;
@property (nonatomic, retain) IBOutlet UIButton *recordButton;
@property (nonatomic, retain) IBOutlet UISlider *musicSlider;
@property (nonatomic, retain) IBOutlet UILabel *currentPlayTimeLabel;
@property (nonatomic, retain) IBOutlet UILabel *musicDurationLabel;
@property (nonatomic, retain) IBOutlet UIView *recordSoundReferenceView;
@property (nonatomic, retain) IBOutlet UIButton *hintButton;
@property (nonatomic, retain) IBOutlet MusicSelectionHintController *hintController;
@property (nonatomic, retain) RecordImageView *recordImageView;
@property (nonatomic, retain) NSMutableArray *scrollviewSouceData;
@property (nonatomic, retain) AVAudioPlayer *musicPlayer;
@property (nonatomic, retain) AVAudioRecorder *soundRecorder;
@property (nonatomic, retain) NSTimer *musicCurrentPlayTimer;
@property (nonatomic, retain) UIImageView *naviTitleView;
@property (nonatomic, retain) NSString *recordFilePath;
@property (nonatomic, retain) NSTimer *recordCurrentTimer;
@property (nonatomic, retain) NSString *customMusic64Encoding;
@property (nonatomic, retain) UIActionSheet *processingView;

-(IBAction)confirmButtonPressed:(id)sender;
-(IBAction)playPausedButtonPressed;
-(IBAction)recordButtonPressed;
-(IBAction)deSelectAllButtonPressed;
-(IBAction)hintButtonPress;

-(void)playMusic;
-(void)playMusicWithPath:(NSString*)filePath;
-(void)stopMusic;
-(void)updateMusicPlay;
-(void)updateRecordTime;
-(void)assignInfoToPackage;
-(void)startRecord;
-(void)stopRecord;
-(void)loadBuildinMusic;
-(void)nextView;
-(void)disableHint;
-(void)startProcessingCustomMusic;
-(void)doProcessingCustomMusic;

@end
