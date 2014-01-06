//
//  ViewKira.h
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/26.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, KiraType) {//order with difficulty of get down
    KiraTypeYellow,
    KiraTypeGreen,
    KiraTypeBlue,
    KiraTypePurple,
    KiraTypeRed,
    KiraTypeWhite
};


@interface ViewKira : UIView
@property(nonatomic) KiraType kiraType;
-(id)initWithFrame:(CGRect)frame type:(KiraType)_kiraType;
-(id)initWithFrame:(CGRect)frame type:(KiraType)_kiraType image:(NSString *)_strImg;
@end
