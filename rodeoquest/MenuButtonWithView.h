//
//  MenuButtonWithView.h
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/04.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ButtonMenuImageType) {
    ButtonMenuImageTypeWeapon,
    ButtonMenuImageTypeDefense,
    ButtonMenuImageTypeItem,
    ButtonMenuImageTypeInn,
    ButtonMenuImageTypeSet,
    ButtonMenuImageTypeCoin,
    ButtonMenuImageTypeStart
    
    
};

typedef NS_ENUM(NSInteger, ButtonMenuBackType) {
    ButtonMenuBackTypeDefault = 0,          // default
    ButtonMenuBackTypeOrange,
    ButtonMenuBackTypeBlue,
    ButtonMenuBackTypeGreen
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
    int tag_img;
}


@property(nonatomic) ButtonMenuImageType buttonMenuImageType;
@property(nonatomic) ButtonMenuBackType buttonMenuBackType;
-(id)initWithFrame:(CGRect)frame
          backType:(ButtonMenuBackType)_backType
         imageType:(ButtonMenuImageType)_imageType
            target:(id)target
          selector:(NSString *)selName
               tag:(int)_tag;

@end
