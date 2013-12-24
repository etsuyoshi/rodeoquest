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
                         [NSNumber numberWithInteger:ButtonMenuImageTypeCoin],
                         [NSNumber numberWithInteger:ButtonMenuImageTypeCoin],
                         [NSNumber numberWithInteger:ButtonMenuImageTypeCoin],
                         nil],
                        [NSArray arrayWithObjects:
                         [NSNumber numberWithInteger:ButtonMenuImageTypeCoin],
                         [NSNumber numberWithInteger:ButtonMenuImageTypeCoin],
                         [NSNumber numberWithInteger:ButtonMenuImageTypeCoin],
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
