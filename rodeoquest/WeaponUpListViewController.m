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
        
        /*
         武器が強化される時間を長くする
         効果は一回きりにするのか、永続させるのか。
         
         【永続】
         メリット
         購買意欲：割安感による商品魅力度増大
         
         デメリット
         開発リソース大
         機会損失＝一度購入されれば購入機会はなくなる：コインの消費機会の低下
         
         【使い切り】
         メリット
         開発リソース小
         機会獲得＝コインの消費機会の生成
         
         デメリット
         購買意欲低下：商品魅力度低下
         
         結論：永続化のメリットは使い切りのデメリットの裏返し＝トレードオフ
         従って、永続化にしろ、使い切りにしろ、それによって得られる効果(結果として得られるコインや得点)が商品価格より高ければ魅力があるということ
         
         
         

         */
        arrIv = [NSMutableArray arrayWithObjects:
                 @"weapon_laser.png",
                 @"weapon_laser.png",//krkr
                 @"weapon_diffuse.png",
                 @"weapon_diffuse.png",//krkr
                 @"weapon_bomb.png",
                 @"weapon_bomb.png",//krkr
                 nil];
        
        
        /*
         *defense example
         
         @"次回以降全てのゲームにおいて、シールドアイテム獲得後の耐久回数を現状に+1上乗せする。\n15枚のコインが必要です。",//1=10coin
         @"次回のゲームにのみ、シールドアイテム獲得後のダメージ耐久回数を現状の２倍に長持ちさせる。\n18枚のコインが必要です。",//1=9coin
         @"次回以降全てのゲームにおいて、バリアアイテム獲得後の耐久時間を現状に0.5秒上乗せする。\n24枚のコインが必要です。",//1=8coin
         @"次回のゲームにのみ、バリアアイテム獲得後の耐久時間を現状の２倍に長持ちさせる。\n28枚のコインが必要です。",//1=7coin
         nil];
         */
        arrTv = [NSMutableArray arrayWithObjects:
                 
                 @"次回以降全てのゲームにおいて、レーザー発射持続時間を0.5秒上乗せする。\n15枚のコインが必要です。",//1=10coin
                 @"次回のゲームにのみ、レーザー発射持続時間を現状の２倍に長持ちさせる。\n18枚のコインが必要です。",//1=9coin
                 @"次回以降全てのゲームにおいて、爆弾投下の持続時間を0.5秒上乗せする。\n15枚のコインが必要です。",//1=10coin
                 @"次回のゲームにのみ、爆弾投下の持続時間を現状の２倍に長持ちさせる。\n18枚のコインが必要です。",//1=9coin
                 @"次回以降全てのゲームにおいて、通常弾の攻撃力強化持続時間を0.5秒上乗せする。\n15枚のコインが必要です。",//1=10coin
                 @"次回のゲームにのみ、通常弾の攻撃力持続時間を現状の２倍に長持ちさせる。\n18枚のコインが必要です。",//1=9coin
                 
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
        
        itemList = [NSMutableArray arrayWithObjects:
                    @"itemlistWeaponUp0",
                    @"itemlistWeaponUp1",
                    @"itemlistWeaponUp2",
                    @"itemlistWeaponUp3",
                    @"itemlistWeaponUp0",
                    @"itemlistWeaponUp1",
                    @"itemlistWeaponUp2",
                    @"itemlistWeaponUp3",
                    nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end