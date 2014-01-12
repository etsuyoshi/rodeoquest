//
//  EnemyClass.h
//  ShootingTest
//
//  Created by 遠藤 豪 on 13/09/26.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExplodeParticleView.h"
#import "DamageParticleView.h"
#import "ViewExplode.h"
#import "SpecialBeamClass.h"

typedef NS_ENUM(NSInteger, EnemyType) {//order with difficulty of get down
    EnemyTypeTanu,
    EnemyTypeMusa,
    EnemyTypePen,
    EnemyTypeHari,
    EnemyTypeZou
};


@interface EnemyClass : NSObject{
    
    int x_loc;
    int y_loc;
    int hitPoint;
    int mySize;
    float gTime;
    int lifetime_count;
    int bomb_size;
    int dead_time;
    Boolean isAlive;
    int isImpact;//特殊攻撃による被弾があったかどうか(-1からスタートして被弾されたらその特殊弾丸を代入)
    int isDamaged;
    UIImageView *iv;
    CGRect rect;
    ExplodeParticleView *explodeParticle;
    DamageParticleView *damageParticle;
    
    ViewExplode *viewExplode;
}
@property(nonatomic) EnemyType enemyType;


-(id)init;
-(id)init:(int)x_init size:(int)size;
-(id)init:(int)x_init size:(int)size time:(float)time;
-(id)init:(int)x_init size:(int)size time:(float)time enemyType:(EnemyType)_enemyType;


-(void)setDamage:(int)damage location:(CGPoint)location;
-(void)setDamage:(int)damage location:(CGPoint)location beamType:(int)beamType;
-(int)getHitPoint;
-(Boolean)getIsAlive;
-(int)getDeadTime;
-(void)setSize:(int)s;
-(int)getSize;

-(void)doNext;

-(int)die;
-(void)setLocation:(CGPoint)loc;
-(void)setX:(int)x;
-(void)setY:(int)y;
-(EnemyType)getType;
-(CGPoint) getLocation;
-(int) getX;
-(int) getY;
-(UIImageView *)getImageView;
-(ExplodeParticleView *)getExplodeParticle;
-(DamageParticleView *)getDamageParticle;
-(UIView*)getSmokeEffect;
-(ViewExplode *)getExplodeEffect;
@end
