//
//  ItemSelectViewController.m
//  Shooting5
//
//  Created by 遠藤 豪 on 13/10/07.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

//#define TEST//TestViewController-transition

#import <GameKit/GameKit.h>
#import "DBAccessClass.h"
#import "GADBannerView.h"
#import "BGMClass.h"
#import "MenuViewController.h"
#import "GameClassViewController.h"
#import "BackGroundClass2.h"
#import "WeaponBuyListViewController.h"
#import "ItemListViewController.h"
#import "DefenseUpListViewController.h"
#import "ItemUpListViewController.h"
#import "SpecialBeamClass.h"
#import "WeaponUpListViewController.h"
#import "LifeUpListViewController.h"
#import "CreateComponentClass.h"
#import "InviteFriendsViewController.h"
#import "PayProductViewController.h"
#import "TestViewController.h"
#import "AttrClass.h"
#import <QuartzCore/QuartzCore.h>

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
#define H_BT_START 50

#define ALPHA_COMPONENT 0.5

#define WEAPON_BUY_COUNT 10

//NSMutableArray *imageFileArray;
//NSMutableArray *tagArray;
//NSMutableArray *titleArray;
NSMutableArray *arrNoImage;
NSMutableArray *arrBtnBack;

UIView *subView;
UIButton *closeButton;//閉じるボタン
BGMClass *bgmClass;
BackGroundClass2 *backGround;
AttrClass *attr;

UITextView *tvGoldAmount_global;//金額はメニュー画面内で更新するのでグローバルに宣言しておく(武器やアイテムの購入等)



//ユーザー要望
UIView *viewMailSuperForm;
UITextView* tvSubject;
UITextView* tvDemand;
NSString *strSubject = @"お名前は匿名です。個人が特定されることはありません。";
NSString *strDemand = @"こちらにご要望をお書き下さい。\n頂いたご意見はアプリの改善に役立てるためだけに用い、他の用途には使用しません。\nご協力ありがとうございます。";


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
        
        //game centerにスコアを報告する
        GKScore *scoreReporter = [[GKScore alloc] initWithCategory:@"comendo.rodeoquest"];
        scoreReporter.value = rand() % 1000000;	// とりあえずランダム値をスコアに
        [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
            if (error != nil)
            {
                // 報告エラーの処理
                NSLog(@"error leaderboard : %@", error);
            }
        }];
        
        
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
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
    
    
    //タイトル配列
