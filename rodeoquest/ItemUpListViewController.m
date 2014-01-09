//
//  ItemUpListViewController.m
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/05.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "ItemUpListViewController.h"

@interface ItemUpListViewController ()

@end

@implementation ItemUpListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        arrIv = [NSMutableArray arrayWithObjects:
                 @"tool_big.png",
                 @"tool_big.png",
                 @"tool_transparancy.png",
                 @"tool_transparancy.png",
                 @"tool_bomb.png",
                 @"tool_bomb.png",
                 @"tool_magnet.png",
                 @"tool_magnet.png",
                 @"tool_cookie.png",
                 @"tool_cookie.png",
                 nil];
        
        
        
//        @"次回以降全てのゲームにおいて、爆弾投下の持続時間を0.5秒上乗せする。\n15枚のコインが必要です。",//1=10coin
//        @"1回のゲームでのみ、爆弾投下の持続時間を現状の２倍に長持ちさせる。\n18枚のコインが必要です。",//1=9coin
        arrTv = [NSMutableArray arrayWithObjects:
                 @"次回以降全てのゲームにおいて、巨大化の持続時間を0.5秒延長します。\n100枚のコインが必要です。",
                 @"1回のゲームでのみ、巨大化の持続時間を2倍にします。\n100枚のコインが必要です。",
                 @"次回以降の全てのゲームにおいて、透明化の持続時間を0.5秒延長します。\n100枚のコインが必要です。",
                 @"1回のゲームにおいてのみ、透明化の持続時間を2倍にします。\n100枚のコインが必要です。",
                 @"次回以降の全てのゲームにおいて、周囲で爆発が発生する時間を0.5秒延長します。\n100枚のコインが必要です。",
                 @"1回のゲームにおいてのみ、周囲で爆発が発生する時間を2倍にします。\n100枚のコインが必要です。",
                 @"次回以降の全てのゲームにおいて、磁石が有効になっている時間を0.5秒延長します。\n100枚のコインが必要です。",
                 @"1回のゲームにおいてのみ、磁石が有効になっている時間を2倍にします。\n100枚のコインが必要です。",
                 @"次回以降の全てのゲームにおいて、分身の術が有効になっている時間を0.5秒延長します。\n100枚のコインが必要です。",
                 @"1回のゲームにおいてのみ、分身の術が有効になっている時間を2倍にします。\n100枚のコインが必要です。",
                 nil];
        
        arrCost = [NSMutableArray arrayWithObjects:
                   @"100",
                   @"100",
                   @"100",
                   @"100",
                   @"100",
                   @"100",
                   @"100",
                   @"100",
                   @"100",
                   @"100",
                   nil];
        arrTitle = [NSMutableArray arrayWithObjects:
                    @"buy",
                    @"buy",
                    @"buy",
                    @"buy",
                    @"buy",
                    @"buy",
                    @"buy",
                    @"buy",
                    @"buy",
                    @"buy",
                    nil];
        
        itemList = [NSMutableArray arrayWithObjects:
                    @"itemlistBig0",
                    @"itemlistBig1",
                    @"itemlistTrans0",
                    @"itemlistTrans1",
                    @"itemlistBomb0",
                    @"itemlistBomb1",
                    @"itemlistMagnet0",
                    @"itemlistMagnet1",
                    @"itemlistCookie0",
                    @"itemlistCookie1",
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



