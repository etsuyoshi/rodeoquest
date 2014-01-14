//
//  EnemyClass.m
//  ShootingTest
//
//  Created by 遠藤 豪 on 13/09/26.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//


#import "EnemyClass.h"
#import "UIView+Animation.h"

@implementation EnemyClass
@synthesize enemyType;
const int explosionCycle3 = 30;//爆発時間:GameViewCon側でも定義
int unique_id;

-(id) init:(int)x_init size:(int)size{
    return [self init:x_init size:size time:5.0f];//standard
}

-(id) init:(int)x_init size:(int)size time:(float)time{
    
    return [self init:x_init size:size time:time enemyType:(EnemyType)arc4random() % 5];
}

-(id) init:(int)x_init size:(int)size time:(float)time enemyType:(EnemyType)_enemyType{
    gTime = time;
    unique_id++;
    
    mySize = size;
    y_loc = 0;//-mySize;//画面の外から発生させる
    x_loc = x_init;
    
    lifetime_count = 0;
    isDispEffect = NO;
    dead_time = -1;//死亡したら0にして一秒後にparticleを消去する
    isAlive = true;
    isDiedMoment = false;
    isDamaged = 0;
    isImpact = -1;
    explodeParticle = nil;
    damageParticle  = nil;
    rect = CGRectMake(x_loc, y_loc, mySize, mySize);
    iv = [[UIImageView alloc]initWithFrame:rect];
    iv.center = CGPointMake(x_loc, y_loc);//位置を修正
    
    enemyType = _enemyType;
    
    switch(enemyType){
        case EnemyTypeTanu:{
            bomb_size = 30;
            iv.image = [UIImage imageNamed:@"mob_tanu_01.png"];
            hitPoint = 30;
            break;
        }
        case EnemyTypeMusa:{
            bomb_size = 40;
            iv.image = [UIImage imageNamed:@"mob_musa_01.png"];
            hitPoint = 100;
            break;
        }
        case EnemyTypePen:{
            bomb_size = 40;
            iv.image = [UIImage imageNamed:@"mob_pen_01.png"];
            hitPoint = 300;
            break;
        }
        case EnemyTypeHari:{
            bomb_size = 40;
            iv.image = [UIImage imageNamed:@"mob_hari_01.png"];
            hitPoint = 700;
            break;
        }
        case EnemyTypeZou:{
            bomb_size = 20;
            iv.image = [UIImage imageNamed:@"mob_zou_01.png"];
            hitPoint = 1500;
            break;
        }
    }
//    iv.alpha = 0.5;
    
    
    return self;
}


-(id) init{
    NSLog(@"call enemy class initialization");
    return [self init:0 size:50];
}


-(int) die{
    
    
//    explodeParticle.center = CGPointMake(x_loc, y_loc);
    isAlive = false;
    
    return -1;
}

-(EnemyType)getType{
    return enemyType;
}


-(int)getHitPoint{
    return hitPoint;
}

-(Boolean) getIsAlive{
    return isAlive;
}

-(void)setSize:(int)s{
    mySize = s;
}
-(int)getSize{
    return mySize;
}
-(Boolean)getIsDiedMoment{
    return isDiedMoment;
}
-(void)doNext{
    if(isDiedMoment){
        //ここでfalseになる前にgameViewCon側でアイテムを生成しなくてはいけない
        isDiedMoment = false;
    }
    //初動：最初に呼び出される時のみ
    if(lifetime_count == 0){
//        [iv moveTo:CGPointMake(x_loc - mySize/2, iv.superview.bounds.size.height)
//          duration:5.0f
//            option:UIViewAnimationOptionCurveLinear];
        [UIView animateWithDuration:gTime
                              delay:0.0
                             options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             iv.center = CGPointMake(x_loc,
                                                     iv.superview.bounds.size.height + iv.bounds.size.height);
                         }
                         completion:^(BOOL finished){
                             [self die];
                             [iv removeFromSuperview];
                         }];
    }
    
