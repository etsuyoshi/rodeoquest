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
UIView *uvOnScroll;
NSString *strImgCurrency;
UIView *cashView;
NSString *strSmallIcon;
NSString *nameCurrency;

@interface ItemListViewController : UIViewController{
    BackGroundClass2 *background;
    NSMutableArray *arrIv;
    NSMutableArray *arrIv2;
    NSMutableArray *arrIvType;
    NSMutableArray *arrTv;
    NSMutableArray *arrCost;
    NSMutableArray *arrTitle;
    NSMutableArray *itemList;
    NSMutableArray *arrBtnBuy;//list of UIButton
    
    
    
    
    //frame-size
    int itemFrameWidth;
    int itemFrameHeight;
    int itemFrameInitX;
    int itemFrameInitY;
    int itemFrameInterval;
    int smallIconHeight;
    
    
    //icon-size
    int imageFrameWidth;
    int imageFrameHeight;
    int imageFrameInitX;
    int imageFrameInitY;
    int imageFrameInterval;
    
    //button-size
    int buttonFrameWidth;
    int buttonFrameHeight;
    
    //text(view)-size
    int textViewInitX;
    int textViewInitY;
    int textViewHeight;
    int textViewWidth;
    
    //貨幣ビュー
    int cashFrameWidth;
    int cashFrameHeight;
    int cashFrameInitX;
    int cashFrameInitY;
    
    //スクロールビューを載せるスーバービューの位置
    int init_y;
    int init_x;
    
//    void (^actYesForCoinShort)(void);
//    void (^actNoForCoinShort)(void);
//    NSMutableArray *arrBtn;
}


//in order to use :subclass method
-(void)buyBtnPressed:(id)sender;
-(void)oscillateTextViewGold:(int)count;
@end
