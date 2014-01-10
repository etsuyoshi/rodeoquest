//
//  ViewExplode.m
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/29.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "ViewExplode.h"


@implementation ViewExplode
@synthesize explodeType;

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
        explodeType = _explodeType;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    //elliptical gradient color
//http://stackoverflow.com/questions/15084522/draw-ellipse-gradient
    
//http://stackoverflow.com/questions/6913208/is-there-a-way-to-draw-a-cgcontextdrawradialgradient-as-an-oval-instead-of-a-per/12665177#12665177
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // Create gradient
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    float middleLocation = 0.8;
    float widthLength = 1.0f;//
    float heightLength = 1.0f;
    
    UIColor *centerColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0];//[UIColor clearColor];
    UIColor *middleColor = nil;//[UIColor colorWithRed:1.0f green:165.0f/255.0f blue:0.0f alpha:1.0f];//[UIColor blueColor];//orange
    UIColor *edgeColor = nil;//[UIColor colorWithRed:1.0f green:1.0f blue:224.0f/225.0f alpha:1.0f];//[UIColor clearColor];//lightYellow
    
    switch (explodeType) {
        case ExplodeTypeRed:{
            middleLocation = 0.8f;
            centerColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.3f];
            middleColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f];//lightYellow
            //            edgeColor = [UIColor colorWithRed:1.0f green:165.0f/255.0f blue:0.0f alpha:1.0f];//orange
            edgeColor = [UIColor colorWithRed:1 green:69.0f/255.0f blue:0.0f alpha:1.0];
            widthLength = 1.05f;
            heightLength = 1.0f;
            break;
        }
        case ExplodeTypeWhite:{//ゲーム終了後のボタンとして採用
            middleLocation = 0.8f;
            centerColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0f];
            middleColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f];//lightYellow
            edgeColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.0];
            widthLength = 1.0f;
            heightLength = 1.0f;
            break;
        }
        case ExplodeTypeSmallCircle:{//白ー＞明黄ー＞橙
            middleLocation = 0.5;
            centerColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5f];
            middleColor = [UIColor colorWithRed:1.0f green:1.0f blue:224.0f/225.0f alpha:1.0f];//lightYellow
//            edgeColor = [UIColor colorWithRed:1.0f green:165.0f/255.0f blue:0.0f alpha:1.0f];//orange
            edgeColor = [UIColor colorWithRed:1 green:1 blue:104.0f/225.0f alpha:1];//light-orange
            widthLength = 1.0f;
            heightLength = 1.0f;
            break;
        }
        case ExplodeTypeFireBomb:{//火炎系武器のクリティカルヒットエフェクト
            middleLocation = 0.8;
            middleColor = [UIColor colorWithRed:1.0f green:165.0f/255.0f blue:0.0f alpha:1.0f];//orange
            edgeColor = [UIColor colorWithRed:1.0f green:1.0f blue:224.0f/225.0f alpha:1.0f];//lightYellow
            widthLength = 1.0f;
            heightLength = 1.0f;
            break;
        }
        case ExplodeType1:{
            middleLocation = 0.8;
            middleColor = [UIColor colorWithRed:1.0f green:165.0f/255.0f blue:0.0f alpha:1.0f];//orange
            edgeColor = [UIColor colorWithRed:1.0f green:1.0f blue:224.0f/225.0f alpha:1.0f];//lightYellow
            widthLength = 2.0f;//横長
            heightLength = 1.0f;
            break;
        }
         
        case ExplodeType2:{
            middleLocation = 0.8;
            middleColor = [UIColor colorWithRed:0.0f green:0.0f blue:205.0f/255.0f alpha:1.0f];//mediumBlue
            edgeColor = [UIColor colorWithRed:0.0f green:191.0f/255.0f blue:1.0f alpha:1.0f];//deepSkyBlue
            widthLength = 2.0f;//横長
            heightLength = 1.0f;
            break;
        }
        default:{//equals explodeType1
            middleLocation = 0.8;
            middleColor = [UIColor colorWithRed:1.0f green:165.0f/255.0f blue:0.0f alpha:1.0f];//[UIColor blueColor];//orange
            edgeColor = [UIColor colorWithRed:1.0f green:1.0f blue:224.0f/225.0f alpha:1.0f];//[UIColor clearColor];//lightYellow
            break;
        }
    }
    CGFloat locations[] = {0.0, middleLocation, 1.0};
    
    NSArray *colors = [NSArray arrayWithObjects:
                       (__bridge id)centerColor.CGColor,
                       (__bridge id)middleColor.CGColor,
                       (__bridge id)edgeColor.CGColor,
                       nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);
    
    // Scaling transformation and keeping track of the inverse
    CGAffineTransform scaleT = CGAffineTransformMakeScale(widthLength, heightLength);//width x 2
    CGAffineTransform invScaleT = CGAffineTransformInvert(scaleT);
    
    
    // Extract the Sx and Sy elements from the inverse matrix
    // (See the Quartz documentation for the math behind the matrices)
    CGPoint invS = CGPointMake(invScaleT.a, invScaleT.d);
    
    // Transform center and radius of gradient with the inverse
    CGPoint center = CGPointMake((self.bounds.size.width / 2) * invS.x, (self.bounds.size.height / 2) * invS.y);
    CGFloat radius = (self.bounds.size.width / 2) * invS.x;
    
    // Draw the gradient with the scale transform on the context
    CGContextScaleCTM(ctx, scaleT.a, scaleT.d);
    CGContextDrawRadialGradient(ctx, gradient, center, 0, center, radius, kCGGradientDrawsBeforeStartLocation);
    
    // Reset the context
    CGContextScaleCTM(ctx, invS.x, invS.y);
    
    // Continue to draw whatever else ...
    
    // Clean up the memory used by Quartz
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    
    
    //method2
