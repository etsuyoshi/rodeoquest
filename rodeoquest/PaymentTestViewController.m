//
//  PaymentTestViewController.m
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/09.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "PaymentTestViewController.h"

@interface PaymentTestViewController ()

@end

@implementation PaymentTestViewController
UIActivityIndicatorView *activityIndicator;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //    activityIndicator.frame = CGRectMake(0, 0, 100, 100);
    activityIndicator.center = CGPointMake(self.view.bounds.size.width/2,
                                           self.view.bounds.size.height/2);
    [self.view addSubview:activityIndicator];
    
    //    UIButton *btProductRequest = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *btProductRequest = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 70)];
    btProductRequest.center = CGPointMake(self.view.bounds.size.width/2, 50);
    [btProductRequest setBackgroundColor:[UIColor grayColor]];
    [btProductRequest addTarget:self
                         action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btProductRequest];
}
-(void)showDialog{
    NSString *title = @"ありがとうございます。";
    NSString *msg = @"購入が完了しました。";
    UIAlertView *alert =[[UIAlertView alloc]
                         initWithTitle:title
                         message:msg
                         delegate:self
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
    [alert show];
    
}
-(void)buttonPressed:(id)sender{
    UIButton *bt = (UIButton *)sender;
    NSLog(@"bt=%@", bt);
    
    if (![SKPaymentQueue canMakePayments]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                        message:@"アプリ内課金が制限されています。"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }else{
        NSLog(@"アプリ内課金制限なし：クリアー");
        SKProductsRequest *request= [[SKProductsRequest alloc]
                                     initWithProductIdentifiers: [NSSet setWithObject: @"coin1.1.1"]];
        request.delegate = self;
        [request start];
        
        [activityIndicator startAnimating];
        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    
    if([response.products count] == 0){
        NSLog(@"アイテムが存在しません。");
        [activityIndicator stopAnimating];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                        message:@"アイテムが存在しません"
                                                       delegate:Nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }else if ([response.invalidProductIdentifiers count] > 0) {//無効アイテムがないかCheck
        NSLog(@"%d個の無効なアイテムが取得されました", [response.invalidProductIdentifiers count]);
        [activityIndicator stopAnimating];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                        message:@"アイテムIDが不正です。"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    // 購入処理開始
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    for (SKProduct *product in response.products) {
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@"Transaction Completed");
    // You can create a method to record the transaction.
    // [self recordTransaction: transaction];
    
    // You should make the update to your app based on what was purchased and inform user.
    // [self provideContent: transaction.payment.productIdentifier];
    
    // Finally, remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@"Transaction Restored");
    // You can create a method to record the transaction.
    // [self recordTransaction: transaction];
    
    // You should make the update to your app based on what was purchased and inform user.
    // [self provideContent: transaction.payment.productIdentifier];
    
    // Finally, remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
    [activityIndicator stopAnimating];
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // Display an error here.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchase Unsuccessful"
                                                        message:@"Your purchase failed. Please try again."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    // Finally, remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}



@end
