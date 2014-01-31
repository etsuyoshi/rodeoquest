//
//  SpecialBeamClass.m
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/08.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "SpecialBeamClass.h"

@implementation SpecialBeamClass
@synthesize beamType;

-(id) init:(int)x_init y_init:(int)y_init width:(int)w height:(int)h type:(BeamType)_type{
//    NSLog(@"special beam occurred");
    
    
    NSDictionary *dictBeam = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"Fire.png",[NSNumber numberWithInt:BeamTypeFire],
                              @"Rock.png",[NSNumber numberWithInt:BeamTypeRock],
                @"Ice.png",[NSNumber numberWithInt:BeamTypeIce],
                @"Water.png",[NSNumber numberWithInt:BeamTypeWater],
                @"Bug.png",[NSNumber numberWithInt:BeamTypeBug],
                @"Animal.png",[NSNumber numberWithInt:BeamTypeAnimal],
                @"Cloth.png",[NSNumber numberWithInt:BeamTypeCloth],
                @"Grass.png",[NSNumber numberWithInt:BeamTypeGrass ],
                @"Space.png",[NSNumber numberWithInt:BeamTypeSpace ],
                @"Wing.png",[NSNumber numberWithInt:BeamTypeWing ],
                nil];
    
    //以下、イチイチ初期化していると動作が遅くなる。ー＞配列か単変数で対応予定
//    AttrClass *attr = [[AttrClass alloc] init];
    NSString *strBeamImage = [dictBeam objectForKey:[NSNumber numberWithInt:_type]];
//    NSLog(@"beam = %@", strBeamImage);
    
    self = [super init:x_init y_init:y_init width:w height:h];
//    level = _level;
    beamType = _type;
    power = _type+1;//test?仮
    iv.image = [UIImage imageNamed:strBeamImage];
    //    NSLog(@"bullet level = %@", [NSString stringWithFormat:@"%02d", _level]);
    return self;
}

-(void)doNext{
    [super doNext];//ordinarymode
}

//-(NSDictionary *)getDict{
//    
//    
//    return dictWeapon;
//}
//-(id)getBowAsKeys:(int)no{
//    return [arrayBowAsKeys objectAtIndex:no];
//}
//
//-(id)getBeamAsValues:(int)no{
//    return [arrayBeamAsValues objectAtIndex:no];
//}


//-(NSString *)getBowImageFromBeam:(NSString *)strBeamImage{
//    return nil;
//}

/*
 *敵機衝突時にエフェクト発動の可否を返す
 *親クラス、ordinaryBeamは-1(基本的に本クラスにおいてもゼロ)
 */
-(int)die{
//    [super die];//isAlive=falseと同値(返り値は不要)
    isAlive = false;
//    NSLog(@"SpecialBeamclass die" );
    if(arc4random() % 200 == 0){//
//        NSLog(@"effect drive!");
        return beamType;
    }
    //test:always
    return beamType;//beamType;
//    return -1;
}

/*
 *敵機衝突時のエフェクト=>ここで定義するのではなく、敵機内(にビームタイプを渡した上)でエフェクト発動
 *重くない処理にする必要
 */
//-(UIView *)getEffect{
////    NSLog(@"getEffect");
//    UIView *viewEffect = [[UIImageView alloc] initWithFrame:iv.bounds];
//    switch (beamType) {
//        case BeamTypeAnimal:{
////            viewEffect.image = nil;
//            
//            NSArray *imgArray = [[NSArray alloc] initWithObjects:
//                                 [UIImage imageNamed:@"player.png"],
//                                 [UIImage imageNamed:@"player2.png"],
//                                 [UIImage imageNamed:@"player3.png"],
//                                 [UIImage imageNamed:@"player4.png"],
//                                 [UIImage imageNamed:@"player4.png"],
//                                 [UIImage imageNamed:@"player3.png"],
//                                 [UIImage imageNamed:@"player2.png"],
//                                 [UIImage imageNamed:@"player.png"],
//                                 nil];
//            iv.animationImages = imgArray;
//            iv.animationRepeatCount = 0;
//            iv.animationDuration = 1.0f; // アニメーション全体で1秒（＝各間隔は0.5秒）
//            [iv startAnimating];
//            
//            
//            break;
//        }
//        case BeamTypeFire:{
////            NSLog(@" beamtypeFire occure" );
//            //通常時爆発(=ViewExplode)と同様の処理を(グラデ、時間を変更して)実行
////            ViewExplode *viewExplode = [[ViewExplode alloc] initWithFrame:CGRectMake(x_loc, y_loc, 1, 1)
////                                                        type:ExplodeTypeRed];
////            [viewExplode explode:250 angle:60 x:x_loc y:y_loc];
////            [NSTimer scheduledTimerWithTimeInterval:0.5f
////                                             target:viewExplode
////                                           selector:@selector(explode) userInfo:nil repeats:YES];
////            return viewExplode;
//            
//            
//            
//            ExplodeParticleView *explode;
//            explode =
////            viewEffect =
//            (ExplodeParticleView *)[[ExplodeParticleView alloc]
//                                    initWithFrame:iv.bounds
//                                    type:ExplodeParticleTypeOrangeFire];
////            [explode setType:3];//orange-fire
//            [explode setOnOffEmitting];//発火と消火の繰り返し
////            [viewEffect addSubview:explode];
//            
//            //interval秒後に停止させる
////            [NSTimer scheduledTimerWithTimeInterval:0.2f
////                                             target:explode
////                                           selector:@selector(setOnOffEmitting)
////                                           userInfo:nil
////                                            repeats:YES];
//            
//            
//            return explode;
////
////            break;
//        }
//        case BeamTypeWing:{
//            
//            
//        }
//            
////        default:
////            break;
//    }
//    
//    return viewEffect;
//}

@end
