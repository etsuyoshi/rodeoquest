//
//  CreateComponentClass.h
//  Shooting6
//
//  Created by 遠藤 豪 on 13/10/15.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoolButton.h"
#import "MenuButtonWithView.h"
#import "SwitchButtonWithView.h"
#import "CountButtonWithView.h"
#import "ScrollViewForItemList.h"
#import "TextViewForItemList.h"

//typedef NS_ENUM(NSInteger, Type) {
//    ProductTypeCoin6
//};


@interface CreateComponentClass : NSObject{
//    NSDictionary *dictWeapon;
//    NSArray *arrayBowAsKeys;
//    NSArray *arrayBeamAsValues;
}

+(UITextView *)createTextView:(CGRect)rect
                       text:(NSString *)text;
+(UITextView *)createTextView:(CGRect)rect
                         text:(NSString *)text
                         font:(NSString *)font
                         size:(int)size
                    textColor:(UIColor *)textColor
                    backColor:(UIColor *)backColor
                   isEditable:(Boolean)isEditable;



+(UIView *)createView;
+(UIView *)createView:(CGRect)rect;
+(UIView *)createView:(CGRect)rect
                color:(UIColor*)color
         cornerRaidus:(float)cornerRadius
          borderColor:(UIColor*)borderColor
          borderWidth:(float)borderWidth;
//フレームなしでタップイベント(フレームありタップイベント付きは必要に応じて作る予定)
+(UIView *)createViewNoFrame:(CGRect)rect
                       color:(UIColor *)color
                         tag:(int)tag
                      target:(id)target
                    selector:(NSString *)selName;
+(UIView *)createViewWithFrame:(CGRect)rect
                         color:(UIColor *)color
                           tag:(int)tag
                        target:(id)target
                      selector:(NSString *)selName;

//タッチイベントを付けたimageview:http://php6.jp/iphone/2011/11/11/uilabel%E3%82%84uiimageview%E3%81%8C%E5%BF%9C%E7%AD%94%E3%81%97%E3%81%AA%E3%81%84/
+(UIImageView *)createImageView:(CGRect)rect
                          image:(NSString *)image
                            tag:(int)tag
                         target:(id)target
                       selector:(NSString *)selName;

+(UIImageView *)createImageView:(CGRect)rect
                          image:(NSString *)image;
+(UIImageView *)createSwitchButton:(CGRect)rect
                          backType:(ButtonMenuBackType)_backType
                         imageType:(ButtonSwitchImageType)_imageType
                               tag:(int)tag
                            target:(id)target
                          selector:(NSString *)selName;
+(UIImageView *)createCountButton:(CGRect)rect
                         backType:(ButtonMenuBackType)_backType
                        imageType:(ButtonCountImageType)_imageType
                              tag:(int)tag
                           target:(id)target
                         selector:(NSString *)selName;
+(UIButton *)createButton:(id)target
                 selector:(NSString *)selName;
+(UIButton *)createButtonWithType:(ButtonMenuBackType)type
                             rect:(CGRect)rect
                            image:(NSString *)image
                           target:(id)target
                         selector:(NSString *)selName;

+(UIButton *)createQBButton:(ButtonMenuBackType)type
                     rect:(CGRect)rect
                    image:(NSString *)image
                      title:(NSString *)title
                   target:(id)target
                 selector:(NSString *)selName;


//horizon
+(UIView *)createSlideShowHorizon:(CGRect)rect
                 imageFile:(NSArray *)fileArray
                    target:(id)target
                 selector1:(NSString *)selector1
                 selector2:(NSString *)selector2;
//vertical
+(UIView *)createSlideShowVertical:(CGRect)rect
                         imageFile:(NSArray *)imageArray
                            target:(id)target
                         selector1:(NSString *)selector1
                         selector2:(NSString *)selector2;
//vertical for all display
+(UIView *)createSlideShowVerticalAll:(CGRect)rect
                         imageFile:(NSArray *)imageArray
                            target:(id)target
                         selector1:(NSString *)selector1
                         selector2:(NSString *)selector2;

+(UIImageView *)createMenuButton:(ButtonMenuBackType)_backType
                       imageType:(ButtonMenuImageType)_imageType
                            rect:(CGRect)rect
                          target:(id)target
                        selector:(NSString *)selector;
+(UIImageView *)createMenuButton:(ButtonMenuBackType)_backType
                       imageType:(ButtonMenuImageType)_imageType
                            rect:(CGRect)rect
                          target:(id)target
                        selector:(NSString *)selector
                             tag:(int)_tag;
+(UIButton *)createGradButton;
+(CoolButton *)createCoolButton:(CGRect)_rect
                       text:(NSString *)_text
                          hue:(float)_hue
                   saturation:(float)_saturation
                   brightness:(float)_brightness
                       target:(id)_target
                     selector:(NSString *)_selector
                          tag:(int)_tag;

+(UIView *)createAlertView:(CGRect)_rectFrame
                dialogRect:(CGRect)_rectDialog
                     title:(NSString *)_title
                   message:(NSString *)_message
                     onYes:(void (^)(void))onYes
                      onNo:(void (^)(void))onNo;

+(UIView *)createAlertView:(CGRect)_rectFrame
                dialogRect:(CGRect)_rectDialog
                     title:(NSString *)_title
                   message:(NSString *)_message
                  titleYes:(NSString *)_titleYes
                   titleNo:(NSString *)_titleNo
                     onYes:(void (^)(void))onYes
                      onNo:(void (^)(void))onNo;
@end
