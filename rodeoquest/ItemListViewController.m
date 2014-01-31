//
//  ItemListViewController.m
//  Shooting6
//
//  Created by 遠藤 豪 on 13/10/17.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
/*
 *initWithNibName:データ初期化
 *viewDidLoad:各コンポーネントの張り付け
 *viewWillAppear:コインや装備状態(サブクラスのWeaponBuyList...)にデータを反映
 *viewDidAppear:
 *onSelectButton:(id)sender:リスト中のボタン押下により呼出される。サブクラスにおいて即座に購入せずに状態を判定する機能も備える。
 *buyBtnPressed:sender:onSelectButtonから呼出し:購入処理orコイン不足のエフェクト表示
 *processAfterBtnPressed:(NSString *)_key:各アイテムの状態をセット。サブクラスにおいて装備状態を判定する機能も備える。
 *viewWillDisappear:
 *viewDidDisappear:
 */
//

//arrCostには初期値だけ代入しておき、サブクラスで実際の数字を代入する
//一度アイテムを購入すると次の購入コストのそのx(５個までは５倍、それ以降は２倍)倍にする


//コインの購入機能の付与(機能を許可する場合はコメントアウトを外す)
//#define PaymentAllowMode

//アイテムの購入数上限
#define LimitNumBuyItem 12

#import "ItemListViewController.h"

@interface ItemListViewController ()

@end

@implementation ItemListViewController

AttrClass *attr;
//UIButton *btnBuy;
BackGroundClass2 *backGround;
id _self;

void (^actYesForCoinShort)(void) = ^(void) {
    
    NSLog(@"link to buy money");
    [viewForCoinShort removeFromSuperview];
    
    
    //             [self closeBtnClicked];
    CoinProductViewController *coinView = [[CoinProductViewController alloc] init];
    [_self presentViewController: coinView animated:NO completion: nil];
    
    
};

