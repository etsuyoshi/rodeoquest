//
//  PayProductViewController.h
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/10.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

typedef NS_ENUM(NSInteger, ProductType) {
    ProductTypeCoin1,
    ProductTypeCoin2,
    ProductTypeCoin3,
    ProductTypeCoin4,
    ProductTypeCoin5,
    ProductTypeCoin6
};

@interface PayProductViewController : UIViewController<SKProductsRequestDelegate,
SKPaymentTransactionObserver>{
    
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction;
- (void) restoreTransaction: (SKPaymentTransaction *)transaction;
- (void) failedTransaction: (SKPaymentTransaction *)transaction;

@end
