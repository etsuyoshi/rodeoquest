//
//  ViewKira.m
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/26.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "ViewKira.h"

@implementation ViewKira

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextAddEllipseInRect(context, self.frame);
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    //hotpink:(255, 105, 180)
    CGFloat components[] = {
        255.0f/255.0f, 105.0f/255.0f, 180.0f/255.0f, 1.0f,//r,g,b,a
        255.0f/255.0f, 105.0f/255.0f, 180.0f/255.0f, 0.5f,
        0.0f, 0.0f, 0.0f, 0.0f,//clearcolor
    };
    //default:black-white
//    CGFloat components[] = {
//        1.0f, 1.0f, 1.0f, 1.0f,//r,g,b,a
//        0.5f, 0.5f, 0.5f, 1.0f,
//        0.25f, 0.25f, 0.25f, 0.0f,
//    };

    
    
    CGFloat locations[] = { 0.0, 0.5, 1.0 };
    
    size_t count = sizeof(components)/ (sizeof(CGFloat)* 4);
    CGGradientRef gradientRef =
    CGGradientCreateWithColorComponents(colorSpaceRef, components, locations, count);
    
    CGRect frame = self.bounds;
    CGFloat radius = frame.size.height/2.0*0.8;
    
    CGPoint startCenter = frame.origin;
    startCenter.x += frame.size.width/2.0;
    startCenter.y += frame.size.height/2.0;
    CGPoint endCenter = startCenter;
    
    CGFloat startRadius = 0;
    CGFloat endRadius = radius;
    
    CGContextDrawRadialGradient(context,
                                gradientRef,
                                startCenter,
                                startRadius,
                                endCenter,
                                endRadius,
                                kCGGradientDrawsAfterEndLocation);
    
    CGGradientRelease(gradientRef);
    CGColorSpaceRelease(colorSpaceRef);
    
    CGContextRestoreGState(context);
    
    
    CGRect _rectImg=CGRectMake(0, 0, self.bounds.size.width*5,
                               self.bounds.size.height*5);
    UIImageView *_img = [[UIImageView alloc]initWithFrame:_rectImg];
    _img.image = [UIImage imageNamed:@"img11.png"];
    _img.center = CGPointMake(self.bounds.size.width/2,
                              self.bounds.size.height/2);
    [self addSubview:_img];
}


@end
