//
//  GameClassViewController2.m
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2014/01/07.
//  Copyright (c) 2014年 endo.tuyo. All rights reserved.
//

//#define log//NSLog-TEST

//#define STATUSBAR_MODE
//#define ENEMY_TEST
#define FREQ_ENEMY 10//Freq_Enemyカウントに一回発生

#define MAX_ENEMY_NUM 50

//#define COUNT_TEST

#import "GameClassViewController2.h"

#define TIMEOVER_SECOND 1000
#define OBJECT_SIZE 70//自機と敵機のサイズ
#define ITEM_SIZE 50

CGRect rect_frame, rect_myMachine, rect_enemyBeam, rect_beam_launch;
UIImageView *iv_frame, *iv_myMachine, *iv_enemyBeam, *iv_beam_launch;//, *iv_background1, *iv_background2;
UIView* viewScoreField;
UILabel *lblScore;
UILabel *lblGold;

Boolean flagIsDown1;
Boolean flagIsDown2;
int countFirstUserTouchEnable;//最初にユーザーのタッチを受け付けるまでのカウンター
int timeIntervalEnemy;
int timeIntervalEnemyMax;

AttrClass *attr;

UIView *_loadingView;
UIActivityIndicatorView *_indicator;

#ifdef COUNT_TEST
UITextView *tvCount;//テスト用
#endif

#ifdef STATUSBAR_MODE
UILabel *label_test;
#endif

int world_no;


//NSMutableArray *iv_arr_tokuten;
int y_background1, y_background2;

//敵オブジェクト：removeFromSuperviewするため
//gameClassViewCon:remove from Arrayするため
const int explosionCycle2 = 30;//爆発時間:敵オブジェクトでも定義
int max_enemy_in_frame;
int x_frame, y_frame;
//int x_myMachine, x_enemyMachine, x_beam;
//int y_myMachine, y_enemyMachine, y_beam;
int size_machine;
int length_beam, thick_beam;//ビームの長さと太さ
Boolean isGameMode;
Boolean flagItemTrigger;//エフェクト表示トリガー
Boolean isEffectDisplaying;//エフェクト表示中フラグ
//Boolean isMagnetMode;//マグネットモード
int diameterMagnet;//マグネット引力有効範囲
//int countMagnet;//マグネット有効期間
//Boolean isBigMode;//ビッグモード
//int countBig;


//パワースポットによる弾丸パワー倍率
int multipleBulletPower;

UIPanGestureRecognizer *panGesture;
//UILongPressGestureRecognizer *longPress_frame;
Boolean isTouched;

BackGroundClass2 *BackGround;
UIImageView *viewBackBack;
MyMachineClass *MyMachine;
NSMutableArray *EnemyArray;
//NSMutableArray *BeamArray;
NSMutableArray *ItemArray;
//NSMutableArray *KiraArray;
ScoreBoardClass *ScoreBoard;
GoldBoardClass *GoldBoard;

PowerGaugeClass *powerGauge;//imageviewを内包
//UIImageView *iv_powerGauge;
//UIImageView *iv_pg_ribrary;
//UIImageView *iv_pg_circle;
//UIImageView *iv_pg_cross;



NSTimer *timer;
BGMClass *bgmClass;
float gameSecond2 = 0;//timer->0.01sec
int timeEnemyRowYield2 = 100;//100countで敵列発生
int countEnemyRowYield2 = 0;//上記timeのカウンター
int countItem2 = 0;//テスト用

//ordinaryMethod内部で使用するテンポラリー変数
ItemClass *_item;
ItemType itemType;
EnemyClass *_enemy;
BeamClass *_beam;//
int _xMine;
int _yMine;
int _sMine;
int _xEnemy;
int _yEnemy;
int _sEnemy;
int _xItem;
int _yItem;
int _sItem;
int _xBeam;
int _yBeam;
int _sBeam;


int mySize2 = OBJECT_SIZE;//拡大した時のために変更可能にしておく

UIView *viewMyEffect;


@interface GameClassViewController2 ()
<ASFriendPickerViewControllerDelegate>
@end




@implementation GameClassViewController2

@synthesize sound_hit_URL;
@synthesize sound_hit_ID;
@synthesize sound_damage_URL;
@synthesize sound_damage_ID;
@synthesize sound_itemGet_URL;
@synthesize sound_itemGet_ID;
@synthesize sound_died_URL;
@synthesize sound_died_ID;
Boolean isBGM;
Boolean isSE;
int sensitivity;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //if home-button is pressed:
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(pressedHomeButton)
                                                     name: @"didEnterBackground"
                                                   object: nil];
        
        
    }
    
    return self;
}
//ステータスバー非表示の一環
- (BOOL)prefersStatusBarHidden {
    return YES;
}

//viewDidLoadの次に呼ばれる
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setBackGroundInit];//defined at viewDidLoad called before viewwillappear
    
    //次に描画するため
    //http://stackoverflow.com/questions/4175729/run-animation-every-time-app-is-opened
    //In iOS 4, pressing the home button doesn't terminate the app, it suspends it. When the app is made active again, a UIApplicationDidBecomeActiveNotification is posted. Register for that notification and initiate the animation in you
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(setBackGroundInit)
     name:UIApplicationDidBecomeActiveNotification
     object:nil];
    
}


//画面が表示されてからアニメーションを実施
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //test:showactivity
    [self showActivityIndicator];
    
    //ビーム位置をアニメーション終了位置から発射させるために座標のみ移動後にセットしておく
    [MyMachine setX:[UIScreen mainScreen].bounds.size.width/2];
    [MyMachine setY:[UIScreen mainScreen].bounds.size.height-100];
    
    
    //mymachineを定位置にアニメートさせる
    [UIView animateWithDuration:0.5f
                     animations:^{
                         [MyMachine getImageView].center =
                         CGPointMake([UIScreen mainScreen].bounds.size.width/2,
                                     [UIScreen mainScreen].bounds.size.height-100);
                     }
                     completion:^(BOOL finished){
                         
                         if(finished){
                             //以下実行後、0.01秒間隔でtimerメソッドが呼び出されるが、それと並行してこのメソッド(viewDidLoad)も実行される(マルチスレッドのような感じ)
                             
                             if(timer != nil){
                                 NSLog(@"timer is not nil : %@", timer);
                                 timer = nil;
                                 [timer invalidate];
                             }
                             timer = [NSTimer scheduledTimerWithTimeInterval:0.01f
                                                                      target:self
                                                                    selector:@selector(time:)//タイマー呼び出し
                                                                    userInfo:nil
                                                                     repeats:YES];
                             
                             for(int i = 0 ;i < 1;i++){
                                 //敵1体生成とビーム1個生成
                                 [self initEnemyBreak];
                                 enemyCount++;
                                 enemyDown++;
                             }
                         }
                     }];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIApplicationDidBecomeActiveNotification
     object:nil];
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    countFirstUserTouchEnable = 100;
    timeIntervalEnemyMax = 300;//3sec
    timeIntervalEnemy = timeIntervalEnemyMax;
    
    //時間計測用
    startDate = [NSDate date];
    worldType = arc4random() % WorldTypeCount;
    
    //いつでもデータを取り出せるようにグローバルに保存しておく：最初の一度だけにする
    attr = [[AttrClass alloc]init];//実際に使うのは最後のデータ表示部分@sendRequest...
    if([[attr getValueFromDevice:@"powerspot"] isEqualToString:@"0"]){
        multipleBulletPower = 1;
    }else{//近さに応じて３倍、４倍にする？=>将来的仕様
        multipleBulletPower = 2;//弾丸パワーを２倍に強化
    }
    
    //bgmの有効化判定
    if([[attr getValueFromDevice:@"bgm"] isEqual:[NSNull null]] ||
       [attr getValueFromDevice:@"bgm"] == nil ||
       [[attr getValueFromDevice:@"bgm"] isEqual:@"1"]){
        isBGM = YES;
    }else{
        isBGM = NO;
    }
    
    //seの有効化判定
    if([[attr getValueFromDevice:@"se"] isEqual:[NSNull null]] ||
       [attr getValueFromDevice:@"se"] == nil ||
       [[attr getValueFromDevice:@"se"] isEqual:@"1"]){
        isSE = YES;
    }else{
        isSE = NO;
    }
    
    if([[attr getValueFromDevice:@"sensitivity"] isEqual:[NSNull null]] ||
       [attr getValueFromDevice:@"sensitivity"] == nil){
        sensitivity = 0;
    }else{
        sensitivity = [attr getValueFromDevice:@"sensitivity"].integerValue;//value-domain=0,1,2;
    }
    
    
    
    
    
    flagItemTrigger = false;
    
    //ビームヒット音等のSound-Effect
    CFBundleRef mainBundle;
    mainBundle = CFBundleGetMainBundle ();
    
    if(isSE){//no-sound??
        NSLog(@"set sound-effect:%d", isSE);
        //敵機撃破
        sound_hit_URL  = CFBundleCopyResourceURL (mainBundle,CFSTR ("flinging"),CFSTR ("mp3"),NULL);
        AudioServicesCreateSystemSoundID (sound_hit_URL, &sound_hit_ID);
        CFRelease (sound_hit_URL);
        
        //敵機ダメージ：耳障りの良い物を選択しなければならない
        //    sound_damage_URL  = CFBundleCopyResourceURL (mainBundle,CFSTR ("gunshot3"),CFSTR ("mp3"),NULL);//耳障り
        sound_damage_URL  = CFBundleCopyResourceURL (mainBundle,CFSTR ("damage3"),CFSTR ("mp3"),NULL);//耳障り
        AudioServicesCreateSystemSoundID (sound_damage_URL, &sound_damage_ID);
        CFRelease (sound_damage_URL);
        
        sound_itemGet_URL  = CFBundleCopyResourceURL (mainBundle,CFSTR ("synth-sweep1"),CFSTR ("mp3"),NULL);
        AudioServicesCreateSystemSoundID (sound_itemGet_URL, &sound_itemGet_ID);
        CFRelease (sound_itemGet_URL);
        
        sound_died_URL  = CFBundleCopyResourceURL (mainBundle,CFSTR ("explosion1"),CFSTR ("mp3"),NULL);
        AudioServicesCreateSystemSoundID (sound_died_URL, &sound_died_ID);
        CFRelease (sound_died_URL);
    }
    
#ifdef COUNT_TEST
    //秒数カウンターテスト用
    tvCount = [CreateComponentClass createTextView:CGRectMake(self.view.bounds.size.width-100, 100, 100, 50)
                                              text:@"count:0"];
    
    [tvCount setBackgroundColor:[UIColor blackColor]];
    tvCount.textColor = [UIColor whiteColor];
    [self.view addSubview:tvCount];
#endif
    
    
    // ステータスバーを非表示にする
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        //ios7用
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    else
    {
        // bar非表示：iOS 6=>iOS 7ではきかない
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
    // Do any additional setup after loading the view.
    
    //ステージ選択
    world_no = arc4random() % 6;
    
    //BGM START=0.1second-delay
    [self performSelector:@selector(playBGM) withObject:nil afterDelay:0.1];
    
    
    //UI編集：ナビゲーションボタンの追加＝一時停止
    
    UIBarButtonItem* right_button_stop = [[UIBarButtonItem alloc] initWithTitle:@"stop"
                                                                          style:UIBarButtonItemStyleBordered
                                                                         target:self
                                          //                                                                         action:@selector(alertView:clickedButtonAtIndex:)];
                                                                         action:@selector(onClickedStopButton)];
    UIBarButtonItem* right_button_setting = [[UIBarButtonItem alloc]
                                             initWithTitle:@"set"
                                             style:UIBarButtonItemStyleBordered
                                             target:self
                                             action:@selector(onClickedSettingButton)];
    
    isGameMode = true;
    isTouched = false;
    //    isMagnetMode = false;
    //    isBigMode = false;
    diameterMagnet = 200;//引力有効範囲：アイテム購入により変更可能
    self.navigationItem.rightBarButtonItems = @[right_button_stop, right_button_setting];
    self.navigationItem.leftItemsSupplementBackButton = YES; //戻るボタンを有効にする
    
    max_enemy_in_frame = 20;
    
    
    //タッチ用パネル(タップ＆フリックで自機移動、タップしている間はビーム発射)
    rect_frame = [[UIScreen mainScreen] bounds];
    x_frame = rect_frame.size.width;
    y_frame = rect_frame.size.height;
    NSLog(@"frame-size : %d, %d", x_frame, y_frame);
    iv_frame = [[UIImageView alloc]initWithFrame:rect_frame];
    iv_frame.center = CGPointMake(self.view.frame.size.width/2,
                                  self.view.frame.size.height/2);
    //    iv_frame.image =[UIImage imageNamed:@"gameover.png"];
    iv_frame.userInteractionEnabled = YES;
    panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                         action:@selector(onFlickedFrame:)];
    //LongPressGestureRecogを付けてしまうとtouchesEnded:メソッドが実行されないかも？
    //もしやるとしたら→http://teru2-bo2.blogspot.jp/2012/04/uilongpressgesturerecognizer.html
    //    longPress_frame=
    //        [[UILongPressGestureRecognizer alloc]initWithTarget:self
    //                                                     action:@selector(onLongPressedFrame:)];
    //    UITapGestureRecognizer *tap_frame = [[UITapGestureRecognizer alloc] initWithTarget:self
    //                                                                                action:@selector(onTappedFrame:)];
    [iv_frame addGestureRecognizer:panGesture];
    //    [iv_frame addGestureRecognizer:longPress_frame];
    
    //    [iv_frame addGestureRecognizer:tap_frame];
    
    //ビューにメインイメージを貼り付ける：最前面に貼付けるためこのメソッドの最後ら辺でbringFrontする
    [self.view addSubview:iv_frame];
    
    
    length_beam = 20;
    thick_beam = 5;
    
    //敵の発生時の格納箱初期化
    EnemyArray = [[NSMutableArray alloc]init];
    
    //背景インスタンス定義
    NSLog(@"init background instance from game view controller");
    [self setBackGroundInit];//set equals to func below
    //    BackGround = [[BackGroundClass2 alloc]init:worldType
    //                                         width:self.view.bounds.size.width
    //                                        height:self.view.bounds.size.height
    //                                          secs:5.0f];
    //
    //
    //    [self.view addSubview:[BackGround getImageView1]];
    //    [self.view addSubview:[BackGround getImageView2]];
    //    [self.view bringSubviewToFront:[BackGround getImageView1]];
    //    [self.view bringSubviewToFront:[BackGround getImageView2]];
    
    
    //    [(UIImageView *)[BackGround getImageView1] moveTo:CGPointMake(0, 400)
    //                                             duration:200.0f
    //                                               option:UIViewAnimationOptionCurveLinear];//一定速度
    
    //自機定義
    //    MyMachine = [[MyMachineClass alloc] init:x_frame/2 size:OBJECT_SIZE];
    //    MyMachine = [[MyMachineClass alloc] init:x_frame/2 size:OBJECT_SIZE level:[[attr getValueFromDevice:@"level"] intValue]];
    int beamType = -1;
    for(int i = 0; i < 10; i++){//beamTypeの個数だけ
        if([[attr getValueFromDevice:[NSString stringWithFormat:@"weaponID%d", i]] isEqualToString:@"2"]){
            beamType = i;
            break;
        }
    }
    
    MyMachine = [[MyMachineClass alloc] init:x_frame/2
                                        size:OBJECT_SIZE
                                       level:[[attr getValueFromDevice:@"level"] intValue]
                                    spWeapon:beamType];
    
    [self.view addSubview:[MyMachine getImageView]];
    [self.view bringSubviewToFront:[MyMachine getImageView]];
    NSLog(@"mymachine bring front");
    //    [[MyMachine getImageView] startAnimating];
    
    //自機エフェクトを描画するビュー
    viewMyEffect = [[UIView alloc] initWithFrame:[MyMachine getImageView].frame];
    //    [viewMyEffect setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.2f]];
    [self.view addSubview:viewMyEffect];
    [self.view bringSubviewToFront:viewMyEffect];
    
    //自機が発射したビームを格納する配列初期化=>MyMachineクラス内に実装
    //    BeamArray = [[NSMutableArray alloc] init];
    
    //敵機を破壊した際のアイテム
    ItemArray = [[NSMutableArray alloc] init];
    
    //アイテム生成時、移動時、消滅時のパーティクル格納用配列
    //    KiraArray = [[NSMutableArray alloc]init];
    
    //スコアボードを置くフィールド
    viewScoreField = [CreateComponentClass createView:CGRectMake(5, 5, 140, 70)];
    [viewScoreField setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5]];
    [self.view addSubview:viewScoreField];
    
    //ornament
    UIImageView *viewOrnament1 =
    [[UIImageView alloc] initWithFrame:CGRectMake(5, 2, 60, 60)];
    viewOrnament1.image = [UIImage imageNamed:@"frame02.png"];
    [viewScoreField addSubview:viewOrnament1];
    UIImageView *viewOrnament2 =
    [[UIImageView alloc] initWithFrame:viewOrnament1.bounds];
    viewOrnament2.image = [UIImage imageNamed:@"frame02.png"];
    CGAffineTransform t1 =    //アフィン変換：180degree rotate
    CGAffineTransformMakeTranslation(viewScoreField.bounds.size.width-viewOrnament1.bounds.size.width-5,8);//adjustment
    viewOrnament2.transform = CGAffineTransformRotate(t1, M_PI);
    [viewScoreField addSubview:viewOrnament2];
    
    
    lblScore = [[UILabel alloc]init];
    lblScore.text = @"0";
    lblScore.textColor = [UIColor whiteColor];
    lblScore.backgroundColor = [UIColor clearColor];
    lblScore.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:14];
    [lblScore sizeToFit];
    //temporary
    lblScore.center = CGPointMake(viewScoreField.bounds.size.width-lblScore.bounds.size.width/2-10,
                                  lblScore.bounds.size.height/2+10);
    [viewScoreField addSubview:lblScore];
    
    lblGold = [[UILabel alloc]init];
    lblGold.text = @"0";
    lblGold.textColor = [UIColor whiteColor];
    lblGold.backgroundColor = [UIColor clearColor];
    lblGold.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:14];
    [lblGold sizeToFit];
    //temporary
    lblGold.center = CGPointMake(viewScoreField.bounds.size.width-lblGold.bounds.size.width/2-10,
                                 lblScore.bounds.size.height + lblGold.bounds.size.height/2+20);
    [viewScoreField addSubview:lblGold];
    
    
    
    //スコアボードの初期化
    ScoreBoard = [[ScoreBoardClass alloc]init:0 x_init:0 y_init:0 ketasu:7];
    [ScoreBoard getTextView].center = CGPointMake(viewScoreField.frame.size.width/2,
                                                  [ScoreBoard getTextView].frame.size.height/2);
    [ScoreBoard getTextView].textAlignment = NSTextAlignmentRight;
    //スコアボードの表示(初期状態ではゼロ)
    [self displayScore:ScoreBoard];
    
    //label
    UITextView *tvScoreLabel = [CreateComponentClass
                                createTextView:CGRectMake(10, 0,80,
                                                          [ScoreBoard getTextView].frame.size.height)
                                text:@"Score"
                                font:@"AmericanTypewriter-Bold"
                                size:15
                                textColor:[UIColor whiteColor]
                                backColor:[UIColor clearColor]
                                isEditable:NO];
    [viewScoreField addSubview:tvScoreLabel];
    
    
    
    //ゴールドの初期化と表示
    //    GoldBoard = [[GoldBoardClass alloc]init:0 x_init:0 y_init:50 ketasu:10 type:@"gold"];
    GoldBoard = [[GoldBoardClass alloc] init:0 x_init:0 y_init:0 ketasu:7];
    [GoldBoard getTextView].center = CGPointMake(viewScoreField.frame.size.width/2,
                                                 viewScoreField.frame.size.height - [GoldBoard getTextView].frame.size.height/2);
    //    [[GoldBoard getTextView] setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];//test
    [GoldBoard getTextView].textAlignment = NSTextAlignmentRight;
    [self displayScore:GoldBoard];
    
    //coin-image
    UIImageView *ivCoinLabel = [CreateComponentClass
                                createImageView:CGRectMake(0, 0, 20, 20)
                                image:@"coin_yellow.png"];
    ivCoinLabel.center = CGPointMake(viewScoreField.frame.size.width/3 - ivCoinLabel.frame.size.width/2,
                                     [GoldBoard getTextView].frame.origin.y + [GoldBoard getTextView].frame.size.height/2);
    [viewScoreField addSubview:ivCoinLabel];
    
    
    
    
    size_machine = 100;
    
    
    gameSecond2 = 0;
    
    
    //パワーゲージの描画:新機種のframeサイズに応じて変える
    //    int devide_frame = 3;
    //    int x_pg, y_pg, width_pg, height_pg;
    //    x_pg = rect_frame.size.width * (devide_frame - 1)/devide_frame;//左側１／４
    //    y_pg = rect_frame.size.height * (devide_frame - 1)/devide_frame;//下側１／４
    //    width_pg = MIN(x_pg / devide_frame, y_pg /devide_frame);
    //    height_pg = MIN(x_pg / devide_frame, y_pg /devide_frame);
    //
    //    powerGauge = [[PowerGaugeClass alloc ]init:0 x_init:x_pg y_init:y_pg width:width_pg height:height_pg];
    //    //    [powerGauge getImageView].transform = CGAffineTransformMakeRotation(2*M_PI* (float)(count-1)/60.0f );
    //    [self.view addSubview:[powerGauge getImageView]];
    
    
    //power gauge定義以上。
    
    
    //一時停止ボタン
    int size_pause = 20;
    CGRect rect_pause = CGRectMake(0, 0 , size_pause, size_pause);
    //    UIImageView *iv_pause = [[UIImageView alloc]initWithFrame:CGRectMake(rect_frame.size.width / 2 - size_pause / 2,0 , size_pause, size_pause)];
    UIImageView *iv_pause = [CreateComponentClass createImageView:rect_pause image:@"pause.png" tag:0 target:self selector:@"onClickedStopButton"];
    iv_pause.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,15);
    [iv_frame bringSubviewToFront:iv_pause];//iv_frameの上にボタン配置
    [iv_frame addSubview:iv_pause];
    
    
    
