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
                 @"weapon_laser.png",
                 @"weapon_laser.png",
                 @"weapon_diffuse.png",
                 @"weapon_bomb.png",
                 nil];
        arrTv = [NSMutableArray arrayWithObjects:
                 @"爆弾が投下される時間を長くします。\n50枚のコインが必要です。",
                 @"攻撃力が強化される時間を長くします。\n100枚のコインが必要です。",
                 @"レーザーを発射する時間を1.5倍にします。\n100枚のコインが必要です。",
                 @"レーザーを発射する時間を２倍にします。\n150枚のコインが必要です。",
                 nil];
        
        arrCost = [NSMutableArray arrayWithObjects:
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
