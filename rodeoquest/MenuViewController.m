//
//  ItemSelectViewController.m
//  Shooting5
//
//  Created by 遠藤 豪 on 13/10/07.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

//#define TEST//TestViewController-transition


#import "MenuViewController.h"


//#define COMPONENT_00 0
//#define COMPONENT_01 1
//#define COMPONENT_02 2
//#define COMPONENT_03 3
//#define COMPONENT_04 4
//#define COMPONENT_05 5
//#define COMPONENT_06 6
//#define COMPONENT_07 7
//#define COMPONENT_08 8
//#define COMPONENT_09 9
//#define COMPONENT_10 10

//#define AD_UPPER

#define MARGIN_UPPER_COMPONENT 5
#ifdef AD_UPPER
    #define Y_MOST_UPPER_COMPONENT 53//広告縦幅50
#else
    #define Y_MOST_UPPER_COMPONENT 3//53//広告縦幅50
#endif
#define W_MOST_UPPER_COMPONENT 100
#define H_MOST_UPPER_COMPONENT 50

#define MARGIN_UPPER_TO_RANKING 2

#define W_RANKING_COMPONENT 300
#define H_RANKING_COMPONENT 200

#define MARGIN_RANKING_TO_FORMAL_BUTTON 10

#define SIZE_FORMAL_BUTTON 60
#define INTERVAL_FORMAL_BUTTON 10

#define MARGIN_FORMAL_TO_START 2

#define W_BT_START 150
#define H_BT_START 60

#define ALPHA_COMPONENT 0.5

#define WEAPON_BUY_COUNT 10

int x_frame_center;//画面横軸中心値
NSTimer *tm;
UITextView *tv_timer;
UILabel *lbl_gameLife;
int secondForLife;
int maxSecondForLife;
int lifeGame;
int maxLifeGame;
//NSMutableArray *imageFileArray;
//NSMutableArray *tagArray;
NSMutableArray *arrNoImage;
NSMutableArray *arrBtnBack;


//game-start-button
UIButton *bt_start;

UIView *subView;
UIButton *closeButton;//閉じるボタン
BGMClass *bgmClass;
BackGroundClass2 *backGround;
UIImageView *ivBackChara;
AttrClass *attr;

UITextView *tvLevelAmount;
UITextView *tvScoreAmount;
UITextView *tvGoldAmount_global;//金額はメニュー画面内で更新するのでグローバルに宣言しておく(武器やアイテムの購入等)



//ユーザー要望
UIView *viewMailSuperForm;
UITextView* tvSubject;
UITextView* tvDemand;
NSString *strSubject = @"個人が特定されることはありません。お名前は匿名でも結構です。";
NSString *strDemand = @"アプリの品質向上のためにこちらにご要望をお書き下さい。\n頂いたご意見はアプリの改善に役立てるためだけに用い、他の用途には使用しません。\nご協力ありがとうございます。";
//dialog
UIView *viewForDialog;


//ゲーム開始可能フラグ：bt_startボタンを連打できないように(他の代替案としてはbt_startボタンを押したらgotoGameメソッド実行までタッチ不可能な透明板を張る)
BOOL isStartable;//viewWillAppearで初期化：(続けて押せてしまうとlifeGameが何度も減ってしまう)




//CreateComponentClass *createComponentClass;

@interface MenuViewController ()

@end


//コンポーネント動的配置：http://d.hatena.ne.jp/mohayonao/20100719/1279524706
@implementation MenuViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //back ground music
//        audioPlayerCapture = [self getAVAudioPlayer:@"mySoundEffects.caf" ];
//        [audioPlayerCapture prepareToPlay];
        
        
        //本来ならここに全ての変数を定義し、viewWillAppearもしくはその前のviewDidLoadでaddSubviewすべき。
//        ivBackChara = [[UIImageView alloc] initWithFrame:CGRectMake(-110, -10, 544, 400)];
//        ivBackChara.image = [UIImage imageNamed:@"chara01.png"];
//        ivBackChara.center = self.view.center;//CGPointMake(self.view.center.x, self.view.center.y);
//        //    iv_back.alpha = ALPHA_COMPONENT;
//        [self.view sendSubviewToBack:ivBackChara];
//        [self.view addSubview:ivBackChara];
//
//        [self animAirViewUp];

        
        
    }
    return self;
}


- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController {
    
//	[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:NO completion:nil];//itemSelectVCのpresentViewControllerからの場合
}


//ステータスバー非表示の一環
- (BOOL)prefersStatusBarHidden {
    return YES;
}

//admob関連
- (void)viewDidUnload {
    // ARCが有効の場合は、以下のbannerView_ のリリースは不要
    bannerView_.delegate = nil;
}

- (void)dealloc {

}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"adView:didFailToReceiveAdWithError:%@", [error localizedDescription]);
    
    // 他の広告ネットワークの広告を表示させるなど。
}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    // 他の広告ネットワーク用のビューの非表示など。
    
    NSLog(@"adViewDidReceivedAd");
    // 表示位置
    [UIView animateWithDuration:0.3
                     animations:^{
                         bannerView.frame = CGRectMake(0.0,
                                                       self.view.frame.size.height -
                                                       bannerView.frame.size.height,
                                                       bannerView.frame.size.width,
                                                       bannerView.frame.size.height);
                     }];
}

//viewDidLoad:viewが初めて呼び出される時に一度だけ実行される(その後にviewWillAppear,viewDidAppear実行：表示の度)
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //ホームボタンが押されたらonPressedHomeButtonを実行
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onPressedHomeButton:)
                                                 name:UIApplicationWillResignActiveNotification//UIApplicationWillTerminateNotification
                                               object:app];
    
    
    //admob
    
    //deviceID:52aefdfc304953d5ec510b1d5fb41806c4942f83
    
    // サイズを指定してAdMob広告のインスタンスを生成
    // 指定できる広告サイズは、GADAdSize.h か https://developers.google.com/mobile-ads-sdk/docs/admob/intermediate を参考に。
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];//縦
#ifdef AD_UPPER
    //画面上部に配置
    bannerView_.frame = CGRectMake(0, 0,
                                   bannerView_.bounds.size.width,
                                   bannerView_.bounds.size.height);
#else
    //画面下部に配置
    bannerView_.frame = CGRectMake(0, self.view.bounds.size.height - bannerView_.bounds.size.height,
                                   bannerView_.bounds.size.width,
                                   bannerView_.bounds.size.height);
#endif
//    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBanner];
    
    // AdMobのパブリッシャーIDを指定
    bannerView_.adUnitID = @"ca-app-pub-2428023138794278/3840801740";//nend
    
    // AdMob広告を表示するUIViewController(自分自身)の指定し、ビューに広告を追加
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    
    // 広告をビューの一番下に表示する場合
    //[bannerView_ setCenter:CGPointMake(self.view.bounds.size.width/2,
    //                                   self.view.bounds.size.height-bannerView_.bounds.size.height/2)];
    
    // AdMob広告データの読み込みを要求
    GADRequest *request = [GADRequest request];
//    request.testing = YES;
//    request.testDevices = [NSArray arrayWithObjects:
//                           GAD_SIMULATOR_ID,                               // シミュレータ
//                           @"TEST_DEVICE_ID",                              // iOS 端末をテスト
//                           nil];
//    request.testDevices = @[ @"d42e39771eb546945bbd35e0f9cfa39e" ];
    request.testDevices = [NSArray arrayWithObjects:
                           GAD_SIMULATOR_ID,
                           @"d850cff511c013cdcf44a5b2c294c80ff1939605", nil];
//                           @"d42e39771eb546945bbd35e0f9cfa39e", nil];
//                           @"52aefdfc304953d5ec510b1d5fb41806c4942f83", nil];
//                           GAD_SIMULATOR_ID,
////                           @"d42e39771eb546945bbd35e0f9cfa39e", nil];
//                           @"52aefdfc304953d5ec510b1d5fb41806c4942f83", nil];
//    52aefdfc304953d5ec510b1d5fb41806c4942f83
//    d42e39771eb546945bbd35e0f9cfa39e
    
//    [bannerView_ loadRequest:[GADRequest request]];
    [bannerView_ loadRequest:request];

    
    //admob終了
    
    
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
    
    attr = [[AttrClass alloc]init];
    
    

//    imageFile = [[NSMutableArray alloc]init];
//    _imageFile = [NSArray arrayWithObjects:@"red.png", @"blue_item_yuri_big.png", nil];
    arrNoImage = [NSMutableArray arrayWithObjects:
                  [NSArray arrayWithObjects:
                       [NSNumber numberWithInt:ButtonMenuImageTypeWeapon],
                       [NSNumber numberWithInt:ButtonMenuImageTypeDefense],
                       [NSNumber numberWithInt:ButtonMenuImageTypeItem],//item-time-up
                       [NSNumber numberWithInt:ButtonMenuImageTypeWpnUp],//weapon-time-up
                       nil],
                      [NSArray arrayWithObjects:
                       [NSNumber numberWithInt:ButtonMenuImageTypeInn],
                       [NSNumber numberWithInt:ButtonMenuImageTypeCoin],
                       [NSNumber numberWithInt:ButtonMenuImageTypeSet],
                       [NSNumber numberWithInt:ButtonMenuImageTypeDemand],
                       nil],
                      nil];
    arrBtnBack = [NSMutableArray arrayWithObjects:
                  [NSArray arrayWithObjects:
                   [NSNumber numberWithInt:ButtonMenuBackTypeBlue],
                   [NSNumber numberWithInt:ButtonMenuBackTypeGreen],
                   [NSNumber numberWithInt:ButtonMenuBackTypeGreen],
                   [NSNumber numberWithInt:ButtonMenuBackTypeGreen],
                   nil],
                  [NSArray arrayWithObjects:
                   [NSNumber numberWithInt:ButtonMenuBackTypeGreen],
                   [NSNumber numberWithInt:ButtonMenuBackTypeOrange],
                   [NSNumber numberWithInt:ButtonMenuBackTypeOrange],
                   [NSNumber numberWithInt:ButtonMenuBackTypeBlue],
                   nil],
                  nil];
                   
//    NSLog(@"imageFileArray initialization complete");
    