//    [self doNext:false];
//}
//-(void)doNext:(Boolean)isDamaged{

//    [iv removeFromSuperview];
//    NSLog(@"更新前 y = %d", y_loc);
    
//    y_loc += mySize/6;//旧形式
//    y_loc = iv.center.y;
//    CALayer *mLayer = [iv.layer presentationLayer];
    //現在中心座標
    y_loc = ((CALayer *)[iv.layer presentationLayer]).position.y;//center = 240
    
//    iv = [[UIImageView alloc]initWithFrame:CGRectMake(x_loc, y_loc, mySize, mySize)];

    
    switch(enemyType){
        case EnemyTypeZou:{
            bomb_size = 20;
            if(isAlive && !isDamaged){
                iv.image = [UIImage imageNamed:@"mob_zou_01.png"];
            }else if(isAlive){
                iv.image = [UIImage imageNamed:@"mob_zou_02.png"];
            }else{
                iv.image = nil;
            }
            
            break;
        }
        case EnemyTypeTanu:{
            bomb_size = 30;
            if(!isDamaged){
                iv.image = [UIImage imageNamed:@"mob_tanu_01.png"];
            }else if(isAlive){
                iv.image = [UIImage imageNamed:@"mob_tanu_02.png"];
            }else{
                iv.image = nil;
            }
            break;
        }
        case EnemyTypePen:{
            bomb_size = 40;
            if(!isDamaged){
                iv.image = [UIImage imageNamed:@"mob_pen_01.png"];
            }else if(isAlive){
                iv.image = [UIImage imageNamed:@"mob_pen_02.png"];
            }else{
                iv.image = nil;
            }
            break;
        }
        case EnemyTypeMusa:{
            bomb_size = 40;
            if(!isDamaged){
                iv.image = [UIImage imageNamed:@"mob_musa_01.png"];
            }else if(isAlive){
                iv.image = [UIImage imageNamed:@"mob_musa_02.png"];
            }else{
                iv.image = nil;
            }
            break;
        }
        case EnemyTypeHari:{
            bomb_size = 40;
            if(!isDamaged){
                iv.image = [UIImage imageNamed:@"mob_hari_01.png"];
            }else if(isAlive){
                iv.image = [UIImage imageNamed:@"mob_hari_02.png"];
            }else{
                iv.image = nil;
            }
            break;
        }
    }
    
    lifetime_count ++;//need to animate
    if(!isAlive){
        dead_time ++;
        if(dead_time > explosionCycle3){
            NSLog(@"dead_time=%d", dead_time);
            [iv removeFromSuperview];
        }
        return;
    }
    
    //最後にisDamagedを通常時に戻してあげる
//    isDamaged = false;//ダメージを受けたときだけtrueにする
    
    if(isDamaged > 0){
        isDamaged --;
    }
    
}

-(int) getDeadTime{
    return dead_time;
}
-(void) setLocation:(CGPoint)loc{
    x_loc = (int)loc.x;
    y_loc = (int)loc.y;
}

-(void)setX:(int)x{
    x_loc = x;
}
-(void)setY:(int)y{
    y_loc = y;
}

-(CGPoint) getLocation{
    return CGPointMake((float)x_loc, (float)y_loc);
}

-(int) getX{
    return x_loc;
}

-(int) getY{
    return y_loc;
}

-(UIImageView *)getImageView{
    return iv;
}

//現状生成はしていない：
//本番において(生成していた場合を考慮して)念のためremove時に実行されている。
-(ExplodeParticleView *)getExplodeParticle{//死亡イフェクト
    //dieしていれば爆発用particleは初期化されているはず=>描画用クラスで描画(self.view addSubview:particle);
//    [explodeParticle setType:1];//敵用パーティクル設定
    return explodeParticle;
//    return nil;
}
-(DamageParticleView *)getDamageParticle{//被弾イフェクト
    //dieしていれば爆発用particleは初期化されているはず=>描画用クラスで描画(self.view addSubview:particle);
    return damageParticle;
}

