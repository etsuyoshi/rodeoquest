//
//  MenuButtonWithView.m
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/04.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "MenuButtonWithView.h"

@implementation MenuButtonWithView
//@synthesize menuBtnType;
@synthesize buttonMenuBackType;
@synthesize buttonMenuImageType;

- (id)initWithFrame:(CGRect)frame
               backType:(ButtonMenuBackType)_backType
          imageType:(ButtonMenuImageType)_imageType
             target:(id)_target
           selector:(NSString *)_selName
                tag:(int)_tag_img{
    tag_img = _tag_img;
    originalFrame = frame;
    self = [super initWithFrame:frame];
    isPressed = false;
    buttonMenuBackType = _backType;
    buttonMenuImageType = _imageType;
    target = _target;
    strMethod = _selName;
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
    // タッチされたときの処理
//    touchedX = touches.x;
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
//    NSLog(@"touchedtouched x:%f y:%f", location.x, location.y);
    touchedX = location.x;
    touchedY = location.y;
    isPressed = true;
    [self setBack];
    [self switchLight];
    
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
        isPressed = false;
        [self setBack];
        [self switchLight];
        
    }else{
//        isPressed = true;
    }

}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(isPressed){
        
        self.center = CGPointMake(self.center.x,
                                  self.center.y - 3);
//        UITouch *touch = [touches anyObject];
//        CGPoint location = [touch locationInView:self];
        //離れた位置がボタン中心から離れていれば元に戻して何もしない
//        NSLog(@"touchedEnded x:%f y:%f", location.x, location.y);
        isPressed = false;
        [self setBack];
        [self switchLight];
//        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:target
//                                                                           action:NSSelectorFromString(selName)]];
//        [target performSelector:@selector(strMethod) withObject:nil afterDelay:0.01f];
        [target performSelector:NSSelectorFromString(strMethod)
                     withObject:[NSNumber numberWithInt:tag_img]
                     afterDelay:0.01f];
        
    }
    
    
}
-(void)switchLight{
    if(isPressed){
        imgLight.image = [UIImage imageNamed:@"powerGauge2.png"];
        
    }else{
        imgLight.image = nil;//[UIImage imageNamed:@""];
    }
}
-(void)setBack{
    switch (buttonMenuBackType) {
        case ButtonMenuBackTypeBlue:{
            if(isPressed){
                self.image = [UIImage imageNamed:@"btn_g_on2.png"];//blue
                
            }else{
                self.image = [UIImage imageNamed:@"btn_g_off2.png"];
            }
            break;
        }
        case ButtonMenuBackTypeGreen:{
            if(isPressed){
                self.image = [UIImage imageNamed:@"btn_g_on2.png"];
                
            }else{
                self.image = [UIImage imageNamed:@"btn_g_off2.png"];
            }
            break;
        }
        case ButtonMenuBackTypeOrange:{
            if(isPressed){
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
        switch (buttonMenuImageType) {
            case ButtonMenuImageTypeInn:{
                imgAdd.image = [UIImage imageNamed:@"icon_INN_b.png"];
                break;
            }
            case ButtonMenuImageTypeSet:{
                imgAdd.image = [UIImage imageNamed:@"icon_gear_b.png"];
                break;
            }
            case ButtonMenuImageTypeWeapon:{
                imgAdd.image = [UIImage imageNamed:@"icon_gear_b.png"];
                break;
            }
            case ButtonMenuImageTypeStart: {
                imgAdd.image = [UIImage imageNamed:@"icon_gear_b.png"];
                break;
            }
            case ButtonMenuImageTypeItem:{
                imgAdd.image = [UIImage imageNamed:@"icon_gear_b.png"];
                break;
            }
            case ButtonMenuImageTypeCoin:{
                imgAdd.image = [UIImage imageNamed:@"coin_yellow.png"];
                break;
            }
        }
//    }else{
//        switch (menuBtnType) {
//            case MenuBtnTypeInn:{
//                self.image = [UIImage imageNamed:@"icon_INN_b.png"];
//                break;
//            }
//            case MenuBtnTypeSet:{
//                self.image = [UIImage imageNamed:@"icon_gear_b.png"];
//                break;
//            }
//            case MenuBtnTypeWeapon:{
//                self.image = [UIImage imageNamed:@"icon_gear_b.png"];
//                
//                break;
//            }
//        }
//    }
}

@end
