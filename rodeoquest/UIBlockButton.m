//
//  UIBlockButton.m
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/21.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "UIBlockButton.h"

@implementation UIBlockButton



- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) handleControlEvent:(UIControlEvents)event
                 withBlock:(ActionBlock) action
{
    _actionBlock = action;//Block_copy(action);
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}

-(void) callActionBlock:(id)sender{
    _actionBlock();
}

//-(void) dealloc{
//    Block_release(_actionBlock);
//    [super dealloc];
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
