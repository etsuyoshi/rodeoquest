//
//  CountButtonWithView.m
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/06.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "CountButtonWithView.h"

@implementation CountButtonWithView
@synthesize buttonCountType;
@synthesize buttonMenuBackType;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
          backType:(ButtonMenuBackType)_backType
         imageType:(ButtonCountImageType)_imageType
            target:(id)_target
          selector:(NSString *)_selName
               tag:(int)_tag_img{
    MAXCOUNT = 3;
    countPressed = 0;
    tag_img = _tag_img;
    originalFrame = frame;
    self = [super initWithFrame:frame];
    isPressed = false;
    buttonMenuBackType = _backType;
    buttonCountType = _imageType;
    target = _target;
    strMethod = _selName;
    NSLog(@"count button call");
    if (self) {
        // Initialization code
        // タッチを有効にする
        self.userInteractionEnabled = YES;
        imgAdd = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,
                                                              frame.size.width,
                                                              frame.size.height)];
        imgLight = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,
                                                                frame.size.width,
                                                                frame.size.height)];
        mask = [[UIControl alloc]initWithFrame:CGRectMake(0, 0,
                                                          frame.size.width,
                                                          frame.size.height)];
        [self setBack];
        [self setImage];
        [self addSubview:imgAdd];
        [self addSubview:imgLight];
        //        [self addSubview:mask];
        touchedX = -100;
        touchedX = -100;
        // マルチタッチを有効にする
        //        [self setMultipleTouchEnabled:YES];
        
    }

    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //    NSLog(@"touchesended : %@", strMethod);
    // タッチされたときの処理
    //    touchedX = touches.x;
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    //    NSLog(@"touchedtouched x:%f y:%f", location.x, location.y);
    touchedX = location.x;
    touchedY = location.y;
    isPressed = true;
//    on_off = on_off?false:true;
    //if countPressed=0,1 then 1,2 else 0
    countPressed = (countPressed < MAXCOUNT-1)?(countPressed+1):0;
    //    NSLog(@"switch=%@->%f", on_off?@"on":@"off", self.center.y);
    [self setBack];
    [self switchLight];
    
    self.center = CGPointMake(self.center.x,
                              self.center.y + countPressed * 3);
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    if(isPressed) {
        
        if(ABS(location.x - touchedX) > 100 ||
           ABS(location.y - touchedY) > 100 ){
            //originalization
            
            self.frame = originalFrame;
            isPressed = false;
//            on_off = on_off?FALSE:TRUE;
            countPressed = (countPressed == 0)?MAXCOUNT-1:(countPressed-1);
            [self setBack];
            [self switchLight];
            
        }else{
            
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    isPressed = false;
    
    [target performSelector:NSSelectorFromString(strMethod)
                 withObject:[NSNumber numberWithInteger:countPressed]
                 afterDelay:0.01f];
}
-(void)switchLight{
//    if(on_off){
    if(countPressed > 0){
        imgLight.image = [UIImage imageNamed:@"powerGauge2.png"];
        
    }else{
        imgLight.image = nil;//[UIImage imageNamed:@""];
    }
}
-(void)setBack{
    switch (buttonMenuBackType) {
        case ButtonMenuBackTypeBlue:{
//            if(on_off){
            if(countPressed > 0){
                self.image = [UIImage imageNamed:@"btn_g_on2.png"];//blue
                
            }else{
                self.image = [UIImage imageNamed:@"btn_g_off2.png"];
            }
            break;
        }
        case ButtonMenuBackTypeGreen:{
//            if(on_off){
            if(countPressed > 0){
                self.image = [UIImage imageNamed:@"btn_g_on2.png"];
                
            }else{
                self.image = [UIImage imageNamed:@"btn_g_off2.png"];
            }
            break;
        }
        case ButtonMenuBackTypeOrange:{
//            if(on_off){
            if(countPressed > 0){
                self.image = [UIImage imageNamed:@"btn_g_on2.png"];//orange
                
            }else{
                self.image = [UIImage imageNamed:@"btn_g_off2.png"];
            }
            break;
        }
        case ButtonMenuBackTypeDefault:{
            
        }
            
        default:{
            break;
        }
    }
    
}
-(void)setImage{
    //    if(isPressed){
    switch (buttonCountType) {
        case ButtonCountImageTypeSensitivity:{
            if(countPressed > 0){
                NSLog(@"senstivity image");
                imgAdd.image = [UIImage imageNamed:@"icon_gear_b.png"];
                break;
            }
        }
    }
}
@end
