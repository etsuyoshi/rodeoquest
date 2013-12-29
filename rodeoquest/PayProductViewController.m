//
//  PayProductViewController.m
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/10.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "PayProductViewController.h"

#define WIDTH_FRAME_SUPER 290
#define HEIGHT_FRAME_SUPER 300
#define WIDTH_FRAME_PRODUCT 80
#define HEIGHT_FRAME_PRODUCT 100
#define MARGIN_FRAME_PRODUCT 13
#define SIZE_BUTTON_PRODUCT 70

@interface PayProductViewController ()

@end

@implementation PayProductViewController
UIActivityIndicatorView *activityIndicator;
BackGroundClass2 *background;
NSArray *arrProductId;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //arrProductIdはrubyX.X.Xに変更したいがitunes connect側で実行する必要がある
        arrProductId = [NSArray arrayWithObjects:
                        @"coin1.1.1",
                        @"coin2.1.1",
                        @"coin3.1.1",
                        @"coin4.1.1",
                        @"coin5.1.1",
                        @"coin6.1.1",
                        nil];
        arrAcquired = [NSArray arrayWithObjects:
                       @"16",//number of ruby when user buy this item
                       @"48",
                       @"100",
                       @"203",
                       @"339",
                       @"715",
                       nil];
        
        //ボタン押下時の判定キー
        arrProductType = [NSArray arrayWithObjects:
                          [NSArray arrayWithObjects:
                           [NSNumber numberWithInt:RubyType1],
                           [NSNumber numberWithInt:RubyType2],
                           [NSNumber numberWithInt:RubyType3],
                           nil],
                          [NSArray arrayWithObjects:
                           [NSNumber numberWithInt:RubyType4],
                           [NSNumber numberWithInt:RubyType5],
                           [NSNumber numberWithInt:RubyType6],
                           nil],
                          nil];
        
        
        arrTypeImage = [NSArray arrayWithObjects:
                        [NSArray arrayWithObjects:
                         [NSNumber numberWithInt:ButtonMenuImageTypeBuyProduct0],
                         [NSNumber numberWithInt:ButtonMenuImageTypeBuyProduct1],
                         [NSNumber numberWithInt:ButtonMenuImageTypeBuyProduct2],
                         nil],
                        [NSArray arrayWithObjects:
                         [NSNumber numberWithInt:ButtonMenuImageTypeBuyProduct3],
                         [NSNumber numberWithInt:ButtonMenuImageTypeBuyProduct4],
                         [NSNumber numberWithInt:ButtonMenuImageTypeBuyProduct5],
                         nil],
                        nil];
        //price
        arrPrice = [NSArray arrayWithObjects:
                    [NSArray arrayWithObjects:
                     @"200",//yen
                     @"500",
                     @"1200",
                     nil],
                    [NSArray arrayWithObjects:
                     @"2500",
                     @"4100",
                     @"6300",
                     nil],
                    nil];
        
        
        strImgUnit = @"yen_g.png";
        
        attr = [[AttrClass alloc]init];
        
    }
    
    return self;
}

//-(void)closeViewCon:(id)sender{
//    NSLog(@"close Payment View controller");
//    [self dismissViewControllerAnimated:NO completion:nil];//itemSelectVCのpresentViewControllerからの場合
//}
-(void)closeViewCon{
    
    NSLog(@"close Payment View controller");
    [self dismissViewControllerAnimated:NO completion:nil];//itemSelectVCのpresentViewControllerからの場合
    
}