void (^actNoForCoinShort)(void) = ^(void) {
    NSLog(@"automatically remove this alert");
    
    [viewForCoinShort removeFromSuperview];
    
    
};


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    _self = self;
    if (self) {
        // Custom initialization
        //アイコン
        arrIv = [NSMutableArray arrayWithObjects:
                 @"close.png",
                 @"close.png",
                 @"close.png",
                 @"close.png",
                 nil];
        
        //view over icon:arrIv
        arrIv2 = [NSMutableArray arrayWithObjects:
                  @"",
                  @"",
                  @"",
                  @"",
                 nil];
        arrIvType = [NSMutableArray arrayWithObjects:
                     @0,//min:normal
                     @1,//static
                     @2,//animation
                     @3,//max:static+animation
                     nil];
        //コメント
        arrTv = [NSMutableArray arrayWithObjects:
                 @"close.png",
                 @"close.png",
                 @"close.png",
                 @"close.png",
                 nil];
        //価格
        arrCost = [NSMutableArray arrayWithObjects:
                   @"100",
                   @"100",
                   @"100",
                   @"100",
                nil];
        //AttrClassに書き込むキー値
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
        
        strImgCurrency = @"coin_yellow";//image of unit to buy item.
        
        attr = [[AttrClass alloc]init];
        
        
        
        //ビューの位置
        //frame-size
        itemFrameWidth = 300;
        itemFrameHeight = 75;
        itemFrameInitX = 5;
        itemFrameInitY = 10;
        itemFrameInterval = 10;
        smallIconHeight = 25;
        //icon-size
        imageFrameWidth = itemFrameWidth / 6;
//        imageFrameWidth  = itemFrameHeight - 20;
        imageFrameHeight = itemFrameHeight - 20;
        imageFrameInitX = 5;//itemFrameの左から10px
        imageFrameInitY = 5;//itemFrameの上から10px
//        imageFrameInterval = itemFrameInterval + 20;
        
        //button-size
        buttonFrameWidth = imageFrameWidth;
        buttonFrameHeight = imageFrameHeight;
        
        //text(view)-size
        textViewInitX = imageFrameInitX + imageFrameWidth-5;//画像が小さいので右隣のテキストは少し左にずらす
        textViewInitY = imageFrameInitY;
        textViewHeight = itemFrameHeight-smallIconHeight/2;
        textViewWidth = itemFrameWidth * 6 / 9;//微調整結果
        //cash　frame
        cashFrameWidth = 170;
        cashFrameHeight = 50;
        cashFrameInitX = 145;
        cashFrameInitY = 40;
        //location of superview which is listing each item-frame
        init_x = 5;
        init_y = 95;
        
        strSmallIcon = @"blue_item_yuri_big.png";//アイテムの保有個数：WeaponBuyListViewControllerのみ
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
    
    nameCurrency = @"ゼニー";
    idCurrency = @"gold";
    
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
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"back_shop02.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //サブクラスで更新された表示文字(コスト)の初期値を保有数によってアップデート
    
    for(int _noItem = 0; _noItem < [arrCost count];_noItem++){
        //初期コストを取得
        int cost = [arrCost[_noItem] integerValue];
        
        //今までに購入した個数
        int sumOfItemBought = [[attr getValueFromDevice:itemList[_noItem]] integerValue];//各itemlistの値
        
        //costを変換：５個までは５倍、それ以降は２倍(最初は急激に増えるが最後は滑らかに上昇)
        for(int i = 0;i < sumOfItemBought;i++){
            if(i < 5){//5個までは５倍
                cost *= 5;
            }else{//５個より多く購入している場合は2倍
                cost *= 2;
            }
        }
        
        //コスト更新
        arrCost[_noItem] = [NSString stringWithFormat:@"%d", cost];
        
        //説明文の更新
        arrTv[_noItem] = [NSString stringWithFormat:@"%@\n%@枚の%@が必要です。",
                    arrTv[_noItem], arrCost[_noItem],nameCurrency];
    }
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    //コンポーネントの配置(少し遅らせてコンポーネントを表示することによって背景が強調され道具屋であることが分かる。)
    //ornament
    UIImageView *viewOrnament =
    [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    viewOrnament.image = [UIImage imageNamed:@"frame02.png"];
    [self.view addSubview:viewOrnament];
    
    
    cashView = [CreateComponentClass createView:CGRectMake(cashFrameInitX,
                                                           cashFrameInitY,
                                                           cashFrameWidth,
                                                           cashFrameHeight)];
    [self.view addSubview:cashView];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(pushedCashFrame:)];
    [cashView addGestureRecognizer:singleFingerTap];
    
    
    //cash image
    //    UIImageView *cashIV = [[UIImageView alloc]initWithFrame:CGRectMake(cashFrameInitX + 10,
    //                                                                       cashFrameInitY + 14, 23, 23)];
    UIImageView *cashIV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 14, 23, 23)];
    cashIV.image = [UIImage imageNamed:strImgCurrency];
    //    [self.view addSubview:cashIV];
    [cashView addSubview:cashIV];
    
    //cash numeric
    //    CGRect rectGoldAmount = CGRectMake(cashFrameInitX + 50,
    //                                       cashFrameInitY + 10,
    //                                       150, 32);
    CGRect rectGoldAmount = CGRectMake(50, 10, 150, 32);
    tvGoldAmount = [[UITextView alloc]initWithFrame:rectGoldAmount];
    //@"AmericanTypewriter-Bold"
    [tvGoldAmount setFont:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:14]];
    tvGoldAmount.text = [NSString stringWithFormat:@"%d", [[attr getValueFromDevice:@"gold"] intValue]];
    tvGoldAmount.textColor = [UIColor whiteColor];
    tvGoldAmount.backgroundColor = [UIColor clearColor];//gray?
    tvGoldAmount.editable = NO;
    //    [self.view addSubview:tvGoldAmount];
    [cashView addSubview:tvGoldAmount];
    
    
    
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
    uvOnScroll = [[UIView alloc]
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
        
        //image(left-icon)の貼付
        //        UIImageView *ivIcon = [[UIImageView alloc]initWithFrame:CGRectMake(imageFrameInitX-5,
        //                                                                   imageFrameInitY + i * (imageFrameHeight + imageFrameInterval),
        //                                                                   imageFrameWidth,
        //                                                                   imageFrameHeight)];
        UIImageView *ivIcon = [[UIImageView alloc]
                               initWithFrame:CGRectMake(imageFrameInitX,
                                                        itemFrameInitY + i * (itemFrameHeight + itemFrameInterval) + imageFrameInitY,
                                                        imageFrameWidth, imageFrameHeight)];
        ivIcon.center = CGPointMake(ivIcon.center.x,
                                    itemFrameInitY + i * (itemFrameHeight + itemFrameInterval) + itemFrameHeight/2);//中心に
        ivIcon.image = [UIImage imageNamed:[arrIv objectAtIndex:i]];
        
        //アイコンの上に載せるエフェクト(キラキラ)
        if([arrIv2 count] > 0 && [arrIvType count] > 0){
            if(![[arrIv2 objectAtIndex:i] isEqualToString:@""]){
                //                NSLog(@"arritType=%d, %d", (int)arrIvType[i], [arrIvType[i] integerValue]);
                switch ([arrIvType[i] integerValue]) {
                    case 0:{
                        //do nothing
                        break;
                    }
                    case 1:{
                        //static
                        UIImageView *iv3 = [[UIImageView alloc] initWithFrame:ivIcon.bounds];
                        iv3.image = [UIImage imageNamed:arrIv2[i]];
                        iv3.alpha = 1.0f;
                        iv3.transform = CGAffineTransformMakeRotation(15.0f * i * M_PI/180.0f);//適当な角度に回転
                        [ivIcon addSubview:iv3];
                        break;
                    }
                    case 2:{//anim=>実際にはアニメーション実行Viewとiかiv2は異なるのでcase 3と同じエフェクト
                        UIImageView *iv2 = [[UIImageView alloc] initWithFrame:ivIcon.bounds];
                        iv2.image = [UIImage imageNamed:arrIv2[i]];
                        iv2.alpha = 1.0f;
                        [self effectOnOff:iv2];
                        [ivIcon addSubview:iv2];
                        
                    }
                    case 3:{//anim+static
                        //anim
                        UIImageView *iv2 = [[UIImageView alloc] initWithFrame:ivIcon.bounds];
                        iv2.image = [UIImage imageNamed:arrIv2[i]];
                        iv2.alpha = 1.0f;
                        [self effectOnOff:iv2];
                        [ivIcon addSubview:iv2];
                        
                        //static
                        UIImageView *iv3 = [[UIImageView alloc] initWithFrame:ivIcon.bounds];
                        iv3.image = [UIImage imageNamed:arrIv2[i]];
                        iv3.alpha = 1.0f;
                        iv3.transform = CGAffineTransformMakeRotation(15.0f * i * M_PI/180.0f);//適当な角度に回転
                        [ivIcon addSubview:iv3];
                        break;
                    }
                    default:
                        break;
                }
            }
        }
        //        [self.view addSubview:iv];
        [uvOnScroll addSubview:ivIcon];
        
        //名称、説明文の貼付：配列等にしておく必要あり
        UITextView *tv = [[TextViewForItemList alloc]
                          initWithFrame:CGRectMake(textViewInitX,
                                                   itemFrameInitY + i * (itemFrameHeight + itemFrameInterval) + textViewInitY,
                                                   textViewWidth,
                                                   textViewHeight)];
        //        tv.alpha = 0.5f;//文字色にも適用されてしまう
        //        tv.backgroundColor = [UIColor blueColor];//test
        tv.backgroundColor = [UIColor clearColor];
        tv.font = [UIFont fontWithName:@"Arial" size:10.0f];//12.0f
        tv.textColor = [UIColor whiteColor];
        //        tv.text = @"explanation";
        tv.text = [arrTv objectAtIndex:i];
        //        tv.adjustsFontSizeToFitWidth = YES;//only for textlabel
        tv.editable = NO;
        tv.bounces = NO;//no-bound
        //        [self.view addSubview:tv];
        [uvOnScroll addSubview:tv];
        
        //drawing of smallIcon
        [self displaySmallIcon:i];
        
        
        
        //プラスボタンの貼付
        //        CGRect btnRect = CGRectMake(imageFrameInitX + imageFrameWidth + 10 + itemFrameWidth / 2 + 20,
        //                                    itemFrameInitY + i * (itemFrameHeight + itemFrameInterval) + 10,
        //                                    imageFrameWidth,
        //                                    imageFrameHeight);
        CGRect btnRect = CGRectMake(itemFrameInitX + textViewInitX + textViewWidth-5,//微調整
                                    itemFrameInitY + i * (itemFrameHeight + itemFrameInterval) + textViewInitY,
                                    buttonFrameWidth, buttonFrameHeight);
        UIButton *btnBuy = [CreateComponentClass createQBButton:ButtonMenuBackTypeDefault
                                                           rect:btnRect
                                                          image:@"bullet_level6.png"
                                                          title:[arrTitle objectAtIndex:i]
                                                         target:self
                                                       selector:@"onSelectButton:"];
        btnBuy.center = CGPointMake(btnBuy.center.x,
                                    itemFrameInitY + i * (itemFrameHeight + itemFrameInterval) + itemFrameHeight/2);//中心高さ
        btnBuy.tag = i;//ボタンが押されたときのデータ更新に使用
        [arrBtnBuy addObject:btnBuy];//サブクラスで使用するためにグローバル配列に格納(ボタン特性を変更するWeaponBuyのため)
        [uvOnScroll addSubview:[arrBtnBuy objectAtIndex:i]];
        
    }
    
    
    
    //参考戻る時(時間経過等ゲーム終了時で)：[self dismissModalViewControllerAnimated:YES];
    //            NSLog(@"return");
    //            [self dismissViewControllerAnimated:YES completion:nil];
    closeBtn = [CreateComponentClass createButtonWithType:ButtonMenuBackTypeDefault
                                                     rect:CGRectMake(300, 3, 50, 50)
                                                    image:@"exit_b.png"
                                                   target:self
                                                 selector:@"closeBtnClicked"];
    closeBtn.center = CGPointMake(self.view.bounds.size.width-closeBtn.bounds.size.width/2,
                                  closeBtn.bounds.size.height/2);
    [self.view addSubview:closeBtn];
    [self.view bringSubviewToFront:closeBtn];
    
    
    //キャッシュビューに最新値を更新する
    tvGoldAmount.text = [attr getValueFromDevice:idCurrency];
}

