//
//  ScrollViewForItemList.m
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/17.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "ScrollViewForItemList.h"

@implementation ScrollViewForItemList
@synthesize direction = direction_;
@synthesize beganPoint = beganPoint_;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
// スクロール管理の初期化
//- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView {
//    self.direction = kILScrollViewDirectionNone;
//    // スクロールしはじめのoffset管理
//    self.beganPoint = [scrollView contentOffset];
//}

// スクロール位置の矯正
- (void)scrollViewDidScroll:(UIScrollView*)scrollView {
    
    CGPoint origin = [scrollView contentOffset];
    [scrollView setContentOffset:CGPointMake(0.0, origin.y)];
    NSLog(@"%f,  %f", origin.x ,origin.y);

//    CGPoint currentPoint = [scrollView contentOffset];
//    if ( kILScrollViewDirectionNone == self.direction ) {
//        // スクロール方向の決定
//        if ( !CGPointEqualToPoint( currentPoint, self.beganPoint ) ) {
//            CGFloat moveHorizontal = ABS( currentPoint.x - self.beganPoint.x );
//            CGFloat moveVertical = ABS( currentPoint.y - self.beganPoint.y );
//            if ( moveHorizontal < moveVertical ) {
//                NSLog( @"direction = Vertical" );
//                self.direction = kILScrollViewDirectionVertical;
//            } else {
//                NSLog( @"direction = Horizontal" );
//                self.direction = kILScrollViewDirectionHorizontal;
//            }
//        }
//    }
//    if ( kILScrollViewDirectionVertical == self.direction ) {
//        currentPoint.x = self.beganPoint.x;
//        [scrollView setContentOffset:currentPoint];
//    } else if ( kILScrollViewDirectionHorizontal == self.direction ) {
//        currentPoint.y = self.beganPoint.y;
//        [scrollView setContentOffset:currentPoint];
//    }
}



@end