#ifdef STATUSBAR_MODE
    label_test = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, 100, 50)];
    label_test.text = @"test";
    label_test.font = [UIFont fontWithName:@"AppleGothic" size:12];
    [self.view addSubview:label_test];
    [self.view bringSubviewToFront:label_test];
#endif
    
    [self.view bringSubviewToFront: iv_frame];//最前面に
    
    
    
}//viewDidLoad

/**
 *tmインスタンスによって一定時間呼び出されるメソッド
 *一定間隔呼び出しは[tm invalidate];によって停止される
 */
- (void)time:(NSTimer*)timer{
#ifdef COUNT_TEST
    tvCount.text = [NSString stringWithFormat:@"counter:%f", gameSecond2];
#endif
    
    //onFlickedFrameを実行出来る
    if(countFirstUserTouchEnable != 0){
        countFirstUserTouchEnable--;
        if(countFirstUserTouchEnable == 0){
            //初めてユーザーがタッチ可能になったら
            [self hideActivityIndicator];//くるくるを消す
        }
    }else{
    }
    
    if(isGameMode){
//    if(isGameMode && countFirstUserTouchEnable == 0){
        //        NSLog(@"count = %f from timer", count);
        [self ordinaryAnimationStart];
        //        NSLog(@"complete ordinaryAnimation from timer");
        //一定時間経過するとゲームオーバー
        //        if(count >= TIMEOVER_SECOND || ![MyMachine getIsAlive]){
        //            NSLog(@"gameover");
        //経過したらタイマー終了
        //            [self performSelector:@selector(exitProcess) withObject:nil afterDelay:0.1];//自機爆破後、即座に終了させると違和感あるため少しdelay
        //            [self exitProcess];//delayさせるとその間にprogressが進んでしまうので即座に表示
        //        }
        gameSecond2 += 0.01f;
        timeIntervalEnemy--;//敵
        
        //終了モードは辞める(ユーザーが努力した分だけ進めるようにする)
        //        if(count >= TIMEOVER_SECOND){
        //            isGameMode = false;
        //            [self exitProcess];//delayさせるとその間にprogressが進んでしまうので即座に表示
        //        }
        
    }else{
        
        //[tm invalidate]をしないでisGameMode=falseとなった時 ＝ 一時停止ボタンが押された時もしくはプレイヤー撃破時
        //停止中画面に移行(一時停止用UIImageViewの表示)
        
    }
    
    /*
     *敵を100体生成して配列に格納して表示して消滅させるだけでは、その後も画面固定現象は確認
     *ゲームと全く同じ現象を再現するためにビームを生成し、配列に格納し、衝突判定、エフェクトも全て同様に実行して、画面固定現象が再現されるか確認。
     */
    
    //test
//    if(countFirstUserTouchEnable != 0){//initially false
//        //仮想的に敵を生成して、すぐに消去
////        if(countFirstUserTouchEnable == 0){
//        [self initEnemyBreak];
////        }
//        //        [self hideActivityIndicator];
//        countFirstUserTouchEnable --;
//    }
    
    
    
#ifdef log
    NSLog(@"timer complete");
#endif
}

//BGM曲をかける
-(void)playBGM{
    if([[attr getValueFromDevice:@"bgm"] isEqual:[NSNull null]] ||
       [attr getValueFromDevice:@"bgm"] == nil ||
       [[attr getValueFromDevice:@"bgm"] isEqual:@"1"]){
        
        bgmClass = [[BGMClass alloc]init];
        switch (world_no) {
            case 0:
            {
                [bgmClass play:@"hisho_hmix"];
                break;
            }
            case 1:
            {
                [bgmClass play:@"bgm_game_687"];
                break;
            }
            case 2:
            {
                [bgmClass play:@"ones_hmix"];
                break;
            }
            case 3:
            {
                [bgmClass play:@"hisho_hmix"];
                break;
            }
            case 4:
            {
                [bgmClass play:@"kinpaku_hmix"];
                break;
            }
            case 5:{
                
                [bgmClass play:@"sabaki_hmix"];
                break;
            }
            default:
                break;
        }
    }else{
        //switch=offのときはストップ
        if(bgmClass.getIsPlaying){
            [bgmClass stop];
        }
    }
}


