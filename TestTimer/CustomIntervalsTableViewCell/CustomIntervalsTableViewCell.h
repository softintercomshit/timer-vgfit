//
//  TabataIntervalsTableViewCell.h
//  TestTimer
//
//  Created by a on 3/17/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomIntervalsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomLabelTopConstraint;
@property (strong, nonatomic) IBOutlet UILabel *customIntervalsTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *customIntervalsDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *customIntervalsTimeValueLabel;

@property (strong, nonatomic) IBOutlet UITextField *customWorkOutTextField;
@property (strong, nonatomic) IBOutlet UIImageView *colorImageViewCollectionCell;



//-(void)loadPrepareIndexColorForImageView:(NSInteger)selectedColorCollectionViewCell;

@end
