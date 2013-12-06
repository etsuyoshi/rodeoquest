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
                 @"defense_barrier.png",
                 @"defense_barrier.png",
                 @"defense_barrier.png",
                 @"defense_barrier.png",
                 nil];
        arrTv = [NSMutableArray arrayWithObjects:
                 @"シールドが発生する時間を1.5倍に長くします。\n15枚のコインが必要です。",//1=10coin
                 @"シールドが発生する時間を2倍に長くします。\n18枚のコインが必要です。",//1=9coin
                 @"シールドが発生する時間を3倍に長くします。\n24枚のコインが必要です。",//1=8coin
                 @"シールドが発生する時間を4倍に長くします。\n28枚のコインが必要です。",//1=7coin
                 nil];
        
        arrCost = [NSMutableArray arrayWithObjects:
                   @"15",
                   @"18",
                   @"24",
                   @"28",
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
