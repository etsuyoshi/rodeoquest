//
//  SwitchButtonWithView.m
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/06.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

//バグ：onの状態でドラックすると位置がおかしくなる

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
    
    
//    on_off = false;
    NSUserDefaults *_myDefaults = [NSUserDefaults standardUserDefaults];
    switch (_imageType) {
        case ButtonSwitchImageTypeBGM:{
            on_off = [[_myDefaults objectForKey:@"bgm"] intValue];
            NSLog(@"init : on_off=%d", on_off);
            break;
        }
        case ButtonSwitchImageTypeSpeaker:{
            on_off = [[_myDefaults objectForKey:@"se"] intValue];
            break;
        }
        default:{
            break;
        }
    }

    tag_img = _tag_img;
    originalFrame = frame;
    self = [super initWithFrame:frame];
    isPressed = false;
    buttonMenuBackType = _backType;
    buttonSwitchType = _imageType;
    target = _target;
    strMethod = _selName;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:target
                                                                    action:NSSelectorFromString(strMethod)]];
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
        [self switchLight];
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
    NSLog(@"touches began : %@", strMethod);
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
    
//    self.center = CGPointMake(self.center.x,
//                              self.center.y + (on_off?+6:-6));
    
}

//理想：タップした後、やめたい場合は別の場所までフリックして元に戻すのが通常(ここではややこしいのでやめた)
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    //endedが機能しないので、ややこしさを無くすためやめる
//    NSLog(@"touches moved : %@", strMethod);
//    UITouch *touch = [touches anyObject];
//    CGPoint location = [touch locationInView:self];
////    if(isPressed) {
//    
//        if(ABS(location.x - touchedX) > 100 ||
//           ABS(location.y - touchedY) > 100 ){
//            //originalization
//            
//            self.frame = originalFrame;
//            isPressed = false;
//            on_off = on_off?FALSE:TRUE;
//            if(!on_off){
//                self.frame = originalFrame;
//            }
////            on_off != on_off;
//            [self setBack];
//            [self switchLight];
//            
////        }else{
////            
////        }
//    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    //なぜか反応しない。。(ボタンをタップしたままフリックするとたまに反応する場合がある)
//    isPressed = false;
//    NSLog(@"touches ended at switch button");
//    if(buttonSwitchType == ButtonSwitchImageTypeBGM ||
//       buttonSwitchType == ButtonSwitchImageTypeSpeaker){
//        [target performSelector:NSSelectorFromString(strMethod)
//                     withObject:[NSNumber numberWithInt:tag_img]
//                     afterDelay:0.01f];
//    }else{//sensitive
//        [target performSelector:NSSelectorFromString(strMethod)
//                     withObject:[NSNumber numberWithInteger:countPressed]
//                     afterDelay:0.01f];
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
    if(on_off){
        self.center = CGPointMake(self.center.x,
                                  originalFrame.origin.y+originalFrame.size.height/2 + 6);

    }else{
        self.center = CGPointMake(self.center.x,
                                  originalFrame.origin.y+originalFrame.size.height/2);
    }
//    if([strMethod  isEqual: @"setBGM:"]){
//        NSLog(@"setback on_off=%d, y=%f", on_off, self.center.y);
//    }
    switch (buttonMenuBackType) {
        case ButtonMenuBackTypeBlue:{
//            if(isPressed){
            if(on_off){
                self.image = [UIImage imageNamed:@"btn_b_on.png"];//blue
                
            }else{
                self.image = [UIImage imageNamed:@"btn_b_off.png"];
            }
            break;
        }
        case ButtonMenuBackTypeGreen:{
            if(on_off){
                self.image = [UIImage imageNamed:@"btn_g_on.png"];
                
            }else{
                self.image = [UIImage imageNamed:@"btn_g_off.png"];
            }
            break;
        }
        case ButtonMenuBackTypeOrange:{
            if(on_off){
                self.image = [UIImage imageNamed:@"btn_r_on.png"];//orange
                
            }else{
                self.image = [UIImage imageNamed:@"btn_r_off.png"];
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
            if(on_off){
                imgAdd.image = [UIImage imageNamed:@"icon_speaker_on.png"];
            }else{
                imgAdd.image = [UIImage imageNamed:@"icon_speaker_on.png"];
            }
            break;
        }
        case ButtonSwitchImageTypeBGM:{
            if(on_off){
                imgAdd.image = [UIImage imageNamed:@"icon_music_on.png"];
            }else{
                imgAdd.image = [UIImage imageNamed:@"icon_music_off.png"];
            }
            break;
        }
//        case ButtonSwitchImageTypeSensitivity:{
//            imgAdd.image = [UIImage imageNamed:@"icon_gear_b.png"];
//            break;
//        }
    }
}
@end