//    tagArray = [NSMutableArray arrayWithObjects:
//                [NSArray arrayWithObjects:@"200", @"201", @"202", @"203", nil],
//                [NSArray arrayWithObjects:@"210", @"211", @"212", @"213", nil],
//                [NSArray arrayWithObjects:@"220", @"221", @"222", @"223", nil],
//                [NSArray arrayWithObjects:@"230", @"231", @"232", @"233", nil],
//                nil];
//    NSLog(@"tagArray initialization complete");

	// Do any additional setup after loading the view.
    
    
    x_frame_center = (int)[[UIScreen mainScreen] bounds].size.width/2;
    //    NSLog(@"%d" , x_frame_center);
    //    int y_frame_center = (int)[[UIScreen mainScreen] bounds].size.height/2;//使用しない？
    //    NSLog(@"中心＝%d", (int)[[UIScreen mainScreen] bounds].origin.x);
    
    //背景作成
    //    UIImageView *iv_back = [self createImageView:@"chara_test2.png" tag:0 frame:[[UIScreen mainScreen] bounds]];
    //    UIImageView *iv_back = [self createImageView:@"chara01.png" tag:0 frame:CGRectMake(-110, -10, 680, 500)];
    //    UIImageView *iv_back = [[UIImageView alloc] initWithFrame:CGRectMake(-110, -10, 680, 500)];
    
    
    //_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    //_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    //_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    
    //背景描画
    [self setBackGroundInit];
    
    
    //上段数字部分の更新
    
    //数字の大きさ
    int sizeNumeric = 16;
    
    //レベル表示部分:枠
    UIView *v_level =
    [CreateComponentClass createView:CGRectMake(x_frame_center - MARGIN_UPPER_COMPONENT - W_MOST_UPPER_COMPONENT*3/2,
                                                Y_MOST_UPPER_COMPONENT,
                                                W_MOST_UPPER_COMPONENT,
                                                H_MOST_UPPER_COMPONENT)];
    [self.view addSubview:v_level];
    //レベル表示部分:ラベル
    CGRect rectLevelLabel = CGRectMake(x_frame_center - MARGIN_UPPER_COMPONENT - W_MOST_UPPER_COMPONENT*3/2 + 3,
                                       Y_MOST_UPPER_COMPONENT + H_MOST_UPPER_COMPONENT - 50,
                                       W_MOST_UPPER_COMPONENT,
                                       H_MOST_UPPER_COMPONENT);
    UITextView *tvLevelLabel = [CreateComponentClass createTextView:rectLevelLabel
                                                               text:@"Lv."
                                                               font:@"AmericanTypewriter-Bold"
                                                               size:15
                                                          textColor:[UIColor whiteColor]
                                                          backColor:[UIColor clearColor]
                                                         isEditable:NO];
    [self.view addSubview:tvLevelLabel];
    
    //レベル表示部分:数字
    CGRect rectLevelAmount = CGRectMake(x_frame_center - MARGIN_UPPER_COMPONENT - W_MOST_UPPER_COMPONENT*3/2 + 10,
                                        Y_MOST_UPPER_COMPONENT + H_MOST_UPPER_COMPONENT - 30,
                                        W_MOST_UPPER_COMPONENT,
                                        H_MOST_UPPER_COMPONENT);
    
    //if level < 89 then display the level, else display "MAX"
    
//    NSString *strLevel = [NSString stringWithFormat:@"%d", [[attr getValueFromDevice:@"level"] intValue]];
    NSString *strLevel = [attr getValueFromDevice:@"level"];
    tvLevelAmount = [CreateComponentClass createTextView:rectLevelAmount
                                                                text:[NSString stringWithFormat:@"\n%@",strLevel]
                                                                font:@"AmericanTypewriter-Bold"
                                                                size:sizeNumeric
                                                           textColor:[UIColor whiteColor]
                                                           backColor:[UIColor clearColor]
                                                          isEditable:NO];
    tvLevelAmount.textAlignment = NSTextAlignmentRight;
    tvLevelAmount.center =
    CGPointMake(v_level.center.x, v_level.center.y + v_level.bounds.size.height/2);
//    tvLevelAmount.backgroundColor = [UIColor colorWithRed:0.5f green:0 blue:0 alpha:0.3f];
    [self.view addSubview:tvLevelAmount];
    
    
    
    //スコア表示部分:枠
    UIView *v_tokuten =
    [CreateComponentClass createView:CGRectMake(x_frame_center - W_MOST_UPPER_COMPONENT/2,
                                                Y_MOST_UPPER_COMPONENT,
                                                W_MOST_UPPER_COMPONENT,
                                                H_MOST_UPPER_COMPONENT)];
    [self.view addSubview:v_tokuten];
    //スコア表示部分:ラベル
    CGRect rectScoreLabel = CGRectMake(x_frame_center - W_MOST_UPPER_COMPONENT/2 + 3,
                                       Y_MOST_UPPER_COMPONENT + H_MOST_UPPER_COMPONENT - 50,
                                       W_MOST_UPPER_COMPONENT,
                                       H_MOST_UPPER_COMPONENT);
    UITextView *tvScoreLabel = [CreateComponentClass createTextView:rectScoreLabel
                                                               text:@"Exp."
                                                               font:@"AmericanTypewriter-Bold"
                                                               size:15
                                                          textColor:[UIColor whiteColor]
                                                          backColor:[UIColor clearColor]
                                                         isEditable:NO];
    [self.view addSubview:tvScoreLabel];
    
    //スコア表示部分:数字
    CGRect rectScoreAmount = CGRectMake(x_frame_center - W_MOST_UPPER_COMPONENT/2 + 10,
                                        Y_MOST_UPPER_COMPONENT + H_MOST_UPPER_COMPONENT - 30,
                                        W_MOST_UPPER_COMPONENT,
                                        H_MOST_UPPER_COMPONENT);
    
//    NSString *strExp = [NSString stringWithFormat:@"%09d", [[attr getValueFromDevice:@"exp"]
//                                                            intValue]];
    NSString *strExp = [attr getValueFromDevice:@"exp"];
    if([strExp isEqualToString:@"9999"]){//レベルがマックスになると経験値は9999にセットした@AttrClass
        strExp = @"MAX";
    }
    
    tvScoreAmount = [CreateComponentClass createTextView:rectScoreAmount
                                                                text:strExp
                                                                font:@"AmericanTypewriter-Bold"
                                                                size:sizeNumeric
                                                           textColor:[UIColor whiteColor]
                                                           backColor:[UIColor clearColor]
                                                          isEditable:NO];
    tvScoreAmount.textAlignment = NSTextAlignmentRight;
    tvScoreAmount.center = CGPointMake(v_tokuten.center.x,
                                       v_tokuten.center.y + v_tokuten.bounds.size.height/2);
    [self.view addSubview:tvScoreAmount];
    
    
    //獲得ゴールド数表示部分
    UIView *v_gold =
    [CreateComponentClass createView:CGRectMake(x_frame_center + MARGIN_UPPER_COMPONENT + W_MOST_UPPER_COMPONENT/2,
                                                Y_MOST_UPPER_COMPONENT,
                                                W_MOST_UPPER_COMPONENT,
                                                H_MOST_UPPER_COMPONENT)];
    [self.view addSubview:v_gold];
    //ゴールド表示部分:ラベル
    //ラベル影
