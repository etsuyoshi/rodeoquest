//
//  ItemListViewController.h
//  Shooting6
//
//  Created by 遠藤 豪 on 13/10/17.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackGroundClass2.h"
#import "CreateComponentClass.h"
#import "AttrClass.h"


//サブクラスでボタン追加するときに位置調整のために使用するのでグローバルに。
UITextView *tvGoldAmount;

@interface ItemListViewController : UIViewController{
    BackGroundClass2 *background;
    NSMutableArray *arrIv;
    NSMutableArray *arrTv;
    NSMutableArray *arrCost;
    NSMutableArray *arrTitle;
    NSMutableArray *itemList;
    NSMutableArray *arrBtnBuy;//list of UIButton
    
    
//    void (^actYesForCoinShort)(void);
//    void (^actNoForCoinShort)(void);
//    NSMutableArray *arrBtn;
}

-(void)buyBtnPressed:(id)sender;
@end