//    titleArray = [NSMutableArray arrayWithObjects:
//                  [NSArray arrayWithObjects:
//                   @"wpn",//
//                   @"drgn",
//                   @"heal",//INN:try-count recover
//                   @"配合",
//                   nil],
//                  [NSArray arrayWithObjects:
//                   @"buy",
//                   @"item",//
//                   @"set",//
//                   @"gold",//
//                   nil],
//                  nil];
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
                   [NSNumber numberWithInt:ButtonMenuBackTypeOrange],
                   [NSNumber numberWithInt:ButtonMenuBackTypeGreen],
                   [NSNumber numberWithInt:ButtonMenuBackTypeGreen],
                   [NSNumber numberWithInt:ButtonMenuBackTypeGreen],
                   nil],
                  [NSArray arrayWithObjects:
                   [NSNumber numberWithInt:ButtonMenuBackTypeGreen],
                   [NSNumber numberWithInt:ButtonMenuBackTypeBlue],
                   [NSNumber numberWithInt:ButtonMenuBackTypeBlue],
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
}
-(void)viewDidAppear:(BOOL)animated{
//    [self.view.subviews removeFromSuperview];
    
    //background
    [self setBackGroundInit];
    
    //ホームボタン押下後の再開時に以下の登録したメソッドから開始する
    [[NSNotificationCenter defaultCenter]
     addObserver:self
//     selector:@selector(applicationDidBecomeActive)
     selector:@selector(viewDidAppear:)
     name:UIApplicationDidBecomeActiveNotification
     object:nil];
    
    [self.view bringSubviewToFront:bannerView_];
    
    //時間を遅らせてBGM
    [self performSelector:@selector(playBGM) withObject:nil afterDelay:0.3];

//    NSLog(@"init select view controller start!!");
    int x_frame_center = (int)[[UIScreen mainScreen] bounds].size.width/2;
//    NSLog(@"%d" , x_frame_center);
//    int y_frame_center = (int)[[UIScreen mainScreen] bounds].size.height/2;//使用しない？
//    NSLog(@"中心＝%d", (int)[[UIScreen mainScreen] bounds].origin.x);
    
    //背景作成
//    UIImageView *iv_back = [self createImageView:@"chara_test2.png" tag:0 frame:[[UIScreen mainScreen] bounds]];
//    UIImageView *iv_back = [self createImageView:@"chara01.png" tag:0 frame:CGRectMake(-110, -10, 680, 500)];
//    UIImageView *iv_back = [[UIImageView alloc] initWithFrame:CGRectMake(-110, -10, 680, 500)];
    UIImageView *iv_back = [[UIImageView alloc] initWithFrame:CGRectMake(-110, -10, 544, 400)];
    iv_back.image = [UIImage imageNamed:@"chara01.png"];
    iv_back.center = self.view.center;//CGPointMake(self.view.center.x, self.view.center.y);
    [self animAirViewUp:iv_back];
//    iv_back.alpha = ALPHA_COMPONENT;
    [self.view sendSubviewToBack:iv_back];
    [self.view addSubview:iv_back];
    
    //_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    //_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    //_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    
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
    NSString *strLevel = [NSString stringWithFormat:@"%09d", [[attr getValueFromDevice:@"level"] intValue]];
    UITextView *tvLevelAmount = [CreateComponentClass createTextView:rectLevelAmount
                                                          text:strLevel
                                                          font:@"AmericanTypewriter-Bold"
                                                          size:10
                                                     textColor:[UIColor whiteColor]
                                                     backColor:[UIColor clearColor]
                                                    isEditable:NO];
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
    NSString *strExp = [NSString stringWithFormat:@"%09d", [[attr getValueFromDevice:@"exp"]
                                                            intValue]];
    
    UITextView *tvScoreAmount = [CreateComponentClass createTextView:rectScoreAmount
                                                                text:strExp
                                                                font:@"AmericanTypewriter-Bold"
                                                                size:10
                                                           textColor:[UIColor whiteColor]
                                                           backColor:[UIColor clearColor]
                                                          isEditable:NO];
    [self.view addSubview:tvScoreAmount];
    
    
    //獲得ゴールド数表示部分
    UIView *v_gold =
    [CreateComponentClass createView:CGRectMake(x_frame_center + MARGIN_UPPER_COMPONENT + W_MOST_UPPER_COMPONENT/2,
                                                Y_MOST_UPPER_COMPONENT,
                                                W_MOST_UPPER_COMPONENT,
                                                H_MOST_UPPER_COMPONENT)];
    [self.view addSubview:v_gold];
    //ゴールド表示部分:ラベル
    CGRect rectGoldLabel2 = CGRectMake(x_frame_center + MARGIN_UPPER_COMPONENT + W_MOST_UPPER_COMPONENT/2 + 7,    //影を先に付ける
                                       Y_MOST_UPPER_COMPONENT + H_MOST_UPPER_COMPONENT - 46,
                                       W_MOST_UPPER_COMPONENT,
                                       H_MOST_UPPER_COMPONENT);
    UITextView *tvGoldLabel2 = [CreateComponentClass createTextView:rectGoldLabel2
                                                               text:@"Zeny"
                                                               font:@"AmericanTypewriter-Bold"
                                                               size:15
                                                          textColor:[UIColor blackColor]
                                                          backColor:[UIColor clearColor]
                                                         isEditable:NO];
    [self.view addSubview:tvGoldLabel2];
    
    CGRect rectGoldLabel = CGRectMake(x_frame_center + MARGIN_UPPER_COMPONENT + W_MOST_UPPER_COMPONENT/2 + 3,
                                       Y_MOST_UPPER_COMPONENT + H_MOST_UPPER_COMPONENT - 50,
                                       W_MOST_UPPER_COMPONENT,
                                       H_MOST_UPPER_COMPONENT);
    UITextView *tvGoldLabel = [CreateComponentClass createTextView:rectGoldLabel
                                                               text:@"Zeny"
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
    NSString *strGold = [NSString stringWithFormat:@"%09d", [[attr getValueFromDevice:@"gold"] intValue]];
    tvGoldAmount_global = [CreateComponentClass createTextView:rectGoldAmount
                                                                text:strGold
                                                                font:@"AmericanTypewriter-Bold"
                                                                size:10
                                                           textColor:[UIColor whiteColor]
                                                           backColor:[UIColor clearColor]
                                                          isEditable:NO];
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
    
//    UIImageView *iv_ranking = [self createImageView:@"black_128.png"
//                                             tag:103
//                                           frame:CGRectMake(x_frame_center - W_RANKING_COMPONENT / 2,
//                                                            Y_MOST_UPPER_COMPONENT + H_MOST_UPPER_COMPONENT + MARGIN_UPPER_TO_RANKING,
//                                                            W_RANKING_COMPONENT,
//                                                            H_RANKING_COMPONENT)];
//    iv_ranking.alpha = ALPHA_COMPONENT;
//    [[iv_ranking layer] setCornerRadius:10.0];
//    [iv_ranking setClipsToBounds:YES];
//    [self.view bringSubviewToFront:iv_ranking];
//    [self.view addSubview:iv_ranking];

    
    
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
    
//    UIImageView *bt_start = [CreateComponentClass createMenuButton:(ButtonMenuBackType)ButtonMenuBackTypeGreen
//                                                         imageType:(ButtonMenuImageType)ButtonMenuImageTypeStart
//                                                              rect:(CGRect)rect_start
//                                                            target:(id)self
//                                                          selector:(NSString *)@"pushedButton:"
//                                                               tag:ButtonMenuImageTypeStart];
    UIButton *bt_start = [CreateComponentClass
                          createCoolButton:rect_start
                          text:@"START"
                          hue:0 saturation:1 brightness:1
                          target:self
                          selector:@"pushedStartButton:"
                          tag:ButtonMenuImageTypeStart];
    //丸角
//    [[bt_start layer] setCornerRadius:10.0];
//    [bt_start setClipsToBounds:YES];
    [self.view addSubview:bt_start];
    
    
    //キャラ変更部分(購入部分)
    
    
    //機体数増加部分(購入ページ)
    
    NSLog(@"ItemViewController start");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)gotoGame{

    GameClassViewController *gameView = [[GameClassViewController alloc] init];
    [self presentViewController: gameView animated:YES completion: nil];

    [backGround exitAnimations];

}
-(void)pushedStartButton:(id)sender{//UIButton型による定義
    NSNumber *num = [NSNumber numberWithInt:[sender tag]];
//-(void)pushedButton:(NSNumber *)num{//UIImageView型による定義
    
    NSLog(@"num = %d", num.integerValue);
    switch((ButtonMenuImageType)num.integerValue){
        case ButtonMenuImageTypeStart:{
            
            NSLog(@"start games");
            
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
            [self performSelector:@selector(gotoGame) withObject:nil];// afterDelay:0.1f];
            [backGround exitAnimations];
#endif

            
            break;
        }
        default:{
            break;
        }
    }
}
-(void)pushedButton:(NSNumber *)num{//UIImageView型による定義
    switch((ButtonMenuImageType)num.integerValue){
        case ButtonMenuImageTypeWeapon:{
            WeaponBuyListViewController *wblvc = [[WeaponBuyListViewController alloc]init];
            [self presentViewController: wblvc animated:YES completion: nil];
            
            
            //slide-show
//            NSArray *imageArray = [NSArray arrayWithObjects:
//                                   @"RockBow.png",
//                                   @"FireBow.png",
//                                   @"WaterBow.png",
//                                   @"IceBow.png",
//                                   @"BugBow.png",
//                                   @"AnimalBow.png",
//                                   @"GrassBow.png",
//                                   @"ClothBow.png",
//                                   @"SpaceBow.png",
//                                   @"WingBow.png",
//                                   nil];
//            //画面中央部にイメージファイル、その周りに半透明ビュー、更にその周囲に透明ビュー(イメージ以外をタップすると消える)
//            //購入した武器の分だけ右を見れる
//            UIView *superView = [CreateComponentClass createSlideShow:CGRectMake(0,
//                                                                                 50,
//                                                                                 self.view.bounds.size.width,
//                                                                                 self.view.bounds.size.height)
//                                                            imageFile:imageArray
//                                                               target:self
//                                                            selector1:@"closeView:"
//                                                            selector2:@"weaponSelected:"];
////                                                            selector2:@"imageTapped:"];
//            superView.tag = 0;
//            [self.view addSubview:superView];
            
            
            break;
        }
        case ButtonMenuImageTypeDefense:{
            [backGround stopAnimation];//これをしないと裏で動いてしまう
            DefenseUpListViewController *ilvc = [[DefenseUpListViewController alloc]init];
            [self presentViewController: ilvc animated:YES completion: nil];
            break;
        }
        case ButtonMenuImageTypeItem:{
            [backGround stopAnimation];//これをしないと裏で動いてしまう
            ItemUpListViewController *ilvc = [[ItemUpListViewController alloc]init];
            [self presentViewController: ilvc animated:YES completion: nil];
            break;
        }
        case ButtonMenuImageTypeWpnUp:{
            [backGround stopAnimation];//これをしないと裏で動いてしまう
            WeaponUpListViewController *ilvc = [[WeaponUpListViewController alloc]init];
            [self presentViewController: ilvc animated:YES completion: nil];
            break;
        }
        case ButtonMenuImageTypeInn:{
//            [backGround pauseAnimations];
            [backGround stopAnimation];//これをしないと裏で動いてしまう
            LifeUpListViewController *ilvc = [[LifeUpListViewController alloc]init];
            [self presentViewController: ilvc animated:YES completion: nil];
            break;
        }
        case ButtonMenuImageTypeCoin:{//コイン購入画面へ
            PayProductViewController *ppvc = [[PayProductViewController alloc]init];
            [self presentViewController:ppvc animated:NO completion:nil];
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
                                 [NSNumber numberWithInt:ButtonSwitchImageTypeSpeaker],
                                 [NSNumber numberWithInt:ButtonSwitchImageTypeBGM],
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
                                                                            tag:[[NSString stringWithFormat:@"%d%d", 212, i] intValue]
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
            int heightForm = 150;
            int heightSubjects = 40;
            //件名
            UILabel *lbSubject = [[UILabel alloc]initWithFrame:CGRectMake(xSubject, ySubject, wSubject, hSubject)];
            lbSubject.text = @" 件名:";
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
                                                                                   tvDemand.frame.origin.y + tvDemand.frame.size.height + 10,
                                                                                   widthButton, heightButton)
                                                                   text:@"send!"
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
                                                                    text:@"close"
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
    
    //武器タグの場合
    
    switch(tappedView.tag){//->MenuTagType
        //case:0 - 9 => definite in upper for-loop
        case 100:{
//            NSLog(@"invite");
//            InviteFriendsViewController *inviteView = [[InviteFriendsViewController alloc] init];
//            [self presentViewController:inviteView animated:YES completion:nil];
            
            NSLog(@"leader board");
            //learderboard
            GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
            leaderboardController.leaderboardDelegate = self;
            //    [self presentModalViewController:leaderboardController animated:YES];
            [self presentViewController: leaderboardController animated:YES completion: nil];

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
    NSString *value = ([[_myDefaults objectForKey:name] intValue]==1)?@"0":@"1";
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

//-(UIButton*)createButtonWithImage:(NSString*)imageFile tag:(int)tag frame:(CGRect)frame
//{
//    //画像を表示させる場合：http://blog.syuhari.jp/archives/1407
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    button.frame = frame;
//    button.tag   = tag;
//    UIImage *image = [UIImage imageNamed:imageFile];
//    [button setBackgroundImage:image forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(pushed_button:)
//     forControlEvents:UIControlEventTouchUpInside];
//    return button;
//}
//-(UIButton*)createButtonWithTitle:(NSString*)title tag:(int)tag frame:(CGRect)frame
//{
//    //画像を表示させる場合：http://blog.syuhari.jp/archives/1407
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    button.frame = frame;
//    button.tag   = tag;
//    [button setTitle:title forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(pushed_button:)
//     forControlEvents:UIControlEventTouchUpInside];
//    return button;
//}


-(UIImageView*)createImageView:(NSString*)filename tag:(int)tag frame:(CGRect)frame{
    UIImageView *iv = [[UIImageView alloc] initWithFrame:frame];
    iv.tag = tag;
    iv.image = [UIImage imageNamed:filename];
    return iv;
}


-(void)animAirViewUp:(UIView *)view{//浮遊アニメーション
    
    CGPoint kStartPos = self.view.center;//((CALayer *)[view.layer presentationLayer]).position;
    CGPoint kEndPos = self.view.center;
    [CATransaction begin];
//    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [CATransaction setCompletionBlock:^{//終了処理
//        [self animAirView:view];
        CAAnimation *animationKeyFrame = [view.layer animationForKey:@"position"];
        if(animationKeyFrame){
            //途中で終わらずにアニメーションが全て完了して
//            [self animAirViewDown:view];
            [self animAirViewUp:view];
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
        [view.layer addAnimation:animation forKey:@"position"];
        
    }
    [CATransaction commit];
}

-(void)setBackGroundInit{
    NSLog(@"set background init");
    [backGround exitAnimations];//前のアニメーションの停止
    
    backGround = [[BackGroundClass2 alloc]init:WorldTypeUniverse1
                                         width:self.view.bounds.size.width
                                        height:self.view.bounds.size.height
                                          secs:5.0f];
    
    
    [self.view addSubview:[backGround getImageView1]];
    [self.view addSubview:[backGround getImageView2]];
    [self.view bringSubviewToFront:[backGround getImageView1]];
    [self.view bringSubviewToFront:[backGround getImageView2]];
    [backGround startAnimation];//3sec-Round
}
@end
