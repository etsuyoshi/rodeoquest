//
//  MyMachineClass.h
//  Shooting5
//
//  Created by 遠藤 豪 on 13/10/04.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExplodeParticleView.h"
#import "DamageParticleView.h"
#import "BeamClass.h"
#import "OrdinaryBeamClass.h"
#import "SpecialBeamClass.h"
#import "ItemClass.h"
#import "ViewExplode.h"
#import "ViewKira.h"
#import "AttrClass.h"


@interface MyMachineClass : NSObject{
    int spWeapon;//特殊武器の判定フラグ：-1なら装備なし、0以上の整数でbeamTypeを指定する
    int level;
    
    int x_loc;
    int y_loc;
    int machine_type;//機体の型
    int hitPoint;
    int laserPower;//レーザー威力(give enemy)
    int maxHitPoint;
    int offensePower;//攻撃力
    int defensePower;//守備力：バリアー
    int mySize,bigSize,originalSize;
    int lifetime_count;
    int bomb_size;
    int dead_time;
    
    //以下アイテムの有効時間
    int magnetCount;
    int weapon0Count;//爆弾を投げられる時間->爆弾は敵に当てるように投げた方が効果的
    int weapon1Count;//攻撃力強化できる時間
    int weapon2Count;//laserR=item
    int weapon3Count;//laserG=flick
    int weapon4Count;//laserB=item & flick?
    int defense0Count;//barrier:時間性
    int defense1Count;//shield:被弾回数
    int transparancyCount;
    int bombCount;
    int bigCount;
    int healCount;
    
    //アイテムの有効最大時間
    int magnetCountMax;
    int weapon0CountMax;//爆弾を投げられる時間->爆弾は敵に当てるように投げた方が効果的
    int weapon1CountMax;//攻撃力強化できる時間
    int weapon2CountMax;//laserR=item
    int weapon3CountMax;//laserG=flick
    int weapon4CountMax;//laserB=item & flick?
    int defense0CountMax;//barrier:時間性
    int defense1CountMax;//shield:被弾回数
    int transparancyCountMax;
    int bombCountMax;
    int bigCountMax;
    int healCountMax;
    
    
    int numOfBeam;
    Boolean isAlive;
    UIImageView *iv;
    CGRect rect;
    UIImageView *ivLaserR;
    UIImageView *ivLaserG;
    UIImageView *ivLaserB;
    NSMutableArray *beamArray;
    ExplodeParticleView *explodeParticle;
    DamageParticleView *damageParticle;
    
    ViewExplode *viewExplode;

    
    NSMutableDictionary *status;//可変ステータス
}

@property(nonatomic) ItemType itemType;

-(id)init:(int)x_init size:(int)size level:(int)_level spWeapon:(int)_spWeapon;
-(id)init:(int)x_init size:(int)size level:(int)_level;
-(id)init:(int)x_init size:(int)size;
-(id)init;
-(void)setType:(int)_type;
-(void)setDamage:(int)damage location:(CGPoint)location;
-(int)getStatus:(ItemType)_statusKey;
-(void)setStatus:(NSString *)statusValue key:(ItemType)itemType;
-(void)setNumOfBeam:(int)_numOfBeam;
-(int)getNumOfBeam;
-(void)die:(CGPoint)loc;
-(int)getHitPoint;
-(Boolean)getIsAlive;
-(void)setSize:(int)s;
-(int)getSize;
-(void)doNext;
-(int)getDeadTime;
-(void)setLocation:(CGPoint)loc;
-(void)setX:(int)x;
-(void)setY:(int)y;

-(CGPoint) getLocation;
-(int) getX;
-(int) getY;
-(UIImageView *)getImageView;
-(UIImageView *)getLaserImageView;
-(ExplodeParticleView *)getExplodeParticle;
-(DamageParticleView *)getDamageParticle;


-(Boolean)yieldBeam:(int)beam_type init_x:(int)x init_y:(int)y;
-(BeamClass *)getBeam:(int)i;
-(int)getBeamCount;
-(int)getAliveBeamCount;

-(void)setOffensePow:(int)_val;
-(void)setDefensePow:(int)_val;

-(int)getLaserPower;
-(BeamType)getSpWeapon;

-(ViewExplode *)getExplodeEffect;
@end