-(UIView*)getSmokeEffect{
    
    int trans = 50;//移動範囲
    //最初に移動する距離：-trans/2〜+trans/2=>ポンと移動させたい
    int transX1 = arc4random() % trans - trans/2;//移動位置x
    int transY1 = arc4random() % trans - trans;//移動位置y
    int transX2 = arc4random() % trans - trans/2;//移動位置x
    int transY2 = arc4random() % trans - trans;//移動位置y
    int transX3 = arc4random() % trans - trans/2;//移動位置x
    int transY3 = arc4random() % trans - trans;//移動位置y
    
    
    int size_max = 30;
    int size_init = 40;
    int size1 = arc4random() % size_max;
    int size2 = arc4random() % size_max;
    int size3 = arc4random() % size_max;
    size1 = MAX(size1, 10);
    size2 = MAX(size2, 10);
    size3 = MAX(size3, 10);
    
    UIImageView *smoke1;
    UIImageView *smoke2;
    UIImageView *smoke3;
    
    
//    UIView *sv = [[UIView alloc]initWithFrame:CGRectMake(x_loc, y_loc, 1,1)];//描画しないのでサイズは関係ない
//    sv.center = CGPointMake(x_loc, y_loc);
    UIView *sv = [[UIView alloc]initWithFrame:CGRectMake(0,0, 1,1)];//描画しないのでサイズは関係ない
    sv.center = CGPointMake(iv.bounds.size.width/2,
                            iv.bounds.size.height/2);
    
    
    smoke1 = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,
                                                          size_init, size_init)];//初期スモークサイズ
    smoke2 = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,
                                                          size_init, size_init)];//初期スモークサイズ
    smoke3 = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,
                                                          size_init, size_init)];//初期スモークサイズ
    
    smoke1.center = CGPointMake(arc4random() % mySize, arc4random() % mySize);//sv上での位置：左上
    smoke2.center = CGPointMake(arc4random() % mySize, arc4random() % mySize);//sv上での位置：左上
    smoke3.center = CGPointMake(arc4random() % mySize, arc4random() % mySize);//sv上での位置：左上
    [smoke1 setAlpha:1.0f];//init:0
    [smoke2 setAlpha:1.0f];//init:0
    [smoke3 setAlpha:1.0f];//init:0
    
    smoke1.image = [UIImage imageNamed:@"smoke.png"];
    smoke2.image = [UIImage imageNamed:@"smoke.png"];
    smoke3.image = [UIImage imageNamed:@"smoke.png"];
    
    [UIView animateWithDuration:0.3f
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut//early-slow-stop
                     animations:^{
                         smoke1.frame = CGRectMake(0,0,size1/2, size1);//resize
                         smoke1.center = CGPointMake(smoke1.center.x + transX1,
                                                     smoke1.center.y + transY1);//center
                         
                         smoke2.frame = CGRectMake(0,0,size2/1.5, size2);//resize
                         smoke2.center = CGPointMake(smoke2.center.x + transX2,
                                                     smoke2.center.y + transY2);//center
                         
                         
                         smoke3.frame = CGRectMake(0,0,size3/1.2, size3);//resize
                         smoke3.center = CGPointMake(smoke3.center.x + transX3,
                                                     smoke3.center.y + transY3);//center
                         
                         
                         [smoke1 setAlpha:0.8f];
                         [smoke2 setAlpha:0.7f];
                         [smoke3 setAlpha:0.5f];
                         
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.2f
                                               delay:0.0f
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              smoke1.center = CGPointMake(smoke1.center.x, smoke1.center.y - (arc4random() % 30));
                                              [smoke1 setAlpha:0.0f];
                                              smoke2.center = CGPointMake(smoke1.center.x, smoke2.center.y - (arc4random() % 30));
                                              [smoke2 setAlpha:0.0f];
                                              smoke3.center = CGPointMake(smoke3.center.x, smoke3.center.y - (arc4random() % 30));
                                              [smoke3 setAlpha:0.0f];
                                          }
                                          completion:^(BOOL finished){
                                              [smoke1 removeFromSuperview];
                                              [smoke2 removeFromSuperview];
                                              [smoke3 removeFromSuperview];
                                              [sv removeFromSuperview];
                                          }];
                     }];

    [sv addSubview:smoke1];
    [sv addSubview:smoke2];
    [sv addSubview:smoke3];
    
    return sv;
}

