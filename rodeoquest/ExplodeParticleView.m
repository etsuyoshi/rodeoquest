//
//  ExplodeParticleView.m
//  Shooting3
//
//  Created by 遠藤 豪 on 13/10/01.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "ExplodeParticleView.h"
#import "QuartzCore/QuartzCore.h"

@implementation ExplodeParticleView

-(id)initWithFrame:(CGRect)frame
{
    
    return  [self initWithFrame:frame type:ExplodeParticleTypeRedFire];
}
-(id)initWithFrame:(CGRect)frame type:(ExplodeParticleType)_explodeParticleType{
    
    self = [super initWithFrame:frame];
    isFinished = false;
    if (self) {
        // Initialization code
        
#ifdef DEBUG
//        NSLog(@"ExplodeParticleView start");
#endif
        
        
        originalBirthRate = 300;
        myBirthRate = originalBirthRate;
        
        
//        CAEmitterLayer *particleEmitter;//global
        switch (_explodeParticleType) {
            case ExplodeParticleTypeRedFire:
            case ExplodeParticleTypeBlueFire:
            case ExplodeParticleTypeOrangeFire:{
                NSLog(@"fire");
                
                particleEmitter = (CAEmitterLayer *) self.layer;
                particleEmitter.emitterPosition = CGPointMake(0, 0);//CGPointMake(frame.origin.x, frame.origin.y);//CGPointMake(0, 0);
                particleEmitter.emitterSize = CGSizeMake(frame.size.width, frame.size.height);
                particleEmitter.renderMode = kCAEmitterLayerAdditive;
                
                CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
                emitterCell.birthRate = myBirthRate;//火や水に見せるためには数百が必要
                emitterCell.lifetime = 0.5;
                emitterCell.lifetimeRange = 0.5;
                emitterCell.color = [[UIColor colorWithRed: 0.2 green: 0.4 blue: 0.8 alpha: 0.1] CGColor];
                emitterCell.contents = (id) [[UIImage imageNamed: @"Particles_fire.png"] CGImage];
                emitterCell.name = @"fire";
                emitterCell.velocity = 50;
                emitterCell.velocityRange = 20;
                emitterCell.emissionLongitude = M_PI_2;
                emitterCell.emissionRange = M_PI_2;
                emitterCell.scale = 0.3f;
                emitterCell.scaleRange = 0;
                emitterCell.scaleSpeed = 0.5;
                emitterCell.spin = 0.5;
                particleEmitter.emitterCells = [NSArray arrayWithObject: emitterCell];
                break;
            }
            case ExplodeParticleTypeWater:{
                NSLog(@"water");
                particleEmitter = (CAEmitterLayer *) self.layer;
                particleEmitter.emitterPosition = CGPointMake(self.bounds.size.width / 2, self.bounds.origin.y); // 2
                particleEmitter.emitterZPosition = 10; // 3
                particleEmitter.emitterSize = CGSizeMake(self.bounds.size.width, 0); // 4
                particleEmitter.emitterShape = kCAEmitterLayerSphere; // 5
                
                CAEmitterCell *emitterCell = [CAEmitterCell emitterCell]; // 6
                emitterCell.scale = 0.1; // 7 : 0.1倍の大きさ
                emitterCell.scaleRange = 0.2; // 8 : 拡大誤差±0.2倍
                emitterCell.emissionLongitude = -M_PI_2;//上方向に発射
                emitterCell.emissionRange = (CGFloat)M_PI_2/4; // 9 : 発射後さは４分の９０度
                emitterCell.lifetime = 0.3; // 10 : 1秒で消える
                emitterCell.birthRate = 100; // 11 : 100個生成
                emitterCell.velocity = 200; // 12 : 秒速平均200px
                emitterCell.velocityRange = 50; // 13 : 秒速分散±50px
                emitterCell.yAcceleration = 100; // 14 : 縦軸方向加速度100px/sec^2
                
                emitterCell.color = [[UIColor colorWithRed: 0.2 green: 0.4 blue: 0.9 alpha: 0.5] CGColor];
                
                emitterCell.contents = (id)[[UIImage imageNamed:@"Particles_fire.png"] CGImage]; // 15
                emitterCell.name = @"fire";//正確にはwaterだけど、あとで指定する時に統一されている方が楽？
                particleEmitter.emitterCells = [NSArray arrayWithObject:emitterCell]; // 16
//                [self.view.layer addSublayer:emitterLayer]; // 17
                break;
            }
        }
        
        
        
    }
//    NSLog(@"%@", self);//<ExplodeParticleView: 0x92458e0; frame = (160 160; 150 150); layer = <CAEmitterLayer: 0x9243e50>>
#ifdef DEBUG
//    NSLog(@"ExplodeParticleView end");
#endif

    return self;

    
    
    
}

