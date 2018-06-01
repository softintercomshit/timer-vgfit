//
//  MoreTabBarViewController.h
//  TestTimer
//
//  Created by user on 7/26/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MoreTabBarViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
//@property (strong, nonatomic) IBOutlet UITableView *moreDataTableView;
@property (strong, nonatomic) IBOutlet UIImageView *tabbarImageView;
@property (strong, nonatomic) IBOutlet UIView *navBarUIView;
@property (strong, nonatomic) IBOutlet UITableView *dataTableView;

@property (assign) NSInteger selectedIndex;

@end
