//
//  ViewExplode.h
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/29.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ExplodeType) {//order with difficulty of get down
    ExplodeType1,
    ExplodeType2
};


@interface ViewExplode : UIView
@property(nonatomic) ExplodeType explodeType;
-(id)initWithFrame:(CGRect)frame type:(ExplodeType)_explodeType;
@end
