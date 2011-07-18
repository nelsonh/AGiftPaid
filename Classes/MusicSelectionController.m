//
//  MusicSelectionView.m
//  AGiftPaid
//
//  Created by Nelson on 3/23/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "MusicSelectionController.h"
#import "MessageController.h"
#import "MusicInfo.h"
#import "MusicImageView.h"
#import "SendGiftSectionViewController.h"
#import "NSData+Base64.h"
#import "AGiftPaidAppDelegate.h"

@implementation MusicSelectionController

@synthesize musicGalleryScrollView;
@synthesize playPausedButton;
@synthesize recordButton;
@synthesize musicSlider;
@synthesize scrollviewSouceData;
@synthesize musicPlayer;
@synthesize currentPlayTimeLabel;
@synthesize musicDurationLabel;
@synthesize musicCurrentPlayTimer;
@synthesize naviTitleView;
@synthesize recordFilePath;
@synthesize soundRecorder;
@synthesize recordCurrentTimer;
@synthesize recordSoundReferenceView;
@synthesize recordImageView;
@synthesize deSelectAllButton;
@synthesize hintButton;
@synthesize hintController;
@synthesize customMusic64Encoding;
@synthesize processingView;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	//AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	NSArray *domainPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docPath=[domainPaths objectAtIndex:0];
	
	self.naviTitleView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iMusic.png"]];
	[self.navigationItem setTitleView:self.naviTitleView];
	
	[self setTitle:@"Music"];
	
	scrollviewSouceData=[[NSMutableArray alloc] init];
	

	[musicSlider setThumbImage:[UIImage imageNamed:@"Music.png"] forState:UIControlStateNormal];
	
	//record file path
	self.recordFilePath=[docPath stringByAppendingPathComponent:@"Record.wav"];

	//self.musicPlayer=[[AVAudioPlayer alloc] init];
	
	//add a record sound image view 
	self.recordImageView=[[RecordImageView alloc] initWithFrame:recordSoundReferenceView.frame];
	[recordImageView setOwner:musicGalleryScrollView];
	[recordImageView setMainController:self];
	[self.view addSubview:recordImageView];
	[recordImageView setHidden:YES];
	
	//build in music
	[self loadBuildinMusic];
	
	/*
	//NSOperationQueue *opQueue=[NSOperationQueue new];
	AGiftWebService *service=[[AGiftWebService alloc] initAGiftWebService];
	[service setDelegate:self];
	[appDelegate.mainOpQueue addOperation:service];
	[service ReceiveGiftMusicList];
	[service release];
	 */
	
	//custom navi right button
	UIImageView *nextButton=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MessageBla.png"]];
	[nextButton setUserInteractionEnabled:YES];
	UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextView)];
	[tapGesture setNumberOfTapsRequired:1];
	[nextButton addGestureRecognizer:tapGesture];
	[tapGesture release];
	
	UIBarButtonItem *nextButtonItem=[[UIBarButtonItem alloc] initWithCustomView:nextButton];
	
	[self.navigationItem setRightBarButtonItem:nextButtonItem];
	[nextButtonItem release];
	
	[musicGalleryScrollView.layer setCornerRadius:4.0f];
	[musicGalleryScrollView.layer setMasksToBounds:YES];
	[musicGalleryScrollView setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.6]];
	
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	
	self.musicGalleryScrollView=nil;
	self.playPausedButton=nil;
	self.recordButton=nil;
	self.musicSlider=nil;
	self.currentPlayTimeLabel=nil;
	self.musicDurationLabel=nil;
	self.naviTitleView=nil;
	self.recordSoundReferenceView=nil;
	self.recordImageView=nil;
	self.deSelectAllButton=nil;
	self.hintButton=nil;
	self.hintController=nil;
	
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark IBAction
-(IBAction)confirmButtonPressed:(id)sender
{
	UIView *senderView=(UIView*)sender;
	
	//anim effect
	CABasicAnimation *expandAnim=[CABasicAnimation animationWithKeyPath:@"transform"];
	[expandAnim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[expandAnim setDuration:0.15];
	[expandAnim setRepeatCount:1];
	[expandAnim setAutoreverses:YES];
	[expandAnim setRemovedOnCompletion:YES];
	[expandAnim setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(2.0, 2.0, 1.0)]];
	[senderView.layer addAnimation:expandAnim forKey:nil];
	
	[self assignInfoToPackage];
	
	if(musicPlayer)
	{
		if([musicPlayer isPlaying])
		{
			[self stopMusic];
		}
	}
	
	MessageController *messageController=[[MessageController alloc] initWithNibName:@"MessageController" bundle:nil];
	[self.navigationController pushViewController:messageController animated:YES];
	[messageController release];
}