-(ViewExplode *)getExplodeEffect{
    switch (enemyType) {
        case EnemyTypeHari:{
            viewExplode = [[ViewExplode alloc] initWithFrame:CGRectMake(0, 0, 1, 1)
                           type:ExplodeType1];
            [viewExplode explode:250 angle:60 x:0 y:0];
            break;
        }
        case EnemyTypeZou:{
            viewExplode = [[ViewExplode alloc] initWithFrame:CGRectMake(0, 0, 1, 1)
                                                        type:ExplodeType2];
            [viewExplode explode:300 angle:60 x:0 y:0];
            break;
        }
        default:{
            viewExplode = [[ViewExplode alloc] initWithFrame:CGRectMake(0, 0, 1, 1)
                                                        type:ExplodeTypeSmallCircle];
            [viewExplode explode:(int)100 angle:(int)0 x:0 y:0];

            break;
        }
    }
    
    return viewExplode;
}


//特殊弾丸を被弾した時のエフェクト
/*
 *各dispXXXEffectは何度も(新規に)呼ばれることがなく、
 *初めて特殊攻撃を受けた(後にisImpactフラグが反転した)瞬間にのみ実行され、
 *NSTimerのschedule関数として繰り返し実行される
 */



/*
 *BemTypeWind:風が回る
 *風が回るごとに小さなダメージを与える
 *呼出し形態はnstimerのschedule関数ではなく、関数自体が再起呼出しを行っている。
 */

-(void)dispWindEffect:(int)_times{
    if(hitPoint > 0){
        UIImageView *ivWind = [[UIImageView alloc]
                               initWithFrame:CGRectMake(0,0,1,1)];
        ivWind.image = [UIImage imageNamed:@"wind_effect.png"];
        //        ivWind.image = [UIImage imageNamed:@"wing_swirl.png"];
        [ivWind setAlpha:0.5f];
        [iv addSubview:ivWind];
        
        
        [UIView animateWithDuration: 0.5f
                              delay: 0.0f
                            options: UIViewAnimationOptionCurveLinear
                         animations: ^{
                             ivWind.transform = CGAffineTransformRotate(ivWind.transform, M_PI / 2);
                         }
                         completion: ^(BOOL finished) {
                             if (finished) {
                                 //与えるダメージは考慮必要
                                 [self setDamage:hitPoint/3 location:CGPointMake(x_loc, y_loc)];
                                 [ivWind removeFromSuperview];
                                 if (_times > 0 && hitPoint > 0) {
                                     [self dispWindEffect:_times-1];
                                 }
                             }
                         }];
    }
}

/*
 *BeamTypeCloth:広げる
 *(繰り返しであれば最後の)広がった瞬間に敵を葬る
 */
-(void)dispClothEffect:(int)_times{
    if(hitPoint > 0){
        UIImageView *ivCloth = [[UIImageView alloc]
                                initWithFrame:
                                CGRectMake(0, 0, 1, iv.bounds.size.height)];
        ivCloth.image = [UIImage imageNamed:@"sozai_maki.png"];
        ivCloth.alpha = 0.3f;
        [iv addSubview:ivCloth];
        
        
        [UIView animateWithDuration:0.5f
                         animations:^{
                             //立て幅と同じになるまで広げる
                             ivCloth.frame =
                             CGRectMake(ivCloth.frame.origin.x, ivCloth.frame.origin.y,
                                        ivCloth.bounds.size.height, ivCloth.bounds.size.height);
                             ivCloth.alpha = 1.0f;
                         }
                         completion:^(BOOL finished){
                             if(finished){
                                 [ivCloth removeFromSuperview];
                                 [self setDamageBySpecialWeapon];
                             }
                         }];
    }
}