-(void)effectOnOff:(UIImageView *)_viewArg{
//    _viewArg.alpha = 1.0f;
    [UIView animateWithDuration:MAX(1.0f,(float)(arc4random() % 20)/10.0f)//発火、消火の繰り返し:3秒から1秒
                     animations:^{
                         _viewArg.alpha = 1.0;
//                         _viewArg.center =
//                         CGPointMake(_viewArg.center.x,
//                                     _viewArg.center.y + _viewArg.bounds.size.height/2);
                     }
                     completion:^(BOOL finished){
                         if(finished){
                             _viewArg.alpha = 0.0f;
                             //任意方向に回転
                             float sizeView = MAX(0.7f,(float)(arc4random()%15)/10.0f);//1.0-1.5
                             CGAffineTransform t1 = CGAffineTransformMakeRotation(MAX(arc4random()%90, 10) * M_PI / 180.0);//回転
                             CGAffineTransform t2 = CGAffineTransformMakeScale(sizeView, sizeView);//拡大、縮小
                             
                             // 回転と拡大の組み合わせ
                             _viewArg.transform = CGAffineTransformConcat(t1, t2);
                             
                             
                             NSLog(@"effectOnOff");
                             [self effectOnOff:_viewArg];
                         }
                     }];
    
}

-(void)closeBtnClicked{
    NSLog(@"close");
//    [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];//menuViewConの背景がすぐに表示されない
//    [self performSelector:@selector(closeViewCon) withObject:Nil afterDelay:0.01f];
}


