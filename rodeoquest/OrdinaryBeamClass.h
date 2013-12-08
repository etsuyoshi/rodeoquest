//
//  OrdinaryBeamClass.h
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/08.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "BeamClass.h"

@interface OrdinaryBeamClass : BeamClass{
    int level;
}


-(id) init:(int)x_init y_init:(int)y_init width:(int)w height:(int)h level:(int)_level;
@end
