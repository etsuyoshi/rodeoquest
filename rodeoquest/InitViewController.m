//
//  ViewController.m
//  ShootingTest
//
//  Created by 遠藤 豪 on 13/09/25.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//
//  待機画面の作成：http://ameblo.jp/mal000n/entry-11477524801.html
//　同期通信の場合はサブスレッド立てるhttp://www.yoheim.net/blog.php?q=20130206


//#define NoConnectTEST
//#define TestView

#ifdef TestView//PaymentTestでテストする場合、TestViewをオンにしたまま以下をコメントイン(コメントアウトを外す)
//    #define PaymentTest//TestViewの場合にのみPaymentテスト有効
//    #import "PaymentTestViewController.h"
#endif

#ifdef TestView
    #import "TestViewController.h"
#endif


//DB側でログイン回数をカウントする(カラム追加、値取得して１を足す)
//#define FONTTEST YES
#ifdef FONTTEST
    #import "FontTestViewController.h"
#endif

#import "InitViewController.h"
#import "MenuViewController.h"
#import "DBAccessClass.h"
#import "AttrClass.h"

@interface InitViewController ()

@end

@implementation InitViewController

UIView *_loadingView;
UIActivityIndicatorView *_indicator;



//ステータスバー非表示の一環
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //gamecenterログイン
    __weak GKLocalPlayer *localPlayer;
    localPlayer = [GKLocalPlayer localPlayer];
    [localPlayer setAuthenticateHandler:(^(UIViewController* viewcontroller, NSError *error) {
        NSLog(@"%@", localPlayer);
        //[localPlayer authenticateWithCompletionHandler:^(NSError *error) { OLD CODE!
        if (localPlayer.isAuthenticated)
        {
            //do some stuff
            NSLog(@" autherize complete" );
        }
        else {
            NSLog(@"authenticating-error = %@", error);
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"iPhoneのGameCenter登録が確認できませんでした。"
                                      message:@"他のプレーヤーと競うためには「設定」の中の「Game Center」の設定を確認して下さい。"
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
            
        }
    })];

    
    // ステータスバーを非表示にする:plistでも可？
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
    

    
    //フォントテストー＞本番時削除
#ifdef FONTTEST
    FontTestViewController *ftvc = [[FontTestViewController alloc]init];
    [self presentViewController:ftvc animated:YES completion:nil];
#endif
    
	// Do any additional setup after loading the view, typically from a nib.
    
//    CGRect rect_frame = [[UIScreen mainScreen] bounds];
//    CGRect rect_main = CGRectMake(-100, -30, 580, 480);
    CGRect rect_main = CGRectMake(-110, -10, 544, 400);
    UIImageView *iv_frame = [[UIImageView alloc]initWithFrame:rect_main];
    iv_frame.image = [UIImage imageNamed:@"chara01.png"];
    iv_frame.center = CGPointMake(self.view.center.x,
                                  self.view.center.y * 2);
    [self.view addSubview:iv_frame];
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         iv_frame.center = self.view.center;
                     }
                     completion:^(BOOL finished){
                         //nothing
                     }];
    
    
#ifndef NoConnectTEST
    // インジケーター表示
    [self showActivityIndicator];
    //サーバー通信
    [self performSelector:@selector(sendRequestToServer) withObject:nil afterDelay:0.1];
#elif defined TestView
    
    #ifdef PaymentTest
        PaymentTestViewController *ptvc = [[PaymentTestViewController alloc]init];
        [self presentViewController: ptvc animated:YES completion: nil];
        return;
    #endif
    
    
    TestViewController *tvc = [[TestViewController alloc]init];
    [self presentViewController: tvc animated:YES completion: nil];
#else
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    //    NSLog(@"%@", vc);
    [self presentViewController: vc animated:YES completion: nil];
#endif
}


