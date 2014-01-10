//
//  ClowdButtonWIthView.m
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2014/01/10.
//  Copyright (c) 2014年 endo.tuyo. All rights reserved.
//

#import "ClowdButtonWIthView.h"

@implementation ClowdButtonWIthView

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame
                        target:Nil
                        method:nil];
}

-(id)initWithFrame:(CGRect)frame
            target:(id)target
            method:(NSString *)method{
    self = [super initWithFrame:frame];
    if(self){
        idTarget = target;
        strMethod = method;
        originalFrame = frame;
        self.userInteractionEnabled = YES;
        
        self.backgroundColor =
        [UIColor clearColor];
        
        kCenterColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0f];
        kMiddleColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f];
        kEdgeColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.0];
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touches began");
    // タッチされたときの処理
    //    touchedX = touches.x;
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    //    NSLog(@"touchedtouched x:%f y:%f", location.x, location.y);
    touchedX = location.x;
    touchedY = location.y;
    float sizeUp = 1.5f;
    
    //最初に淡い色にしてから全体を大きくする
    kMiddleColor = [UIColor colorWithRed:1 green:1 blue:104.0f/225.0f alpha:0];//light-orange
    [self setNeedsDisplay];
    
    [UIView animateWithDuration:0.5f
                     animations:^{
                         self.frame =
                         CGRectMake(self.center.x - sizeUp*self.bounds.size.width/2,
                                    self.center.y - sizeUp*self.bounds.size.height/2,
                                    self.bounds.size.width*sizeUp, self.bounds.size.height*sizeUp);
                         
                     }
                     completion:^(BOOL finished){
                         if(finished){
                             
                         }
                     }];

    
    isPressed = true;
//    [self setBack];
//    [self switchLight];
    
    self.center = CGPointMake(self.center.x,
                              self.center.y + 3);
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    if(ABS(location.x - touchedX) > 100 ||
       ABS(location.y - touchedY) > 100 ){
        //originalization
        self.frame = originalFrame;
        kCenterColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0f];
        kMiddleColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f];
        kEdgeColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.0];
        [self setNeedsDisplay];
        
        isPressed = false;
//        [self setBack];
//        [self switchLight];
        
    }else{
        //        isPressed = true;
    }
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touches ended");
    if(isPressed){
        self.frame = originalFrame;
        //        UITouch *touch = [touches anyObject];
        //        CGPoint location = [touch locationInView:self];
        //離れた位置がボタン中心から離れていれば元に戻して何もしない
        //        NSLog(@"touchedEnded x:%f y:%f", location.x, location.y);
        isPressed = false;
//        [self setBack];
//        [self switchLight];
        //        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:target
        //                                                                           action:NSSelectorFromString(selName)]];
        //        [target performSelector:@selector(strMethod) withObject:nil afterDelay:0.01f];
        [idTarget performSelector:NSSelectorFromString(strMethod)
                     withObject:[NSNumber numberWithInt:0]//no-tag
                     afterDelay:0.01f];
        
        //このクラスオブジェクトの生成後にputBlockが実行されている場合ブロックがヒモづけられているのでそのブロックを実行させる
//        if(_actionBlock != nil){
//            [self callActionBlock:self];
//        }
    }
    
    
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
//    ViewExplode *viewExplode =
//    [[ViewExplode alloc]initWithFrame:self.bounds
//     type:ExplodeTypeWhite];
//    [self addSubview:viewExplode];
    
    
    
//    [self drawRect:rect
//     centerColor:centerColor
//       middleColor:middleColor
//         edgeColor:edgeColor];
//    
//}
//
//-(void)drawRect:(CGRect)rect
//    centerColor:(UIColor *)centerColor
//    middleColor:(UIColor *)middleColor
//      edgeColor:(UIColor *)edgeColor{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // Create gradient
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    float middleLocation = 0.8;
    float widthLength = 1.0f;//
    float heightLength = 1.0f;
    
    UIColor *centerColor = kCenterColor;
    UIColor *middleColor = kMiddleColor;
    UIColor *edgeColor = kEdgeColor;
    
    
    
    widthLength = 1.0f;
    heightLength = 1.0f;
    
    
    
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
}

@end
