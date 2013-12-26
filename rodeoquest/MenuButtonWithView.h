//
//  MenuButtonWithView.h
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/04.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ButtonMenuImageType) {
    ButtonMenuImageTypeWeapon,// at menu
    ButtonMenuImageTypeDefense,// at menu
    ButtonMenuImageTypeItem,// at menu
    ButtonMenuImageTypeInn,// at menu
    ButtonMenuImageTypeSet,// at menu
    ButtonMenuImageTypeCoin,// at menu
    ButtonMenuImageTypeWpnUp,// at menu
    ButtonMenuImageTypeStart,// at menu
    ButtonMenuImageTypeDemand,//at menu
    ButtonMenuImageTypeBuyCoin0,//at CoinProduct
    ButtonMenuImageTypeBuyCoin1,//at CoinProduct
    ButtonMenuImageTypeBuyCoin2,//at CoinProduct
    ButtonMenuImageTypeBuyCoin3,//at CoinProduct
    ButtonMenuImageTypeBuyCoin4,//at CoinProduct
    ButtonMenuImageTypeBuyCoin5,//at CoinProduct
    ButtonMenuImageTypeBuyProduct0,//at buyItemMenu
    ButtonMenuImageTypeBuyProduct1,//at buyItemMenu
    ButtonMenuImageTypeBuyProduct2,//at buyItemMenu
    ButtonMenuImageTypeBuyProduct3,//at buyItemMenu
    ButtonMenuImageTypeBuyProduct4,//at buyItemMenu
    ButtonMenuImageTypeBuyProduct5//at buyItemMenu
    
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
