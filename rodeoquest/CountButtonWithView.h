//
//  CountButtonWithView.h
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/06.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuButtonWithView.h"
typedef NS_ENUM(NSInteger, ButtonCountImageType) {
    ButtonCountImageTypeSensitivity
};

@interface CountButtonWithView : UIImageView{
    float touchedX;
    float touchedY;
    UIImageView *imgAdd;
    UIImageView *imgLight;
    Boolean isPressed;
    int countPressed;
    int MAXCOUNT;
    CGRect originalFrame;
    UIControl *mask;
    id target;
    //    selector *selector;
    NSString *strMethod;
    int tag_img;
    
}


@property(nonatomic) ButtonCountImageType buttonCountType;
@property(nonatomic) ButtonMenuBackType buttonMenuBackType;
-(id)initWithFrame:(CGRect)frame
          backType:(ButtonMenuBackType)_backType
         imageType:(ButtonCountImageType)_imageType
            target:(id)target
          selector:(NSString *)selName
               tag:(int)_tag;


@end