- (void)ordinaryAnimationStart{
    
#ifdef log
    NSLog(@"ordinaryAnimationStart : enemy count = %d", [EnemyArray count]);
#endif
    
    
    //test:notouch beam
//    [self yieldBeamFromMyMachine];
    
    //    NSLog(@"orinary animation start");
    //ユーザーインターフェース
    [self.view bringSubviewToFront:iv_frame];
    [self.view bringSubviewToFront:viewScoreField];//score-display
    
    //メモリ確認
    //    NSLog(@"enemyArray length = %d", [EnemyArray count]);
    //    NSLog(@"particleArray length = %d", [KiraArray count]);
    
    
    //消去、生成、更新、表示
    
    
    //_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    //_/_/_/_/前時刻の描画を消去_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    //_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    
    /*旧形式の方法
     for(int i = 0; i < [MyMachine getBeamCount]; i++){
     [[[MyMachine getBeam:i] getImageView] removeFromSuperview];
     }
     */
    
    
    //_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    //_/_/_/_/生成_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    //_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
#ifdef log
    NSLog(@"yield enemy");
#endif
    if(gameSecond2 > 0.3f && timeIntervalEnemy <= 0){//0.3秒後で、かつ最後に生成した敵を倒してから３秒以上が経過していれば敵を開始
        [self yieldEnemy];
    }
#ifdef log
    NSLog(@"[MyMachine getIsAlive] && isTouched");
#endif
    //    NSLog(@"detection touch");
    //ビーム生成はタッチ検出場所で実行
    if([MyMachine getIsAlive] && isTouched && countFirstUserTouchEnable == 0){
        //弾丸が画面上になければ無条件に弾丸を出す
        if([MyMachine getAliveBeamCount] == 0){
            //            NSLog(@"before yield beam");
            
            [self yieldBeamFromMyMachine];
            
            //            NSLog(@"after add beam to superview");
        }else if([[MyMachine getBeam:0] getY] <
                 [MyMachine getImageView].center.y - OBJECT_SIZE/2){//最後(index:i)の弾丸がキャラクターの近くになければ(近くにあると重なってしまう)
            
            [self yieldBeamFromMyMachine];
            
        }
    }
    
#ifdef log
    NSLog(@"if(arc4random() %% 50 == 0 &&//1秒に1回");
#endif
    //爆弾投下
    if(arc4random() % 50 == 0 ){//0.5秒に1回
        if([MyMachine getStatus:ItemTypeWeapon0]){
            if([EnemyArray count] > 0){
                [self throwBombAnimation];
           }
        }
    }
    
    //_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    //_/_/_/_/進行:各オブジェクトのdoNext_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    //_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
#ifdef log
    NSLog(@"mymachine donext");
#endif
    if(//[MyMachine getIsAlive] ||
       [MyMachine getDeadTime] < explosionCycle2){
        
        [MyMachine doNext];//設定されたtype、x_loc,y_locプロパティでUIImageViewを作成する
        
        //ダメージを受けたときのイフェクト(画面を揺らす)=>縦方向に流れるアニメーション中なので難しい？
        
        //爆発から所定時間が経過しているか判定＝＞爆発パーティクルの消去
        if([MyMachine getDeadTime] >= explosionCycle2){
            //            NSLog(@"mymachine : set emitting no");
            
            isGameMode = false;
            
            //            [self exitProcess];
            //爆発を描画するために少し遅らせて実行
            [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(exitProcess) userInfo:nil repeats:NO];//低スピード再開
            [self showActivityIndicator];
            
            //startDateからこの時点までの時間をゲーム時間として定義(attr:time_maxと比較、必要に応じて格納)
            time_game = (int)[[NSDate date] timeIntervalSinceDate:startDate];//時間を計測して格納する
            return;
        }
    }
    
#ifdef log
    NSLog(@"enemy donext loop");
#endif
    
    //敵機進行or爆発後のカウント
    for(int i = 0; i < [EnemyArray count] ; i++){
        //        NSLog(@"do next at enemy:No %d", i);
        //既存敵機の距離進行！
        //dead状態になってからも、dead_timeが10未満の時までは更新doNextする(爆発パーティクル表示のため)
        if([(EnemyClass *)[EnemyArray objectAtIndex:i] getIsAlive] ||
           [(EnemyClass *)[EnemyArray objectAtIndex:i] getDeadTime] < explosionCycle2){
            
            
            //donext実行(時間と位置の更新)前に、前時刻において死んだ場合はアイテムを生成する：ビーム衝突以外に特殊効果によるsetdamageもあるため
            if([(EnemyClass *)[EnemyArray objectAtIndex:i] getIsDiedMoment]){
                
                //効果音=>別クラスに格納してstatic method化して簡潔に！
                AudioServicesPlaySystemSound (sound_hit_ID);
                
                
                [self generateItem:-1
                                 x:[[EnemyArray objectAtIndex:i] getX]
                                 y:[[EnemyArray objectAtIndex:i] getY]];
                
                
                if([self getCountAliveEnemy] == 0){//生存している敵がいないならカウンターは集う
                    timeIntervalEnemy = timeIntervalEnemyMax;//ゲーム進行とともにインターバルを現象させる
                }
                
                //得点の加算
                [ScoreBoard setScore:[ScoreBoard getScore] + 5 + [[EnemyArray objectAtIndex:i] getType]];//from 5 to 9
                [self displayScore:ScoreBoard];
                
                //カウント
                enemyDown++;
                
                //ivはdeadTimeがexplosionCycleになるまでremoveされないので、ivにエフェクトをaddする
                [[EnemyArray objectAtIndex:i] dispDieEffect];
            }
            //更新(進行位置の更新と爆発後の時間経過)：isDiedMomentはfalseに強制設定
            [(EnemyClass *)[EnemyArray objectAtIndex:i] doNext];
            
            
            //            NSLog(@"%d番目敵：y=%d", i, [(EnemyClass *)[EnemyArray objectAtIndex:i] getY]);
            
            //爆発してから時間が所定時間が経過してる場合 or 画面外に移動した場合、削除＝＞
//            if([(EnemyClass *)[EnemyArray objectAtIndex: i] getDeadTime] >= explosionCycle2 ||
//               [[EnemyArray objectAtIndex:i] getY] >= self.view.bounds.size.height + OBJECT_SIZE){
//                //爆発パーティクルの消去
//                
//                //爆発ビューが表示されたままなので、ここでは消さずに
//                //explodeした場合は既に画面から消去されているー＞？
////                [EnemyArray removeObjectAtIndex:i];
//            }
        }
    }
    
    //自機ビームの進行->mymachine donextで実行
    //旧形式
    //    for(int i = 0; i < [MyMachine getBeamCount];i++){
    //        if([[MyMachine getBeam:i] getIsAlive]){
    //            [[MyMachine getBeam:i] doNext];
    //        }else{
    //            //これをすると点滅
    ////            [[[MyMachine getBeam:i] getImageView] removeFromSuperview];
    //        }
    //    }
    
#ifdef log
    NSLog(@"item judgement start");
#endif
    
    //アイテムの進行=[アイテム自体の移動 & 生成したパーティクルの時間経過:寿命判定は別途]
    for(int i = 0 ; i< [ItemArray count]; i ++){
        if([[ItemArray objectAtIndex:i] getIsAlive]){
            [(ItemClass *)[ItemArray objectAtIndex:i] doNext];
            //            if([(ItemClass *)[ItemArray objectAtIndex:i] doNext]){//移動とパーティクル発生判定：同時実行
            //                NSLog(@"create particle");
            //動線上パーティクルの格納と表示
            //                [self.view addSubview:[[ItemArray objectAtIndex:i] getMovingParticle:0]] ;//生成したparticleは自動消滅
            //                [KiraArray insertObject:[((ItemClass*)[ItemArray objectAtIndex:i]) getMovingParticle:0] atIndex:0];
            //                [self.view addSubview:[KiraArray objectAtIndex:0]];
            //            }
            //            NSLog(@"itemC=%d, type=%d",[ItemArray count], i);//((ItemClass *)[ItemArray lastObject]).getType
            
            //確認用
            //            CALayer *_itemLayer1 = [[[ItemArray objectAtIndex:i] getImageView].layer presentationLayer];
            //            NSLog(@"i=%d, x=%f, y=%f, dist = %f",i,  _itemLayer1.position.x, _itemLayer1.position.y, [self getDistance:_itemLayer1.position.x y:_itemLayer1.position.y]);
            
            //            if(true){//常にマグネットモード
            //自機位置が変更された場合に対応するため常に監視しておく必要がある。
            //            if(isMagnetMode){// && !([[ItemArray objectAtIndex:i] getIsMagnetMode])){//ゲーム自体のmagnetModeかアイテム個体のmagnetModeか
            if([MyMachine getStatus:ItemTypeMagnet]){
                [[ItemArray objectAtIndex:i] setIsMagnetMode:YES];
                //                NSLog(@"マグネットモード");
                //                CGPoint _itemLoc = [[ItemArray objectAtIndex:i] getImageView].center;
                //                CALayer *_itemLayer = [[[ItemArray objectAtIndex:i] getImageView].layer presentationLayer];
                UIView *_itemView = (UIView *)[[ItemArray objectAtIndex:i] getImageView];
                //                NSLog(@"xItem:%f, yItem:%f,", _itemLoc.x, _itemLoc.y);
                //myMachine and item are neighbor
                
                //                if([self getDistance:_itemLoc.x y:_itemLoc.y] < diameterMagnet){
                //                if([self getDistance:_itemLayer.position.x y:_itemLayer.position.y] < diameterMagnet){
                if(ABS(((CALayer *)[_itemView.layer presentationLayer]).position.x - [MyMachine getImageView].center.x) < diameterMagnet &&
                   ABS(((CALayer *)[_itemView.layer presentationLayer]).position.y - [MyMachine getImageView].center.y) < diameterMagnet){
                    //                    CGPoint kStartPos = ((CALayer *)[[[ItemArray objectAtIndex:i] getImageView].layer presentationLayer]).position;//viewInArray.center;//((CALayer *)[iv.layer presentationLayer]).position;
                    CGPoint kStartPos = ((CALayer *)[_itemView.layer presentationLayer]).position;
                    CGPoint kEndPos = [MyMachine getImageView].center;//CGPointMake(kStartPos.x + arc4random() % 100 - 50,//iv.bounds.size.width,
                    //                                          500);//iv.superview.bounds.size.height);//480);//
                    //                    NSLog(@"start[x,y]=%f, %f, end[x,y]=%f, %f",kStartPos.x,kStartPos.y,kEndPos.x,kEndPos.y);
                    [CATransaction begin];
                    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
                    [CATransaction setCompletionBlock:^{//終了処理
                        //                        CAAnimation* animationKeyFrame = [((UIView *)[[ItemArray objectAtIndex:i] getImageView]).layer animationForKey:@"position"];
                        CAAnimation *animationKeyFrame = [_itemView.layer animationForKey:@"position"];
                        if(animationKeyFrame){
                            //途中で終わらずにアニメーションが全て完了して
                            //            [self die];
                            //NSLog(@"animation key frame already exit & die");
                            
                            //スイープモードが終わって射程圏内に入ったアイテムを削除したいが、
                            //ここでのindex:iはスイープモードになっているインデックスとはならない。
                            
                            //                            if(!sweepmode)all-item:freefall
                            if(![MyMachine getStatus:ItemTypeMagnet]){
                                if(i < [ItemArray count]){
                                    if([ItemArray[i] getIsAlive]){
                                        [ItemArray[i] freefall];
                                    }
                                }
                            }
                            
                            
                        }else{
                            //途中で何らかの理由で遮られた場合
                            //                            NSLog(@"animation key frame not exit");
                        }
                        
                    }];
                    
                    {
                        
                        // CAKeyframeAnimationオブジェクトを生成
                        CAKeyframeAnimation *animation;
                        animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
                        animation.fillMode = kCAFillModeForwards;
                        animation.removedOnCompletion = NO;
                        animation.duration = 0.15f;
                        
                        // 放物線のパスを生成
                        //    CGFloat jumpHeight = kStartPos.y * 0.2;
                        //                        CGPoint peakPos = CGPointMake((kStartPos.x + kEndPos.x)/2, (kStartPos.y * kEndPos.y)/2);//test
                        CGPoint peakPos = CGPointMake((kStartPos.x + kEndPos.x)/2, (kStartPos.y + kEndPos.y) / 2);//test
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
                        [_itemView.layer addAnimation:animation forKey:@"position"];
                        
                    }
                    [CATransaction commit];
                    //                    [CATransaction begin];
                    //                    //        [CATransaction setAnimationDuration:0.5f];
                    //                    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
                    //                    {
                    //                        [CATransaction setAnimationDuration:2.0f];//時間
                    //                        //        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                    //
                    //                        //        viewLayerTest.layer.position=CGPointMake(200, 200);
                    //                        //        viewLayerTest.layer.opacity=0.5;
                    ////
                    //                        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
                    ////                        CABasicAnimation *anim = (CABasicAnimation *)[[[ItemArray objectAtIndex:i] getImageView].layer animationForKey:@"position"];
                    //                        [anim setDuration:1.5f];
                    ////                        anim.fromValue = [NSValue valueWithCGPoint:((CALayer *)[[[ItemArray objectAtIndex:i] getImageView].layer presentationLayer]).position];//現在位置
                    //                        //            anim.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.bounds.size.width,
                    //                        //                                                                 self.view.bounds.size.height)];
                    //
                    //                        anim.toValue = [NSValue valueWithCGPoint:[MyMachine getImageView].center];
                    //
                    //
                    //                        anim.removedOnCompletion = NO;
                    //                        anim.fillMode = kCAFillModeForwards;
                    //                        [[[ItemArray objectAtIndex:i] getImageView].layer addAnimation:anim forKey:@"position"];
                    //
                    //                        //        mylayer.position=CGPointMake(200, 200);
                    //                        //        mylayer.opacity=0.5;
                    //                    } [CATransaction commit];
                    
                    
                    
                    //                    [CATransaction begin];
                    //                    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
                    //                    [CATransaction setCompletionBlock:^{//終了処理
                    ////                        CAAnimation* animationMag = [[[ItemArray objectAtIndex:i] getImageView].layer animationForKey:@"sweep"];
                    //                        if(i < [ItemArray count]){
                    ////                            CAAnimation *animSwp = [_itemLayer animationForKey:@"freeDown"];//終了判定用
                    //
                    //                            //if collide
                    //                            if(CGRectIntersectsRect(((CALayer*)[MyMachine getImageView].layer.presentationLayer).frame,
                    //                                                    ((CALayer*)[_item getImageView].layer.presentationLayer).frame)) {
                    //
                    //                                NSLog(@"collision");
                    //                                //handle the collision
                    //                            }else{//if no collide
                    //                                //down animation
                    //                                [CATransaction begin];
                    //                                [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
                    //                                [CATransaction setCompletionBlock:^{//終了判定
                    //
                    //                                }];//終了判定時処理終了
                    //
                    //
                    //                                {
                    //                                    CABasicAnimation *animSweep = [CABasicAnimation animationWithKeyPath:@"position"];
                    //                                    [animSweep setDuration:0.4f];
                    //                                    //最初はアニメーションが始まっていないので中心位置はUIView.centerで取得
                    //                                    //[ItemArray objectAtIndex:i] getImageView]
                    //
                    //                                    //                        animSweep.fromValue = [NSValue valueWithCGPoint:_itemLayer.position];
                    //                                    //                        animSweep.fromValue = [NSValue valueWithCGPoint:CGPointMake(
                    //                                    //                                               [[ItemArray objectAtIndex:i] getX], [[ItemArray objectAtIndex:i] getY]
                    //                                    //                                               )];
                    //                                    //                        animSweep.fromValue = [NSValue valueWithCGPoint:[[ItemArray objectAtIndex:i] getImageView].layer.position];
                    //                                    animSweep.toValue = [NSValue valueWithCGPoint:
                    //                                                         CGPointMake(_itemLayer.position.x,
                    //                                                                     self.view.bounds.size.height)];
                    //                                    // completion処理用に、アニメーションが終了しても登録を残しておく
                    //                                    animSweep.removedOnCompletion = NO;
                    //                                    animSweep.fillMode = kCAFillModeForwards;
                    //                                    [[[ItemArray objectAtIndex:i] getImageView].layer.presentationLayer addAnimation:animSweep forKey:@"sweep"];//uiviewから生成したlayerをanimation
                    //
                    //                                }
                    //                                [CATransaction commit];
                    //
                    //
                    //
                    //                            }
                    ////                            if([[ItemArray objectAtIndex:i] getIsAlive]){
                    ////                            ItemClass *_item = [ItemArray objectAtIndex:i];
                    ////                            CGPoint pos = [[ItemArray objectAtIndex:i] getImageView].center;
                    ////                            pos = [[_item getImageView].layer convertPoint:pos toLayer:[_item getImageView].layer.superlayer];
                    //
                    ////                            NSLog(@"sweep-completion-block at i=%d, %d, x = %d, y = %d, x=%f, y=%f, newX=%f, newY=%f, %f, %f", i,
                    ////                                  [[ItemArray objectAtIndex:i] getIsAlive],
                    ////                                  [[ItemArray objectAtIndex:i] getX],
                    ////                                  [[ItemArray objectAtIndex:i] getY],
                    ////                                  [[ItemArray objectAtIndex:i] getImageView].center.x,
                    ////                                  [[ItemArray objectAtIndex:i] getImageView].center.y,
                    ////                                  pos.x, pos.y,
                    ////                                  ((CALayer *)[[_item getImageView].layer presentationLayer]).position.x,
                    ////                                  ((CALayer *)[[_item getImageView].layer presentationLayer]).position.y);
                    //
                    //
                    ////                            [[[ItemArray objectAtIndex:i]getImageView].layer.presentationLayer removeAnimationForKey:@"sweep"];   // 後始末:元の状態に戻す？removeすると"sweep"開始位置に戻ってしまう
                    //
                    //                            //自機位置の距離判定して取得判定をしてしまう？
                    ////                            [self getDistance:0 y:0];
                    //                        }
                    //                        //        NSLog(@"item : x = %f, y = %f",
                    //                        //              ((CALayer *)[iv.layer presentationLayer]).position.x,
                    //                        //              ((CALayer *)[iv.layer presentationLayer]).position.y);
                    //                    }];//終了判定終了
                    //
                    //
                    //                    //    [CATransaction setAnimationDuration:0.5f];
                    //
                    //                    {
                    //                        CABasicAnimation *animSweep = [CABasicAnimation animationWithKeyPath:@"position"];
                    //                        [animSweep setDuration:0.4f];
                    //                        //最初はアニメーションが始まっていないので中心位置はUIView.centerで取得
                    //                        //[ItemArray objectAtIndex:i] getImageView]
                    //
                    ////                        animSweep.fromValue = [NSValue valueWithCGPoint:_itemLayer.position];
                    ////                        animSweep.fromValue = [NSValue valueWithCGPoint:CGPointMake(
                    ////                                               [[ItemArray objectAtIndex:i] getX], [[ItemArray objectAtIndex:i] getY]
                    ////                                               )];
                    ////                        animSweep.fromValue = [NSValue valueWithCGPoint:[[ItemArray objectAtIndex:i] getImageView].layer.position];
                    //                        animSweep.toValue = [NSValue valueWithCGPoint:[MyMachine getImageView].center];//myview.superview.bounds.size.height)];
                    ////                        animSweep.toValue = [NSValue valueWithCGPoint:CGPointZero];//test
                    //                        // completion処理用に、アニメーションが終了しても登録を残しておく
                    //                        animSweep.removedOnCompletion = NO;
                    //                        animSweep.fillMode = kCAFillModeForwards;
                    //                        [[[ItemArray objectAtIndex:i] getImageView].layer.presentationLayer addAnimation:animSweep forKey:@"sweep"];//uiviewから生成したlayerをanimation
                    //
                    //                    }
                    //                    [CATransaction commit];
                    //
                    
                    
                    
                    
                    
                    
                    //                    NSLog(@"magnet射程範囲->count:%d, i=%d, item:%@",
                    //                          [ItemArray count], i,
                    //                          [ItemArray objectAtIndex:i]);
                    //                    [UIView setAnimationBeginsFromCurrentState:YES];
                    //                    NSLog(@"aaa");
                    //                    [[ItemArray objectAtIndex:i] getImageView].center =
                    ////                        CGPointMake([[[ItemArray objectAtIndex:i] getImageView].layer presentationLayer].position.x,
                    ////                                    [[[ItemArray objectAtIndex:i] getImageView].layer presentationLayer].position.y);
                    //                        [[ItemArray objectAtIndex:i]getImageView].center;
                    //                    [CATransaction begin];
                    //                    [[[ItemArray objectAtIndex:i] getImageView].layer removeAllAnimations];//使えない?：変な所(画面上部)で停止する->上下にCATransaction begin&commitを実装しないから？？(未検証)
                    //                    [CATransaction commit];
                    //                    [UIView animateWithDuration:1.0f
                    //                                     animations:^{
                    //                                         [[ItemArray objectAtIndex:i] getImageView].center =
                    //                                            [MyMachine getImageView].center;
                    //                                     }
                    //                                     completion:^(BOOL finished){
                    //                                         if(i < [ItemArray count]){
                    //
                    //                                             if([[ItemArray objectAtIndex:i] getImageView] != nil){
                    //                                                 [UIView setAnimationBeginsFromCurrentState:YES];
                    //                                                 if([[ItemArray objectAtIndex:i] getIsAlive]){
                    //                                                     int x = [[ItemArray objectAtIndex:i] getImageView].center.x;
                    //                                                     [[ItemArray objectAtIndex:i] getImageView].center = CGPointMake(x, self.view.bounds.size.height);
                    //                                                 }
                    //                                             }
                    //                                         }
                    //                                     }];
                    
                    
                    
                }
            }
            
#ifdef log
            NSLog(@"itemC=%d, type=%d",[ItemArray count], i);//((ItemClass *)[ItemArray lastObject]).getType
#endif
            
            //test
            _item = [ItemArray objectAtIndex:i];
            _xItem = [_item getX];
            _yItem = [_item getY];
            //            NSLog(@"y=%d", _yItem);
            
            //            NSLog(@"xI = %d, xM = %d, yI = %d, yM = %d",
            //                  _xItem, [MyMachine getX],
            //                  _yItem, [MyMachine getY]);
            
            //アイテム検出テスト
            //            int xi = ((CALayer *)[_item getImageView].layer).position.x;//[_item getImageView].center.x;
            //            int yi = ((CALayer *)[_item getImageView].layer).position.y;//[_item getImageView].center.y;
            //            int xm = [MyMachine getImageView].center.x;
            //            int ym = [MyMachine getImageView].center.y;
            //            if(itemCount == 0){
            //                NSLog(@"xi=%d, yi=%d, xm=%d, ym=%d", xi, yi, xm, ym);
            //            }
            float near_coeff = 0.5;
            //            if(isMagnetMode){//グローバルに設定しても良い
            if([MyMachine getStatus:ItemTypeMagnet]){
                near_coeff = 0.7f;
            }else if([MyMachine getStatus:ItemTypeBig]){
                near_coeff = 2.0f;
            }
            if(
               _xItem >= [MyMachine getX] - mySize2 * near_coeff &&
               _xItem <= [MyMachine getX] + mySize2 * near_coeff &&
               _yItem >= [MyMachine getY] - mySize2 * near_coeff &&
               _yItem <= [MyMachine getY] + mySize2 * near_coeff){
                
                //                if(itemCount == 0){
                //                NSLog(@"collision detect at %d", itemCount);
                //                }
                flagItemTrigger = true;
                
                [self dispEffectItemAcq:[_item getType]];
#ifdef log
                NSLog(@"item acquire at %d", i);
#endif
                
                //                NSLog(@"Item acquired");
                //                [[[ItemArray objectAtIndex:itemCount] getImageView] removeFromSuperview];
                //                [[ItemArray objectAtIndex:itemCount] die];
                [[[ItemArray objectAtIndex:i] getImageView] removeFromSuperview];
                [[ItemArray objectAtIndex:i] die];
                [ItemArray removeObjectAtIndex:i];//追加：あったほうがいいよね？
                
                //                NSLog(@"num item = %d", [ItemArray count]);
                //アイテム取得時のパーティクル表示
                //                [self.view addSubview:[[ItemArray objectAtIndex:itemCount] getKilledParticle]];
                
                //                Effect *effect = [[Effect alloc]initWithFrame:[MyMachine getImageView].frame];
                //                UIView *viewMagnetEffect = [effect getEffectView:EffectTypeStandard];
                ////                [viewMyEffect addSubview:viewMagnetEffect];
                //                [self.view addSubview:viewMagnetEffect];
                
                //取得したアイテムを判定
                itemType = [_item getType];
                //                NSLog(@"%d", itemType);
                switch ((ItemType)itemType) {
                    case ItemTypeYellowGold:{
                        [GoldBoard setScore:[GoldBoard getScore] + 1];
                        [self displayScore:GoldBoard];
                        break;
                    }
                    case ItemTypeGreenGold:{
                        [GoldBoard setScore:[GoldBoard getScore] + 2];
                        [self displayScore:GoldBoard];
                        break;
                    }
                    case ItemTypeBlueGold:{
                        [GoldBoard setScore:[GoldBoard getScore] + 3];
                        [self displayScore:GoldBoard];
                        break;
                    }
                    case ItemTypePurpleGold:{
                        [GoldBoard setScore:[GoldBoard getScore] + 5];
                        [self displayScore:GoldBoard];
                        break;
                    }
                    case ItemTypeRedGold:{
                        [GoldBoard setScore:[GoldBoard getScore] + 10];
                        [self displayScore:GoldBoard];
                        break;
                    }
                    case ItemTypeMagnet:{//元々magnetModeでも取得可能(時間延長)
                        
                        //se:他にも適用可能
                        AudioServicesPlaySystemSound (sound_itemGet_ID);
                        
                        
                        //アイテムまでの距離を逐次計算(画面を分割して大体どの位置にいるかで処理を軽くしてもよいかも)
                        //射程範囲に入ったらアイテムを自分位置に向かわせる
                        //上記ItemClass:donext実行後にisMagnetModeで判定するが、
                        //isMagnetModeはcountMagnet>0により判定する。
                        //                        if(!isMagnetMode){
                        //                        if(![MyMachine getStatus:ItemTypeMagnet]){
                        [MyMachine setStatus:@"1" key:ItemTypeMagnet];//あまり意味ない？
                        
                        //                            NSLog(@"get isMagnetMode :true");
                        
                        //                            isMagnetMode = true;
                        //                            countMagnet = 500;//500カウント=5sec
                        //                        }
                        break;
                    }
                    case ItemTypeBig:{
                        //bigger
                        //                        if(!isBigMode){
                        if(![MyMachine getStatus:ItemTypeBig]){
                            [MyMachine setStatus:@"1" key:ItemTypeBig];
                            //                            countBig = 500;
                            //                            isBigMode = true;
                            //                            mySize2 = [MyMachine getSize];
                        }
                        break;
                    }
                    case ItemTypeBomb:{
                        //                        [MyMachine setStatus:@"1" key:ItemTypeBomb];
                        
                        if(![MyMachine getStatus:ItemTypeBomb]){
                            [MyMachine setStatus:@"1" key:ItemTypeBomb];
                            [self ItemBombEffect:self.view.center];
                        }
                        //                        for(int i = 0; i < [EnemyArray count] ;i++){//画面内全敵対象
                        //                            [self enemyDieEffect:i];
                        //                        }
                        break;
                    }
                    case ItemTypeDeffense0:{
                        /*
                         *バリアー：時間制
                         *何度当たっても解除されない代わりに、一定時間経過すれば解除される
                         */
                        if(![MyMachine getStatus:ItemTypeDeffense0]){
                            if(![MyMachine getStatus:ItemTypeBig]){//巨大化しているときにバリア不要
                                [MyMachine setStatus:@"1" key:ItemTypeDeffense0];
                            }
                        }
                        break;
                    }
                    case ItemTypeDeffense1:{
                        /*
                         *シールド：回数制
                         *永久に解除されない代わりに、一定回数当たれば解除される
                         */
                        if(![MyMachine getStatus:ItemTypeDeffense1]){
                            if(![MyMachine getStatus:ItemTypeBig]){//巨大化しているときにシールド不要
                                [MyMachine setStatus:@"1" key:ItemTypeDeffense1];
                            }
                        }
                        break;
                    }
                    case ItemTypeHeal:{
                        if(![MyMachine getStatus:ItemTypeHeal]){
                            [MyMachine setStatus:@"1" key:ItemTypeHeal];
                        }
                        break;
                    }
                    case ItemTypeCookie:{
                        //追加取得可能：MyMachine内部でnumOfAnotherが3未満なら追加するロジック
                        [MyMachine setStatus:@"1" key:ItemTypeCookie];
                        break;
                    }
                    case ItemTypeTransparency:{
                        if(![MyMachine getStatus:ItemTypeTransparency]){
                            [MyMachine setStatus:@"1" key:ItemTypeTransparency];
                        }
                        break;
                    }
                    case ItemTypeWeapon0:{//wpBomb
                        if(![MyMachine getStatus:ItemTypeWeapon0]){
                            [MyMachine setStatus:@"1" key:ItemTypeWeapon0];
                        }
                        //                        [self throwBombEffect];
                        break;
                    }
                    case ItemTypeWeapon1:{//wpDiffuse
                        //追加取得可能になるようにステータス判定なし(弾丸列数増加)
                        [MyMachine setStatus:@"1" key:ItemTypeWeapon1];
                        break;
                    }
                    case ItemTypeWeapon2:{//wpLaser
                        if(![MyMachine getStatus:ItemTypeWeapon2]){
                            
                            //se
                            AudioServicesPlaySystemSound (sound_itemGet_ID);
                            
                            
                            [self oscillateBackgroundEffect];
                            
                            [MyMachine setStatus:@"1" key:ItemTypeWeapon2];
                            
                            //                            [viewMyEffect addSubview:[MyMachine getLaserImageView]];
                            //                            [MyMachine getLaserImageView].center = CGPointMake(viewMyEffect.bounds.size.width/2,-[MyMachine getLaserImageView].bounds.size.height/2 + 40);
                        }
                        break;
                    }
                    default:
                        break;
                }
                
                /*
                 _/_/_/_/_/_/_/_/_/_/_/_/
                 得点を加算
                 武器を強化
                 シールドを強化
                 体力回復？？
                 _/_/_/_/_/_/_/_/_/_/_/_/
                 */
                
                //ゴールドを加算if item == gold
                
            }
        }
    }
#ifdef log
    NSLog(@"敵機衝突判定");
#endif
    
    //敵機の衝突判定:against自機＆ビーム
    for(int i = [EnemyArray count] - 1; i >= 0 ;i-- ) {//全ての生存している敵に対して発生した順番に衝突判定
        //        NSLog(@"敵衝突判定:%d", i);
        
        if([(EnemyClass *)[EnemyArray objectAtIndex:i] getIsAlive]){//計算時間節約
            
            if([[EnemyArray objectAtIndex:i] getY] >= self.view.bounds.size.height){
                [[EnemyArray objectAtIndex:i] die];
                continue;
            }
            //            NSLog(@"敵衝突生存確認完了");
            
            _enemy = [EnemyArray objectAtIndex:i];
            _xEnemy = [_enemy getX];
            _yEnemy = [_enemy getY];
            _sEnemy = [_enemy getSize];
            _xMine = [MyMachine getX];
            _yMine = [MyMachine getY];
            _sMine = [MyMachine getSize];
            
            //自機と敵機の衝突判定
            //            if(isBigMode){
            if([MyMachine getStatus:ItemTypeBig]){//in case of : bigMode
                if(
                   _xMine + _sMine * 0.4 >= _xEnemy - _sEnemy * 0.4 &&
                   _xMine - _sMine * 0.4 <= _xEnemy + _sEnemy * 0.4 &&
                   _yMine + _sMine * 0.4 >= _yEnemy - _sEnemy * 0.4 &&
                   _yMine - _sMine * 0.4 <= _yEnemy + _sEnemy * 0.4 ){
                    //                    NSLog(@"size=%d", _sMine);
                    //                    NSLog(@"die effect");
                    //敵機撃墜時のエフェクト
                    //                    [self enemyDieEffect:i];
                    [self giveDamageToEnemy:i damage:5 x:_xEnemy y:_yEnemy];
                    
                }
            }else if([MyMachine getStatus:ItemTypeTransparency]){
                //do nothing...
            }else if(
                     _xMine >= _xEnemy - _sEnemy * 0.4 &&
                     _xMine <= _xEnemy + _sEnemy * 0.4 &&
                     _yEnemy - _sEnemy * 0.4 <= _yMine &&
                     _yEnemy + _sEnemy * 0.4 >= _yMine)
            {
                
                //                NSLog(@"自機と敵機との衝突");
                //ダメージの設定
                [MyMachine setDamage:10 location:CGPointMake([MyMachine getX],[MyMachine getY])];
                //ヒットポイントのセット
                //                [powerGauge setValue:[MyMachine getHitPoint]];
                //パワーゲージの減少
                [self.view addSubview:[powerGauge getImageView]];
                
                
                
                //ダメージパーティクル表示
                //                [[MyMachine getDamageParticle] setUserInteractionEnabled: NO];//インタラクション拒否
                //                [[MyMachine getDamageParticle] setIsEmitting:YES];//消去するには数秒後にNOに
                //                [self.view bringSubviewToFront: [MyMachine getDamageParticle]];//最前面に
                //                [self.view addSubview: [MyMachine getDamageParticle]];//表示する
                
                
                //爆発パーティクル(ダメージ前isAliveがtrueからダメージ後falseになった場合は攻撃によって死んだものとして爆発)
                if(![MyMachine getIsAlive] &&
                   [MyMachine getDeadTime] == 1){//撃破されてから最初のタイミング
                    
                    //oscillate and slow restart
                    [self gameOverBackGround];
                    
                    
                    //se
                    AudioServicesPlaySystemSound (sound_died_ID);
                    
                    
                    [self.view addSubview:[MyMachine getExplodeEffect]];
                    
                    [[MyMachine getExplodeParticle] setUserInteractionEnabled: NO];//インタラクション拒否
                    [[MyMachine getExplodeParticle] setIsEmitting:YES];//消去するには数秒後にNOに
                    
                    [self.view addSubview: [MyMachine getExplodeParticle]];//表示する
                    [self.view bringSubviewToFront: [MyMachine getExplodeParticle]];//最前面に
                    
                    [UIView animateWithDuration:5.0f
                                     animations:^{
                                         [[MyMachine getExplodeParticle] setAlpha:0];
                                     }];
                }
            }
            
            //            NSLog(@"laser judgement");
            
            //レーザーモードの場合：レーザーと敵機の衝突判定
            if([MyMachine getStatus:ItemTypeWeapon2]){//レーザーモードの場合
                if(//自機の幅を活用する
                   _xMine + _sMine * 0.5 >= _xEnemy - _sEnemy * 0.5 &&
                   _xMine - _sMine * 0.5 <= _xEnemy + _sEnemy * 0.5 &&
                   _yMine > _yEnemy){
                    
                    
                    //攻撃によって敵が死んだらYES:生きてればNO
                    //                    if([self giveDamageToEnemy:i damagae:(int)[_beam getPower] x:_xBeam y:_yBeam]){
                    if([self giveDamageToEnemy:(int)i damage:[MyMachine getLaserPower] x:(int)_xEnemy y:(int)_yEnemy]){
                        //                        continue;//弾丸モード(非レーザーモード)とは異なり、ビームループはないのでそのまま。
                    }
                }
                
            }
            
#ifdef log
            NSLog(@"beam judgement");
#endif
            
            //敵機とビームの衝突判定
            for(int j = 0 ; j < [MyMachine getBeamCount];j++){
                //                NSLog(@"beam%d judgement against enemy%d",j, i);
                _beam = [MyMachine getBeam:j];
                
                if([_beam getIsAlive]){
                    //左上位置
                    _xBeam = [_beam getX];
                    _yBeam = [_beam getY];
                    _sBeam = [_beam getSize];
                    
                    
                    if(_xBeam + _sBeam * 0 >= _xEnemy - _sEnemy * 0.5 &&
                       _xBeam - _sBeam * 0 <= _xEnemy + _sEnemy * 0.5 &&
                       _yBeam - _sBeam * 0.5 >= _yEnemy - _sEnemy * 0.5 &&
                       _yBeam + _sBeam * 0.5 <= _yEnemy + _sEnemy * 0.5 ){
                        
                        //se
                        AudioServicesPlaySystemSound (sound_damage_ID);
                        
                        //dieと同時にremovefromSuperviewせずに集約する(画面外に出てもdieするため)
                        //dieメソッドはエフェクトを発動する特殊武器がある(発動する場合はBeamTypeを返す)
                        int _beamType = [[MyMachine getBeam:j] die];//衝突したらビームは消去＆型を取り出して(特殊武器の場合は)エフェクト表示の判別変数とする
//                        [[MyMachine getBeam:j] die];//衝突したらビームは消去
                        
                        
                        //攻撃によって敵が死んだらYES:生きてればNO
                        if([self giveDamageToEnemy:i damage:[_beam getPower] x:_xEnemy y:_yEnemy beamType:_beamType]){//_beamType:エフェクト表示
#ifdef log
                            NSLog(@"beam is hit to enemy%d which die", i);
#endif
                            break;//当該iへの衝突判定を辞め、別の敵への判定(弾丸は最初から判定)に入る
                        }else{
#ifdef log
                            NSLog(@"beam is hit to enemy%d which alive", i);
                            NSLog(@"beamType=%d", _beamType);
#endif
                            
                            
                            //beamClassによって発動されたエフェクトを判別して表示->setdamageで渡す
//                            if(_beamType != -1){
//#ifdef log
//                                NSLog(@"effect : beamtype = %d", _beamType);
//#endif
//                                [[[EnemyArray objectAtIndex:i] getImageView]
//                                 addSubview:[[MyMachine getBeam:j] getEffect]];
//                            }
                            continue;//no need?:同じ敵iに対して次の弾丸の衝突判定を行う
                        }
                        
                        
                        //                        break;//何の判定もせずににビーム[j]ループ脱出すると次以降のビームが敵に当たっている位置にいるのに衝突しないでスルーしてしまう
                        
                    }//ビーム衝突判定(位置判定)
                }//if(_beam isAlive)
            }//for(int j = 0 ; j < [MyMachine getBeamCount];j++)：ビームループ
            //            NSLog(@"complete beam loop");
        }else{//if([(EnemyClass *)[EnemyArray objectAtIndex:i] getIsAlive])
            [EnemyArray removeObjectAtIndex:i];
        }
    }//for(int i = 0; i < [EnemyArray count] ;i++ )：敵ループ
    //    NSLog(@"complete enemy-loop");
    
    
    //powergaugeを回転させる
    //    [powerGauge setAngle:2*M_PI * count * 2/60.0f];
    //
    //    //pg背景をアニメ
    //    [iv_powerGauge removeFromSuperview];
    //    int temp = count * 10  + 1;
    //
    //    //透過度を0.1, 0.2, ・・, 1.0, 0.9, 0.8, ・・循環する。
    //    iv_powerGauge.alpha = 0.1 * MAX((temp - (int)(temp/10)*10)*((((int)(temp/10)) + 1) % 2) +//二桁目が偶数の場合
    //                                    ((((int)(temp/10)+1)*10-temp) *(((int)(temp/10)) % 2)//二桁目が奇数のとき
    //                                     ), 0.1);//0.1以上にする
    ////    NSLog(@"%f", 0.1 * (temp - (int)(temp/10)*10)*((((int)(temp/10)) + 1) % 2) +//二桁目が偶数の場合
    ////          ((((int)(temp/10)+1)*10-temp) *((int)(temp/10) % 2)));//二桁目が奇数の場合
    //    [self.view addSubview:iv_powerGauge];
    //
    //    iv_pg_ribrary.transform = CGAffineTransformMakeRotation(-2*M_PI * count * 2/60.0f);
    
    
    
    //    NSLog(@"%d, %d, 偶数 = %d, 奇数 = %d, 10の位 = %d", temp, (temp - (int)(temp/10)*10)*((((int)(temp/10)) + 1) % 2) +
    //          ((((int)(temp/10)+1)*10-temp) *(((int)(temp/10)) % 2)),
    //          (temp - (int)(temp/10)*10)*((((int)(temp/10)) + 1) % 2),
    //          (((((int)(temp/10)+1)+1)*10-temp) *((int)(temp/10) % 2)),
    //          (int)(temp/10));
    
    
    if((int)gameSecond2 % 10 == 0){//per 10sec
        [self garbageCollection];
#ifdef log
        NSLog(@"complete garvageCollection");
#endif
    }
    
    
    //ユーザーインターフェース
    //    [self.view bringSubviewToFront:iv_frame];
    
#ifdef log
    if(flagIsDown1 != flagIsDown2){
        NSLog(@"flagcheck : ordinaryAnimation loop end after enemyDown");
    }
#endif
    flagIsDown2 = flagIsDown1;
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)pressedHomeButton{
    //homeボタンが押された時
    NSLog(@"pressedHomeButton");
    //以下応急処置：ユーザー表示画面(UIView)は作成必要
    [self onClickedStopButton];//isGameMode = false;も実行
    //    [self exitProcess];
}