//    CGRect rectGoldLabel2 = CGRectMake(x_frame_center + MARGIN_UPPER_COMPONENT + W_MOST_UPPER_COMPONENT/2 + 7,    //影を先に付ける
//                                       Y_MOST_UPPER_COMPONENT + H_MOST_UPPER_COMPONENT - 46,
//                                       W_MOST_UPPER_COMPONENT,
//                                       H_MOST_UPPER_COMPONENT);
//    UITextView *tvGoldLabel2 = [CreateComponentClass createTextView:rectGoldLabel2
//                                                               text:@"Zeny."
//                                                               font:@"AmericanTypewriter-Bold"
//                                                               size:15
//                                                          textColor:[UIColor blackColor]
//                                                          backColor:[UIColor clearColor]
//                                                         isEditable:NO];
//    [self.view addSubview:tvGoldLabel2];
    
    //ラベル本文
    CGRect rectGoldLabel = CGRectMake(x_frame_center + MARGIN_UPPER_COMPONENT + W_MOST_UPPER_COMPONENT/2 + 3,
                                      Y_MOST_UPPER_COMPONENT + H_MOST_UPPER_COMPONENT - 50,
                                      W_MOST_UPPER_COMPONENT,
                                      H_MOST_UPPER_COMPONENT);
    UITextView *tvGoldLabel = [CreateComponentClass createTextView:rectGoldLabel
                                                              text:@"Zeny."
                                                              font:@"AmericanTypewriter-Bold"
                                                              size:15
                                                         textColor:[UIColor whiteColor]
                                                         backColor:[UIColor clearColor]
                                                        isEditable:NO];
    [self.view addSubview:tvGoldLabel];
    
    
    
    
    //ゴールド表示部分:数字
    CGRect rectGoldAmount = CGRectMake(x_frame_center + MARGIN_UPPER_COMPONENT + W_MOST_UPPER_COMPONENT/2 + 10,
                                       Y_MOST_UPPER_COMPONENT + H_MOST_UPPER_COMPONENT - 30,
                                       W_MOST_UPPER_COMPONENT,
                                       H_MOST_UPPER_COMPONENT);
    NSString *strGold = [NSString stringWithFormat:@"%d", [[attr getValueFromDevice:@"gold"] intValue]];
    tvGoldAmount_global = [CreateComponentClass createTextView:rectGoldAmount
                                                          text:strGold
                                                          font:@"AmericanTypewriter-Bold"
                                                          size:sizeNumeric
                                                     textColor:[UIColor whiteColor]
                                                     backColor:[UIColor clearColor]
                                                    isEditable:NO];
    tvGoldAmount_global.textAlignment = NSTextAlignmentRight;
    tvGoldAmount_global.center =
    CGPointMake(v_gold.center.x,
                v_gold.center.y + v_gold.bounds.size.height/2);
    [self.view addSubview:tvGoldAmount_global];
    
    
    
    
    //ランキング表示部分
    CGRect rect_ranking = CGRectMake(x_frame_center - W_RANKING_COMPONENT / 2,
                                     Y_MOST_UPPER_COMPONENT + H_MOST_UPPER_COMPONENT + MARGIN_UPPER_TO_RANKING,
                                     W_RANKING_COMPONENT,
                                     H_RANKING_COMPONENT);
    //    UIView *v_ranking = [CreateComponentClass createView:rect_ranking];
    UIView *v_ranking = [CreateComponentClass createViewWithFrame:rect_ranking
                                                            color:[UIColor colorWithRed:0 green:0 blue:0 alpha:ALPHA_COMPONENT]
                                                              tag:100//行数は０、１、２の１番目
                                                           target:self
                                                         selector:@"imageTapped:"];
    [self.view addSubview:v_ranking];
    
    UIImageView *viewOrnament =
    [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    viewOrnament.image = [UIImage imageNamed:@"frame02.png"];
    [v_ranking addSubview:viewOrnament];
    
    
    //    NSLog(@"count = %d", [[imageFileArray objectAtIndex:0] count]);
    
    //各種アイコン表示部分
    for(int row = 0; row < [arrNoImage count];row++){
        //        NSLog(@"row = %d", row);
        
        for(int col = 0; col < [[arrNoImage objectAtIndex:row] count] ;col++){
            //            NSLog(@"row = %d, col = %d", row, col);
            CGRect rect_bt = CGRectMake(
                                        x_frame_center - (SIZE_FORMAL_BUTTON + INTERVAL_FORMAL_BUTTON) * [[arrNoImage objectAtIndex:0] count]/2 +
                                        (SIZE_FORMAL_BUTTON + INTERVAL_FORMAL_BUTTON) * col,
                                        
                                        Y_MOST_UPPER_COMPONENT + H_MOST_UPPER_COMPONENT + MARGIN_UPPER_TO_RANKING +
                                        H_RANKING_COMPONENT + MARGIN_RANKING_TO_FORMAL_BUTTON +
                                        (SIZE_FORMAL_BUTTON + INTERVAL_FORMAL_BUTTON) * row,
                                        
                                        SIZE_FORMAL_BUTTON,
                                        SIZE_FORMAL_BUTTON);
            
            UIImageView *bt = [CreateComponentClass createMenuButton:[[[arrBtnBack objectAtIndex:row]
                                                                       objectAtIndex:col] intValue]
                                                           imageType:[[[arrNoImage objectAtIndex:row] objectAtIndex:col] intValue]
                                                                rect:rect_bt
                                                              target:self
                                                            selector:@"pushedButton:"
                                                                 tag:[[[arrNoImage objectAtIndex:row] objectAtIndex:col] intValue]];
            
            [self.view addSubview:bt];
        }
    }
    
    
    //スタートボタン表示部分
    CGRect rect_start = CGRectMake(x_frame_center - W_BT_START/2,
                                   Y_MOST_UPPER_COMPONENT + H_MOST_UPPER_COMPONENT + MARGIN_UPPER_TO_RANKING +
                                   H_RANKING_COMPONENT + MARGIN_RANKING_TO_FORMAL_BUTTON +
                                   (SIZE_FORMAL_BUTTON + INTERVAL_FORMAL_BUTTON) * [arrNoImage count] + MARGIN_FORMAL_TO_START,
                                   W_BT_START,
                                   H_BT_START);
    
    bt_start =
    [UIButton buttonWithType:UIButtonTypeCustom];
    bt_start.frame = rect_start;
    [bt_start setBackgroundImage:[UIImage imageNamed:@"start_r.png"]
                        forState:UIControlStateNormal];
    [bt_start addTarget:self
                 action:@selector(pushedStartButton:)
       forControlEvents:UIControlEventTouchUpInside];
    [bt_start addTarget:self
                 action:@selector(selectingStartButton:)
       forControlEvents:UIControlEventTouchDown];
    [bt_start addTarget:self
                 action:@selector(releasedStartButton:)
       forControlEvents:UIControlEventTouchUpOutside];
    [bt_start addTarget:self
                 action:@selector(releasedStartButton:)
       forControlEvents:UIControlEventTouchDragOutside];
    [bt_start addTarget:self
                 action:@selector(releasedStartButton:)
       forControlEvents:UIControlEventTouchDragExit];
    [bt_start addTarget:self
                 action:@selector(selectingStartButton:)
       forControlEvents:UIControlEventTouchDragInside];//ドラッグして戻ってきた時にサイズを大きくする
    [self.view addSubview:bt_start];
    
    
    //lifeを表示する背景の影の部分を表示する
    UIView *shadowView =
    [CreateComponentClass
     createShadowView:CGRectMake(0, 0, W_BT_START/3, H_BT_START/3)//3分の1のサイズ
     viewColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.95f]
     borderColor:[UIColor whiteColor]
     text:@"" textSize:13];
    [bt_start addSubview:shadowView];
    
    
    
    //game開始以外でも、ホームボタン押下時、アイテムリストViewCon起動時等、様々なイベント(MenuViewConが消えるイベント)毎にsetValueToDeviceをする。
    //null判定等の例外(アプリ初期起動時対応等も)
    //secondForLifeが１秒に何度も引かれる自体(複数のスレッドによるバグ？)を控除or,secondForLife--ではなく、hmsMenuLastOpenからの経過時間を逐次計算する至要にするなど。
    //gameLife-display
    maxLifeGame = 6;//const要修正
    //本来ならシステム時計を読み込んで次のlifeUpまでの時間を計測
    maxSecondForLife = 360;//6minutes:const要修正
    //secondForLifeはこの後viewWillAppear内でシステム時間を取得して更新
    secondForLife = maxSecondForLife;//equal to 6minutes
    
    NSString *strLifeGame =
    [NSString stringWithFormat:@"%@ ／ %d",
    [attr getValueFromDevice:@"lifeGame"],
     maxLifeGame];
    
    
    lbl_gameLife =
    [[UILabel alloc]
     initWithFrame:
     CGRectMake(0, 0, shadowView.bounds.size.width,
                shadowView.bounds.size.height)];
    lbl_gameLife.text = strLifeGame;
    lbl_gameLife.font = [UIFont fontWithName:@"AmericanTypewriter-Bold"
                         size:15.0f];
//    lbl_gameLife.textColor = [UIColor purpleColor];
    lbl_gameLife.textColor = [UIColor whiteColor];
    lbl_gameLife.backgroundColor = [UIColor clearColor];
    lbl_gameLife.center =
    CGPointMake(shadowView.bounds.size.width/2,
                shadowView.bounds.size.height/2);
    lbl_gameLife.textAlignment = NSTextAlignmentCenter;
    
    [shadowView addSubview:lbl_gameLife];
    
    
    
    
    CGRect rect_timer =
    CGRectMake(x_frame_center - W_BT_START/2 - MARGIN_UPPER_COMPONENT*2 - H_BT_START,
               Y_MOST_UPPER_COMPONENT + H_MOST_UPPER_COMPONENT + MARGIN_UPPER_TO_RANKING +
               H_RANKING_COMPONENT + MARGIN_RANKING_TO_FORMAL_BUTTON +
               (SIZE_FORMAL_BUTTON + INTERVAL_FORMAL_BUTTON) * [arrNoImage count] + MARGIN_FORMAL_TO_START,
               H_BT_START, H_BT_START);
    //startボタンの横にtimer
    UIView *viewForTimer =
    [CreateComponentClass
     createView:rect_timer];
    
    [self.view addSubview:viewForTimer];
    
    tv_timer =
    [CreateComponentClass
     createTextView:viewForTimer.bounds
     text:@"MAX"
     font:@"AmericanTypewriter-Bold"
     size:15
     textColor:[UIColor whiteColor]
     backColor:[UIColor clearColor]
     isEditable:NO];
    tv_timer.textAlignment = NSTextAlignmentCenter;
    //    [tv_timer setContentVerticalAlignment:UIControlContentHorizontalAlignmentCenter];
    [viewForTimer addSubview:tv_timer];
    
    //時間を買うためのコイン購入ページへの誘導イベントの駆動コンポーネント
    UIView *viewTimer =
    [CreateComponentClass
     createViewWithFrame:rect_timer
     color:[UIColor clearColor]
     tag:101
     target:self
     selector:@"imageTapped:"];
    [self.view addSubview:viewTimer];
    
    
    
    //invitation of friends by app-socially
    //    UIView *v_ranking = [CreateComponentClass createView:rect_ranking];
    UIView *viewInvite =
    [CreateComponentClass
     createViewWithFrame:CGRectMake(0, 0, H_BT_START, H_BT_START)
     color:[UIColor colorWithRed:0 green:0 blue:0 alpha:ALPHA_COMPONENT]
     tag:102//invite
     target:self
     selector:@"imageTapped:"];
    viewInvite.center =
    CGPointMake(x_frame_center + W_BT_START/2 + MARGIN_UPPER_COMPONENT*2 + H_BT_START/2,
                bt_start.center.y);
    [self.view addSubview:viewInvite];
    //invitation mark(View)
    UIImageView *ivInvite =
    [[UIImageView alloc]
     initWithFrame:
     CGRectMake(0, 0, viewInvite.bounds.size.width/2, viewInvite.bounds.size.height/2)];
    ivInvite.center =
    CGPointMake(viewInvite.bounds.size.width/2,
                viewInvite.bounds.size.height/2);
    ivInvite.image = [UIImage imageNamed:@"Add_contact_user.png"];
    [viewInvite addSubview:ivInvite];
    

    
    
    //キャラ変更部分(購入部分)
    
    
    //機体数増加部分(購入ページ)
    
    //timer起動部分
    if(tm != nil){
        [tm invalidate];
        tm = nil;
    }
    tm = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                          target:self
                                        selector:@selector(time:)//タイマー呼び出し
                                        userInfo:nil
                                         repeats:YES];
    
}//viewdidload
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [tm invalidate];
    
    NSLog(@"view will disappear at menuviewcontroller");
    
    
    
}

//画面が表示される度に起動
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"viewWillAppear");
    [super viewWillAppear:animated];
    
    isStartable = true;//ゲームスタート可能にする
    
    //timer drive
    if(tm != nil){
        [tm invalidate];
        tm = nil;
    }
    tm = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                          target:self
                                        selector:@selector(time:)//タイマー呼び出し
                                        userInfo:nil
                                         repeats:YES];

    //background
    [self setBackGroundInit];
    //次に描画するため
    //http://stackoverflow.com/questions/4175729/run-animation-every-time-app-is-opened
    //In iOS 4, pressing the home button doesn't terminate the app, it suspends it. When the app is made active again, a UIApplicationDidBecomeActiveNotification is posted. Register for that notification and initiate the animation in you
    //アプリが表示されたらsetBackGroundInitとviewWillAppearを実行
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(setBackGroundInit)
     name:UIApplicationDidBecomeActiveNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(viewWillAppear:)
     name:UIApplicationDidBecomeActiveNotification
     object:nil];
    
    //exp, level, goldの更新
//    tvLevelAmount.text = [NSString stringWithFormat:@"%09d", [[attr getValueFromDevice:@"level"] intValue]];
//    tvGoldAmount_global.text = [NSString stringWithFormat:@"%09d", [[attr getValueFromDevice:@"gold"] intValue]];
//    tvScoreAmount.text = [NSString stringWithFormat:@"%09d", [[attr getValueFromDevice:@"exp"] intValue]];
    if([[attr getValueFromDevice:@"level"] intValue] < [attr getMaxLevel]){
        tvLevelAmount.text = [NSString stringWithFormat:@"%d", [[attr getValueFromDevice:@"level"] intValue]];
        tvScoreAmount.text = [NSString stringWithFormat:@"%d", [[attr getValueFromDevice:@"exp"] intValue]];
    }else{
        tvLevelAmount.text = @"MAX";
        tvScoreAmount.text = @"MAX";
    }
    
    tvGoldAmount_global.text = [NSString stringWithFormat:@"%d", [[attr getValueFromDevice:@"gold"] intValue]];

    [self updateLifeAndSecond];
    
}