/*
 *BeamTypeIce
 */
-(void)dispIceEffect{
    if(hitPoint > 0){
        UIImageView *iceView = [[UIImageView alloc]
                                initWithFrame:CGRectMake(0, 0, 1, 1)];
        iceView.image = [UIImage imageNamed:@"ice_icon.png"];
        iceView.transform =
        CGAffineTransformMakeRotation(-M_PI_2);
        [iv addSubview:iceView];
        
        [UIView animateWithDuration:1.0f
                         animations:^{
                             iceView.frame = CGRectMake(0, 0,
                                                        iv.bounds.size.width,
                                                        iv.bounds.size.height);
                             iceView.transform =
                             CGAffineTransformRotate(iceView.transform, M_PI_2);
                         }
                         completion:^(BOOL finished){
                             if(finished){
//                                 [self setDamage:10 location:CGPointMake(x_loc, y_loc)];
                                 [self setDamageBySpecialWeapon];
                                 [iceView removeFromSuperview];
//                                 if(times > 0){
//                                     [self dispIceEffect:times-1];
//                                 }else{
//                                     
//                                 }
                             }
                         }];

    }
}


/*
 *BeamTypeWater
 */
-(void)dispWaterEffect{
    if(hitPoint > 0){
        //bubble
        ExplodeParticleView *water =
        (ExplodeParticleView *)[[ExplodeParticleView alloc]
                                initWithFrame:CGRectMake(0,0,
                                                         iv.bounds.size.width,
                                                         iv.bounds.size.height)
                                type:ExplodeParticleTypeWater];
//        [water setOnOffEmitting];
        [iv addSubview:water];
        
        //level-up:高頻度=>(iv消去後も存続していないか)メモリリーク確認？
        [self setDamageBySpecialWeapon];
        
        [NSTimer scheduledTimerWithTimeInterval:1.0f
                                         target:water
                                       selector:@selector(setNoEmitting)
                                       userInfo:nil
                                        repeats:NO];
        
    }
    
}


/*
 *BeamTypeFire
 *0.5秒間隔で呼ばれる
 */
-(void)dispFireEffect{
    //hitPointが正値であるときのみエフェクト実行
    //発火したら0.1秒で消火を繰り返す
    if(hitPoint > 0){
        isDispEffect = true;//未使用：不要？
        //level-up:orange-red-blue?
        ExplodeParticleView *viewFireEffect;
        viewFireEffect =
        (ExplodeParticleView *)[[ExplodeParticleView alloc]
                                initWithFrame:CGRectMake(iv.bounds.size.width/2,
                                                         iv.bounds.size.height/2,
                                                         iv.bounds.size.width,
                                                         iv.bounds.size.height)
//                                type:ExplodeParticleTypeBlackFire];
                                type:ExplodeParticleTypeOrangeFire];
        //            [viewFireEffect setColor:ExplodeParticleTypeRedFire];//orange-fire
        [viewFireEffect setEmitDirection:-M_PI_2];//後ろ向きに放射
        //        [viewFireEffect setOnOffEmitting];//発火と消火の繰り返し
        //        [iv sendSubviewToBack:viewFireEffect];//機能しない
        [iv addSubview:viewFireEffect];
        
        
        [self setDamageBySpecialWeapon];
        
        //level-up:高頻度=>(iv消去後も存続していないか)メモリリーク確認？
        
        //0.1秒後に消火
        [NSTimer scheduledTimerWithTimeInterval:0.1f
                                         target:viewFireEffect
                                       selector:@selector(setNoEmitting)
                                       userInfo:Nil repeats:NO];
        
    }
}