//- (void)onLongPressedFrame:(UILongPressGestureRecognizer *)gr {
////    [self yieldBeam:0 init_x:(x_myMachine + size_machine/2) init_y:(y_myMachine - length_beam)];
//    NSLog(@"長押しがされました．");
////    isTouched = true;
//}

-(void)garbageCollection{
    NSLog(@"garvageCollection");
    for(int i = 0; i < [EnemyArray count]; i++){
        //        NSLog(@"i = %d at Y = %d", i, [[EnemyArray objectAtIndex:i]getY]);
        if([[EnemyArray objectAtIndex:i] getY] >= self.view.bounds.size.height ||
//           ![[EnemyArray objectAtIndex:i] getIsAlive]){
            [(EnemyClass *)[EnemyArray objectAtIndex:i] getDeadTime] >= explosionCycle2){
            //            NSLog(@"remove at %d, %d", i, [[EnemyArray objectAtIndex:i] getY]);
            [[[EnemyArray objectAtIndex:i] getImageView] removeFromSuperview];
            [EnemyArray removeObjectAtIndex:i];
        }
    }
    if([ItemArray count] > 30){//アニメーション中にアイテムが消えてしまう現象を回避するため(効力不明？)
        for(int i = 0; i < [ItemArray count]; i++){
            if([[ItemArray objectAtIndex:i] getY] >= self.view.bounds.size.height ||
               ![[ItemArray objectAtIndex:i] getIsAlive]){
                //            NSLog(@"item %d remove , isAlive=%d", i, [[ItemArray objectAtIndex:i] getIsAlive]);
                [[[ItemArray objectAtIndex:i] getImageView] removeFromSuperview];
                [ItemArray removeObjectAtIndex:i];
                NSLog(@"item%d is removed", i);
            }
        }
    }
}
- (void)onFlickedFrame:(UIPanGestureRecognizer*)gr {
    if(countFirstUserTouchEnable == 0){
        CGPoint point = [gr translationInView:[MyMachine getImageView]];
        if(sensitivity != 0){
            point = CGPointMake(point.x*(0.5f*sensitivity+1), point.y);
        }
        CGPoint movedPoint = CGPointMake([MyMachine getImageView].center.x + point.x,
                                         [MyMachine getImageView].center.y + point.y);
        
        //この方法では画面の渕ギリギリを動くことができない。
        //    if(movedPoint.x >= 0 && movedPoint.x <= self.view.bounds.size.width &&
        //       movedPoint.y >= 0 && movedPoint.y <= self.view.bounds.size.height){
        //
        //        [MyMachine setLocation:CGPointMake(movedPoint.x, movedPoint.y)];
        //        [MyMachine getImageView].center = movedPoint;
        //        [gr setTranslation:CGPointZero inView:[MyMachine getImageView]];
        //
        //        //エフェクト描画用frame
        //        viewMyEffect.center = movedPoint;
        //        [gr setTranslation:CGPointZero inView:viewMyEffect];
        //    }
        
        if(movedPoint.x >= 0 && movedPoint.x <= self.view.bounds.size.width){
            [MyMachine setLocation:CGPointMake(movedPoint.x,
                                               [MyMachine getImageView].center.y)];
            [MyMachine getImageView].center = CGPointMake(movedPoint.x,
                                                          [MyMachine getImageView].center.y);
            [gr setTranslation:CGPointZero inView:[MyMachine getImageView]];
            
            
            //エフェクト描画用frame
            viewMyEffect.center = [MyMachine getImageView].center;
            [gr setTranslation:CGPointZero inView:viewMyEffect];
            
        }
        
        //    if(movedPoint.y >= 0 && movedPoint.y <= self.view.bounds.size.height){
        //        [MyMachine setLocation:CGPointMake([MyMachine getImageView].center.x,
        //                                           movedPoint.y)];
        //        [MyMachine getImageView].center = CGPointMake([MyMachine getImageView].center.x,
        //                                                      movedPoint.y);
        //        [gr setTranslation:CGPointZero inView:[MyMachine getImageView]];
        //
        //
        //        //エフェクト描画用frame
        //        viewMyEffect.center = [MyMachine getImageView].center;
        //        [gr setTranslation:CGPointZero inView:viewMyEffect];
        //    }
        
        
        
        // 指が移動したとき、上下方向にビューをスライドさせる
        if (gr.state == UIGestureRecognizerStateChanged) {//移動中
            isTouched = true;
        }
        // 指が離されたとき、ビューを元に位置に戻して、ラベルの文字列を変更する
        else if (gr.state == UIGestureRecognizerStateEnded) {//指を離した時
            isTouched = false;
        }
        
        if([MyMachine getIsAlive] && isTouched){
            //弾丸が画面上になければ無条件に弾丸を出す
            if([MyMachine getAliveBeamCount] == 0){
                //            NSLog(@"before yield beam");
                
                [self yieldBeamFromMyMachine];
                
                //            NSLog(@"after add beam to superview");
            }else if([[MyMachine getBeam:0] getY] <
                     [MyMachine getImageView].center.y - OBJECT_SIZE/2){//最後(index:i)の弾丸がキャラクターの近くになければ(近くにあると重なってしまう)
                
                [self yieldBeamFromMyMachine];
                
            }
        }
        
        
        if([MyMachine getStatus:ItemTypeMagnet]){
            
            
            if(flagItemTrigger && !isEffectDisplaying){//他のエフェクトが表示中でなければ
                flagItemTrigger = false;
                isEffectDisplaying = true;
                
                int diameter = diameterMagnet;
                int duration = 3;//repeat-count
                int finishRadius = 20;
                CGFloat animationDuration = 0.5f; // Your duration
                CGFloat animationDelay = 0; // Your delay (if any)
                UIImageView *circle = [[UIImageView alloc] initWithFrame:CGRectMake(30, 30,
                                                                                    diameter,
                                                                                    diameter)];
                circle.center = CGPointMake(viewMyEffect.frame.size.width/2,
                                            viewMyEffect.frame.size.height/2);
                circle.layer.cornerRadius=diameter/2;
                
                //cyan[0,1,1] or white[1, 1, 1]?
                UIColor *itemColor =[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1f];
                circle.layer.borderColor=[[itemColor colorWithAlphaComponent:0.5f] CGColor] ;
                circle.layer.borderWidth = 4.0f;//4px
                circle.layer.backgroundColor = [itemColor CGColor];
                
                
                CABasicAnimation *cornerRadiusAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
                [cornerRadiusAnimation setFromValue:[NSNumber numberWithFloat:diameter/2]]; // The current value
                [cornerRadiusAnimation setToValue:[NSNumber numberWithFloat:10.0]]; // The new value
                [cornerRadiusAnimation setDuration:animationDuration];
                [cornerRadiusAnimation setBeginTime:CACurrentMediaTime() + animationDelay];
                [cornerRadiusAnimation setRepeatCount:duration];
                
                // If your UIView animation uses a timing funcition then your basic animation needs the same one
                [cornerRadiusAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                
                // This will keep make the animation look as the "from" and "to" values before and after the animation
                [cornerRadiusAnimation setFillMode:kCAFillModeBoth];
                [circle.layer addAnimation:cornerRadiusAnimation forKey:@"keepAsCircle"];
                //        [circle.layer setCornerRadius:10.0]; // Core Animation doesn't change the real value so we have to.
                
                [UIView animateWithDuration:animationDuration
                                      delay:animationDelay
                                    options:UIViewAnimationOptionCurveEaseInOut
                 //                                |UIViewAnimationOptionRepeat
                                 animations:^{
                                     [UIView setAnimationRepeatCount: duration];
                                     [circle.layer setFrame:CGRectMake(viewMyEffect.frame.size.width/2-finishRadius/2,
                                                                       viewMyEffect.frame.size.height/2-finishRadius/2,
                                                                       finishRadius,
                                                                       finishRadius)]; // Arbitrary frame ...
                                     [circle.layer setBackgroundColor:[[UIColor colorWithRed:0
                                                                                       green:1
                                                                                        blue:1
                                                                                       alpha:0.5f] CGColor]];
                                     circle.center = CGPointMake(viewMyEffect.frame.size.width/2,
                                                                 viewMyEffect.frame.size.height/2);//viewEffect.center;//
                                     // You other UIView animations in here...
                                 } completion:^(BOOL finished) {
                                     // Maybe you have your completion in here...
                                     [circle removeFromSuperview];
                                     isEffectDisplaying = false;
                                     //                         [viewMyEffect removeFromSuperview];
                                 }];
                
                [viewMyEffect addSubview:circle];
            }//if(flagItemTrigger && !isEffectDisplaying){//他のエフェクトが表示中でなければ
            
        }//if(isMagnetMode)
        
    }
}//onFlickedFrame

-(void) viewWillDisappear:(BOOL)animated {
    //navigationバーの戻るボタン押下時の呼び出しメソッド
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        //        NSLog(@"pressed back button");
        
    }
    [timer invalidate];
    [super viewWillDisappear:animated];
}


/**敵発生
 *count(0.1sec)に応じて発生頻度を大きくする
 * 0- 5sec:2secに一回
 * 6-10sec:1secに一回
 *11-15sec:0.5secに一回
 *16-20sec:0.25secに一回
 *21-25sec:0.125secに一回=ほぼ毎回
 */
-(void)yieldEnemy{
    
    if([EnemyArray count] > MAX_ENEMY_NUM - 10){
        
        return;
    }
    Boolean isYield = false;
    
#ifndef ENEMY_TEST//本番
    /*
     *ゲーム進行と共にdifficultyを上げていく
     */
    int stageInterval = 5;//本番10sec?
    int difficulty = gameSecond2/stageInterval;//stageInterval秒経過するごとにdifficulty++//easy:0, 1, ... difficult
    
    
    
    //最初の30秒？(総ゲーム時間の5分の4)は一定間隔：例えば10秒目から１５秒目は表示しない等の小休憩が必要
    //ゲーム時間：初級＝１分、中級＝３分、上級6分(最高記録：10分)
    //5秒間隔で非表示
    if([EnemyArray count] == 0){//画面上に敵がいなければ敵を発生(通常生成)
        isYield = true;
        //    }else if(gameSecond2 < 20){//20秒未満なら
        //        if(arc4random() % 300 == 0){//平均2秒に1回=100px程度の間隔(通常生成とは別にゲーム進行と共に高頻度で敵を発生)
        //            isYield = true;
        //        }
        //    }else if(gameSecond2 < 22){//5秒間隔で非表示
        //        //nothing : isYield = false;
        //    }else if(gameSecond2 < 40){//40秒未満
        //        if(arc4random() % 300 == 0){//平均１秒に1回
        //            isYield = true;
        //        }
        //    }else if(gameSecond2 < 42){//5秒間隔で非表示
        //        //nothing : isYield = false;
        //    }else if(gameSecond2 < 60){
        //        if(arc4random() % 100 == 0){//平均0.5秒に1回出現
        //            isYield = true;
        //        }
        //    }else if(gameSecond2 < 61){
        //        //nothing : isYield = false;
        //    }else if(gameSecond2 < 80){//初級殺し
        //        if(arc4random() % 30 == 0){//平均0.3秒に1回出現
        //            isYield = true;
        //        }
        //    }else if(gameSecond2 < 81){
        //        //nothing : is...
        //    }else if(gameSecond2 < 100){
        //        if(arc4random() % 30 == 0){
        //            isYield = true;
        //        }
        //    }else if(gameSecond2 < 140){
        //        if(arc4random() % 30 == 0){
        //            isYield = true;
        //        }
        //    }else if(gameSecond2 < 200){
        //        if(arc4random() % 30 == 0){
        //            isYield = true;
        //        }
        //    }else{
        //        if(arc4random() % 30 == 0){
        //            isYield = true;
        //        }
    }
#else
    
    if(countEnemyRowYield2 == 0){
        countEnemyRowYield2 = timeEnemyRowYield2;//100count(1count=0.01sec)で一列生成する
        isYield = true;
    }else{
        countEnemyRowYield2 --;
    }
    
#endif
    if(isYield){
        //        NSLog(@"gameSec = %f, difficulty = %d",gameSecond2, difficulty);
        
        
        int occurredX = 0;
        EnemyType _enemyType = EnemyTypeTanu;
        
        
        
        //tanu,musa,pen,hari,zou
        NSArray *arrEmergentProbability=
        [NSArray arrayWithObjects:
         //early stage
         [NSArray arrayWithObjects:@10, @0, @0, @0, @0 ,nil],
         [NSArray arrayWithObjects:@9, @1, @0, @0, @0 ,nil],
         [NSArray arrayWithObjects:@8, @2, @0, @0, @0 ,nil],
         [NSArray arrayWithObjects:@7, @3, @0, @0, @0 ,nil],
         [NSArray arrayWithObjects:@7, @2, @1, @0, @0 ,nil],
         [NSArray arrayWithObjects:@7, @1, @1, @1, @0 ,nil],
         [NSArray arrayWithObjects:@6, @2, @1, @1, @0 ,nil],
         [NSArray arrayWithObjects:@6, @1, @1, @1, @1 ,nil],
         
         //...below is sense..
         [NSArray arrayWithObjects:@5, @1, @1, @2, @1 ,nil],
         [NSArray arrayWithObjects:@3, @2, @2, @2, @1 ,nil],
         [NSArray arrayWithObjects:@1, @3, @3, @2, @1 ,nil],
         [NSArray arrayWithObjects:@0, @5, @2, @2, @1 ,nil],
         
         //middle stage
         [NSArray arrayWithObjects:@0, @2, @5, @2, @1 ,nil],
         [NSArray arrayWithObjects:@0, @0, @5, @4, @1 ,nil],
         [NSArray arrayWithObjects:@0, @0, @3, @6, @1 ,nil],
         [NSArray arrayWithObjects:@0, @0, @1, @8, @1 ,nil],
         
         
         //final stage
         [NSArray arrayWithObjects:@0, @0, @0, @8, @2 ,nil],
         [NSArray arrayWithObjects:@0, @0, @0, @6, @4 ,nil],
         [NSArray arrayWithObjects:@0, @0, @0, @3, @7 ,nil],
         [NSArray arrayWithObjects:@0, @0, @0, @1, @9 ,nil],
         
         nil];
        
        float prob = 0;//分子
        int bunbo = 10;//分母
        for(int eneCnt = 0; eneCnt < 5 ;eneCnt++){//display 5 enemy
            
            enemyCount ++;
            //        NSLog(@"enemyCount %d", enemyCount);
            //            int x = arc4random() % ((int)self.view.bounds.size.width - OBJECT_SIZE);
            //            occurredX = (OBJECT_SIZE-50)/2 + eneCnt * (OBJECT_SIZE-50);
            occurredX = OBJECT_SIZE/2 + eneCnt * (OBJECT_SIZE - 7);
            
            
            difficulty = MIN(difficulty, [arrEmergentProbability count]-1);
            prob = 0;
            bunbo = 10;
            for(EnemyType i = 0 ; i < 5; i++){
                for(EnemyType j = 0;j<i;j++){
                    bunbo -= prob;//残りの確率の分母を計算する
                }
                if(bunbo < 0)break;
                prob = [[[arrEmergentProbability objectAtIndex:difficulty] objectAtIndex:i] floatValue];
                
                if(arc4random() % bunbo < prob){
                    _enemyType = (EnemyType)i;
                    break;
                }
            }
            
            
            
            //enemy initialize
            //enemy is defined as move ealier for gameSecond2/5.0 which gameSecond2 is increasing 0.01f;
            EnemyClass *enemy = [[EnemyClass alloc]init:occurredX
                                                   size:OBJECT_SIZE
                                                   time:[self getSigmoid:(float)gameSecond2]
//                                                   time:MAX(5.0f-(float)gameSecond2/5.0f, 0.5f)
                                              enemyType:_enemyType
                                 ];
            //test用
            //            [[enemy getImageView] setBackgroundColor:[UIColor colorWithRed:((float)(occurredX%255))/255.0f
            //                                                                     green:0
            //                                                                      blue:0
            //                                                                     alpha:0.5f]];//test:enemy
            [EnemyArray insertObject:enemy atIndex:0];
            [self.view addSubview:[[EnemyArray objectAtIndex:0] getImageView]];
            [self.view bringSubviewToFront:[[EnemyArray objectAtIndex:0] getImageView]];
            
            
            
            if([EnemyArray count] > MAX_ENEMY_NUM) {
                //                for(int i = 0; i < 10;i++){//
                [[[EnemyArray lastObject] getImageView] removeFromSuperview];
                //(パーティクルを生成していたら)パーティクルを消去
//                [[[EnemyArray lastObject] getDamageParticle] removeFromSuperview];
                [[[EnemyArray lastObject] getExplodeParticle] removeFromSuperview];
                //配列から削除してメモリを解放
                [EnemyArray removeLastObject];
                //                }
                
            }
        }
    }
}

