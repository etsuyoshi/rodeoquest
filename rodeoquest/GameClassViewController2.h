//
//  GameClassViewController2.h
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2014/01/07.
//  Copyright (c) 2014年 endo.tuyo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioServices.h>
#import "BackGroundClass2.h"

#import <AppSocially/AppSocially.h>
#import "ViewWithEffectLevelUp.h"
#import "LDProgressView.h"
#import "ViewExplode.h"
#import "ViewKira.h"
#import "BGMClass.h"
#import "DBAccessClass.h"
#import "AttrClass.h"
#import "CreateComponentClass.h"
#import "EnemyClass.h"
#import "ItemClass.h"
#import "PowerGaugeClass.h"
#import "MyMachineClass.h"
#import "ScoreBoardClass.h"
#import "GoldBoardClass.h"
#import "ClowdButtonWIthView.h"
#import "UIView+Animation.h"
#import "Effect.h"
#import <QuartzCore/QuartzCore.h>
#import <GameKit/GameKit.h>


@interface GameClassViewController2 : UIViewController{
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
    
    int time_game;//開始してから死ぬまでの時間(死んでから計測した秒数を格納しておく)
    NSDate *startDate;//時間計測用
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