//実行されない？
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIApplicationDidBecomeActiveNotification
     object:nil];
    

}
-(void)viewDidAppear:(BOOL)animated{
//    [self.view.subviews removeFromSuperview];
    
    
    
    //ホームボタン押下後の再開時に以下の登録したメソッドから開始する
//    [[NSNotificationCenter defaultCenter]
//     addObserver:self
////     selector:@selector(applicationDidBecomeActive)
//     selector:@selector(viewDidAppear:)
//     name:UIApplicationDidBecomeActiveNotification
//     object:nil];
    
    [self.view bringSubviewToFront:bannerView_];
    
    //時間を遅らせてBGM
    [self performSelector:@selector(playBGM) withObject:nil afterDelay:0.3];

//    NSLog(@"init select view controller start!!");
    
    NSLog(@"now = %@ : %@",
          [self getYYYYMMDD],
          [self getHHMMSS]);
    
    NSLog(@"ItemViewController start");
}//viewDidLoad

- (void)time:(NSTimer*)timer{//every-1sec
    
//    NSLog(@"timer = %@", tv_timer.text);
    //DFの場合、次のlifeUpまでの時間は12分=720sec
    NSLog(@"secondForlife = %d, lifeGame=%d",
          secondForLife, lifeGame);
    if(lifeGame < maxLifeGame){
        if(secondForLife > 0){
            secondForLife --;//every1second
            //attrに書き込む必要あり
            //        NSLog(@"secondForLife decrease to = %d" , secondForLife);
            tv_timer.text =
            [self transformSecToMMSS:secondForLife];
            if(secondForLife == 0){
                secondForLife = maxSecondForLife;
                if(lifeGame < maxLifeGame){
                    lifeGame++;
                    [attr setValueToDevice:@"lifeGame" strValue:[NSString stringWithFormat:@"%d",lifeGame]];
                    lbl_gameLife.text = [NSString stringWithFormat:@"%d", lifeGame];
                    if(lifeGame == maxLifeGame){
                        tv_timer.text = @"MAX";
                    }
                }
            }
        }else{
            tv_timer.text = @"MAX";
        }
    }else{//lifeGame == maxLifeGame
//        lbl_gameLife.text = [NSString stringWithFormat:@"MAX"];
//        secondForLife = maxSecondForLife;
        [self updateLifeAndSecond];
    }
    
}
/*
 *与えられた秒数から次のlifeUpまでの分秒数を返す
 *dfの場合、X:00で返される(minutesのフォーマットは00ではない)
 */