-(void)initEnemyBreak{
    NSLog(@"initEnemyBreak start");
    //最初にエネミーを生成してすぐに殺す
    EnemyClass *_enemy = [[EnemyClass alloc]init:[UIScreen mainScreen].bounds.size.width/2
                                            size:OBJECT_SIZE
                                            time:[self getSigmoid:(float)gameSecond2]
                                       enemyType:EnemyTypeTanu
                         ];
    [EnemyArray insertObject:_enemy atIndex:0];
    [self.view addSubview:[[EnemyArray objectAtIndex:0] getImageView]];
    [self.view bringSubviewToFront:[[EnemyArray objectAtIndex:0] getImageView]];
    [_enemy setDamage:[_enemy getHitPoint]-1 location:[_enemy getLocation]];
    
    //removeFromSuperviewは不要？
    NSLog(@"initEnemyBreak complete");
    
//    [(EnemyClass *)[EnemyArray objectAtIndex:0] setDamage:[_enemy getHitPoint]+1 location:[_enemy getLocation]];
//    [[[EnemyArray objectAtIndex:0] getImageView] removeFromSuperview];
    [self yieldBeamFromMyMachine];
    [MyMachine doNext];
    
}

-(void)exitProcess{//自機が撃破されたら自動的に呼び出し
    //    [self showActivityIndicator];//ボタン押下可能になってしまう
    //タイマー終了(死んだ時に周囲の敵やイフェクトが動いているようにするかどうか)
    [timer invalidate];
    timer = nil;
    
    
    
    
    UIView *superView = [CreateComponentClass createViewNoFrame:self.view.bounds
                                                          color:[UIColor clearColor]
                                                            tag:0
                                                         target:nil
                                                       selector:nil];
    [self.view addSubview:superView];
    
    
    //処理能力が低下するので自機以外のparticleを全て消去
    //敵の爆発パーティクルは全て消去
    for(int i = 0; i < [EnemyArray count] ;i++){
        if([[EnemyArray objectAtIndex:i] getIsAlive]){
            //ゲーム終了後に生存している敵の処理：消去？=>メモリ解放に役立たないのでやらない。
            //            [[[EnemyArray objectAtIndex:i] getImageView]removeFromSuperview];
            
        }else{//死亡した敵の処理：爆発パーティクルは消去：メモリ消去
            [[[EnemyArray objectAtIndex:i] getExplodeParticle] removeFromSuperview];
//            [[[EnemyArray objectAtIndex:i] getDamageParticle] removeFromSuperview];
            
            //画面からは消去しなくても良いが、配列から削除してメモリ解放
            [[[EnemyArray objectAtIndex:i] getImageView] removeFromSuperview];
            [EnemyArray removeObjectAtIndex:i];
        }
    }
    
    //念のため全てのリソースを解放
    [self garbageCollection];
    
    //ItemClassのパーティクルは最後に生成された物(index:0)以外すべて消去
    //    for(int i = 1; i < [KiraArray count];i++){
    //        [[KiraArray objectAtIndex:i] removeFromSuperview];
    //    }
    
    //ゲーム終了時に呼び出されるメソッド
    //終了報告イメージ？ダイアログ？表示
    //データ：attrclassで処理
    
    //ゲームオーバー表示
    //ScoreBoard
    //GoldBoard
    //敵機撃破率
    
    
    
    
    //描画用に使うため、更新前データを保存しておく
    //    AttrClass *attr = [[AttrClass alloc]init];
    int beforeLevel = [[attr getValueFromDevice:@"level"] intValue];
    int beforeExp = [[attr getValueFromDevice:@"exp"] intValue];
    int go_component_width = 250;
    
    int _score = [ScoreBoard getScore];
    int _gold = [GoldBoard getScore];
    int _bonus = 100;//飛行時間(time_game：既に格納済)に応じたボーナス：time_gameを引数とするシグモイド関数を定義
    
    //全体のフレーム
    UIView *view_go = [CreateComponentClass createView];
    view_go.frame =
    CGRectMake(viewScoreField.frame.origin.x+5,
               viewScoreField.frame.origin.y+viewScoreField.bounds.size.height+3,
               [UIScreen mainScreen].bounds.size.width-viewScoreField.frame.origin.x-10,
               [UIScreen mainScreen].bounds.size.height-viewScoreField.frame.origin.y-viewScoreField.bounds.size.height-10);
    
    [self.view addSubview:view_go];
    [self.view bringSubviewToFront:view_go];
    
    //gameover_display:go_y=10
    //tv_score
    //pv_score
    //tv_gold
    //pv_gold
    //tv_complete
    //pv_complete
    
    //ゲームオーバー(go)表示
    //    int go_width = 250;
    int go_height = 50;
    int go_y = 10;//view_go上での相対位置
    //    CGRect rect_gameover = CGRectMake(view_go.bounds.size.width/2 - go_component_width/2,
    //                                      go_y,
    //                                      go_component_width,
    //                                      go_height);
    //    [view_go addSubview:[CreateComponentClass createImageView:rect_gameover
    //                                                        image:@"gameover.png"]];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"game over!";
    label.backgroundColor = [UIColor clearColor];
    //    label.font = [UIFont fontWithName:@"Chalkduster" size:40];
    label.font = [UIFont fontWithName:@"Noteworthy-Light" size:40];
    [label sizeToFit];
    //最後にview_goに貼付けているのでview_go上での位置
    label.center = CGPointMake([self.view convertPoint:view_go.center toView:view_go].x,
                               label.frame.size.height/2 + 5);//5はマージン
    label.textColor = [UIColor whiteColor];
    [view_go addSubview:label];
    
    
    
    int label_h = 30;//表示するテキストの縦(高さ)
    //今回獲得したスコア:static
    UILabel *lbl_nowScore =
    [[UILabel alloc]initWithFrame:CGRectMake(view_go.bounds.size.width/2 - go_component_width/2,
                                             go_y + go_height + 15,
                                             go_component_width,
                                             label_h)];
    lbl_nowScore.text = [NSString stringWithFormat:
                         @"今回獲得したスコア：%d",
                         _score];
    //左端を合わせる
//    [lbl_nowScore sizeToFit];
//    lbl_nowScore.center =
//    CGPointMake(view_go.bounds.size.width/2,
//                go_y + go_height + 5 + lbl_nowScore.bounds.size.height/2+5);
    lbl_nowScore.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:14];
    lbl_nowScore.textColor = [UIColor whiteColor];
    [view_go addSubview:lbl_nowScore];
    
    //ボーナス
    UILabel *lbl_bonus =
    [[UILabel alloc]initWithFrame:CGRectMake(view_go.bounds.size.width/2 - go_component_width/2,
                                             lbl_nowScore.frame.origin.y + lbl_nowScore.bounds.size.height + 5,
                                             go_component_width,
                                             label_h)];
    lbl_bonus.text = [NSString stringWithFormat:
                         @"飛行時間によるボーナススコア：%d",
                         _bonus];
    //左端を合わせる
//    [lbl_bonus sizeToFit];
//    lbl_bonus.center =
//    CGPointMake(view_go.bounds.size.width/2,
//                go_y + go_height + 5 +
//                lbl_nowScore.bounds.size.height +
//                lbl_bonus.bounds.size.height/2+5);
    lbl_bonus.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:14];
    lbl_bonus.textColor = [UIColor whiteColor];
    [view_go addSubview:lbl_bonus];
    
    
    
    
    
    
    //ScoreBoard
    //スコアの上端位置
    int score_y = lbl_bonus.frame.origin.y + lbl_bonus.bounds.size.height + 5;
    int pv_h = 25;
    CGRect rect_score = CGRectMake(view_go.bounds.size.width/2 - go_component_width/2,
                                   score_y,
                                   go_component_width,
                                   label_h);
    //    [view_go addSubview:[CreateComponentClass createImageView:rect_score image:@"close"]];
    UITextView *tv_score = nil;
    
    if(beforeLevel < [attr getMaxLevel]){
        tv_score = [CreateComponentClass
                    createTextView:rect_score
                    text:[NSString stringWithFormat:@"score : %d", beforeExp]];
    }else{
        tv_score = [CreateComponentClass
                    createTextView:rect_score
                    text:[NSString stringWithFormat:@"score : MAX"]];
    }
    [tv_score setBackgroundColor:[UIColor clearColor]];
    [view_go addSubview:tv_score];
    
    //    UIProgressView *pv_score = [[UIProgressView alloc]
    //                                initWithProgressViewStyle:UIProgressViewStyleBar];
    //    pv_score.frame = CGRectMake(view_go.bounds.size.width/2 - go_component_width/2,
    //                                score_y + go_height,
    //                                go_component_width,
    //                                10);
    //    pv_score.progressTintColor = [UIColor greenColor];
    
    LDProgressView *pv_score = [[LDProgressView alloc]
                                initWithFrame:CGRectMake(view_go.bounds.size.width/2 - go_component_width/2,
                                                         score_y + label_h,
                                                         go_component_width,
                                                         pv_h)];//default is blue color
    pv_score.color = [UIColor colorWithRed:0.73f green:0.10f blue:0.00f alpha:1.00f];
    pv_score.progress = 0.40;
    pv_score.animate = @YES;
    pv_score.type = LDProgressGradient;
    pv_score.background = [pv_score.color colorWithAlphaComponent:0.8];
    
    
    //    // default color, animated
    //    LDProgressView *progressView = [[LDProgressView alloc] initWithFrame:CGRectMake(20, 130, self.view.frame.size.width-40, 22)];
    //    progressView.progress = 0.40;
    //    [self.progressViews addObject:progressView];
    //    [self.view addSubview:progressView];
    //
    //
    //    // flat, green, animated
    //    progressView = [[LDProgressView alloc] initWithFrame:CGRectMake(20, 160, self.view.frame.size.width-40, 22)];
    //    progressView.color = [UIColor colorWithRed:0.00f green:0.64f blue:0.00f alpha:1.00f];
    //    progressView.flat = @YES;
    //    progressView.progress = 0.40;
    //    progressView.animate = @YES;
    //    [self.progressViews addObject:progressView];
    //    [self.view addSubview:progressView];
    
    
    
    
    [view_go addSubview:pv_score];
    
    //GoldBoard
    int gold_y = score_y + go_height + 5;
    CGRect rect_gold = CGRectMake(view_go.bounds.size.width/2 - go_component_width/2,
                                  gold_y,
                                  go_component_width,
                                  label_h);
    //    [view_go addSubview:[CreateComponentClass createImageView:rect_gold image:@"close"]];
    UITextView *tv_gold = [CreateComponentClass createTextView:rect_gold text:@"Zeny : 0"];
    [tv_gold setBackgroundColor:[UIColor clearColor]];
    [view_go addSubview:tv_gold];
    
    //goldのprogressviewは不要
    //    UIProgressView *pv_gold = [[UIProgressView alloc]
    //                           initWithProgressViewStyle:UIProgressViewStyleBar];
    //    pv_gold.progressTintColor = [UIColor redColor];
    //    pv_gold.frame = CGRectMake(view_go.bounds.size.width/2 - go_component_width/2,
    //                          gold_y + go_height,
    //                          go_component_width,
    //                          10);
    //    [view_go addSubview:pv_gold];
    
    
    //撃破率
    int complete_y = gold_y + go_height + 5;
    CGRect rect_complete = CGRectMake(view_go.bounds.size.width/2 - go_component_width/2,
                                      complete_y,
                                      go_component_width,
                                      label_h);
    //    [view_go addSubview:[CreateComponentClass createImageView:rect_complete image:@"close"]];
    UITextView *tv_complete = [CreateComponentClass createTextView:rect_complete text:@"complete : "];
    [tv_complete setBackgroundColor:[UIColor clearColor]];
    [view_go addSubview:tv_complete];
    //    UIProgressView *pv_complete = [[UIProgressView alloc]
    //                                   initWithProgressViewStyle:UIProgressViewStyleBar];
    //    pv_complete.progressTintColor = [UIColor blueColor];
    //    pv_complete.frame = CGRectMake(view_go.bounds.size.width/2 - go_component_width/2,
    //                                   complete_y + go_height,
    //                                   go_component_width,
    //                                   10);
    LDProgressView *pv_complete =
    [[LDProgressView alloc]
     initWithFrame:
     CGRectMake(view_go.bounds.size.width/2 - go_component_width/2,
                complete_y + label_h,
                go_component_width,
                pv_h)];//default is blue color
    
    pv_complete.color = [UIColor colorWithRed:0.00f green:0.64f blue:0.00f alpha:1.00f];//green
    pv_complete.progress = 0.40;
    pv_complete.animate = @YES;

    
    
    [view_go addSubview:pv_complete];
    
    //ダイアログで成績を表示(未)してからゲーム画面閉じる
    //    CreateComponentClass *createComponentClass = [[CreateComponentClass alloc]init];
    
    
    //ボタン配置=>下から算出:ボタンではなく、終了したらこのフレームを押せば終了するようにする
//    CGRect rect_btn = CGRectMake(view_go.bounds.size.width/2 - go_component_width/2,
//                                 view_go.bounds.size.height - go_height - 10,
//                                 go_component_width,
//                                 go_height);
//    UIButton *qbBtn = [CreateComponentClass createQBButton:ButtonMenuBackTypeDefault
//                                                      rect:rect_btn
//                                                     image:@"blue_item_yuri_big2.png"
//                                                     title:@"exit"
//                                                    target:self
//                                                  selector:@"pushExit"];
//    [view_go addSubview:qbBtn];
    
