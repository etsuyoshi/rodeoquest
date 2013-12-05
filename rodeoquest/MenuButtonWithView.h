//
//  MenuButtonWithView.h
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/04.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, MenuBtnType) {
    MenuBtnTypeWeapon,
    MenuBtnTypeSet,
    MenuBtnTypeInn
};

@interface MenuButtonWithView : UIImageView{
    float touchedX;
    float touchedY;
    UIImageView *imgAdd;
    UIImageView *imgLight;
    Boolean isPressed;
    CGRect originalFrame;
    UIControl *mask;
    id target;
//    selector *selector;
    NSString *strMethod;
}


@property(nonatomic) MenuBtnType menuBtnType;
-(id)initWithFrame:(CGRect)frame
              type:(MenuBtnType)_type
            target:(id)target
          selector:(NSString *)selName;
@end
