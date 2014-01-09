//
//  ItemListViewController.h
//  Shooting6
//
//  Created by 遠藤 豪 on 13/10/17.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackGroundClass2.h"
#import "CoinProductViewController.h"
#import "PayProductViewController.h"
#import "CreateComponentClass.h"
#import "AttrClass.h"


//サブクラスでボタン追加するときに位置調整のために使用するのでグローバルに。
UITextView *tvGoldAmount;
UIButton *closeBtn;
UIView *viewForCoinShort;//コインがショートしている場合のダイアログビュー
UIView *viewWantBuy;//購入するか否か確認するダイアログビュー
NSString *strImgUnit;
UIView *cashView;

NSString *nameCurrency;

@interface ItemListViewController : UIViewController{
    BackGroundClass2 *background;
    NSMutableArray *arrIv;
    NSMutableArray *arrIv2;
    NSMutableArray *arrTv;
    NSMutableArray *arrCost;
    NSMutableArray *arrTitle;
    NSMutableArray *itemList;
    NSMutableArray *arrBtnBuy;//list of UIButton
    
    
//    void (^actYesForCoinShort)(void);
//    void (^actNoForCoinShort)(void);
//    NSMutableArray *arrBtn;
}


//in order to use :subclass method
-(void)buyBtnPressed:(id)sender;
-(void)oscillateTextViewGold:(int)count;
@end