/*
 *購入だけでなく、(サブクラスで)装備品もあることを勘案して
 *購入だけでなく、装備中ですメッセージを表示するパターンも考慮した。
 *つまりサブクラスで装備中アイテムボタンが押下された場合、onSelectButtonが呼ばれるので、このボタンをオーバーライドしておけば
 *オーバーライドクラス内で装備品、購入品かを判定し、購入品ならばbuyBtnPressedを呼べば良い
 *ちなみにbuyBtnPressedメソッドをサブクラスでオーバーライドする方法は非推奨：当該クラス内でグローバルなブロック変数(actYesFor...)を用いて、その修正が多岐に渡るため。
 *具体的にはサブクラス内でグローバルブロック変数を定義等。
 */

-(void)onSelectButton:(id)sender{
    int _cost = [[arrCost objectAtIndex:[sender tag]] intValue];
    NSString *_titleView = @"購入手続";
    NSString *_message = [NSString stringWithFormat:@"このアイテムを購入しますか？\n%d個の%@が必要です", _cost, nameCurrency];
    viewWantBuy =
    [CreateComponentClass
     createAlertView2:self.view.bounds
     dialogRect:CGRectMake(0, 0,
                           self.view.bounds.size.width-20,
                           self.view.bounds.size.width-100)
     title:_titleView
     message:_message
     onYes:^{
         //購入プロセス
         [self buyBtnPressed:sender];
         
         [viewWantBuy removeFromSuperview];
         
     }
     onNo:^{
         [viewWantBuy removeFromSuperview];
     }];
    
    [self.view addSubview:viewWantBuy];
    
}


