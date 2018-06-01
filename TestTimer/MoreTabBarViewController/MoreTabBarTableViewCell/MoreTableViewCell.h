//
//  MoreTableViewCell.h
//  TestTimer
//
//  Created by user on 7/27/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *moreImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleMoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionMoreLabel;
@property (strong, nonatomic) IBOutlet UIButton *facebookButton;
@property (strong, nonatomic) IBOutlet UIButton *twitterButton;
@property (strong, nonatomic) IBOutlet UIButton *urlButton;
@property (strong, nonatomic) IBOutlet UIButton *instagramButton;
@property (strong, nonatomic) IBOutlet UIButton *mailButton;
@property (strong, nonatomic) IBOutlet UIImageView *accesoryImageView;
@property (weak, nonatomic) IBOutlet UIView *detailUIView;
@property (weak, nonatomic) IBOutlet UIView *descriptionButtonsUIView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *equalHeightsViewsConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *healthKitImageView;

@end
