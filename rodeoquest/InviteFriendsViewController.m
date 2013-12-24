//
//  InviteFriendsViewController.m
//  Shooting6
//
//  Created by 遠藤 豪 on 13/10/24.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//　本アプリではこのクラスは使用しない＝＞AppSociallyInviteMainViewController

#import "InviteFriendsViewController.h"
#import <AppSocially/AppSocially.h>

@interface InviteFriendsViewController ()
<ASFriendPickerViewControllerDelegate,
 UIImagePickerControllerDelegate,
 UINavigationControllerDelegate>
@end

@implementation InviteFriendsViewController

NSArray *pickedFriends;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //ナビゲーションバー設置
    UINavigationBar* objectNaviBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0 , self.view.bounds.size.width, 40)];
    objectNaviBar.alpha = 0.8f;
    
    // ナビゲーションアイテムを生成
    UINavigationItem* naviItem = [[UINavigationItem alloc] initWithTitle:@"タイトル"];
    
    // 戻るボタンを生成
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(clickBack)];
    
    // ナビゲーションアイテムの右側に戻るボタンを設置
    naviItem.leftBarButtonItem = backButton;
    
    
    //appsocially機能追加
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close.png"]
                                                               style:UIBarButtonItemStyleBordered
                                                              target:self
                                                              action:@selector(invite:)];
//    barBtn.image = [UIImage imageNamed:@"close.png"];
    naviItem.rightBarButtonItem = barBtn;
    
    // ナビゲーションバーにナビゲーションアイテムを設置
    [objectNaviBar pushNavigationItem:naviItem animated:YES];
    
    // ビューにナビゲーションアイテムを設置
    [self.view addSubview:objectNaviBar];


    
    
//    [self.view addSubview:barBtn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)invite:(UIButton *)sender {
    //method1
    [ASInviter showInviteSheetInView:self.view];
    
    //method2
//    [ASInviter inviteFriends:self.pickedFriends
//                  inviteInfo:inviteInfo
//                  completion:nil];
    
    
    //method3
//    ASFriendPickerViewController *pickerCtr = [[ASFriendPickerViewController alloc] init];
//    pickerCtr.delegate = self;
    
    // customize here
//    [self presentViewController:pickerCtr animated:YES completion:nil];
}



-(void) clickBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}



//写真の起動：本アプリでは使用せず
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

@end
