//
//  PhotoCell.h
//  AGiftPaid
//
//  Created by Nelson on 5/11/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PhotoCell : UITableViewCell {
	
	UIImageView *photoImageView;
	UILabel *noPhotoLabel;

}

@property (nonatomic, retain) IBOutlet UIImageView *photoImageView;
@property (nonatomic, retain) IBOutlet UILabel *noPhotoLabel;

@end
