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
    int isDamaged;
    UIImageView *iv;
    CGRect rect;
    ExplodeParticleView *explodeParticle;
    DamageParticleView *damageParticle;
}
@property(nonatomic) EnemyType enemyType;


-(id)init;
-(id)init:(int)x_init size:(int)size;
-(id)init:(int)x_init size:(int)size time:(float)time;
-(id)init:(int)x_init size:(int)size time:(float)time enemyType:(EnemyType)_enemyType;


-(void)setDamage:(int)damage location:(CGPoint)location;
-(int)getHitPoint;
-(Boolean)getIsAlive;
-(int)getDeadTime;
-(void)setSize:(int)s;
-(int)getSize;

-(void)doNext;

-(void)die;
-(void)setLocation:(CGPoint)loc;
-(void)setX:(int)x;
-(void)setY:(int)y;

-(CGPoint) getLocation;
-(int) getX;
-(int) getY;
-(UIImageView *)getImageView;
-(ExplodeParticleView *)getExplodeParticle;
-(DamageParticleView *)getDamageParticle;
-(UIView*)getSmokeEffect;
@end