//    UIView *viewForExit =
//    [[ViewExplode alloc]initWithFrame:

    
    //終了ボタンはhideIndicator
    
    //マルチスレッド用の描画コンポーネント初期化完了
    
    //デバイスデータ更新＆サーバー通信＝＞時間遅れ付performSelectorを実行するとsuperView(上のコンポーネントを含めて)描画しながらsendRequest...を実行してくれる
    //exitボタン押下時に実行してしまうと、menu画面で正しい値が表示されなくなってしまう
    
    
    
    
    
    //マルチスレッド
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    //score:expに既に獲得したスコアを表示(pvはmaxは次のレベルに必要な値)
    //gold: pvは過去の最高値を横軸最大値とした軸
    //complete:100%を横軸最大値
    //三つとも最大値に達したら初期化してゼロからスタート
    //加えるべき値を別途定義してそれぞれ(pv_score等)に加えていく
    //上限まで達したら再度ゼロにして足していくが、次のレベルにおいても上限に達する場合はそこで停止しておく
    //レベルマックスに達したら経験値上昇動作は実行しない
    dispatch_async(globalQueue, ^{
        NSLog(@"multi-thread start");
        //ここでは情報を取得しておくに留める(更新はdispatch_asyncで実施)
        //        AttrClass *attr = [[AttrClass alloc]init];
        int level = beforeLevel;//[[attr getValueFromDevice:@"level"] intValue];//既に更新済なので古いデータを使う
        int exp = beforeExp;//[[attr getValueFromDevice:@"exp"] intValue];//既に更新済なので古いデータを使う
        int expTilNextLevel = 0;
        if(beforeLevel < [attr getMaxLevel]){
            expTilNextLevel = [attr getMaxExpAtTheLevel:beforeLevel];//非更新データなのでアクセス
        }
        
        //        float unit = (float)expTilNextLevel / 100.0f;//progressViewの100分割ユニット＝最初のレベルで固定
        float unit = (float)_score/100.0f;//experience devided per 100count
        
        //unitは取得スコア[ScoreBoard getScore]の100分割の方がすっきりする(最初のレベルにおけるレベルアップのための必要経験値の100分割にしてしまうと次のレベルに上がった時に１カウント当たりの上昇速度が低下してしまい時間がかかる)
        int loopCount = 100;//(float)(exp + [ScoreBoard getScore])/unit;
        //        int loopCount = (float)(exp + 1000)/unit;//テスト用
        //        int cntInit = 0;//(float)exp / unit;//最初のcntInitの表示はanimateしないようにしたい(現状x)
        float pvScoreValue = (float)exp;
        //        int goldCnt = 0;
        
        Boolean flagLevelUp = false;
        int goldCnt = 0;
        int goldAdd = 0;
        if(_gold != 0){
            goldAdd = (_gold/100==0)?1:((float)_gold/100.0f);//大体100カウントで終わらせる
        }
        //exp初期値
        //        [pv_score setProgress:(float)pvScoreValue/100.0f//<-why?????
        //                     animated:NO];
        if(level < [attr getMaxLevel]){
            //            [pv_score setProgress:(float)pvScoreValue/expTilNextLevel
            //                     animated:NO];
            pv_score.progress = pvScoreValue/expTilNextLevel;
        }else{
            //            [pv_score setProgress:1.0f animated:NO];
            pv_score.progress = 1.0f;
        }
        
        for(int cnt = 0;cnt < loopCount ||//必ず100回繰り返す
            goldCnt < _gold||//獲得金額を100分割にして100回ループ
            cnt < (float)enemyDown/(float)enemyCount*100//倒した敵の数
            ;cnt++){
            
            goldCnt += goldAdd;
            goldCnt = MIN(goldCnt, _gold);
            //時間のかかる処理
            //            NSLog(@"cnt = %d", cnt);
            for(int i = 0; i < 10;i++){
                //                NSLog(@"i = %d to expend time", i);//時間経過
                NSLog(@"cnt = %d, i = %d, before-exp:%d, acquired:%d, after:%d, gold:%d, unit:%f, expUntileNextLevel:%d, level:%d, complete:%f, down:%d, count:%d",
                      cnt, i, exp, _score, exp + _score, _gold, unit, expTilNextLevel, level, (float)enemyDown/enemyCount, enemyDown, enemyCount);
            }
            if(cnt < loopCount){
                if(pvScoreValue + unit < expTilNextLevel){
                    pvScoreValue += unit;//小数点以下の誤差は発生するが
                }else{
                    //                    pvScoreValue = expTilNextLevel;
                    //次のレベルに進行
                    level++;
                    if(level < [attr getMaxLevel]){
                        flagLevelUp = true;
                        expTilNextLevel = [attr getMaxExpAtTheLevel:level];
                        //                    pvScoreValue = unit-pvScoreValue;//?
                        pvScoreValue = 0;//(float)[ScoreBoard getScore] - pvScoreValue;//残り：今回取得したスコアから今まで足し上げた値を控除
                        if(pvScoreValue > expTilNextLevel){//次のレベルのMAXよりも残り経験値が大きい場合
                            //経験値を沢山取得しても何度もレベル上昇するのは止めて次のレベルで止めておく
                            pvScoreValue = expTilNextLevel-1;
                        }
                    }else{//levelが89から90に達したら
                        //要対応...
                        //レベルと累積のスコアを表示するラベルはMAXに、今回取得したスコア(未実装？)は数字を表示する
                    }
                }
            }
            
            //上記で設定した値をアニメーションのように表示する
            dispatch_async(mainQueue, ^{
                //経験値
                if(level < [attr getMaxLevel]){
                    if(cnt < loopCount-1){//通常ループ
                        tv_score.text = [NSString stringWithFormat:@"EXP : %d     level : %d",
                                         (int)ABS(pvScoreValue) , level];
                        if(!flagLevelUp){
                            //                            [pv_score setProgress:(float)pvScoreValue/expTilNextLevel//levelが上がったら一旦初期化
                            //                                         animated:NO];
                            pv_score.progress = (float)pvScoreValue/expTilNextLevel;
                        }else{
                            
                            //[before]level上がったらcongratビュー表示により見えなくなるのでゼロにしたまま＝＞最終状態でsetProgressしているので進捗しない
                            //                            [pv_score setProgress:0//levelが上がったらゼロにしたままにする(congratビュー表示で見えなくなる)
                            //                                         animated:YES];
                            //[after]level-up always 100%
                            
                            pv_score.progress = 1.0f;
                        }
                        
                        
                        
                    }else{////最後のループのみ別処理(誤差：unitが無理数の場合、割り切れないので正確な値を示すために最終値をそのまま表示)
                        //最終状態：初期値＋今回獲得スコア
                        tv_score.text = [NSString stringWithFormat:@"EXP : %d     level : %d",
                                         (int)ABS(pvScoreValue), level];
                        //                        [pv_score setProgress:(float)pvScoreValue/expTilNextLevel
                        //                                     animated:YES];
                        pv_score.progress = (float)pvScoreValue/expTilNextLevel;
                    }
                }else{
                    //レベルマックスになっている場合
                    tv_score.text = [NSString stringWithFormat:@"EXP : MAX     level : MAX"];
                    //                    [pv_score setProgress:1.0f animated:NO];
                    pv_score.progress = 1.0f;
                }
                
                //gold
                if(_gold > 0 &&
                   goldCnt < _gold-1){//少なくとも一枚以上獲得した場合の通常ループ
                    //                    goldCnt = (goldCnt + goldAdd > [GoldBoard getScore])?[GoldBoard getScore]:(goldCnt + goldAdd);
                    tv_gold.text = [NSString stringWithFormat:@"Zeny : %d", goldCnt];
                }else{//最終状態
                    tv_gold.text = [NSString stringWithFormat:@"Zeny : %d", _gold];
                }
                
                //complete
                if(cnt < (float)enemyDown/(float)enemyCount*100){
                    if(enemyDown != enemyCount){
                        //no-update for string(progress is updating...)
                        //                        tv_complete.text = [NSString stringWithFormat:@"complete : %d%%", MIN(cnt, 100)];
                        pv_complete.progress = (float)cnt / 100.0f;
                    }
                }else{//最終状態：
                    if(enemyDown == enemyCount){
                        //                        tv_complete.text = [NSString stringWithFormat:@"complete : %d%%", 100];
                        pv_complete.progress = 1.0f;
                    }
                }
                
                
                //最後の方で完了したらサーバーにデータ登録
                if(cnt == loopCount-1){//cntは少なくと99は必ずカウントする(割り切れなかった場合のため)：ちなみに他の条件もあるのでcntは100を超える場合もある
                    //                    //最終状態
                    //                    tv_gold.text = [NSString stringWithFormat:@"Zeny : %d", [GoldBoard getScore]];
                    //                    tv_score.text = [NSString stringWithFormat:@"EXP : %d     level : %d",
                    //                                     [ScoreBoard getScore] , level];
                    //
                    //                    if(enemyDown == enemyCount){
                    //                        tv_complete.text = [NSString stringWithFormat:@"complete : %d%%", 100];
                    //                        pv_complete.progress = 1.0f;
                    //                    }
                    
                    NSLog(@"finished thread");
                    //                    [self showActivityIndicator];//activityIndicatorが表示されている間は画面タッチできないようにnoActionframeを張り付け
                    //                    if(flagLevelUp){//test:levelUpEffect
                    if(flagLevelUp){
                        NSLog(@"flagLevelUp = %d", flagLevelUp);
                        UIView *vwel = [[ViewWithEffectLevelUp alloc]
                                        initWithFrame:self.view.bounds
                                        beforeLevel:beforeLevel
                                        afterLevel:beforeLevel+1
                                        ];
                        [self.view addSubview:vwel];
                        
                        //上記ビューにボタンを配置して以下のメソッドを実行して自慢する
                        //                        [ASInviter showInviteSheetInView:self.view];//test:report
                        //このメソッドは<ASFriendPickerViewControllerDelegate>を追加し、
                        //- (void)friendPickerViewController:(ASFriendPickerViewController *)controllerをオーバーロードする必要がある
                    }
                    
                    //サーバーにデータ登録
                    [self performSelector:@selector(sendRequestToServer) withObject:nil afterDelay:1.0f];
                    
                    
                    
                }
            });
        }//for-cnt
        
    });
    
    
    
    return ;
    
}

-(void)pushExit{
    //終了ボタン押下時対応=>サーバー接続してゲーム回数を更新
    
    //    if(flag){//ボタンがレベルアップ表示が完了するまで反応しないようにする
    [self exit];
    //    }
}
-(void)exit{
    //    [super viewWillDisappear:NO];//storyboard遷移からの場合
    //BGM stop
    [bgmClass stop];
    
    //全てのメモリを解放する
    EnemyArray = nil;
    ItemArray = nil;
    MyMachine = nil;
    BackGround = nil;
    
    //ウィンドウ閉じる
    [self dismissViewControllerAnimated:NO completion:nil];//itemSelectVCのpresentViewControllerからの場合
    //    [BackGround pauseAnimations];
    //    [BackGround exitAnimations];//pauseAnimationsとexitAnimationのどちらかがおかしい
    
    GKScore *scoreReporter = [[GKScore alloc] initWithCategory:@"comendo.rodeoquest"];
    scoreReporter.value = [ScoreBoard getScore];        // とりあえずランダム値をスコアに
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        if (error != nil)
        {
            // 報告エラーの処理
        }
    }];
    
    
}

-(void)onClickedStopButton{
    NSLog(@"clicked stop button");
    isGameMode = false;
    
    [self displayStoppedFrame];
}

-(void)onClickedSettingButton{
    NSLog(@"clicked setting button");
    isGameMode = false;
    
}

-(void)displayStoppedFrame{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PAUSE"
                                                    message:@"再開するにはボタンを押して下さい"
                                                   delegate:self//デリゲートによりボタン反応はalertViewメソッドに委ねられる
                                          cancelButtonTitle:@"ゲームに戻る"
                                          otherButtonTitles:@"止める"
                          ,nil];
    [alert show];
    
    
}
//displayStoppedFrameメソッド内のalertと関連づけられている
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            //１番目のボタンが押されたときの処理を記述する
            isGameMode = true;
            break;
        case 1:
            //２番目のボタンが押されたときの処理を記述する
            NSLog(@"2");
            
            [self showActivityIndicator];
            
            //startDateからこの時点までの時間をゲーム時間として定義(attr:time_maxと比較、必要に応じて格納)
            time_game = (int)[[NSDate date] timeIntervalSinceDate:startDate];//時間を計測して格納する
            
            //exitprocessなし(情報記録なし)で終了した方が良いかも？
            [self exitProcess];
            break;
    }
    
}

-(void)displaySettingFrame{
    
}

-(void)displayScore:(ScoreBoardClass *)_boardClass{
    //スコアボードの表示
    
    //デジタル表示用
    
//     for(int i = 0; i < [[_boardClass getDigitalArray] count]; i++){
//     //removeはなくても新しいbackgroundframeの上に表示されるので見た目上は必要ない
//     //が、ないとメモリがどんどん増えていくと思う。
//     [(UIImageView*)[[_boardClass getDigitalArray] objectAtIndex:i] removeFromSuperview];
//     [self.view addSubview:[[_boardClass getDigitalArray] objectAtIndex:i]];
//     }
    
    lblScore.text = [NSString stringWithFormat:@"%d",[ScoreBoard getScore]];
    lblGold.text = [NSString stringWithFormat:@"%d", [GoldBoard getScore]];
    
    //temporary
    [lblScore sizeToFit];
    [lblGold sizeToFit];
    lblScore.center = CGPointMake(viewScoreField.bounds.size.width*2/3,
                                  lblScore.center.y);
    lblGold.center = CGPointMake(viewScoreField.bounds.size.width*2/3,
                                 lblGold.center.y);
    
    
    //テキストビュー用
    /*test
    [[_boardClass getTextView] removeFromSuperview];
    //    [self.view addSubview:[_boardClass getTextView]];
    [viewScoreField addSubview:[_boardClass getTextView]];
    */
    //textView.text = xxx;の方がスマート。＝＞要修正
    
    
}

//以下参考：http://www.atmarkit.co.jp/fsmart/articles/ios_sensor05/02.html

// 画面に指を一本以上タッチしたときに実行されるメソッド
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    isTouched = true;
    //    NSLog(@"touches count : %d (touchesBegan:withEvent:)", [touches count]);
}

// 画面に触れている指が一本以上移動したときに実行されるメソッド
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    isTouched = true;
    
    //以下の方法ではズレる：onFlickedFrame内で実装
    //    UITouch *touch = [[event allTouches] anyObject];
    //    CGPoint point = [touch locationInView:self.view];
    //    [MyMachine setX:point.x];
    //    [MyMachine setY:point.y];
    
    
    //    NSLog(@"touches count : %d (touchesMoved:withEvent:)", [touches count]);
}

// 指を一本以上画面から離したときに実行されるメソッド
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    isTouched = false;
    //    NSLog(@"touches count : %d (touchesEnded:withEvent:)", [touches count]);
}

// システムイベントがタッチイベントをキャンセルしたときに実行されるメソッド
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    isTouched = false;
    //    NSLog(@"touches count : %d (touchesCancelled:withEvent:)", [touches count]);
}



//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
//_/_/_/_/_/_/_/_/終了時処理_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
//サーバーに登録するためにhttp通信
-(void)sendRequestToServer{
    NSLog(@"start request server");
    // インジケーター表示：メニューがないので意味ない？
    //    [self showActivityIndicator];
    
    
    DBAccessClass *dbac = [[DBAccessClass alloc]init];
    NSString *_id = [attr getIdFromDevice];
    
    
    
    
    //_/_/_/_/_/端末情報更新開始：得点とゴールドを端末に記録させる=>時間がある時にAttrClassに代行！！_/_/_/_/_/_/_/_/_/_/
    
    
    //ゲーム回数
    int newGameCnt = [[attr getValueFromDevice:@"gameCnt"] intValue] + 1;
    //    NSLog(@"gameCnt = %@ => %d, updating..", [attr getValueFromDevice:@"gameCnt"], newGameCnt);
    [attr setValueToDevice:@"gameCnt" strValue:[NSString stringWithFormat:@"%d", newGameCnt]];
    
    
    
    //exp_accum:今までの獲得経験値
    //break_enemy:今までに倒した敵の数
    //gold_max:今までに最も獲得したコインの数
    //time_max:今までの最高飛行時間
    
    int exp_accum = [[attr getValueFromDevice:@"exp_accum"] intValue] + [ScoreBoard getScore];
    [attr setValueToDevice:@"exp_accum" strValue:[NSString stringWithFormat:@"%d", exp_accum]];
    
    int break_enemy = [[attr getValueFromDevice:@"break_enemy"] intValue] + enemyDown;
    [attr setValueToDevice:@"break_enemy" strValue:[NSString stringWithFormat:@"%d", break_enemy]];
    
    int gold_max = [[attr getValueFromDevice:@"gold_max"] intValue];
    int now_gold = [GoldBoard getScore];
    if(now_gold > gold_max){
        [attr setValueToDevice:@"gold_max" strValue:[NSString stringWithFormat:@"%d", now_gold]];
    }
    
    
    
    //http://d.hatena.ne.jp/mmasashi/20100524/1286123680
    int time_max = [[attr getValueFromDevice:@"time_max"] intValue];
    
    if(time_game > time_max){//time_gameは既にexitprocessを呼ぶ直前に計測
        [attr setValueToDevice:@"time_max" strValue:[NSString stringWithFormat:@"%d", time_game]];
    }
    //do something
    //    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:startDate];
    NSLog(@"game time is %lf (sec)", [[NSDate date] timeIntervalSinceDate:startDate]);
    
    
    //前回最高得点を取得する
    //    NSUserDefaults* score_defaults =
    //    [NSUserDefaults standardUserDefaults];
    //    [id_defaults removeObjectForKey:@"user_id"];//値を削除：テスト用
    //    int max_score = [score_defaults integerForKey:@"max_score"];
    int max_score = [[attr getValueFromDevice:@"score"] intValue];
    NSLog(@"now score = %d, max_score = %d", [ScoreBoard getScore], max_score);
    //今回取得したスコアが前回までの最高得点を上回れば更新
    if([ScoreBoard getScore] > max_score){
        //update
        max_score = [ScoreBoard getScore];
        //        [score_defaults setInteger:max_score forKey:@"max_score"];
        [attr setValueToDevice:@"score" strValue:[NSString stringWithFormat:@"%d", max_score]];
        //        NSLog(@"score update! => %d", [score_defaults integerForKey:@"max_score"]);
        NSLog(@"score update! => %d", [[attr getValueFromDevice:@"score"] intValue]);
        
        //congrat!! view appear!effect!!
        
        //世界の10位を上回ったら更新
        //        if( [ScoreBoard getScore] > tenth_world_record){
        //            fill_out_your_name!
        //        }
        
        
        
    }else{
        NSLog(@"not updating so be going ...");
    }
    
    //累積ゴールドを取得して累積計算
    //    NSUserDefaults* gold_defaults = [NSUserDefaults standardUserDefaults];
    //    int before_gold = [gold_defaults integerForKey:@"gold_score"];
    int before_gold = [[attr getValueFromDevice:@"gold"] intValue];
    int after_gold = before_gold + [GoldBoard getScore];
    NSLog(@"now gold = %d, before_gold = %d, so after_gold = %d", [GoldBoard getScore], before_gold, after_gold);
    //    if([GoldBoard getScore] < before_gold){
    //    [gold_defaults setInteger:after_gold forKey:@"gold_score"];
    [attr setValueToDevice:@"gold" strValue:[NSString stringWithFormat:@"%d", after_gold]];
    //    NSLog(@"gold update! => %d ... this comment is annouced regardless updating!", [score_defaults integerForKey:@"gold_score"]);
    NSLog(@"gold update! => %d ... this comment is annouced regardless updating!", [[attr getValueFromDevice:@"gold"] intValue]);
    //    }else{
    //        NSLog(@"be going ...");
    //    }
    
    
    //exp&levelをupdate
    int beforeExp = [[attr getValueFromDevice:@"exp"] intValue];
    int beforeLevel = [[attr getValueFromDevice:@"level"] intValue];
    //経験値とレベルの両方を更新
    [attr addExp:[ScoreBoard getScore]];
    //上記addExpにより下記setValueToDevice@exp & setValueToDevice@levelを両方同時に実行
    //    [attr setValueToDevice:@"exp" strValue:[NSString stringWithFormat:@"%d", afterExp]];
    //    [attr setValueToDevice:@"level" strValue:[NSString stringWithFormat:@"%d", afterLevel]];
    
    int afterExp = [[attr getValueFromDevice:@"exp"] intValue];
    int afterLevel = [[attr getValueFromDevice:@"level"] intValue];
    NSLog(@"ゲーム前経験値%d, 今回獲得スコア%d => ゲーム後経験値%d", beforeExp, [ScoreBoard getScore], afterExp);
    NSLog(@"ゲーム前レベル%d　=> ゲーム後レベル%d", beforeLevel, afterLevel);
    
    
    //武器レベルの更新
    int id_weapon = -1;
    for(BowType bow = 0; bow < 10;bow++){
        if([[attr getValueFromDevice:[NSString stringWithFormat:@"weaponID%d", bow]]
            isEqualToString:@"2"]){
            id_weapon = bow;
            
            [attr addWeaponExp:[ScoreBoard getScore] weaponID:id_weapon];
            break;
        }
    }
    NSLog(@"端末情報更新完了");
    
    //_/_/_/_/_/_/端末情報更新完了_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    
    
    //_/_/_/_/サーバ情報更新：id        name        score        gold        login        gamecnt        level        exp_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    
    //score(最高得点)更新：既に比較されて端末情報max_scoreに格納されている。
    //  after_score = [[dbac getValueFromDB:_id column:@"score"] intValue];
    [dbac updateValueToDB:_id column:@"score" newVal:[NSString stringWithFormat:@"%d", max_score]];
    
    //gold更新：既に累積されて端末情報gold_scoreに格納されている。
    [dbac updateValueToDB:_id column:@"gold" newVal:[NSString stringWithFormat:@"%d", after_gold]];
    
    //login:更新せず
    
    //gameCntをupdate
    int gameCnt = [[dbac getValueFromDB:_id column:@"gamecnt"] intValue];
    gameCnt ++;
    //        [dbac updateValueToDB:_id column:@"login" value:[NSString stringWithFormat:@"%d", login ]];
    [dbac updateValueToDB:_id column:@"gameCnt" newVal:[NSString stringWithFormat:@"%d", gameCnt]];
    NSLog(@"gameCnt = %@回目", [dbac getValueFromDB:_id column:@"gameCnt"]);
    
    //level
    [dbac updateValueToDB:_id column:@"level" newVal:[NSString stringWithFormat:@"%d", afterLevel]];
    
    //exp
    [dbac updateValueToDB:_id column:@"exp" newVal:[NSString stringWithFormat:@"%d", afterExp]];
    
    
    //更新情報の確認id        name        score        gold        login        gamecnt        level        exp
    NSLog(@"更新後id = %@, name = %@, score = %@, gold = %@, login = %@, gameCnt = %@, level = %@, exp = %@",
          [dbac getValueFromDB:_id column:@"id"],
          [dbac getValueFromDB:_id column:@"name"],
          [dbac getValueFromDB:_id column:@"score"],
          [dbac getValueFromDB:_id column:@"gold"],
          [dbac getValueFromDB:_id column:@"login"],
          [dbac getValueFromDB:_id column:@"gamecnt"],
          [dbac getValueFromDB:_id column:@"level"],
          [dbac getValueFromDB:_id column:@"exp"]
          );
    
    
    //最後の処理＝終了処理
//    //無限ループを組んで値が更新されるまでhideActivityIndicatorをしない
//    for(int i = 0;;i++){
//        NSLog(@"gameCntFromDevice= %d, gameCntFromDB=%@", gameCnt, [dbac getValueFromDB:_id column:@"gamecnt"]);
//        if(gameCnt == [[dbac getValueFromDB:_id column:@"gamecnt"] intValue] ||
//           i > 10){//10回やってダメなら諦める:ネット回線が切れているか遅すぎるか
//            [self hideActivityIndicator];
//            break;
//        }
//    }
    
    //xx秒後にhideActivityIndicatorを実行(その中でactivityIndを消去＆画面全体に(透明の)終了ボタンを貼付ける)
    [NSTimer scheduledTimerWithTimeInterval:3.0f
                                     target:self
                                   selector:@selector(hideActivityIndicator)
                                   userInfo:nil repeats:NO];
    
    
    // インジケーター非表示(このメソッドを表示する際に表示済)
    //    [self hideActivityIndicator];//network通信終了後までhideしないようにするためには？
    
}

