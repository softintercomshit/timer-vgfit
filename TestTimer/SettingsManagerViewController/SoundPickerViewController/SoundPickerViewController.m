//
//  SoundPickerViewController.m
//  TestTimer
//
//  Created by user on 8/3/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import "SoundPickerViewController.h"
#import "AppTheme.h"
#import <AVFoundation/AVFoundation.h>
#import "CustomNavigationBarUIView.h"


@interface SoundPickerViewController ()
{
    AVAudioPlayer *audioPlayer;
    NSArray *alertSoundsTimer;
    NSString *stringReplaceExtension;
    UIButton* backButton;
    UIBarButtonItem *customLeftBarButtonItem;
    
}
@property (weak, nonatomic) IBOutlet UIView *customNavigationBarViewIpad;
@property (weak, nonatomic) IBOutlet CustomNavigationBarUIView *customNavigationBarView;
@end

@implementation SoundPickerViewController

int indexSelectedSongs=0;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Sound scheme".localized;
    alertSoundsTimer = [NSArray arrayWithObjects:
                      @"%@/Air Horn.wav",
                      @"%@/Beep.wav",
                      @"%@/Boxing Bell.wav",
                      @"%@/Buzzer.wav",
                      @"%@/Censor.wav",
                      @"%@/Chinese Gong.wav",
                      @"%@/Ding.wav",
                      @"%@/Double Ding.wav",
                      @"%@/Metal Ding.wav",
                      @"%@/Punch.wav",
                      @"%@/Referee Whistle.wav",
                      @"%@/Siren Horn.wav",
                      @"%@/Sports Whistle.wav",
                      @"%@/Tone.wav",
                      nil];
    [self updateUI];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.dataTableView.tableFooterView = [UIView new];
    [self updateUI];
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        [_customNavigationBarView setupLandscapeConstraint];
    }else{
        [_customNavigationBarView setupPortraitConstraint];
    }
}


- (void)loadView
{
    [super loadView];
    backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [backButton setTitle:@"Back".localized forState:UIControlStateNormal];
    backButton.titleLabel.font= [UIFont fontWithName:@"AvenirNext-Regular" size:18];
    [backButton setImage:[UIImage imageNamed:@"Image.png"] forState:UIControlStateNormal];
    [backButton setTintColor:[UIColor colorWithRed:38.0f/255.0f green:182.0f/255.0f blue:155.0f/255.0f alpha:1.0f]];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton sizeToFit];
    [ backButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    customLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = customLeftBarButtonItem;
    
}


- (void) popBack {
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)updateInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if(UIInterfaceOrientationIsLandscape(interfaceOrientation)){
        [_customNavigationBarView setupLandscapeConstraint];
    }else{
        [_customNavigationBarView setupPortraitConstraint];
    }
    
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        [_customNavigationBarView setupLandscapeConstraint];
    }else{
        [_customNavigationBarView setupPortraitConstraint];
    }
}


- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [self updateInterfaceOrientation:toInterfaceOrientation];
    //    [_dataFromTableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [alertSoundsTimer count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SoundPickerViewController" forIndexPath:indexPath];
    
    stringReplaceExtension = [alertSoundsTimer[indexPath.row] stringByReplacingOccurrencesOfString:@"%@/" withString:@""];
    stringReplaceExtension =[stringReplaceExtension stringByReplacingOccurrencesOfString:@".wav" withString:@""];
    cell.textLabel.text=stringReplaceExtension.localized;
    cell.textLabel.font = [UIFont fontWithName:@"Avenir Next" size:15.0f];
    if (indexPath.row == _pickedIndex ) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *path =[NSString stringWithFormat:alertSoundsTimer[indexPath.row],[[NSBundle mainBundle]resourcePath]];
    NSURL *soundUrl=[NSURL fileURLWithPath:path];
    audioPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    
    
    
    if (indexPath.row!=indexSelectedSongs) {
        
        [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] animated:YES];
        [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        indexSelectedSongs= (int)indexPath.row;
        //[audioPlayer play];
    }
    [audioPlayer play];
    _pickedSong=alertSoundsTimer[indexSelectedSongs];
    
    _pickedIndex=indexSelectedSongs;
//    NSLog(@"%@",_pickedSong);
    
    [self SoundPickerTableViewControllerDelegate];
    [_dataTableView reloadData];
}


- (void)SoundPickerTableViewControllerDelegate {
    if ([_delegate respondsToSelector:@selector(dataFromSoundPickerViewController:indexFromSoundPickerViewController:)]) {
        [_delegate dataFromSoundPickerViewController:_pickedSong indexFromSoundPickerViewController:_pickedIndex];
    }
}


- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:AppUpdateThemeNotificationName object:nil];
}
- (void)removeObserver {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AppUpdateThemeNotificationName object:nil];
}

- (void)updateUI {
    
    [_customNavigationBarView setBackgroundColor:[[AppTheme sharedManager] backgroundColor]];
     [_customNavigationBarViewIpad setBackgroundColor:[[AppTheme sharedManager] backgroundColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[[AppTheme sharedManager] labelColor],
       NSFontAttributeName:[UIFont fontWithName:@"Avenir Next" size:18.0]}];
    [backButton setTintColor:[[AppTheme sharedManager] labelColor]];
    [backButton setTitleColor:[[AppTheme sharedManager] labelColor] forState:UIControlStateNormal];
}
-(void)dealloc{
    [self removeObserver];
}


@end
