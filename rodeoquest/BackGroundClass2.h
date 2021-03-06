//
//  BackGroundClass2.h
//  Shooting8
//
//  Created by 遠藤 豪 on 2013/11/04.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, WorldType) {
    WorldTypeUniverse1,//0
    WorldTypeUniverse2,
    WorldTypeDesert,
    WorldTypeForest,
    WorldTypeNangoku,
    WorldTypeSnow,
    WorldTypeCount//6
};



@interface BackGroundClass2 : NSObject{
    
    int y_loc1;
    int y_loc2;
    float gSecs;
    float nowSpeed;
    int originalFrameSize;
    NSString *imageName;
    UIImageView *iv_background1;
    UIImageView *iv_background2;
    UIImageView *iv_oscillate1;
    UIImageView *iv_oscillate2;
}
@property(nonatomic) WorldType wType;

-(id)init;
-(id)init:(WorldType)_type width:(int)width height:(int)height secs:(float)secs;
-(void)stopAnimation;
-(void)pauseAnimations;
-(void)startAnimation;
-(void)doNext;
-(UIImageView *)getImageView1;
-(UIImageView *)getImageView2;
-(void)oscillateEffect:(int)count;
-(UIImageView *)getIvOscillate1;
-(UIImageView *)getIvOscillate2;
-(void)setSpeed:(float)speed;
-(void)exitAnimations;
-(void)gameOver;
@end
