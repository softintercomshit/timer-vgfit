//
//  SettingsManagerTableViewController.h
//  TestTimer
//
//  Created by a on 1/26/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import <UIKit/UIKit.h>


//#import <AVFoundation/AVFoundation.h>
@interface SettingsManagerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
   
    //CustomView *customView;
}
@property (strong,nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) IBOutlet UITableView *dataTableView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *customViewSettings;

@property (strong,nonatomic) UIBarButtonItem *customRightBarButtonItem;
@property (strong,nonatomic) UIBarButtonItem *leftBarButtonItem;
@property (strong, nonatomic) IBOutlet UIView *viewForScreenFlashOperation;
@property (strong, nonatomic) IBOutlet UIImageView *customImageView;
@property (strong,nonatomic) NSString *themeName;

@end
