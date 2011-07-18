//
//  CategoryMenuView.m
//  AGiftPaid
//
//  Created by Nelson on 3/22/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "CategoryMenuView.h"
#import "GiftSelectionController.h"

@implementation CategoryMenuView

@synthesize owner;
@synthesize categoryButtonContainer;
@synthesize sourceDataDelegate;
@synthesize methodDelegate;


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

-(void)initialize
{
	[self.layer setCornerRadius:10.0f];
	[self.layer setMasksToBounds:YES];
	[self setBackgroundColor:[UIColor colorWithRed:42.0f/255.0f green:13.0f/255.0f blue:9.0f/255.0f alpha:0.7f]];
	
	self.categoryButtonContainer=[[NSMutableArray alloc] init];
	
	//start position point
	positionToSet.x=kWidthSpace;
	positionToSet.y=kHeightSpace;
	
	if(self.sourceDataDelegate!=nil)
	{
		//setup content size base on number of item
		totalItem=[self.sourceDataDelegate numberOfItemInContentWithCategoryScrollView:self];
		[self setupContentSize:totalItem];
		
	}
	
	if(self.sourceDataDelegate!=nil)
	{
		//setup button
		
		for(int i=0; i<totalItem; i++)
		{
			
			UIButton *categoryButton=[UIButton buttonWithType:UIButtonTypeCustom];
			[categoryButton setTag:i];
			[categoryButton setBackgroundImage:[UIImage imageNamed:@"Category.png"] forState:UIControlStateNormal];
			[categoryButton setBackgroundColor:[UIColor clearColor]];
			[categoryButton.titleLabel setFont:[UIFont fontWithName:@"CalibriBold" size:15.0f]];
			[categoryButton setTitleColor:[UIColor colorWithRed:42.0f/255.0f green:13.0f/255.0f blue:9.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
			[categoryButton setTitle:[self.sourceDataDelegate CategoryScrollView:self categoryNameForIndex:i] forState:UIControlStateNormal];
			[categoryButton addTarget:self action:@selector(categoryButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
			
			[categoryButtonContainer addObject:categoryButton];
			[categoryButton release];
		}
		
	}
	
	if(self.sourceDataDelegate!=nil)
	{
		for(int i=0; i<[categoryButtonContainer count]; i++)
		{
			//setup button position
			UIButton *categoryButton=[categoryButtonContainer objectAtIndex:i];
			CGRect buttonRect=CGRectMake(positionToSet.x, positionToSet.y, kItemWidth, kItemHeight);
			
			//set frame
			[categoryButton setFrame:buttonRect];
			
			//calculate next position
			positionToSet=[self calculateNextPosition];
		}
		
		for(int j=0; j<[categoryButtonContainer count]; j++)
		{
			//add button to scroll view
			UIButton *categoryButton=[categoryButtonContainer objectAtIndex:j];
			[self addSubview:categoryButton];
		}
	}
}

#pragma mark methods
-(void)setupContentSize:(NSUInteger)numberOfItem
{
	CGSize contentSize;
	
	contentSize.width=self.frame.size.width;
	contentSize.height=(numberOfItem*kItemHeight)+((numberOfItem+1)*kHeightSpace);
	
	[self setContentSize:contentSize];
}

-(CGPoint)calculateNextPosition
{
	CGPoint newPoisition;
	
	//remain x position
	newPoisition.x=positionToSet.x;
	
	//adjust y position
	newPoisition.y=positionToSet.y+kItemHeight+kHeightSpace;
	
	return newPoisition;
}

-(void)selectItemWithIndex:(NSInteger)selectedIndex
{
	
}

-(void)categoryButtonSelected:(id)sender
{
	
	UIButton *categoryButton=sender;
	
	[owner changeCategoryWithIndex:categoryButton.tag];
}

- (void)dealloc {
	
	[categoryButtonContainer release];
	
    [super dealloc];
}


@end