-(NSString *)transformSecToMMSS:(int)_second{
    NSString *minuteForReturn = 0;
    NSString *secondForReturn = 0;
    if(_second > 0){
        minuteForReturn = [NSString stringWithFormat:@"%d",_second/60];
        secondForReturn = [NSString stringWithFormat:@"%02d",
                           _second - minuteForReturn.integerValue * 60];
        return [NSString stringWithFormat:@"%@:%@",
                minuteForReturn,
                secondForReturn];
    }else {
        return @"0:00";
    }
    
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)gotoGame{
    [backGround exitAnimations];
//    GameClassViewController *gameView = [[GameClassViewController alloc] init];
//    [self presentViewController: gameView animated:NO completion: nil];//if "animated"=YES then background perform incorrect
    GameClassViewController2 *gameView = [[GameClassViewController2 alloc]init];
    [self presentViewController:gameView animated:NO completion:nil];

//    [backGround exitAnimations];

}
//ボタン押下時のサイズ反応
-(void)selectingStartButton:(id)sender{
    bt_start.transform = CGAffineTransformMakeScale(1.1f, 1.2f);//vertical-expand
    
}
-(void)releasedStartButton:(id)sender{
    bt_start.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
}
-(void)pushedStartButton:(id)sender{//UIButton型による定義
//    NSNumber *num = [NSNumber numberWithInt:[sender tag]];
//-(void)pushedButton:(NSNumber *)num{//UIImageView型による定義
    
//    NSLog(@"num = %d", num.integerValue);
//    switch((ButtonMenuImageType)num.integerValue){
//        case ButtonMenuImageTypeStart:{
    
    
    //拡大したbt_startを元の大きさに戻す
    NSLog(@"start games");
    bt_start.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    if(bgmClass.getIsPlaying){
        [bgmClass stop];
    }
    
    
    
#ifdef TEST
            TestViewController *tvc = [[TestViewController alloc]init];
            [self presentViewController: tvc animated:YES completion: nil];
#else
//            [backGround pauseAnimations];//exitAnimationsはgotoGameの中で実行(画面が白くなってしまう)
//            [backGround stopAnimation];
//            [backGround exitAnimations];
            //background stopAnimation(0.01sec必要)を実行しないとゲーム画面でアニメーションが開始されない(既存のiv animationが残っているため)
            //stopAnimationを実行するための0.01sを稼ぐためにここで0.1s-Delayさせる
//            lifeGame = 6;//test:life
            if(lifeGame > 0){
                
                
                
                lifeGame--;
                
                if(isStartable){
                    
                    //次にviewWillAppearが実行されるまでisStartableはfalseのまま
                    isStartable = false;//続けてボタンを押せないように(続けて押せてしまうとlifeGameが何度も減ってしまう)
                    
                    
                    
                    [attr setValueToDevice:@"lifeGame" strValue:[NSString stringWithFormat:@"%d",lifeGame]];
                    
                    //lifeGameの表示
                    lbl_gameLife.text =
                    [NSString stringWithFormat:@"%d ／ %d",
                     lifeGame, maxLifeGame];
                    
                    //日時を記憶
                    [attr setValueToDevice:@"ymdMenuLastOpen"
                                  strValue:[self getYYYYMMDD]];
                    [attr setValueToDevice:@"hmsMenuLastOpen"
                                  strValue:[self getHHMMSS]];
                    
                    NSLog(@"before game : %@", [attr getValueFromDevice:@"hmsMenuLastOpen"]);
                    //現在カウンターを記憶
                    [attr setValueToDevice:@"secondForLife"
                                  strValue:[NSString stringWithFormat:@"%d", secondForLife]];
                    
                    [tm invalidate];
                    tm = nil;
                    //                [self performSelector:@selector(gotoGame) withObject:nil];// afterDelay:0.1f];
                    //遅らせる場合：lifeGameが減少したlbl_gameLifeを示す。
                    [NSTimer
                     scheduledTimerWithTimeInterval:0.5f
                     target:self
                     selector:@selector(gotoGame) userInfo:nil repeats:NO];
                    [backGround exitAnimations];
                    //button resize
                }else{//誤操作等により続けて連打してしまった時は何もしない
                    //do nothing
                }
                
            }else{
//                NSLog(@"%d" , lifeGame);
                //for short-life, transfer LifeUpListViewController
                viewForDialog =
                [CreateComponentClass
                 createAlertView:CGRectMake(10, 10,
                                            self.view.bounds.size.width-10,
                                            self.view.bounds.size.height)
                 dialogRect:CGRectMake(10, 10,
                                       self.view.bounds.size.width-30,
                                       self.view.bounds.size.width-30)//正方形：縦＝横
                 title:@"ライフが不足しています。"
                 message:@"ライフとルビーを交換しますか？"
                 titleYes:@"はい"
                 titleNo:@"いいえ"
                 onYes:^{
                     LifeUpListViewController *lifeUpView = [[LifeUpListViewController alloc] init];
                     [self presentViewController:lifeUpView animated:YES completion:nil];
                     
                     [viewForDialog removeFromSuperview];
                 }
                 onNo:^{
                     [viewForDialog removeFromSuperview];
                 }
                 ];
                
                [self.view addSubview:viewForDialog];
                
            }
#endif

            
//            break;
//        }
//        default:{
//            break;
//        }
//    }
}
-(void)pushedButton:(NSNumber *)num{//UIImageView型による定義
    switch((ButtonMenuImageType)num.integerValue){
        case ButtonMenuImageTypeWeapon:{
            WeaponBuyListViewController *wblvc = [[WeaponBuyListViewController alloc]init];
            [self presentViewController: wblvc animated:YES completion: nil];
            break;
        }
        case ButtonMenuImageTypeDefense:{
            [backGround stopAnimation];//これをしないと裏で動いてしまう=>exit?
            DefenseUpListViewController *ilvc = [[DefenseUpListViewController alloc]init];
            [self presentViewController: ilvc animated:YES completion: nil];
            break;
        }
        case ButtonMenuImageTypeItem:{
            [backGround stopAnimation];//これをしないと裏で動いてしまう=>exit?
            ItemUpListViewController *ilvc = [[ItemUpListViewController alloc]init];
            [self presentViewController: ilvc animated:YES completion: nil];
            break;
        }
        case ButtonMenuImageTypeWpnUp:{
            [backGround stopAnimation];//これをしないと裏で動いてしまう=>exit?
            WeaponUpListViewController *ilvc = [[WeaponUpListViewController alloc]init];
            [self presentViewController: ilvc animated:YES completion: nil];
            break;
        }
        case ButtonMenuImageTypeInn:{
//            [backGround pauseAnimations];
            [backGround stopAnimation];//これをしないと裏で動いてしまう=>exit?
            LifeUpListViewController *ilvc = [[LifeUpListViewController alloc]init];
            [self presentViewController: ilvc animated:YES completion: nil];
            break;
        }
        case ButtonMenuImageTypeCoin:{//コイン購入画面へ=>exit?
            [backGround stopAnimation];
//            PayProductViewController *ppvc = [[PayProductViewController alloc]init];
//            [self presentViewController:ppvc animated:NO completion:nil];
            CoinProductViewController *cpvc = [[CoinProductViewController alloc] init];
            [self presentViewController:cpvc animated:YES completion:nil];
            break;
        }
        case ButtonMenuImageTypeSet:{//設定画面：BGM,効果音、操作感度、ボイス、難易度
            //大元のビューを定義する：viewSuperを親ビューにしてボタンを押すと親ビューも押下に反応する(反応したら消去されてしまう)
            UIView *viewSuperSuper = [CreateComponentClass createViewNoFrame:self.view.bounds
                                                                       color:[UIColor clearColor]
                                                                         tag:0
                                                                      target:Nil
                                                                    selector:nil];
            [self.view addSubview:viewSuperSuper];
            
            //メインフレームを消去するための透明ビューを派生(メインフレームとは別派生にする)
//            UIView *viewSuper = [CreateComponentClass createViewNoFrame:self.view.bounds
//                                                                  color:[UIColor clearColor]
//                                                                    tag:9999
//                                                                 target:self
//                                                               selector:@"closeSuperView:"];//透明ビュー
            //createViewNoFrameの場合、selectorに渡す引数がaddTargetなのでUITapGestureRecognizerになってしまう(コンポーネント本体を渡したい)ので
            //(コード的には不自然だけど何も見えない)ボタンにしてaddTargetで自身のコンポーネントを渡す
            UIView *viewSuper = [CreateComponentClass createButtonWithType:ButtonMenuBackTypeDefault
                                                                      rect:self.view.bounds
                                                                     image:nil
                                                                    target:self
                                                                  selector:@"closeSuperView:"];
            [viewSuper setBackgroundColor:[UIColor colorWithRed:0.0f green:0 blue:0 alpha:0.7f]];
            [viewSuperSuper addSubview:viewSuper];
            
            //メインフレームの定義
            UIView *viewFrame = [CreateComponentClass createView:CGRectMake(100, 70, 210, 250)];//340)];//in case of 4components
            [viewFrame setBackgroundColor:[UIColor colorWithRed:0.1f green:0.1f blue:0.3f alpha:0.6f]];//どちらでも良い
            [viewSuperSuper addSubview:viewFrame];
            

            
            
            int imageInitX = 10;
            int imageInitY = 10;
            int imageWidth = 70;
            int imageHeight = 70;
            int imageMargin = 10;
            //each name of method
            NSArray *arrSetMethodName = [NSArray arrayWithObjects:
                                  @"setBGM:",
                                  @"setSE:",
//                                  @"setSensitivity:",
                                  nil] ;
            NSArray *arrDisplay = [NSArray arrayWithObjects:
                                   @"BGM",
                                   @"効果音",
                                   nil];
            NSArray *arrImage = [NSArray arrayWithObjects:
                                 [NSNumber numberWithInt:ButtonSwitchImageTypeBGM],
                                 [NSNumber numberWithInt:ButtonSwitchImageTypeSpeaker],
//                                 [NSNumber numberWithInt:ButtonSwitchImageTypeSensitivity],
                                 nil];
            for (int i = 0; i < [arrSetMethodName count]; i++){
                CGRect rect_image = CGRectMake(imageInitX,
                                               imageInitY + i * (imageHeight + imageMargin),
                                               imageWidth,
                                               imageHeight);
                //button
                UIImageView *iv_item = [CreateComponentClass createSwitchButton:rect_image
                                                                       backType:ButtonMenuBackTypeBlue
                                                                      imageType:[[arrImage objectAtIndex:i] intValue]
                                                                            tag:[[NSString stringWithFormat:@"%d%d", 212, i] intValue]//non-use
                                                                         target:self
                                                                       selector:[arrSetMethodName objectAtIndex:i]];
                [viewFrame addSubview:iv_item];
                
                //explanation
                UITextView *tv_setExp = [CreateComponentClass createTextView:CGRectMake(rect_image.origin.x + rect_image.size.width,
                                                                                        rect_image.origin.y,
                                                                                        viewFrame.bounds.size.width - rect_image.size.width,
                                                                                        rect_image.size.height)
                                                                        text:[arrDisplay objectAtIndex:i]
                                                                        font:@"AmericanTypewriter-Bold"
                                                                        size:15
                                                                   textColor:[UIColor whiteColor]
                                                                   backColor:[UIColor clearColor]
                                                                  isEditable:NO];
                [viewFrame addSubview:tv_setExp];
                
            }
            //sensitivity
            CGRect rect_image = CGRectMake(imageInitX,
                                           imageInitY + 2 * (imageHeight + imageMargin),
                                           imageWidth,
                                           imageHeight);
            
            UIImageView *iv_sense = [CreateComponentClass createCountButton:rect_image
                                                                   backType:ButtonMenuBackTypeBlue
                                                                  imageType:ButtonCountImageTypeSensitivity
                                                                        tag:0
                                                                     target:self
                                                                   selector:@"setSensitivity:"];
            [viewFrame addSubview:iv_sense];
            
            UITextView *tv_setExp = [CreateComponentClass createTextView:CGRectMake(rect_image.origin.x + rect_image.size.width,
                                                                                    rect_image.origin.y,
                                                                                    viewFrame.bounds.size.width - rect_image.size.width,
                                                                                    rect_image.size.height)
                                                                    text:@"操作感度"
                                                                    font:@"AmericanTypewriter-Bold"
                                                                    size:15
                                                               textColor:[UIColor whiteColor]
                                                               backColor:[UIColor clearColor]
                                                              isEditable:NO];
            [viewFrame addSubview:tv_setExp];
            
            
            //要望フォーム
//            UIImageView *iv_demand = [CreateComponentClass createMenuButton:(ButtonMenuBackType)ButtonMenuBackTypeBlue
//                                                                  imageType:(ButtonMenuImageType)ButtonMenuImageTypeDemand
//                                                                       rect:CGRectMake(imageInitX,
//                                                                                        imageInitY + 3 * (imageHeight + imageMargin),//+ viewFrame.frame.origin.y,//because it's on self.view
//                                                                                        imageWidth, imageHeight)
//                                                                     target:self
//                                                                   selector:@"setDemand"];
//            [viewFrame addSubview:iv_demand];
//            
//            UITextView *tv_setDemand = [CreateComponentClass
//                                        createTextView:CGRectMake(iv_demand.frame.origin.x + iv_demand.frame.size.width,
//                                                                  iv_demand.frame.origin.y,
//                                                                  viewFrame.frame.size.width - iv_demand.frame.size.width,
//                                                                  iv_demand.frame.size.height)
//                                                                    text:@"ご意見"
//                                                                    font:@"AmericanTypewriter-Bold"
//                                                                    size:15
//                                                               textColor:[UIColor whiteColor]
//                                                               backColor:[UIColor clearColor]
//                                                              isEditable:NO];
//            [viewFrame addSubview:tv_setDemand];
            
            break;
        }
        case ButtonMenuImageTypeDemand:{
            /*
             *ユーザーの要望を聞くフォーム (PayProductViewControlと同じ構造)
             */
            viewMailSuperForm = [CreateComponentClass createViewNoFrame:self.view.bounds
                                                                       color:[UIColor clearColor]
                                                                         tag:0
                                                                      target:Nil
                                                                    selector:nil];
            [viewMailSuperForm setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8]];
            [self.view addSubview:viewMailSuperForm];
            
            
            
            
            int xViewFrame = 10;
            int yViewFrame = 100;
            int widthViewFrame = 300;
            int heightViewFrame = 350;
            
            //見た目の飾り付け
            UIView *viewFrame = [CreateComponentClass createView:CGRectMake(xViewFrame,yViewFrame,
                                                                            widthViewFrame,
                                                                            heightViewFrame)];
            [viewFrame setBackgroundColor:[UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:0.6f]];
            [viewMailSuperForm addSubview:viewFrame];
            
            //TextViewから他の場所をタップした時にフォーカスを外すためのview
            UIView *viewForResign = [CreateComponentClass createViewNoFrame:self.view.bounds
                                                                      color:[UIColor clearColor]
                                                                        tag:0
                                                                     target:self
                                                                   selector:@"setResign"];
            [viewMailSuperForm addSubview:viewForResign];//only for action
            
            
            
            int xSubject = 10;
            int ySubject = 10;
            int wSubject = 60;
            int hSubject = 40;
            int widthForm = viewFrame.frame.size.width - wSubject - 15;
            int heightForm = 130;
            int heightSubjects = 40;
            //件名
            UILabel *lbSubject = [[UILabel alloc]initWithFrame:CGRectMake(xSubject, ySubject, wSubject, hSubject)];
            lbSubject.text = @"お名前:";
            lbSubject.textColor = [UIColor whiteColor];
            [viewFrame addSubview:lbSubject];
            
            tvSubject = [[UITextView alloc] initWithFrame:CGRectMake(viewFrame.frame.origin.x + xSubject + wSubject,
                                                                     viewFrame.frame.origin.y + ySubject,
                                                                     widthForm, heightSubjects)];
            tvSubject.text = strSubject;
            tvSubject.textColor = [UIColor lightGrayColor];
            tvSubject.delegate = self;
//            [viewFrame addSubview:tvSubject];
            [viewMailSuperForm addSubview:tvSubject];
//            [tvSubject becomeFirstResponder];                // キーボードを表示
            tvSubject.layer.borderWidth = 1;//add frame-line
            tvSubject.layer.borderColor = [[UIColor blackColor] CGColor];
            tvSubject.layer.cornerRadius = 5;//curve line
            tvSubject.editable = YES;
            
            //内容
            UILabel *lbDemand = [[UILabel alloc]initWithFrame:CGRectMake(xSubject,
                                                                         lbSubject.frame.origin.y + heightSubjects + 3,
                                                                         wSubject, hSubject)];
            lbDemand.text = @"ご要望:";
            lbDemand.textColor = [UIColor whiteColor];
            [viewFrame addSubview:lbDemand];
            
            tvDemand = [[UITextView alloc] initWithFrame:CGRectMake(viewFrame.frame.origin.x + xSubject + wSubject,
                                                                    tvSubject.frame.origin.y + heightSubjects + 3,
                                                                                widthForm, heightForm)];
            tvDemand.text = strDemand;
            tvDemand.textColor = [UIColor lightGrayColor];
            tvDemand.delegate = self;
//            [viewFrame addSubview:tvDemand];
            [viewMailSuperForm addSubview:tvDemand];
//            [textView becomeFirstResponder];                // キーボードを表示
            tvDemand.layer.borderWidth = 1;//add frame-line
            tvDemand.layer.borderColor = [[UIColor blackColor] CGColor];
            tvDemand.layer.cornerRadius = 5;//curve line
            tvDemand.editable = YES;

            
            //send-button
            int widthButton = 100;
            int heightButton = 50;
            CoolButton *btSend = [CreateComponentClass createCoolButton:CGRectMake(tvDemand.frame.origin.x + tvDemand.frame.size.width - widthButton,//right
                                                                                   tvDemand.frame.origin.y + tvDemand.frame.size.height + 5,
                                                                                   widthButton, heightButton)
                                                                   text:@"送る"
                                                                    hue:0.85f
                                                             saturation:0.63f
                                                             brightness:0.79f
                                                                 target:self
                                                               selector:@"confirmDemand"
                                                                    tag:0];
            [viewMailSuperForm addSubview:btSend];
            
            CoolButton *btClose = [CreateComponentClass createCoolButton:CGRectMake(viewMailSuperForm.frame.size.width - widthButton - 5,//right
                                                                                   10,
                                                                                   widthButton - 20, heightButton + 10)
                                                                    text:@"閉じる"
                                                                     hue:0.532f
                                                              saturation:0.553f
                                                              brightness:0.535f
                                                                 target:self
                                                               selector:@"closeSuperView:"
                                                                    tag:0];
            [viewMailSuperForm addSubview:btClose];
            
            
            
            break;
        }
        default:{//Menu画面にはないButtonMenuImageTypeBuyButton(PayProduct内), ...TypeDemand(Set内)は何もしない
            //
            break;
        }
            
    }
}

-(void)confirmDemand{
    NSLog(@"confirm demand button pressed!");
    //この内容で宜しいですか？
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:@"ご協力ありがとうございます。" message:@"この内容でお送りしても宜しいですか？"
                              delegate:self cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい", nil];
    [alert show];
    
}
// アラートのボタンが押された時に呼ばれるデリゲート例文
-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            //１番目のボタンが押されたときの処理を記述する
            //do nothing
            break;
        case 1:
            //２番目のボタンが押されたときの処理を記述する
            [self sendDemand];
            break;
    }
    
}

