//
//  WeaponBuyListViewController.m
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/17.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "WeaponBuyListViewController.h"

@interface WeaponBuyListViewController ()

@end

@implementation WeaponBuyListViewController
AttrClass *attr;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        attr = [[AttrClass alloc]init];
        
        // Custom initialization
        arrIv = [NSMutableArray arrayWithObjects:
                 @"tool_heal.png",
                 @"tool_heal.png",
                 @"tool_heal.png",
                 @"tool_heal.png",
                 @"tool_heal.png",
                 @"tool_heal.png",
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
                 @"ドラゴンを2回だけ急速回復します。\n180枚のコインが必要です。",//1rep=90coin
                 @"ドラゴンを3回だけ急速回復します。\n240枚のコインが必要です。",//1rep=80coin
                 @"ドラゴンを4回だけ急速回復します。\n280枚のコインが必要です。",//1rep=70coin
                 @"ドラゴンを2回だけ急速回復します。\n180枚のコインが必要です。",//1rep=90coin
                 @"ドラゴンを3回だけ急速回復します。\n240枚のコインが必要です。",//1rep=80coin
                 @"ドラゴンを4回だけ急速回復します。\n280枚のコインが必要です。",//1rep=70coin
                 @"ドラゴンを2回だけ急速回復します。\n180枚のコインが必要です。",//1rep=90coin
                 nil];
        arrCost = [NSMutableArray arrayWithObjects:
                   @"100",
                   @"180",
                   @"240",
                   @"70",
                   @"70",
                   @"70",
                   @"70",
                   @"70",
                   @"70",
                   @"70",
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

-(void)processAfterBuy:(NSString *)_key{
    NSLog(@"weapon buy list : %@", _key);
    NSArray *imageArray = [NSArray arrayWithObjects:
                           @"RockBow.png",
                           @"FireBow.png",
                           @"WaterBow.png",
                           @"IceBow.png",
                           @"BugBow.png",
                           @"AnimalBow.png",
                           @"GrassBow.png",
                           @"ClothBow.png",
                           @"SpaceBow.png",
                           @"WingBow.png",
                           nil];
    //画面中央部にイメージファイル、その周りに半透明ビュー、更にその周囲に透明ビュー(イメージ以外をタップすると消える)
    //購入した武器の分だけ右を見れる
    UIView *superView = [CreateComponentClass createSlideShow:CGRectMake(0,
                                                                         50,
                                                                         self.view.bounds.size.width,
                                                                         self.view.bounds.size.height)
                                                    imageFile:imageArray
                                                       target:self
                                                    selector1:@"closeView:"
                                                    selector2:@"weaponSelected:"];
    //                                                            selector2:@"imageTapped:"];
    superView.tag = 0;
    [self.view addSubview:superView];

}


-(void)weaponSelected:(id)sender{
    UIView *tappedView = [sender view];
    NSLog(@"%@", tappedView);
    int WEAPON_BUY_COUNT = 10;
    
    /*
     購入した武器のみ表示する
     */
    
    for(int i = 0;i < WEAPON_BUY_COUNT;i++){//最初のタグは武器イメージタップ時のイベント
        if(i == tappedView.tag){
            UIView *viewAll = [[UIView alloc]initWithFrame:self.view.bounds];
            [viewAll setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.3f]];//タップイベントを受け付けないビューを画面全体に配置
            UIView *viewFrame = [CreateComponentClass createView:CGRectMake(10, 120, 300, 300)];
            [viewFrame setBackgroundColor:[UIColor colorWithRed:((float)i+1)/WEAPON_BUY_COUNT green:1.0f blue:1.0f alpha:0.3f]];
            NSLog(@"%f", (float)i/WEAPON_BUY_COUNT);
            UIButton *bt = [CreateComponentClass createButtonWithType:ButtonMenuBackTypeDefault
                                                                 rect:CGRectMake(260, 50, 25, 25)
                                                                image:@"close.png"
                                                               target:self
                                                             selector:@"closeSuperSuperView:"];//親クラスを削除する
            bt.tag = 9999;
            [viewFrame addSubview:bt];
            
            //説明文
            UITextView *tv_buy = [CreateComponentClass createTextView:CGRectMake(30, 30,
                                                                                 viewFrame.bounds.size.width-60,
                                                                                 100)
                                                                 text:@"explanation"
                                                                 font:@"AmericanTypewriter-Bold"
                                                                 size:12
                                                            textColor:[UIColor whiteColor]
                                                            backColor:[UIColor clearColor]
                                                           isEditable:NO];
            [viewFrame addSubview:tv_buy];
            
            NSString *strButtonText;
            //現在の武器のフレームには枠を付ける
            NSString *strWeaponIDX = [NSString stringWithFormat:@"weaponID%d", i];
            if([[attr getValueFromDevice:strWeaponIDX] isEqualToString:@"0"] ||
               [[attr getValueFromDevice:strWeaponIDX] isEqual:[NSNull null]] ||
               [attr getValueFromDevice:strWeaponIDX] == nil){
                
                strButtonText = @"buy now!";
            }else if([[attr getValueFromDevice:strWeaponIDX] isEqualToString:@"1"]){
                //既に購入済
                strButtonText = @"set";
            }else if([[attr getValueFromDevice:strWeaponIDX] isEqualToString:@"2"]){
                strButtonText = @"now setting.";
            }
            CoolButton *bt_buy = [CreateComponentClass createCoolButton:CGRectMake(30, 150, viewFrame.bounds.size.width-60, 70)
                                                                   text:strButtonText
                                                                    hue:0.532f
                                                             saturation:0.553f
                                                             brightness:0.535f
                                                                 target:self
                                                               selector:@"buyWeapon:"
                                                                    tag:i];
            [viewFrame addSubview:bt_buy];
            
            
            [viewAll addSubview:viewFrame];
            [self.view addSubview:viewAll];
            break;
        }
    }
    
}

-(void)closeView:(id)sender{
    NSLog(@"close view");
    [[sender view]removeFromSuperview];
}


@end
