//
//  PayProductViewController.h
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/10.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "AttrClass.h"
#import "BackGroundClass2.h"
#import "CreateComponentClass.h"


typedef NS_ENUM(NSInteger, RubyType) {
    RubyType1,
    RubyType2,
    RubyType3,
    RubyType4,
    RubyType5,
    RubyType6
};
//サブクラスで変更するためグローバル
NSString *strImgCurrency;//yen-or-ruby:支払うもののイメージ
NSString *strImgAcq;//ruby-or-coin:得るもののイメージ
NSArray *arrAcquired;
NSArray *arrPrice;
NSArray *arrTypeBack;
NSArray *arrTypeImage;//ボタンアイコンタイプ
NSArray *arrProductType;
UIImageView *viewYenImage;
UIView *rubyView;//現在保有ルビーを表示する
UILabel *lblRubyAmount;

UIView *viewDialog;
AttrClass *attr;

@interface PayProductViewController : UIViewController<SKProductsRequestDelegate,
SKPaymentTransactionObserver>{
    
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction;
- (void) restoreTransaction: (SKPaymentTransaction *)transaction;
- (void) failedTransaction: (SKPaymentTransaction *)transaction;


-(void)showDialog;

@end
