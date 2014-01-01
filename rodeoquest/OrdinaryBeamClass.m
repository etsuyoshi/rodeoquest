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
    if(_level < 30){
        iv.image = [UIImage imageNamed:[NSString stringWithFormat:@"%02d", _level]];
    }else {
        /*
         *30-59:grade=2, 60-89:grade=3, ...
         *grade=2:[0,w], grade=3:[0,w/2,w], grade=4:[0,w/3,2w/3,w]
         */
        iv.image = nil;
        int grade=_level/30+1;//always:grade>=2
//        NSLog(@"grade=%d", grade);
        for(int i = 0;i < grade;i++){
            UIImageView *ivImg = [[UIImageView alloc] initWithFrame:iv.bounds];
            ivImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%02d", (_level%30)+1]];
            ivImg.center = CGPointMake(i*iv.bounds.size.width/(grade-1), iv.bounds.size.height/2);
//            NSLog(@"x=%f, level=%d", i*iv.bounds.size.width/(grade-1), (_level%30)+1);
            [iv addSubview:ivImg];
        }
        
    }
//    NSLog(@"bullet level = %@", [NSString stringWithFormat:@"%02d", _level]);
    return self;
}

@end
