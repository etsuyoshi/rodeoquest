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
                 @"tool_transparancy.png",
                 @"tool_bomb.png",
                 @"tool_magnet.png",
                 nil];
        arrTv = [NSMutableArray arrayWithObjects:
                 @"巨大化している時間を長くします。\n100枚のコインが必要です。",
                 @"透明になっている時間を長くします。\n100枚のコインが必要です。",
                 @"周囲で爆発が発生する時間を長くします。\n100枚のコインが必要です。",
                 @"磁石が有効になっている時間を長くします。\n100枚のコインが必要です。",
                 nil];
        arrCost = [NSMutableArray arrayWithObjects:
                   @"100",
                   @"100",
                   @"100",
                   @"100",
                   nil];
        
        itemList = [NSMutableArray arrayWithObjects:
                    @"itemlistItemUp0",
                    @"itemlistItemUp1",
                    @"itemlistItemUp2",
                    @"itemlistItemUp3",
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
