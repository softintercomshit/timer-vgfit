//
//  ColorSchemeViewController.h
//  TestTimer
//
//  Created by user on 8/4/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ColorSchemeViewControllerDelegate<NSObject>
@required
-(void) dataFromColorSchemeViewControllerDelegate:(NSString*)data  indexVisualStyleForView:(NSInteger)index;
@end
@interface ColorSchemeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIImageView *navBarImageView;
@property (strong, nonatomic) IBOutlet UIView *navBarUIView;
@property (strong, nonatomic) IBOutlet UITableView *dataFromTableView;
@property (strong,nonatomic) NSString* selectedColorScheme;
@property (weak,nonatomic) id<ColorSchemeViewControllerDelegate>delegate;

@end
