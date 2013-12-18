//
//  ScrollViewForItemList.h
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/17.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

typedef enum
{
    kILScrollViewDirectionNone = 0,
    kILScrollViewDirectionHorizontal = 1,
    kILScrollViewDirectionVertical = 2,
} ILScrollViewDirection;


#import <UIKit/UIKit.h>

@interface ScrollViewForItemList : UIScrollView

@property (nonatomic, assign) ILScrollViewDirection direction;
@property (nonatomic, assign) CGPoint beganPoint;


@end
