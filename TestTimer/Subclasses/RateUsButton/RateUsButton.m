#import "RateUsButton.h"
#import "UIDevice+Hardware.h"


@import StoreKit;

@implementation RateUsButton {
    
    SEL okActionGlobal, cancelActionGlobal;
}

-(instancetype)init{
    if (self = [super init]) {
        
        float width = IS_IPAD ? 120 : 96;
        float height = IS_IPAD ? 30 : 22;
        
        float originX = IS_IPAD ? (DEFAULT_SCREEN_WIDTH - 125) : (DEFAULT_SCREEN_WIDTH - 98);
        float originY = 0;
        
        if (Utilities.deviceHasAreaInsets) {
            originY = DEFAULT_SCREEN_HEIGHT - 110;
        } else {
            originY = IS_IPAD ? (DEFAULT_SCREEN_HEIGHT - 95) : (DEFAULT_SCREEN_HEIGHT - 75);
        }
        
        [self setFrame:CGRectMake(originX, originY, width, height)];
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    [self setImage:[UIImage imageNamed:@"fiveStars"] forState:UIControlStateNormal];
    [self addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [super drawRect:rect];
}

-(void)showAlertWithTitle:(NSString *)title
                  message:(NSString *)message
             okBottonText:(NSString *)okButtonText
         cancelButtonText:(NSString *)cancelButtonText
                 okAction:(SEL)okAction
             cancelAction:(SEL)cancelAction
{
    if (@available(iOS 8, *)) {
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:title
                                     message:message
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okButton = [UIAlertAction
                                   actionWithTitle:okButtonText.localized
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       if (okAction) {
                                           [self performSelector:okAction];
                                       }
                                   }];
        
        UIAlertAction* cancelButton = [UIAlertAction
                                       actionWithTitle:cancelButtonText.localized
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                           if (cancelAction) {
                                               [self performSelector:cancelAction];
                                           }
                                       }];
        
        [alert addAction:okButton];
        [alert addAction:cancelButton];
        
        [[Utilities topMostController] presentViewController:alert animated:YES completion:nil];
        
    }else{
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:okButtonText
                                                  otherButtonTitles:cancelButtonText, nil];
        [alertView show];
        okActionGlobal = okAction;
        cancelActionGlobal = cancelAction;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        if (okActionGlobal) {
            [self performSelector:okActionGlobal];
        }
    }else{
        if (cancelActionGlobal) {
            [self performSelector:cancelActionGlobal];
        }
    }
}

-(void)buttonAction{
    [self showAlertWithTitle:@"5-Stars".localized
                     message:@"To improve the app, please Leave a Rating or Review.".localized
                okBottonText:@"Not now".localized
            cancelButtonText:@"Rate Us".localized
                    okAction:@selector(notNowAction)
                cancelAction:@selector(leaveAReview)];
}

#pragma mark - alert controller selectors

-(void)notNowAction{
    [self showAlertWithTitle:@"Oh Dear!".localized
                     message:@"We would be grateful if you could consider giving us some ideas to improve the app. Thank you!".localized
                okBottonText:@"Not now".localized
            cancelButtonText:@"Email Us".localized
                    okAction:nil
                cancelAction:@selector(emailUs)];
}

-(void)leaveAReview{
    
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:kRateUsButtonPushedKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (@available(iOS 11, *)) {
        [SKStoreReviewController requestReview];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1160713176"]];
    }
}

-(void)emailUs{
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    NSString *currDeiceVer = [[UIDevice currentDevice] modelName];
    NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(id)kCFBundleNameKey];
    
    MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
    [composeViewController setMailComposeDelegate:self];
    [composeViewController setToRecipients:@[supportEmailAddress]];
    [composeViewController setMessageBody:[NSString stringWithFormat:@"********************\nDevice: %@\nModel: %@\nApplication Version: %@\nApplication Name: %@\n\n********************", currSysVer, currDeiceVer, currentVersion, appName] isHTML:NO];
    
    if ([MFMailComposeViewController canSendMail])
    {
        self.hidden = YES;
        [[Utilities topMostController] presentViewController:composeViewController animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    self.hidden = NO;
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

@end
