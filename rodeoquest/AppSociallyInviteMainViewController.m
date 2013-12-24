//
//  GrowthSDKMainViewController.m
//  GrowthSDKSample
//
//  Created by Shuichi Tsutsumi.
//  Copyright (c) 2013 AppSocially Inc. All rights reserved.
//  this viewCon is demo by appSocially.
//

#import "AppSociallyInviteMainViewController.h"
#import <AppSocially/AppSocially.h>
#import <QuartzCore/QuartzCore.h>
#import "Utils.h"


#define kPresetMessage @"一緒にこのゲームをやろう->RodeoQuest!"
#define kSpecialColor [UIColor colorWithRed: 9.0/255.0 green:187./255.0 blue: 198./255.0 alpha:1.0]


@interface AppSociallyInviteMainViewController ()
<ASFriendPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end


@implementation AppSociallyInviteMainViewController

NSArray *pickedFriends;
UISwitch *addressbookSwitch;
UISwitch *facebookSwitch;
UISwitch *twitterSwitch;
UISwitch *tabSwitch;
UISwitch *bulkSwitch;
UIButton *showPickerBtn;

UILabel *lbAddressbook;
UILabel *lbFacebook;
UILabel *lbTwitter;
UILabel *lbTab;
UILabel *lbBulk;
//no label for UIButton
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        NSLog(@"app socially invite main view controller");
    }
    return self;
}

