//
//  BackGroundClass2.m
//  Shooting8
//
//  Created by 遠藤 豪 on 2013/11/04.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.

//#define TEST
#import "BackGroundClass2.h"
#import "UIView+Animation.h"

@implementation BackGroundClass2
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
    
    iv_background1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, 2*originalFrameSize)];
    iv_background2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, -2*originalFrameSize,
                                                                  width, 2*originalFrameSize)];
    
    //ゲームやメニュー表示中にホームボタンを押された後、最表示時に再度描画するため
    [self stopAnimation];
    
    //つなぎ目Check@静止画:テスト用=>startAnimationの内容をコメントアウトして停止
    //    iv_background1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, -originalFrameSize/2, width, originalFrameSize)];
    //    iv_background2 = [[UIImageView alloc]initWithFrame:CGRectMake(0,  originalFrameSize/2, width, originalFrameSize)];
    //    y_loc1 = iv_background1.bounds.origin.y;
    //    y_loc2 = iv_background2.bounds.origin.y;
    y_loc1 = iv_background1.center.y;//((CALayer *)[iv_background1.layer presentationLayer]).position.y;//center = 240
    y_loc2 = iv_background2.center.y;//((CALayer *)[iv_background2.layer presentationLayer]).position.y;//center = -240
    NSLog(@"init : yloc1=%d, %f, yloc2=%d, %f", y_loc1, iv_background1.center.y, y_loc2, iv_background2.center.y);
    wType = _type;
    
    //frameの大きさと背景の現在描画位置を決定
    //点数オブジェクトで描画
    
    UIImageView *subIv_background11 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,
                                                                                   iv_background1.bounds.size.width,
                                                                                   iv_background1.bounds.size.height/2)];
    UIImageView *subIv_background12 = [[UIImageView alloc]initWithFrame:CGRectMake(0, iv_background1.bounds.size.height/2,
                                                                                   iv_background1.bounds.size.width,
                                                                                   iv_background1.bounds.size.height/2)];
    UIImageView *subIv_background21 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,
                                                                                   iv_background2.bounds.size.width,
                                                                                   iv_background2.bounds.size.height/2)];
    UIImageView *subIv_background22 = [[UIImageView alloc]initWithFrame:CGRectMake(0, iv_background2.bounds.size.height/2,
                                                                                   iv_background2.bounds.size.width,
                                                                                   iv_background2.bounds.size.height/2)];
    
    UIImage *image1 = nil;
    UIImage *image2 = nil;
    //#ifndef TEST
    switch(wType){
        case WorldTypeUniverse1:{
            //宇宙空間の描画方法
            image1 = [UIImage imageNamed:@"cosmos_star4_repair.png"];
            image2 = [UIImage imageNamed:@"cosmos_star4_repair.png"];
            break;
        }
        case WorldTypeUniverse2:{
            //宇宙バージョン
            image1 = [UIImage imageNamed:@"back_univ.png"];
            image2 = [UIImage imageNamed:@"back_univ2.png"];//attention!
            
            break;
        }
        case WorldTypeNangoku:{
            //南国バージョン
            image1 = [UIImage imageNamed:@"back_nangoku.png"];
            image2 = [UIImage imageNamed:@"back_nangoku.png"];
            
            break;
        }
        case WorldTypeSnow:{
            
            //雪山バージョン
            image1 = [UIImage imageNamed:@"back_snow.png"];
            image2 = [UIImage imageNamed:@"back_snow.png"];
            
            break;
        }
        case WorldTypeDesert:{
            //砂漠バージョン
            image1 = [UIImage imageNamed:@"back_desert.png"];
            image2 = [UIImage imageNamed:@"back_desert.png"];
            
            break;
        }
        case WorldTypeForest:{
            //森バージョン
            image1 = [UIImage imageNamed:@"back_forest2.png"];
            image2 = [UIImage imageNamed:@"back_forest2.png"];
            break;
        }
    }
    //#endif
    
    //test:image