//    CGFloat colors [] = {
//        0.2, 0.2, 0.2, 1.0,
//        0.0, 0.0, 0.0, 0.0,
////        255.0f/255.0f, 215.0f/255.0f, 0/255.0f, 0.0f,//r,g,b,a
////        255.0f/255.0f, 215.0f/255.0f, 0/255.0f, 1.0f,//r,g,b,a
////        255.0f/255.0f, 215.0f/255.0f, 0/255.0f, 0.0f,//r,g,b,a
//    };
//    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
//    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
////    CGFloat locations[] = {0.0, 1.0};
////    NSArray *colors = [NSArray arrayWithObjects:(__bridge id)([UIColor blueColor]).CGColor, (__bridge id)([UIColor purpleColor]).CGColor, nil];
////    CGGradientRef gradient = CGGradientCreateWithColors(baseSpace, (__bridge CFArrayRef)colors, locations);
//    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSaveGState(context);
//    CGContextAddEllipseInRect(context, rect);
//    CGContextClip(context);
//    CGContextDrawRadialGradient(context, gradient, self.center, 0, self.center, self.frame.size.width, kCGGradientDrawsAfterEndLocation);
//    CGGradientRelease(gradient), gradient = NULL;
//    CGContextRestoreGState(context);
    
    
    
    
    
    //method1
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

/*
 *_x,_yは中心位置
 */
-(void)explode:(int)_size angle:(int)_angle x:(float)_x y:(float)_y times:(int)_times duration:(float)_duration{
    
    float duration = 0;
    int radius = 0;//
    switch (explodeType) {
            
        case ExplodeTypeRed:{
            radius = _size;
            duration = 1.2f;//MIN(_duration, 0.3f);
            break;
        }
        case ExplodeTypeWhite:{//ゲーム終了画面の最後にボタンとして採用
            radius = _size;
            duration = 0.5f;
        }
        case ExplodeTypeFireBomb:{
            radius = _size;
            duration = _duration;
            break;
        }
        case ExplodeTypeSmallCircle:{
            radius = _size;
            duration = MIN(_duration, 0.3f);
            break;
        }
        default:{
            radius = MAX(600, _size);//under 600px
            duration = MAX(0.5f, _duration);
            break;
        }
    }
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.frame = CGRectMake(_x-radius/2,
                                                 _y-radius/2,
                                                 radius, radius);
                         self.transform = CGAffineTransformMakeRotation(M_PI*(_angle%180)/180.0f);
                         self.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         switch (explodeType) {
                             case ExplodeType2:{//type2のみ2重表示
                                 if(_times > 0){
                                     self.frame = CGRectMake(_x, _y, 1, 1);
                                     [self explode:_size angle:_angle x:_x y:_y times:_times-1 duration:_duration];
                                     
                                 }else{
                                     [self removeFromSuperview];
                                 }
                                 break;
                             }
                                 
                             default:{
                                 [self removeFromSuperview];
                                 break;
                             }
                         }
                         
                     }];
}

-(void)explode:(int)_size angle:(int)_angle x:(float)_x y:(float)_y{
    [self explode:(int)_size angle:(int)_angle x:(float)_x y:(float)_y times:(int)2 duration:(float)0.5f];
}

@end
