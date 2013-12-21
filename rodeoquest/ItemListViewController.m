//
//  ItemListViewController.m
//  Shooting6
//
//  Created by 遠藤 豪 on 13/10/17.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "ItemListViewController.h"
//#import "BackGroundClass2.h"

@interface ItemListViewController ()

@end

@implementation ItemListViewController

AttrClass *attr;
UITextView *tvGoldAmount;
//UIButton *btnBuy;
BackGroundClass2 *backGround;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        arrIv = [NSMutableArray arrayWithObjects:
                 @"close.png",
                 @"close.png",
                 @"close.png",
                 @"close.png",
                 nil];
        arrTv = [NSMutableArray arrayWithObjects:
                 @"close.png",
                 @"close.png",
                 @"close.png",
                 @"close.png",
                 nil];
        arrCost = [NSMutableArray arrayWithObjects:
                   @"100",
                   @"100",
                   @"100",
                   @"100",
                nil];
        itemList = [NSMutableArray arrayWithObjects:
                    @"itemlist0",
                    @"itemlist1",
                    @"itemlist2",
                    @"itemlist3",
                    nil];
        arrTitle = [NSMutableArray arrayWithObjects:
                        @"buy",
                        @"buy",
                        @"buy",
                        @"buy",
                        nil];
        arrBtnBuy = [NSMutableArray array];
        
//        background = [[BackGroundClass2 alloc]init:WorldTypeForest
//                                             width:self.view.bounds.size.width
//                                            height:self.view.bounds.size.height
//                                              secs:5.0f];
        
        attr = [[AttrClass alloc]init];
    }
    return self;
}

//ステータスバー非表示の一環
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    // ステータスバーを非表示にする:plistでの処理はiOS7以降非推奨
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        //ios7用
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    else
    {
        // iOS 6=>iOS 7ではきかない
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
    //backgroundの設定
//    UIImageView *background = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [self.view setBackgroundColor:[UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.5f]];
//    UIImageView *background = [[UIImageView alloc]initWithFrame:CGRectMake(-100, -10, 580, 480)];
//    background.image = [UIImage imageNamed:@"chara01.png"];
//    background.alpha = 0.5f;
//    [self.view sendSubviewToBack:background];
//    [self.view addSubview:background];
    
    //cash　frame
    int cashFrameWidth = 170;
    int cashFrameHeight = 50;
    int cashFrameInitX = 145;
    int cashFrameInitY = 40;
    UIView *cashView = [CreateComponentClass createView:CGRectMake(cashFrameInitX,
                                                                   cashFrameInitY,
                                                                   cashFrameWidth,
                                                                   cashFrameHeight)];
    [self.view addSubview:cashView];
    
    //cash image
    UIImageView *cashIV = [[UIImageView alloc]initWithFrame:CGRectMake(cashFrameInitX + 10,
                                                                       cashFrameInitY + 14, 23, 23)];
    cashIV.image = [UIImage imageNamed:@"coin_yellow.png"];
    [self.view addSubview:cashIV];
    
    //cash numeric
    CGRect rectGoldAmount = CGRectMake(cashFrameInitX + 50,
                                       cashFrameInitY + 10,
                                       150, 32);
    tvGoldAmount = [[UITextView alloc]initWithFrame:rectGoldAmount];
    //@"AmericanTypewriter-Bold"
    [tvGoldAmount setFont:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:14]];
    tvGoldAmount.text = [NSString stringWithFormat:@"%d", [[attr getValueFromDevice:@"gold"] intValue]];
    tvGoldAmount.textColor = [UIColor whiteColor];
    tvGoldAmount.backgroundColor = [UIColor clearColor];//gray?
    tvGoldAmount.editable = NO;
    [self.view addSubview:tvGoldAmount];
    
    
    
    
    
    
    
    //frame
    int itemFrameWidth = 300;
    int itemFrameHeight = 75;
    int itemFrameInitX = 5;
    int itemFrameInitY = 10;
    int itemFrameInterval = 10;
    
    int imageFrameWidth = itemFrameWidth / 6;
    int imageFrameHeight = itemFrameHeight - 20;
    int imageFrameInitX = itemFrameInitX + 10;
    int imageFrameInitY = itemFrameInitY + 10;
    int imageFrameInterval = itemFrameInterval + 20;
    
    
    int init_y = 95;
    int init_x = 5;
    //フレームの枠の長さはアイテムの表示が画面サイズ内に収まればアイテム個数まで。
    //収まらなければ画面サイズ一杯にする
    UIView *viewFrame = [CreateComponentClass
                         createView:CGRectMake(init_x, init_y,
                                               self.view.frame.size.width-init_x * 2,
                                               MIN(self.view.frame.size.height-init_y-10,
                                                   itemFrameInitY + (itemFrameHeight + itemFrameInterval) * [arrIv count])
                                               )];
    [viewFrame setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.01]];
    [self.view addSubview:viewFrame];
    
