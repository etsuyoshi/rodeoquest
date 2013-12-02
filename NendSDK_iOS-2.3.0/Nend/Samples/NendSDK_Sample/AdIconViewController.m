//
//  AdIconViewController.m
//  NendSDK_Sample
//
//  Created by ADN on 2013/07/19.
//  Copyright (c) 2013年 F@N Communications. All rights reserved.
//

#import "AdIconViewController.h"

@interface AdIconViewController ()

@end

@implementation AdIconViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    
    //IconLoaderの生成
    nadIconLoader = [[NADIconLoader alloc] init];
    
    //NADIconViewを保持するArrayの生成
    nadIconViewArray = [[NSMutableArray alloc] init];
    
    //アイコン個数を設定
    int iconCount = 4;
    
    //画面下部に均等間隔で表示する場合
    for (int i = 0 ; i < iconCount ; i++) {
        //IconViewの生成
        NADIconView* iconView = [[NADIconView alloc] init];
        [iconView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin];
        
        //テキストの表示or非表示(任意)
        [iconView setTextHidden:NO];
        
        //テキスト色の設定(任意)
        [iconView setTextColor:[UIColor whiteColor]];
        
        //位置の設定
        [iconView setCenter:CGPointMake((self.view.frame.size.width * (i+1) /iconCount) -(self.view.frame.size.width /iconCount /2), self.view.frame.size.height - (NAD_ICONVIEW_SIZE_75x75.height /2))];
        
        //画面上へ追加
        [self.view addSubview:iconView];
        
        //チェック用にタグを設定
        iconView.tag = i;
        
        //loaderへ追加
        [nadIconLoader addIconView:iconView];
        
        //Viewを保持
        [nadIconViewArray addObject:iconView];
    }
    //loaderへの設定
    [nadIconLoader setNendID:@"2349edefe7c2742dfb9f434de23bc3c7ca55ad22" spotID:@"101281"];
    [nadIconLoader setDelegate:self];
    //load開始
    [nadIconLoader load];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    //loaderのdelegateにnilを設定して解放します。
    nadIconLoader.delegate = nil;
    nadIconLoader = nil;
}

#pragma mark - NADIconLoaderDelegate
// 広告の受信に成功し表示できた場合に１度通知される任意メソッドです。
-(void)nadIconLoaderDidFinishLoad:(NADIconLoader *)iconLoader{
    NSLog(@"NADIconViewDelegate nadIconLoaderDidFinishLoad");
}

// 以下は広告受信成功ごとに通知される任意メソッドです。
-(void)nadIconLoaderDidReceiveAd:(NADIconLoader *)iconLoader nadIconView:(NADIconView *)nadIconView{
    NSLog(@"NADIconViewDelegate nadIconLoaderDidReceiveAd, nadIconView.tag = %d", nadIconView.tag);
}

// 以下は広告受信失敗ごとに通知される任意メソッドです。
-(void)nadIconLoaderDidFailToReceiveAd:(NADIconLoader *)iconLoader nadIconView:(NADIconView *)nadIconView{
    if (nadIconView) {
        NSLog(@"NADIconViewDelegate nadIconLoaderDidFailToReceiveAd, nadIconView.tag = %d", nadIconView.tag);
    }
    else{
        NSLog(@"NADIconViewDelegate nadIconLoaderDidFailToReceiveAd");
    }
    
    // エラー発生時の情報をログに出力します
    NSError* nadError = iconLoader.error;
    // エラーコード
    NSLog(@"code = %ld", (long)nadError.code);
    // エラーメッセージ
    NSLog(@"message = %@", nadError.domain);

}

// 以下はバナー広告がクリックされるごとに通知される任意メソッドです。
-(void)nadIconLoaderDidClickAd:(NADIconLoader *)iconLoader nadIconView:(NADIconView *)nadIconView{
    NSLog(@"NADIconViewDelegate nadIconLoaderDidClickAd, nadIconView.tag = %d", nadIconView.tag);
}

@end
