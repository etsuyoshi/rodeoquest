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


#define GPS_MEASURING_TIME 3.0
#define GPS_DESIRED_ACCURACY 100.0
#define GPS_UNADOPTABLE_ACCURACY 2000.0



#import "InitViewController.h"

@interface InitViewController ()

@end

@implementation InitViewController

UIView *_loadingView;
UIActivityIndicatorView *_indicator;


/*
 init
 viewDidLoad
 viewWillAppear:->startAccessDB
 viewDidAppear:animation
 
 
 startAccessDB
    ->sendRequestToServer
    ->[after 3sec]stopAccess
        ->isSuccessAccess:...(transitToMenu or initSpeculateLocation)
            ->[SPECULATE LOCATION PROCESS]
        -> ! isSuccessAccess:dialog->re:sendReuqestToServer?
 */


//ステータスバー非表示の一環
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //DBにアクセス出来たかどうか：sendRequestToServer内で認証or新規登録出来ればYESに設定
    isSuccessAccess = false;
    
    attr = [[AttrClass alloc]init];
    
    
    //powersportをゼロに設定：後でxxxモードに移行する時に選択制でyesにする
    [attr setValueToDevice:@"powerspot" strValue:@"0"];
    
    //gamecenterログイン
    __weak GKLocalPlayer *localPlayer;
    localPlayer = [GKLocalPlayer localPlayer];
    [localPlayer setAuthenticateHandler:(^(UIViewController* viewcontroller, NSError *error) {
        NSLog(@"%@", localPlayer);
        //[localPlayer authenticateWithCompletionHandler:^(NSError *error) { OLD CODE!
        if (localPlayer.isAuthenticated)
        {
            //do some stuff
            NSLog(@"autherize complete" );
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
    
}


//サーバーに登録するためにhttp通信
-(void)sendRequestToServer{
    //ユーザー認証
    DBAccessClass *dbac = [[DBAccessClass alloc]init];
    //端末からidを取得してdbと照合(なければdbと端末自体に新規作成)
    //    [dbac setIdToDB:[dbac getIdFromDevice]];
    
    NSString *_id = [attr getIdFromDevice];
    if([dbac setIdToDB:_id]){//dbに登録(既存idなら何もしないで)YES、登録に失敗すればNO
        NSLog(@"データベース登録or承認完了");
        
        isSuccessAccess = true;
        
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
//        [self hideActivityIndicator];
        
        
        //StoryboardでのID：ItemSelectViewControllerはMenuViewControllerを示す
        //        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        //        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
        //        [self presentViewController: vc animated:NO completion: nil];
        //上記ブロックと同値
//        MenuViewController *menuView = [[MenuViewController alloc] init];
//        [self presentViewController: menuView animated:NO completion: nil];//if "animated"=YES then background perform incorrect
        
        
    }else{
        NSLog(@"データベース登録or承認失敗");
//        // インジケーター非表示
//        [self hideActivityIndicator];
        
    }
}

//dbアクセスを停止
-(void)stopAccess{
    //インジケーター非表示
    [self hideActivityIndicator];
    
    //取得成功していれば何も表示しない
    //取得失敗ならdialogで再度取得するか確認
    //原因：ネット不接続(恐らく。それ以外の可能性は未調査)
    if(isSuccessAccess){
//        [self transitToMenu];
        
        //speculate location test
        [self initSpeculateLocation];
    }else{
        UIView *alertView =nil;
        alertView =
        [CreateComponentClass
         createAlertView2:self.view.bounds
         dialogRect:CGRectMake(0, 0, 290, 200)
         title:@"インターネットへの接続が不安定です。"
         message:@"このまま続けますか？\n続けた場合には記録の保存ができないことがあります。\n接続なしで続ける場合は「はい」を選択して下さい。"
         onYes:^{
             [alertView removeFromSuperview];
             
             //位置情報の取得はせずにメニューへ移行
             [self transitToMenu];
         }
         onNo:^{
             [alertView removeFromSuperview];
             //再接続開始
             [self startAccessDB];
             
         }];
        
        [self.view addSubview:alertView];
    }
    
}

//menuViewに遷移
-(void)transitToMenu{
    NSLog(@"transitToMenu");
    
    //MenuViewControllerを呼び出す
    MenuViewController *menuView = [[MenuViewController alloc] init];
    [self presentViewController: menuView animated:NO completion: nil];//if "animated"=YES then background perform incorrect
    
}

/*
 *インジケータ表示
 *DB登録or新規承認を開始
 *接続成功の可否を問わず、3秒後にstopAccessを実行
 *参考：stopAccessでは接続成功ならmenuViewCon遷移、失敗なら再度接続開始するかダイアログで確認する。
 */
-(void)startAccessDB{
    [self sendRequestToServer];
    
    // インジケーター表示
    [self showActivityIndicator];
    
    //DBアクセス成功の可否にかかわらずMenuViewConに遷移する
    [self performSelector:@selector(stopAccess)
               withObject:nil
               afterDelay:3.0f];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    
#ifndef NoConnectTEST
    //サーバー通信開始
//    [self performSelector:@selector(sendRequestToServer) withObject:nil afterDelay:0.1];
    
    //インジケータ接続とDB接続開始(＆接続成功の可否を問わず３秒後にstopAccessを実行)
    [self startAccessDB];
    
#elif defined TestView
    
    #ifdef PaymentTest//
        PaymentTestViewController *ptvc = [[PaymentTestViewController alloc]init];
        [self presentViewController: ptvc animated:YES completion: nil];
        return;
    #endif
    
    
    TestViewController *tvc = [[TestViewController alloc]init];
    [self presentViewController: tvc animated:YES completion: nil];
#else
    
    
    //no-connection-modeならばサーバー通信をせずにすぐにmenuviewControllerに遷移
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
//    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
//    //    NSLog(@"%@", vc);
//    [self presentViewController: vc animated:YES completion: nil];
    [self transitToMenu];
#endif
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
    
    //    CGRect rect_frame = [[UIScreen mainScreen] bounds];
    //    CGRect rect_main = CGRectMake(-100, -30, 580, 480);
    CGRect rect_main = CGRectMake(-110, -10, 544, 400);
    UIImageView *iv_frame = [[UIImageView alloc]initWithFrame:rect_main];
    iv_frame.image = [UIImage imageNamed:@"chara01.png"];
    iv_frame.center = CGPointMake(self.view.center.x,
                                  self.view.center.y * 2);
    [self.view addSubview:iv_frame];
    
    [UIView animateWithDuration:1.0f
                     animations:^{
                         iv_frame.center = self.view.center;
                     }
                     completion:^(BOOL finished){
                         //nothing
                     }];
    
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



//以下、位置特定メソッド群

/*
 *測定環境初期化
 */
-(void)initSpeculateLocation{
    NSLog(@"initSpeculateLocation");
    
    //GPS測定開始処理：View表示時に測定開始
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    
    bestEffortAtLocation = nil;
    locationManager.desiredAccuracy = GPS_DESIRED_ACCURACY;
    
    //GPS測定開始
    [locationManager startUpdatingLocation];
    //GPS_MEASURING_TIME秒後に測定終了(stopUpdatingLocation:)メソッドを実行
    [self performSelector:@selector(stopUpdatingLocation:)
               withObject:nil
               afterDelay:GPS_MEASURING_TIME];
    
    [self showActivityIndicator];
}


/*
 *GPS情報処理。OSからGPS情報取得時に呼び出される
 */
-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation{
    
    //newLocation.descriptionで位置情報の全ての文字列で取得できる
    NSLog(@"newLoc:%@", newLocation.description);
    
    //不要なデータは無視
    if(-[newLocation.timestamp timeIntervalSinceNow] > 5.0)return;
    
    if(newLocation.horizontalAccuracy > GPS_UNADOPTABLE_ACCURACY)return;
    
    //一番精度の高い情報を記憶
    if(bestEffortAtLocation == nil ||
       newLocation.horizontalAccuracy < bestEffortAtLocation.horizontalAccuracy){
        
        bestEffortAtLocation = newLocation;
    }
    
}

/*
 *GPS測定終了処理
 */
-(void)stopUpdatingLocation:(NSObject *)args{
    [locationManager stopUpdatingLocation];
    [self hideActivityIndicator];
    
    if(bestEffortAtLocation == nil){
        NSLog(@"GPS取得失敗");
//        statusLabel.text = @"GPS取得失敗";
        //失敗しても続ける
        UIView *failedLocate = nil;
        failedLocate = [CreateComponentClass
         createAlertView2:self.view.bounds
         dialogRect:CGRectMake(10, 100, 290, 200)
         title:@"GPS情報を取得できませんでした。"
         message:@"GPS機能をオンにすると日本全国の特定の場所でドラゴンのパワーが強化されます。\nGPS情報を再取得しますか？"
         onYes:^{
             [failedLocate removeFromSuperview];
             
             //GPS情報の再取得
             [self initSpeculateLocation];
             return ;//先に行かずにここで返す
         }
         onNo:^{
             //do nothing：そのまま続ける(NSUserDefaultにGPS不使用の旨を書いておく必要あるかも。)
             [failedLocate removeFromSuperview];
         }];
        
        [self.view addSubview:failedLocate];
        
//        return;
    }
    
    float longitude = bestEffortAtLocation.coordinate.longitude;//経度
    float latitude = bestEffortAtLocation.coordinate.latitude;//緯度
    
    NSLog(@"latitude=%f, longitude=%f",
          latitude,longitude);
    
    
    //test:label
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,
                                                              self.view.bounds.size.height)];
    label.center =
    CGPointMake(self.view.bounds.size.width/2,
                self.view.bounds.size.height-30);
    label.text = [NSString stringWithFormat:@"現在位置=(緯度%.3f,経度%.3f)",
                  latitude, longitude];
    label.textColor = [UIColor blackColor];
    [self.view addSubview:label];
    [self.view bringSubviewToFront:label];
    //test:label-finish
    
    //test:location
    //高千穂32.71169	131.307787
    //池袋35.729534	139.718055
//    bestEffortAtLocation = [[CLLocation alloc] initWithLatitude:35.82 longitude:139.71];
    
    //既存の位置情報との照合を開始する
    LocationDataClass *locationData = [[LocationDataClass alloc]init];
    NSLog(@"最も近い場所は%@で誤差は%fメートル",
          [locationData getNameNearestLocation:bestEffortAtLocation],
          [locationData getDistanceNearest:bestEffortAtLocation]);
    
    //最近接地が誤差の範囲内で取得できなかった場合
    if([locationData getNameNearestLocation:bestEffortAtLocation] == nil){
        NSLog(@"最近接地が誤差の範囲内で取得できませんでした");
        [attr setValueToDevice:@"powerspot" strValue:@"0"];//初期値なので特に上書きは不要
        
        //今後聞かない設定にする
        UIView *viewConfirmNoMode = nil;
        viewConfirmNoMode =
        [CreateComponentClass
         createAlertView2:self.view.bounds
         dialogRect:CGRectMake(10, 100, 290, 250)
         title:@"ドラゴンの回復スポットが近くにありません。"
         message:@"「はい」を押すと通常モードで開始します。「いいえ」を押すと再度GPS情報を取得します。"
         onYes:^{
             [viewConfirmNoMode removeFromSuperview];
             
             //nsuserDefaultsを設定する
             [attr setValueToDevice:@"powerspot" strValue:@"0"];
             [self transitToMenu];
             return;
         }
         onNo:^{
             
             [viewConfirmNoMode removeFromSuperview];
             
             [self initSpeculateLocation];
             return;
         }];
        
        [self.view addSubview:viewConfirmNoMode];
         
        
    }else{//最近接地が誤差の範囲内で取得できた場合
        if([locationData getDistanceNearest:bestEffortAtLocation] > 0){
            if([locationData getDistanceNearest:bestEffortAtLocation] < 500){
                
                //誤差が許容範囲内なら処理続行
                NSLog(@"誤差が許容範囲内なのでダイアログ表示");
                UIView *alertModeView = nil;
                alertModeView =
                [CreateComponentClass
                 createAlertView2:self.view.bounds
                 dialogRect:CGRectMake(10, 100, 315, 280)
                 title:@"回復ポイント周辺にいます。"
                 message:[NSString stringWithFormat:@"最近接地:%@\n距離:%.2fメートル\nドラゴン全力モードで開始しますか？",
                          [locationData getNameNearestLocation:bestEffortAtLocation],
                          [locationData getDistanceNearest:bestEffortAtLocation]]
                 onYes:^{
                     
                     [alertModeView removeFromSuperview];
                     
                     //xxxモードへの移行：常に全回復？弾丸強度1.5倍
                     [attr setValueToDevice:@"powersport" strValue:@"1"];
                     [self transitToMenu];
                     return;
                 }
                 onNo:^{
                     [alertModeView removeFromSuperview];
                     
                     //xxxモードの解除
                     [attr setValueToDevice:@"powerspot" strValue:@"0"];
                     [self transitToMenu];
                     return;
                 }];
                [self.view addSubview:alertModeView];
            }//if([locationData getDistanceNearest:bestEffortAtLocation] < 500){
            else{//距離が遠い時
                //case:外国、orどこかのランドマークから99999.9m以下だが500m以上離れている時
                //action:移動すればドラゴンが回復します、という指示を与える？
                [self transitToMenu];
                
            }
        }//if([locationData getDistanceNearest:bestEffortAtLocation] > 0){
        else{//距離がマイナス１を返した時：LocationDataClass内で99999.9m以下の距離でランドマークを取得できなかった場合
            //case:外国、orどのランドマークからももの凄く遠いところ
            //そのまま続行
            [self transitToMenu];
            
        }
    }
}

@end