/*
 * インジケーター表示
 */
- (void)showActivityIndicator
{
    NSLog(@"showActivity indicator");
    // Activity Indicator 表示
    //    _loadingView                 = [[UIView alloc] initWithFrame:self.navigationController.view.bounds];
    _loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
    //    _loadingView.backgroundColor = [UIColor blackColor];
    _loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
    //    _loadingView.alpha           = 0.5f;//上のビューにも反映
    _indicator                   = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    [_indicator setCenter:CGPointMake(_loadingView.bounds.size.width/2, _loadingView.bounds.size.height/2)];
    _indicator.center =
    CGPointMake(_loadingView.bounds.size.width/2,
                _loadingView.bounds.size.height - 100);//下からの相対位置で指定する
    
    
    [_loadingView addSubview:_indicator];
    [self.view addSubview:_loadingView];
    [self.view bringSubviewToFront:_loadingView];
    
    //    [self.navigationController.view addSubview:_loadingView];
    [_indicator startAnimating];
    //    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
    
    UITextView *tvWaiting = [CreateComponentClass
                             createTextView:CGRectMake(0, 0, _loadingView.frame.size.width, 50)
                             text:@"now loading..."
                             font:@"AmericanTypewriter-Bold"
                             size:30
                             textColor:[UIColor lightGrayColor]
                             backColor:[UIColor clearColor]
                             isEditable:NO];
    tvWaiting.center = CGPointMake(_loadingView.frame.size.width/2,
                                   _indicator.center.y + _indicator.bounds.size.height+5);//under indicator
    tvWaiting.textAlignment = NSTextAlignmentCenter;
    tvWaiting.text = @"data updating ...";
    [_loadingView addSubview:tvWaiting];
    
}

/*
 * インジケーター非表示:メニュー非表示モードなので、画面中心に薄く表示される程度が良い？->rotate-animate?
 * 開始時と終了時に呼び出される：time_gameで判別可能
 */
- (void)hideActivityIndicator
{
    NSLog(@"hide activity");
    // Activity Indicator 非表示
    [_indicator stopAnimating];
    [_loadingView removeFromSuperview];
    //    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
//    //ダサい
//    if(time_game > 0){
//        //終了ボタンの配置
//        
//        int radius = 100;
//        CGRect rectBtn =
//        CGRectMake(self.view.bounds.size.width/2 - radius,
//                   self.view.bounds.size.height - radius*2,
//                   radius*2, radius*2);
//        ClowdButtonWIthView *btnForExit =
//        [[ClowdButtonWIthView alloc]
//         initWithFrame:rectBtn
//         target:self
//         method:@"pushExit"];//center調整してはいけない(内部で引数にあるフレームを参照しているため)
//        
////        btnForExit.center =
////        CGPointMake(self.view.bounds.size.width/2,
////                    self.view.bounds.size.height - btnForExit.bounds.size.height);
//        
//        [self.view addSubview:btnForExit];
//        [self.view bringSubviewToFront:btnForExit];
//        
//    }
    
    if(time_game > 0){
        UILabel *exitLabel =
        [[UILabel alloc]
         initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,50)];
        exitLabel.center =
        CGPointMake(self.view.bounds.size.width/2,
                    self.view.bounds.size.height-80);
        exitLabel.textAlignment = NSTextAlignmentCenter;
        exitLabel.text = @"画面上をタップして終了して下さい";
        exitLabel.textColor = [UIColor whiteColor];
        exitLabel.backgroundColor = [UIColor clearColor];
        exitLabel.font = [UIFont fontWithName:@"AmericanTypewriter-Bold"
                                         size:15];
        
        [self.view addSubview:exitLabel];
        
        //画面全体に透明の終了ボタンを貼付ける
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = self.view.bounds;
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self
                action:@selector(pushExit)
      forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
}


/*
 *自機と指定した距離を取得する
 */
-(float)getDistance:(int)x y:(int)y{
    int x0 = [MyMachine getImageView].center.x;
    int y0 = [MyMachine getImageView].center.y;
    //    NSLog(@"distance = %f", sqrtf((x - x0) * (x - x0) + (y - y0) * (y - y0)));
    return sqrtf((x - x0) * (x - x0) + (y - y0) * (y - y0));
}


-(void)enemyDieEffect:(int)i{
    //imageViewだけを消去(爆発パーティクルが描画するためインスタンス自体は残しておく)
    [[[EnemyArray objectAtIndex:i] getImageView] removeFromSuperview];
    
    
    //効果音=>別クラスに格納してstatic method化して簡潔に！
    AudioServicesPlaySystemSound (sound_hit_ID);
    
    ////                            NSLog(@"パーティクル = %@", [(EnemyClass *)[EnemyArray objectAtIndex:i] getExplodeParticle]);
    //爆発パーティクル表示
    //                            [[(EnemyClass *)[EnemyArray objectAtIndex:i] getExplodeParticle] setUserInteractionEnabled: NO];//インタラクション拒否
    //                            [[(EnemyClass *)[EnemyArray objectAtIndex:i] getExplodeParticle] setIsEmitting:YES];//消去するには数秒後にNOに
    //                            [self.view bringSubviewToFront: [(EnemyClass *)[EnemyArray objectAtIndex:i] getExplodeParticle]];//最前面に
    //                            [self.view addSubview: [(EnemyClass *)[EnemyArray objectAtIndex:i] getExplodeParticle]];//表示する
    //smoke-effect
    UIView *smoke = [[EnemyArray objectAtIndex:i] getSmokeEffect];
    [self.view bringSubviewToFront:smoke];
    [self.view addSubview:smoke];
    smoke = [[EnemyArray objectAtIndex:i] getSmokeEffect];
    [self.view bringSubviewToFront:smoke];
    [self.view addSubview:smoke];
    smoke = [[EnemyArray objectAtIndex:i] getSmokeEffect];
    [self.view bringSubviewToFront:smoke];
    [self.view addSubview:smoke];
    
    
    //クリティカルヒット及びビーム発射時及び象撃破時のみ→修正要
    //explodeEffect
    ViewExplode *viewExplode = [[EnemyArray objectAtIndex:i] getExplodeEffect];
    [self.view addSubview:viewExplode];
    
    
    
    
    //得点の加算
    [ScoreBoard setScore:[ScoreBoard getScore] + 5 + [[EnemyArray objectAtIndex:i] getType]];//from 5 to 9
    [self displayScore:ScoreBoard];
    
    enemyDown++;
}


/*
 *現在位置(mymachine getimageview.center)からランダムに爆弾を投げる
 *レベル上昇で意図した場所に投げられる？
 */
-(void)throwBombAnimation{

    //投下用爆弾
    UIImageView *bombView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,
                                                                         ITEM_SIZE*1.5f, ITEM_SIZE)];
    bombView.image = [UIImage imageNamed:@"bomb026.png"];
    
    
    bombView.center = [MyMachine getImageView].center;
    CGPoint kStartPos = bombView.center;//((CALayer *)[view.layer presentationLayer]).position;
    
    //生きているターゲットを探す
    int noTargetEnemy = 0;
    int counter = 0;
    for(noTargetEnemy = arc4random() % [EnemyArray count];
        ![EnemyArray[noTargetEnemy] getIsAlive] ||//敵が死んでいればループ継続
        [EnemyArray[noTargetEnemy] getY] > [MyMachine getY];//自機位置より前方にいないならループ継続
        noTargetEnemy = arc4random() % [EnemyArray count]){
        
        counter++;
        if(counter > 50){//if not found enemy by 50times loop, then return
            return;//諦めてメソッド終了
        }
        
    }
    
    
    //ターゲットにライブラリを付与
    powerGauge = [[PowerGaugeClass alloc ]init:0 x_init:0 y_init:0 width:OBJECT_SIZE height:OBJECT_SIZE];
    //    [powerGauge getImageView].transform = CGAffineTransformMakeRotation(2*M_PI* (float)(count-1)/60.0f );
    [[EnemyArray[noTargetEnemy] getImageView] addSubview:[powerGauge getImageView]];
    [[EnemyArray[noTargetEnemy] getImageView] bringSubviewToFront:[powerGauge getImageView]];
    
    //target add ribrary effect
    
    
    //アニメーション実行中の経過時間を考慮して、敵の現在位置より少し手前に投げる。
    CGPoint kEndPos = CGPointMake([EnemyArray[noTargetEnemy] getX],
                                  [EnemyArray[noTargetEnemy] getY] + 50);//レベル上昇で意図した場所に投げられる？
    
    
    
    
    [CATransaction begin];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    //    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    //    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [CATransaction setCompletionBlock:^{//終了処理
        //        [self animAirView:view];
        CAAnimation *animationKeyFrame = [bombView.layer animationForKey:@"position"];
        if(animationKeyFrame){
            //途中で終わらずにアニメーションが全て完了した場合
            //            NSLog(@"bomb throwed!!");
            
            //爆発エフェクト
            //            float x = ((CALayer *)[bombView.layer presentationLayer]).position.x;
            //            float y = ((CALayer *)[bombView.layer presentationLayer]).position.y;
            //            NSLog(@"x = %f, y = %f", x, y);
            [self ExplodeBombEffect:kEndPos];//CGPointMake(x, y)];//bombView.center];//((CALayer *)[bombView.layer presentationLayer]).position];
            
            [bombView removeFromSuperview];
            
        }else{
            //途中で何らかの理由で遮られた場合
            //            NSLog(@"animation key frame not exit");
        }
        
    }];
    
    {
        
        //回転させたい！
        //http://stackoverflow.com/questions/7329426/how-can-i-rotate-a-uibutton-continuously-and-be-able-to-stop-it
        //http://stackoverflow.com/questions/7204607/ios-cakeyframeanimation-rotate
        
        // CAKeyframeAnimationオブジェクトを生成
        CAKeyframeAnimation *animation;
        animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        animation.fillMode = kCAFillModeForwards;
        animation.removedOnCompletion = NO;
        animation.duration = 0.7f;
        
        // 放物線のパスを生成
        CGPoint peakPos = CGPointMake((arc4random()%2==0?0:320),//kStartPos.x + arc4random() % 600 - 300,
                                      kEndPos.y*0.05f);//test
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
        [bombView.layer addAnimation:animation forKey:@"position"];
        
    }
    [CATransaction commit];
    
    //    [UIView animateWithDuration:3.0f
    //                     animations:^{
    //                         bombView.center = self.view.center;
    //                     }];
    
    [self.view bringSubviewToFront:bombView];
    [self.view addSubview:bombView];
}

-(void)ExplodeBombEffect:(CGPoint)point{
    int bombSize = 200;
    UIImageView *uivBomb = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,
                                                                        bombSize/10, bombSize/10)];
    uivBomb.image = [UIImage imageNamed:@"bomb012.png"];//original:758x598
    uivBomb.center = point;
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/10.0f);
    [UIView animateWithDuration:0.1f
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
     //     |UIViewAnimationOptionRepeat//リピートさせる場合
                     animations:^{
                         uivBomb.transform = transform;
                         uivBomb.frame = CGRectMake(point.x - bombSize/2,
                                                    point.y - bombSize/2,
                                                    bombSize, 758.0f/598*bombSize);
                         uivBomb.center = point;
                     }
                     completion:^(BOOL finished){
                         [uivBomb removeFromSuperview];
                         
                         //爆発範囲内の敵にダメージor殲滅？
                         for(int i = 0;i < [EnemyArray count] ;i++){
                             if([[EnemyArray objectAtIndex:i] getIsAlive]){
                                 _xEnemy = [[EnemyArray objectAtIndex:i] getX];
                                 _yEnemy = [[EnemyArray objectAtIndex:i] getY];
                                 _sEnemy = [[EnemyArray objectAtIndex:i] getSize];
                                 
                                 if(point.x + bombSize * 0.5 >= _xEnemy - _sEnemy * 0.5 &&
                                    point.x - bombSize * 0.5 <= _xEnemy + _sEnemy * 0.5 &&
                                    point.y + bombSize * 0.5 >= _yEnemy - _sEnemy * 0.5 &&
                                    point.y - bombSize * 0.5 <= _yEnemy + _sEnemy * 0.5 ){
                                     
                                     //                                     [self enemyDieEffect:i];//殲滅？
                                     [self giveDamageToEnemy:i damage:3 x:_xEnemy y:_yEnemy];
                                     
                                     
                                 }
                             }
                         }
                     }];
    [self.view addSubview:uivBomb];
    
    //    ExplodeParticleView *explode = [[ExplodeParticleView alloc]initWithFrame:CGRectMake(point.x - bombSize/2
    //                                                                                        , point.y - bombSize/2,
    //                                                                                        bombSize, bombSize)];
    //
    //    [UIView animateWithDuration:0.9f
    //                     animations:^{
    //                         explode.alpha = 0.0f;
    //                     }
    //                     completion:^(BOOL finished){
    //                         [explode setIsEmitting:NO];
    //                         [explode removeFromSuperview];
    //                     }];
    ////    ExplodeParticleView.center = point;
    //    [self.view addSubview:explode];
    
}

-(void)ItemBombEffect:(CGPoint)point{
    int bombSize = 200;
    UIImageView *uivBomb = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,
                                                                        bombSize/10, bombSize/10)];
    uivBomb.image = [UIImage imageNamed:@"bomb016.png"];//original:758x598
    uivBomb.center = point;
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/10.0f);
    [UIView animateWithDuration:0.2f
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
     //     |UIViewAnimationOptionRepeat//リピートさせる場合
                     animations:^{
                         uivBomb.transform = transform;
                         uivBomb.frame = CGRectMake(point.x - bombSize/2,
                                                    point.y - bombSize/2,
                                                    bombSize, 675.0f/547*bombSize);
                         uivBomb.center = point;
                     }
                     completion:^(BOOL finished){
                         [uivBomb removeFromSuperview];
                         
                         //連続した小爆発(爆発周りの敵にダメージ)
                         [self smallBombEffectRepeat:10 point:CGPointMake(arc4random() % (int)self.view.bounds.size.width, arc4random() % (int)(self.view.bounds.size.height*0.8f))];
                     }];
    [self.view addSubview:uivBomb];
}

//item-Bombを取得した時に画面上に爆発が発生する
-(void)smallBombEffectRepeat:(int)repeatCount point:(CGPoint)point{//sub-effect of itemBombEffect
    int bombSize = 150;
    UIImageView *uivBomb = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,
                                                                        bombSize/10, bombSize/10)];
    switch (repeatCount % 3) {
        case 0:{
            uivBomb.image = [UIImage imageNamed:@"bomb010.png"];//original:318x340
            break;
        }
        case 1:{
            uivBomb.image = [UIImage imageNamed:@"bomb013.png"];//original:541x484
            break;
        }
        case 2:{
            uivBomb.image = [UIImage imageNamed:@"bomb017.png"];//original:281x325
        }
        default:
            break;
    }
    //    uivBomb.image = [UIImage imageNamed:@"bomb016.png"];//original:758x598
    uivBomb.center = point;
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/10.0f);
    [UIView animateWithDuration:0.2f
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
     //     |UIViewAnimationOptionRepeat//リピートさせる場合
                     animations:^{
                         uivBomb.transform = transform;
                         uivBomb.frame = CGRectMake(point.x - bombSize/2,
                                                    point.y - bombSize/2,
                                                    bombSize, 675.0f/547*bombSize);
                         uivBomb.center = point;
                     }
                     completion:^(BOOL finished){
                         [uivBomb removeFromSuperview];
                         
                         for(int i = 0;i < [EnemyArray count] ;i++){
                             if([[EnemyArray objectAtIndex:i] getIsAlive]){
                                 _xEnemy = [[EnemyArray objectAtIndex:i] getX];
                                 _yEnemy = [[EnemyArray objectAtIndex:i] getY];
                                 _sEnemy = [[EnemyArray objectAtIndex:i] getSize];
                                 
                                 if(point.x + bombSize * 0.5 >= _xEnemy - _sEnemy * 0.5 &&
                                    point.x - bombSize * 0.5 <= _xEnemy + _sEnemy * 0.5 &&
                                    point.y + bombSize * 0.5 >= _yEnemy - _sEnemy * 0.5 &&
                                    point.y - bombSize * 0.5 <= _yEnemy + _sEnemy * 0.5 ){
                                     
                                     //                                     [self enemyDieEffect:i];//殲滅？orダメージ
                                     [self giveDamageToEnemy:i damage:10 x:_xEnemy y:_xEnemy];
                                     
                                     
                                 }
                             }
                         }
                         
                         if(repeatCount > 0){
                             [self smallBombEffectRepeat:repeatCount-1
                                                   point:CGPointMake(arc4random() % (int)self.view.bounds.size.width, arc4random() % (int)self.view.bounds.size.height)];
                         }
                     }];
    [self.view addSubview:uivBomb];
}

-(BOOL)giveDamageToEnemy:(int)i damage:(int)_damage x:(int)_xBeam y:(int)_yBeam{
    return [self giveDamageToEnemy:i damage:_damage x:_xBeam y:_yBeam beamType:-1];//(通常弾もしくはレーザーによる)通常モードでの攻撃
}
    
-(BOOL)giveDamageToEnemy:(int)i damage:(int)_damage x:(int)_xBeam y:(int)_yBeam beamType:(int)beamType{
    //ビームが衝突した位置にdamageParticle表示(damageParticle生成のため位置情報を渡す)
    NSLog(@"multiple = %d", multipleBulletPower);
    [(EnemyClass *)[EnemyArray objectAtIndex:i] setDamage:_damage * multipleBulletPower location:CGPointMake(_xBeam, _yBeam) beamType:(int)beamType];
    
    
    //エフェクトについて
    //以下if文内のエフェクトはenemyClassで記述：特殊武器による連蔵ダメージモードで死んだ時にivの消去＆死亡時爆発エフェクトが表示されない
    
    
    //内部処理について
    //ordinaryAnimation内において全ての敵を常に監視してisDiedフラグ(死亡した瞬間だけフラグが立つ)を見つけたら
    //それを判別して撃墜カウント、次軍発生までのカウント発動
    //その場所でアイテムを生成(エフェクト)
    
    
    //ビームに当たる前に生きていた敵が死んだら＝今回のビームで敵を倒したら
    //dieEffect
    if(![[EnemyArray objectAtIndex:i] getIsAlive]){
        
        //敵全滅によりcounterを発動:次のordinaryAnimループで実行される
//        if([self getCountAliveEnemy] == 0){//生存している敵がいないならカウンターは集う
//            timeIntervalEnemy = timeIntervalEnemyMax;//ゲーム進行とともにインターバルを現象させる
//        }
        
        //敵機撃墜時のエフェクト=>enemyClassで記述
//        [self enemyDieEffect:i];//雲とかViewExplodeとか。
        
        
//        //アイテムの生成:次のordinaryAnimループで実行される
//        [self
//         generateItem:-1
//         x:[[EnemyArray objectAtIndex:i] getX]
//         y:[[EnemyArray objectAtIndex:i] getY]];
        
        
        /*
         【以下のbreak(return YES)は極めて重要！】
         強いビームパワーの場合、(一発で倒しても)同じ敵に対して何度もhit(＝enemyDown++)してしまう
         １つの敵に対して複数の玉があたってenemyDownする
         */
        return YES;//=break:その敵への衝突判定は辞めて、次の敵への衝突判定のため最初から最後までビームループを回す＃注意
        //＃ちなみに(最初：最後に発生したビームから)「最後：最初に発生したビームまで」の衝突判定をさせるのたは「ある意味」非効率：今回ビームjより(時間的)前に発生したビームが後ろの敵に当たることはあまりない
        //#しかし、自機がビームの進行速度を上回って前方に進行した場合や敵機がまっすぐ進行して来なかった場合(曲線を描いて来た場合など)は時間的に後で発生したビームに衝突する場合がある。
        //前提：ビームも敵もFIFO配列
        
    }else{
        //敵が倒されなければダメージパーティクルのみ表示
        //処理が重くなるので実施見送り
        //ダメージパーティクル表示：処理が間に合わない可能性があるので、配列に格納して数カウントで消去
        //                            [[(EnemyClass *)[EnemyArray objectAtIndex:i] getDamageParticle] setUserInteractionEnabled: NO];//インタラクション拒否
        //                            [[(EnemyClass *)[EnemyArray objectAtIndex:i] getDamageParticle] setIsEmitting:YES];//消去するには数秒後にNOに
        //                            [self.view bringSubviewToFront: [(EnemyClass *)[EnemyArray objectAtIndex:i] getDamageParticle]];//最前面に
        //                            [self.view addSubview: [(EnemyClass *)[EnemyArray objectAtIndex:i] getDamageParticle]];//表示する:次のcountで消去
        
        
        
        //その敵が生きているならば同じ敵に別のビームへの衝突判定するため(continue)
        return NO;//continue;//次のビームの衝突判定へ(ビームループ内でこの後何もしなければこのcontinueはなくても良い)
        
    }
}