//    subIv_background11.image = image1;//[UIImage imageNamed:@"back_nangoku.png"];//image1;
//    subIv_background12.image = image2;//[UIImage imageNamed:@"back_snow.png"];
//    subIv_background21.image = image1;//[UIImage imageNamed:@"back_desert.png"];
//    subIv_background22.image = image2;//[UIImage imageNamed:@"back_forest2.png"];
    subIv_background11.image = [UIImage imageNamed:@"back_nangoku.png"];//image1;
    subIv_background12.image = [UIImage imageNamed:@"back_snow.png"];
    subIv_background21.image = [UIImage imageNamed:@"back_desert.png"];
    subIv_background22.image = [UIImage imageNamed:@"back_forest2.png"];

    
    [iv_background1 addSubview:subIv_background11];
    [iv_background1 addSubview:subIv_background12];
    [iv_background2 addSubview:subIv_background21];
    [iv_background2 addSubview:subIv_background22];
    
    
    return self;
}

-(void)stopAnimation{
    //静止中、アニメーション中のケースは引数で分ける？
    //静止中の場合
    int x0 = iv_background1.bounds.size.width/2;
    int y0 = originalFrameSize;
    //アニメーション中の場合
    int x1 = ((CALayer *)[iv_background1.layer presentationLayer]).position.x;
    int y1 = ((CALayer *)[iv_background1.layer presentationLayer]).position.y;
    int x2 = ((CALayer *)[iv_background2.layer presentationLayer]).position.x;
    int y2 = ((CALayer *)[iv_background2.layer presentationLayer]).position.y;
    
    NSLog(@"stop animation");
    [UIView animateWithDuration:0.001f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear//constant-speed
                     animations:^{
                         iv_background1.center = CGPointMake(x0, y0);
                         iv_background2.center = CGPointMake(x0, -y0);
                     }
                     completion:^(BOOL finished){
                         NSLog(@"block completion at stop animation");
                         if(finished){
                             NSLog(@"finished stop animation");
                         }
                     }];
}

-(void)animation1:(float)secs{
    int y1 = iv_background1.center.y;//((CALayer *)[iv_background1.layer presentationLayer]).position.y;
    int x1 = iv_background1.center.x;//((CALayer *)[iv_background1.layer presentationLayer]).position.x;
    NSLog(@"x1=%d, y1=%d", x1, y1);
//    [UIView animateWithDuration:secs
//                          delay:0
//                        options:UIViewAnimationOptionCurveLinear//constant-speed
//                     animations:^{
//                         iv_background1.center =
//                            CGPointMake(x1, y1 + originalFrameSize);
//                     }
//                     completion:^(BOOL finished){
//                         if(finished){
//                             if(iv_background1.center.y >= 2*originalFrameSize){
//                                 iv_background1.center = CGPointMake(x1, -2 * originalFrameSize);
//                             }
//                             NSLog(@"recursive at 1, y = %f", iv_background1.center.y);
//                             [self animation1:secs];
//                         }
//                     }];
    
    
    
    //一定速度に
    //cabasicanimationで中間地点を指定しない
    //recursiveに
    
    CGPoint kStartPos = iv_background1.center;//((CALayer *)[iv_background1.layer presentationLayer]).position;//
    CGPoint kEndPos = CGPointMake(x1,y1 + originalFrameSize);
    
    [CATransaction begin];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [CATransaction setCompletionBlock:^{//終了処理
        CAAnimation* animationKeyFrame = [iv_background1.layer animationForKey:@"position"];
        if(animationKeyFrame){
            NSLog(@"1 layer=%f,iv=%f", ((CALayer *)[iv_background1.layer presentationLayer]).position.y,
                  iv_background1.center.y);
//            if(iv_background1.center.y >= 2*originalFrameSize){
            if(((CALayer *)[iv_background1.layer presentationLayer]).position.y >= 2*originalFrameSize){
//                [self stopAnimation];
                iv_background1.center = CGPointMake(x1, -2*originalFrameSize);
                NSLog(@"2 layer=%f,iv=%f", ((CALayer *)[iv_background1.layer presentationLayer]).position.y,
                      iv_background1.center.y);
            }
            iv_background1.center = CGPointMake(x1, ((CALayer *)[iv_background1.layer presentationLayer]).position.y);
            NSLog(@"3 layer=%f,iv=%f", ((CALayer *)[iv_background1.layer presentationLayer]).position.y,
                  iv_background1.center.y);
            [self animation1:secs];
        }else{
            
        }
        
    }];
    
    {
        
        // CAKeyframeAnimationオブジェクトを生成
//        CAKeyframeAnimation *animation;
//        animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
        animation.fillMode = kCAFillModeForwards;
        animation.removedOnCompletion = NO;
        animation.duration = secs;
//        animation.repeatCount = HUGE_VALF;
        
        // アニメーションの始点と終点をセット
//        animation.fromValue = [NSValue valueWithCGPoint:kStartPos];//CGPointMake(0, 0)]; // 始点
        animation.toValue = [NSValue valueWithCGPoint:kEndPos];//CGPointMake(320, 480)]; // 終点
        
        
        // 放物線のパスを生成
//        CGPoint peakPos = CGPointMake((kStartPos.x + kEndPos.x)/2,
//                                      (kStartPos.y + kEndPos.y)/2);
//        CGMutablePathRef curvedPath = CGPathCreateMutable();
//        CGPathMoveToPoint(curvedPath, NULL, kStartPos.x, kStartPos.y);//始点に移動
//        CGPathAddCurveToPoint(curvedPath, NULL,
//                              peakPos.x, peakPos.y,
//                              (peakPos.x + kEndPos.x)/2, (peakPos.y + kEndPos.y)/2,
//                              kEndPos.x, kEndPos.y);
//        
//        // パスをCAKeyframeAnimationオブジェクトにセット
//        animation.path = curvedPath;
//        
//        // パスを解放
//        CGPathRelease(curvedPath);
        
        // レイヤーにアニメーションを追加
        [iv_background1.layer addAnimation:animation forKey:@"position"];
        
    }
    [CATransaction commit];
    
}

