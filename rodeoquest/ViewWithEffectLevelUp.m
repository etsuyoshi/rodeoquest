//
//  ViewWithEffectLevelUp.m
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2013/12/12.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "ViewWithEffectLevelUp.h"

@implementation ViewWithEffectLevelUp
UIView *viewLevelUp;
UIImageView *viewPaper;
UITextView *tvTitle;
UIView *viewBeforeLevel;
UIView *viewAfterLevel;
UIImageView *ivBeforeBeam;
UIImageView *ivAfterBeam;
UITextView *tvBeforeLevel;
UITextView *tvAfterLevel;
UIView *viewKiraParticle;

AttrClass *attr;
- (id)initWithFrame:(CGRect)frame{
    
    self = [self initWithFrame:frame beforeLevel:1 afterLevel:2];
    return self;
}
-(id)initWithFrame:(CGRect)frame beforeLevel:(int)blv afterLevel:(int)alv{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        attr = [[AttrClass alloc] init];
        
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
        
        viewPaper = [[UIImageView alloc]
                     initWithFrame:CGRectMake(0, 0,
                                              self.frame.size.width, self.frame.size.height)];
        viewPaper.image = [UIImage imageNamed:@"sozai_paper.png"];
        [self addSubview:viewPaper];
        
        //right upper side : level-up label
        //表示期間中、ジャンプアニメーション:fireworksアニメーションとバッティングして振動してしまう
//        viewLevelUp = [CreateComponentClass
//                              createView:CGRectMake(0, 0, 100, 70)];
//        viewLevelUp.center = CGPointMake(self.bounds.size.width-viewLevelUp.frame.size.width,
//                                         viewLevelUp.frame.size.height/2+10);
//        [viewLevelUp setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.5 alpha:0.5]];
//        [self addSubview:viewLevelUp];
//        [self animViewLevelUp:9 originalPoint:viewLevelUp.center];
        
        
        /*
         *タイトル：Congraturation!
         */
        tvTitle = [CreateComponentClass
                   createTextView:CGRectMake(0, 0,
                                             self.bounds.size.width*4/5,100)
                   text:@"Congratulation!\nlevel-up!"
                   font:@"AmericanTypewriter-Bold"
                   size:30
                   textColor:[UIColor whiteColor]
                   backColor:[UIColor clearColor]
                   isEditable:NO];
        [tvTitle sizeToFit];
        tvTitle.textAlignment = NSTextAlignmentCenter;
        tvTitle.center = CGPointMake(self.bounds.size.width/2,
                                     100);
        [self addSubview:tvTitle];
        
        
        
        /*
         *center part : now-level => next-level
         *small-now-level, big-next-level
         *フレームの中にビームとレベルの数字を表示
        */
        
        //まず枠：タイトルの下に配置
        viewBeforeLevel = [CreateComponentClass
                           createView:CGRectMake(0, 0, 100, 90)];
        [self addSubview:viewBeforeLevel];
        viewBeforeLevel.center = CGPointMake(self.bounds.size.width/2 - viewBeforeLevel.bounds.size.width/2 - 10,
                                             tvTitle.center.y + tvTitle.bounds.size.height/2 +viewBeforeLevel.bounds.size.height/2);
//                                             self.bounds.size.height/2);
        
        //viewBeforeLevelの横(同じ高さ)に同じ大きさのフレームを用意
        viewAfterLevel = [CreateComponentClass
                          createView:viewBeforeLevel.bounds];
        [self addSubview:viewAfterLevel];
        viewAfterLevel.center = CGPointMake(self.bounds.size.width/2 + viewAfterLevel.bounds.size.width/2 + 10,
                                            viewBeforeLevel.center.y);
//                                            self.bounds.size.height/2);
        
        
        //次にimageView:beam描画
//        ivBeforeBeam = [CreateComponentClass
//                        createImageView:viewBeforeLevel.bounds
//                        image:[NSString stringWithFormat:@"%02d.png", blv]];
        ivBeforeBeam = [[[OrdinaryBeamClass alloc]
                         init:viewBeforeLevel.bounds.size.width/2
                         y_init:viewBeforeLevel.bounds.size.height/2
                         width:viewBeforeLevel.bounds.size.width
                         height:viewBeforeLevel.bounds.size.height
                         level:blv]
                        getImageView];
        ivBeforeBeam.center = CGPointMake(viewBeforeLevel.bounds.size.width/2,
                                          viewBeforeLevel.bounds.size.height/2);
        [viewBeforeLevel addSubview:ivBeforeBeam];
        
//        ivAfterBeam = [CreateComponentClass
//                       createImageView:viewAfterLevel.bounds
//                       image:[NSString stringWithFormat:@"%02d.png", alv]];
        ivAfterBeam = [[[OrdinaryBeamClass alloc]
                       init:viewAfterLevel.bounds.size.width/2
                       y_init:viewAfterLevel.bounds.size.height/2
                       width:viewAfterLevel.bounds.size.width
                       height:viewAfterLevel.bounds.size.height
                       level:alv]
                       getImageView];
        ivAfterBeam.center = CGPointMake(viewAfterLevel.bounds.size.width/2,
                                         viewAfterLevel.bounds.size.height/2);
        [viewAfterLevel addSubview:ivAfterBeam];
        
        //最後に数字
        tvBeforeLevel = [CreateComponentClass
                         createTextView:ivBeforeBeam.bounds
                         text:[NSString stringWithFormat:@"%d", blv]
                         font:@"AmericanTypewriter-Bold"
                         size:35
                         textColor:[UIColor whiteColor]
                         backColor:[UIColor clearColor]
                         isEditable:NO];
        tvBeforeLevel.textAlignment = NSTextAlignmentCenter;
        tvBeforeLevel.center = CGPointMake(viewBeforeLevel.bounds.size.width/2,
                                           viewBeforeLevel.bounds.size.height);
        [viewBeforeLevel addSubview:tvBeforeLevel];
        
        tvAfterLevel = [CreateComponentClass
                        createTextView:ivAfterBeam.bounds
                        text:[NSString stringWithFormat:@"%d", alv]
                        font:@"AmericanTypewriter-Bold"
                        size:35
                        textColor:[UIColor whiteColor]
                        backColor:[UIColor clearColor]
                        isEditable:NO];
        tvAfterLevel.textAlignment = NSTextAlignmentCenter;
        tvAfterLevel.center = CGPointMake(viewAfterLevel.bounds.size.width/2,
                                          viewAfterLevel.bounds.size.height);
        [viewAfterLevel addSubview:tvAfterLevel];
        
//        NSLog(@"b = %@ \n a = %@", tvBeforeLevel, tvAfterLevel);
        
        
        
        
        /*
         *effect looks like fire flower
         */
        //test
//        ViewFireWorks *viewFire = [[ViewFireWorks alloc]
//                                   initWithFrame:CGRectMake(0, 0, 20, 20)];
//        [self addSubview: viewFire];
        
        
        /*
         *kira kira
         */
//        for(int i = 0; i < 10;i++){
//            viewKiraParticle = [[KiraParticleView alloc]
//                                initWithFrame:CGRectMake(i * 30, tvTitle.frame.origin.y + tvTitle.frame.size.height/2,
//                                                         50, 50)
//                                particleType:ParticleTypeMoving];
//            [self addSubview:viewKiraParticle];
//        }
//        
//        //whole-frame-effect:kirakira=3x4interval
//        for(int i = 0; i < 3;i++){//width
//            for(int j = 0 ; j < 4 ; j++){//height
//                viewKiraParticle = [[KiraParticleView alloc]
//                                    initWithFrame:CGRectMake((i * 100) % (int)self.bounds.size.width,
//                                                             (j * 120) % (int)self.bounds.size.height, 50, 50)
//                                    particleType:ParticleTypeKilled];
//                [self addSubview:viewKiraParticle];
//            }
//        }
        
        
        
        //if tapped, remove.
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(tappedView)];
        [self addGestureRecognizer:tapGesture];
        
        
        //特殊武器経験値＆レベル
        [self dispSpecialWeapon];//未実装
        
        //自機各種ステータス
        [self dispAttribution];
        
    }
    return self;
}