//    UIScrollView *sv = [[UIScrollView alloc]
//                        initWithFrame:viewFrame.bounds];
    ScrollViewForItemList *sv = [[ScrollViewForItemList alloc]
                                 initWithFrame:viewFrame.bounds];
    sv.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];//こうすれば子どものalpha値は上書きされない
    sv.bounces = NO;//バウンドさせない
    
    //svの上に貼られるview
    UIView *uvOnScroll = [[UIView alloc]
                          initWithFrame:CGRectMake(0,0,
                                                   sv.bounds.size.width,
                                                   itemFrameInitY + [arrIv count] * (itemFrameHeight + itemFrameInterval)
                                                   )];
    [uvOnScroll setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f]];
    sv.contentSize = uvOnScroll.bounds.size;
    
    
    [sv addSubview:uvOnScroll];
    [viewFrame addSubview:sv];
    
    
    //uvOnScroll-component
    for(int i = 0; i < [arrIv count]; i++){
        //frame作成
        UIView *eachView = [CreateComponentClass createView:CGRectMake(itemFrameInitX,
                                                                itemFrameInitY + i * (itemFrameHeight + itemFrameInterval),
                                                                itemFrameWidth,
                                                                itemFrameHeight)];
//        [self.view addSubview:eachView];
        [uvOnScroll addSubview:eachView];
        
        //image(cash)の貼付
        UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(imageFrameInitX-5,
                                                                   imageFrameInitY + i * (imageFrameHeight + imageFrameInterval),
                                                                   imageFrameWidth,
                                                                   imageFrameHeight)];
        iv.image = [UIImage imageNamed:[arrIv objectAtIndex:i]];
//        [self.view addSubview:iv];
        [uvOnScroll addSubview:iv];
        
        //名称、説明文の貼付：配列等にしておく必要あり
        UITextView *tv = [[TextViewForItemList alloc]initWithFrame:CGRectMake(imageFrameInitX + imageFrameWidth,
                                                                     itemFrameInitY + i * (itemFrameHeight + itemFrameInterval) + 10,
                                                                     itemFrameWidth * 5 / 9,
                                                                     itemFrameHeight - 20)];
//        tv.alpha = 0.5f;//文字色にも適用されてしまう
        tv.backgroundColor = [UIColor clearColor];
        tv.font = [UIFont fontWithName:@"Arial" size:12.0f];
        tv.textColor = [UIColor whiteColor];
//        tv.text = @"explanation";
        tv.text = [arrTv objectAtIndex:i];
        tv.editable = NO;
        tv.bounces = NO;//no-bound
//        [self.view addSubview:tv];
        [uvOnScroll addSubview:tv];
        
        //プラスボタンの貼付
        CGRect btnRect = CGRectMake(imageFrameInitX + imageFrameWidth + 10 + itemFrameWidth / 2 + 20,
                                    itemFrameInitY + i * (itemFrameHeight + itemFrameInterval) + 10,
                                    imageFrameWidth,
                                    imageFrameHeight);
        UIButton *btnBuy = [CreateComponentClass createQBButton:ButtonMenuBackTypeDefault
                                                        rect:btnRect
                                                       image:@"bullet_level6.png"
                                                       title:[arrTitle objectAtIndex:i]
                                                      target:self
                                                    selector:@"buyBtnPressed:"];
        btnBuy.tag = i;//[[arrCost objectAtIndex:i] intValue];