-(void)sendDemand{
    NSLog(@"send demand button pressed!");
    
    
    NSString *strTime = [NSString stringWithFormat:@""];
    // 現在日付を取得
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger flags;
    NSDateComponents *comps;
    
    // 年・月・日を取得
    flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    comps = [calendar components:flags fromDate:now];
    NSString *year = [NSString stringWithFormat:@"%04d", comps.year];
    NSString *month = [NSString stringWithFormat:@"%02d", comps.month];
    NSString *day = [NSString stringWithFormat:@"%02d", comps.day];
    NSLog(@"%@年 %@月 %@日",year,month,day);
    strTime = [NSString stringWithFormat:@"%@%@%@%@", strTime, year, month, day];
    
    // 時・分・秒を取得
    flags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    comps = [calendar components:flags fromDate:now];
    NSString *hour = [NSString stringWithFormat:@"%d", comps.hour];
    NSString *minute = [NSString stringWithFormat:@"%d", comps.minute];
    NSString *second = [NSString stringWithFormat:@"%d", comps.second];
    NSLog(@"%@時 %@分 %@秒", hour, minute, second);
    strTime = [NSString stringWithFormat:@"%@%@%@%@", strTime, hour, minute, second];
    
    // 曜日
    comps = [calendar components:NSWeekdayCalendarUnit fromDate:now];
    NSArray *arrayWeekName = [[NSArray alloc]initWithObjects:
                              @"sun", @"mon", @"tue", @"wed", @"thu", @"fri", @"sat", nil];
    NSString *weekday = arrayWeekName[comps.weekday - 1];//comps.weekday; // 曜日(1が日曜日 7が土曜日)
    NSLog(@"曜日: %@", weekday);
    strTime = [NSString stringWithFormat:@"%@%@", strTime, weekday];
    
    DBAccessClass *dbac = [[DBAccessClass alloc]init];
    [dbac insertDemandToDB:(NSString *)strTime
                   subject:(NSString *)tvSubject.text
                    demand:(NSString *)tvDemand.text
                     login:(NSString *)[attr getValueFromDevice:@"login"]
                 lastlogin:(NSString *)[attr getValueFromDevice:@"lastlogin"]
                   gamecnt:(NSString *)[attr getValueFromDevice:@"gameCnt"]];
    
    //薄いviewを貼付けてそこに「送信しました」的なメッセージを貼付して１秒後に消去(遅延実行）
    UIView *viewNoAction = [[UIView alloc]initWithFrame:self.view.bounds];
    [viewNoAction setBackgroundColor:[UIColor whiteColor]];
    [viewNoAction setAlpha:0.5f];
    [viewMailSuperForm addSubview:viewNoAction];
    
    //frame for message:"completed sending message"
    UIView *viewMessageFrame = [CreateComponentClass
                                createView:CGRectMake(0, 0,
                                                      viewNoAction.frame.size.width*2/3,
                                                      50)];
    [viewMessageFrame setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.1f alpha:0.6f]];
    viewMessageFrame.center = CGPointMake(viewNoAction.frame.size.width/2,
                                          viewNoAction.frame.size.height/2);
    [viewNoAction addSubview:viewMessageFrame];
    
    UITextView *tvSendComplete = [CreateComponentClass
                                  createTextView:CGRectMake(0, 0, viewMessageFrame.frame.size.width,
                                                            viewMessageFrame.frame.size.height)
                                  text:@"送信しました"
                                  font:@"AmericanTypewriter-Bold"
                                  size:20
                                  textColor:[UIColor blackColor]
                                  backColor:[UIColor clearColor]
                                  isEditable:NO];
    tvSendComplete.textAlignment = NSTextAlignmentCenter;
    tvSendComplete.center = CGPointMake(viewMessageFrame.frame.size.width/2,
                                        viewMessageFrame.frame.size.height/2);
    [viewMessageFrame addSubview:tvSendComplete];
    
    
    
    [self performSelector:@selector(removeMailView) withObject:nil afterDelay:3.0f];
    
}

-(void)removeMailView{//遅延実行させる
    [viewMailSuperForm removeFromSuperview];
}

//自作
-(void)setResign{
    if(tvSubject.text.length == 0){
        tvSubject.textColor = [UIColor lightGrayColor];
        tvSubject.text = strSubject;
        
    }
    [tvSubject resignFirstResponder];
    if(tvDemand.text.length == 0){
        tvDemand.textColor = [UIColor lightGrayColor];
        tvDemand.text = strDemand;
    }
    [tvDemand resignFirstResponder];
}

//override
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if(textView == tvSubject){
        if (tvSubject.textColor == [UIColor lightGrayColor]) {
            tvSubject.text = @"";
            tvSubject.textColor = [UIColor blackColor];
        }
    }else if(textView == tvDemand){
        if(tvDemand.textColor == [UIColor lightGrayColor]){
            tvDemand.text = @"";
            tvDemand.textColor = [UIColor blackColor];
        }
    }
    
    return YES;
}
//override
-(void) textViewDidChange:(UITextView *)textView
{
    if(tvSubject.text.length == 0){
        tvSubject.textColor = [UIColor lightGrayColor];
        tvSubject.text = strSubject;
        [tvSubject resignFirstResponder];
    }
    if(tvDemand.text.length == 0){
        tvDemand.textColor = [UIColor lightGrayColor];
        tvDemand.text = strDemand;
        [tvDemand resignFirstResponder];
    }
}
//override
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //テキストを変更しても良いかの事前通知です。
    //rangeに変更対象の位置（location）と長さ（length）、textに変更後の文字列
    if(textView == tvSubject){//イベントの呼出し元がtvSubviewの時
        if([text isEqualToString:@"\n"]) {
            [tvSubject resignFirstResponder];//フォーカス外す
            if(tvSubject.text.length == 0){
                tvSubject.textColor = [UIColor lightGrayColor];
                tvSubject.text = strSubject;
                [tvSubject resignFirstResponder];//フォーカス外す
            }
//            [tvDemand becomeFirstResponder];
            return YES;
        }
    }
    return YES;
}


/*
 *未使用？->weaponBuyListViewControllerに委譲
 */
-(void)weaponSelected:(id)sender{
    UIView *tappedView = [sender view];
    NSLog(@"%@", tappedView);
    
    
    for(int i = 0;i < WEAPON_BUY_COUNT;i++){//最初のタグは武器イメージタップ時のイベント
        if(i == tappedView.tag){
            UIView *viewAll = [[UIView alloc]initWithFrame:self.view.bounds];
            [viewAll setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.3f]];//タップイベントを受け付けないビューを画面全体に配置
            UIView *viewFrame = [CreateComponentClass createView:CGRectMake(10, 120, 300, 300)];
            [viewFrame setBackgroundColor:[UIColor colorWithRed:((float)i+1)/WEAPON_BUY_COUNT green:1.0f blue:1.0f alpha:0.3f]];
            NSLog(@"%f", (float)i/WEAPON_BUY_COUNT);
            UIButton *bt = [CreateComponentClass createButtonWithType:ButtonMenuBackTypeDefault
                                                                 rect:CGRectMake(260, 50, 25, 25)
                                                                image:@"close.png"
                                                               target:self
                                                             selector:@"closeSuperSuperView:"];//親クラスを削除する
            bt.tag = 9999;
            [viewFrame addSubview:bt];
            
            //説明文
            UITextView *tv_buy = [CreateComponentClass createTextView:CGRectMake(30, 30,
                                                                                 viewFrame.bounds.size.width-60,
                                                                                 100)
                                                                 text:@"explanation"
                                                                 font:@"AmericanTypewriter-Bold"
                                                                 size:12
                                                            textColor:[UIColor whiteColor]
                                                            backColor:[UIColor clearColor]
                                                           isEditable:NO];
            [viewFrame addSubview:tv_buy];
            
            NSString *strButtonText;
            //現在の武器のフレームには枠を付ける
            NSString *strWeaponIDX = [NSString stringWithFormat:@"weaponID%d", i];
            if([[attr getValueFromDevice:strWeaponIDX] isEqualToString:@"0"] ||
               [[attr getValueFromDevice:strWeaponIDX] isEqual:[NSNull null]] ||
               [attr getValueFromDevice:strWeaponIDX] == nil){
                
                strButtonText = @"buy now!";
            }else if([[attr getValueFromDevice:strWeaponIDX] isEqualToString:@"1"]){
                //既に購入済
                strButtonText = @"set";
            }else if([[attr getValueFromDevice:strWeaponIDX] isEqualToString:@"2"]){
                strButtonText = @"now setting.";
            }
            CoolButton *bt_buy = [CreateComponentClass createCoolButton:CGRectMake(30, 150, viewFrame.bounds.size.width-60, 70)
                                                                   text:strButtonText
                                                                    hue:0.532f
                                                             saturation:0.553f
                                                             brightness:0.535f
                                                                 target:self
                                                               selector:@"buyWeapon:"
                                                                    tag:i];
            [viewFrame addSubview:bt_buy];
            
            
            [viewAll addSubview:viewFrame];
            [self.view addSubview:viewAll];
            break;
        }
    }
    
}


-(void)imageTapped:(id)sender{

    UIView *tappedView = [sender view];
    NSLog(@"imageTapped at tag = %d", tappedView.tag);
    
    switch(tappedView.tag){
        case 100:{//leaderboard表示用
//            NSLog(@"invite");

            
            NSLog(@"leader board");
            //learderboard
            GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
            leaderboardController.leaderboardDelegate = self;
            //    [self presentModalViewController:leaderboardController animated:YES];
            [self presentViewController: leaderboardController animated:YES completion: nil];

            break;
        }
        case 101:{//set timer=> buy money at left of bt_start
            NSLog(@"set timer event to code: not yet");
//            CoinProductViewController * coinView =
//            [[CoinProductViewController alloc] init];
//            [self presentViewController:coinView animated:YES completion:nil];
            LifeUpListViewController *ilvc = [[LifeUpListViewController alloc]init];
            [self presentViewController: ilvc animated:YES completion: nil];

            break;
        }
        case 102:{//invite - friends
            NSLog(@"invitation of friends");
            //firstSample
//            InviteFriendsViewController *inviteView = [[InviteFriendsViewController alloc] init];
//            [self presentViewController:inviteView animated:YES completion:nil];
            
            //inviteSample
//            AppSociallyInviteMainViewController *apInviteVC =
//            [[AppSociallyInviteMainViewController alloc] init];
//            [self presentViewController:apInviteVC animated:YES completion:nil];
            
            //inviteSample=>navigation-version
            AppSociallyInviteMainViewController *controller = [[AppSociallyInviteMainViewController alloc] init];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:navigationController animated:YES completion:nil];
            
            
            break;
        }
        
        default :{
            NSLog(@"other tag %d", tappedView.tag);
            break;
        }
    
    }
    return;
}

/*
 *武器購入時の呼出しメソッド(内部処理＝金額計算＋nsuserDefaults上書き)
 *まだ購入していなければ購入メニュー、購入していれば選択メニュー
 */
