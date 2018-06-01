#import "MoreTabBarViewController.h"
#import "MoreTableViewCell.h"
#import "CustomHeaderTableViewCell.h"
#import "AppTheme.h"
#import "CustomNavigationBarUIView.h"
#import <StoreKit/StoreKit.h>
#import "BundleImageLoader.h"

@import Social;
@import MessageUI;

static NSString *cellIdentifier = @"MoreTableViewCell";

typedef NS_ENUM(NSInteger, RowType) {
    RowTypeVGFIT = 0,
    RowTypeRateUs,
    RowTypeSendFeed,
    RowTypeTellFriend,
    RowTypeShareApp,
//    RowTypeShareFacebook,
//    RowTypeSendTweet,
    RowTypeSevenMinutes,
    RowTypeWaterReminder,
    RowTypeTimerPro,
    RowTypeSixPack,
    RowTypeFitnessBodybuilding,
    RowTypeFemaleFitness,
    RowTypeYoga,
    RowTypeHealthKit
};

@interface MoreTabBarViewController()<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
{
    NSArray *arrayWithData;
    NSArray *arrayWithImagesForMoreTabBar;
    RowType rowType;
    __weak IBOutlet NSLayoutConstraint *heightConstraintForNavigationBar;
}
@property (weak, nonatomic) IBOutlet CustomNavigationBarUIView *customNavigationBarView;
@property (weak, nonatomic) IBOutlet UIView *customNavigationBarViewIpad;

@property  (nonatomic, retain) SLComposeViewController *mySLComposerSheet;
@end

@implementation MoreTabBarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"More".localized;
    
    [self.dataTableView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellReuseIdentifier:cellIdentifier];
    
    arrayWithData = @[@"Stay connected with VGFIT".localized,
                      @"Rate us".localized,
                      @"Send feedback".localized,
                      @"Tell a friend".localized,
                      @"Share app".localized,
                      @"VGFIT Workout".localized,
                      @"Water Reminder".localized,
                      @"Timer Pro by VGFIT".localized,
                      @"ABS Workout".localized,
                      @"Fitness VIP".localized,
                      @"Female Fitness".localized,
                      @"Yoga by VGFIT".localized,
                      @" "];
    
    arrayWithImagesForMoreTabBar = @[@"VGFITIcon",
                                     @"rateUsIcon",
                                     @"sendFeedIcon",
                                     @"tellAFriendIcon",
                                     @"shareApp",
                                     @"VGFIT Workout",
                                     @"waterReminderIcon",
                                     @"timerProIcon",
                                     @"sixPackIcon",
                                     @"fitnessBodybuildingIcon",
                                     @"femaleFitIcon",
                                     @"yogaIcon",
                                     @" "];
    _selectedIndex = -1;
    
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavbarAppearence];
    self.dataTableView.tableFooterView = [UIView new];
    [self updateUI];
    
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication]statusBarOrientation])) {
        [_customNavigationBarView setupLandscapeConstraint];
    }else{
        [_customNavigationBarView setupPortraitConstraint];
    }
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


- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self updateInterfaceOrientation:toInterfaceOrientation];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrayWithImagesForMoreTabBar count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MoreTableViewCell *cell = (MoreTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    [self.dataTableView setContentInset:UIEdgeInsetsMake(0, 0, 10, 0)];
    cell.titleMoreLabel.text = [arrayWithData objectAtIndex:indexPath.row];

    [BundleImageLoader loadImageWithName:arrayWithImagesForMoreTabBar[indexPath.row] completion:^(UIImage *image) {
        cell.moreImageView.image = image;
        [UIView animateWithDuration:0.2 animations:^{
            cell.moreImageView.alpha = 1.0;
        }];
    }];
    
    cell.moreImageView.layer.cornerRadius = 10.0f;
    cell.moreImageView.clipsToBounds = YES;
    [cell.facebookButton addTarget:self action:@selector(facebookLink) forControlEvents:UIControlEventTouchUpInside];
    [cell.twitterButton addTarget:self action:@selector(twitterLink) forControlEvents:UIControlEventTouchUpInside];
    [cell.urlButton addTarget:self action:@selector(urlLink) forControlEvents:UIControlEventTouchUpInside];
    [cell.instagramButton addTarget:self action:@selector(instagramLink) forControlEvents:UIControlEventTouchUpInside];
    [cell.mailButton addTarget:self action:@selector(mailLink) forControlEvents:UIControlEventTouchUpInside];

    if(_selectedIndex == indexPath.row) {
        [cell.detailUIView setHidden:false];
        [cell.descriptionButtonsUIView setHidden:false];
        cell.accesoryImageView.hidden = false;
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckClose.png"]];
        cell.descriptionMoreLabel.text = @"www.vgfit.com";
    }else {
        [cell.detailUIView setHidden:false];
        [cell.descriptionButtonsUIView setHidden:true];
        cell.descriptionMoreLabel.text = @"";
        cell.accesoryImageView.hidden = true;
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkOpen.png"]];
    }

    [self showInCell:cell atIndex:indexPath.row];
    
    return cell;
}


- (void)showInCell:(MoreTableViewCell*)cell atIndex:(NSInteger)index {
        if (index == RowTypeHealthKit) {
            cell.healthKitImageView.hidden = false;
            cell.userInteractionEnabled = false;
            cell.accessoryView.hidden = true;
        }else {
            cell.healthKitImageView.hidden = true;
            cell.userInteractionEnabled = true;
            cell.accessoryView.hidden = false;
        }
}

- (void)facebookLink{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/valerio.gutu?fref=ts"]];
}


- (void)twitterLink{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/GutuValeriu"]];
}

- (void)urlLink{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://vgfit.com/home"]];
}

- (void)instagramLink{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.instagram.com/valeriu_gutu/"]];
}

- (void)mailLink{
    [self mailSetupButtonAction];
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"team@vgfit.com"]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_selectedIndex == indexPath.row) {
        return 131;
    }else{
        return 65;
    }
}

