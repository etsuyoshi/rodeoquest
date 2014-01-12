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
                @"Rock.png",[NSNumber numberWithInt:BeamTypeRock],
                @"Fire.png",[NSNumber numberWithInt:BeamTypeFire],
                @"Ice.png",[NSNumber numberWithInt:BeamTypeWater],
                @"Water.png",[NSNumber numberWithInt:BeamTypeIce],
                @"Bug.png",[NSNumber numberWithInt:BeamTypeBug],
                @"Animal.png",[NSNumber numberWithInt:BeamTypeAnimal],
                @"Grass.png",[NSNumber numberWithInt:BeamTypeGrass ],
                @"Cloth.png",[NSNumber numberWithInt:BeamTypeCloth],
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
    if(arc4random() % 200 == 0){//
        return beamType;
    }
    return beamType;//test:always
//    return -1;
}

/*
 *敵機衝突時のエフェクト
 *重くない処理
 */
-(UIView *)getEffect{
    UIView *viewEffect = [[UIImageView alloc] initWithFrame:iv.bounds];
    switch (beamType) {
        case BeamTypeAnimal:{
//            viewEffect.image = nil;
            
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
            [iv startAnimating];
            
            
            break;
        }
        case BeamTypeFire:{
            ExplodeParticleView *explode =
//            viewEffect =
            (ExplodeParticleView *)[[ExplodeParticleView alloc]initWithFrame:iv.bounds];
            [explode setType:0];//red-fire
            [viewEffect addSubview:explode];
            
            break;
        }
            
        default:
            break;
    }
    
    return viewEffect;
}
@end