-(void)buyWeapon:(id)sender{
    //武器ID
    int id_weapon = ((UIImageView *)sender).tag;

    NSArray *arrCostWeapon = [NSArray arrayWithObjects:
                              @"1000",
                              @"2000",
                              @"3000",
                              @"4000",
                              @"5000",
                              @"6000",
                              @"7000",
                              @"8000",
                              @"9000",
                              @"10000",
                              nil];
    
    NSLog(@"weapon id = %d & cost is %d", id_weapon, [[arrCostWeapon objectAtIndex:id_weapon] intValue]);
    NSString *strWeaponIDX = [NSString stringWithFormat:@"weaponID%d", id_weapon];
    
    if([[attr getValueFromDevice:strWeaponIDX] isEqual:[NSNull null]] ||
       [attr getValueFromDevice:strWeaponIDX] == nil ||
       [[attr getValueFromDevice:strWeaponIDX] isEqual:@"0"]){//未購入の場合
        
        //金額の取得
        int gold = [[attr getValueFromDevice:@"gold"] intValue];
        if(gold < [[arrCostWeapon objectAtIndex:id_weapon] intValue]){
            NSLog(@"need more Money!");//sender(UIImageView)を揺らす等のエフェクト？
            [((UIButton *)sender) setTitle:@"コインが足りません..." forState:UIControlStateNormal];
            [((UIButton *)sender) setTitle:@"コインが足りません..." forState:UIControlStateHighlighted];
            [((UIButton *)sender) setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
            [self oscillate:(UIButton *)sender count:10];
        }else{
            
            gold -= [[arrCostWeapon objectAtIndex:id_weapon] intValue];
            NSLog(@"set new gold = %d", gold);
            [attr setValueToDevice:@"gold" strValue:[NSString stringWithFormat:@"%d", gold]];
            
            tvGoldAmount_global.text = [NSString stringWithFormat:@"%d", gold];
            
            //other weaponIDX:->0(all->0 then the weapon->1)
            for(BeamType beamType = 0;beamType < 10;beamType++){
                if([[attr getValueFromDevice:
                    [NSString stringWithFormat:@"weaponID%d", beamType]
                    ]
                   isEqual:@"2"]){
                    //購入済＆設定：2=>1
                    //購入済：1=>1
                    //非購入：0(null)=>0(null)
                    [attr setValueToDevice:[NSString stringWithFormat:@"weaponID%d", beamType] strValue:@"1"];
                }
            }
            
            
            
            //if(setting to weapon ??)
            [attr setValueToDevice:[NSString stringWithFormat:@"weaponID%d", id_weapon] strValue:@"2"];
            [((UIButton *)sender) setTitle:@"装備しました。" forState:UIControlStateNormal];
            [((UIButton *)sender) setTitle:@"既に装備済です。" forState:UIControlStateHighlighted];
//          }
        
//            for(BeamType beamType = 0;beamType < 10;beamType++){
//                NSLog(@"weaponID%d=%@", beamType, [attr getValueFromDevice:[NSString stringWithFormat:@"weaponID%d", beamType]]);
//            }
        }
    }else if([[attr getValueFromDevice:strWeaponIDX] isEqualToString:@"1"]){//購入済の場合
        //選択画面:この武器を選択
        
        //other weaponIDX:->0(all->0 then the weapon->1)
        for(BeamType beamType = 0;beamType < 10;beamType++){
            if([[attr getValueFromDevice:
                 [NSString stringWithFormat:@"weaponID%d", beamType]
                 ]
                isEqual:@"2"]){
                //購入済＆設定：2=>1
                //購入済：1=>1
                //非購入：0(null)=>0(null)
                [attr setValueToDevice:[NSString stringWithFormat:@"weaponID%d", beamType] strValue:@"1"];
            }
        }
        
        
        [attr setValueToDevice:strWeaponIDX strValue:@"2"];
        [((UIButton *)sender) setTitle:@"装備しました。" forState:UIControlStateNormal];
        [((UIButton *)sender) setTitle:@"既に装備済です。" forState:UIControlStateHighlighted];
        
    }else if([[attr getValueFromDevice:strWeaponIDX] isEqualToString:@"2"]){
        //既に購入済みなので
        
//        //other weaponIDX:->0(all->0 then the weapon->1)
//        for(BeamType beamType = 0;beamType < 10;beamType++){
//            if([[attr getValueFromDevice:
//                 [NSString stringWithFormat:@"weaponID%d", beamType]
//                 ]
//                isEqual:@"2"]){
//                //購入済＆設定：2=>1
//                //購入済：1=>1
//                //非購入：0(null)=>0(null)
//                [attr setValueToDevice:[NSString stringWithFormat:@"weaponID%d", beamType] strValue:@"1"];
//            }
//        }
        
        [((UIButton *)sender) setTitle:@"現在装備中です。" forState:UIControlStateNormal];
        [((UIButton *)sender) setTitle:@"既に装備済です。" forState:UIControlStateHighlighted];
        [((UIButton *)sender) setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [self oscillate:(UIButton *)sender count:10];
    }
}

//ボタンの文字を「金額不足」の旨表示して、指定された回数だけ振動。
//振動後は元の文字列に変更
-(void)oscillate:(UIView *)view count:(int)_count{
    [UIView animateWithDuration:0.05f
                     animations:^{
                         view.center = CGPointMake(view.center.x + ((_count % 2 == 0)?5:-5),
                                                   view.center.y);
                     }
                     completion:^(BOOL finished){
                         //元に戻す
                         view.center = CGPointMake(view.center.x + ((_count % 2 == 0)?-5:5),
                                                   view.center.y);
                         if(_count > 0){
                             [self oscillate:view count:_count-1];
                         }else{
                             [(UIButton *)view setTitle:@"buy now!" forState:UIControlStateNormal];
                         }
                         
                     }];
    
    
}

//引数は使用せず(bgm, se, sensitivity)
-(void)setBGM:(NSNumber *)num{
    //以下は[[attr getValueFromDevice:@"bgm"] intValue]で済むのでは？
    NSUserDefaults *_myDefaults = [NSUserDefaults standardUserDefaults];
    NSString *name = @"bgm";
    NSLog(@"original-BGM : %d", [[_myDefaults objectForKey:name] intValue]);
    //if bgm on/off then bgm off/on
    NSString *value = ([[_myDefaults objectForKey:name] intValue]==1)?@"0":@"1";
    [_myDefaults setObject:value forKey:name];
    NSLog(@"set up BGM : %d", [[_myDefaults objectForKey:name] intValue]);
    
    //スイッチの結果を反映する(0でも1でも反映するためにplayBGM)
    [self playBGM];
    
}
-(void)setSE:(NSNumber *)num{
    NSUserDefaults *_myDefaults = [NSUserDefaults standardUserDefaults];
    NSString *name = @"se";
    NSLog(@"original-SE : %d", [[_myDefaults objectForKey:name] intValue]);
    //if se on/off then se off/on
    NSString *value = ([[_myDefaults objectForKey:name] intValue]==1)?@"0":@"1";//if value=1 then 0, else 1;
    [_myDefaults setObject:value forKey:name];
    NSLog(@"set up se : %d", [[_myDefaults objectForKey:name] intValue]);
}

-(void)setSensitivity:(NSNumber *)num{
    NSUserDefaults *_myDefaults = [NSUserDefaults standardUserDefaults];
    NSString *name = @"sensitivity";
    NSLog(@"original-sensitivity : %d", [[_myDefaults objectForKey:name] intValue]);
    //if se on/off then se off/on
//    NSString *value = ([[_myDefaults objectForKey:name] intValue]==1)?@"0":@"1";
    int value = [[_myDefaults objectForKey:name] intValue];
    NSLog(@"now value = %d", value);
    switch (value) {
        case 0:{
            value++;
            break;
        }
        case 1:{
            value++;
            break;
        }
        case 2:{
            value = 0;
            break;
        }
        default:{
            value = 0;
            break;
        }
    }
    [_myDefaults setObject:[NSString stringWithFormat:@"%d", value] forKey:name];
    NSLog(@"set up sensitivity : %d", [[_myDefaults objectForKey:name] intValue]);
    
}


-(void)closeView:(id)sender{
    NSLog(@"close view");
    [[sender view]removeFromSuperview];
}

-(void)closeSuperView:(id)sender{
    NSLog(@"close superview : %@", sender);
    [[sender superview]removeFromSuperview];
    
}
-(void)closeSuperSuperView:(id)sender{
    NSLog(@"close superview");
    [[[sender superview] superview ]removeFromSuperview];
    
}

//BGM曲をかける
-(void)playBGM{
    NSLog(@"play bgm method : %@", [attr getValueFromDevice:@"bgm"]);
    //初期状態(null)、もしくは既に設定が１となっている場合
    if([[attr getValueFromDevice:@"bgm"] isEqual:[NSNull null]] ||
       [attr getValueFromDevice:@"bgm"] == nil ||
       [[attr getValueFromDevice:@"bgm"] isEqual:@"1"]){
        
        bgmClass = [[BGMClass alloc]init];
        if(arc4random() %2 == 0){
            [bgmClass play:@"bgm_menu_683"];
        }else{
            [bgmClass play:@"mahotoshi_hmix"];
        }
    }else{
        //switch=offのときはストップ
        if(bgmClass.getIsPlaying){
            [bgmClass stop];
        }
    }
}

-(UIImageView*)createImageView:(NSString*)filename tag:(int)tag frame:(CGRect)frame{
    UIImageView *iv = [[UIImageView alloc] initWithFrame:frame];
    iv.tag = tag;
    iv.image = [UIImage imageNamed:filename];
    return iv;
}

//test:anim
//-(void)animAirViewUp{//:(UIView *)view{//浮遊アニメーション
-(void)animAirViewUp:(UIView *)view{//浮遊アニメーション
    
    CGPoint kStartPos = self.view.center;//((CALayer *)[view.layer presentationLayer]).position;
    CGPoint kEndPos = self.view.center;
    [CATransaction begin];
//    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [CATransaction setCompletionBlock:^{//終了処理
//        [self animAirView:view];
        CAAnimation *animationKeyFrame = [view.layer animationForKey:@"position"];
//        CAAnimation *animationKeyFrame = [ivBackChara.layer animationForKey:@"position"];
        if(animationKeyFrame){
            //途中で終わらずにアニメーションが全て完了して
//            [self animAirViewDown:view];
            [self animAirViewUp:view];
//            [self animAirViewUp];
//            NSLog(@"animation key frame already exit & die");
        }else{
            //途中で何らかの理由で遮られた場合
//            NSLog(@"animation key frame not exit");
        }
    }];
    
    {
        // CAKeyframeAnimationオブジェクトを生成
        CAKeyframeAnimation *animation;
        animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        animation.fillMode = kCAFillModeForwards;
        animation.removedOnCompletion = NO;
        animation.duration = 1.0f;
        
        // 放物線のパスを生成
        CGPoint peakPos = CGPointMake(kStartPos.x, kEndPos.y * 0.95f);//test
        CGMutablePathRef curvedPath = CGPathCreateMutable();
        CGPathMoveToPoint(curvedPath, NULL, kStartPos.x, kStartPos.y);//始点に移動
        CGPathAddCurveToPoint(curvedPath, NULL,
                              peakPos.x, peakPos.y,
                              (peakPos.x + kEndPos.x)/2, (peakPos.y + kEndPos.y)/2,
                              kEndPos.x, kEndPos.y);
        
        // パスをCAKeyframeAnimationオブジェクトにセット
        animation.path = curvedPath;
        
        // パスを解放
        CGPathRelease(curvedPath);
        
        // レイヤーにアニメーションを追加
        //                        [[[ItemArray objectAtIndex:i] getImageView].layer addAnimation:animation forKey:@"position"];
//        [ivBackChara.layer addAnimation:animation forKey:@"position"];
        [view.layer addAnimation:animation forKey:@"position"];
        
    }
    [CATransaction commit];
}

