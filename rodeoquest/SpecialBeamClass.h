//
//  SpecialBeamClass.h
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/08.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "BeamClass.h"

typedef NS_ENUM(NSInteger, BeamType) {
    BeamTypeAnimal,
    BeamTypeBug,
    BeamTypeCloth,
    BeamTypeFire,
    BeamTypeGrass,
    BeamTypeIce,
    BeamTypeRock,
    BeamTypeSpace,
    BeamTypeWater,
    BeamTypeWing
};


@interface SpecialBeamClass : BeamClass
@property(nonatomic) BeamType beamType;
-(id) init:(int)x_init y_init:(int)y_init width:(int)w height:(int)h type:(int)_type;
@end