//サーバーに登録するためにhttp通信
-(void)sendRequestToServer{
    //ユーザー認証
    DBAccessClass *dbac = [[DBAccessClass alloc]init];
    //端末からidを取得してdbと照合(なければdbと端末自体に新規作成)
    //    [dbac setIdToDB:[dbac getIdFromDevice]];
    AttrClass *attr = [[AttrClass alloc]init];
    NSString *_id = [attr getIdFromDevice];
    if([dbac setIdToDB:_id]){//dbに登録(既存idなら何もしないで)YES、登録に失敗すればNO
        NSLog(@"データベース登録or承認完了");
        
        
        //last login
        //最終ゲーム実行時間:http://www.objectivec-iphone.com/foundation/NSDate/components.html
        NSString *strLogin = [NSString stringWithFormat:@""];
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
        strLogin = [NSString stringWithFormat:@"%@%@%@%@", strLogin, year, month, day];
        
        // 時・分・秒を取得
        flags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        comps = [calendar components:flags fromDate:now];
        NSString *hour = [NSString stringWithFormat:@"%02d", comps.hour];
        NSString *minute = [NSString stringWithFormat:@"%02d", comps.minute];
        NSString *second = [NSString stringWithFormat:@"%02d", comps.second];
        NSLog(@"%@時 %@分 %@秒", hour, minute, second);
        strLogin = [NSString stringWithFormat:@"%@%@%@%@", strLogin, hour, minute, second];
        
        // 曜日
        comps = [calendar components:NSWeekdayCalendarUnit fromDate:now];
        NSArray *arrayWeekName = [[NSArray alloc]initWithObjects:
                                  @"sun", @"mon", @"tue", @"wed", @"thu", @"fri", @"sat", nil];
        NSString *weekday = arrayWeekName[comps.weekday - 1];//comps.weekday; // 曜日(1が日曜日 7が土曜日)
        NSLog(@"曜日: %@", weekday);
        strLogin = [NSString stringWithFormat:@"%@%@", strLogin, weekday];
        [attr setValueToDevice:@"lastlogin" strValue:strLogin];//最後にloginを実施した日付をデバイスへ
        [dbac updateValueToDB:_id column:@"lastlogin" newVal:strLogin];//同様にDBへ
        
        
        //ログイン回数をupdate
        int login = [[dbac getValueFromDB:_id column:@"login"] intValue];
        login ++;
//        [dbac updateValueToDB:_id column:@"login" value:[NSString stringWithFormat:@"%d", login ]];
        [dbac updateValueToDB:_id column:@"login" newVal:[NSString stringWithFormat:@"%d", login]];
        NSLog(@"login = %@回目", [dbac getValueFromDB:_id column:@"login"]);
        [attr setValueToDevice:@"login" strValue:[NSString stringWithFormat:@"%d", login]];
        
        // インジケーター非表示
        [self hideActivityIndicator];
        
        //StoryboardでのID：ItemSelectViewControllerはMenuViewControllerを示す
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
//        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
//        [self presentViewController: vc animated:NO completion: nil];
        //上記ブロックと同値
        MenuViewController *menuView = [[MenuViewController alloc] init];
        [self presentViewController: menuView animated:NO completion: nil];//if "animated"=YES then background perform incorrect
        
        
    }else{
        NSLog(@"データベース登録or承認失敗");
        // インジケーター非表示
        [self hideActivityIndicator];
        
    }
}


-(void)viewDidAppear:(BOOL)animated{
    //viewDidLoadの次に呼び出される
    
    //画面遷移はid登録が完了後に実行する
    /*
    CGRect rect_frame = [[UIScreen mainScreen] bounds];
    UIButton *bt = [self createButtonWithTitle:@"start"
                                           tag:0
                                         frame:CGRectMake(rect_frame.size.width/2 - 50,
                                                          rect_frame.size.height/2 + 130,
                                                          100,
                                                          40)];
    
    
    [bt addTarget:self action:@selector(pushed_button:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
     */
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pushed_button:(id)sender{
    UIStoryboard *storyboard = nil;

    switch([sender tag]){
        case 0:
            storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ItemSelectViewController"];
            //    NSLog(@"%@", vc);
            [self presentViewController: vc animated:YES completion: nil];
            break;
//        case 1:
//            NSLog(@"bb@");
//            break;

    }
}
-(UIButton*)createButtonWithTitle:(NSString*)title tag:(int)tag frame:(CGRect)frame
{
    //画像を表示させる場合：http://blog.syuhari.jp/archives/1407
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = frame;
    button.tag   = tag;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pushed_button:)
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}


/*
 * インジケーター表示
 */
- (void)showActivityIndicator
{
    // Activity Indicator 表示
    _loadingView                 = [[UIView alloc] initWithFrame:self.navigationController.view.bounds];
    _loadingView.backgroundColor = [UIColor blackColor];
    _loadingView.alpha           = 0.5f;
    _indicator                   = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_indicator setCenter:CGPointMake(_loadingView.bounds.size.width/2, _loadingView.bounds.size.height/2)];
    [_loadingView addSubview:_indicator];
    [self.navigationController.view addSubview:_loadingView];
    [_indicator startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

/*
 * インジケーター非表示
 */
- (void)hideActivityIndicator
{
    // Activity Indicator 非表示
    [_indicator stopAnimating];
    [_loadingView removeFromSuperview];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
