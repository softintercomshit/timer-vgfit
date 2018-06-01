//
//  TimeFormatViewController.h
//  TestTimer
//
//  Created by user on 8/3/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TimeFormatViewControllerDelegate <NSObject>
@required
-(void) dataFromTimeFormatViewController:(NSString*)data indexFromTimeFormatViewController:(NSInteger)index;
@end



@interface TimeFormatViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *navBarView;
@property (strong, nonatomic) IBOutlet UIImageView *navBarImageView;
@property (strong,nonatomic) NSString* selectedTimeFormat;
@property (assign,nonatomic) NSInteger selectedIndex;

@property (strong, nonatomic) IBOutlet UITableView *dataTableView;
@property (weak,nonatomic) id<TimeFormatViewControllerDelegate>delegate;
@end