-(void)tappedView{
    NSLog(@"tapped me");
    [self removeFromSuperview];
}

-(void)animViewLevelUp:(int)count originalPoint:(CGPoint)point{//ponpon
    float jumpHeight = (count%2==0)?10:-10;
    [UIView animateWithDuration:0.2f//(float)count/10//((float)10 - count)/10
                     animations:^{
                         viewLevelUp.center = CGPointMake(viewLevelUp.center.x,
                                                          viewLevelUp.center.y + jumpHeight);
                     }
                     completion:^(BOOL finished){
                         if(count == 0){
                             viewLevelUp.center = point;
                         }
                         
                         [self animViewLevelUp:(count > 0)?(count-1):9 originalPoint:point];//10,9,...,1,0,10,9,...
                     }];
}


-(void)dispAttribution{
    
    
    
    //dictionaryでは順番を制御できない
//    NSDictionary *_dictID = @{
//                              @"level":@"レベル",
//                              @"score":@"最高得点:",
//                              @"gold_max":@"最高獲得コイン:",
//                              @"time_max":@"最高飛行時間:",
//                              @"gamecnt":@"ゲーム回数:",
//                              @"gold":@"現在保有コイン:",
//                              @"ruby":@"現在保有ルビー:",
//                              @"exp_accum":@"今までの獲得経験値:",
//                              @"break_enemy":@"今までに倒した敵の数:"};
//
//    NSArray *arrId = [_dictID allKeys];
//    NSArray *arrDisp = [_dictID allValues];
//    
//    for(int i = 0;i < [arrId count];i++){
//        NSLog(@"%@", arrId[i]);
//    }
    
    
    NSArray *arrId = [NSArray arrayWithObjects:
                      @"level",
                      @"score",
                      @"gold_max",
                      @"time_max",
                      @"gamecnt",
                      @"gold",
//                      @"",
                      @"ruby",
//                      @"",
                      @"exp_accum",
//                      @"",
                      @"break_enemy",
                      
                      nil];
    //画面上に表示するラベル
    NSArray *arrDisp = [NSArray arrayWithObjects:
                        @"現在レベル:",
                        @"最高スコア:",
                        @"最高獲得コイン:",
                        @"最高飛行時間:",
                        @"ゲーム回数:",
                        @"現在保有コイン:",
//                        @"",
                        @"現在保有ルビー:",
//                        @"",
                        @"今までの獲得経験値:",
//                        @"",
                        @"今までに倒した敵の数:",
                        
//                        @"総プレイ時間:",//ユーザーがやり込みを認識してしまう可能性
                        nil];
    //横２列に配置
    int _no = 0;
    for(int row = 0;;row++){
//        for(int col = 0;col < 2;col++){//二列
        for(int col = 0; col < 1;col++){//一列
//            NSLog(@"_no = %d, row=%d, col=%d", _no, row, col);
            if(_no < [arrDisp count]){
                NSString *strValueByID = [attr getValueFromDevice:[arrId objectAtIndex:_no]];
                if([[arrId objectAtIndex:_no] isEqualToString:@""]){
                    _no++;
//                    break;//改行:next-col
                    continue;//次の位置へ
                }
                if(strValueByID == nil ||
                   [strValueByID isEqual:[NSNull null]]){
                    strValueByID = @"0";
                }
                
                NSString *strDisplay = [NSString stringWithFormat:@"%@%@",
                                        [arrDisp objectAtIndex:_no],
                                        strValueByID];
                
                UILabel *lblDisplay =
                [self getLabel:strDisplay
                        center:CGPointMake(self.bounds.size.width/4 + self.bounds.size.width/2*col,
                                           viewAfterLevel.center.y + viewAfterLevel.bounds.size.height/2 + row * 20 + 10)
                     alignment:(col==0)?NSTextAlignmentRight:NSTextAlignmentLeft];
                lblDisplay.adjustsFontSizeToFitWidth = YES;//文字長さが範囲に収まらなくなった時にサイズ調整
                lblDisplay.minimumScaleFactor = 5;//サイズ調整時の最小サイズ
                
                [self addSubview:lblDisplay];
                [self bringSubviewToFront:lblDisplay];
                
                _no++;
                
                
            }else{
                break;
            }
        }
        
        if(_no >= [arrDisp count]){
            break;
        }
    }
//    for(int i = 0; i < [arrId count]; i++){
//        NSString *strValueByID = [attr getValueFromDevice:[arrId objectAtIndex:i]];
//
//        if(strValueByID == nil ||
//           [strValueByID isEqual:[NSNull null]]){
//            strValueByID = @"0";
//        }
//        NSString *strDisplay = [NSString stringWithFormat:@"%@%@",
//                                [arrDisp objectAtIndex:i],
//                                strValueByID];
//        
//        UILabel *lblDisplay =
//        [self getLabel:strDisplay
//                center:CGPointMake(self.bounds.size.width/2,
//                                   viewAfterLevel.center.y + viewAfterLevel.bounds.size.height/2 + i/2 * 20 + 30)];
//        [self addSubview:lblDisplay];
//        [self bringSubviewToFront:lblDisplay];
//    }
    
    
}

