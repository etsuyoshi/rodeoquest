//
//  ViewFireWorks.m
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/13.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "ViewFireWorks.h"

@implementation ViewFireWorks
CAEmitterLayer *rootLayer;
CAEmitterLayer *mortor;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        //Create the root layer
//        rootLayer = [CALayer layer];
        rootLayer = (CAEmitterLayer *) self.layer;
        //Set the root layer's attributes
        rootLayer.bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
//        CGColorRef color = CGColorCreateGenericRGB(0.0, 0.0, 0.0, 1);
//        CGColor *color = [[UIColor blackColor] CGColor];
//        rootLayer.backgroundColor = color;
//        CGColorRelease(color);
        
        
        //Load the spark image for the particle
//        const char* fileName = [[[NSBundle mainBundle] pathForResource:@"tspark" ofType:@"png"] UTF8String];
//        CGDataProviderRef dataProvider = CGDataProviderCreateWithFilename(fileName);
//        id img = (id) CGImageCreateWithPNGDataProvider(dataProvider, NULL, NO, kCGRenderingIntentDefault);
        
        mortor = [CAEmitterLayer layer];
//        mortor = (CAEmitterLayer *) self.layer;
        mortor.emitterPosition = CGPointMake(200, 600);//320, 0);//発射位置
        mortor.renderMode = kCAEmitterLayerAdditive;
        
        //Invisible particle representing the rocket before the explosion
        CAEmitterCell *rocket = [CAEmitterCell emitterCell];
        rocket.contents = (id) [[UIImage imageNamed: @"snow.png"] CGImage];//菱形
        rocket.emissionLongitude = M_PI / 2;
        rocket.emissionLatitude = 0;
        rocket.lifetime = 1.6;
        rocket.birthRate = 1;
        rocket.velocity = -50;//400;
        rocket.velocityRange = 100;
        rocket.yAcceleration = -250;
        rocket.emissionRange = M_PI / 4;
//        color = CGColorCreateGenericRGB(0.5, 0.5, 0.5, 0.5);
//        CGColor *color = [[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5] CGColor];
//        rocket.color = color;
//        CGColorRelease(color);
        rocket.color = [[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5] CGColor];
        rocket.redRange = 0.5;
        rocket.greenRange = 0.5;
        rocket.blueRange = 0.5;
        
        //Name the cell so that it can be animated later using keypath
        [rocket setName:@"rocket"];
        
        //Flare particles emitted from the rocket as it flys
        CAEmitterCell *flare = [CAEmitterCell emitterCell];
//        flare.contents = img;
        flare.contents = (id) [[UIImage imageNamed: @"snow.png"] CGImage];//菱形
        flare.emissionLongitude = (4 * M_PI) / 2;
        flare.scale = 0.4;
        flare.velocity = 100;
        flare.birthRate = 45;
        flare.lifetime = 1.5;
        flare.yAcceleration = -350;
        flare.emissionRange = M_PI / 7;
        flare.alphaSpeed = -0.7;
        flare.scaleSpeed = -0.1;
        flare.scaleRange = 0.1;
        flare.beginTime = 0.01;
        flare.duration = 0.7;
        
        //The particles that make up the explosion
        CAEmitterCell *firework = [CAEmitterCell emitterCell];
//        firework.contents = img;
        firework.contents = (id) [[UIImage imageNamed: @"snow.png"] CGImage];//菱形
        firework.birthRate = 9999;
        firework.scale = 0.6;
        firework.velocity = 130;
        firework.lifetime = 2;
        firework.alphaSpeed = -0.2;
        firework.yAcceleration = -80;
        firework.beginTime = 1.5;
        firework.duration = 0.1;
        firework.emissionRange = 2 * M_PI;
        firework.scaleSpeed = -0.1;
        firework.spin = 2;
        
        //Name the cell so that it can be animated later using keypath
        [firework setName:@"firework"];
        
        //preSpark is an invisible particle used to later emit the spark
        CAEmitterCell *preSpark = [CAEmitterCell emitterCell];
        preSpark.birthRate = 80;
        preSpark.velocity = firework.velocity * 0.70;
        preSpark.lifetime = 1.7;
        preSpark.yAcceleration = firework.yAcceleration * 0.85;
        preSpark.beginTime = firework.beginTime - 0.2;
        preSpark.emissionRange = firework.emissionRange;
        preSpark.greenSpeed = 100;
        preSpark.blueSpeed = 100;
        preSpark.redSpeed = 100;
        
        //Name the cell so that it can be animated later using keypath
        [preSpark setName:@"preSpark"];
        
        //The 'sparkle' at the end of a firework
        CAEmitterCell *spark = [CAEmitterCell emitterCell];
//        spark.contents = img;
        spark.contents = (id) [[UIImage imageNamed: @"snow.png"] CGImage];//菱形
        spark.lifetime = 0.05;
        spark.yAcceleration = -250;
        spark.beginTime = 0.8;
        spark.scale = 0.4;
        spark.birthRate = 10;
        
        preSpark.emitterCells = [NSArray arrayWithObjects:spark, nil];
        rocket.emitterCells = [NSArray arrayWithObjects:flare, firework, preSpark, nil];
        mortor.emitterCells = [NSArray arrayWithObjects:rocket, nil];
        [rootLayer addSublayer:mortor];
        
        //Set the view's layer to the base layer
//        [self.layer addLayer:rootLayer];
//        [theView setWantsLayer:YES];
        
        //Force the view to update
//        [theView setNeedsDisplay:YES];
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

@end
