//
//  CoolButton.h
//  CoolButton
//
//  Created by Brian Moakley on 2/21/13.
//  Copyright (c) 2013 Razeware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

typedef void (^ActionBlock)();

@interface CoolButton : UIButton{
    ActionBlock _actionBlock;
}

@property  (nonatomic, assign) CGFloat hue;
@property  (nonatomic, assign) CGFloat saturation;
@property  (nonatomic, assign) CGFloat brightness;


-(void) handleControlEvent:(UIControlEvents)event
                 withBlock:(ActionBlock) action;

@end