- (void)viewDidLoad {
    NSLog(@"viewDidLoad at appsocially");
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    int yTop = 100;
    int interval = 40;
    
    //label settings
    lbAddressbook   = [[UILabel alloc]init];
    lbFacebook      = [[UILabel alloc]init];
    lbTwitter       = [[UILabel alloc]init];
    lbTab           = [[UILabel alloc]init];
    lbBulk          = [[UILabel alloc]init];
    
    
    lbAddressbook.text  = @"address";
    lbFacebook.text     = @"facebook";
    lbTwitter.text      = @"twitter";
    lbTab.text          = @"tab";
    lbBulk.text         = @"bulk";
    
    lbAddressbook.textColor = [UIColor blackColor];
    lbFacebook.textColor    = [UIColor blackColor];
    lbTwitter.textColor     = [UIColor blackColor];
    lbTab.textColor         = [UIColor blackColor];
    lbBulk.textColor        = [UIColor blackColor];
    
    lbAddressbook.textAlignment = NSTextAlignmentRight;
    lbFacebook.textAlignment    = NSTextAlignmentRight;
    lbTwitter.textAlignment     = NSTextAlignmentRight;
    lbTab.textAlignment         = NSTextAlignmentRight;
    lbBulk.textAlignment        = NSTextAlignmentRight;
    
    
    lbAddressbook.center = CGPointMake(self.view.bounds.size.width/2 - 150, yTop + interval + 0);
    lbFacebook.center    = CGPointMake(self.view.bounds.size.width/2 - 150, yTop + interval + 1);
    lbTwitter.center     = CGPointMake(self.view.bounds.size.width/2 - 150, yTop + interval + 2);
    lbTab.center         = CGPointMake(self.view.bounds.size.width/2 - 150, yTop + interval + 3);
    lbBulk.center        = CGPointMake(self.view.bounds.size.width/2 - 150, yTop + interval + 4);

    
    //GUI settings
    addressbookSwitch       = [[UISwitch alloc] init];
    facebookSwitch          = [[UISwitch alloc] init];
    twitterSwitch           = [[UISwitch alloc] init];
    tabSwitch               = [[UISwitch alloc] init];
    bulkSwitch              = [[UISwitch alloc] init];
    showPickerBtn           = [UIButton buttonWithType:UIButtonTypeCustom];
    [showPickerBtn setFrame:CGRectMake(0, 0, 150, 40)];
    showPickerBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    showPickerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    showPickerBtn.contentMode = UIViewContentModeScaleToFill;
    [showPickerBtn addTarget:self
                      action:@selector(showFriendPicker)
//               action:NSSelectorFromString(@"showFriendPicker")
     forControlEvents:UIControlEventTouchUpInside];
    UIImage *btnColorImage = [Utils drawImageOfSize:CGSizeMake(1, 1) andColor:kSpecialColor];
    [showPickerBtn setBackgroundImage:btnColorImage forState:UIControlStateNormal];
    [showPickerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    showPickerBtn.layer.cornerRadius = 3.0;
    showPickerBtn.layer.masksToBounds = YES;
    [showPickerBtn setTitle:@"show picker" forState:UIControlStateNormal];
    
    
    //GUI allocating parameter
    
    addressbookSwitch.center = CGPointMake(self.view.bounds.size.width/2,yTop + interval * 0);
    facebookSwitch.center    = CGPointMake(self.view.bounds.size.width/2,yTop + interval * 1);
    twitterSwitch.center     = CGPointMake(self.view.bounds.size.width/2,yTop + interval * 2);
    tabSwitch.center         = CGPointMake(self.view.bounds.size.width/2,yTop + interval * 3);
    bulkSwitch.center        = CGPointMake(self.view.bounds.size.width/2,yTop + interval * 4);
    showPickerBtn.center     = CGPointMake(self.view.bounds.size.width/2,yTop + interval * 6);
    

    
    
    addressbookSwitch.onTintColor = kSpecialColor;
    facebookSwitch.onTintColor = kSpecialColor;
    twitterSwitch.onTintColor = kSpecialColor;
    bulkSwitch.onTintColor = kSpecialColor;
    tabSwitch.onTintColor = kSpecialColor;
    
    
    [self.view addSubview:addressbookSwitch];
    [self.view addSubview:facebookSwitch];
    [self.view addSubview:twitterSwitch];
    [self.view addSubview:tabSwitch];
    [self.view addSubview:bulkSwitch];
    [self.view addSubview:showPickerBtn];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    NSLog(@"view did appear at appsocially ");
    
    
}

// > OPTIONAL
// To track sign up, call "trackSignupBy:" method when a user signs up.
- (void)signup {

    NSDictionary *userInfo = @{@"id": @"APP_USER_ID",
                               @"name": @"APP_USER_NAME",
                               @"icon": @"APP_USER_ICON_URL"};
    [AppSocially trackSignupBy:userInfo];
}
// < OPTIONAL


// =============================================================================
#pragma mark - Private

- (void)showImagePicker {

    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        return;
    }

    NSAssert(pickedFriends, @"No friends are picked.");

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    
    UIView *overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, 320, 40)];
    overlayView.backgroundColor = [UIColor clearColor];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 40)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.numberOfLines = 0;
    nameLabel.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:14.0];
    nameLabel.textColor = [UIColor whiteColor];
    int cnt = 0;
    nameLabel.text = @"";
    for (ASFriend *aFriend in pickedFriends) {
        if (cnt > 0) {
            nameLabel.text = [nameLabel.text stringByAppendingString:@", "];
        }
        nameLabel.text = [nameLabel.text stringByAppendingString:aFriend.fullname];
        cnt++;
    }
    [overlayView addSubview:nameLabel];
    picker.cameraOverlayView = overlayView;
    
    [self presentViewController:picker
                       animated:YES
                     completion:^{
                     }];
}


// =============================================================================
#pragma mark - ASFriendPickerViewControllerDelegate

- (void)friendPickerViewController:(ASFriendPickerViewController *)controller
                  didPickedFriends:(NSArray *)friends
{
    pickedFriends = friends;
    
    [controller dismissViewControllerAnimated:YES
                                   completion:^{
                                       
                                       [self showImagePicker];
                                   }];
}

- (void)twitterAccountDidSelect:(ACAccount *)account {

    // NOTE: If you'd like to use invitation function via Twitter, an ACAccount object must be set to GRTwitterDMInviter.
    [ASInviter setSenderAccount:account type:ASInviteTypeTwitterDM];
}

- (NSArray *)internalFriends {
    
    NSArray *friends = @[
                         @{kASFriendDetailKeyID: @"1111",
                           kASInternalFriendKeyName: @"aiueo1",
                           kASInternalFriendKeyIcon: @"https://s3.amazonaws.com/photos.angel.co/users/172837-medium_jpg?1368907018"},
                         @{kASFriendDetailKeyID: @"1112",
                           kASInternalFriendKeyName: @"aiueo2",
                           kASInternalFriendKeyIcon: @"https://s3.amazonaws.com/photos.angel.co/users/302469-medium_jpg?1368324948"},
                         ];
    return friends;
}

