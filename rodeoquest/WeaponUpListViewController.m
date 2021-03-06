//
//  WeaponUpListViewController.m
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/05.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "WeaponUpListViewController.h"

@interface WeaponUpListViewController ()

@end

@implementation WeaponUpListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        arrIv = [NSMutableArray arrayWithObjects:
                 @"weapon_bomb.png",
                 @"weapon_bomb.png",//krkr
                 @"weapon_diffuse.png",
                 @"weapon_diffuse.png",//krkr
                 @"weapon_laser.png",
                 @"weapon_laser.png",//krkr
                 nil];
        arrIv2 = [NSMutableArray arrayWithObjects:
                  @"",
                  @"krkr_many.png",
                  @"",
                  @"krkr_many.png",
                  @"",
                  @"krkr_many.png",
                  nil];
        arrIvType = [NSMutableArray arrayWithObjects:
                     @0,
                     @3,
                     @0,
                     @3,
                     @0,
                     @3,
                     nil];
        
        arrStrTvOriginal = [NSMutableArray arrayWithObjects:
                 @"次回以降全てのゲームにおいて、爆弾投下の持続時間を0.5秒上乗せする。",//1=10coin
                 @"1回のゲームでのみ、爆弾投下の持続時間を現状の２倍に長持ちさせる。",//1=9coin
                 @"次回以降全てのゲームにおいて、通常弾の攻撃力強化持続時間を0.5秒上乗せする。",//1=10coin
                 @"1回のゲームでのみ、通常弾の攻撃力持続時間を現状の２倍に長持ちさせる。",//1=9coin
                 @"次回以降全てのゲームにおいて、レーザー発射持続時間を0.5秒上乗せする。",//1=10coin
                 @"1回のゲームでのみ、レーザー発射持続時間を現状の２倍に長持ちさせる。",//1=9coin
                 
//                 @"レーザーを発射する時間を1.5倍にします。\n100枚のコインが必要です。",
//                 @"レーザーを発射する時間を２倍にします。\n150枚のコインが必要です。",
//                 @"爆弾が投下される時間を長くします。\n50枚のコインが必要です。",
//                 @"攻撃力が強化される時間を長くします。\n100枚のコインが必要です。",
                 nil];
        
        arrCost = [NSMutableArray arrayWithObjects:
                   @"50",
                   @"100",
                   @"50",
                   @"100",
                   @"100",
                   @"150",
                   nil];
        arrTitle = [NSMutableArray arrayWithObjects:
                    @"buy",
                    @"buy",
                    @"buy",
                    @"buy",
                    @"buy",
                    @"buy",
                    nil];
                    
        
        itemList = [NSMutableArray arrayWithObjects:
                    @"itemlistWeapon00",//bombにするとitemと被ってしまう
                    @"itemlistWeapon01",
                    @"itemlistWeapon10",
                    @"itemlistWeapon11",
                    @"itemlistWeapon20",
                    @"itemlistWeapon21",
                    nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    nameCurrency = @"ゼニー";
    idCurrency = @"gold";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end