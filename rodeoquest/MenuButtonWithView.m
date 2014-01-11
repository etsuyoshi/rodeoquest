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
//    NSLog(@"tag_img = %d", _tag_img);
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
    NSLog(@"touches began");
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
    NSLog(@"touches ended");
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
        
        //このクラスオブジェクトの生成後にputBlockが実行されている場合ブロックがヒモづけられているのでそのブロックを実行させる
        if(_actionBlock != nil){
            [self callActionBlock:self];
        }
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
                self.image = [UIImage imageNamed:@"btn_b_on.png"];//blue
                
            }else{
                self.image = [UIImage imageNamed:@"btn_b_off.png"];
            }
            break;
        }
        case ButtonMenuBackTypeGreen:{
            if(isPressed){
                self.image = [UIImage imageNamed:@"btn_g_on.png"];
                
            }else{
                self.image = [UIImage imageNamed:@"btn_g_off.png"];
            }
            break;
        }
        case ButtonMenuBackTypeOrange:{
            if(isPressed){
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
                imgAdd.image = [UIImage imageNamed:@"weapon_b.png"];
                break;
            }
            case ButtonMenuImageTypeStart: {
                imgAdd.image = [UIImage imageNamed:@"icon_gear_b.png"];
                break;
            }
            case ButtonMenuImageTypeItem:{
                imgAdd.image = [UIImage imageNamed:@"item_UP.png"];
                break;
            }
            case ButtonMenuImageTypeDefense:{
                imgAdd.image = [UIImage imageNamed:@"shield_b.png"];
                break;
            }
            case  ButtonMenuImageTypeWpnUp:{
                imgAdd.image = [UIImage imageNamed:@"weapon_UP2.png"];
                break;
            }
            case ButtonMenuImageTypeCoin:{
                imgAdd.image = [UIImage imageNamed:@"icon_coin_b.png"];
                break;
            }
            case ButtonMenuImageTypeBuyProduct0:{
                imgAdd.image = [UIImage imageNamed:@"apatite01.png"];
                
                for(int i = 0 ; i < 10 ; i++){
                    CGRect rectKr = CGRectMake(0, 0, imgAdd.bounds.size.width/5,
                                               imgAdd.bounds.size.height/4);
                    UIImageView *imgKr = [[UIImageView alloc]initWithFrame:rectKr];
                    NSString *strImageName = [NSString stringWithFormat:@"img%02d.png",
                                              MAX(3, arc4random()%12)];
                    imgKr.image = [UIImage imageNamed:strImageName];
                    imgKr.image = [UIImage imageNamed:strImageName];
                    imgKr.center = CGPointMake(imgAdd.bounds.size.width/5 +
                                               arc4random() % ((int)imgAdd.bounds.size.width*3/5),
                                               imgAdd.bounds.size.height/3 +
                                               arc4random() % ((int)imgAdd.bounds.size.height*2/3));
                    [imgAdd addSubview:imgKr];
                }
                break;
            }
            case ButtonMenuImageTypeBuyProduct1:{
                imgAdd.image = [UIImage imageNamed:@"apatite02.png"];
                for(int i = 0 ; i < 10 ; i++){
                    CGRect rectKr = CGRectMake(0, 0, imgAdd.bounds.size.width/5,
                                               imgAdd.bounds.size.height/4);
                    UIImageView *imgKr = [[UIImageView alloc]initWithFrame:rectKr];
                    NSString *strImageName = [NSString stringWithFormat:@"img%02d.png",
                                              MAX(3, arc4random()%12)];
                    imgKr.image = [UIImage imageNamed:strImageName];
                    imgKr.image = [UIImage imageNamed:strImageName];
                    imgKr.center = CGPointMake(imgAdd.bounds.size.width/5 +
                                               arc4random() % ((int)imgAdd.bounds.size.width*3/5),
                                               imgAdd.bounds.size.height/3 +
                                               arc4random() % ((int)imgAdd.bounds.size.height*2/3));
                    [imgAdd addSubview:imgKr];
                }
                break;
            }
            case ButtonMenuImageTypeBuyProduct2:{
                imgAdd.image = [UIImage imageNamed:@"apatite03.png"];
                for(int i = 0 ; i < 10 ; i++){
                    CGRect rectKr = CGRectMake(0, 0, imgAdd.bounds.size.width/5,
                                               imgAdd.bounds.size.height/4);
                    UIImageView *imgKr = [[UIImageView alloc]initWithFrame:rectKr];
                    NSString *strImageName = [NSString stringWithFormat:@"img%02d.png",
                                              MAX(3, arc4random()%12)];
                    imgKr.image = [UIImage imageNamed:strImageName];
                    imgKr.image = [UIImage imageNamed:strImageName];
                    imgKr.center = CGPointMake(imgAdd.bounds.size.width/5 +
                                               arc4random() % ((int)imgAdd.bounds.size.width*3/5),
                                               imgAdd.bounds.size.height/3 +
                                               arc4random() % ((int)imgAdd.bounds.size.height*2/3));
                    [imgAdd addSubview:imgKr];
                }
                break;
            }
            case ButtonMenuImageTypeBuyProduct3:{
                imgAdd.image = [UIImage imageNamed:@"apatite04.png"];
                for(int i = 0 ; i < 10 ; i++){
                    CGRect rectKr = CGRectMake(0, 0, imgAdd.bounds.size.width/5,
                                               imgAdd.bounds.size.height/4);
                    UIImageView *imgKr = [[UIImageView alloc]initWithFrame:rectKr];
                    NSString *strImageName = [NSString stringWithFormat:@"img%02d.png",
                                              MAX(3, arc4random()%12)];
                    imgKr.image = [UIImage imageNamed:strImageName];
                    imgKr.image = [UIImage imageNamed:strImageName];
                    imgKr.center = CGPointMake(imgAdd.bounds.size.width/5 +
                                               arc4random() % ((int)imgAdd.bounds.size.width*3/5),
                                               imgAdd.bounds.size.height/3 +
                                               arc4random() % ((int)imgAdd.bounds.size.height*2/3));
                    [imgAdd addSubview:imgKr];
                }
                break;
            }
            case ButtonMenuImageTypeBuyProduct4:{
                imgAdd.image = [UIImage imageNamed:@"apatite05.png"];
                for(int i = 0 ; i < 10 ; i++){
                    CGRect rectKr = CGRectMake(0, 0, imgAdd.bounds.size.width/5,
                                               imgAdd.bounds.size.height/4);
                    UIImageView *imgKr = [[UIImageView alloc]initWithFrame:rectKr];
                    NSString *strImageName = [NSString stringWithFormat:@"img%02d.png",
                                              MAX(3, arc4random()%12)];
                    imgKr.image = [UIImage imageNamed:strImageName];
                    imgKr.image = [UIImage imageNamed:strImageName];
                    imgKr.center = CGPointMake(imgAdd.bounds.size.width/5 +
                                               arc4random() % ((int)imgAdd.bounds.size.width*3/5),
                                               imgAdd.bounds.size.height/3 +
                                               arc4random() % ((int)imgAdd.bounds.size.height*2/3));
                    [imgAdd addSubview:imgKr];
                }
                break;
            }
            case ButtonMenuImageTypeBuyProduct5:{
                imgAdd.image = [UIImage imageNamed:@"apatite06.png"];
                for(int i = 0 ; i < 10 ; i++){
                    CGRect rectKr = CGRectMake(0, 0, imgAdd.bounds.size.width/5,
                                               imgAdd.bounds.size.height/4);
                    UIImageView *imgKr = [[UIImageView alloc]initWithFrame:rectKr];
                    NSString *strImageName = [NSString stringWithFormat:@"img%02d.png",
                                              MAX(3, arc4random()%12)];
                    imgKr.image = [UIImage imageNamed:strImageName];
                    imgKr.image = [UIImage imageNamed:strImageName];
                    imgKr.center = CGPointMake(imgAdd.bounds.size.width/5 +
                                               arc4random() % ((int)imgAdd.bounds.size.width*3/5),
                                               imgAdd.bounds.size.height/3 +
                                               arc4random() % ((int)imgAdd.bounds.size.height*2/3));
                    [imgAdd addSubview:imgKr];
                }
                break;
            }
            case ButtonMenuImageTypeDemand:{
                imgAdd.image = [UIImage imageNamed:@"icon_voice.png"];//test:
                break;
            }
            case ButtonMenuImageTypeBuyCoin0:{
                imgAdd.image = [UIImage imageNamed:@"BuyCoin01.png"];
                imgAdd.center = CGPointMake(imgAdd.center.x,
                                            imgAdd.center.y + 10);//少し上過ぎなので下げる
                for(int i = 0 ; i < 10 ; i++){
                    CGRect rectKr = CGRectMake(0, 0, imgAdd.bounds.size.width/4,
                                               imgAdd.bounds.size.height/4);
                    UIImageView *imgKr = [[UIImageView alloc]initWithFrame:rectKr];
                    NSString *strImageName = [NSString stringWithFormat:@"img%02d.png",
                                              MAX(3, arc4random()%12)];
                    imgKr.image = [UIImage imageNamed:strImageName];
                    imgKr.center = CGPointMake(imgAdd.bounds.size.width/4 +
                                               arc4random() % ((int)imgAdd.bounds.size.width/2),
                                               imgAdd.bounds.size.height/4 +
                                               arc4random() % ((int)imgAdd.bounds.size.height/2));
                    [imgAdd addSubview:imgKr];
                }
                break;
            }
            case ButtonMenuImageTypeBuyCoin1:{
                imgAdd.image = [UIImage imageNamed:@"BuyCoin02.png"];
                for(int i = 0 ; i < 10 ; i++){
                    CGRect rectKr = CGRectMake(0, 0, imgAdd.bounds.size.width/5,
                                               imgAdd.bounds.size.height/4);
                    UIImageView *imgKr = [[UIImageView alloc]initWithFrame:rectKr];
                    NSString *strImageName = [NSString stringWithFormat:@"img%02d.png",
                                              MAX(3, arc4random()%12)];
                    imgKr.image = [UIImage imageNamed:strImageName];
                    imgKr.image = [UIImage imageNamed:strImageName];
                    imgKr.center = CGPointMake(imgAdd.bounds.size.width/4 +
                                               arc4random() % ((int)imgAdd.bounds.size.width/2),
                                               imgAdd.bounds.size.height/4 +
                                               arc4random() % ((int)imgAdd.bounds.size.height/2));
                    [imgAdd addSubview:imgKr];
                }
                break;
            }
            case ButtonMenuImageTypeBuyCoin2:{
                imgAdd.image = [UIImage imageNamed:@"BuyCoin03.png"];
                for(int i = 0 ; i < 25 ; i++){
                    CGRect rectKr = CGRectMake(0, 0, imgAdd.bounds.size.width/5,
                                               imgAdd.bounds.size.height/4);
                    UIImageView *imgKr = [[UIImageView alloc]initWithFrame:rectKr];
                    NSString *strImageName = [NSString stringWithFormat:@"img%02d.png",
                                              MAX(3, arc4random()%12)];
                    imgKr.image = [UIImage imageNamed:strImageName];
                    imgKr.image = [UIImage imageNamed:strImageName];
                    imgKr.center = CGPointMake(imgAdd.bounds.size.width/4 +
                                               arc4random() % ((int)imgAdd.bounds.size.width/2),
                                               imgAdd.bounds.size.height/4 +
                                               arc4random() % ((int)imgAdd.bounds.size.height/2));
                    [imgAdd addSubview:imgKr];
                }
                break;
            }
            case ButtonMenuImageTypeBuyCoin3:{
                imgAdd.image = [UIImage imageNamed:@"BuyCoin04.png"];
                for(int i = 0 ; i < 20 ; i++){
                    CGRect rectKr = CGRectMake(0, 0, imgAdd.bounds.size.width/5,
                                               imgAdd.bounds.size.height/4);
                    UIImageView *imgKr = [[UIImageView alloc]initWithFrame:rectKr];
                    NSString *strImageName = [NSString stringWithFormat:@"img%02d.png",
                                              MAX(3, arc4random()%12)];
                    imgKr.image = [UIImage imageNamed:strImageName];
                    imgKr.center = CGPointMake(arc4random() % ((int)imgAdd.bounds.size.width),
                                               imgAdd.bounds.size.height/3+
                                               arc4random() % ((int)imgAdd.bounds.size.height*2/3));
                    [imgAdd addSubview:imgKr];
                }
                break;
            }
            case ButtonMenuImageTypeBuyCoin4:{
                imgAdd.image = [UIImage imageNamed:@"BuyCoin05.png"];
                for(int i = 0 ; i < 30 ; i++){
                    CGRect rectKr = CGRectMake(0, 0, imgAdd.bounds.size.width/5,
                                               imgAdd.bounds.size.height/4);
                    UIImageView *imgKr = [[UIImageView alloc]initWithFrame:rectKr];
                    NSString *strImageName = [NSString stringWithFormat:@"img%02d.png",
                                              MAX(3, arc4random()%12)];
                    imgKr.image = [UIImage imageNamed:strImageName];
                    imgKr.center = CGPointMake(arc4random() % ((int)imgAdd.bounds.size.width),
                                               imgAdd.bounds.size.height/3 +
                                               arc4random() % ((int)imgAdd.bounds.size.height*2/3));
                    [imgAdd addSubview:imgKr];
                }
                break;
            }
            case ButtonMenuImageTypeBuyCoin5:{
                imgAdd.image = [UIImage imageNamed:@"BuyCoin06.png"];
                for(int i = 0 ; i < 30 ; i++){
                    CGRect rectKr = CGRectMake(0, 0, imgAdd.bounds.size.width/5,
                                               imgAdd.bounds.size.height/4);
                    UIImageView *imgKr = [[UIImageView alloc]initWithFrame:rectKr];
                    NSString *strImageName = [NSString stringWithFormat:@"img%02d.png",
                                              MAX(3, arc4random()%12)];
                    imgKr.image = [UIImage imageNamed:strImageName];
                    imgKr.center = CGPointMake(imgAdd.bounds.size.width/4 +
                                               arc4random() % ((int)imgAdd.bounds.size.width/2),
                                               imgAdd.bounds.size.height/3 +
                                               arc4random() % ((int)imgAdd.bounds.size.height*2/3));
                    [imgAdd addSubview:imgKr];
                }
                break;
            }
            case ButtonMenuImageTypeDialogYes:{
                imgAdd.image = [UIImage imageNamed:@"yes_2.png"];//o
                UIImageView *imgAdd2 =
                [[UIImageView alloc]
                 initWithFrame:
                 CGRectMake(0, 0,
                            imgAdd.bounds.size.width/2,
                            imgAdd.bounds.size.height/2)];
                imgAdd2.center = CGPointMake(imgAdd.bounds.size.width/2,
                                             imgAdd.bounds.size.height/2);
                imgAdd2.image = [UIImage imageNamed:@"yes2.png"];
                
                [imgAdd addSubview:imgAdd2];
                break;
            }
            case ButtonMenuImageTypeDialogNo:{
                imgAdd.image = [UIImage imageNamed:@"no_2.png"];//x
                UIImageView *imgAdd2 =
                [[UIImageView alloc]
                 initWithFrame:
                 CGRectMake(0, 0,
                            imgAdd.bounds.size.width/2,
                            imgAdd.bounds.size.height/2)];
                imgAdd2.center = CGPointMake(imgAdd.bounds.size.width/2,
                                             imgAdd.bounds.size.height/2);
                imgAdd2.image = [UIImage imageNamed:@"no2.png"];//いいえ
                [imgAdd addSubview:imgAdd2];
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

-(void) putBlock:(ActionBlockInUIV) action1
{
    _actionBlock = action1;//Block_copy(action);
    
    
    
//    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}

-(void) callActionBlock:(id)sender{
    _actionBlock();
    //自動的に閉じる
    //    [self.superview.superview ]
}

@end