-(IBAction)playPausedButtonPressed
{
	if(musicPlayer)
	{
		if([musicPlayer isPlaying])
		{
			//stop
			[self stopMusic];
			
			if(musicCurrentPlayTimer)
			{
				[musicCurrentPlayTimer invalidate];
			}
			
			//reset currentTimeText and slider
			[currentPlayTimeLabel setText:[NSString stringWithString:@"0:0"]];
			[musicSlider setValue:0.0f];
			
		}
		else 
		{
			
			if(musicGalleryScrollView.lastSelectedIcon!=nil)
			{
				[self playMusic];
			}
			else 
			{
				NSFileManager *fileManager=[NSFileManager defaultManager];
				if([fileManager fileExistsAtPath:self.recordFilePath])
				{
					[self playMusicWithPath:self.recordFilePath];
				}
				else 
				{
					NSString *msg=@"You must pick one music to play";
					UIAlertView *pickOneAlert=[[UIAlertView alloc] initWithTitle:@"Pick one" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
					[pickOneAlert show];
					[pickOneAlert release];
				}

			}
		}

	}
	else 
	{
		NSString *msg=@"You must pick one music to play";
		UIAlertView *pickOneAlert=[[UIAlertView alloc] initWithTitle:@"Pick one" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[pickOneAlert show];
		[pickOneAlert release];
	}

}

-(IBAction)recordButtonPressed
{
	AVAudioSession *audioSession=[AVAudioSession sharedInstance];
	
	//check hardware support or not
	if(!audioSession.inputIsAvailable)
	{
		NSString *msg=@"Your device not support for recording sound";
		UIAlertView *recordAlert=[[UIAlertView alloc] initWithTitle:@"Device not support" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[recordAlert show];
		[recordAlert release];
	}
	else
	{
		//check music is playing or not 
		if([musicPlayer isPlaying])
		{
			//stop music
			[self stopMusic];
			
			//deSelect gallery last icon
			[musicGalleryScrollView deSelectLastIcon];
		}
		
		if(soundRecorder.recording)
		{
			[self stopRecord];
		}
		else
		{
			//start record
			[self startRecord];
		}
	}
}

-(IBAction)deSelectAllButtonPressed
{
	if(musicGalleryScrollView.lastSelectedIcon)
	{
		[musicGalleryScrollView.lastSelectedIcon deSelected];
		musicGalleryScrollView.lastSelectedIcon=nil;
	}
	
	if(recordImageView.isSelected)
	{
		[recordImageView deSelected];
	}
	
	[self stopMusic];
	
	if(musicPlayer)
		self.musicPlayer=nil;
	
}

-(IBAction)hintButtonPress
{
	
	
	if(hintController)
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
		[UIView setAnimationDuration:1.0];
		
		[self.view addSubview:hintController.view];
		
		[UIView commitAnimations];
	}
	
}

#pragma mark method
-(void)nextView
{
	[self assignInfoToPackage];
	
	[self disableHint];
	
	if(musicPlayer)
	{
		if([musicPlayer isPlaying])
		{
			[self stopMusic];
		}
	}
	
	MessageController *messageController=[[MessageController alloc] initWithNibName:@"MessageController" bundle:nil];
	[self.navigationController pushViewController:messageController animated:YES];
	[messageController release];
}

-(void)loadBuildinMusic
{
	NSString *buildinMusicPlist=[[NSBundle mainBundle] pathForResource:@"BuildinMusic" ofType:@"plist"];
	NSArray *buildinMusicList=[[NSArray alloc] initWithContentsOfFile:buildinMusicPlist];
	
	for(int i=0; i<[buildinMusicList count]; i++)
	{
		NSString *item=[buildinMusicList objectAtIndex:i];
		NSArray *stringSet=[item componentsSeparatedByString:@"-"];
		NSArray *musicNameSet=[[stringSet objectAtIndex:1] componentsSeparatedByString:@"."];
		
		NSString *musicID=[stringSet objectAtIndex:0];
		NSString *musicFileName=[musicNameSet objectAtIndex:0];
		
		MusicInfo *newMusicInfo=[[MusicInfo alloc] init];
		
		[newMusicInfo.musicIconPresenter setOwner:musicGalleryScrollView];
		[newMusicInfo assignNumber:[musicID intValue]];
		[newMusicInfo assignMusicFileName:musicFileName];
		
		[scrollviewSouceData addObject:newMusicInfo];
		
		[newMusicInfo release];
	}
	
	[musicGalleryScrollView initialize];
	

}

-(void)startRecord
{
	if(soundRecorder)
		self.soundRecorder=nil;
	
	NSMutableDictionary *recordSetting=[[NSMutableDictionary alloc] init];
	NSError *error;
	
	
	[recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
	[recordSetting setValue:[NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey]; 
	[recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
	
	/*
	[recordSetting setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
	[recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey]; 
	[recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
	*/
	
	[recordSetting setValue :[NSNumber numberWithInt:8] forKey:AVLinearPCMBitDepthKey];
	[recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
	[recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];

	
	NSURL *recordFileURL=[NSURL fileURLWithPath:recordFilePath];
	
	AVAudioSession *audioSession=[AVAudioSession sharedInstance];
	[audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
	
	AVAudioRecorder *audioRecorder=[[AVAudioRecorder alloc] initWithURL:recordFileURL settings:recordSetting error:&error];
	[audioRecorder setDelegate:self];
	[audioRecorder setMeteringEnabled:YES];
	[audioRecorder prepareToRecord];
	self.soundRecorder=audioRecorder;
	[audioRecorder release];
	
	[soundRecorder recordForDuration:(NSTimeInterval)KRecordDuration];
	
	if(recordCurrentTimer)
	{
		[recordCurrentTimer invalidate];
	}
	
	self.recordCurrentTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateRecordTime) userInfo:nil repeats:YES];
	
	//reset currentTimeText and slider
	[currentPlayTimeLabel setText:[NSString stringWithString:@"0:0"]];
	[musicDurationLabel setText:[NSString stringWithString:@"-0:20"]];
	[musicSlider setValue:0.0f];
	
	//set slider
	[musicSlider setMaximumValue:KRecordDuration];
	
	[recordButton setImage:[UIImage imageNamed:@"Stop.png"] forState:UIControlStateNormal];
	//[recordButton setTitle:@"Stop" forState:UIControlStateNormal];
	
	
	[musicGalleryScrollView setUserInteractionEnabled:NO];
	[playPausedButton setHidden:YES];

	[deSelectAllButton setHidden:YES];
	
	if(!recordImageView.hidden)
	{
		[recordImageView setHidden:YES];
	}
	
	
	[soundRecorder record];
	
	[self.navigationItem setHidesBackButton:YES];
}

-(void)stopRecord
{
	[soundRecorder stop];
	
	if(recordCurrentTimer)
	{
		[recordCurrentTimer invalidate];
	}
}

-(void)playMusic
{
	NSFileManager *fileManager=[NSFileManager defaultManager];
	
	NSArray *domainPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docDirectory=[domainPaths objectAtIndex:0];
	
	NSError *error;
	NSURL *musicURL;
	
	NSUInteger index=musicGalleryScrollView.lastSelectedIcon.index;
	MusicInfo *musicInfo=[scrollviewSouceData objectAtIndex:index];
	
	//check if music is in bundle or in disk
	if(musicInfo.musicURL)
	{
		//in disk mean music download from server
		NSString *musicFileName=[musicInfo.musicPrefix stringByAppendingString:musicInfo.musicFileName];
		NSString *musicFilePath=[docDirectory stringByAppendingPathComponent:musicFileName];
		
		if([fileManager fileExistsAtPath:musicFileName])
		{
			musicURL=[NSURL fileURLWithPath:musicFilePath];
		}
	}
	else 
	{
		//in bundle
		NSString *bundleResourcePath=[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%i-%@", musicInfo.musicNumber, musicInfo.musicFileName] ofType:@"mp3"];
		
		if([fileManager fileExistsAtPath:bundleResourcePath])
		{
			musicURL=[NSURL fileURLWithPath:bundleResourcePath];
		}
	}


	if(musicPlayer)
	{
		if([musicPlayer isPlaying])
			[self stopMusic];
	}
	
	AVAudioSession *audioSession=[AVAudioSession sharedInstance];
	[audioSession setCategory:AVAudioSessionCategoryPlayback error:&error];
	
	AVAudioPlayer *player=[[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:&error];
	[player setDelegate:self];
	[player setCurrentTime:0.0f];
	[player prepareToPlay];
	self.musicPlayer=player;
	[musicPlayer play];
	
	[player release];
	
	if(musicCurrentPlayTimer)
	{
		[musicCurrentPlayTimer invalidate];
	}
	
	self.musicCurrentPlayTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateMusicPlay) userInfo:nil repeats:YES];
	
	//reset currentTimeText and slider
	[currentPlayTimeLabel setText:[NSString stringWithString:@"0:0"]];
	[musicSlider setValue:0.0f];
	
	//calculate time
	NSUInteger duration=musicPlayer.duration;
	NSString *durationText=[NSString stringWithFormat:@"%i:%i", (duration/60)%60, duration%60];
	[musicDurationLabel setText:durationText];
	
	//set slider
	[musicSlider setMaximumValue:duration];
	
	[playPausedButton setImage:[UIImage imageNamed:@"Pause.png"] forState:UIControlStateNormal];
	//[playPausedButton setTitle:@"Stop" forState:UIControlStateNormal];
}

-(void)playMusicWithPath:(NSString*)filePath
{
	NSError *error;
	NSURL *musicURL=[NSURL fileURLWithPath:filePath];
	
	if(musicPlayer)
	{
		if([musicPlayer isPlaying])
			[self stopMusic];
	}
	
	AVAudioSession *audioSession=[AVAudioSession sharedInstance];
	[audioSession setCategory:AVAudioSessionCategoryPlayback error:&error];
	
	AVAudioPlayer *player=[[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:&error];
	[player setDelegate:self];
	[player setCurrentTime:0.0f];
	[player prepareToPlay];
	self.musicPlayer=player;
	[musicPlayer play];
	
	[player release];
	
	if(musicCurrentPlayTimer)
	{
		[musicCurrentPlayTimer invalidate];
	}
	
	self.musicCurrentPlayTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateMusicPlay) userInfo:nil repeats:YES];
	
	//reset currentTimeText and slider
	[currentPlayTimeLabel setText:[NSString stringWithString:@"0:0"]];
	[musicSlider setValue:0.0f];
	
	//calculate time
	NSUInteger duration=musicPlayer.duration;
	NSString *durationText=[NSString stringWithFormat:@"-%i:%i", (duration/60)%60, duration%60];
	[musicDurationLabel setText:durationText];
	
	//set slider
	[musicSlider setMaximumValue:duration];
	
	
	[playPausedButton setImage:[UIImage imageNamed:@"Pause.png"] forState:UIControlStateNormal];
	//[playPausedButton setTitle:@"Stop" forState:UIControlStateNormal];
}

-(void)stopMusic
{
	if(musicPlayer)
	{
		if([musicPlayer isPlaying])
		{
			[musicPlayer stop];
			
			[playPausedButton setImage:[UIImage imageNamed:@"Play.png"] forState:UIControlStateNormal];
			//[playPausedButton setTitle:@"Play" forState:UIControlStateNormal];
			
			if(musicCurrentPlayTimer)
			{
				[musicCurrentPlayTimer invalidate];
			}
			
			//reset currentTimeText and slider
			[currentPlayTimeLabel setText:[NSString stringWithString:@"0:0"]];
			[musicSlider setValue:0.0f];
		}
		
		//self.musicPlayer=nil;
	}
}

-(void)updateMusicPlay
{
	NSUInteger currentTime=musicPlayer.currentTime+1;
	NSString *currentTimeText=[NSString stringWithFormat:@"%i:%i", (currentTime/60)%60, currentTime%60];
	[currentPlayTimeLabel setText:currentTimeText];
	
	NSUInteger decreaseTime=musicPlayer.duration-musicPlayer.currentTime;
	NSString *decreaseTimeText=[NSString stringWithFormat:@"-%i:%i", (decreaseTime/60)%60, decreaseTime%60];
	[musicDurationLabel setText:decreaseTimeText];
	
	//set slider
	[musicSlider setValue:currentTime];
}

-(void)updateRecordTime
{
	NSString *increaseTimeText;
	NSString *decreaseTimeText;
	
	NSUInteger decreaseTime=KRecordDuration-soundRecorder.currentTime+2;
	if(decreaseTime>=0)
		decreaseTimeText=[NSString stringWithFormat:@"-0:%i", decreaseTime];
	
	NSUInteger increaseTime=soundRecorder.currentTime-1;
	if(increaseTime<=KRecordDuration)
		increaseTimeText=[NSString stringWithFormat:@"0:%i", increaseTime];
	
	
	if(increaseTimeText!=nil && decreaseTimeText!=nil)
	{
		[currentPlayTimeLabel setText:increaseTimeText];
		[musicDurationLabel setText:decreaseTimeText];
	}
	
	
	//set slider
	[musicSlider setValue:increaseTime];
}

-(void)assignInfoToPackage
{
	SendGiftSectionViewController *rootNaviController=(SendGiftSectionViewController*)self.navigationController;
	SendGiftInfo *package=rootNaviController.giftInfoPackage;
	
	MusicInfo *musicInfo=[scrollviewSouceData objectAtIndex:musicGalleryScrollView.lastSelectedIcon.index];
	
	if(musicGalleryScrollView.lastSelectedIcon!=nil)
	{
		//user pick build in music
		NSString *musicID=[NSString stringWithFormat:@"%i", musicInfo.musicNumber];
		[package setGiftDefMusicID:musicID];
		[package setMusicName:musicInfo.musicFileName];
	}
	else if(recordImageView.isSelected)
	{

		
		[package setCustomMusicFileName:@"CustomMusic.wav"];
		[package setCustomMusic64Encoding:customMusic64Encoding];
		
		[package setMusicName:@"CustomMusic"];
	}

}

-(void)disableHint
{
	[hintController closeButtonPress];
}

-(void)startProcessingCustomMusic
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	UIActionSheet *actionSheet=[[[UIActionSheet alloc] initWithTitle:@"Processing sound. Please wait." delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil] autorelease];
	UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[activityView setFrame:CGRectMake(257, 10, activityView.frame.size.width, activityView.frame.size.height)];
	[activityView setHidden:NO];
	[activityView startAnimating];
	[actionSheet addSubview:activityView];
	[activityView release];
	
	
	self.processingView=actionSheet;
	
	[actionSheet showInView:appDelegate.rootController.view];
	
	[self performSelector:@selector(doProcessingCustomMusic) withObject:nil afterDelay:1];
}

-(void)doProcessingCustomMusic
{
	//user has custom music
	NSData *customMusicData=[NSData dataWithContentsOfFile:self.recordFilePath];
	self.customMusic64Encoding=[customMusicData base64Encoding];
	
	[self.processingView dismissWithClickedButtonIndex:0 animated:YES];
	self.processingView=nil;
}

#pragma mark AGiftWebServiceDelegate
-(void)aGiftWebService:(AGiftWebService*)webService ReceiveGiftMusicListtArray:(NSArray*)respondData
{
	for(int i=0; i<[respondData count]; i++)
	{
		MusicInfo *newMusicInfo=[[MusicInfo alloc] init];
		
		NSDictionary *dic=[respondData objectAtIndex:i];
		NSNumber *musicID=[dic valueForKey:@"MusicID"];
		NSString *musicDownloadURL=[dic valueForKey:@"MusicUri"];
		NSString *musicFileName=[dic valueForKey:@"MusicFilename"];
		
		[newMusicInfo.musicIconPresenter setOwner:musicGalleryScrollView];
		[newMusicInfo assignNumber:[musicID integerValue]];
		[newMusicInfo setMusicURL:musicDownloadURL];
		[newMusicInfo assignMusicFileName:musicFileName];
		
		[scrollviewSouceData addObject:newMusicInfo];
		
		[newMusicInfo downloadMusic];
		
		[newMusicInfo release];
	}
	
	[musicGalleryScrollView initialize];
	

}

#pragma mark MusicGalleryScrollViewDelegate
-(void)GalleryScrollView:(MusicGalleryScrollView*)musicGalleryScrollView didSelectItemWithIndex:(NSUInteger)index
{
	if(recordImageView.isSelected)
	{
		[recordImageView deSelected];
	}
	
	//tell music player to play specific music
	MusicInfo *musicInfo=[scrollviewSouceData objectAtIndex:index];
	
	if(!musicInfo.isDownloadingMusic)
	{
		[self playMusic];
	}
	else 
	{
		NSString *msg=@"Downloading is in progress";
		UIAlertView *isDownloadingAlert=[[UIAlertView alloc] initWithTitle:@"Music downloading" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[isDownloadingAlert show];
		[isDownloadingAlert release];
	}

	
}

#pragma mark MusicGalleryScrollViewSourceDataDelegate
-(NSUInteger)numberOfItemInContentWithMusicGalleryScrollView:(MusicGalleryScrollView*)musicGalleryScrollView
{
	return [scrollviewSouceData count];
}

-(MusicImageView*)GalleryScrollView:(MusicGalleryScrollView*)musicGalleryScrollView musicIconViewForIndex:(NSUInteger)index
{
	MusicInfo *musicInfo=[scrollviewSouceData objectAtIndex:index];
	
	return musicInfo.musicIconPresenter;
}

#pragma mark AVAudioPlayerDelegate
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
	if(musicCurrentPlayTimer)
	{
		[musicCurrentPlayTimer invalidate];
	}
	
	//reset currentTimeText and slider
	[currentPlayTimeLabel setText:[NSString stringWithString:@"0:0"]];
	[musicSlider setValue:0.0f];
	
	[playPausedButton setImage:[UIImage imageNamed:@"Play.png"] forState:UIControlStateNormal];
	//[playPausedButton setTitle:@"Play" forState:UIControlStateNormal];
}

#pragma mark AVAudioRecorderDelegate
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
	[self.navigationItem setHidesBackButton:NO];
	
	//processing sound
	[self startProcessingCustomMusic];
	
	if(recordCurrentTimer)
	{
		[recordCurrentTimer invalidate];
	}
	
	[musicGalleryScrollView setUserInteractionEnabled:YES];
	[playPausedButton setHidden:NO];

	
	[recordButton setImage:[UIImage imageNamed:@"Recording.png"] forState:UIControlStateNormal];
	//[recordButton setTitle:@"Record" forState:UIControlStateNormal];
	
	//[self playMusicWithPath:self.recordFilePath];
	
	//show record image view and make it selected
	[recordImageView setHidden:NO];
	[recordImageView.frontImage doSelected];
	
	[deSelectAllButton setHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
	if(musicPlayer)
	{
		if([musicPlayer isPlaying])
		{
			[self stopMusic];
		}
	}
}

- (void)dealloc {
	
	[musicGalleryScrollView release];
	[playPausedButton release];
	[recordButton release];
	[musicSlider release];
	[scrollviewSouceData release];
	[hintButton release];
	[hintController release];
	
	if(musicPlayer)
		[musicPlayer release];
	
	[currentPlayTimeLabel release];
	[musicDurationLabel release];
	[naviTitleView release];
	[recordFilePath release];
	
	if(soundRecorder)
		[soundRecorder release];
	
	[recordSoundReferenceView release];
	[recordImageView release];
	[deSelectAllButton release];
	[customMusic64Encoding release];
	[processingView release];
	
    [super dealloc];
}

@end
