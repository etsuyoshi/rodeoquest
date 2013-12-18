//
//  WeaponBuyListViewController.m
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/17.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "WeaponBuyListViewController.h"
NSArray *imageArray;
@interface WeaponBuyListViewController ()

@end

@implementation WeaponBuyListViewController
AttrClass *attr;
UIView *superViewForDispWpn;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        attr = [[AttrClass alloc]init];
        
        //test:wallet
//        [attr setValueToDevice:@"gold" strValue:@"10000"];
//        NSLog(@"zeny = %@",
//              [attr getValueFromDevice:@"gold"]);
        
        // Custom initialization
        arrIv = [NSMutableArray arrayWithObjects:
                 @"close.png",
                 @"close.png",
                 @"close.png",
                 @"close.png",
                 @"close.png",
                 @"close.png",
                 @"close.png",
                 @"close.png",
                 @"close.png",
                 @"close.png",
                 nil];
        arrTv = [NSMutableArray arrayWithObjects:
                 @"いわ",//1rep=100coin
                 @"ほのお",//1rep=90coin
                 @"みず",//1rep=80coin
                 @"こおり",//1rep=70coin
                 @"むし",//1rep=90coin
                 @"どうぶつ",//1rep=80coin
                 @"くさ",//1rep=70coin
                 @"ぬの",//1rep=90coin
                 @"うちゅう",//1rep=80coin
                 @"かぜ",//1rep=70coin
                 nil];
        arrCost = [NSMutableArray arrayWithObjects:
                   @"100",//test:price=>increase
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
        
        itemList = [NSArray arrayWithObjects:
                    @"itemlistWeaponBuy0",
                    @"itemlistWeaponBuy1",
                    @"itemlistWeaponBuy2",
                    @"itemlistWeaponBuy3",
                    @"itemlistWeaponBuy4",
                    @"itemlistWeaponBuy5",
                    @"itemlistWeaponBuy6",
                    @"itemlistWeaponBuy7",
                    @"itemlistWeaponBuy8",
                    @"itemlistWeaponBuy9",
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

//購入ボタン押下後に反応する
//1.デバイスに購入済み情報を書き込む
//2.購入した武器を表示(表示された武器をタップすると今まで購入した武器一覧を見ることが出来る)
//arg:[itemList objectAtIndex:[sender tag]]
-(void)processAfterBtnPressed:(NSString *)_key{

    
    NSLog(@"weapon buy list : %@", _key);
    imageArray = [NSArray arrayWithObjects:
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
    
    int numSelected = 0;
    for(int i = 0;i < [imageArray count];i++){
        if([[itemList objectAtIndex:i] isEqualToString:_key]){
            numSelected = i;
            NSLog(@"selected item is %@", [imageArray objectAtIndex:numSelected]);
            break;
        }else if(i == [imageArray count]-1){
            NSLog(@"processAfterBuy selection error. caz:_key");//=\n%@ and itemList0=\n%@",
//                  _key,[itemList objectAtIndex:0]);
        }
    }
    
    //1.デバイスに購入済み情報(装備済)を書き込む
    [attr setValueToDevice:
     [NSString stringWithFormat:@"weaponID%d", numSelected] strValue:@"2"];
    //既に装備済のデバイスがあればvalue=1:購入済に設定
    for(int i = 0 ; i < [imageArray count];i++){
        if(i != numSelected){
            //null時判定注意！:なくてもうまくいくっぽい(null.integerValue=0?)
            if([[attr getValueFromDevice:
                [NSString stringWithFormat:@"weaponID%d", i]]
               isEqual:[NSNull null]]
               ||
               [attr getValueFromDevice:
                [NSString stringWithFormat:@"weaponID%d", i]] == nil){
                   //nullのまま
               }else{//他のアイテムで２になっているものは全て１に。
            
                   if([attr getValueFromDevice:
                       [NSString stringWithFormat:@"weaponID%d", i]].integerValue == 2){
                       
                       [attr setValueToDevice:
                        [NSString stringWithFormat:@"weaponID%d", i]
                                     strValue:@"1"];
                   }
               }
        }
    }

    
    //2.購入した武器を中央に表示(タップしたらコレクション表示)
    //親ビューを画面全体に配置
    //親ビューを閉じる機能を持つ画面全体ビュー
    //親ビューの上に中心にフレーム配置、フレーム内に武器画像表示
    superViewForDispWpn =
    [[UIView alloc] initWithFrame:self.view.bounds];
    [superViewForDispWpn setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.01f]];
    [self.view addSubview:superViewForDispWpn];
    
    //閉じる機能を持つ画面全体ビュー
    UIView *viewWithCloseFunc =
    [CreateComponentClass
     createViewNoFrame:superViewForDispWpn.bounds
     color:[UIColor clearColor]
     tag:0 target:self selector:@"closeSuperViewForDispWpn:"];
//    [viewWithCloseFunc setBackgroundColor:[UIColor blackColor]];
    
    [superViewForDispWpn addSubview:viewWithCloseFunc];
    
    //フレームのみ
    UIView *viewFrame =
    [CreateComponentClass
     createView:CGRectMake(0,0 , 300, 300)];
    viewFrame.center = CGPointMake(self.view.center.x,
                                   self.view.center.y * 5);
    [viewFrame setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1f]];
    [superViewForDispWpn addSubview:viewFrame];
    
    //フレームの上に画像表示
    UIImageView *ivSelectedWeapon =
    [CreateComponentClass
     createImageView:viewFrame.bounds
     image:[imageArray objectAtIndex:numSelected]
     tag:numSelected
     target:self
     selector:@"dispSlideShow:"];
    [viewFrame addSubview:ivSelectedWeapon];
    
    [UIView animateWithDuration:1.0f
                     animations:^ {
                         viewFrame.center = self.view.center;
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    


}


-(void)dispSlideShow:(id)sender{
    UIView *tappedView = [sender view];
    NSLog(@"weaponSelected:%@", tappedView);
    
    //画面中央部にイメージファイル、その周りに半透明ビュー、更にその周囲に透明ビュー(イメージ以外をタップすると消える)
    //購入した武器の分だけ右を見れる
    UIView *viewSlide = [CreateComponentClass
                         createSlideShow:CGRectMake(0,50,
                                                    self.view.bounds.size.width,
                                                    self.view.bounds.size.height)
                         imageFile:imageArray
                         target:self
                         selector1:@"closeSuperViewForDispWpn:"
                         selector2:nil];//@"weaponSelected:"];
    viewSlide.tag = 0;
    [superViewForDispWpn addSubview:viewSlide];
    
    //slideshowでビューを選択した時の挙動(ボタンや説明文等)＝＞廃止？
//    int WEAPON_BUY_COUNT = 10;
    //slideshowの上に表示するダイアログボックス
//    for(int i = 0;i < WEAPON_BUY_COUNT;i++){//最初のタグは武器イメージタップ時のイベント
//        if(i == tappedView.tag){
//            UIView *viewAll = [[UIView alloc]initWithFrame:self.view.bounds];
//            [viewAll setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.3f]];//タップイベントを受け付けないビューを画面全体に配置
//            UIView *viewFrame = [CreateComponentClass createView:CGRectMake(10, 120, 300, 300)];
//            [viewFrame setBackgroundColor:[UIColor colorWithRed:((float)i+1)/WEAPON_BUY_COUNT green:1.0f blue:1.0f alpha:0.3f]];
//            NSLog(@"%f", (float)i/WEAPON_BUY_COUNT);
//            UIButton *bt = [CreateComponentClass createButtonWithType:ButtonMenuBackTypeDefault
//                                                                 rect:CGRectMake(260, 50, 25, 25)
//                                                                image:@"close.png"
//                                                               target:self
//                                                             selector:@"closeSuperSuperView:"];//親クラスを削除する
//            bt.tag = 9999;
//            [viewFrame addSubview:bt];
//            
//            //説明文
//            UITextView *tv_buy = [CreateComponentClass createTextView:CGRectMake(30, 30,
//                                                                                 viewFrame.bounds.size.width-60,
//                                                                                 100)
//                                                                 text:@"explanation"
//                                                                 font:@"AmericanTypewriter-Bold"
//                                                                 size:12
//                                                            textColor:[UIColor whiteColor]
//                                                            backColor:[UIColor clearColor]
//                                                           isEditable:NO];
//            [viewFrame addSubview:tv_buy];
//            
//            NSString *strButtonText;
//            //現在の武器のフレームには枠を付ける
//            NSString *strWeaponIDX = [NSString stringWithFormat:@"weaponID%d", i];
//            if([[attr getValueFromDevice:strWeaponIDX] isEqualToString:@"0"] ||
//               [[attr getValueFromDevice:strWeaponIDX] isEqual:[NSNull null]] ||
//               [attr getValueFromDevice:strWeaponIDX] == nil){
//                
//                strButtonText = @"buy now!";
//            }else if([[attr getValueFromDevice:strWeaponIDX] isEqualToString:@"1"]){
//                //既に購入済
//                strButtonText = @"set";
//            }else if([[attr getValueFromDevice:strWeaponIDX] isEqualToString:@"2"]){
//                strButtonText = @"now setting.";
//            }
//            CoolButton *bt_buy = [CreateComponentClass createCoolButton:CGRectMake(30, 150, viewFrame.bounds.size.width-60, 70)
//                                                                   text:strButtonText
//                                                                    hue:0.532f
//                                                             saturation:0.553f
//                                                             brightness:0.535f
//                                                                 target:self
//                                                               selector:@"buyWeapon:"
//                                                                    tag:i];
//            [viewFrame addSubview:bt_buy];
//            
//            
//            [viewAll addSubview:viewFrame];
//            [self.view addSubview:viewAll];
//            break;
//        }
//    }
    
}

-(void)closeView:(id)sender{
    NSLog(@"close view");
    [[sender view]removeFromSuperview];
}
//-(void)closeSuperView:(id)sender{
//    NSLog(@"close superview : %@", sender);
//    [[sender superview]removeFromSuperview];
//    
//}
-(void)closeSuperViewForDispWpn:(NSNumber *)num{
    NSLog(@"closeSuperView");
    [superViewForDispWpn removeFromSuperview];
}



@end
