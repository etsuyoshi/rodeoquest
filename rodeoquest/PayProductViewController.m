//
//  PayProductViewController.m
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/10.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "PayProductViewController.h"
#import "BackGroundClass2.h"
#import "CreateComponentClass.h"

#define WIDTH_FRAME_SUPER 290
#define HEIGHT_FRAME_SUPER 350
#define WIDTH_FRAME_PRODUCT 80
#define HEIGHT_FRAME_PRODUCT 100
#define MARGIN_FRAME_PRODUCT 13
#define SIZE_BUTTON_PRODUCT 70

@interface PayProductViewController ()

@end

@implementation PayProductViewController
UIActivityIndicatorView *activityIndicator;
BackGroundClass2 *background;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.center = CGPointMake(self.view.bounds.size.width/2,
                                               self.view.bounds.size.height/2);
        [self.view addSubview:activityIndicator];
        
        //動画背景を
        background = [[BackGroundClass2 alloc] init:WorldTypeUniverse1
                                              width:self.view.bounds.size.width
                                             height:self.view.bounds.size.height
                                               secs:5.0f];
        
        [self.view addSubview:[background getImageView1]];
        [self.view addSubview:[background getImageView2]];
        [self.view sendSubviewToBack:[background getImageView1]];
        [self.view sendSubviewToBack:[background getImageView2]];
        //        [self.view bringSubviewToFront:[background getImageView1]];
        //        [self.view bringSubviewToFront:[background getImageView2]];
        
        
        [background startAnimation];

        
        
        
        //何もしないUIViewをaddする:他のコンポーネントをこの上に置く(閉じるアクションをつけたuiviewの上にaddすると他のコンポーネントに対するアクションにも閉じるアクションが適用されてしまう)
        UIView *viewSuperInPay = [CreateComponentClass createViewNoFrame:self.view.bounds
                                                                   color:[UIColor clearColor]
                                                                     tag:0
                                                                  target:Nil
                                                                selector:nil];
        [self.view addSubview:viewSuperInPay];
        
        //その上に閉じるアクションをつけたuiviewをaddする(この上に他のコンポーネントを置いてはだめ)
        UIView *viewSuper = [CreateComponentClass createButtonWithType:ButtonMenuBackTypeDefault
                                                                  rect:self.view.bounds
                                                                 image:nil
                                                                target:self
                                                              selector:@"closeViewCon:"];//このviewControllerだけ閉じる
        [viewSuper setBackgroundColor:[UIColor colorWithRed:0.0f green:0 blue:0 alpha:0.7f]];
        [viewSuperInPay addSubview:viewSuper];
        
        
        
        UIView *viewFrame = [CreateComponentClass createView:CGRectMake(self.view.bounds.size.width/2 - WIDTH_FRAME_SUPER/2,
                                                                        self.view.bounds.size.height/2 - HEIGHT_FRAME_SUPER/2,
                                                                        WIDTH_FRAME_SUPER,
                                                                        HEIGHT_FRAME_SUPER)];
        [viewFrame setBackgroundColor:[UIColor colorWithRed:0.1f green:0.6f blue:0.1f alpha:0.6f]];//どちらでも良い
        [viewSuperInPay addSubview:viewFrame];
        
        
        CGRect rectFrame;
        CGRect rectButton;
        UIView *eachFrame;
        UIImageView *payButtonView;//
        //viewFrameに2x3行列のframeを置いて、更にそれぞれにbuttonを置く
        int numOfRow = 2;
        int numOfCol = 3;
        for(int row = 0;row < numOfRow ;row++){
            for(int col = 0;col < numOfCol ; col++){
                rectFrame = CGRectMake(MARGIN_FRAME_PRODUCT + col * (WIDTH_FRAME_PRODUCT + MARGIN_FRAME_PRODUCT),
                                       MARGIN_FRAME_PRODUCT + row * (HEIGHT_FRAME_PRODUCT + MARGIN_FRAME_PRODUCT),
                                       WIDTH_FRAME_PRODUCT, HEIGHT_FRAME_PRODUCT);
                rectButton = CGRectMake(MARGIN_FRAME_PRODUCT/2, MARGIN_FRAME_PRODUCT/2,
                                        SIZE_BUTTON_PRODUCT, SIZE_BUTTON_PRODUCT);
                eachFrame = [CreateComponentClass createView:rectFrame];
                payButtonView = [CreateComponentClass createMenuButton:(ButtonMenuBackType)ButtonMenuBackTypeGreen
                                                             imageType:(ButtonMenuImageType)ButtonMenuImageTypeStart
                                                                  rect:(CGRect)rectButton
                                                                target:(id)self
                                                              selector:(NSString *)@"pushedButton:"
                                                                   tag:ButtonMenuImageTypeStart];
                [eachFrame addSubview:payButtonView];
                [viewFrame addSubview:eachFrame];
            }
        }
        
        
    }
    
    return self;
}

-(void)closeViewCon:(id)sender{
    
    [self dismissViewControllerAnimated:NO completion:nil];//itemSelectVCのpresentViewControllerからの場合
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ありがとうございます。"
                                                    message:@"購入が完了しました"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil,
                          nil];
    [alert show];
    
    
    //コインを追加する等の処理を実行
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
        NSLog(@"failed transaction");
        
        // Display an error here.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchase Unsuccessful"
                                                        message:[NSString stringWithFormat:@"Your purchase failed. reason:%@",[transaction.error description]]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    // Finally, remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}



@end