-(void)dispBugEffect{
    
    //hitPointが正値であるときのみエフェクト実行
    //発火したら0.1秒で消火を繰り返す
    if(hitPoint > 0){
        //level-up:orange-red-blue?
        ExplodeParticleView *viewFireEffect;
        viewFireEffect =
        (ExplodeParticleView *)[[ExplodeParticleView alloc]
                                initWithFrame:CGRectMake(iv.bounds.size.width/2,
                                                         iv.bounds.size.height/2,
                                                         iv.bounds.size.width,
                                                         iv.bounds.size.height)
                                type:ExplodeParticleTypeBlackFire];//black_fire
        [viewFireEffect setBirthRate:30];//particleの生成数が多くなりすぎて重なった部分が白くならないように。
        [viewFireEffect setEmitDirection:-M_PI_2];//(前に進むので)後ろ向きに放射
        [iv addSubview:viewFireEffect];
        
        
        [self setDamageBySpecialWeapon];
        //0.1秒後に消火
        [NSTimer scheduledTimerWithTimeInterval:0.1f
                                         target:viewFireEffect
                                       selector:@selector(setNoEmitting)
                                       userInfo:Nil repeats:NO];
        
    }
}


-(void)dispDieEffect{
    NSLog(@"dispDieEffect");
    //imageViewだけを消去(爆発パーティクルが描画するためインスタンス自体は残しておく)
//    [[[EnemyArray objectAtIndex:i] getImageView] removeFromSuperview];
    iv.image = [UIImage imageNamed:@"nothing.png"];//無地にした上でエフェクトを追加するためにインスタンス自体は残しておく
    
    
    
    ////                            NSLog(@"パーティクル = %@", [(EnemyClass *)[EnemyArray objectAtIndex:i] getExplodeParticle]);
    //爆発パーティクル表示
    //                            [[(EnemyClass *)[EnemyArray objectAtIndex:i] getExplodeParticle] setUserInteractionEnabled: NO];//インタラクション拒否
    //                            [[(EnemyClass *)[EnemyArray objectAtIndex:i] getExplodeParticle] setIsEmitting:YES];//消去するには数秒後にNOに
    //                            [self.view bringSubviewToFront: [(EnemyClass *)[EnemyArray objectAtIndex:i] getExplodeParticle]];//最前面に
    //                            [self.view addSubview: [(EnemyClass *)[EnemyArray objectAtIndex:i] getExplodeParticle]];//表示する
    //smoke-effect
    UIView *smoke = [self getSmokeEffect];
    [iv bringSubviewToFront:smoke];
    [iv addSubview:smoke];
    smoke = [self getSmokeEffect];
    [iv bringSubviewToFront:smoke];
    [iv addSubview:smoke];
    smoke = [self getSmokeEffect];
    [iv bringSubviewToFront:smoke];
    [iv addSubview:smoke];
    
    
    //クリティカルヒット及びビーム発射時及び象撃破時のみ→修正要
    //explodeEffect
    ViewExplode *_viewExplode = [self getExplodeEffect];
    _viewExplode.center = CGPointMake(iv.bounds.size.width/2,
                                      iv.bounds.size.height/2);
    [iv addSubview:_viewExplode];
    
}

-(void)dispAnimalEffect{
    if(hitPoint > 0){
        UIImageView *animalView = [[UIImageView alloc]
                                initWithFrame:CGRectMake(0, 0, 1, 1)];
        animalView.image = [UIImage imageNamed:@"icon_lion.png"];
        animalView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        [iv addSubview:animalView];
        [self drawScratch:3];
        [UIView animateWithDuration:0.5f
                         animations:^{
                             animalView.frame = CGRectMake(0, 0,
                                                        iv.bounds.size.width,
                                                        iv.bounds.size.height);
                             animalView.transform =
                             CGAffineTransformRotate(animalView.transform, M_PI_2);
                         }
                         completion:^(BOOL finished){
                             if(finished){
                                 [self setDamageBySpecialWeapon];
                                 [animalView removeFromSuperview];
                             }
                         }];
        
    }
}

