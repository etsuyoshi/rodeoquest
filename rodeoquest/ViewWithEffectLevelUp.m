//
//  ViewWithEffectLevelUp.m
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/12.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "ViewWithEffectLevelUp.h"
#import "KiraParticleView.h"
#import "CreateComponentClass.h"

@implementation ViewWithEffectLevelUp
UIView *viewLevelUp;
UIView *viewBeforeLevel;
UIView *viewAfterLevel;
UIImageView *viewPaper;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setBackgroundColor:[UIColor clearColor]];
        
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
        
        
        //center part : now-level => next-level
        //small-now-level, big-next-level
        //フレームの中にビームとレベルの数字を表示
//        view
        
        
        
        //effect looks like fire flower
        
        
    }
    return self;
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
