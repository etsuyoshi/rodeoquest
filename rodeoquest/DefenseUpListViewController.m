//
//  DefenseUpListViewController.m
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/06.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "DefenseUpListViewController.h"

@interface DefenseUpListViewController ()

@end

@implementation DefenseUpListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        arrIv = [NSMutableArray arrayWithObjects:
                 @"defense_shield.png",
                 @"defense_shield.png",
                 @"defense_barrier.png",
                 @"defense_barrier.png",
                 nil];
        arrTv = [NSMutableArray arrayWithObjects:
                 @"次回以降全てのゲームにおいて、シールドアイテム獲得後の耐久回数を現状に+1上乗せする。\n15枚のコインが必要です。",//1=10coin
                 @"次回のゲームにのみ、シールドアイテム獲得後のダメージ耐久回数を現状の２倍に長持ちさせる。\n18枚のコインが必要です。",//1=9coin
                 @"次回以降全てのゲームにおいて、バリアアイテム獲得後の耐久時間を現状に0.5秒上乗せする。\n24枚のコインが必要です。",//1=8coin
                 @"次回のゲームにのみ、バリアアイテム獲得後の耐久時間を現状の２倍に長持ちさせる。\n28枚のコインが必要です。",//1=7coin
                 nil];
        
        arrCost = [NSMutableArray arrayWithObjects:
                   @"15",
                   @"18",
                   @"24",
                   @"28",
                   nil];
        
        itemList = [NSMutableArray arrayWithObjects:
                    @"itemlistShield0",
                    @"itemlistShield1",
                    @"itemlistBarrier0",
                    @"itemlistBarrier1",
                    nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    nameCurrency = @"ゼニー";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