-(void)drawScratch:(int)times{
    UIImageView *grassView = [[UIImageView alloc]
                              initWithFrame:CGRectMake(0, 0, 1, iv.bounds.size.height)];
    grassView.image = [UIImage imageNamed:@"icon_scratch.png"];
    [iv addSubview:grassView];
    
    [UIView animateWithDuration:0.1f
                     animations:^{
                         grassView.frame = CGRectMake(0, 0,
                                                      iv.bounds.size.width,
                                                      iv.bounds.size.height);
                     }
                     completion:^(BOOL finished){
                         if(finished){
                             
                             [grassView removeFromSuperview];
                             if(times > 0){
                                 [self drawScratch:times-1];
                             }
                         }
                     }];
}

-(void)dispRockEffect{
    if(hitPoint > 0){
        UIImageView *rockView = [[UIImageView alloc]
                                   initWithFrame:CGRectMake(0, 0, 1, 1)];
        rockView.image = [UIImage imageNamed:@"bomb_016.png"];
        rockView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        rockView.center = CGPointMake(iv.bounds.size.width/2,
                                        iv.bounds.size.height/2);
        [iv addSubview:rockView];
        
        [UIView animateWithDuration:1.0f
                         animations:^{
                             rockView.frame = CGRectMake(0, 0,
                                                           iv.bounds.size.width,
                                                           iv.bounds.size.height);
                             rockView.transform =
                             CGAffineTransformRotate(rockView.transform, M_PI_2);
                         }
                         completion:^(BOOL finished){
                             if(finished){
                                 [self setDamageBySpecialWeapon];
                                 [rockView removeFromSuperview];
                             }
                         }];
    }
}

//drawScratchを３回繰り返す(各0.1秒、合計で0.3秒)
//0.5秒間隔で呼び出されるので0.2秒の空白がある
-(void)dispGrassEffect{
    if(hitPoint > 0){
        
        [self setDamageBySpecialWeapon];
        
        //左上からスタート
        UIImageView *grassView1 =
        [[UIImageView alloc]
         initWithFrame:CGRectMake(0, 0, 1, 1)];
        grassView1.image = [UIImage imageNamed:@"leaf01.png"];
        [iv addSubview:grassView1];
        
        //右上からスタート
        UIImageView *grassView2 =
        [[UIImageView alloc]
         initWithFrame:CGRectMake(iv.bounds.size.width,
                                  iv.bounds.size.height/2,
                                  1,1)];
//                                  iv.bounds.size.width,
//                                  iv.bounds.size.height)];
        iv.image = [UIImage imageNamed:@"leaf02.png"];
        [iv addSubview:grassView2];
        
        //最下部中心からスタート
        UIImageView *grassView3 =
        [[UIImageView alloc]initWithFrame:
        CGRectMake(iv.bounds.size.width/2,
                   iv.bounds.size.height,
                   1, 1)];
        grassView3.image = [UIImage imageNamed:@"leaf03.png"];
        [iv addSubview:grassView3];
        
        [UIView animateWithDuration:0.1
                         animations:^{//magic-axis
                             //leaf01
                             grassView1.frame =
                             CGRectMake(0, 0, iv.bounds.size.width,
                                        iv.bounds.size.height);
                         }
                         completion:^(BOOL finished){
                             if(finished){
                                 //leaf02
                                 [UIView
                                  animateWithDuration:0.1f
                                  animations:^{
                                      
                                      grassView2.frame =
                                      CGRectMake(0, 0,
                                                 iv.bounds.size.width,
                                                 iv.bounds.size.height);
                                  }
                                  completion:^(BOOL finished){
                                      if(finished){
                                          //leaf03
                                          [UIView
                                           animateWithDuration:0.3f
                                           animations:^{
                                               grassView3.frame =
                                               CGRectMake(0, 0,
                                                          iv.bounds.size.width,
                                                          iv.bounds.size.height);
                                           }
                                           completion:^(BOOL finished){
                                               if(finished){
                                                   [grassView1 removeFromSuperview];
                                                   [grassView2 removeFromSuperview];
                                                   [grassView3 removeFromSuperview];
                                               }
                                           }];
                                      }
                                  }];
                             }
                         }];

    }
}


