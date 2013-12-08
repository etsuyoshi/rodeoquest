//
//  OrdinaryBeamClass.m
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/08.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "OrdinaryBeamClass.h"

@implementation OrdinaryBeamClass
-(id) init:(int)x_init y_init:(int)y_init width:(int)w height:(int)h level:(int)_level{
    self = [super init:x_init y_init:y_init width:w height:h];
    level = _level;
    power = _level;//test?仮
    iv.image = [UIImage imageNamed:[NSString stringWithFormat:@"%02d", _level]];
//    NSLog(@"bullet level = %@", [NSString stringWithFormat:@"%02d", _level]);
    return self;
}

@end
