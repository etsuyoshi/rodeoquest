//
//  MyMachineClass.m
//  Shooting5
//
//  Created by 遠藤 豪 on 13/10/04.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "MyMachineClass.h"
#import "ItemClass.h"

@implementation MyMachineClass

@synthesize itemType;

int unique_id;
int wingStatus;
int effectDuration;
CGPoint _center;
NSString *imageName;
NSMutableArray *healEffectArray;
-(id) init:(int)x_init size:(int)size{
    effectDuration = 10;//10回アニメーション
    wingStatus = 0;//翼の状態
    unique_id++;
    y_loc = 350;
    x_loc = x_init;
    hitPoint = 10000;
    offensePower = 1;
    defensePower = 0;
    originalSize = size;
    mySize = originalSize;//モード変更によるサイズ
    bigSize = mySize * 4;
    lifetime_count = 0;
    dead_time = -1;//死亡したら0にして一秒後にparticleを消去する
    weapon0Count = 0;//攻撃力強化(爆弾投下)タイム(通常時ゼロ)
    weapon1Count = 0;//攻撃力強化(弾丸複数)タイム(通常時はゼロ)
    magnetCount = 0;
    bigCount = 0;
    bombCount = 0;
    healCount = 0;
    numOfBeam = 1;//通常時、最初はビームの数は1つ(１列)
    isAlive = true;
    explodeParticle = nil;
    damageParticle  = nil;
    
    
    //x_loc,y_loc is center point
    rect = CGRectMake(x_loc-mySize/2, y_loc-mySize/2, mySize, mySize);
    iv = [[UIImageView alloc]initWithFrame:rect];
    NSArray *imgArray = [[NSArray alloc] initWithObjects:
                         [UIImage imageNamed:@"player.png"],
                         [UIImage imageNamed:@"player2.png"],
                         [UIImage imageNamed:@"player3.png"],
                         [UIImage imageNamed:@"player4.png"],
                         [UIImage imageNamed:@"player4.png"],
                         [UIImage imageNamed:@"player3.png"],
                         [UIImage imageNamed:@"player2.png"],
                         [UIImage imageNamed:@"player.png"],
                         nil];
    iv.animationImages = imgArray;
    iv.animationRepeatCount = 0;
    iv.animationDuration = 1.0f; // アニメーション全体で1秒（＝各間隔は0.5秒）
    [iv startAnimating]; // アニメーション開始!!
    
    healEffectArray = [[NSMutableArray alloc]init];//要素に疑似パーティクルセルを格納
    
    
    
//    machine_type = arc4random() % 3;
    beamArray = [[NSMutableArray alloc]init];
    
    //status=GameClassのアイテム取得時と対応
//    status = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//              @"0",@"StatusWpBomb",//
//              @"0",@"StatusWpDiffuse",
//              @"0",@"StatusWpLaser",
//              @"0",@"StatusDfBarrier",
//              @"0",@"StatusDfShield",
//              @"0",@"StatusTlBomb",
//              @"0",@"StatusTlHeal",
//              @"0",@"StatusTlMagnet",
//              @"0",@"StatusTlBig",
//              @"0",@"StatusTlSmall",
//              @"0",@"StatusTlTransparancy",
//              nil];
    
//    status = [[NSMutableDictionary alloc]init];
    /*
     ItemTypeWeapon0,//0
     ItemTypeWeapon1,
     ItemTypeWeapon2,
     ItemTypeDeffense0,
     ItemTypeDeffense1,
     ItemTypeMagnet,
     ItemTypeBomb,
     ItemTypeHeal,
     ItemTypeBig,
     ItemTypeSmall,
     ItemTypeTransparency,
     ItemTypeYellowGold,
     ItemTypeGreenGold,
     ItemTypeBlueGold,
     ItemTypePurpleGold,
     ItemTypeRedGold
     */
    status = [NSMutableDictionary dictionaryWithObjectsAndKeys:
              @"0", [NSNumber numberWithInt:ItemTypeWeapon0],//0
              @"0", [NSNumber numberWithInt:ItemTypeWeapon1],
              @"0", [NSNumber numberWithInt:ItemTypeWeapon2],
              @"0", [NSNumber numberWithInt:ItemTypeDeffense0],
              @"0", [NSNumber numberWithInt:ItemTypeDeffense1],
              @"0", [NSNumber numberWithInt:ItemTypeMagnet],
              @"0", [NSNumber numberWithInt:ItemTypeBomb],
              @"0", [NSNumber numberWithInt:ItemTypeHeal],
              @"0", [NSNumber numberWithInt:ItemTypeBig],
              @"0", [NSNumber numberWithInt:ItemTypeSmall],
              @"0", [NSNumber numberWithInt:ItemTypeTransparency],
              @"0", [NSNumber numberWithInt:ItemTypeYellowGold],
              @"0", [NSNumber numberWithInt:ItemTypeGreenGold],
              @"0", [NSNumber numberWithInt:ItemTypeBlueGold],
              @"0", [NSNumber numberWithInt:ItemTypePurpleGold],
              @"0", [NSNumber numberWithInt:ItemTypeRedGold],
              nil];
    
    
    return self;
}
-(id) init{
    NSLog(@"call mymachine class ""DEFAULT"" initialization");
    return [self init:0 size:50];
}