/*
 *レベルや獲得スコア等を表示するためのラベル専用生成メソッド
 */
-(UILabel *)getLabel:(NSString *)_string center:(CGPoint)_center alignment:(NSTextAlignment)_align{
    if([_string isEqual:[NSNull null]] ||
       _string == nil){
        return nil;
    }else{
    
        UILabel *lbl =
        [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width/2-10, 20)];
//        NSLog(@"frame=%@", lbl);
        lbl.text = _string;
        lbl.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:13];
//        [lbl sizeToFit];//size alter & alignment is invalid..
        lbl.center = _center;
        lbl.textColor = [UIColor whiteColor];
        lbl.backgroundColor = [UIColor clearColor];
//        lbl.backgroundColor = [UIColor blackColor];
        lbl.textAlignment = _align;//NSTextAlignmentRight;
//        NSLog(@"%f, %@", lbl.bounds.size.width, lbl.text);
        return lbl;
        
    }
    return nil;
}

//現在装備している特殊武器の表示とレベル
-(void)dispSpecialWeapon{
    //枠を表示
    //枠内に特殊武器のイメージ添付
    //添付イメージの上にレベル、次までの経験値を記入
    //->経験値は各レベルにおける最高値は自機の半分とする？
    //獲得経験値は倒した敵の数？通常の経験値？
    
    //装備中のボウガン
    UILabel *lblSpecialWeapon =
    [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 130, 20)];
