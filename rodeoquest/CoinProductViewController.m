//
//  CoinProductViewController.m
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/24.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "CoinProductViewController.h"

@interface CoinProductViewController ()

@end

@implementation CoinProductViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        arrTypeImage = [NSArray arrayWithObjects:
                        [NSArray arrayWithObjects:
                         [NSNumber numberWithInteger:ButtonMenuImageTypeBuyCoin0],
                         [NSNumber numberWithInteger:ButtonMenuImageTypeBuyCoin1],
                         [NSNumber numberWithInteger:ButtonMenuImageTypeBuyCoin2],
                         nil],
                        [NSArray arrayWithObjects:
                         [NSNumber numberWithInteger:ButtonMenuImageTypeBuyCoin3],
                         [NSNumber numberWithInteger:ButtonMenuImageTypeBuyCoin4],
                         [NSNumber numberWithInteger:ButtonMenuImageTypeBuyCoin5],
                         nil],
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

-(void)pushedButton:(NSNumber *)num{
    NSLog(@"pushed button : tag = %d from coinProductViewCon", num.integerValue);
}

@end
