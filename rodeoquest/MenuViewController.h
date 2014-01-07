//
//  ItemSelectViewController.h
//  Shooting5
//
//  Created by 遠藤 豪 on 13/10/07.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <AVFoundation/AVFoundation.h>
#import "GADBannerView.h"
#import "DBAccessClass.h"
#import "GADBannerView.h"
#import "BGMClass.h"
#import "GameClassViewController.h"
#import "GameClassViewController2.h"
#import "BackGroundClass2.h"
#import "WeaponBuyListViewController.h"
#import "ItemListViewController.h"
#import "DefenseUpListViewController.h"
#import "ItemUpListViewController.h"
#import "SpecialBeamClass.h"
#import "WeaponUpListViewController.h"
#import "LifeUpListViewController.h"
#import "CreateComponentClass.h"
#import "InviteFriendsViewController.h"
#import "AppSociallyInviteMainViewController.h"
#import "PayProductViewController.h"
#import "CoinProductViewController.h"
#import "TestViewController.h"
#import "AttrClass.h"
#import <GameKit/GameKit.h>
#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSInteger, MenuTagType) {//未使用？
    MenuTagTypeWeapon0,
    MenuTagTypeWeapon1,
    MenuTagTypeWeapon2,
    MenuTagTypeWeapon3,
    MenuTagTypeWeapon4,
    MenuTagTypeWeapon5,
    MenuTagTypeWeapon6,
    MenuTagTypeWeapon7,
    MenuTagTypeWeapon8,
    MenuTagTypeWeapon9,
    MenuTagTypeLeaderBoard,
    MenuTagTypeStartGame
    
};
//未使用？
typedef NS_ENUM(NSInteger, WeaponType){
    WeaponType0,
    WeaponType1,
    WeaponType2,
    WeaponType3,
    WeaponType4,
    WeaponType5,
    WeaponType6,
    WeaponType7,
    WeaponType8,
    WeaponType9
};
@interface MenuViewController : UIViewController<UITextViewDelegate,GKLeaderboardViewControllerDelegate>{
    //admob
    GADBannerView *bannerView_;

}
//@property (nonatomic, retain) AVAudioPlayer *audioPlayer;

//- (AVAudioPlayer*)getAVAudioPlayer:(NSString*)soudFileName;

@end