//    [lblSpecialWeapon sizeToFit];
    lblSpecialWeapon.center =
    CGPointMake(viewAfterLevel.frame.origin.x + lblSpecialWeapon.bounds.size.width/2,
                viewAfterLevel.center.y + viewAfterLevel.bounds.size.height/2 + lblSpecialWeapon.bounds.size.height/2 + 50);
    lblSpecialWeapon.text = @"装備中のボウガン";
    lblSpecialWeapon.textColor = [UIColor whiteColor];
    lblSpecialWeapon.backgroundColor = [UIColor clearColor];
    lblSpecialWeapon.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:13];
    lblSpecialWeapon.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lblSpecialWeapon];
    
    //装備中のボウガンのレベル
    UILabel *lblSpecialWeapon_LV =
    [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 130, 20)];
    //    [lblSpecialWeapon_LV sizeToFit];
    lblSpecialWeapon_LV.center =
    CGPointMake(viewAfterLevel.frame.origin.x + lblSpecialWeapon_LV.bounds.size.width/2,
                lblSpecialWeapon.center.y + lblSpecialWeapon.bounds.size.height/2 + lblSpecialWeapon_LV.bounds.size.height/2);
    lblSpecialWeapon_LV.text = @"LV. --";
    lblSpecialWeapon_LV.textColor = [UIColor whiteColor];
    lblSpecialWeapon_LV.backgroundColor = [UIColor clearColor];
    lblSpecialWeapon_LV.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:13];
    lblSpecialWeapon_LV.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lblSpecialWeapon_LV];
    
    
    //frame
    UIView *viewSpecialWeapon = [CreateComponentClass
                                 createView:CGRectMake(0, 0, 130, 130*2/3)];//width:height=3:2(specialWeapon Image size)
    viewSpecialWeapon.center =
    CGPointMake(viewAfterLevel.frame.origin.x + viewSpecialWeapon.bounds.size.width/2,
                lblSpecialWeapon_LV.center.y + lblSpecialWeapon_LV.bounds.size.height/2 + viewSpecialWeapon.bounds.size.height/2);
    [self addSubview:viewSpecialWeapon];
    
    int equippedID = [self getEquipWeaponType];
    //装備がない場合は「no-equipment」文字表示
    if(equippedID == -1){
        //weapon[?]-image
        UIImageView *ivEquippedWeapon =
        [CreateComponentClass
         createImageView:viewSpecialWeapon.bounds
         image:@"NH_WingBow.png"//[?]-image
         tag:0
         target:nil
         selector:nil];
        //少しだけ縦位置を下げる
        ivEquippedWeapon.center = CGPointMake(ivEquippedWeapon.center.x,
                                              ivEquippedWeapon.center.y + 10);
        [viewSpecialWeapon addSubview:ivEquippedWeapon];
        
        
        //no-equipment-string
        UILabel *lblNoEquip =
        [[UILabel alloc]initWithFrame:viewSpecialWeapon.bounds];
        lblNoEquip.text = @"no-equipment";
        [lblNoEquip sizeToFit];//viewSpecialWeapon.boundsの左上になる(※必ずtextを入力した後に設定する)
        lblNoEquip.center = CGPointMake(viewSpecialWeapon.bounds.size.width/2,//横位置だけ中心に揃える
                                        lblNoEquip.center.y);
        lblNoEquip.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:13];
        lblNoEquip.textAlignment = NSTextAlignmentCenter;

        lblNoEquip.textColor = [UIColor whiteColor];
        lblNoEquip.backgroundColor = [UIColor clearColor];
        
