//
//  SoundPickerViewController.h
//  TestTimer
//
//  Created by user on 8/3/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SoundPickerViewControllerDelegate <NSObject>

@required
-(void)dataFromSoundPickerViewController:(NSString*)data indexFromSoundPickerViewController:(NSInteger)index ;

@end

@interface SoundPickerViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UINavigationBarDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *navBarImageView;
@property (strong, nonatomic) IBOutlet UIView *navBarUIView;
@property (strong, nonatomic) IBOutlet UITableView *dataTableView;

@property (strong,nonatomic) NSString* pickedSong;
@property NSInteger pickedIndex;
@property (weak,nonatomic) id <SoundPickerViewControllerDelegate>delegate;

@end
