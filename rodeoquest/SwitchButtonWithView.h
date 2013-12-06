//
//  SwitchButtonWithView.h
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/06.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuButtonWithView.h"

typedef NS_ENUM(NSInteger, ButtonSwitchImageType) {
    ButtonSwitchImageTypeSpeaker,
    ButtonSwitchImageTypeBGM
};

@interface SwitchButtonWithView : UIImageView{
    Boolean on_off;
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


@property(nonatomic) ButtonSwitchImageType buttonSwitchType;
@property(nonatomic) ButtonMenuBackType buttonMenuBackType;
-(id)initWithFrame:(CGRect)frame
          backType:(ButtonMenuBackType)_backType
         imageType:(ButtonSwitchImageType)_imageType
            target:(id)target
          selector:(NSString *)selName
               tag:(int)_tag;

@end