-(void)pushedButton:(NSNumber *)num{
    NSLog(@"pushed button : tag = %d", num.integerValue);
    
    
    if (![SKPaymentQueue canMakePayments]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                        message:@"端末側でアプリ内課金が制限されています。設定を確認して下さい。"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"閉じる", nil];
        [alert show];
        return;
    }else{
        NSLog(@"アプリ内課金制限なし：クリアー");
        SKProductsRequest *request;
        switch((RubyType)(num.integerValue)){
            case RubyType1:{
                
                request= [[SKProductsRequest alloc]
                          initWithProductIdentifiers: [NSSet setWithObject: [arrProductId objectAtIndex:RubyType1]]];
                break;
            }
            case RubyType2:{
                request= [[SKProductsRequest alloc]
                          initWithProductIdentifiers: [NSSet setWithObject: [arrProductId objectAtIndex:RubyType2]]];
                break;
            }
            case RubyType3:{
                request= [[SKProductsRequest alloc]
                          initWithProductIdentifiers: [NSSet setWithObject: [arrProductId objectAtIndex:RubyType3]]];
                break;
            }
            case RubyType4:{
                request= [[SKProductsRequest alloc]
                          initWithProductIdentifiers: [NSSet setWithObject: [arrProductId objectAtIndex:RubyType4]]];
                break;
            }
            case RubyType5:{
                request= [[SKProductsRequest alloc]
                          initWithProductIdentifiers: [NSSet setWithObject: [arrProductId objectAtIndex:RubyType5]]];
                break;
            }
            case RubyType6:{
                request= [[SKProductsRequest alloc]
                          initWithProductIdentifiers: [NSSet setWithObject: [arrProductId objectAtIndex:RubyType6]]];
                break;
            }
        }
        request.delegate = self;
        [request start];
        
        [activityIndicator startAnimating];
        
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    
    //ruby　frame
    int cashFrameWidth = 170;
    int cashFrameHeight = 50;
    int cashFrameInitX = 145;
    int cashFrameInitY = 40;
    
    //remove cashView defined in superclass
    [cashView removeFromSuperview];
    cashView = [CreateComponentClass createView:CGRectMake(cashFrameInitX,
                                                           cashFrameInitY,
                                                           cashFrameWidth,
                                                           cashFrameHeight)];
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(pushedMoneyFrame:)];
    [cashView addGestureRecognizer:singleFingerTap];
    [self.view addSubview:cashView];
    
    //ruby image
    UIImageView *cashIV = [[UIImageView alloc]initWithFrame:CGRectMake(cashFrameInitX + 10,
                                                                       cashFrameInitY + 14, 23, 23)];
    cashIV.image = [UIImage imageNamed:strImgUnit];
    [self.view addSubview:cashIV];
    
    //ruby numeric
    CGRect rectRubyAmount = CGRectMake(cashFrameInitX + 50,
                                       cashFrameInitY + 10,
                                       150, 32);
    lblRubyAmount = [[UILabel alloc]initWithFrame:rectRubyAmount];
    [lblRubyAmount setFont:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:14]];
    lblRubyAmount.text = [NSString stringWithFormat:@"%d", [[attr getValueFromDevice:@"ruby"] intValue]];
    lblRubyAmount.textColor = [UIColor whiteColor];
    lblRubyAmount.backgroundColor = [UIColor clearColor];//gray?
    [self.view addSubview:lblRubyAmount];
    
    
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = CGPointMake(self.view.bounds.size.width/2,
                                           self.view.bounds.size.height/2);
    [self.view addSubview:activityIndicator];
    
    //動画背景
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
    [viewSuperInPay setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.5]];
    [self.view addSubview:viewSuperInPay];
    
    //その上に閉じるアクションをつけたuiviewをaddする(この上に他のコンポーネントを置いてはだめ)
    //        UIView *viewSuper = [CreateComponentClass createButtonWithType:ButtonMenuBackTypeDefault
    //                                                                  rect:self.view.bounds
    //                                                                 image:nil
    //                                                                target:self
    //                                                              selector:@"closeViewCon:"];//このviewControllerだけ閉じる
    //        [viewSuper setBackgroundColor:[UIColor colorWithRed:0.0f green:0 blue:0 alpha:0.7f]];
    //        [viewSuperInPay addSubview:viewSuper];
    
    
    //画面中心にWIDTH_FRAME_SUPER X HEIGHT_FRAME_SUPERの枠を表示
    UIView *viewFrame = [CreateComponentClass createView:CGRectMake(self.view.bounds.size.width/2 - WIDTH_FRAME_SUPER/2,
                                                                    self.view.bounds.size.height/2 - HEIGHT_FRAME_SUPER/2,
                                                                    WIDTH_FRAME_SUPER,
                                                                    HEIGHT_FRAME_SUPER)];
    [viewFrame setBackgroundColor:[UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.6f]];//どちらでも良い
    //        [viewSuperInPay addSubview:viewFrame];//ここにviewFrameを乗っけるとボタンの反応がおかしい。
    [self.view addSubview:viewFrame];
    
    
    CGRect rectFrame;
    CGRect rectButton;
    UIView *eachFrame;
    UIImageView *payButtonView;

    UITextView *tvPrice;
    int widthPrice = SIZE_BUTTON_PRODUCT*1.3/2;
    int heightPrice = HEIGHT_FRAME_PRODUCT - SIZE_BUTTON_PRODUCT;//20
    
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
            eachFrame = [CreateComponentClass createView:rectFrame];//ボタン周りの小さな枠
            NSLog(@"button type %d, %d = %@",
                  row, col, [[arrTypeImage objectAtIndex:row] objectAtIndex:col]);
            payButtonView = [CreateComponentClass createMenuButton:(ButtonMenuBackType)ButtonMenuBackTypeBlue
                                                         imageType:(ButtonMenuImageType)[[[arrTypeImage
                                                                                           objectAtIndex:row]
                                                                                          objectAtIndex:col]
                                                                                         integerValue]
                                                              rect:(CGRect)rectButton
                                                            target:(id)self
                                                          selector:(NSString *)@"pushedButton:"
                                                               tag:[[[arrProductType objectAtIndex:row] objectAtIndex:col] intValue]];
            [eachFrame addSubview:payButtonView];//各フレームに各ボタンに置く
            
            //yen-mark
            viewYenImage = [CreateComponentClass createImageView:CGRectMake(MARGIN_FRAME_PRODUCT-10,
                                                                            HEIGHT_FRAME_PRODUCT - heightPrice+5, 20, 20)
                                                           image:strImgUnit];
            //                viewYenImage.center = CGPointMake(MARGIN_FRAME_PRODUCT, SIZE_BUTTON_PRODUCT + MARGIN_FRAME_PRODUCT*2);
            [eachFrame addSubview:viewYenImage];
            
            //price
            tvPrice = [CreateComponentClass createTextView:CGRectMake(SIZE_BUTTON_PRODUCT-widthPrice,
                                                                      HEIGHT_FRAME_PRODUCT-heightPrice,//center-adoption
                                                                      widthPrice,heightPrice)
                                                      text:[[arrPrice objectAtIndex:row] objectAtIndex:col]
                                                      font:@"AmericanTypewriter-Bold"
                                                      size:13
                                                 textColor:[UIColor whiteColor]
                                                 backColor:[UIColor clearColor]//redColor]//
                                                isEditable:NO];
            tvPrice.textAlignment = NSTextAlignmentRight;
            [eachFrame addSubview:tvPrice];
            
            [viewFrame addSubview:eachFrame];//各フレームをviewFrameに置く
            
        }
    }
    
    //確認ボタン->閉じる(viewFrameの外を押しても閉じる)
    int btHeight = 30;
    int btWidth = 150;
    //        UIImageView *btnConfirm = [CreateComponentClass createMenuButton:(ButtonMenuBackType)ButtonMenuBackTypeBlue
    //                                                               imageType:nil//(ButtonMenuImageType)ButtonMenuImageTypeCoin//test:仮
    //                                                                    rect:CGRectMake(WIDTH_FRAME_SUPER - btWidth - MARGIN_FRAME_PRODUCT,//右寄り
    //                                                                                    numOfRow * (HEIGHT_FRAME_PRODUCT + MARGIN_FRAME_PRODUCT) + MARGIN_FRAME_PRODUCT*3/2,//最下段フレームの下
    //                                                                                    btWidth, btHeight)
    //                                                                  target:(id)self
    //                                                                selector:@"closeViewCon"];
    //        UIButton *btnConfirm = [[CoolButton alloc]initWithFrame:CGRectMake(WIDTH_FRAME_SUPER - btWidth - MARGIN_FRAME_PRODUCT,//右寄り
    //                                                                          numOfRow * (HEIGHT_FRAME_PRODUCT + MARGIN_FRAME_PRODUCT) + MARGIN_FRAME_PRODUCT*3/2,//最下段フレームの下
    //                                                                           btWidth, btHeight)];
    UIButton *btnConfirm = [CreateComponentClass createCoolButton:CGRectMake(WIDTH_FRAME_SUPER - btWidth - MARGIN_FRAME_PRODUCT,//右寄り
                                                                             numOfRow * (HEIGHT_FRAME_PRODUCT + MARGIN_FRAME_PRODUCT) + MARGIN_FRAME_PRODUCT*3/2,//最下段フレームの下
                                                                             btWidth, btHeight)
                                                             text:@"confirm"
                                                              hue:0.3
                                                       saturation:0.3
                                                       brightness:0.3
                                                           target:self
                                                         selector:@"closeViewCon"
                                                              tag:0];
    [viewFrame addSubview:btnConfirm];
    //        [self.view addSubview:btnConfirm];//位置修正が必要
    

    
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //rubyの更新
    lblRubyAmount.text = [attr getValueFromDevice:@"ruby"];
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
    
    NSString *productId = transaction.payment.productIdentifier;
    NSLog(@"Successfully acquired product ID = %@", productId);

//    for(NSString *strId in arrProductId){
    for(int i = 0; i < [arrProductId count];i++){
        NSString *strId = [arrProductId objectAtIndex:i];
        if([strId isEqualToString:productId]){
            //log
            NSLog(@"%@を取得したのでコイン%dを追加します",
                  strId,
                  [[arrAcquired objectAtIndex:i] intValue]);
            
            int _ruby = [[attr getValueFromDevice:@"ruby"] intValue] + [[arrAcquired objectAtIndex:i] intValue];
            [attr setValueToDevice:@"ruby" strValue:[NSString stringWithFormat:@"%d", _ruby]];
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"コイン%@枚を追加しました。", [arrAcquired objectAtIndex:i]]
                                                           message:nil
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
    
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
