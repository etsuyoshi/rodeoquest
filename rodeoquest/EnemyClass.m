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
    dead_time = -1;//死亡したら0にして一秒後にparticleを消去する
    isAlive = true;
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

//特殊武器による連続攻撃
-(void)setDamageBySpecialWeapon{
    [self setDamage:10 location:CGPointMake(x_loc, y_loc)];
}

-(void)setDamage:(int)damage location:(CGPoint)location{
    //通常弾での攻撃
    [self setDamage:damage location:location beamType:-1];
}

-(void)setDamage:(int)damage location:(CGPoint)location beamType:(int)beamType{
    
    if(beamType != -1 && isImpact == -1){//初めて特殊攻撃を受けた場合
        NSLog(@"first impact");
        isImpact = beamType;
        switch ((BeamType)beamType) {
            case BeamTypeAnimal:{//not yet
//                <#statements#>
                break;
            }
            case BeamTypeBug:{//not yet
                
                break;
            }
            case BeamTypeFire:{//done
                [self dispFireEffect];
////                iv addSubview:<#(UIView *)#>
//                NSLog(@"fire occurred");
//                ExplodeParticleView *explode =
//                //            viewEffect =
//                (ExplodeParticleView *)[[ExplodeParticleView alloc]
//                                        initWithFrame:iv.bounds
//                                        type:ExplodeParticleTypeOrangeFire];
////                [explode setColor:ExplodeParticleTypeOrangeFire];//red-fire
//                [explode setOnOffEmitting];//発火と消火の繰り返し
//                [iv addSubview:explode];
//                
//                NSLog(@"damaged in beamTypeFire");
                
                break;
            }
            case BeamTypeCloth:{//done->check
                
//                //布を広げる前は幅1px
//                UIImageView *ivCloth = [[UIImageView alloc]initWithFrame:CGRectMake(200,350, 1, 50)];
//                ivCloth.image = [UIImage imageNamed:@"sozai_maki.png"];
//                [iv addSubview:ivCloth];
//                ivCloth.alpha = 0.3f;
//                [self extendWith:ivCloth times:30];
                
                
                [self dispClothEffect:5];
                
                
                break;
            }
            case BeamTypeGrass:{//not yet
                
                break;
            }
            case BeamTypeIce:{//done->check
                [self dispIceEffect:10];
                break;
            }
            case BeamTypeRock:{
                
                break;
            }
            case BeamTypeSpace:{
                
                break;
            }
            case BeamTypeWater:{//done->check
                [self dispWaterEffect];
                break;
            }
            case BeamTypeWing:{
                [self dispWindEffect:100];
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
    isDamaged = 100;//100count=1sec
    //particleを表示すると動作が重くなる
//    damageParticle = [[DamageParticleView alloc] initWithFrame:CGRectMake(location.x, location.y, damage, damage)];
//    [UIView animateWithDuration:0.5f
//                     animations:^{
//                         [damageParticle setAlpha:0.0f];//徐々に薄く
//                     }
//                     completion:^(BOOL finished){
//                         //終了時処理
//                         [damageParticle setIsEmitting:NO];
//                         [damageParticle removeFromSuperview];
//                         
//                     }];
    
//    damageParticle.center = CGPointMake(x_loc, y_loc);
    hitPoint -= damage;
    if(hitPoint <= 0){//爆発用パーティクルの初期化
//        explodeParticle = [[ExplodeParticleView alloc] initWithFrame:CGRectMake(x_loc, y_loc, bomb_size, bomb_size)];
//        [UIView animateWithDuration:0.5f
//                         animations:^{
//                             [explodeParticle setAlpha:0.0f];//徐々に薄く
//                         }
//                         completion:^(BOOL finished){
//                             //終了時処理
//                             [explodeParticle setIsEmitting:NO];
//                             [explodeParticle removeFromSuperview];
//                             
//                             //自分自身も削除
//                             [iv removeFromSuperview];
//                         }];
        [self die];
    }
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
-(void)doNext{
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
            if(!isDamaged){
                iv.image = [UIImage imageNamed:@"mob_zou_01.png"];
            }else{
                iv.image = [UIImage imageNamed:@"mob_zou_02.png"];
            }
            break;
        }
        case EnemyTypeTanu:{
            bomb_size = 30;
            if(!isDamaged){
                iv.image = [UIImage imageNamed:@"mob_tanu_01.png"];
            }else{
                iv.image = [UIImage imageNamed:@"mob_tanu_02.png"];
            }
            break;
        }
        case EnemyTypePen:{
            bomb_size = 40;
            if(!isDamaged){
                iv.image = [UIImage imageNamed:@"mob_pen_01.png"];
            }else{
                iv.image = [UIImage imageNamed:@"mob_pen_02.png"];
            }
            break;
        }
        case EnemyTypeMusa:{
            bomb_size = 40;
            if(!isDamaged){
                iv.image = [UIImage imageNamed:@"mob_musa_01.png"];
            }else{
                iv.image = [UIImage imageNamed:@"mob_musa_02.png"];
            }
            break;
        }
        case EnemyTypeHari:{
            bomb_size = 40;
            if(!isDamaged){
                iv.image = [UIImage imageNamed:@"mob_hari_01.png"];
            }else{
                iv.image = [UIImage imageNamed:@"mob_hari_02.png"];
            }
            break;
        }
    }
    
    lifetime_count ++;//need to animate
    if(!isAlive){
        dead_time ++;
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
    
    
    UIView *sv = [[UIView alloc]initWithFrame:CGRectMake(x_loc, y_loc, 1,1)];//描画しないのでサイズは関係ない
    sv.center = CGPointMake(x_loc, y_loc);
    
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
            viewExplode = [[ViewExplode alloc] initWithFrame:CGRectMake(x_loc, y_loc, 1, 1)
                           type:ExplodeType1];
            [viewExplode explode:250 angle:60 x:x_loc y:y_loc];
            break;
        }
        case EnemyTypeZou:{
            viewExplode = [[ViewExplode alloc] initWithFrame:CGRectMake(x_loc, y_loc, 1, 1)
                                                        type:ExplodeType2];
            [viewExplode explode:300 angle:60 x:x_loc y:y_loc];
            break;
        }
        default:{
            viewExplode = [[ViewExplode alloc] initWithFrame:CGRectMake(x_loc,y_loc, 1, 1)
                                                        type:ExplodeTypeSmallCircle];
            [viewExplode explode:(int)100 angle:(int)0 x:(float)x_loc y:(float)y_loc];

            break;
        }
    }
    
    return viewExplode;
}


//特殊弾丸を被弾した時のエフェクト
/*
 *BemTypeWind:風が回る
 *風が回るごとに小さなダメージを与える
 *
 */

-(void)dispWindEffect:(int)_times{
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
                             if (_times > 0) {
                                 [self dispWindEffect:_times-1];
                             }
                         }
                     }];
}

