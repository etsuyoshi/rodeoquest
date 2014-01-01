//
//  CoinProductViewController.m
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/24.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "CoinProductViewController.h"

@interface CoinProductViewController ()

@end

@implementation CoinProductViewController


UIView *viewDialog;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        arrTypeImage = [NSArray arrayWithObjects:
                        [NSArray arrayWithObjects:
                         [NSNumber numberWithInteger:ButtonMenuImageTypeBuyCoin0],
                         [NSNumber numberWithInteger:ButtonMenuImageTypeBuyCoin1],
                         [NSNumber numberWithInteger:ButtonMenuImageTypeBuyCoin2],
                         nil],
                        [NSArray arrayWithObjects:
                         [NSNumber numberWithInteger:ButtonMenuImageTypeBuyCoin3],
                         [NSNumber numberWithInteger:ButtonMenuImageTypeBuyCoin4],
                         [NSNumber numberWithInteger:ButtonMenuImageTypeBuyCoin5],
                         nil],
                        nil];
        arrAcquired = [NSArray arrayWithObjects:
                       @"1500",//number of coin(gold) when user buy this item
                       @"3500",
                       @"8000",
                       @"15000",
                       @"27500",
                       @"60000",
                       nil];
        arrProductType = [NSArray arrayWithObjects:
                          [NSArray arrayWithObjects:
                           [NSNumber numberWithInt:CoinType1],
                           [NSNumber numberWithInt:CoinType2],
                           [NSNumber numberWithInt:CoinType3],
                           nil],
                          [NSArray arrayWithObjects:
                           [NSNumber numberWithInt:CoinType4],
                           [NSNumber numberWithInt:CoinType5],
                           [NSNumber numberWithInt:CoinType6],
                           nil],
                          nil];

        //price
        arrPrice = [NSArray arrayWithObjects:
                    [NSArray arrayWithObjects:
                     @"5",//ruby consumed(need)
                     @"10",
                     @"20",
                     nil],
                    [NSArray arrayWithObjects:
                     @"30",
                     @"50",
                     @"100",
                     nil],
                    nil];
        arrTypeBack = [NSArray arrayWithObjects:
                       [NSArray arrayWithObjects:
                        [NSNumber numberWithInt:ButtonMenuBackTypeGreen],
                        [NSNumber numberWithInt:ButtonMenuBackTypeGreen],
                        [NSNumber numberWithInt:ButtonMenuBackTypeGreen],
                        nil],
                       [NSArray arrayWithObjects:
                        [NSNumber numberWithInt:ButtonMenuBackTypeGreen],
                        [NSNumber numberWithInt:ButtonMenuBackTypeGreen],
                        [NSNumber numberWithInt:ButtonMenuBackTypeGreen],
                        nil],
                       nil];
        
        strImgUnit = @"jewel_small";//購入単位イメージ画像(.png省略)
    }
    return self;
}


/*
 *スーパークラスで定義されたrubyViewの位置を調整(上にずらす)
 *本クラスでcashViewを新規に作成し、rubyViewの下に生成
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //location adjustment
    rubyView.center =
    CGPointMake(rubyView.center.x,
                rubyView.frame.size.height);
    
    //cash　frame location
    int cashFrameWidth = rubyView.frame.size.width;
    int cashFrameHeight = rubyView.frame.size.height;
    int cashFrameInitX = rubyView.frame.origin.x;
    int cashFrameInitY = rubyView.frame.origin.y + rubyView.frame.size.height + 5;
    
    cashView = [CreateComponentClass createView:CGRectMake(cashFrameInitX,
                                                           cashFrameInitY,
                                                           cashFrameWidth,
                                                           cashFrameHeight)];
    [self.view addSubview:cashView];
    
    
    
    //cash image
    UIImageView *cashIV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 14, 23, 23)];
    cashIV.image = [UIImage imageNamed:@"coin_yellow"];//png-file
    [cashView addSubview:cashIV];
    
    CGRect rectCashAmount = CGRectMake(50, 10, 150, 32);
    lblCashAmount = [[UILabel alloc]initWithFrame:rectCashAmount];
    [lblCashAmount setFont:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:14]];
    lblCashAmount.text = [NSString stringWithFormat:@"%d", [[attr getValueFromDevice:@"gold"] intValue]];
    lblCashAmount.textColor = [UIColor whiteColor];
    lblCashAmount.backgroundColor = [UIColor clearColor];//gray?
    [cashView addSubview:lblCashAmount];
    
    
    
    
    //スーパークラスのrubyViewにジェスチャーレコを付与(subclassのみに適用)
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(pushedMoneyFrame:)];
    [rubyView addGestureRecognizer:singleFingerTap];
    
    
//    //ruby numeric
    CGRect rectRubyAmount = CGRectMake(50, 10, 150, 32);
    [lblRubyAmount removeFromSuperview];//remove superclass field "rubyView"
    myLblRubyAmount = [[UILabel alloc]initWithFrame:rectRubyAmount];
    [myLblRubyAmount setFont:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:14]];
    myLblRubyAmount.text = [NSString stringWithFormat:@"%d", [[attr getValueFromDevice:@"ruby"] intValue]];
    myLblRubyAmount.textColor = [UIColor whiteColor];
    myLblRubyAmount.backgroundColor = [UIColor clearColor];//gray?
    [rubyView addSubview:myLblRubyAmount];//cashView is defined in superclass
    
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    myLblRubyAmount.text = [NSString stringWithFormat:@"%d",
                            [[attr getValueFromDevice:@"ruby"] integerValue]];
//    [self.view bringSubviewToFront:rubyView];
    
    lblCashAmount.text = [NSString stringWithFormat:@"%d",
                          [[attr getValueFromDevice:@"gold"] integerValue]];
    
    NSLog(@"view will appear at coinProduct at ruby:%@", myLblRubyAmount.text);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 *ボタン押下時の対応
 *1.(足りていれば)ルビーを使って購入?ダイアログ
 *2.(不足していれば)ルビーが足りません。ルビー購入画面に移動しますか？ダイアログ
 */
