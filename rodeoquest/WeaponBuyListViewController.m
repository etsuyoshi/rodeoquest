//
//  WeaponBuyListViewController.m
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/17.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
/*
 *initWithNibName:データ初期化
 *viewDidLoad:各コンポーネントの張り付け
 *viewWillAppear:コインや装備状態(サブクラスのWeaponBuyList...)にデータを反映
 *viewDidAppear:
 *onSelectButton:(id)sender:リスト中のボタン押下により呼出される。サブクラスである本クラスにおいて即座に購入せずに状態を判定する機能も備える。
 *buyBtnPressed:sender:onSelectButtonから呼出し:購入処理orコイン不足のエフェクト表示
 *processAfterBtnPressed:(NSString *)_key:各アイテムの状態をセット。サブクラスである本クラスにおいて装備状態を判定し、選択したアイテムを中央に表示
 *dispSlideShow:processAfterBtnPressed内で中央に表示されたアイテムを選択するとアイテム一覧のスライドショー表示
 *viewWillDisappear:
 *viewDidDisappear:
 */
//

#import "WeaponBuyListViewController.h"
#import "QBFlatButton.h"
#import "KiraParticleView.h"

//dispSlideShow内で使用:購入時に表示されるイメージファイルに使用
NSArray *imageArrayWithWhite;
@interface WeaponBuyListViewController ()

@end