-(void)setBackGroundInit{
    NSLog(@"set background init");
    
    //キャラクター描画
    if(ivBackChara != nil &&
       ![ivBackChara isEqual:[NSNull null]]){
        
        [ivBackChara removeFromSuperview];
        [ivBackChara.layer removeAnimationForKey:@"position"];
        NSLog(@"ivBackChara delete");
        ivBackChara = nil;
    }
    ivBackChara = [[UIImageView alloc] initWithFrame:CGRectMake(-110, -10, 544, 400)];
    ivBackChara.image = [UIImage imageNamed:@"chara01.png"];
    ivBackChara.center = self.view.center;//CGPointMake(self.view.center.x, self.view.center.y);
    //    iv_back.alpha = ALPHA_COMPONENT;
    [self.view addSubview:ivBackChara];
    [self.view sendSubviewToBack:ivBackChara];
    
    //背景描画
    if(backGround != nil &&
       ![backGround isEqual:[NSNull null]]){
        
        [backGround exitAnimations];//前のアニメーションの停止
    }
        
    backGround = [[BackGroundClass2 alloc]init:WorldTypeUniverse1
                                         width:self.view.bounds.size.width
                                        height:self.view.bounds.size.height
                                          secs:5.0f];
    
    
    [self.view addSubview:[backGround getImageView1]];
    [self.view addSubview:[backGround getImageView2]];
    [self.view sendSubviewToBack:[backGround getImageView1]];
    [self.view sendSubviewToBack:[backGround getImageView2]];
    

    [self startAnimateBackGround];//背景動画
}

-(void)startAnimateBackGround{
    NSLog(@"startAnimateBackGround");
    [self animAirViewUp:ivBackChara];
//    [self animAirViewUp];
    [backGround startAnimation];//3sec-Round
    
}

//現在日時
-(NSString *)getYYYYMMDD{
    NSDateFormatter *_dateformat = [[NSDateFormatter alloc] init];
    [_dateformat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
    [_dateformat setDateFormat:@"yyyyMMdd"];
    NSString *_now = [_dateformat stringFromDate:[NSDate date]];
    return _now;
}

//現在時刻
-(NSString *)getHHMMSS{
    NSDateFormatter *_dateformat = [[NSDateFormatter alloc] init];
    [_dateformat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
    [_dateformat setDateFormat:@"HHmmss"];
    NSString *_now = [_dateformat stringFromDate:[NSDate date]];
    return _now;
}

//二つのhhmmssから経過時間(秒)を返す
-(int)getPassTime:(NSString *)hms1 hms2:(NSString *)hms2{
    NSString* after = 0;
    NSString* before = 0;
    if(hms1.integerValue > hms2.integerValue){
        after = hms1;
        before = hms2;
    }else{
        after = hms2;
        before = hms1;
    }
    
    int afterH =[after substringToIndex:2].integerValue;
    int afterM = [after substringWithRange:NSMakeRange(2, 2)].integerValue;
    int afterS = [after substringFromIndex:4].integerValue;
    
    int beforeH =[before substringToIndex:2].integerValue;
    int beforeM = [before substringWithRange:NSMakeRange(2, 2)].integerValue;
    int beforeS = [before substringFromIndex:4].integerValue;
    
    return afterH * 3600 + afterM * 60 + afterS -
            (beforeH * 3600 + beforeM * 60 + beforeS);
    
}

-(void)onPressedHomeButton:(NSNotification *)notification{
    
    //ホームボタンが押された時の対応：カウンターのため
    //時間を記憶
    NSLog(@"home button pressed and view becomes inActive, memorize timer and tm invalidate");
    [attr setValueToDevice:@"ymdMenuLastOpen"
                  strValue:[self getYYYYMMDD]];
    [attr setValueToDevice:@"hmsMenuLastOpen"
                  strValue:[self getHHMMSS]];
    [attr setValueToDevice:@"secondForLife"
                  strValue:[NSString stringWithFormat:@"%d", secondForLife]];
    [attr setValueToDevice:@"lifeGame"
                  strValue:[NSString stringWithFormat:@"%d", lifeGame]];
    
    [tm invalidate];
}

//viewWillAppearとtime関数から実行される
-(void)updateLifeAndSecond{
    
    //以下の目的：secondForLifeとlifeGameの更新
    NSString *strLifeGame =
    [attr getValueFromDevice:@"lifeGame"];
    lifeGame = strLifeGame.integerValue;
    NSString *ymdMenuLastOpen =
    [attr getValueFromDevice:@"ymdMenuLastOpen"];//最後にカウントされていた日にち
    NSString *hmsMenuLastOpen =
    [attr getValueFromDevice:@"hmsMenuLastOpen"];//最後にカウントされていた時間
    
    //    NSLog(@"lifegame= %@", strLifeGame);
    
    if([strLifeGame isEqual:[NSNull null]] ||
       strLifeGame == nil ||
       ymdMenuLastOpen == nil ||
       [ymdMenuLastOpen isEqual:[NSNull null]] ||
       hmsMenuLastOpen == nil ||
       [hmsMenuLastOpen isEqual:[NSNull null]]){
        lifeGame = maxLifeGame;
    }else{
        //前回のsecondForLifeがカウントされていた最後の日時と時刻からの経過時間passedSecondを計測
        if([ymdMenuLastOpen isEqualToString:[self getYYYYMMDD]]){//最後に観測されたのが同日ならば
            
            //getPassSecond:二つの時間からint型差額秒数を返す
            int passedSecond = [self getPassTime:hmsMenuLastOpen
                                            hms2:[self getHHMMSS]];
            NSLog(@"passedSec=%d, last=%@, now=%@", passedSecond,
                  hmsMenuLastOpen, [self getHHMMSS]);
            //secondForLifeの更新
            secondForLife = [attr getValueFromDevice:@"secondForLife"].integerValue - passedSecond;
            NSLog(@"secondForLife:%d, passedSecond:%d", secondForLife, passedSecond);
            
            //lifeGameの更新:短く書くと分かりにくい
            if(secondForLife < -maxSecondForLife * (maxLifeGame-1)){//30分以上経過
                lifeGame = MIN(lifeGame + (maxLifeGame-0), maxLifeGame);
                secondForLife += (maxLifeGame-1) * maxSecondForLife;
                //以下、残りの経過時間(secondForLifeの負値はmaxSecondForLifeからの経過時間とする)
                secondForLife = maxSecondForLife + secondForLife;
                //結局上記２行によってsecondForLife += maxLifeGame * maxSecondForLifeで良い
            }else if(secondForLife < -maxSecondForLife * (maxLifeGame-2)){//24分以上経過
                lifeGame = MIN(lifeGame + (maxLifeGame-1), maxLifeGame);
                //                secondForLife += (maxLifeGame-2) * maxSecondForLife;
                //                secondForLife = maxSecondForLife + secondForLife;
                secondForLife += (maxLifeGame - 1) * maxSecondForLife;
            }else if(secondForLife < -maxSecondForLife * (maxLifeGame-3)){//18分以上経過
                lifeGame = MIN(lifeGame + (maxLifeGame-2), maxLifeGame);
                //                secondForLife += (maxLifeGame-3) * maxSecondForLife;
                //                secondForLife = maxSecondForLife + secondForLife;
                secondForLife += (maxLifeGame - 2) * maxSecondForLife;
            }else if(secondForLife < -maxSecondForLife * (maxLifeGame-4)){//12分以上経過
                lifeGame = MIN(lifeGame + (maxLifeGame-3), maxLifeGame);
                //                secondForLife += (maxLifeGame-4) * maxSecondForLife;
                //                secondForLife = maxSecondForLife + secondForLife;
                secondForLife += (maxLifeGame - 3) * maxSecondForLife;
            }else if(secondForLife < -maxSecondForLife * (maxLifeGame-5)){//6分以上経過
                lifeGame = MIN(lifeGame + (maxLifeGame-4), maxLifeGame);
                //                secondForLife += (maxLifeGame-5) * maxSecondForLife;
                //                secondForLife = maxSecondForLife + secondForLife;
                secondForLife += (maxLifeGame - 4) * maxSecondForLife;
            }else if(secondForLife < 0){//6分未満の経過時間の場合
                lifeGame = MIN(lifeGame + (maxLifeGame-5), maxLifeGame);
                secondForLife += (maxLifeGame - 5) * maxSecondForLife;
            }
            secondForLife = MIN(secondForLife, maxSecondForLife);
            
            //            NSLog(@"lifeGame == %d", lifeGame);
            //            NSLog(@"secondForLife == %d", secondForLife);
        }else{//日付が違えば全回復
            lifeGame = maxLifeGame;
        }
        //        lifeGame = strLifeGame.integerValue;
    }
    if(lifeGame < maxLifeGame){
        NSLog(@"lifegameInt=%d", lifeGame);
        lbl_gameLife.text =
        [NSString stringWithFormat:@"%d ／ %d", lifeGame, maxLifeGame];
        if(secondForLife < maxSecondForLife){
            tv_timer.text = [self transformSecToMMSS:secondForLife];
        }else{
            tv_timer.text = @"MAX";
        }
    }else if(lifeGame == maxLifeGame){
        lbl_gameLife.text = @"MAX";
        tv_timer.text = @"MAX";
    }else if(lifeGame > maxLifeGame){//回復アイテム等を購入した場合にmaxを上回ることがある
        lbl_gameLife.text =
        [NSString stringWithFormat:@"%d ／ %d", lifeGame, maxLifeGame];
        
        secondForLife = maxSecondForLife;//秒数はマックスに設定
        tv_timer.text = @"MAX";
        
    }
    //上記により更新されたlifeGameとsecondForLifeを用いて、timeメソッド内でtv_timer, tv_lifegameに動的に反映
    
    NSLog(@"lifegame= %@", strLifeGame);
}
@end