- (void)vgfitMethod {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.dataTableView deselectRowAtIndexPath:indexPath animated:YES];
    if(_selectedIndex == indexPath.row) {
        _selectedIndex = -1;
        [self.dataTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        return;
    }
    // when tapped different row
    if(_selectedIndex == -1) {
        NSIndexPath *prevIndexPath = [NSIndexPath indexPathForRow:_selectedIndex inSection:0];
        _selectedIndex = indexPath.row;
        [self.dataTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:prevIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    _selectedIndex = indexPath.row;
    [self.dataTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case RowTypeVGFIT:
            [self vgfitMethod];
            break;
        case RowTypeRateUs:
            [self rateUsCellPressed];
            break;
        case RowTypeSendFeed:
            [self sendFeedbackCellPressed];
            break;
        case RowTypeTellFriend:
            [self tellAFriendCellPressed];
            break;
        case RowTypeShareApp:
            [self shareApp];
            break;
            
//        case RowTypeShareFacebook:  [self shareOnFacebookButtonPressed];
//            break;
//        case RowTypeSendTweet:      [self shareOnTwitterButtonPressed];
//            break;
        case RowTypeSevenMinutes:   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/7-minute-workout-vgfit/id1178939968?mt=8"]];
            break;
        case RowTypeWaterReminder:  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/water-reminder-drink-water/id1221965482?mt=8"]];
            break;
        case RowTypeTimerPro: [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/timer-plus-workouts-timer/id1279716547?mt=8"]];
            break;
        case RowTypeSixPack: [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/six-pack-abs-by-vgfit/id843233267?mt=8"]];
            break;
        case RowTypeFitnessBodybuilding: [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/fitness-bodybuilding-exercises/id698154775?mt=8"]];
            break;
        case RowTypeFemaleFitness: [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/female-fitness-best-exercises/id698172579?mt=8"]];
            break;
        case RowTypeYoga: [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/yoga-poses-classes/id1122658784?mt=8"]]; break;
        default:
            break;
    }
}


-(void) mailSetupButtonAction
{
    if (![MFMailComposeViewController canSendMail]) {
        [self showAlertControllerwithTitle:@"No Mail Accounts".localized withMessage:@"Please set up a Mail account in order to send email.".localized];
        // NSLog(@"Mail services are not available.");
        return;
    }
    
    MFMailComposeViewController* composeVC = [[MFMailComposeViewController alloc] init];
    composeVC.mailComposeDelegate = self;
    
    // Configure the fields of the interface.
    [composeVC setToRecipients:@[@"team@vgfit.com"]];
    [composeVC setSubject:@"Timer Pro by Valerio Gucci:\n Support"];
    
    //    [composeVC setMessageBody:@"Check out this amazing Timer Pro application for your iOS device!" isHTML:YES];
    
    NSString *bodyMessage = [NSString stringWithFormat:
                             @"*********************************************\n"
                             "Device Model: %@\n"
                             "iOS Version: %@\n"
                             "Application Version: %@\n"
                             "*********************************************",
                             [Utilities deviceModel],
                             [Utilities systemVersion],
                             [Utilities applicationNameAndVersion]];
    [composeVC setMessageBody:bodyMessage isHTML:NO];
    
    
    // Present the view controller modally.
    [self presentViewController:composeVC animated:YES completion:nil];
}


- (void) rateUsCellPressed {
    
    if (@available(iOS 10.3, *)) {
        [SKStoreReviewController requestReview];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[AppInfo sharedManager] storeAppLink]]];
    }
}

- (void) tellAFriendCellPressed
{
    
    if (![MFMailComposeViewController canSendMail]) {
        // NSLog(@"Mail services are not available.");
        [self showAlertControllerwithTitle:@"No Mail Accounts".localized withMessage:@"Please set up a Mail account in order to send email.".localized];
        return;
    }
    
    MFMailComposeViewController* composeVC = [[MFMailComposeViewController alloc] init];
    composeVC.mailComposeDelegate = self;
    
    // Configure the fields of the interface.
    [composeVC setToRecipients:@[@""]];
    [composeVC setSubject:@"Check out this amazing app for iOS device !".localized];
    [composeVC setMessageBody:[NSString stringWithFormat:@"%@ %@", @"Check out this amazing Timer Pro application for your iOS device !".localized, [[AppInfo sharedManager] storeAppLink]] isHTML:YES];
    
    NSData *myData = UIImagePNGRepresentation([UIImage imageNamed:@"AppIcon60x60"]);
    if (myData)
    {
        [composeVC addAttachmentData:myData mimeType:@"image/png" fileName:@"icon"];
        [self presentViewController:composeVC animated:YES completion:nil];
    }
    
    
    // Present the view controller modally.
    [self presentViewController:composeVC animated:YES completion:nil];
}


-(void) sendFeedbackCellPressed
{
    if (![MFMailComposeViewController canSendMail]) {
        [self showAlertControllerwithTitle:@"No Mail Accounts".localized withMessage:@"Please set up a Mail account in order to send email.".localized];
        //  NSLog(@"Mail services are not available.");
        return;
    }
    
    MFMailComposeViewController* composeVC = [[MFMailComposeViewController alloc] init];
    composeVC.mailComposeDelegate = self;
    
    // Configure the fields of the interface.
    [composeVC setToRecipients:@[@"support@vgfit.com"]];
    [composeVC setSubject:@"Timer Pro by Valeriu Gutu:\n Support"];
    
    
    //    [composeVC setMessageBody:@"Check out this amazing Timer Pro application for your iOS device!" isHTML:YES];
    
    NSString *bodyMessage = [NSString stringWithFormat:
                             @"*********************************************\n"
                             "Device Model: %@\n"
                             "iOS Version: %@\n"
                             "Application Version: %@\n"
                             "*********************************************",
                             [Utilities deviceModel],
                             [Utilities systemVersion],
                             [Utilities applicationNameAndVersion]];
    [composeVC setMessageBody:bodyMessage isHTML:NO];
    
    
    // Present the view controller modally.
    [self presentViewController:composeVC animated:YES completion:nil];
}


- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    // Check the result or perform other tasks.
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //  NSLog(@"Result: canceled");
            break;
        case MFMailComposeResultSaved:
            // NSLog(@"Result: saved");
            break;
        case MFMailComposeResultSent:
            //NSLog(@"Result: sent");
            break;
        case MFMailComposeResultFailed:
            // NSLog(@"Result: failed");
            //            [self showEmailNotSendAlert];
            break;
        default:
            // NSLog(@"Result: not sent");
            //            [self showEmailNotSendAlert];
            break;
    }
    // Dismiss the mail compose view controller.
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled:
            // NSLog(@"Result: canceled");
            break;
        case MessageComposeResultSent:
            // NSLog(@"Result sent");
        case MessageComposeResultFailed:
            // NSLog(@"Result: failed");
        default:
            break;
    }
}


- (void) shareOnFacebookButtonPressed
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        self.mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        NSString *messageToPost = [NSString stringWithFormat:@"%@", @"Check out this amazing app for iOS device !".localized];
        [self.mySLComposerSheet setInitialText:messageToPost];
        [self.mySLComposerSheet addImage:[UIImage imageNamed:@"Icon-App-60x60"]];
        [self presentViewController:self.mySLComposerSheet animated:YES completion:nil];
    }
    else
    {
        //NSLog(@"No facebook account !");
        [self showAlertControllerwithTitle:@"Notification".localized withMessage:@"Please login to your Facebook account from your device settings.".localized];
        //[self showWarningAlert:NSLocalizedString(@"noFacebookAccountKey", nil) withMessage:NSLocalizedString(@"noFacebookAccountMessageKey", nil)];
        return;
    }
}
-(void)showAlertControllerwithTitle:(NSString*)title withMessage:(NSString*)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK".localized style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }]];
    
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self presentViewController:alertController animated:YES completion:nil];
    });
}
- (void) shareOnTwitterButtonPressed
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        self.mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        //        NSString *shareString = NSLocalizedString(@"shareAppTextKey", nil);
        NSString *messageToPost = [NSString stringWithFormat:@"%@", @"Check out this amazing app for iOS device !".localized];
        [self.mySLComposerSheet setInitialText:messageToPost];
        //        [self.mySLComposerSheet addImage:[UIImage imageNamed:@"AppIcon60x60"]];
        [self presentViewController:_mySLComposerSheet animated:YES completion:nil];
    }
    else
    {
        // NSLog(@"No twitter account !");
        [self showAlertControllerwithTitle:@"Oops".localized withMessage:@"The application can't send a tweet at the moment. This is because it cannot reach Twitter or you don't have a Twitter account associated with this device".localized];
        //        [self showWarningAlert:NSLocalizedString(@"noTwitterAccountKey", nil) withMessage:NSLocalizedString(@"noTwitterAccountMessageKey", nil)];
        return;
    }
    
}

- (void)shareApp {
    //    UIImage *image = [UIImage imageNamed:@"Icon-App-60x60"];
    NSString *url = @"https://itunes.apple.com/us/app/timer-pro-workouts-timer/id1160713176";
    
    NSArray* dataToShare = @[url];
    UIActivityViewController* activityViewController =[[UIActivityViewController alloc] initWithActivityItems:dataToShare applicationActivities:nil];
    if ( [activityViewController respondsToSelector:@selector(popoverPresentationController)] ) {
        activityViewController.popoverPresentationController.sourceView = self.dataTableView;
        activityViewController.popoverPresentationController.sourceRect = [self.dataTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]].frame;
    }
    //    activityViewController.excludedActivityTypes = @[UIActivityTypeAirDrop];
    [self presentViewController:activityViewController animated:YES completion:^{}];
}



-(void)updateUI
{
    [_customNavigationBarView setBackgroundColor:[[AppTheme sharedManager] backgroundColor]];
     [_customNavigationBarViewIpad setBackgroundColor:[[AppTheme sharedManager] backgroundColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[[AppTheme sharedManager] labelColor],
       NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Medium" size:18.0]}];
}

@end