/*
 *引数の_typeはシグナル＝＞アイテム指定もしくは生成個数についてのシグナル＝沢山出す等：未定義
 *他の引数(x、y)は生成位置
 */
-(void)generateItem:(int)_type x:(int)_xItem y:(int)_yItem{
    if(_type != -1){//
        
        return;
    }
    //特定ステータスではコインのみ
    if([MyMachine getStatus:ItemTypeBig] ||
       [MyMachine getStatus:ItemTypeBomb] ||
       [MyMachine getStatus:ItemTypeMagnet] ||
       [MyMachine getStatus:ItemTypeWeapon0] ||
       //           [MyMachine getStatus:ItemTypeWeapon1] ||//複数ビームは何度も２回まで取得可能(制限をかけるなら[MyMachine getNumOfBeam]等)
       [MyMachine getStatus:ItemTypeWeapon2]){
        
        if(arc4random() % 100 >= 20){//本番では40(特殊状態でコインが沢山取れる方が嬉しいため)
            _item = [[ItemClass alloc] init:ItemTypeYellowGold x_init:_xItem y_init:_yItem width:ITEM_SIZE height:ITEM_SIZE];
        }else if(arc4random() % 2 == 0){
            _item = [[ItemClass alloc] init:ItemTypeGreenGold x_init:_xItem y_init:_yItem width:ITEM_SIZE height:ITEM_SIZE];
        }else if(arc4random() % 3 == 0){
            _item = [[ItemClass alloc] init:ItemTypeBlueGold x_init:_xItem y_init:_yItem width:ITEM_SIZE height:ITEM_SIZE];
        }else if(arc4random() % 3 == 0){
            _item = [[ItemClass alloc] init:ItemTypePurpleGold x_init:_xItem y_init:_yItem width:ITEM_SIZE height:ITEM_SIZE];
        }else if(arc4random() % 3 == 0){
            _item = [[ItemClass alloc] init:ItemTypeMagnet x_init:_xItem y_init:_yItem width:ITEM_SIZE height:ITEM_SIZE];
        }else{
            _item = [[ItemClass alloc] init:ItemTypeRedGold x_init:_xItem y_init:_yItem width:ITEM_SIZE height:ITEM_SIZE];
        }
    }else{//通常時におけるアイテム出現定義
        int probabilityt = arc4random() % 100;
        //アイテム出現、アイテム生成
        if(probabilityt > 40){//60%の確率
            _item = [[ItemClass alloc] init:ItemTypeYellowGold x_init:_xItem y_init:_yItem width:ITEM_SIZE height:ITEM_SIZE];
        }else if(arc4random() % 3 < 1){//2/3
            _item = [[ItemClass alloc] init:ItemTypeGreenGold x_init:_xItem y_init:_yItem width:ITEM_SIZE height:ITEM_SIZE];
        }else if(arc4random() % 3 == 0){
            _item = [[ItemClass alloc] init:ItemTypeBlueGold x_init:_xItem y_init:_yItem width:ITEM_SIZE height:ITEM_SIZE];
        }else if(arc4random() % 3 == 0){
            _item = [[ItemClass alloc] init:ItemTypePurpleGold x_init:_xItem y_init:_yItem width:ITEM_SIZE height:ITEM_SIZE];
        }else if(arc4random() % 5 == 0){
            _item = [[ItemClass alloc] init:ItemTypeMagnet x_init:_xItem y_init:_yItem width:ITEM_SIZE height:ITEM_SIZE];
        }else if(arc4random() % 3 == 0){
            _item = [[ItemClass alloc] init:ItemTypeWeapon1 x_init:_xItem y_init:_yItem width:ITEM_SIZE height:ITEM_SIZE];
        }else if(arc4random() % 3 == 0){
            _item = [[ItemClass alloc] init:ItemTypeWeapon2 x_init:_xItem y_init:_yItem width:ITEM_SIZE height:ITEM_SIZE];
        }else if(arc4random() % 3 == 0){
            _item = [[ItemClass alloc] init:ItemTypeCookie x_init:_xItem y_init:_yItem width:ITEM_SIZE height:ITEM_SIZE];
        }else if(arc4random() % 3 == 0){//barrier
            _item = [[ItemClass alloc] init:ItemTypeDeffense0 x_init:_xItem y_init:_yItem width:ITEM_SIZE height:ITEM_SIZE];
        }else if(arc4random() % 3 == 0){//shield
            _item = [[ItemClass alloc] init:ItemTypeDeffense1 x_init:_xItem y_init:_yItem width:ITEM_SIZE height:ITEM_SIZE];
        }else{//
            
            //                if([EnemyArray count] > MAX_ENEMY_NUM/2){//ピンチ=敵が多ければ:最大の半分以上
            if(arc4random() % 2 == 0 && [EnemyArray count] > 5){//もしくは敵の位置が自機に近い時など
                _item = [[ItemClass alloc] init:ItemTypeBig x_init:_xItem y_init:_yItem width:ITEM_SIZE height:ITEM_SIZE];
            }else if(arc4random() % 2 == 0){
                _item = [[ItemClass alloc] init:ItemTypeBomb x_init:_xItem y_init:_yItem width:ITEM_SIZE height:ITEM_SIZE];
            }else{
                _item = [[ItemClass alloc] init:arc4random() % 16 x_init:_xItem y_init:_yItem width:ITEM_SIZE height:ITEM_SIZE];
            }
        }
    }
    
    //test:item
    //        _item = [[ItemClass alloc] init:ItemTypeWeapon0 x_init:_xItem y_init:_yItem width:ITEM_SIZE height:ITEM_SIZE];
    
    [ItemArray insertObject:_item atIndex:0];
    //現状全てのアイテムは手前に進んで消えるので先に発生(FIFO)したものから消去
    if([ItemArray count] > 50){
        NSLog(@"item count = %d so remove dead", [ItemArray count]);
        //            for(int i = 0; i < [ItemArray count];i++){
        //                NSLog(@"item %d is %@", i, [ItemArray[i] getIsAlive]?@"alive":@"dead");
        //            }
        //isDeadなのになぜか格納されているものがあるので削除(画面上には表示されていない)
        for(int i = [ItemArray count]-1;i >= 0;i--){
            if(![[ItemArray objectAtIndex:i] getIsAlive]){
                NSLog(@"item %d is dead so remove(view & array)", i);
                [[[ItemArray objectAtIndex:i] getImageView] removeFromSuperview];
                [ItemArray removeObjectAtIndex:i];
                //                    break;
            }
        }
        //            [ItemArray removeLastObject];
    }
    [self.view bringSubviewToFront:[[ItemArray objectAtIndex:0] getImageView]];
    [self.view addSubview:[[ItemArray objectAtIndex:0] getImageView]];
    
    
}


-(void)dispEffectItemAcq:(ItemType)_itemType{
    
    int x0 = [MyMachine getImageView].center.x;
    int y0 = [MyMachine getImageView].center.y;
    KiraType _kiraType = KiraTypeYellow;
    switch (_itemType) {
        case ItemTypeYellowGold:{
            _kiraType = KiraTypeYellow;
            break;
        }
        case ItemTypeGreenGold:{
            _kiraType = KiraTypeGreen;
            break;
        }
        case ItemTypeBlueGold:{
            _kiraType = KiraTypeBlue;
            break;
        }
        case ItemTypePurpleGold:{
            _kiraType = KiraTypePurple;
            break;
        }
        case ItemTypeRedGold:{
            _kiraType = KiraTypeRed;
            break;
        }
        default:{
            _kiraType = KiraTypeBlue;
            break;
        }
    }
    if(_itemType == ItemTypeRedGold ||
       _itemType == ItemTypePurpleGold ||
       _itemType == ItemTypeBlueGold ||
       _itemType == ItemTypeGreenGold ||
       _itemType == ItemTypeYellowGold){
        
        //        UIImageView *ivItemAcq = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, OBJECT_SIZE*3, OBJECT_SIZE*3)];
        ViewKira *ivItemAcq = [[ViewKira alloc]
                               initWithFrame:CGRectMake(0, 0, OBJECT_SIZE/2, OBJECT_SIZE/2)
                               type:_kiraType];
        ivItemAcq.center = CGPointMake(x0, y0);//OBJECT_SIZE/2, 0);
        
        //        ivItemAcq.alpha = 1.0f;//MIN(exp(((float)(arc4random() % 100))*4.0f / 100.0f - 1),1);//0-1の指数関数(１の確率が４分の３)
        
        [UIView animateWithDuration:0.5f
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             ivItemAcq.center = CGPointMake(x0, y0 - OBJECT_SIZE*4/5);//OBJECT_SIZE/2, -OBJECT_SIZE);
                             ivItemAcq.alpha = 0.7f;
                             CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/2);
                             ivItemAcq.transform = transform;//...ok?
                         }
                         completion:^(BOOL finished){
                             
                             if(finished){
                                 [UIView animateWithDuration:0.5f
                                                       delay:0.0
                                                     options:UIViewAnimationOptionCurveLinear
                                                  animations:^{
                                                      //add rotation
                                                      CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
                                                      ivItemAcq.transform = transform;//...ok?
                                                      ivItemAcq.center = CGPointMake(x0, y0 - OBJECT_SIZE);
                                                      ivItemAcq.alpha = 0.0f;
                                                  }
                                                  completion:^(BOOL finished){
                                                      
                                                      if(finished){
                                                          [ivItemAcq removeFromSuperview];
                                                      }
                                                  }];
                             }
                         }];
        //上記で設定したUIImageViewを配列格納
        [self.view addSubview:ivItemAcq];
        [self.view bringSubviewToFront:ivItemAcq];
    }else{//kiratypeWhite
        //沢山の小さなキラキラを表示
        //以下要修正：配列でキラを表示させると、ループ順に終了せずに、スタックに残ってしまう
        //->キラキラを複数貼付けた一つのイメージファイルとして表示する必要がある。
        /*
         for(int i = 0; i < 10; i++){
         //            UIImageView *ivItemAcq = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, OBJECT_SIZE, OBJECT_SIZE)];
         //            ivItemAcq.center = CGPointMake(x0, y0);//OBJECT_SIZE/2, 0);
         //            ivItemAcq.image = [UIImage imageNamed:@"img11.png"];
         ViewKira *ivItemAcq =
         [[ViewKira alloc] initWithFrame:CGRectMake(0, 0, OBJECT_SIZE/5, OBJECT_SIZE/5)
         type:_kiraType];
         ivItemAcq.center = CGPointMake(x0, y0);
         
         ivItemAcq.alpha = 1.0f;//MIN(exp(((float)(arc4random() % 100))*4.0f / 100.0f - 1),1);//0-1の指数関数(１の確率が４分の３)
         
         [UIView animateWithDuration:0.5f
         delay:0.0
         options:UIViewAnimationOptionCurveLinear
         animations:^{
         ivItemAcq.center = CGPointMake(x0+arc4random()%OBJECT_SIZE,
         y0 - OBJECT_SIZE*4/5+arc4random()%OBJECT_SIZE/2);
         ivItemAcq.alpha = 0.7f;
         CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/4);
         ivItemAcq.transform = transform;//...ok?
         }
         completion:^(BOOL finished){
         
         if(finished){
         [UIView animateWithDuration:0.5f
         delay:0.0
         options:UIViewAnimationOptionCurveLinear
         animations:^{
         //add rotation
         CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
         ivItemAcq.transform = transform;//...ok?
         ivItemAcq.center = CGPointMake(x0+arc4random()%OBJECT_SIZE,
         y0 - OBJECT_SIZE+arc4random()%OBJECT_SIZE/2);
         ivItemAcq.alpha = 0.0f;
         }
         completion:^(BOOL finished){
         
         if(finished){
         [ivItemAcq removeFromSuperview];
         }
         }];
         }
         }];
         //上記で設定したUIImageViewを配列格納
         [self.view addSubview:ivItemAcq];
         [self.view bringSubviewToFront:ivItemAcq];
         }
         */
    }
}

-(void)oscillateBackgroundEffect{
    [BackGround pauseAnimations];
    
    //            [BackGround addIvOscillate];
    [self.view addSubview:[BackGround getIvOscillate1]];
    [self.view addSubview:[BackGround getIvOscillate2]];
    [self.view sendSubviewToBack:[BackGround getIvOscillate1]];
    [self.view sendSubviewToBack:[BackGround getIvOscillate2]];
    
    [self.view sendSubviewToBack:[BackGround getImageView1]];
    [self.view sendSubviewToBack:[BackGround getImageView2]];
    [BackGround oscillateEffect:10];
}

-(void)gameOverBackGround{
    [BackGround pauseAnimations];
    
    //            [BackGround addIvOscillate];
    [self.view addSubview:[BackGround getIvOscillate1]];
    [self.view addSubview:[BackGround getIvOscillate2]];
    [self.view sendSubviewToBack:[BackGround getIvOscillate1]];
    [self.view sendSubviewToBack:[BackGround getIvOscillate2]];
    
    [self.view sendSubviewToBack:[BackGround getImageView1]];
    [self.view sendSubviewToBack:[BackGround getImageView2]];
    //    [BackGround oscillateEffect:10];
    [BackGround gameOver];//振動してから低スピードで進行
}

-(void)yieldBeamFromMyMachine{
    if([MyMachine yieldBeam:0 init_x:[MyMachine getX] init_y:[MyMachine getY]]){
        //ビームはFIFOなので最初のもののみを表示
        //        [self.view addSubview:[[MyMachine getBeam:0] getImageView]];
        //            NSLog(@"after yield beam");
//        for(int i = 0; i < [MyMachine getNumOfBeam];i++){//ordinaryBeam
//            //                NSLog(@"%d", i);
//            for(int j = 0 ;j < [MyMachine getNumOfAnother];j++){
//                [self.view addSubview:[[MyMachine getBeam:i*(j+i???)] getImageView]];//最初の１〜３個
//            }
//        }
//        
//        if([MyMachine getSpWeapon] >= 0){//if not specialWeapon :return -1
//            int numOfOrdinaryBullet = [MyMachine getNumOfBeam];
//            for(int i = numOfOrdinaryBullet ;i < numOfOrdinaryBullet + 2;i++){//それより前二つの弾丸はspecial弾
//                [self.view addSubview:[[MyMachine getBeam:i] getImageView]];
//            }
//        }
        
        //beamの数はgetNumOfBeam*(getNumOfAnother+1)+[numOfSpWeapon]<-最後の項はメソッドがない
        int beamCnt = [MyMachine getNumOfBeam] * ([MyMachine getNumOfAnother]+1) + (([MyMachine getSpWeapon]>=0)?2:0);
//        NSLog(@"beamCnt=%d", beamCnt);
        for(int i = 0; i < beamCnt;i++){
            [self.view addSubview:[[MyMachine getBeam:i] getImageView]];//最初の１〜３個
        }
        
    }
}


-(void)setBackGroundInit{
    NSLog(@"set BackGround init at GameView");
    
    
    
    
    if(BackGround != nil &&
       ![BackGround isEqual:[NSNull null]]){
        
        [BackGround exitAnimations];//前のアニメーションの停止
    }
    
    //test:worldtype
    //    BackGround = [[BackGroundClass2 alloc]init:WorldTypeUniverse1
    BackGround = [[BackGroundClass2 alloc] init:worldType
                                          width:self.view.bounds.size.width
                                         height:self.view.bounds.size.height
                                           secs:20.0f];//homebuttonを押されて途中再開したときのために到達時間は変数にしておく
    [self.view addSubview:[BackGround getImageView1]];
    [self.view addSubview:[BackGround getImageView2]];
    [self.view sendSubviewToBack:[BackGround getImageView1]];
    [self.view sendSubviewToBack:[BackGround getImageView2]];
    [self startAnimateBackGround];
    
    
    //    [self.view addSubview:[BackGround getImageView1]];
    //    [self.view addSubview:[BackGround getImageView2]];
    //    [self.view bringSubviewToFront:[BackGround getImageView1]];
    //    [self.view bringSubviewToFront:[BackGround getImageView2]];
    //    [self.view sendSubviewToBack:[BackGround getImageView1]];
    //    [self.view sendSubviewToBack:[BackGround getImageView2]];
    NSLog(@"background bring front");
    //    [self startAnimateBackGround];
    
    //背景の下地
    UIGraphicsBeginImageContext(self.view.frame.size);
    
    
    
    //    if(viewBackBack == nil){
    //        viewBackBack =
    //        [[UIImageView alloc]initWithFrame:self.view.bounds];
    //    }
    
    switch (worldType) {
        case WorldTypeForest:{
            //            [self.view setBackgroundColor:[UIColor greenColor]];
            //            viewBackBack.image = [UIImage imageNamed:@"backback_forest2.png"];
            [[UIImage imageNamed:@"backback_forest2.png"] drawInRect:self.view.bounds];
            break;
        }
        case WorldTypeUniverse1:{
            //            [self.view setBackgroundColor:[UIColor blackColor]];
            //            viewBackBack.image = [UIImage imageNamed:@"bacback_univ.png"];
            [[UIImage imageNamed:@"backback_univ.png"] drawInRect:self.view.bounds];
            break;
        }
        case WorldTypeUniverse2:{
            //            [self.view setBackgroundColor:[UIColor blackColor]];
            //            viewBackBack.image = [UIImage imageNamed:@"backback_univ.png"];
            [[UIImage imageNamed:@"backback_univ.png"] drawInRect:self.view.bounds];
            break;
        }
        case WorldTypeNangoku:{
            //            [self.view setBackgroundColor:[UIColor blueColor]];
            //            viewBackBack.image = [UIImage imageNamed:@"backback_nangoku.png"];
            [[UIImage imageNamed:@"backback_nangoku.png"] drawInRect:self.view.bounds];
            break;
        }
        case WorldTypeDesert:{
            //            [self.view setBackgroundColor:[UIColor yellowColor]];
            //            viewBackBack.image = [UIImage imageNamed:@"backback_desert.png"];
            [[UIImage imageNamed:@"backback_desert.png"] drawInRect:self.view.bounds];
            break;
        }
        case WorldTypeSnow:{
            //            [self.view setBackgroundColor:[UIColor whiteColor]];
            //            viewBackBack.image = [UIImage imageNamed:@"backback_snow.png"];
            [[UIImage imageNamed:@"backback_snow.png"] drawInRect:self.view.bounds];
            break;
        }
        default:
            break;
    }
    //    [self.view addSubview:viewBackBack];
    //    [self.view sendSubviewToBack:viewBackBack];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
}

-(void)startAnimateBackGround{
    NSLog(@"startAnimateBackGround at GameView");
    [BackGround startAnimation];//3sec-Round
}


- (void)friendPickerViewController:(ASFriendPickerViewController *)controller
                  didPickedFriends:(NSArray *)friends
{
    NSLog(@"friendPickerViewController");
    //    pickedFriends = friends;
    
    [controller dismissViewControllerAnimated:YES
                                   completion:^{
//                                       [self myInviteFriends:friends];
                                   }];
}

/*
 *used for enemy's motion-animation time
 *sigmoid = (max-min)*(1+1/exp)/(1+exp(x/150-1))+min
 */
-(float)getSigmoid:(float)_value{
    float max = 5.0f;
    float min = 0.5f;
    float a = 30.0f;//熱関数:a秒で定常状態の３分の1
    float val = (max-min)*(1.0f+exp(-1))/(1.0f+exp(_value/a-1.0f))+min;
    //    NSLog(@"sigmoid = %f", val);
    return val;
    //    return 1.665f/(1 + exp(_value/150.0f-1))+0.5f;
}

-(int)getSumFromArray:(NSArray *)_arr{
    if([_arr count] == 0){
        return 0;
    }else{
        int _value = 0;
        for(int i = 0 ; i < [_arr count];i++){
            _value += [[_arr objectAtIndex:i] intValue];
        }
        return _value;
    }
}

//生存している敵の個数を返す
-(int)getCountAliveEnemy{
    int _value = 0;
    for(int i = 0 ;i < [EnemyArray count]; i++){
        if([[EnemyArray objectAtIndex:i] getIsAlive]){
            _value++;
        }
    }
    return _value;
}

@end