//特殊武器による連続攻撃
-(int)setDamageBySpecialWeapon{
    return [self setDamage:100 location:CGPointMake(x_loc, y_loc)];
}

-(int)setDamage:(int)damage location:(CGPoint)location{
    //通常弾での攻撃
    return [self setDamage:damage location:location beamType:-1];
}

-(int)setDamage:(int)damage location:(CGPoint)location beamType:(int)beamType{
    
    if(beamType != -1 && isImpact == -1){//初めて特殊攻撃を受けた場合
        NSLog(@"first impact");
        isImpact = beamType;//次から特殊攻撃判定をしないようにする
        switch ((BeamType)beamType) {
            case BeamTypeAnimal:{//done->check
                [NSTimer scheduledTimerWithTimeInterval:0.5f
                                                 target:self
                                               selector:@selector(dispAnimalEffect)
                                               userInfo:nil
                                                repeats:YES];
                break;
            }
            case BeamTypeBug:{//done
                
                //black fire
                [NSTimer scheduledTimerWithTimeInterval:0.5f
                                                 target:self
                                               selector:@selector(dispBugEffect)
                                               userInfo:nil repeats:YES];
                
                break;
            }
            case BeamTypeFire:{//done
                //                [self dispFireEffect];
                
                [NSTimer scheduledTimerWithTimeInterval:0.5f
                                                 target:self
                                               selector:@selector(dispFireEffect)
                                               userInfo:nil repeats:YES];
                
                break;
            }
            case BeamTypeCloth:{//done->check
                
                [NSTimer scheduledTimerWithTimeInterval:0.5f
                                                 target:self
                                               selector:@selector(dispClothEffect)
                                               userInfo:nil repeats:YES];
                
                break;
            }
            case BeamTypeGrass:{//done->check
                [NSTimer scheduledTimerWithTimeInterval:0.5f
                                                 target:self
                                               selector:@selector(dispGrassEffect)
                                               userInfo:nil
                                                repeats:YES];
                
                break;
            }
            case BeamTypeIce:{//done->check
                //                [self dispIceEffect:10];
                [NSTimer scheduledTimerWithTimeInterval:0.5f
                                                 target:self
                                               selector:@selector(dispIceEffect)
                                               userInfo:nil repeats:YES];
                break;
            }
            case BeamTypeRock:{//
                [self dispRockEffect];
                break;
            }
            case BeamTypeSpace:{//メテオストライク
                
                break;
            }
            case BeamTypeWater:{//done->check
                [NSTimer scheduledTimerWithTimeInterval:0.5f
                                                 target:self
                                               selector:@selector(dispWaterEffect)
                                               userInfo:nil repeats:YES];
                
                //                [self dispWaterEffect];
                break;
            }
            case BeamTypeWing:{
                [self dispWindEffect:100];//再起呼出し
                break;
            }
                //                case beamType
            default:{
                NSLog(@"拾えていないアイテムエフェクトがあります。");
                break;
            }
        }
    }
    
    //once damaed, he display damage-mode for 1sec(100count)
    isDamaged = 100;//countdown-start : 100count=1sec
    hitPoint -= damage;
    if(hitPoint <= 0){//爆発用パーティクルの初期化
        [self die];
        isDiedMoment = YES;
        return 1;//
    }
    
    return 0;
}



@end
