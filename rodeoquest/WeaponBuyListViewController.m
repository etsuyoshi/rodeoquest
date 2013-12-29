//
//  WeaponBuyListViewController.m
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/17.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
/*ItemListViewControllerのサブクラス+slideShowを直接表示するボタンを追加
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
#import "CoolButton.h"

//dispSlideShow内で使用:購入時に表示されるイメージファイルに使用
NSArray *imageArrayWithWhite;
CoolButton *btnClDispSlide;
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
        
//        //test:wallet
//        [attr setValueToDevice:@"gold" strValue:@"1000"];
//        NSLog(@"test:zeny = %@",
//              [attr getValueFromDevice:@"gold"]);
        
        // Custom initialization
        arrIv = [NSMutableArray arrayWithObjects://bullet image
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
                 @"装填に時間がかかる一方、敵に通常弾以上の物理ダメージを与えます。レベルアップにより発射頻度が向上します。",//1rep=100coin
                 @"着弾した瞬間のダメージはわずかでも、その後燃えさかる炎により継続的にダメージを与えることがあります。水属性の敵に大ダメージを与えます。",//1rep=90coin
                 @"発射頻度の高い武器で、通常の敵に中ダメージを与えます。特に水属性以外(火属性？)の敵に中ダメージを与えます。",//1rep=80coin
                 @"発射頻度は中程度ですが、通常の敵に大ダメージを与えます。特に水属性以外(火属性？)の敵に最大のダメージを与えます。",//1rep=70coin
                 @"致死性の毒を持つ虫を発射します。クリティカルヒットにより即死することがあります。",//1rep=90coin
                 @"武器自体の見た目は可愛い一方で、着弾した瞬間に敵を食い尽くし、大ダメージを与えます。針属性の敵や虫属性の敵にはダメージを与えないことがあります。",//1rep=80coin
                 @"切れ味鋭い針葉を放ちます。クリティカルヒットと継続的なダメージを与えます。",//1rep=70coin
                 @"魔力によりクリティカルヒットすると敵を完全に消し去ります。",//1rep=90coin
                 @"流れ星によるメテオストライク。全ての敵に大ダメージを与えます。",//1rep=80coin
                 @"大気のエネルギーを使った真空波動により、全ての敵に極大ダメージを与えます。翼が生えた的にダメージを与えます。",//1rep=70coin
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
        
        
        //独自配列：slideShow表示用画像
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

        
    }
    return self;
}
- (void)viewDidLoad
{
	// Do any additional setup after loading the view.
    [super viewDidLoad];
    
    //閉じるボタンの色を赤に変更
    [closeBtn removeFromSuperview];//remove superclasses'closeBtn
    closeBtn = [CreateComponentClass createButtonWithType:ButtonMenuBackTypeDefault
                                                     rect:CGRectMake(300, 3, 50, 50)
                                                    image:@"exit_r.png"
                                                   target:self
                                                 selector:@"closeBtnClicked"];
    closeBtn.center = CGPointMake(self.view.bounds.size.width-closeBtn.bounds.size.width/2,
                                  closeBtn.bounds.size.height/2);
    [self.view addSubview:closeBtn];
    
    
    
    //slideShowを表示するメソッド呼出しのためのボタン
    btnClDispSlide =
    [CreateComponentClass
     createCoolButton:CGRectMake(10, 10, 130, 60)
     text:@"コレクション"
     hue:0.75f saturation:0.5f brightness:0.5f
     target:self selector:@"onPressedBtnCollection" tag:0];
    [self.view addSubview:btnClDispSlide];
    
    btnClDispSlide.center =
    CGPointMake(btnClDispSlide.bounds.size.width/2+5,
                tvGoldAmount.center.y);
    
    
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
        
        
        //textView size
        
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
    
    viewFrame.clipsToBounds = YES;// レイヤー処理を有効化する。
    viewFrame.layer.cornerRadius = 20.0;// 角丸にする。0以上の浮動小数点。大きくなるほど丸くなる。
    [viewFrame.layer setBorderWidth:0.5f];// 大きくなるほどボーダーが太くなる。// ボーダーに線を付ける。角丸に沿ってボーターがつく。
    [viewFrame.layer setBorderColor:[[UIColor clearColor] CGColor]];// ボーダーの色を設定する。角丸に沿ってボーターの色がつく。
    [superViewForDispWpn addSubview:viewFrame];
    
    //フレームの上に背景画像表示withAnimation
    UIImageView *viewBack =
    [CreateComponentClass
     createImageView:CGRectMake(0, 0, 350, 350)
     image:@"BuyWeapon_BG.png"];
    viewBack.center = CGPointMake(widthFrame/2, widthFrame/2-50);
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
    
    //回転し続ける
    [self runSpinAnimationOnView:(UIView*)viewBack
                        duration:(CGFloat)100.0f//times of rotation
                       rotations:(CGFloat)1.0f//
                          repeat:(float)CGFLOAT_MAX];
    
    
    //フレームの上に画像表示
    UIImageView *ivSelectedWeapon =
    [CreateComponentClass
     createImageView:viewFrame.bounds
     image:[imageArrayWithWhite objectAtIndex:numSelected]
     tag:numSelected
     target:self
     selector:@"dispSlideShow"];
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


-(void)dispSlideShow{
    NSLog(@"dispSlideShow");
    for(int i = 0 ; i < [itemList count];i++){
        NSLog(@"%d is %@", i, [imageArrayWithWhite objectAtIndex:i]);
    }
    //画面中央部にイメージファイル、その周りに半透明ビュー、更にその周囲に透明ビュー(イメージ以外をタップすると消える)
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
    
    NSLog(@"base=%@, slide=%@", superViewForDispWpn, viewSlide);
}



/*
 *コレクションボタン表示時のイベント
 *slideshowを表示するためのベースview、閉じるview、スライドショーの表示
 */
-(void)onPressedBtnCollection{
    
    //slideshowを表示するためのベースview、閉じるview、スライドショーの表示
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
    
    
    //スライドショーの表示
    [self dispSlideShow];
    
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
