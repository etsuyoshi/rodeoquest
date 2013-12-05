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
                 @"回復。\n100枚のコインが必要です。",
                 @"。\n100枚のコインが必要です。",
                 @"。\n100枚のコインが必要です。",
                 @"。\n100枚のコインが必要です。",
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
