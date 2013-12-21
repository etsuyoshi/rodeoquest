//
//  LifeUpViewController.m
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/05.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "LifeUpListViewController.h"

@interface LifeUpListViewController ()

@end

@implementation LifeUpListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        arrIv = [NSMutableArray arrayWithObjects:
                 @"tool_heal.png",
                 @"tool_heal.png",
                 @"tool_heal.png",
                 @"tool_heal.png",
                 nil];
        arrTv = [NSMutableArray arrayWithObjects:
                 @"ドラゴンを1回だけ急速回復します。\n100枚のコインが必要です。",//1rep=100coin
                 @"ドラゴンを2回だけ急速回復します。\n180枚のコインが必要です。",//1rep=90coin
                 @"ドラゴンを3回だけ急速回復します。\n240枚のコインが必要です。",//1rep=80coin
                 @"ドラゴンを4回だけ急速回復します。\n280枚のコインが必要です。",//1rep=70coin
                 nil];
        arrCost = [NSMutableArray arrayWithObjects:
                   @"100",
                   @"180",
                   @"240",
                   @"70",
                   nil];
        itemList = [NSMutableArray arrayWithObjects:
                    @"itemlistLifeUp0",
                    @"itemlistLifeUp1",
                    @"itemlistLifeUp2",
                    @"itemlistLifeUp3",
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