-(void)animation2:(float)secs{
    int y2 = iv_background2.center.y;//((CALayer *)[iv_background1.layer presentationLayer]).position.y;
    int x2 = iv_background2.center.x;//((CALayer *)[iv_background1.layer presentationLayer]).position.x;
    [UIView animateWithDuration:secs
                          delay:0
                        options:UIViewAnimationOptionCurveLinear//constant-speed
                     animations:^{
                         iv_background2.center =
                            CGPointMake(x2, y2 + originalFrameSize);
                     }
                     completion:^(BOOL finished){
                         if(finished){
                             if(iv_background2.center.y >= 2*originalFrameSize){
                                 iv_background2.center = CGPointMake(x2, -2 * originalFrameSize);
                             }
                             NSLog(@"recursive at 2, y = %f", iv_background2.center.y);
                             [self animation2:secs];
                         }
                     }];
}

-(void)startAnimation:(float)secs{
    [self animation1:secs];
    [self animation2:secs];
    
    
//    int y1 = iv_background1.center.y;//((CALayer *)[iv_background1.layer presentationLayer]).position.y;
//    int x1 = iv_background1.center.x;//((CALayer *)[iv_background1.layer presentationLayer]).position.x;
//    int y2 = iv_background2.center.y;//((CALayer *)[iv_background2.layer presentationLayer]).position.y;
//    int x2 = iv_background2.center.x;//((CALayer *)[iv_background2.layer presentationLayer]).position.x;
//    //    NSLog(@"x1=%d, x2=%d, y1=%d, y2=%d, originalFsize=%d", x1, x2, y1, y2, originalFrameSize);
//    NSLog(@"start2 : xC1=%f, xC2=%f, yC1=%f, yC2=%f, originalFrameSize=%d, secs=%f",
//          iv_background1.bounds.size.width/2,
//          iv_background2.bounds.size.width/2,
//          iv_background1.center.y,
//          iv_background2.center.y,
//          originalFrameSize, secs);
//    iv_background1.center = CGPointMake(x1, y1);
//    iv_background2.center = CGPointMake(x2, y2);
//    
//    [UIView animateWithDuration:secs
//                          delay:0.0f
//                        options:UIViewAnimationOptionCurveLinear//constant-speed
//                     animations:^{
//                         iv_background1.center =
//                         CGPointMake(x1, y1 + originalFrameSize);
//                         
//                         iv_background2.center =
//                         CGPointMake(x2, y2 + originalFrameSize);
//                     }
//                     completion:^(BOOL finished){
//                         NSLog(@"background animation finished=%@, secs=%f", finished?@"true":@"false", secs);
//                         //初期化
//                         if(finished){
//                             NSLog(@"finished : xC1=%f, xC2=%f, yC1=%f, yC2=%f, originalFrameSize=%d",
//                                   iv_background1.bounds.size.width/2,
//                                   iv_background2.bounds.size.width/2,
//                                   iv_background1.center.y,
//                                   iv_background2.center.y,
//                                   originalFrameSize);
//                             
//                             if(iv_background1.center.y > originalFrameSize){
//                                 iv_background1.center =
//                                 CGPointMake(iv_background1.bounds.size.width/2,
//                                             -originalFrameSize/2);
//                             }
//                             if(iv_background2.center.y > originalFrameSize){
//                                 iv_background2.center =
//                                 CGPointMake(iv_background2.bounds.size.width/2,
//                                             -originalFrameSize/2);
//                             }
//                             
//                             NSLog(@"recursive startAnimation");
//                             [self startAnimation:secs];
//                             //                             [self startAnimation:1.0f];
//                             
//                         }
//                     }];
}

