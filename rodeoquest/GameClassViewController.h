//
//  GameClassViewController.h
//  ShootingTest
//
//  Created by 遠藤 豪 on 13/09/25.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioServices.h>
#import "BackGroundClass2.h"


@interface GameClassViewController : UIViewController{
    CFURLRef sound_hit_URL;//敵機撃破
    SystemSoundID sound_hit_ID;
    CFURLRef sound_damage_URL;//敵機ダメージ
    SystemSoundID sound_damage_ID;
    CFURLRef sound_itemGet_URL;//自機アイテム取得(coin以外)
    SystemSoundID sound_itemGet_ID;
    CFURLRef sound_died_URL;//自機撃破
    SystemSoundID sound_died_ID;
    
    int enemyCount;//発生した敵の数
    int enemyDown;//倒した敵の数
    WorldType worldType;

}
//bgm
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;


//se
@property(readwrite) CFURLRef sound_hit_URL;
@property(readonly) SystemSoundID sound_hit_ID;
@property(readwrite) CFURLRef sound_damage_URL;
@property(readonly) SystemSoundID sound_damage_ID;
@property(readwrite) CFURLRef sound_itemGet_URL;
@property(readonly) SystemSoundID sound_itemGet_ID;
@property(readwrite) CFURLRef sound_died_URL;
@property(readonly) SystemSoundID sound_died_ID;

@end
