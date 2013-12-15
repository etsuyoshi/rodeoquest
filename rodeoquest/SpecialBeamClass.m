//
//  SpecialBeamClass.m
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/08.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "SpecialBeamClass.h"
//#import "AttrClass.h"

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
@end