/*
 *BeamTypeCloth:広げる
 *(繰り返しであれば最後の)広がった瞬間に敵を葬る
 */
-(void)dispClothEffect:(int)_times{
    
    UIImageView *ivCloth = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, 1, iv.bounds.size.height)];
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
                             if(_times > 0){
//                                 //initializa
//                                 ivCloth.frame = CGRectMake(ivCloth.frame.origin.x, ivCloth.frame.origin.y,
//                                                             1, ivCloth.bounds.size.height);
//                                 ivCloth.alpha = 0.1f;
                                 //re-display-effect
                                 [self dispClothEffect:_times-1];
                             }else{
                                 //全てのエフェクトが完了したら終了
                                 [self setDamage:hitPoint+1 location:CGPointMake(x_loc, y_loc)];
                             }
                         }
                     }];
}

/*
 *BeamTypeIce
 */
-(void)dispIceEffect:(int)times{
    
    UIImageView *iceView = [[UIImageView alloc]
                            initWithFrame:CGRectMake(0, 0, 1, 1)];
    iceView.image = [UIImage imageNamed:@"ice_icon.png"];
    [iv addSubview:iceView];
    
    [UIView animateWithDuration:1.0f
                     animations:^{
                         iceView.frame = CGRectMake(0, 0,
                                                    iv.bounds.size.width,
                                                    iv.bounds.size.height);
                     }
                     completion:^(BOOL finished){
                         if(finished){
                             [self setDamage:10 location:CGPointMake(x_loc, y_loc)];
                             [iceView removeFromSuperview];
                             if(times > 0){
                                 [self dispIceEffect:times-1];
                             }else{
                                 
                             }
                         }
                     }];

}


/*
 *BeamTypeWater
 */
-(void)dispWaterEffect{
    //bubble
    ExplodeParticleView *water =
    (ExplodeParticleView *)[[ExplodeParticleView alloc]
                            initWithFrame:CGRectMake(0,0,
                                                     iv.bounds.size.width,
                                                     iv.bounds.size.height)
                            type:ExplodeParticleTypeWater];
    [water setOnOffEmitting];
    [iv addSubview:water];
    
    //level-up:高頻度=>(iv消去後も存続していないか)メモリリーク確認？
    [NSTimer scheduledTimerWithTimeInterval:1.0f
                                     target:self
                                   selector:@selector(setDamageBySpecialWeapon)
                                   userInfo:nil
                                    repeats:YES];
    
}

/*
 *BeamTypeFire
 */
-(void)dispFireEffect{
    
    //level-up:orange-red-blue?
    ExplodeParticleView *viewFireEffect;
    viewFireEffect =
    (ExplodeParticleView *)[[ExplodeParticleView alloc]
                            initWithFrame:CGRectMake(0, 0,
                                                     iv.bounds.size.width,
                                                     iv.bounds.size.height)];
    [viewFireEffect setColor:ExplodeParticleTypeRedFire];//orange-fire
    [viewFireEffect setEmitDirection:-M_PI_2];//後ろ向きに放射
    [viewFireEffect setOnOffEmitting];//発火と消火の繰り返し
    [iv addSubview:viewFireEffect];
    
    //level-up:高頻度=>(iv消去後も存続していないか)メモリリーク確認？
    [NSTimer scheduledTimerWithTimeInterval:1.0f
                                 target:self
                                   selector:@selector(setDamageBySpecialWeapon)
                                   userInfo:Nil repeats:YES];
}

@end
