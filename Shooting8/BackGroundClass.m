//
//  BackGroundClass.m
//  Shooting8
//
//  Created by 遠藤 豪 on 2013/11/04.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.

//#define TEST
#import "BackGroundClass.h"
#import "UIView+Animation.h"

@implementation BackGroundClass
@synthesize wType;

int imageMargin;
-(id)init{//引数なしで呼び出された場合のポリモーフィズム
    self = [self init:0 width:320 height:480];
    
    return self;
}
-(id)init:(WorldType)_type width:(int)width height:(int)height{
    self = [super init];
    imageMargin = 20;
    originalFrameSize = height;//フレーム縦サイズ
    
    iv_background1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, originalFrameSize + imageMargin)];
    iv_background2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, -originalFrameSize,
                                                                  width, originalFrameSize + imageMargin)];
    
    //つなぎ目Check@静止画
//    iv_background1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, -originalFrameSize/2, width, originalFrameSize)];
//    iv_background2 = [[UIImageView alloc]initWithFrame:CGRectMake(0,  originalFrameSize/2, width, originalFrameSize)];
//    y_loc1 = iv_background1.bounds.origin.y;
//    y_loc2 = iv_background2.bounds.origin.y;
    y_loc1 = ((CALayer *)[iv_background1.layer presentationLayer]).position.y;//center = 240
    y_loc2 = ((CALayer *)[iv_background2.layer presentationLayer]).position.y;//center = -240
    wType = _type;
    
    //frameの大きさと背景の現在描画位置を決定
    //点数オブジェクトで描画
    
//#ifndef TEST
    switch(wType){
        case WorldTypeUniverse1:{
            //宇宙空間の描画方法
            iv_background1.image = [UIImage imageNamed:@"cosmos_star4_repair.png"];
            iv_background2.image = [UIImage imageNamed:@"cosmos_star4_repair.png"];
            break;
        }
        case WorldTypeUniverse2:{
            //宇宙バージョン
            iv_background1.image = [UIImage imageNamed:@"back_univ.png"];
            iv_background2.image = [UIImage imageNamed:@"back_univ2.png"];
            
            break;
        }
        case WorldTypeNangoku:{
            //南国バージョン
            iv_background1.image = [UIImage imageNamed:@"back_nangoku.png"];
            iv_background2.image = [UIImage imageNamed:@"back_nangoku.png"];
            
            break;
        }
        case WorldTypeSnow:{
            
            //雪山バージョン
            iv_background1.image = [UIImage imageNamed:@"back_snow.png"];
            iv_background2.image = [UIImage imageNamed:@"back_snow.png"];
            
            break;
        }
        case WorldTypeDesert:{
            //砂漠バージョン
            iv_background1.image = [UIImage imageNamed:@"back_desert.png"];
            iv_background2.image = [UIImage imageNamed:@"back_desert.png"];
            
            break;
        }
        case WorldTypeForest:{
            //森バージョン
            iv_background1.image = [UIImage imageNamed:@"back_forest.png"];
            iv_background2.image = [UIImage imageNamed:@"back_forest.png"];
            break;
        }
    }
//#endif

    return self;
}

-(void)startAnimation:(float)secs{
    
    if(y_loc1 > 0){//最初の状態
        [UIView animateWithDuration:secs/2
                              delay:0.0f
                            options:UIViewAnimationOptionCurveLinear//一定速度
                         animations:^{
                             iv_background1.frame =
                             CGRectMake(0, originalFrameSize,
                                        iv_background1.bounds.size.width,
                                        iv_background1.bounds.size.height);
                             
                             iv_background2.frame =
                             CGRectMake(0, originalFrameSize,
                                        iv_background2.bounds.size.width,
                                        iv_background2.bounds.size.height);
                         }
                         completion:^(BOOL finished){
                             //初期化
                             iv_background1.frame =
                                CGRectMake(0, -originalFrameSize,
                                           iv_background1.bounds.size.width,
                                           iv_background1.bounds.size.height);
                             
                                [self startAnimation:secs*2];
                         }];
    }
    
    
    //    if(y_loc1 <= 0){//通常ルーチン:y_loc1==-iv_background1.bounds.size.height/2
//    if(y_loc1 == -((float)originalFrameSize - imageMargin)/2){
//        [iv_background1 moveTo:CGPointMake(0, originalFrameSize)//origin
//                      duration:10.0f
//                        option:UIViewAnimationOptionCurveLinear];
//    }else if(y_loc1 == ((float)originalFrameSize - imageMargin) /2){//初期状態では１の中心が画面の中心に位置しているので速さは半分
//        [iv_background1 moveTo:CGPointMake(0, originalFrameSize)//origin
//                      duration:5.0f
//                        option:UIViewAnimationOptionCurveLinear];
//    }else{
//        NSLog(@"y_loc1 = %d", y_loc1);
//    }
//    //    if(y_loc2 <= 0){//y_loc2==-iv_background2.bounds.size.height/2){
//    if(y_loc2 == -((float)originalFrameSize - imageMargin)/2){//通常ルーチン
//        [iv_background2 moveTo:CGPointMake(0, originalFrameSize)//origin
//                      duration:10.0f
//                        option:UIViewAnimationOptionCurveLinear];
//    }else if(y_loc2 == -((float) originalFrameSize - imageMargin)/2){//初期状態では２の中心が画面上部外側
//        [iv_background2 moveTo:CGPointMake(0, originalFrameSize)//origin
//                      duration:10.0f
//                        option:UIViewAnimationOptionCurveLinear];
//    }
//    
//    //初期化
//    if(y_loc1 >= (float)originalFrameSize * 3 / 2){//最後まで描画されたら
//        
//        //        iv_background1.frame = CGRectMake(0, -(originalFrameSize),// + imageMargin),下margin部分は被らせる
//        //                                          iv_background1.bounds.size.width,
//        //                                          originalFrameSize + imageMargin);
//        iv_background1.center = CGPointMake(iv_background1.bounds.size.width /2,
//                                            -originalFrameSize/2);
//    }
//    if(y_loc2 >= (float)originalFrameSize * 3 / 2){//最後まで描画されたら
//        //        iv_background2.frame = CGRectMake(0, -(originalFrameSize),// + imageMargin),下部分のimageMarginは被らせる
//        //                                          iv_background2.bounds.size.width,
//        //                                          originalFrameSize + imageMargin);
//        iv_background2.center = CGPointMake(iv_background2.bounds.size.width / 2,
//                                            -originalFrameSize/2);
//        
//    }
}



/*
 *離散的に呼び出されるdoNext：離散的呼び出しなのでここでアニメーションの繰り返し処理をすれば途切れてしまう
 */
-(void)doNext{
    
//    CALayer *mLayer = [iv_background1.layer presentationLayer];
    //現在中心座標
    y_loc1 = ((CALayer *)[iv_background1.layer presentationLayer]).position.y;//center = 240
    y_loc2 = ((CALayer *)[iv_background2.layer presentationLayer]).position.y;//center = -240
    
    
    
    
#ifdef TEST
    NSLog(@"y1 = %d", y_loc1);
    NSLog(@"y2 = %d", y_loc2);
//    NSLog(@"y1 = %d", y_loc1);
//    NSLog(@"y2 = %d", y_loc2);
#endif
}

-(void)setImage:(NSString *)_imageName{
    _imageName = imageName;
}

-(UIImageView *)getImageView1{
    return iv_background1;
}
-(UIImageView *)getImageView2{
    return iv_background2;
}

@end