-(void)setType:(int)_type{
    
    machine_type = _type;
}

-(void)setDamage:(int)damage location:(CGPoint)location{
    damageParticle = [[DamageParticleView alloc] initWithFrame:CGRectMake(location.x, location.y, damage, damage)];
    [UIView animateWithDuration:0.5f
                     animations:^{
                         [damageParticle setAlpha:0.0f];//徐々に薄く
                     }
                     completion:^(BOOL finished){
                         //終了時処理
                         [damageParticle setIsEmitting:NO];
                         [damageParticle removeFromSuperview];
                     }];
    
    
    
    if(defensePower >= 0){
        if(hitPoint > 0){
            hitPoint -= damage;
            if(hitPoint < 0){
                [self die:location];
            }
        }else{
            [self die:location];
        }
    }else{
        defensePower --;
    }
}

-(void) die:(CGPoint) location{
    //爆発用パーティクルの初期化
    explodeParticle = [[ExplodeParticleView alloc] initWithFrame:CGRectMake(x_loc, y_loc, bomb_size, bomb_size)];
    [UIView animateWithDuration:3.5f
                     animations:^{
                         [explodeParticle setAlpha:0.0f];//徐々に薄く
                     }
                     completion:^(BOOL finished){
                         //終了時処理
                         [explodeParticle setIsEmitting:NO];
                         [explodeParticle removeFromSuperview];
                         
                         [iv removeFromSuperview];
                     }];
    isAlive = false;
    dead_time ++;
}


-(int)getHitPoint{
    return hitPoint;
}

-(Boolean) getIsAlive{
    return isAlive;
}

-(void)setSize:(int)s{
    mySize = s;
    iv.frame = CGRectMake(x_loc-mySize/2, y_loc-mySize/2, mySize, mySize);
}
-(int)getSize{
    return mySize;
}

