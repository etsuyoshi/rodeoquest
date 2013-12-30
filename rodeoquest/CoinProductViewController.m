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
        
        
        strImgUnit = @"jewel_small";//購入単位イメージ画像(.png省略)
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //ruby　frame
//    int cashFrameWidth = 170;
//    int cashFrameHeight = 50;
//    int cashFrameInitX = 145;
//    int cashFrameInitY = 40;
    
    //remove cashView defined in superclass
//    cashView = [CreateComponentClass createView:CGRectMake(cashFrameInitX,
//                                                                   cashFrameInitY,
//                                                                   cashFrameWidth,
//                                                                   cashFrameHeight)];
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(pushedMoneyFrame:)];
    [cashView addGestureRecognizer:singleFingerTap];
//    [self.view addSubview:cashView];
    
    //ruby image
//    UIImageView *cashIV = [[UIImageView alloc]initWithFrame:CGRectMake(10,
//                                                                       14, 23, 23)];
//    cashIV.image = [UIImage imageNamed:@"jewel.png"];
//    [cashView addSubview:cashIV];
//    
//    //ruby numeric
    CGRect rectRubyAmount = CGRectMake(50,
                                       10,
                                       150, 32);
    myLblRubyAmount = [[UILabel alloc]initWithFrame:rectRubyAmount];
    [myLblRubyAmount setFont:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:14]];
    myLblRubyAmount.text = [NSString stringWithFormat:@"%d", [[attr getValueFromDevice:@"ruby"] intValue]];
    myLblRubyAmount.textColor = [UIColor whiteColor];
    myLblRubyAmount.backgroundColor = [UIColor clearColor];//gray?
    [cashView addSubview:myLblRubyAmount];
    
    
    [lblRubyAmount removeFromSuperview];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    myLblRubyAmount.text = [attr getValueFromDevice:@"ruby"];
    [self.view bringSubviewToFront:cashView];
    
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
    
}

-(void)pushedMoneyFrame:(UITapGestureRecognizer *)recognizer{//rubyが表示されたフレームを押下するとruby購入ページへ移行
    PayProductViewController * payView =
    [[PayProductViewController alloc] init];
    [self presentViewController:payView animated:YES completion:nil];

}
@end