- (UIView *)labelForSectionIndex {
    
    UILabel *indexLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    indexLabel.font                 = [UIFont fontWithName:@"Futura-CondensedExtraBold" size: 18.0];
    indexLabel.textColor            = [UIColor whiteColor];
    indexLabel.shadowColor          = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    indexLabel.shadowOffset         = CGSizeMake(0, 1);
    indexLabel.backgroundColor      = [kSpecialColor colorWithAlphaComponent:0.60];
    [indexLabel sizeToFit];
    indexLabel.opaque   = YES;
    
    return indexLabel;
}


// =============================================================================
#pragma mark - UIImagePickerControllerDelegate
/*
 * after sending message..
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"imagePickerController");
//    UIImage *pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // It is assumed that the URL of uploaded image was obtained as follows:
    NSString *urlStr = @"http://img.uptodown.net/screen/android/bigthumb/otaku-camera-1.jpg";

    // Any key is abailable. (Following key is used in "Include Content" template.)
    NSDictionary *inviteInfo = @{@"content_url": urlStr,
                                 @"message" :kPresetMessage};
    
    // > OPTIONAL
    // This name is used for Mail / SMS. (not used for Facebook / Twitter.)
    [ASInviter setSenderName:@"APP_USER_NAME"];
    // < OPTIONAL

    [picker dismissViewControllerAnimated:YES
                               completion:^{
                               }];
    
    [ASInviter inviteFriends:pickedFriends
                  inviteInfo:inviteInfo
                  completion:^(NSError *error) {
                      
                      NSLog(@"error:%@", error);
                      pickedFriends = nil;
                  }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES
                               completion:^{
                                   
                                   pickedFriends = nil;
                               }];
}



// =============================================================================
#pragma mark IBAction

- (void)showFriendPicker {//show friendPicker button pressed
    NSLog(@"showFriendPicker");
    ASFriendPickerViewController *pickerCtr = [[ASFriendPickerViewController alloc] init];
    
    pickerCtr.delegate = self;
    
    // > Customization
    UIImage *image = [UIImage imageNamed:@"unda_icon"];
    pickerCtr.imageForInternalFriends = image;
    
    pickerCtr.fontForMainLabel = [UIFont fontWithName:@"Futura-Medium" size:14];
    pickerCtr.fontForSubLabel = [UIFont fontWithName:@"Futura-Medium" size:12];
    
    pickerCtr.backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close"]
                                                         style:UIBarButtonItemStylePlain
                                                        target:nil action:nil];
    
    UIView *selectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    selectionView.backgroundColor    = [UIColor colorWithWhite:0.9 alpha:0.6];
    pickerCtr.selectedBackgroundView = selectionView;

    pickerCtr.addressBookDisabled = !addressbookSwitch.isOn;
    pickerCtr.facebookDisabled    = !facebookSwitch.isOn;
    pickerCtr.twitterDisabled     = !twitterSwitch.isOn;
    
    pickerCtr.multiSelectEnabled = bulkSwitch.isOn;
    pickerCtr.tabDisabled        = !tabSwitch.isOn;
    // < Customization

    [self presentViewController:pickerCtr
                       animated:YES
                     completion:^{
                         
                         [pickerCtr reloadFriendsWithCompletion:
                          ^(NSError *error) {
                              
                              if (error) {
                                  
                                  NSLog(@"Reload failed:%@", error);
                                  
                                  // error handling
                                  if ([error.domain isEqualToString:[AppSocially errorDomain]]) {
                                      
                                      switch (error.code) {
                                          case ASErrorAccessToFacebookDenied:
                                          case ASErrorAccessToFacebookFailed:
                                          case ASErrorFacebookAccountNotFound:
                                              NSLog(@"Error for Facebook Account.");
                                              break;
                                              
                                          case ASErrorAccessToTwitterDenied:
                                          case ASErrorAccessToTwitterFailed:
                                          case ASErrorTwitterAccountNotFound:
                                              NSLog(@"Error for Twitter Account.");
                                              break;
                                              
                                          case ASErrorAccessToAddressBookDenied:
                                              NSLog(@"Error for Address Book.");
                                              break;
                                              
                                          default:
                                              break;
                                      }
                                  }
                              }
                              else {
                                  
                                  NSLog(@"Reload completed.");
                              }
                          }];
                     }];
}

@end
