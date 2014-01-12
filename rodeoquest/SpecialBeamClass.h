//
//  SpecialBeamClass.h
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/08.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "BeamClass.h"
#import "AttrClass.h"
#import "ExplodeParticleView.h"


typedef NS_ENUM(NSInteger, BeamType) {
    BeamTypeRock,
    BeamTypeFire,
    BeamTypeIce,
    BeamTypeWater,
    BeamTypeBug,
    BeamTypeAnimal,
    BeamTypeCloth,
    BeamTypeGrass,
    BeamTypeSpace,
    BeamTypeWing
};





@interface SpecialBeamClass : BeamClass{
//    NSDictionary *dictWeapon;
//    NSArray *arrayBowAsKeys;
//    NSArray *arrayBeamAsValues;
}
@property(nonatomic) BeamType beamType;
-(id) init:(int)x_init y_init:(int)y_init width:(int)w height:(int)h type:(BeamType)_type;
//-(NSDictionary *)getDict;
//-(id)getBowAsKeys:(int)no;
//-(id)getBeamAsValues:(int)no;
//-(NSString *)getBowImageFromBeam:(NSString *)strBeamImage;

@end
