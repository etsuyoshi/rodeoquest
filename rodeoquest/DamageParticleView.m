//
//  DamageParticleView.m
//  Shooting4
//
//  Created by 遠藤 豪 on 13/10/02.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "DamageParticleView.h"
#import "QuartzCore/QuartzCore.h"

@implementation DamageParticleView

-(id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    isFinished = false;
    if (self) {
        // Initialization code
        //http://enharmonichq.com/tutorial-particle-systems-in-core-animation-with-caemitterlayer/
        particleEmitter = (CAEmitterLayer *) self.layer;
        particleEmitter.emitterPosition = CGPointMake(0, 0);//CGPointMake(frame.origin.x, frame.origin.y);//CGPointMake(0, 0);
        particleEmitter.emitterSize = CGSizeMake(3,3);//frame.size.width, frame.size.height);
        particleEmitter.renderMode = kCAEmitterLayerAdditive;
        
        CAEmitterCell *particle = [CAEmitterCell emitterCell];
        particle.birthRate = 100;//火や水に見せるためには数百が必要
        particle.lifetime = 0.5;//表示時間(秒)
        particle.lifetimeRange = 0;
        particle.color = [[UIColor colorWithRed: 0.1 green: 0.4 blue: 0.2 alpha: 0.5] CGColor];
//        particle.contents = (id) [[UIImage imageNamed: @"star.png"] CGImage];
        int pattern = arc4random() % 3;
        if(pattern == 0){
            particle.contents = (id) [[UIImage imageNamed: @"explode3.png"] CGImage];
        }else if(pattern == 1){
            particle.contents = (id) [[UIImage imageNamed: @"explode4.png"] CGImage];
        }else if(pattern == 2){
            particle.contents = (id) [[UIImage imageNamed: @"explode5.png"] CGImage];
        }
        particle.name = @"damage";
        particle.velocity = 10;//流れる平均速度(dot)
        particle.velocityRange = 10;//速度の標準偏差
        particle.emissionLongitude = -M_PI_2;//流れる方向(正：時計回り)
        particle.emissionRange = -1 * M_PI_2;//流れる方向の標準偏差
        particle.scale = 0.15f;//最大サイズ
        particle.scaleSpeed = 0.5f;//最大サイズになるまでのスピード
        particle.scaleRange = 1.0f;//最大サイズのレンジ
        particle.spin = 1.0f;//回転角度
        
        
        
        particleEmitter.emitterCells = [NSArray arrayWithObject: particle];
    }
    //    NSLog(@"%@", self);//<DWFParticleView: 0x92458e0; frame = (160 160; 150 150); layer = <CAEmitterLayer: 0x9243e50>>
    return self;
    
}

-(void)setColor:(DamageParticleType)_type{
    [particleEmitter setValue:(id)[[self getColor:_type] CGColor]
                   forKeyPath:@"emitterCells.damage.color"];
//    switch ((DamageParticleType)_type) {
//        case DamageParticleTypeBlack:{//done
//            [particleEmitter setValue:(id)[[UIColor colorWithRed: 0.1f green: 0.1f blue: 0.1f alpha: 0.1f] CGColor]
//                           forKeyPath:@"emitterCells.damage.color"];
//            break;
//        }
//        case DamageParticleTypeBlue:{//done:調整必要
//            [particleEmitter setValue:(id)[[UIColor colorWithRed: 0 green: 0.2f blue: 0.5 alpha: 0.1] CGColor]
//                           forKeyPath:@"emitterCells.damage.color"];
//            break;
//        }
//            
//        case DamageParticleTypeOrange:{//done
//            [particleEmitter setValue:(id)[[UIColor colorWithRed: 0.8 green: 0.4 blue: 0.2 alpha: 0.1] CGColor]
//                           forKeyPath:@"emitterCells.damage.color"];
//            break;
//        }
//        case DamageParticleTypeRed:{
//            [particleEmitter setValue:(id)[[UIColor colorWithRed: 0.5 green: 0.1 blue: 0.1 alpha: 0.1] CGColor]
//                           forKeyPath:@"emitterCells.damage.color"];
//            break;
//        }
//            
//        default:{//上記以外：
//            [particleEmitter setValue:(id)[[self getColor:_type] CGColor]
//                           forKeyPath:@"emitterCells.damage.color"];
//            break;
//        }
//    }
}

