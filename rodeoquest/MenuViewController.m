//
//  ItemSelectViewController.m
//  Shooting5
//
//  Created by 遠藤 豪 on 13/10/07.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

//#define TEST//TestViewController-transition

#import "GADBannerView.h"
#import "BGMClass.h"
#import "MenuViewController.h"
#import "GameClassViewController.h"
#import "BackGroundClass2.h"
#import "ItemListViewController.h"
#import "DefenseUpListViewController.h"
#import "ItemUpListViewController.h"
#import "WeaponUpListViewController.h"
#import "LifeUpListViewController.h"
#import "CreateComponentClass.h"
#import "InviteFriendsViewController.h"
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

#define SIZE_FORMAL_BUTTON 50
#define INTERVAL_FORMAL_BUTTON 10

#define MARGIN_FORMAL_TO_START 2

#define W_BT_START 150
#define H_BT_START 50

#define ALPHA_COMPONENT 0.5

//NSMutableArray *imageFileArray;
//NSMutableArray *tagArray;
//NSMutableArray *titleArray;
NSMutableArray *arrNoImage;

UIView *subView;
UIButton *closeButton;//閉じるボタン
BGMClass *bgmClass;
BackGroundClass2 *backGround;
AttrClass *attr;



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
    }
    return self;
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
    
    
    backGround = [[BackGroundClass2 alloc]init:WorldTypeUniverse1
                                        width:self.view.bounds.size.width
                                       height:self.view.bounds.size.height
                                          secs:2.0f];
    
    
    [self.view addSubview:[backGround getImageView1]];
    [self.view addSubview:[backGround getImageView2]];
    [self.view bringSubviewToFront:[backGround getImageView1]];
    [self.view bringSubviewToFront:[backGround getImageView2]];
    
    
    
    [backGround startAnimation];//3sec-Round
    
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
                                                               text:@"Gold."
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
                                                               text:@"Gold."
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
    UITextView *tvGoldAmount = [CreateComponentClass createTextView:rectGoldAmount
                                                                text:strGold
                                                                font:@"AmericanTypewriter-Bold"
                                                                size:10
                                                           textColor:[UIColor whiteColor]
                                                           backColor:[UIColor clearColor]
                                                          isEditable:NO];
    [self.view addSubview:tvGoldAmount];
    
    
    
    
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
            
            UIImageView *bt = [CreateComponentClass createMenuButton:ButtonMenuBackTypeGreen
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
    
    UIImageView *bt_start = [CreateComponentClass createMenuButton:(ButtonMenuBackType)ButtonMenuBackTypeGreen
                                                         imageType:(ButtonMenuImageType)ButtonMenuImageTypeStart
                                                              rect:(CGRect)rect_start
                                                            target:(id)self
                                                          selector:(NSString *)@"pushedButton:"
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

-(void)pushedButton:(NSNumber *)num
{
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
            [backGround stopAnimation];
            //background stopAnimation(0.01sec必要)を実行しないとゲーム画面でアニメーションが開始されない(既存のiv animationが残っているため)
            //stopAnimationを実行するための0.01sを稼ぐためにここで0.1s-Delayさせる
            [self performSelector:@selector(gotoGame) withObject:nil afterDelay:0.1f];
#endif

            
            break;
        }
        case ButtonMenuImageTypeWeapon:{
            NSArray *imageArray = [NSArray arrayWithObjects:@"RockBow.png",
                                   @"FireBow.png",
                                   @"WaterBow.png",
                                   @"IceBow.png",
                                   @"BugBow.png",
                                   @"AnimalBow.png",
                                   @"GrassBow.png",
                                   @"ClothBow.png",
                                   @"SpaceBow.png",
                                   @"WingBow.png",
                                   nil];
            //画面中央部にイメージファイル、その周りに半透明ビュー、更にその周囲に透明ビュー(イメージ以外をタップすると消える)
            //購入した武器の分だけ右を見れる
            UIView *superView = [CreateComponentClass createSlideShow:CGRectMake(0,
                                                                                 50,
                                                                                 self.view.bounds.size.width,
                                                                                 self.view.bounds.size.height)
                                                            imageFile:imageArray
                                                               target:self
                                                            selector1:@"closeView:"
                                                            selector2:@"imageTapped:"];
            superView.tag = 0;
            [self.view addSubview:superView];
            
            
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
        case ButtonMenuImageTypeCoin:{
            
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
            UIView *viewFrame = [CreateComponentClass createView:CGRectMake(100, 70, 210, 250)];
            [viewFrame setBackgroundColor:[UIColor colorWithRed:0.1f green:0.6f blue:0.1f alpha:0.6f]];//どちらでも良い
            [viewSuperSuper addSubview:viewFrame];
            

            
            
            int imageInitX = 10;
            int imageInitY = 10;
            int imageWidth = 70;
            int imageHeight = 70;
            int imageMargin = 10;
            NSArray *image_array = [NSArray arrayWithObjects:@"close.png",@"close.png", @"close.png",nil] ;
            NSArray *arrMethod = [NSArray arrayWithObjects:@"setBGM:",@"setSE:", @"close.png",nil] ;
            for (int i = 0; i < [image_array count]; i++){
                CGRect rect_image = CGRectMake(imageInitX,
                                               imageInitY + i * (imageHeight + imageMargin),
                                               imageWidth,
                                               imageHeight);
                
                UIImageView *iv_item = [CreateComponentClass createSwitchButton:rect_image
                                                                          image:[image_array objectAtIndex:i]
                                                                            tag:[[NSString stringWithFormat:@"%d%d", 212, i] intValue]
                                                                         target:self
                                                                       selector:[arrMethod objectAtIndex:i]];
                
                [viewFrame addSubview:iv_item];
                
            }
            
//            [viewSuper addSubview:viewFrame];
//            [self.view addSubview:viewSuper];
            
            
            break;
        }
            
    }
//    switch(num.integerValue){
//        case 0:{//start game
//            NSLog(@"start games");
//            
//            if(bgmClass.getIsPlaying){
//                [bgmClass stop];
//            }
//            
//            
//#ifdef TEST
//            TestViewController *tvc = [[TestViewController alloc]init];
//            [self presentViewController: tvc animated:YES completion: nil];
//#else
//            [backGround pauseAnimations];//exitAnimationsはgotoGameの中で実行(画面が白くなってしまう)
//
//            //background stopAnimation(0.01sec必要)を実行しないとゲーム画面でアニメーションが開始されない(既存のiv animationが残っているため)
//            //stopAnimationを実行するための0.01sを稼ぐためにここで0.1s-Delayさせる
//            [self performSelector:@selector(gotoGame) withObject:nil afterDelay:0.1f];
//#endif
//            //参考戻る時(時間経過等ゲーム終了時で)：[self dismissModalViewControllerAnimated:YES];=>deprecated
////            NSLog(@"return");
////            [self dismissViewControllerAnimated:YES completion:nil];
//            break;
//        }
//        //上段
//        case 200:{//武器バージョンアップ
//            subView = [CreateComponentClass createView];
//            [self.view bringSubviewToFront:subView];
//            [self.view addSubview:subView];
//            
//            
//            CGRect rect_close = CGRectMake(285, 57, 20, 20);
////            closeButton = [self createButtonWithImage:@"close.png" tag:999 frame:rect_close];
//            closeButton = [CreateComponentClass createButtonWithType:ButtonMenuBackTypeGreen
//                                                                rect:rect_close
//                                                               image:@"close.png"
//                                                              target:self
//                                                            selector:@"pushed_button:"];//selector記述する必要あり。
//            closeButton.tag = 999;//
//            [self.view addSubview:closeButton];
//            break;
//        }
//        case 201:{//ドラゴン選択(フリックで選択)
//            
//            NSArray *imageArray = [NSArray arrayWithObjects:@"RockBow.png",
//                                  @"FireBow.png",
//                                  @"WaterBow.png",
//                                  @"IceBow.png",
//                                  @"BugBow.png",
//                                  @"AnimalBow.png",
//                                  @"GrassBow.png",
//                                  @"ClothBow.png",
//                                  @"SpaceBow.png",
//                                  @"WingBow.png",
//                                  nil];
//            //画面中央部にイメージファイル、その周りに半透明ビュー、更にその周囲に透明ビュー(イメージ以外をタップすると消える)
//            //購入した武器の分だけ右を見れる
//            UIView *superView = [CreateComponentClass createSlideShow:CGRectMake(0,
//                                                                                 50,
//                                                                                 self.view.bounds.size.width,
//                                                                                 self.view.bounds.size.height)
//                                                            imageFile:imageArray
//                                                               target:self
//                                                            selector1:@"closeView:"
//                                                            selector2:@"imageTapped:"];
//            superView.tag = 0;
//            [self.view addSubview:superView];
//            
//            
//            break;
//        }
//        case 202:{//回復
//            ItemListViewController *ilvc = [[ItemListViewController alloc]init];
//            [self presentViewController: ilvc animated:YES completion: nil];
//            break;
//        }
//        case 203:{//配合
//            break;
//        }
//        //下段
//        case 210:{//ドラゴン購入？＝＞ドラゴン選択と同じで良い？
//            break;
//        }
//        case 211:{//アイテム
//            ItemListViewController *ilvc = [[ItemListViewController alloc]init];
//            [self presentViewController: ilvc animated:YES completion: nil];
//            break;
//        }
//        case 212:{//設定画面：BGM,効果音、操作感度、ボイス、難易度
//            UIView *viewSuper = [CreateComponentClass createViewNoFrame:self.view.bounds
//                                                                  color:[UIColor clearColor]
//                                                                    tag:9999
//                                                                 target:self
//                                                               selector:@"closeView:"];//透明ビュー
//            [viewSuper setBackgroundColor:[UIColor colorWithRed:0.0f green:0 blue:0 alpha:0.7f]];
//            UIView *viewFrame = [CreateComponentClass createView:CGRectMake(100, 70, 210, 250)];
//            [viewFrame setBackgroundColor:[UIColor colorWithRed:0.1f green:0.6f blue:0.1f alpha:0.6f]];//どちらでも良い
//            
//            int imageInitX = 10;
//            int imageInitY = 10;
//            int imageWidth = 70;
//            int imageHeight = 70;
//            int imageMargin = 10;
////            NSArray *image_array = [NSArray arrayWithObjects:@"bgm.png",@"sound.png", @"difficulty.png",nil] ;
//            NSArray *image_array = [NSArray arrayWithObjects:@"close.png",@"close.png", @"close.png",nil] ;
//            
//            for (int i = 0; i < [image_array count]; i++){
//                CGRect rect_image = CGRectMake(imageInitX,
//                                               imageInitY + i * (imageHeight + imageMargin),
//                                               imageWidth,
//                                               imageHeight);
//                
//                UIImageView *iv_item = [CreateComponentClass createImageView:rect_image
//                                                                      image:[image_array objectAtIndex:i]
//                                                                        tag:[[NSString stringWithFormat:@"%d%d", 212, i] intValue]
//                                                                     target:self
//                                                                   selector:@"imageTapped:"];
////                iv_item.tag = 1;
//                [viewFrame addSubview:iv_item];
//            }
//            
//            [viewSuper addSubview:viewFrame];
//            [self.view addSubview:viewSuper];
//            
//            break;
//        }
//        case 213:{//課金画面
//            break;
//        }
//            /*
//        case 220:{
//            break;
//        }
//        case 221:{
//            break;
//        }
//        case 222:{
//            break;
//        }
//        case 223:{
//            break;
//        }
//             */
//        case 999:{
//            [subView removeFromSuperview];
//            [closeButton removeFromSuperview];
//            break;
//        }
//        case 9999:{
//            NSLog(@"pushed close button 9999");
//            break;
//        }
//            
//    }
}

-(void)imageTapped:(id)sender{
    NSLog(@"imageTapped at tag = %d", [sender view].tag);

    UIView *tappedView = [sender view];
    NSLog(@"imageTapped at tag = %d", tappedView.tag);
    switch(tappedView.tag){
        case 0://slideshowでタップされた場合=>出来ればtypedef NS_ENUMでグローバルに変数宣言しておく。例：TAPPED_SLIDESHOW
        {
            //他のタップレコナイザをunableにするため全体のビューを作成
            UIView *viewAll = [[UIView alloc]initWithFrame:self.view.bounds];
            [viewAll setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.9f]];//タップイベントを受け付けないビューを画面全体に配置
            UIView *viewFrame = [CreateComponentClass createView:CGRectMake(10, 80, 300, 300)];
            [viewFrame setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:0.5f]];
            UIButton *bt = [CreateComponentClass createButtonWithType:ButtonMenuBackTypeDefault
                                                                 rect:CGRectMake(260, 50, 25, 25)
                                                                image:@"close.png"
                                                               target:self
                                                             selector:@"closeSuperSuperView:"];//親クラスを削除する
            bt.tag = 9999;
            [viewFrame addSubview:bt];
            [viewAll addSubview:viewFrame];
            [self.view addSubview:viewAll];

            
            break;
            
        }
        case 2:
        {
            break;
        }
        case 100:{
            NSLog(@"invite");
            InviteFriendsViewController *inviteView = [[InviteFriendsViewController alloc] init];
            [self presentViewController:inviteView animated:YES completion:nil];
            break;
        }
        case 2120://TAPPED_BGM
        {
            NSLog(@"tapped image");
//            if( !audioPlayer.playing ){
//                [audioPlayer play];
//            } else {
//                [audioPlayer pause];
//            }
            if(![bgmClass getIsPlaying]){
                [bgmClass play:@"bgm_menu_683"];
            }else{
                [bgmClass pause];
            }
            break;
        }
        case 2121://TAPPED_BGM
        {
            NSLog(@"tapped image");
            break;
        }case 2122://TAPPED_BGM
        {
            NSLog(@"tapped image");
            break;
        }
        default :{
            break;
        }
    
    }
    return;
}
-(void)setBGM:(NSNumber *)num{
    NSLog(@"pressed setBGM : %d", [num intValue]);
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
    bgmClass = [[BGMClass alloc]init];
    if(arc4random() %2 == 0){
        [bgmClass play:@"bgm_menu_683"];
    }else{
        [bgmClass play:@"mahotoshi_hmix"];
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
@end
