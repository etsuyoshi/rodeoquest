//
//  SwitchButtonWithView.m
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/06.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "SwitchButtonWithView.h"

@implementation SwitchButtonWithView
@synthesize buttonSwitchType;
@synthesize buttonMenuBackType;

- (id)initWithFrame:(CGRect)frame
           backType:(ButtonMenuBackType)_backType
          imageType:(ButtonSwitchImageType)_imageType
             target:(id)_target
           selector:(NSString *)_selName
                tag:(int)_tag_img{
    on_off = false;
    tag_img = _tag_img;
    originalFrame = frame;
    self = [super initWithFrame:frame];
    isPressed = false;
    buttonMenuBackType = _backType;
    buttonSwitchType = _imageType;
    target = _target;
    strMethod = _selName;
    NSLog(@"switch button call");
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
    on_off = on_off?false:true;
//    NSLog(@"switch=%@->%f", on_off?@"on":@"off", self.center.y);
    [self setBack];
    [self switchLight];
    
    self.center = CGPointMake(self.center.x,
                              self.center.y + (on_off?+6:-3));
    
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
            on_off = on_off?FALSE:TRUE;
            [self setBack];
            [self switchLight];
            
        }else{
            
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    isPressed = false;
    [target performSelector:NSSelectorFromString(strMethod)
                 withObject:[NSNumber numberWithInt:tag_img]
                 afterDelay:0.01f];
//    if(isPressed){
//        
//        self.center = CGPointMake(self.center.x,
//                                  self.center.y - 3);
//        isPressed = false;
//        [self setBack];
//        [self switchLight];
//        NSLog(@"touchesended : %@", strMethod);
//        [target performSelector:NSSelectorFromString(strMethod)
//                     withObject:[NSNumber numberWithInt:tag_img]
//                     afterDelay:0.01f];
//        
//    }
    
    
}
-(void)switchLight{
    if(on_off){
        imgLight.image = [UIImage imageNamed:@"powerGauge2.png"];
        
    }else{
        imgLight.image = nil;//[UIImage imageNamed:@""];
    }
}
-(void)setBack{
    switch (buttonMenuBackType) {
        case ButtonMenuBackTypeBlue:{
//            if(isPressed){
            if(on_off){
                self.image = [UIImage imageNamed:@"btn_g_on2.png"];//blue
                
            }else{
                self.image = [UIImage imageNamed:@"btn_g_off2.png"];
            }
            break;
        }
        case ButtonMenuBackTypeGreen:{
            if(on_off){
                self.image = [UIImage imageNamed:@"btn_g_on2.png"];
                
            }else{
                self.image = [UIImage imageNamed:@"btn_g_off2.png"];
            }
            break;
        }
        case ButtonMenuBackTypeOrange:{
            if(on_off){
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
    switch (buttonSwitchType) {
        case ButtonSwitchImageTypeSpeaker:{
            imgAdd.image = [UIImage imageNamed:@"icon_INN_b.png"];
            break;
        }
        case ButtonSwitchImageTypeBGM:{
            imgAdd.image = [UIImage imageNamed:@"icon_gear_b.png"];
            break;
        }
        case ButtonSwitchImageTypeSensitivity:{
            imgAdd.image = [UIImage imageNamed:@"icon_gear_b.png"];
            break;
        }
    }
}
@end