-(void)doNext{
    
    //    [iv removeFromSuperview];
    //    NSLog(@"更新前 y = %d", y_loc);
    
//    NSLog(@"%d" , lifetime_count);
    
//            NSLog(@"machine iv generated");    
//    iv = [[UIImageView alloc]initWithFrame:CGRectMake(x_loc-mySize/2, y_loc-mySize/2, mySize, mySize)];
    
//    
//    switch(machine_type){//lifetime_count%8を引数に取る？
    
    
    
    
//    switch ((int)(lifetime_count/10) % 8){//タイマーの間隔による
//        case 0:{
//            iv.image = [UIImage imageNamed:@"player.png"];
//            break;
//        }
//        case 1:{
//            iv.image = [UIImage imageNamed:@"player2.png"];
//            break;
//        }
//        case 2:{
//            iv.image = [UIImage imageNamed:@"player3.png"];
//            break;
//        }
//        case 3:{
//            iv.image = [UIImage imageNamed:@"player4.png"];
//            break;
//        }
//        case 4:{
//            iv.image = [UIImage imageNamed:@"player4.png"];
//            break;
//        }
//        case 5:{
//            iv.image = [UIImage imageNamed:@"player3.png"];
//            break;
//        }
//        case 6:{
//            iv.image = [UIImage imageNamed:@"player2.png"];
//            break;
//        }
//        case 7:{
//            iv.image = [UIImage imageNamed:@"player.png"];
//            break;
//        }
//    }
    if(magnetCount > 0){
        magnetCount--;
    }else{
//        magnetCount = 0;
        [status setObject:@"0" forKey:[NSNumber numberWithInt:ItemTypeMagnet]];
    }
    
    if(weapon0Count > 0){
        weapon0Count --;
    }else{
        [status setObject:@"0" forKey:[NSNumber numberWithInt:ItemTypeWeapon0]];//bomb
    }
    
    if(weapon1Count > 0){
        weapon1Count--;
    }else{
        numOfBeam = 1;
        [status setObject:@"0" forKey:[NSNumber numberWithInt:ItemTypeWeapon1]];
    }
    
    if(bigCount > 0){
        bigCount --;
    }else{
        mySize = originalSize;
        iv.frame = CGRectMake(x_loc-mySize/2, y_loc-mySize/2, mySize, mySize);
        [status setObject:@"0" forKey:[NSNumber numberWithInt:ItemTypeBig]];
    }
    
    if(bombCount > 0){
        bombCount --;
    }else{
        [status setObject:@"0" forKey:[NSNumber numberWithInt:ItemTypeBomb]];
    }
    
    if(healCount > 0){
        //gameView側で実行
//        NSLog(@"healcount = %d", healCount);
        if(healCount % 100 == 0){
//            NSLog(@"heal");
//            for(int i = 0; i < 30;i++){
                [self healEffectInit];
                [self healEffectRepeat:100];
//            }
        }
        healCount --;
    }else{
        [ivHealEffect removeFromSuperview];
        [status setObject:@"0" forKey:[NSNumber numberWithInt:ItemTypeHeal]];
    }
    
    lifetime_count ++;
    if(!isAlive){
        dead_time ++;
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

-(ExplodeParticleView *)getExplodeParticle{
    //dieしていれば爆発用particleは初期化されているはず=>描画用クラスで描画(self.view addSubview:particle);
    [explodeParticle setType:0];//自機用パーティクル設定
    
    return explodeParticle;
}
-(DamageParticleView *)getDamageParticle{
    //dieしていれば爆発用particleは初期化されているはず=>描画用クラスで描画(self.view addSubview:particle);
    return damageParticle;
}

-(void)yieldBeam:(int)beam_type init_x:(int)x init_y:(int)y{
//    BeamClass *beam = [[BeamClass alloc] init:x y_init:y width:50 height:50];
    //ビーム配列は先入先出(FIFO)
    /*
     *1列の場合は０が中心位置に、２列の場合は０が左、１が右、３列の場合、０が左、１が中心、２が右
     */
    switch (numOfBeam) {
        case 1:{
            [beamArray insertObject:[[BeamClass alloc] init:x
                                                     y_init:y
                                                      width:50
                                                     height:50]
                            atIndex:0];//全て最初に格納
            
            break;
        }
        case 2:{
            
            for(int i = 0; i < numOfBeam;i++){
                [beamArray insertObject:[[BeamClass alloc] init:x+(20*pow(-1,i+1))//(30*(-1)^i)
                                                         y_init:y
                                                          width:50
                                                         height:50]
                                atIndex:0];//全て最初に格納
            }
            break;
        }
        case 3:{
            
            for(int i = 0; i < numOfBeam;i++){
                [beamArray insertObject:[[BeamClass alloc] init:x+40*(i-1)//30*(i-1)
                                                         y_init:y
                                                          width:50
                                                         height:50]
                                atIndex:0];//全て最初に格納
            }
            break;
        }
    }
    
        
//    [beamArray addObject:beam];
//    if([beamArray count] > 10){
////        最後のビームを削除
//        [[[beamArray lastObject] getImageView] removeFromSuperview];
//        [beamArray removeLastObject];
////        [beamArray addObject:beam];
//    }
    for(int i = 0; i < [beamArray count] ; i++){
        if(![[beamArray objectAtIndex:i] getIsAlive]){
            [beamArray removeObjectAtIndex:i];
        }
    }
}
-(BeamClass *)getBeam:(int)i{
    return (BeamClass *)[beamArray objectAtIndex:i];
}

-(int)getBeamCount{
    return [beamArray count];
}

-(void)setOffensePow:(int)_power{
    offensePower = _power;
}

-(void)setDefensePow:(int)_power{
    defensePower = _power;
}

-(int)getStatus:(ItemType)_statusKey{
    NSString *returnStr = [status objectForKey:[NSNumber numberWithInt:_statusKey]];
    return [returnStr integerValue];
}
//edit status
-(void)setStatus:(NSString *)statusValue key:(ItemType)_statusKey{
    itemType = _statusKey;
    
//    NSLog(@"status: %@, key: %d", statusValue, itemType);
    [status setObject:statusValue forKey:[NSNumber numberWithInt:itemType]];
    
    
    
    //    iv.alpha = 0.1f;
    //    [UIView animateWithDuration:10.0f
    //                     animations:^{
    //                         iv.alpha = 0.6f;
    //                     }
    //                     completion:^(BOOL finished){
    //                         iv.alpha = 1.0f;
    //                     }];
    
    
    switch(_statusKey){
            
        case ItemTypeMagnet:{
            if([statusValue integerValue]){
                magnetCount = 500;
            }else{
                magnetCount = 0;
            }
            break;
        }
        case ItemTypeBig:{
            if([statusValue integerValue]){
                
                //bigger
                bigCount = 500;
                mySize = bigSize;
                iv.frame = CGRectMake(x_loc-mySize/2, y_loc-mySize/2, mySize, mySize);
            }else{
                mySize = originalSize;
                iv.frame = CGRectMake(x_loc-mySize/2, y_loc-mySize/2, mySize, mySize);
            }
//            [UIView animateWithDuration:10.0f
//                             animations:^{
//                                 iv.frame = CGRectMake(x_loc-bigSize/2, y_loc-bigSize/2, bigSize, bigSize);
//                             }
//                             completion:^(BOOL finished){
//                                 //original size
//                                 iv.frame = CGRectMake(x_loc-originalSize/2, y_loc-originalSize/2, originalSize, originalSize);
//                             }];
            break;
        }
        case ItemTypeBomb:{
            if([statusValue integerValue]){
                bombCount = 100;//爆弾アイテムを取得した瞬間に爆発(連続して取得できないようにステータス時間は短め)
            }else{
                bombCount = 0;
            }
            break;
        }
        case ItemTypeDeffense0:{
            break;
        }
        case ItemTypeDeffense1:{
            break;
        }
        case ItemTypeHeal:{//tlHeal
            if([statusValue integerValue]){
                healCount = 500;
            }else{
                healCount = 0;
            }
            break;
        }
        case ItemTypeSmall:{
            break;
        }
        case ItemTypeTransparency:{
            break;
        }
        case ItemTypeWeapon0:{//wpBomb:throwing bomb
            if([statusValue integerValue]){
                weapon0Count = 500;
            }else{
                weapon0Count = 0;
            }
            break;
        }
        case ItemTypeWeapon1:{//wpDiffuse
            //ビームが３列になるまでは追加取得可能(新規取得する毎にカウンターが初期化)
            if([statusValue integerValue]){
                
                if(numOfBeam < 3){
                    weapon1Count = 500;
                    numOfBeam++;//max:3
                }
            }else{
                weapon1Count = 0;
                numOfBeam = 1;
            }
            //            [self setNumOfBeam:numOfBeam];
            break;
        }
        case ItemTypeWeapon2:{//wpLaser
            break;
        }
        default:
            break;
    }
}

-(void)setNumOfBeam:(int)_numOfBeam{
    numOfBeam = _numOfBeam;
}

-(int)getNumOfBeam{
    
    return numOfBeam;
}

-(void)healEffectInit{
    NSArray *imgArrayHeal;
    imgArrayHeal = [[NSArray alloc] initWithObjects:
                    [UIImage imageNamed:@"img03.png"],
                    [UIImage imageNamed:@"img04.png"],
                    [UIImage imageNamed:@"img05.png"],
                    [UIImage imageNamed:@"img06.png"],
                    [UIImage imageNamed:@"img07.png"],
                    [UIImage imageNamed:@"img08.png"],
                    [UIImage imageNamed:@"img09.png"],
                    [UIImage imageNamed:@"img10.png"],
                    [UIImage imageNamed:@"img11.png"],
                    nil];
    CGRect rectHeal;
    
    for(int i = 0; i < 10;i++){
        //回復時アニメーション->frame:主人公の左上起点基準
        rectHeal= CGRectMake(- (arc4random() % originalSize),//左端
                             - (arc4random() % originalSize),//上端
                             originalSize, originalSize);
        ivHealEffect = [[UIImageView alloc] initWithFrame:rectHeal];
        ivHealEffect.animationImages = imgArrayHeal;
        ivHealEffect.animationRepeatCount = 0;
        ivHealEffect.animationDuration = 1.0f; // アニメーション全体で1秒（＝各間隔は0.5秒）
        [ivHealEffect startAnimating]; // アニメーション開始!!(アイテム取得時に実行)
        
        [healEffectArray addObject:ivHealEffect];
        
        
    }
}

-(void)healEffectRepeat:(int)repeatCount{
    /*
     *同時に全ての配列に格納されたセルを降らせる
     */
    for(int i = 0; i < [healEffectArray count];i++){
        [iv addSubview:[healEffectArray objectAtIndex:i]];
        [UIView animateWithDuration:0.8f//random?
                         animations:^{
                             ((UIImageView*)[healEffectArray objectAtIndex:i]).center = CGPointMake(arc4random() % mySize - mySize/2, mySize);//down
                             ((UIImageView*)[healEffectArray objectAtIndex:i]).alpha = 0.5f;
                         }
                         completion:^(BOOL finished){
                             if(finished){
                                 [[healEffectArray objectAtIndex:i] removeFromSuperview];
                             }
                         }];
    }
    
//    ivHealEffect = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, originalSize, originalSize)];
    
//    ivHealEffect.animationImages = imgArrayHeal;
//    ivHealEffect.animationRepeatCount = 0;
//    ivHealEffect.animationDuration = 0.3f; // アニメーション全体で1秒（＝各間隔は0.5秒）
    
//    ivHealEffect.center = CGPointMake(arc4random() % mySize, 0);
//    ivHealEffect.alpha = 1.0f;
//    [iv addSubview:ivHealEffect];
//    [ivHealEffect startAnimating];
    //アニメーション:回復は緑系で上昇の方が良い？
//    [UIView animateWithDuration:0.8f//random?
//                     animations:^{
//                         ivHealEffect.center = CGPointMake(arc4random() % mySize - mySize/2, mySize);//down
//                         ivHealEffect.alpha = 0.5f;
//                     }
//                     completion:^(BOOL finished){
//                         if(finished){
//                             [ivHealEffect removeFromSuperview];
//                             if(repeatCount > 0){
////                                 NSLog(@"repeatcount = %d", repeatCount);
//                                 [self healEffectRepeat:repeatCount-1];
//                             }
//                         }
//                     }];
}



@end