-(void)oscillateEffect{
    //現在の位置で背景を一旦停止させ、左右に数ピクセル移動を繰り返す
    
    //    int y1 = ((CALayer *)[iv_background1.layer presentationLayer]).position.y;
    //    int x1 = ((CALayer *)[iv_background1.layer presentationLayer]).position.x;
    //    int y2 = ((CALayer *)[iv_background2.layer presentationLayer]).position.y;
    //    int x2 = ((CALayer *)[iv_background2.layer presentationLayer]).position.x;
    //
    //    iv_background1.center = CGPointMake(x1, y1);
    //    iv_background2.center = CGPointMake(x2, y2);
    //
    //    float _secs = 0.01;
    //    [UIView animateWithDuration:_secs
    //                     animations:^{
    //                         iv_background1.center = CGPointMake(x1 + 10, y1);
    //                         iv_background2.center = CGPointMake(x2 + 10, y2);
    //                     }
    //                     completion:^(BOOL finished){
    //                         if(finished){
    //                             [UIView animateWithDuration:_secs
    //                                              animations:^{
    //                                                  iv_background1.center = CGPointMake(x1 - 10, y1);
    //                                                  iv_background2.center = CGPointMake(x2 - 10, y2);
    //                                              }
    //                                              completion:^(BOOL finished){
    //                                                  if(finished){
    //                                                      [UIView animateWithDuration:_secs
    //                                                                       animations:^{
    //                                                                           iv_background1.center = CGPointMake(x1 + 10, y1);
    //                                                                           iv_background2.center = CGPointMake(x2 + 10, y2);
    //                                                                       }
    //                                                                       completion:^(BOOL finished){
    //                                                                           if(finished){
    //                                                                               [UIView animateWithDuration:_secs
    //                                                                                                animations:^{
    //                                                                                                    iv_background1.center = CGPointMake(x1, y1);
    //                                                                                                    iv_background2.center = CGPointMake(x2, y2);
    //                                                                                                }
    //                                                                                                completion:^(BOOL finished){
    //                                                                                                    [self startAnimation:5.0f];
    //                                                                                                }];
    //                                                                           }
    //                                                                       }];
    //                                                  }
    //                                              }];
    //                         }
    //
    //                     }];
    
}

//-(void)moveToPoint:p1{
//    [UIView animateWithDuration:0.3f
//                     animations:^{
//                         iv_background1.center = CGPointMake(x1 - 20, y1);
//                         iv_background2.center = CGPointMake(x2 - 20, y2);
//                     }
//                     completion:^(BOOL finished){
//
//                     }];
//}



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