@implementation WeaponBuyListViewController
AttrClass *attr;
UIView *superViewForDispWpn;
UIView *superViewForEquipWpn;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        attr = [[AttrClass alloc]init];
        
        //test:wallet
        [attr setValueToDevice:@"gold" strValue:@"1000"];
        NSLog(@"test:zeny = %@",
              [attr getValueFromDevice:@"gold"]);
        
        // Custom initialization
        arrIv = [NSMutableArray arrayWithObjects:
//                 @"close.png",//0
//                 @"close.png",//1
//                 @"close.png",//2
//                 @"close.png",//3
//                 @"close.png",//4
//                 @"close.png",//5
//                 @"close.png",//6
//                 @"close.png",//7
//                 @"close.png",//8
//                 @"close.png",//9
//                 
                 @"Rock.png",
                 @"Fire.png",
                 @"Water.png",
                 @"Ice.png",
                 @"Bug.png",
                 @"Animal.png",
                 @"Grass.png",
                 @"Cloth.png",
                 @"Space.png",
                 @"Wing.png",
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
        
        itemList = [NSMutableArray arrayWithObjects:
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
        
//        arrTitle = [NSMutableArray array];
        
        arrTitle = [NSMutableArray arrayWithObjects:
                    @"buy",
                    @"buy",
                    @"buy",
                    @"buy",
                    @"buy",
                    @"buy",
                    @"buy",
                    @"buy",
                    @"buy",
                    @"buy",
                    nil];
        
        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
	// Do any additional setup after loading the view.
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    for(int i = 0 ;i < [itemList count];i++){
        //nsdefaultに書き込まれていないキーはint型に変換すると0になる:string型ではnil
        int stateHoldWpn =
        [attr getValueFromDevice:
         [NSString stringWithFormat:@"weaponID%d", i]].integerValue;
        
        NSLog(@"id%dはstatus%dです", i, stateHoldWpn);
        [self
         setStateButtonSelected:[arrBtnBuy objectAtIndex:i]
         status:stateHoldWpn];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//購入ボタン押下後に反応する
//0.既に装備しているアイテムかどうか判定する
//1.デバイスに購入済み情報を書き込む
//2.購入した武器を表示(表示された武器をタップすると今まで購入した武器一覧を見ることが出来る)
//arg:UIButton (UIView)
-(void)onSelectButton:(id)sender{
    int numSelected = [sender tag];
    NSString *strIDWpn = [NSString stringWithFormat:@"weaponID%d", numSelected];
    int statusWpn = [attr getValueFromDevice:strIDWpn].integerValue;
    
    NSLog(@"%d button pressed. %@ is %d now",
          numSelected,strIDWpn,statusWpn);
    
    switch (statusWpn) {
        case 0:{
            [super buyBtnPressed:sender];
            break;
        }
        case 1: {
            //装備しますか？メッセージ
            
            void (^blockCloseEquipView)(void) = ^(void){
                [superViewForEquipWpn removeFromSuperview];
            };
            superViewForEquipWpn =
            [CreateComponentClass
             createAlertView:self.view.bounds
             dialogRect:CGRectMake(0, 0,
                                   self.view.bounds.size.width-20,
                                   self.view.bounds.size.width-20)
             title:@"現在装備可能です。"
             message:@"装備しますか？"
             titleYes:@"装備" titleNo:@"いいえ"
             onYes:^{
                 //ID設定：他のアイテム含めて設定
                 [self processAfterBtnPressed:[itemList objectAtIndex:numSelected]];
                 NSLog(@"%@ is set to %@ from %d",
                       strIDWpn, [attr getValueFromDevice:strIDWpn], statusWpn);
                 [superViewForEquipWpn removeFromSuperview];
                 
                 
             }
             onNo:blockCloseEquipView];
            superViewForEquipWpn.center =
            CGPointMake(self.view.bounds.size.width/2,
                        self.view.bounds.size.height/2);
            [self.view addSubview:superViewForEquipWpn];
            break;
        }
        case 2:{
            //装備中ですメッセージor何もしない
            break;
        }
    
        default:{
            NSLog(@"ERROR : status of WeaponID%d is out of exception", numSelected);
            break;
        }
    }
    

}

/*
 *購入処理(@superclass)が完了した後に呼ばれる：
 *機能：ID設定を行う
 *引数_key:factro of itemList :@"itemlistWeaponBuy0", @"itemlistWeaponBuy1",...
 *スーパークラスbuyBtnPressed:メソッドから以下により呼び出される
 *呼出しside：[self processAfterBtnPressed:[itemList objectAtIndex:[sender tag]]];
 */
-(void)processAfterBtnPressed:(NSString *)_key{

    
    NSLog(@"weapon buy list : %@", _key);
    //dispSlideShow内で使用:購入時に表示されるイメージファイルに使用。
    imageArrayWithWhite = [NSArray arrayWithObjects:
                           @"W_RockBow.png",
                           @"W_FireBow.png",
                           @"W_WaterBow.png",
                           @"W_IceBow.png",
                           @"W_BugBow.png",
                           @"W_AnimalBow.png",
                           @"W_GrassBow.png",
                           @"W_ClothBow.png",
                           @"W_SpaceBow.png",
                           @"W_WingBow.png",
                           nil];
    
    //numSelectedに選択されたボタン番号を格納
    int numSelected = -1;
    for(int i = 0;i < [imageArrayWithWhite count];i++){
        if([[itemList objectAtIndex:i] isEqualToString:_key]){
            numSelected = i;
            NSLog(@"selected item is %@", [imageArrayWithWhite objectAtIndex:numSelected]);
            break;
        }else if(i == [imageArrayWithWhite count]-1){
            NSLog(@"ERROR : processAfterBuy selection error. caz:_key is no correspondings.");//=\n%@ and itemList0=\n%@",
//                  _key,[itemList objectAtIndex:0]);

        }
    }
    
    
    

    
    //1.1.デバイスに購入済み情報(装備済)を書き込む&ボタンの状態を装備中に変更
    //1.2.既に装備済のデバイスがあればvalue=1:購入済に設定＆ボタンの状態を装備可能に変更
    for(int i = 0 ; i < [imageArrayWithWhite count];i++){
        if(i == numSelected){
            [attr setValueToDevice:
             [NSString stringWithFormat:@"weaponID%d", numSelected] strValue:@"2"];
            
            [self setStateButtonSelected:((QBFlatButton *)[arrBtnBuy objectAtIndex:numSelected])
                              status:2];
//            
//            [((QBFlatButton *)[arrBtnBuy objectAtIndex:numSelected]) setSelected:YES];//押された状態に
//            ((QBFlatButton *)[arrBtnBuy objectAtIndex:numSelected]).titleLabel.font = [UIFont boldSystemFontOfSize:30];
//            [((QBFlatButton *)[arrBtnBuy objectAtIndex:numSelected]) setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//            [((QBFlatButton *)[arrBtnBuy objectAtIndex:numSelected]) setTitle:@"E." forState:UIControlStateNormal];
            
        }else {
            //null時判定注意！:なくてもうまくいくっぽい(null.integerValue=0?)
            if([[attr getValueFromDevice:
                [NSString stringWithFormat:@"weaponID%d", i]]
               isEqual:[NSNull null]]
               ||
               [attr getValueFromDevice:
                [NSString stringWithFormat:@"weaponID%d", i]] == nil){
                   //nullのまま
                   NSLog(@"ID%dはnil", i);
               }else{//他のアイテムで２になっているものは全て１に。
                   NSLog(@"ID%dの状態は%d",
                         i, [attr getValueFromDevice:[NSString stringWithFormat:@"weaponID%d",i]].integerValue);
                   if([attr getValueFromDevice:
                       [NSString stringWithFormat:@"weaponID%d", i]].integerValue == 2){
                       
                       [attr setValueToDevice:
                        [NSString stringWithFormat:@"weaponID%d", i]
                                     strValue:@"1"];
                       
                       NSLog(@"%dは装備中なので%@に変更",i,
                             [attr getValueFromDevice:
                                 [NSString stringWithFormat:@"weaponID%d", i]]);
                       
                       
                       
                       //ボタンの状態も変更
                       [self setStateButtonSelected:((QBFlatButton *)[arrBtnBuy objectAtIndex:i])
                                         status:1];
                       
//                       [((QBFlatButton *)[arrBtnBuy objectAtIndex:i]) setSelected:NO];//選択された状態を解除
////                       [((QBFlatButton *)[arrBtnBuy objectAtIndex:i]) setHighlighted:NO];//押された状態を解除
//                       ((QBFlatButton *)[arrBtnBuy objectAtIndex:i]).titleLabel.font = [UIFont boldSystemFontOfSize:16];
//                       [((QBFlatButton *)[arrBtnBuy objectAtIndex:i]) setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                       [((QBFlatButton *)[arrBtnBuy objectAtIndex:i]) setTitle:@"Equip" forState:UIControlStateNormal];
                       
                       
                       
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
    int widthFrame = 300;
    int heightFrame = 200;
    UIView *viewFrame =
    [CreateComponentClass
     createView:CGRectMake(0,0 , widthFrame, heightFrame)];
    viewFrame.center = CGPointMake(self.view.center.x,
                                   self.view.center.y * 5);
    [viewFrame setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1f]];
    [superViewForDispWpn addSubview:viewFrame];
    
    //フレームの上に背景画像表示withAnimation
    UIImageView *viewBack =
    [CreateComponentClass
     createImageView:CGRectMake(0, 0, 350, 350)
     image:@"BuyWeapon_BG.png"];
    viewBack.center = CGPointMake(widthFrame/2, widthFrame/2-50);
    viewBack.clipsToBounds = YES;// レイヤー処理を有効化する。
    viewBack.layer.cornerRadius = 10.0;// 角丸にする。0以上の浮動小数点。大きくなるほど丸くなる。
    [viewBack.layer setBorderWidth:1.0];    // 大きくなるほどボーダーが太くなる。// ボーダーに線を付ける。角丸に沿ってボーターがつく。
    [viewBack.layer setBorderColor:[[UIColor clearColor] CGColor]];    // ボーダーの色を設定する。角丸に沿ってボーターの色がつく。
    [viewFrame addSubview:viewBack];
    //背景画像にアニメーションを付与
    //一回転できない
//    [UIView animateWithDuration:3.0
//                          delay:0.0
//                        options:UIViewAnimationOptionRepeat |
//                                UIViewAnimationOptionCurveLinear
//                     animations:^{
//                         CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
//                         viewBack.transform = transform;
//                     }
//                     completion:nil];
    
[self runSpinAnimationOnView:(UIView*)viewBack
                    duration:(CGFloat)3.0f
                   rotations:(CGFloat)1.0f
                      repeat:(float)CGFLOAT_MAX];
    
    
    //フレームの上に画像表示
    UIImageView *ivSelectedWeapon =
    [CreateComponentClass
     createImageView:viewFrame.bounds
     image:[imageArrayWithWhite objectAtIndex:numSelected]
     tag:numSelected
     target:self
     selector:@"dispSlideShow:"];
    [viewFrame addSubview:ivSelectedWeapon];
//    viewFrame.center = self.view.center;//test
    
    
    
    //フレームをアニメーションで下から上に動かす:完了したらパーティクル表示
    //test:stop
    [UIView animateWithDuration:1.0f
                     animations:^ {
                         viewFrame.center = self.view.center;
                     }
                     completion:^(BOOL finished){
                         [self dispParticle:ivSelectedWeapon delay:0.3f];
                     }];
}

/*
 *Z軸周りに回転し続ける
 */
- (void) runSpinAnimationOnView:(UIView*)view
                       duration:(CGFloat)duration
                      rotations:(CGFloat)rotations
                         repeat:(float)repeat{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}



//delaySec後、viewにパーティクルを載せる
-(void)dispParticle:(UIView *)view delay:(int)delaySec{
    //disp perticle after delay
    KiraParticleView *viewKiraParticle;
    for(int i = 0; i < 3;i++){//width
        for(int j = 0 ; j < 4 ; j++){//height
            viewKiraParticle = [[KiraParticleView alloc]
                                initWithFrame:CGRectMake((i * 100) % (int)view.bounds.size.width,
                                                         (j * 120) % (int)view.bounds.size.height, 50, 50)
                                particleType:ParticleTypeKilled];
            [view addSubview:viewKiraParticle];
        }
    }

}


-(void)dispSlideShow:(id)sender{
    UIView *tappedView = [sender view];
    NSLog(@"weaponSelected:%@", tappedView);
    
    //画面中央部にイメージファイル、その周りに半透明ビュー、更にその周囲に透明ビュー(イメージ以外をタップすると消える)
    //購入した武器の分だけ右を見れる
    UIView *viewSlide = [CreateComponentClass
                         createSlideShowVerticalAll:CGRectMake(0,50,
                                                            self.view.bounds.size.width,
                                                            self.view.bounds.size.height)
                         imageFile:imageArrayWithWhite
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

-(void)setStateAllButton{
    for(int i = 0 ; i < [arrBtnBuy count] ;i++){
        NSString *_strIdWpn = [NSString stringWithFormat:@"weaponID%d", i];
        int _state = [attr getValueFromDevice:_strIdWpn].integerValue;
        [self setStateButtonSelected:[arrBtnBuy objectAtIndex:i] status:_state];
    }
}

-(void)setStateButtonSelected:(UIButton *)btn status:(int)status{
    
    if(status == 2){
        [btn setSelected:YES];//押された状態に
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:30];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn setTitle:@"E." forState:UIControlStateNormal];
//        [((QBFlatButton *)[arrBtnBuy objectAtIndex:numSelected]) setSelected:YES];//押された状態に
//        ((QBFlatButton *)[arrBtnBuy objectAtIndex:numSelected]).titleLabel.font = [UIFont boldSystemFontOfSize:30];
//        [((QBFlatButton *)[arrBtnBuy objectAtIndex:numSelected]) setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        [((QBFlatButton *)[arrBtnBuy objectAtIndex:numSelected]) setTitle:@"E." forState:UIControlStateNormal];
    }else if(status == 1){
        
//        [((QBFlatButton *)[arrBtnBuy objectAtIndex:i]) setSelected:NO];//選択された状態を解除
//        //                       [((QBFlatButton *)[arrBtnBuy objectAtIndex:i]) setHighlighted:NO];//押された状態を解除
//        ((QBFlatButton *)[arrBtnBuy objectAtIndex:i]).titleLabel.font = [UIFont boldSystemFontOfSize:16];
//        [((QBFlatButton *)[arrBtnBuy objectAtIndex:i]) setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [((QBFlatButton *)[arrBtnBuy objectAtIndex:i]) setTitle:@"Equip" forState:UIControlStateNormal];
        
        [btn setSelected:NO];//選択された状態を解除
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:@"Equip" forState:UIControlStateNormal];

        
    }else if(status == 0){
        [btn setSelected:NO];//選択された状態を解除
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:@"Buy" forState:UIControlStateNormal];

    }
}

@end
