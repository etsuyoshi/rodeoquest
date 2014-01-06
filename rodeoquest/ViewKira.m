//
//  ViewKira.m
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/26.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
// img11.pngを中心に描画して、背景に淡い色を表示する

#import "ViewKira.h"

@implementation ViewKira
@synthesize kiraType;
- (id)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame type:KiraTypeYellow];
    if(self){
        
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame type:(KiraType)_kiraType
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        kiraType = _kiraType;
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
    //周囲の色は最後の色にセットされる
    float fR = 0;
    float fG = 0;
    float fB = 0;
//    http://lowlife.jp/yasusii/static/color_chart.html
    switch (kiraType) {
        case KiraTypeYellow:{//yellow
            fR = 255.0f;
            fG = 255.0f;
            fB = 0.0f;
            break;
        }
        case KiraTypeGreen:{//LawnGreen
            fR = 124.0f;
            fG = 252.0f;
            fB = 0.0f;
            break;
        }
        case KiraTypeBlue:{//cyan1
            fR = 0;
            fG = 255.0f;
            fB = 255.0f;
            break;
        }
        case KiraTypePurple:{//magenta
            fR = 255.0f;
            fG = 0;
            fB = 255.0f;
            break;
        }
        case KiraTypeRed:{//hotpink
            fR = 255.0f;
            fG = 105.0f;
            fB = 180.0f;
            break;
        }
        case KiraTypeWhite:{//black?
            fR = 0.0f;
            fG = 0.0f;
            fB = 0.0f;
            break;
        }
        default:
            break;
    }
    
    CGFloat components[] = {
        fR/255.0f, fG/255.0f, fB/255.0f, 1.0f,//r,g,b,a
        fR/255.0f, fG/255.0f, fB/255.0f, 0.5f,
        fR/255.0f, fG/255.0f, fB/255.0f, 0.0f,//clearcolor
    };
    //default:white to black
//    CGFloat components[] = {
//        1.0f, 1.0f, 1.0f, 1.0f,//r,g,b,a
//        0.5f, 0.5f, 0.5f, 0.5f,
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
    
    
    //キラキラを中心に表示
    CGRect _rectImg=CGRectMake(0, 0, self.bounds.size.width*5,
                               self.bounds.size.height*5);
    UIImageView *_img = [[UIImageView alloc]initWithFrame:_rectImg];
    _img.image = [UIImage imageNamed:@"img11.png"];
    _img.center = CGPointMake(self.bounds.size.width/2,
                              self.bounds.size.height/2);
    [self addSubview:_img];
    
}


@end
