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
-(id) init:(int)x_init y_init:(int)y_init width:(int)w height:(int)h type:(int)_type{
//    NSLog(@"special beam occurred");
    NSArray *arrBeamImage = [NSArray arrayWithObjects:
                             @"Animal.png",
                             @"Bug.png",
                             @"Cloth.png",
                             @"Fire.png",
                             @"Grass.png",
                             @"Ice.png",
                             @"Rock.png",
                             @"Space.png",
                             @"Water.png",
                             @"Wing.png",
                             nil];
    self = [super init:x_init y_init:y_init width:w height:h];
//    level = _level;
    beamType = _type;
    power = _type+1;//test?仮
    iv.image = [UIImage imageNamed:[arrBeamImage objectAtIndex:beamType]];
    //    NSLog(@"bullet level = %@", [NSString stringWithFormat:@"%02d", _level]);
    return self;
}

-(void)doNext{
    [super doNext];//ordinarymode
}
@end