//        [uvOnScroll addSubview:btnBuy];
        
        [arrBtnBuy addObject:btnBuy];
        [uvOnScroll addSubview:[arrBtnBuy objectAtIndex:i]];
        
    }
    
    
    
    //参考戻る時(時間経過等ゲーム終了時で)：[self dismissModalViewControllerAnimated:YES];
    //            NSLog(@"return");
    //            [self dismissViewControllerAnimated:YES completion:nil];
    UIButton *closeBtn = [CreateComponentClass createButtonWithType:ButtonMenuBackTypeDefault
                                                               rect:CGRectMake(300, 3, 20, 20)
                                                              image:@"close.png"
                                                             target:self
                                                           selector:@"closeBtnClicked"];
    [self.view addSubview:closeBtn];
    [self.view bringSubviewToFront:closeBtn];
    
//    [self.view addSubview:[background getImageView1]];
//    [self.view addSubview:[background getImageView2]];
////    [self.view sendSubviewToBack:[background getImageView1]];
////    [self.view sendSubviewToBack:[background getImageView2]];
//    [self.view bringSubviewToFront:[background getImageView1]];
//    [self.view bringSubviewToFront:[background getImageView2]];
//    NSLog(@"start animation at list view");
//    [background startAnimation];
//    NSLog(@"end animation at list view");
}

-(void)closeBtnClicked{
    NSLog(@"close");
//    [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];//menuViewConの背景がすぐに表示されない
//    [self performSelector:@selector(closeViewCon) withObject:Nil afterDelay:0.01f];
}

//-(void)closeViewCon{
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

-(void)buyBtnPressed:(id)sender{//arg:selected-item-list-no
    if([[attr getValueFromDevice:@"gold"] intValue] >= [[arrCost objectAtIndex:[sender tag]] intValue]){
        int cost = [[arrCost objectAtIndex:[sender tag]] intValue];
        NSLog(@"buy button pressed : %d", [sender tag]);
        [self updateToDeviceCoin:[[attr getValueFromDevice:@"gold"] intValue] - cost];//[attr setValueToDev..
        [self displayCoin];//tv.text = ...
        
        
        [self processAfterBtnPressed:[itemList objectAtIndex:[sender tag]]];
        
    }else{
        //お金が足りない場合
        [self oscillateTextViewGold:9];
        
        //コインはゲームで取得するか購入することができますメッセージダイアログボックス
        UIView *alertView =
        [CreateComponentClass
         createAlertView:CGRectMake(10, 10, 300, 300)
         dialogRect:CGRectMake(10, 10, 250, 200)
         title:@"cash short!"
         subtitle:@"buy coin!"
         onYes:^{
             NSLog(@"link to buy money");
         }
         onNo:^{
             NSLog(@"remove this alert");
         }];
        
        [self.view addSubview:alertView];
        
    }
    
}

-(void)processAfterBtnPressed:(NSString *)_key{
    if([[attr getValueFromDevice:_key] isEqual:[NSNull null]] ||
       [attr getValueFromDevice:_key] == nil){
        
        [attr setValueToDevice:_key strValue:@"1"];
    }else{
        
        int beforeNum = [[attr getValueFromDevice:_key] intValue];
        int afterNum = beforeNum + 1;
        
        
        [attr setValueToDevice:_key strValue:[NSString stringWithFormat:@"%d", afterNum]];
    }
    
    NSLog(@"processAfterBtnPressed:%@", [attr getValueFromDevice:_key]);
}

-(void)oscillateTextViewGold:(int)count{
    NSLog(@"%d", count);
    [UIView animateWithDuration:0.05f
                     animations:^{
                         tvGoldAmount.center = CGPointMake(tvGoldAmount.center.x + ((count%2==0)?10:-10),
                                                           tvGoldAmount.center.y);
                     }
                     completion:^(BOOL finished){
                         if(count > 0){
                             [self oscillateTextViewGold:count-1];
                         }
                     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)displayCoin{//購入後のコイン値を修正する
    NSLog(@"now coin = %d", [[attr getValueFromDevice:@"gold"] intValue]);
    int gold = [[attr getValueFromDevice:@"gold"] intValue];
    tvGoldAmount.text = [NSString stringWithFormat:@"%d", gold];
}
-(void)updateToDeviceCoin:(int)coin{
    [attr setValueToDevice:@"gold" strValue:[NSString stringWithFormat:@"%d", coin]];
    
}

@end
