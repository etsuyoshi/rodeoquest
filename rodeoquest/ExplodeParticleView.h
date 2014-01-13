//
//  ExplodeParticleView.h
//  Shooting3
//
//  Created by 遠藤 豪 on 13/10/01.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
typedef NS_ENUM(NSInteger, ExplodeParticleType) {
    ExplodeParticleTypeRedFire,
    ExplodeParticleTypeOrangeFire,
    ExplodeParticleTypeBlueFire,
    ExplodeParticleTypeWater
    
};
@interface ExplodeParticleView : UIView{
//    CAEmitterLayer *fireEmitter;
    CAEmitterLayer *particleEmitter;
    Boolean isFinished;
    int myBirthRate;
    int originalBirthRate;
    int type;
}
-(id)initWithFrame:(CGRect)frame;
-(id)initWithFrame:(CGRect)frame type:(ExplodeParticleType)_explodeParticleType;
//-(void)setEmitterPositionFromTouch: (UITouch*)t;
-(void)setOnOffEmitting;
-(void)setNoEmitting;
-(void)setIsEmitting:(BOOL)isEmitting;
-(Boolean)getIsFinished;
-(void)setType:(int)type;
//-(void)awakeFromNib:(CGPoint)location;
//-(void)bomb:(CGPoint)location;
-(void)setBirthRate:(int)birthRate;
@end