-(void)buyBtnPressed:(id)sender{//arg:selected-item-list-no
    if([[attr getValueFromDevice:@"gold"] intValue] >= [[arrCost objectAtIndex:[sender tag]] intValue]){
        int cost = [[arrCost objectAtIndex:[sender tag]] intValue];
        NSLog(@"buy button pressed : %d", [sender tag]);
        [self updateToDeviceCoin:[[attr getValueFromDevice:@"gold"] intValue] - cost];//[attr setValueToDev..
        [self displayCoin];//tv.text = ...
        
        //データの反映
        [self processAfterBtnPressed:[itemList objectAtIndex:[sender tag]]];
        //反映されたデータから複数パールを表示
        [self displaySmallIcon:[sender tag]];//アイテムの購入個数
        
    }else{
        //コインが足りない場合
        [self oscillateTextViewGold:9];
        
        //コインはゲームで取得するか購入することができますメッセージダイアログボックス
#ifdef PaymentAllowMode
        viewForCoinShort =
        [CreateComponentClass
         createAlertView:CGRectMake(10, 10,
                                    self.view.bounds.size.width-10,
                                    self.view.bounds.size.height)
         dialogRect:CGRectMake(10, 10,
                               self.view.bounds.size.width-30,
                               self.view.bounds.size.width-30)//正方形：縦＝横
         title:@"コインが不足しています。"
         message:@"コインを購入しますか？"
         titleYes:@"購入"
         titleNo:@"戻る"
         onYes:actYesForCoinShort
         onNo:actNoForCoinShort
         ];
        
        viewForCoinShort.center =
        CGPointMake(self.view.bounds.size.width/2,
                    self.view.bounds.size.height/2);
        [self.view addSubview:viewForCoinShort];
#endif
        
    }
    
}

/*
 *保有記録にフラグ１を立てる
 */
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

-(void)pushedCashFrame:(UITapGestureRecognizer *)recognizer{
    CoinProductViewController * coinView =
    [[CoinProductViewController alloc] init];
    [self presentViewController:coinView animated:YES completion:nil];
    
}


/*
 *購入した個数だけuvOnScrollに表示するメソッド
 *描画する場所はunOnScrollの絶対位置で指定(eachFrameではない点に注意：eachFrameをグローバルにするよりuvOnScrollをグローバルにした方が効率的だった)
 */
-(void)displaySmallIcon:(int)_noOfItemList{
    
    /*
     *viewSmallIcon: name of png file
     */
    //smallicon:説明文の下に幾つ購入したかを示すスモールアイコン(星かパール)
    
    int sumOfItemBought = [[attr getValueFromDevice:itemList[_noOfItemList]] integerValue];//各itemlistの値
    int intervalSmallIcon = smallIconHeight*2/3;//width = height & small icon is too much margin so here needs one of width
    NSLog(@"itemlist%d=%@, num of item bought = %d", _noOfItemList, itemList[_noOfItemList], sumOfItemBought);
    for(int _num = 0; _num < sumOfItemBought;_num++){
        UIImageView *ivSmallIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, smallIconHeight, smallIconHeight)];
        ivSmallIcon.image = [UIImage imageNamed:strSmallIcon];
        ivSmallIcon.center = CGPointMake(textViewInitX + _num * intervalSmallIcon + 10,
                                         itemFrameInitY +  _noOfItemList * (itemFrameHeight + itemFrameInterval) + textViewHeight+1);
        //itemFrameInitY + i * (itemFrameHeight + itemFrameInterval),// + 10,
        [uvOnScroll addSubview:ivSmallIcon];
    }
}

@end
