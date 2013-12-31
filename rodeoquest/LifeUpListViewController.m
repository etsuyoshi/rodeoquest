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
id _self;
NSMutableArray *arrAcquiredLifeNum;

void (^actYesForRubyShort)(void) = ^(void) {
    
    NSLog(@"link to buy money");
    [viewForCoinShort removeFromSuperview];
    
    
    PayProductViewController *payView = [[PayProductViewController alloc] init];
    [_self presentViewController: payView animated:NO completion: nil];
    
    
};

void (^actNoForRubyShort)(void) = ^(void) {
    NSLog(@"automatically remove this alert");
    
    [viewForCoinShort removeFromSuperview];
    
    
};

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    _self = self;
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
//                    @"lifeGame",
//                    @"lifeGame",
//                    @"lifeGame",
//                    @"lifeGame",
                    @"itemlistLifeUp0",
                    @"itemlistLifeUp1",
                    @"itemlistLifeUp2",
                    @"itemlistLifeUp3",
                   nil];
        
        arrAcquiredLifeNum = [NSMutableArray arrayWithObjects:
                              @"1",
                              @"2",
                              @"3",
                              @"4",
                              nil];
        
        strImgUnit = @"jewel";//image of unit to buy item.(abbreviate ".png")
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    tvGoldAmount.text = [NSString stringWithFormat:@"%d", [[attr getValueFromDevice:@"ruby"] intValue]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
 *button->[onButtonSelect]->buyBtnPressed->[updateToDeviceRuby],[displayRuby],[processAfterBuyButton]
 */
-(void)buyBtnPressed:(id)sender{//arg:selected-item-list-no
    if([[attr getValueFromDevice:@"ruby"] intValue] >= [[arrCost objectAtIndex:[sender tag]] intValue]){
        int cost = [[arrCost objectAtIndex:[sender tag]] intValue];
        NSLog(@"buy button pressed : %d", [sender tag]);
        //device data update
        [self updateToDeviceRuby:[[attr getValueFromDevice:@"ruby"] intValue] - cost];//[attr setValueToDev..
        //displayed ruby data update
        [self displayRuby];//tv.text = ...
        
        
        [self processAfterBtnPressed:[itemList objectAtIndex:[sender tag]]];
        
    }else{
        //コインが足りない場合
        [super oscillateTextViewGold:9];
        
        //コインはゲームで取得するか購入することができますメッセージダイアログボックス
        
        viewForCoinShort =
        [CreateComponentClass
         createAlertView:CGRectMake(10, 10,
                                    self.view.bounds.size.width-10,
                                    self.view.bounds.size.height)
         dialogRect:CGRectMake(10, 10,
                               self.view.bounds.size.width-30,
                               self.view.bounds.size.width-30)//正方形：縦＝横
         title:@"ルビーが不足しています。"
         message:@"ルビーを購入しますか？"
         titleYes:@"購入"
         titleNo:@"戻る"
         onYes:actYesForRubyShort
         onNo:actNoForRubyShort
         ];
        
        viewForCoinShort.center =
        CGPointMake(self.view.bounds.size.width/2,
                    self.view.bounds.size.height/2);
        [self.view addSubview:viewForCoinShort];
        
    }
    
}



/*
 *購入した商品情報(idに対応する個数)を更新
 *引数：itemListの項目が渡される
 */
-(void)processAfterBtnPressed:(NSString *)_key{
    
    int _originalLife = [[attr getValueFromDevice:@"lifeGame"] intValue];
    NSLog(@"processBeforeBtnPressed:%d", _originalLife);
    //取得した項目(ItemList配列)と獲得ライフ数(arrAcquiredLifeNum配列)の対応辞書
    NSDictionary *_dictAcquiredAndItem =
    [NSDictionary dictionaryWithObjects:
     arrAcquiredLifeNum forKeys:itemList];
    int _addingLife = [[_dictAcquiredAndItem objectForKey:_key] integerValue];
    
    int afterLife = _originalLife + _addingLife;
    
    [attr setValueToDevice:@"lifeGame" strValue:[NSString stringWithFormat:@"%d", afterLife]];
    
    
    
//    if([[attr getValueFromDevice:_key] isEqual:[NSNull null]] ||
//       [attr getValueFromDevice:_key] == nil){
//        [attr setValueToDevice:_key strValue:@"1"];
//    }else{
//        int beforeNum = [[attr getValueFromDevice:_key] intValue];
//        int afterNum = beforeNum + 1;
//        [attr setValueToDevice:_key strValue:[NSString stringWithFormat:@"%d", afterNum]];
//    }
    
    NSLog(@"processAfterBtnPressed:%@", [attr getValueFromDevice:_key]);
}

-(void)updateToDeviceRuby:(int)_ruby{
    [attr setValueToDevice:@"ruby" strValue:[NSString stringWithFormat:@"%d", _ruby]];
    
}

-(void)displayRuby{//購入後ruby値を修正する
    NSLog(@"now ruby = %d", [[attr getValueFromDevice:@"ruby"] intValue]);
    int _ruby = [[attr getValueFromDevice:@"ruby"] intValue];
    tvGoldAmount.text = [NSString stringWithFormat:@"%d", _ruby];
}


-(void)pushedCashFrame:(UITapGestureRecognizer *)recognizer{
    PayProductViewController * payView =
    [[PayProductViewController alloc] init];
    [self presentViewController:payView animated:YES completion:nil];
    
}


@end
