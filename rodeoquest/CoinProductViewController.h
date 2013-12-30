//
//  CoinProductViewController.h
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/24.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "PayProductViewController.h"
typedef NS_ENUM(NSInteger, CoinType) {
    CoinType1,
    CoinType2,
    CoinType3,
    CoinType4,
    CoinType5,
    CoinType6
};
UILabel *myLblRubyAmount;
UIView *cashView;
UILabel *lblCashAmount;

@interface CoinProductViewController : PayProductViewController

@end