-(id)getColor:(DamageParticleType)_type{
    
    //original-color
//    NSArray *arrColor =
//    [NSArray arrayWithObjects:
//     [[UIColor magentaColor] colorWithAlphaComponent:0.1f],//DamageParticleTypePink,
//     [[UIColor redColor] colorWithAlphaComponent:0.1f],//DamageParticleTypeRed,
//     [[UIColor orangeColor] colorWithAlphaComponent:0.1f],//DamageParticleTypeOrange,
//     [[UIColor yellowColor] colorWithAlphaComponent:0.1f],//DamageParticleTypeYellow,
//     [[UIColor greenColor] colorWithAlphaComponent:0.1f],//DamageParticleTypeGreen,
//     [[UIColor cyanColor] colorWithAlphaComponent:0.1f],//DamageParticleTypeCyan,
//     [[UIColor blueColor] colorWithAlphaComponent:0.1f],//DamageParticleTypeBlue,
//     [[UIColor purpleColor] colorWithAlphaComponent:0.1f],//DamageParticleTypePurple,
//     [[UIColor blackColor] colorWithAlphaComponent:0.1f],//DamageParticleTypeBlack,
//     [[UIColor whiteColor] colorWithAlphaComponent:0.1f],//DamageParticleTypeWhite,
//     nil];
//    return arrColor[_type];
    
    //adjusted-color：http://lowlife.jp/yasusii/static/color_chart.html
    NSArray *arrColor =
    [NSArray arrayWithObjects:
     [NSArray arrayWithObjects:@255.0, @105.0f,@180.0f,nil],//hotpink//DamageParticleTypePink,
     [NSArray arrayWithObjects:@178, @34, @34, nil],//firebrick//DamageParticleTypeRed,
     [NSArray arrayWithObjects:@255, @127, @80, nil],//coral////DamageParticleTypeOrange,
     [NSArray arrayWithObjects:@255, @215, @0, nil],//gold//DamageParticleTypeYellow,
     [NSArray arrayWithObjects:@32, @178, @170, nil],//LightSeaGreen//DamageParticleTypeGreen,
     [NSArray arrayWithObjects:@0, @205, @205, nil],//cyan3//DamageParticleTypeCyan,
     [NSArray arrayWithObjects:@72, @118, @255, nil],//loyalBlue1//DamageParticleTypeBlue,
     [NSArray arrayWithObjects:@224, @102, @255, nil],//MediumOrchid1//DamageParticleTypePurple
     [NSArray arrayWithObjects:@139, @123, @139, nil],//thistle4//DamageParticleTypeBlack,
     [NSArray arrayWithObjects:@238, @210, @238, nil],//thistle2//DamageParticleTypeWhite,
     nil];
//    NSLog(@"from getColor:%@", arrColor[_type]);
    float red = [arrColor[_type][0] floatValue]/255.0f;
    float green = [arrColor[_type][1] floatValue]/255.0f;
    float blue = [arrColor[_type][2] floatValue]/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:0.3f];
}

+ (Class) layerClass //3
{
    //configure the UIView to have emitter layer
    return [CAEmitterLayer class];
}


-(void)setNoEmitting{
    
    [particleEmitter setValue:[NSNumber numberWithInt:0]
                   forKeyPath:@"emitterCells.damage.birthRate"];
}

-(void)setIsEmitting:(BOOL)isEmitting
{
    //turn on/off the emitting of particles:引数がyesならばbirthRateを200に、noならば0(消去)
    //    [particleEmitter setValue:[NSNumber numberWithInt:isEmitting?200:0]
    //               forKeyPath:@"emitterCells.fire.birthRate"];
    if(isEmitting){
        isFinished = false;
    }else{
        isFinished = true;
    }
    
    
    [particleEmitter setValue:[NSNumber numberWithInt:isEmitting?100:0]
                   forKeyPath:@"emitterCells.damage.birthRate"];
    
    //    [particleEmitter setValue:[NSNumber numberWithInt:isEmitting?30:0] forKeyPath:@"emitterCells.particle.birthRate"];
}

-(Boolean)getIsFinished{
    return isFinished;
}


@end
