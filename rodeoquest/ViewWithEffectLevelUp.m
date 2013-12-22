//
//  ViewWithEffectLevelUp.m
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/12.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "ViewWithEffectLevelUp.h"
#import "KiraParticleView.h"
#import "ViewFireWorks.h"
#import "CreateComponentClass.h"

@implementation ViewWithEffectLevelUp
UIView *viewLevelUp;
UIImageView *viewPaper;
UITextView *tvTitle;
UIView *viewBeforeLevel;
UIView *viewAfterLevel;
UIImageView *ivBeforeBeam;
UIImageView *ivAfterBeam;
UITextView *tvBeforeLevel;
UITextView *tvAfterLevel;
UIView *viewKiraParticle;

- (id)initWithFrame:(CGRect)frame{
    
    self = [self initWithFrame:frame beforeLevel:1 afterLevel:2];
    return self;
}
-(id)initWithFrame:(CGRect)frame beforeLevel:(int)blv afterLevel:(int)alv{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
        
        viewPaper = [[UIImageView alloc]
                     initWithFrame:CGRectMake(0, 0,
                                              self.frame.size.width, self.frame.size.height)];
        viewPaper.image = [UIImage imageNamed:@"sozai_paper.png"];
        [self addSubview:viewPaper];
        
        //right upper side : level-up label
        //表示期間中、ジャンプアニメーション
        viewLevelUp = [CreateComponentClass
                              createView:CGRectMake(0, 0, 100, 70)];
        viewLevelUp.center = CGPointMake(self.bounds.size.width-viewLevelUp.frame.size.width,
                                         viewLevelUp.frame.size.height/2+10);
        [viewLevelUp setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.5 alpha:0.5]];
        [self addSubview:viewLevelUp];
        [self animViewLevelUp:9 originalPoint:viewLevelUp.center];
        
        
        /*
         *タイトル：Congraturation!
         */
        tvTitle = [CreateComponentClass
                   createTextView:CGRectMake(0, 0,
                                             self.bounds.size.width*4/5,100)
                   text:@"Congratulation!\nlevel-up!"
                   font:@"AmericanTypewriter-Bold"
                   size:30
                   textColor:[UIColor whiteColor]
                   backColor:[UIColor clearColor]
                   isEditable:NO];
        tvTitle.textAlignment = NSTextAlignmentCenter;
        tvTitle.center = CGPointMake(self.bounds.size.width/2,
                                     180);
        [self addSubview:tvTitle];
        
        
        
        /*
         *center part : now-level => next-level
         *small-now-level, big-next-level
         *フレームの中にビームとレベルの数字を表示
        */
        
        //まず枠
        viewBeforeLevel = [CreateComponentClass
                           createView:CGRectMake(0, 0, 100, 90)];
        [self addSubview:viewBeforeLevel];
        viewBeforeLevel.center = CGPointMake(self.bounds.size.width/2 - viewBeforeLevel.bounds.size.width/2 - 10,
                                             self.bounds.size.height/2);
        
        viewAfterLevel = [CreateComponentClass
                          createView:viewBeforeLevel.bounds];
        [self addSubview:viewAfterLevel];
        viewAfterLevel.center = CGPointMake(self.bounds.size.width/2 + viewAfterLevel.bounds.size.width/2 + 10,
                                            self.bounds.size.height/2);
        
        
        //次にimageView:beam描画
        ivBeforeBeam = [CreateComponentClass
                        createImageView:viewBeforeLevel.bounds
                        image:[NSString stringWithFormat:@"%02d.png", blv]];
        ivBeforeBeam.center = CGPointMake(viewBeforeLevel.bounds.size.width/2,
                                          viewBeforeLevel.bounds.size.height/2);
        [viewBeforeLevel addSubview:ivBeforeBeam];
        
        ivAfterBeam = [CreateComponentClass
                       createImageView:viewAfterLevel.bounds
                       image:[NSString stringWithFormat:@"%02d.png", alv]];
        ivAfterBeam.center = CGPointMake(viewAfterLevel.bounds.size.width/2,
                                         viewAfterLevel.bounds.size.height/2);
        [viewAfterLevel addSubview:ivAfterBeam];
        
        //最後に数字
        tvBeforeLevel = [CreateComponentClass
                         createTextView:ivBeforeBeam.bounds
                         text:[NSString stringWithFormat:@"%d", blv]
                         font:@"AmericanTypewriter-Bold"
                         size:35
                         textColor:[UIColor whiteColor]
                         backColor:[UIColor clearColor]
                         isEditable:NO];
        tvBeforeLevel.textAlignment = NSTextAlignmentCenter;
        tvBeforeLevel.center = CGPointMake(viewBeforeLevel.bounds.size.width/2,
                                           viewBeforeLevel.bounds.size.height);
        [viewBeforeLevel addSubview:tvBeforeLevel];
        
        tvAfterLevel = [CreateComponentClass
                        createTextView:ivAfterBeam.bounds
                        text:[NSString stringWithFormat:@"%d", alv]
                        font:@"AmericanTypewriter-Bold"
                        size:35
                        textColor:[UIColor whiteColor]
                        backColor:[UIColor clearColor]
                        isEditable:NO];
        tvAfterLevel.textAlignment = NSTextAlignmentCenter;
        tvAfterLevel.center = CGPointMake(viewAfterLevel.bounds.size.width/2,
                                          viewAfterLevel.bounds.size.height);
        [viewAfterLevel addSubview:tvAfterLevel];
        
        NSLog(@"b = %@ \n a = %@", tvBeforeLevel, tvAfterLevel);
        
        
        
        
        /*
         *effect looks like fire flower
         */
        ViewFireWorks *viewFire = [[ViewFireWorks alloc]
                                   initWithFrame:CGRectMake(0, 0, 20, 20)];
        [self addSubview: viewFire];
        
        for(int i = 0; i < 10;i++){
            viewKiraParticle = [[KiraParticleView alloc]
                                initWithFrame:CGRectMake(i * 30, tvTitle.frame.origin.y + tvTitle.frame.size.height/2,
                                                         50, 50)
                                particleType:ParticleTypeMoving];
            [self addSubview:viewKiraParticle];
        }
        
        //whole-frame-effect:kirakira=3x4interval
        for(int i = 0; i < 3;i++){//width
            for(int j = 0 ; j < 4 ; j++){//height
                viewKiraParticle = [[KiraParticleView alloc]
                                    initWithFrame:CGRectMake((i * 100) % (int)self.bounds.size.width,
                                                             (j * 120) % (int)self.bounds.size.height, 50, 50)
                                    particleType:ParticleTypeKilled];
                [self addSubview:viewKiraParticle];
            }
        }
        
        
        
        //if tapped, remove.
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(tappedView)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

-(void)tappedView{
    NSLog(@"tapped me");
    [self removeFromSuperview];
}

-(void)animViewLevelUp:(int)count originalPoint:(CGPoint)point{//ponpon
    float jumpHeight = (count%2==0)?10:-10;
    [UIView animateWithDuration:0.2f//(float)count/10//((float)10 - count)/10
                     animations:^{
                         viewLevelUp.center = CGPointMake(viewLevelUp.center.x,
                                                          viewLevelUp.center.y + jumpHeight);
                     }
                     completion:^(BOOL finished){
                         if(count == 0){
                             viewLevelUp.center = point;
                         }
                         
                         [self animViewLevelUp:(count > 0)?(count-1):9 originalPoint:point];//10,9,...,1,0,10,9,...
                     }];
}
@end
