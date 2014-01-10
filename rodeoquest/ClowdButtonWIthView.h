//
//  ClowdButtonWIthView.h
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2014/01/10.
//  Copyright (c) 2014年 endo.tuyo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewExplode.h"

@interface ClowdButtonWIthView : UIView{
    NSString *strMethod;
    id idTarget;
    Boolean isPressed;
    float touchedX;
    float touchedY;
    CGRect originalFrame;
    
    UIColor *kCenterColor;
    UIColor *kMiddleColor;
    UIColor *kEdgeColor;
}
-(id)initWithFrame:(CGRect)frame;
-(id)initWithFrame:(CGRect)frame
            target:(id)target
            method:(NSString *)method;
@end
