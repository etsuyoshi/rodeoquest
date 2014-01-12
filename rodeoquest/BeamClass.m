//
//  BeamClass.m
//  Shooting3
//
//  Created by 遠藤 豪 on 13/09/28.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "BeamClass.h"
//#import "UIView+Animation.h"

@implementation BeamClass
-(id) init:(int)x_init y_init:(int)y_init width:(int)w height:(int)h{
    
    y_loc = y_init;
    x_loc = x_init;
    power = 1;//衝突対象に対するダメージ
    width = w;
    height = h;
    isAlive = true;
    rect = CGRectMake(x_loc - w/2, y_loc - h/2, w, h);
    iv = [[UIImageView alloc]initWithFrame:rect];
//    iv.image = [UIImage imageNamed:@"beam.png"];
//    iv.image = [UIImage imageNamed:@"bullet_level1.png"];
    iv.image = [UIImage imageNamed:@"09.png"];
    
    iv.center = CGPointMake(x_loc, y_loc);
    
//    [UIView animateWithDuration:1.0f
//                          delay:0.0f
//                        options:UIViewAnimationOptionCurveLinear
//                     animations:^{
//                         iv.center = CGPointMake(x_loc,
//                                                 y_loc - 500);//iv.superview.bounds.size.height);
//                         
//                     }
//                     completion:^(BOOL finished){
//                         [iv removeFromSuperview];
//                         iv=nil;
//                     }];
    return self;
}
-(id) init{
//    NSLog(@"call enemy class initialization");
    return [self init:0 y_init:0 width:10 height:10];
}

-(Boolean) getIsAlive{
    return isAlive;
}

-(void)doNext{
    
//    CALayer *mLayer = [iv.layer presentationLayer];
//    x_loc = mLayer.position.x;//中心座標
//    y_loc = mLayer.position.y;//中心座標
//    NSLog(@"yBeam = %d", y_loc);
    y_loc -= height /3;
    iv.center = CGPointMake(x_loc, y_loc);
//    x_loc += 0;//mySize/10 * (int)pow(-1, arc4random()%2) % 200;//単位時間当たりに左右3個体分の移動距離を進む
//    iv = [[UIImageView alloc]initWithFrame:CGRectMake(x_loc - width/2, y_loc - height/2, width, height)];
//    iv.image = [UIImage imageNamed:@"beam.png"];
//    iv.image = [UIImage imageNamed:@"bullet_level1.png"];
//    iv.image = [UIImage imageNamed:@"09.png"];
    
    //    NSLog(@"更新後 y = %d", y_loc);
    //    rect = CGRectMake(x_loc, y_loc, mySize, mySize);
    //    iv = [[UIImageView alloc]initWithFrame:rect];
    if(y_loc <= -height*2){// || !isAlive){
//        NSLog(@"die at %d according to frame out", y_loc);
        [self die];
        [iv removeFromSuperview];//集約する
    }
}

-(int)getPower{
    return power;
}

-(int) die{
    isAlive = false;
//    [iv removeFromSuperview];
    
    return -1;//サブクラスのSpecialBeamClassで特殊効果を発動するか否か
    /*
     *gameクラスにおいて画面外での消滅時のdieは何もせず、
     *敵機衝突での消滅時のdieは返り値を拾ってエフェクトを拾う
     *エフェクトは敵UIViewにaddして継続的に発生：処理が遅くなるのであまり重いものはできない
     */
}
-(void) setLocation:(CGPoint)loc{
    x_loc = (int)loc.x;
    y_loc = (int)loc.y;
}

-(void)setX:(int)x{
    x_loc = x;
}
-(void)setY:(int)y{
    y_loc = y;
}

-(CGPoint) getLocation{
    return CGPointMake((float)x_loc, (float)y_loc);
}

-(int) getX{
    return x_loc;
}

-(int) getY{
    return y_loc;
}

-(int)getSize{
    return width;
}

-(UIImageView *)getImageView{
    return iv;
}

-(UIView *)getEffect{
    //サブクラスの特殊武器において使用
    return nil;
}

@end