//        lblNoEquip.center = CGPointMake(viewSpecialWeapon.bounds.size.width/2, viewSpecialWeapon.bounds.size.height/2)
        [viewSpecialWeapon addSubview:lblNoEquip];
    }else{//装備されている場合は当該イメージを表示
        NSString *strImageName = [self getWeaponImageName:(BowType)equippedID];
//        UIImage *image = [UIImage imageNamed:strImageName];
        UIImageView *ivEquippedWeapon =
        [CreateComponentClass
         createImageView:viewSpecialWeapon.bounds
         image:strImageName
         tag:0
         target:nil
         selector:nil];
        [viewSpecialWeapon addSubview:ivEquippedWeapon];
        
        
        //装備中のボウガンのレベル(上記で定義しているので修正のみ)
        int lvWeapon = [[attr getValueFromDevice:[NSString stringWithFormat:@"weaponID%d_level",equippedID]] intValue];
        lblSpecialWeapon_LV.text = [NSString stringWithFormat:@"LV. %d", lvWeapon];
    }
    
    
    
}
-(int)getEquipWeaponType{
    NSString *_keyID = nil;
    for(int i = 0;i < 10;i++){
        _keyID = [NSString stringWithFormat:@"weaponID%d", i];
        if([[attr getValueFromDevice:_keyID] intValue] == 2){
            return (BowType)i;
        }
    }
    
    return -1;
}
-(NSString *)getWeaponImageName:(BowType)_bowType{
    
    //WeaponBuyListViewControllerと同じ
//    NSArray *imageArrayWithWhite = [NSArray arrayWithObjects:
//                           @"W_RockBow.png",
//                           @"W_FireBow.png",
//                           @"W_WaterBow.png",
//                           @"W_IceBow.png",
//                           @"W_BugBow.png",
//                           @"W_AnimalBow.png",
//                           @"W_GrassBow.png",
//                           @"W_ClothBow.png",
//                           @"W_SpaceBow.png",
//                           @"W_WingBow.png",
//                           nil];
//    return imageArrayWithWhite[_bowType];//BowTypeの対応の一致がズレた時修正が必要。
    switch (_bowType) {
        case BowTypeRock:
            return @"W_RockBow.png";
        case BowTypeFire:
            return @"W_FireBow.png";
        case BowTypeWater:
            return @"W_WaterBow.png";
        case BowTypeIce:
            return @"W_IceBow.png";
        case BowTypeBug:
            return @"W_BugBow.png";
        case BowTypeAnimal:
            return @"W_AnimalBow.png";
        case BowTypeGrass:
            return @"W_GrassBow.png";
        case BowTypeCloth:
            return @"W_ClothBow.png";
        case BowTypeSpace:
            return @"W_SpaceBow.png";
        case BowTypeWing:
            return @"W_WingBow.png";
        default:
            return nil;
    }
}

@end
