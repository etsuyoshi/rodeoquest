//
//  ViewExplode.m
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/29.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "ViewExplode.h"


@implementation ViewExplode

- (id)initWithFrame:(CGRect)frame
{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
    return [self initWithFrame:frame type:ExplodeType1];
}

-(id)initWithFrame:(CGRect)frame type:(ExplodeType)_explodeType{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGFloat colors [] = {
        0.2, 0.2, 0.2, 1.0,
        0.0, 0.0, 0.0, 1.0
//        255.0f/255.0f, 215.0f/255.0f, 0/255.0f, 0.0f,//r,g,b,a
//        255.0f/255.0f, 215.0f/255.0f, 0/255.0f, 1.0f,//r,g,b,a
//        255.0f/255.0f, 215.0f/255.0f, 0/255.0f, 0.0f,//r,g,b,a
    };
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    CGContextDrawRadialGradient(context, gradient, self.center, 0, self.center, self.frame.size.width, kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient), gradient = NULL;
    CGContextRestoreGState(context);
    
    
    
    
    
    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSaveGState(context);
//    
//    CGContextAddEllipseInRect(context, self.frame);
//    
//    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
//    //hotpink:(255, 105, 180)
//    //周囲の色は最後の色にセットされる
//    
//    //circle
//    CGFloat components[] = {//gold
//        255.0f/255.0f, 215.0f/255.0f, 0/255.0f, 0.0f,//r,g,b,a
//        255.0f/255.0f, 215.0f/255.0f, 0/255.0f, 0.5f,
//        255.0f/255.0f, 215.0f/255.0f, 0/255.0f, 1.0f,
//        255.0f/255.0f, 215.0f/255.0f, 0/255.0f, 0.0f,//clearcolor
//    };
//    //default:white to black
//    //    CGFloat components[] = {
//    //        1.0f, 1.0f, 1.0f, 1.0f,//r,g,b,a
//    //        0.5f, 0.5f, 0.5f, 0.5f,
//    //        0.25f, 0.25f, 0.25f, 0.0f,
//    //    };
//    
//    
//    
//    CGFloat locations[] = { 0.0, 0.5, 0.8, 1.0 };
//    
//    size_t count = sizeof(components)/ (sizeof(CGFloat)* 4);
//    CGGradientRef gradientRef =
//    CGGradientCreateWithColorComponents(colorSpaceRef, components, locations, count);
//    
//    CGRect frame = self.bounds;
//    CGFloat radius = frame.size.height/2.0*0.8;
//    
//    CGPoint startCenter = frame.origin;
//    startCenter.x += frame.size.width/2.0;
//    startCenter.y += frame.size.height/2.0;
//    CGPoint endCenter = startCenter;
//    
//    CGFloat startRadius = 0;
//    CGFloat endRadius = radius;
//    
//    CGContextDrawRadialGradient(context,
//                                gradientRef,
//                                startCenter,
//                                startRadius,
//                                endCenter,
//                                endRadius,
//                                kCGGradientDrawsAfterEndLocation);
//    
//    CGGradientRelease(gradientRef);
//    CGColorSpaceRelease(colorSpaceRef);
//    
//    CGContextRestoreGState(context);

    
}

@end
