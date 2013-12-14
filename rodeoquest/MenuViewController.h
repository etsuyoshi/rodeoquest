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
#import <GameKit/GameKit.h>
typedef NS_ENUM(NSInteger, MenuTagType) {
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