//-(void)awakeFromOther:(CGPoint)location{
//    [self awakeFromNib];
//    fireEmitter.emitterPosition = location;
//    
//}

+ (Class) layerClass //3
{
    //configure the UIView to have emitter layer
    return [CAEmitterLayer class];
}

/*
-(void)setEmitterPositionFromTouch: (UITouch*)t
{
    //change the emitter's position
    fireEmitter.emitterPosition = [t locationInView:self];
}
*/

-(void)setType:(int)_type{
#ifdef DEBUG
//    NSLog(@"setType start");
#endif
    type = _type;
    NSLog(@"type=%d" , type);
    switch(type){
        case 0:{//自機は赤で前向き
//            NSLog(@"explode at type = %d", type);
            [particleEmitter setValue:(id)[[UIColor colorWithRed: 0.5 green: 0.1 blue: 0.1 alpha: 0.1] CGColor]
                           forKeyPath:@"emitterCells.fire.color"];
            [particleEmitter setValue:[NSNumber numberWithDouble:-M_PI_2]
                           forKeyPath:@"emitterCells.fire.emissionLongitude"];
            break;
        }
        case 1:{//敵機は青で後ろ向き
//            NSLog(@"explode at type = %d", type);
            [particleEmitter setValue:(id)[[UIColor colorWithRed: 0.1 green: 0.1 blue: 0.5 alpha: 0.1] CGColor]
                           forKeyPath:@"emitterCells.fire.color"];
            [particleEmitter setValue:[NSNumber numberWithDouble:M_PI_2]
                           forKeyPath:@"emitterCells.fire.emissionLongitude"];

            break;
        }
        case 2:{//高温フレア:white-orange
            NSLog(@"orange");
            [particleEmitter setValue:(id)[[UIColor colorWithRed: 0.8 green: 0.4 blue: 0.2 alpha: 0.1] CGColor]
                           forKeyPath:@"emitterCells.fire.color"];
            [particleEmitter setValue:[NSNumber numberWithDouble:-M_PI_2]
                           forKeyPath:@"emitterCells.fire.emissionLongitude"];
            break;
        }
        case 3:{//青い水？
            NSLog(@"blue");
            [particleEmitter setValue:(id)[[UIColor colorWithRed:0 green:0.1 blue:0.8 alpha:0.1] CGColor]
                           forKeyPath:@"emitterCells.fire.color"];
            [particleEmitter setValue:[NSNumber numberWithDouble:-M_PI_2]
                           forKeyPath:@"emitterCells.fire.emissionLongitude"];
            break;
        }
        default:{
            NSLog(@"defaults");
            break;
        }
    }
    NSLog(@"setType exit");
    
}


//発火と消火の切り替え(現在の状態を判定して切り替え：繰り返し用)
-(void)setOnOffEmitting{
//    if(myBirthRate )
    //myBirthRateで状態を判定し、反転した上で発火と消火を切り替える
    myBirthRate = (myBirthRate!=0)?0:originalBirthRate;//0でなければ0、0なら300を返す
    BOOL isEmitting = (myBirthRate>0)?YES:NO;
    [self setIsEmitting:isEmitting];
    
//    NSLog(@"explode=%d" , isEmitting);
    
    //1秒間隔で発火と消火を繰り返す
    [NSTimer scheduledTimerWithTimeInterval:1.0f
                                     target:self
                                   selector:@selector(setOnOffEmitting)
                                   userInfo:nil
                                    repeats:NO];
    
}
//引数を渡さずに直接停止させる方法
-(void)setNoEmitting{
    [self setIsEmitting:NO];
}

-(void)setIsEmitting:(BOOL)isEmitting
{
    //turn on/off the emitting of particles:引数がyesならばbirthRateを200に、noならば0(消去)
//    [particleEmitter setValue:[NSNumber numberWithInt:isEmitting?200:0]
//               forKeyPath:@"emitterCells.fire.birthRate"];
    
#ifdef DEBUG
//    NSLog(@"setEmitting start");
#endif
    if(isEmitting){
        isFinished = false;
    }else{
        isFinished = true;
    }
    
    myBirthRate = isEmitting?originalBirthRate:0;
    [particleEmitter setValue:[NSNumber numberWithInt:myBirthRate]
                   forKeyPath:@"emitterCells.fire.birthRate"];

//    [particleEmitter setValue:[NSNumber numberWithInt:isEmitting?30:0] forKeyPath:@"emitterCells.particle.birthRate"];
    
#ifdef DEBUG
//    NSLog(@"setEmitting exit");
#endif

}

-(Boolean)getIsFinished{
#ifdef DEBUG
//    NSLog(@"getIsFinished @ Explodeparticle");
#endif
    return isFinished;
}

//生成数を増やす
-(void)setBirthRate:(int)_birthRate{
    originalBirthRate = _birthRate;
}

@end