-(void)pushedButton:(NSNumber *)num{
    NSLog(@"pushed button : tag = %d from coinProductViewCon", num.integerValue);
    
    //現在保有ruby個数を取得
    int numOfRuby = [attr getValueFromDevice:@"ruby"].integerValue;
    //必要なルビーの個数を格納するためのフィールド
    int neededRuby = 0;

    //selected item
    switch((CoinType)(num.integerValue)){
        case CoinType1:{
            neededRuby = [[[arrPrice objectAtIndex:0] objectAtIndex:0] integerValue];
            break;
        }
        case CoinType2:{
            neededRuby = [[[arrPrice objectAtIndex:0] objectAtIndex:1] integerValue];
            break;
        }
        case CoinType3:{
            neededRuby = [[[arrPrice objectAtIndex:0] objectAtIndex:2] integerValue];
            break;
        }
        case CoinType4:{
            neededRuby = [[[arrPrice objectAtIndex:1] objectAtIndex:0] integerValue];
            break;
        }
        case CoinType5:{
            neededRuby = [[[arrPrice objectAtIndex:1] objectAtIndex:1] integerValue];
            break;
        }
        case CoinType6:{
            neededRuby = [[[arrPrice objectAtIndex:1] objectAtIndex:2] integerValue];
            break;
        }
            
        default:{//nothings corresponding
            break;
        }
    }
    NSLog(@"numOfRuby=%d, neededRuby=%d", numOfRuby, neededRuby);
    if(numOfRuby < neededRuby){//short
        //不足しています。ルビーを購入しますか？
        
        //キャンセル対応
        void (^blockCloseViewDialog)(void) = ^(void){
            [viewDialog removeFromSuperview];
        };
        //dialog表示
        viewDialog =
        [CreateComponentClass
         createAlertView:self.view.bounds
         dialogRect:CGRectMake(0, 0,
                               self.view.bounds.size.width-20,
                               self.view.bounds.size.width-20)
         title:@"ルビーが不足しています。"
         message:@"購入ページへ移動しますか？"
         titleYes:@"移動" titleNo:@"キャンセル"
         onYes:^{
             //購入ページへ移動
             PayProductViewController *ppvc = [[PayProductViewController alloc]init];
             [self presentViewController:ppvc animated:YES completion:nil];
             
             [viewDialog removeFromSuperview];
             
         }
         onNo:blockCloseViewDialog];

        viewDialog.center =
        CGPointMake(self.view.bounds.size.width/2,
                    self.view.bounds.size.height/2);
        [self.view addSubview:viewDialog];
    }else{
        //コインを購入しますか？
        
        //キャンセル対応
        void (^blockCloseViewDialog)(void) = ^(void){
            [viewDialog removeFromSuperview];
        };
        //dialog表示
        viewDialog =
        [CreateComponentClass
         createAlertView:self.view.bounds
         dialogRect:CGRectMake(0, 0,
                               self.view.bounds.size.width-20,
                               self.view.bounds.size.width-20)
         title:@"ルビーとコインを交換しますか？"
         message:@"よろしければ「はい」を押して下さい。"
         titleYes:@"はい" titleNo:@"キャンセル"
         onYes:^{
             int acquiredCoin = [[arrAcquired objectAtIndex:num.integerValue] integerValue];
             [self buyCoin:neededRuby acquiredCoin:acquiredCoin];
             
             [viewDialog removeFromSuperview];
             
         }
         onNo:blockCloseViewDialog];
        
        viewDialog.center =
        CGPointMake(self.view.bounds.size.width/2,
                    self.view.bounds.size.height/2);
        [self.view addSubview:viewDialog];
    }
}

-(void)buyCoin:(int)_neededRuby acquiredCoin:(int)_acquiredCoin{
    int numOfRuby = [[attr getValueFromDevice:@"ruby"] integerValue];
    numOfRuby -= _neededRuby;
    
    //ruby-process
    if(numOfRuby >= 0){
        [attr setValueToDevice:@"ruby" strValue:[NSString stringWithFormat:@"%d", numOfRuby]];
    }else{
        NSLog(@"error occurred at CoinProductViewController when buyCoin method caz numOfRuby < 0!");
        return;
    }
    
    //gold-process: to increase coin
    int nowCoin = [[attr getValueFromDevice:@"gold"] integerValue];
    [attr setValueToDevice:@"gold"
                  strValue:[NSString stringWithFormat:@"%d", nowCoin+_acquiredCoin]];
    
    //GUI setting(cash & ruby)
    lblCashAmount.text = [attr getValueFromDevice:@"gold"];
    myLblRubyAmount.text = [attr getValueFromDevice:@"ruby"];
    
    
    //確認ダイアログ
    [super showDialog];
    
}

/*
 *rubyが表示されたフレームを押下するとruby購入ページへ移行
 */
-(void)pushedMoneyFrame:(UITapGestureRecognizer *)recognizer{
    PayProductViewController * payView =
    [[PayProductViewController alloc] init];
    [self presentViewController:payView animated:YES completion:nil];

}
@end
