//
//  MyMachineClass.m
//  Shooting5
//
//  Created by 遠藤 豪 on 13/10/04.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

//defense0:barrier
//defense1:shield

#import "MyMachineClass.h"

@implementation MyMachineClass

@synthesize itemType;

int unique_id;
int wingStatus;
int effectDuration;
CGPoint _center;



NSArray *arrayLaserRImg;
NSArray *arrayLaserGImg;
NSArray *arrayLaserBImg;


//heal-relatings
UIImageView *ivHealEffect;
NSMutableArray *healEffectArray;
NSArray *imgArrayHeal;
CGRect rectHeal;
int healCompleteCount;//1回当たりの回復表示終了判定

int shieldLife;//シールドの被弾耐用回数
int shieldLifeMax;//耐用最高値：アイテム購入により変更可能


-(id) init:(int)x_init size:(int)size{
    return [self init:x_init size:size level:1];
}
-(id) init:(int)x_init size:(int)size level:(int)_level{
    return [self init:x_init size:size level:_level spWeapon:-1];
}
-(id) init:(int)x_init size:(int)size level:(int)_level spWeapon:(int)_spWeapon{
    spWeapon = _spWeapon;
    level = _level;
    
    
    effectDuration = 10;//10回アニメーション
    wingStatus = 0;//翼の状態
    unique_id++;
    
    //after initialization, mymachine is animated to move 100px bottom
    y_loc = [[UIScreen mainScreen] bounds].size.height;//center of mymachine's location
    
    x_loc = x_init;
    maxHitPoint = 10;
    laserPower = level;
    hitPoint = maxHitPoint;
    offensePower = 1;
    defensePower = 0;
    originalSize = size;
    mySize = originalSize;//モード変更によるサイズ
    bigSize = mySize * 4;
    lifetime_count = 0;
    dead_time = -1;//死亡したら0にして一秒後にparticleを消去する
    weapon0Count = 0;//攻撃力強化(爆弾投下)タイム(通常時ゼロ)
    weapon1Count = 0;//攻撃力強化(弾丸複数)タイム(通常時はゼロ)
    magnetCount = 0;
    bigCount = 0;
    bombCount = 0;
    healCount = 0;
    defense0Count = 0;
    defense1Count = 0;
    cookieCount = 0;
    shieldLife = 0;
    
    
    numOfAnother = 0;
    numOfBeam = 1;//通常時、最初はビームの数は1つ(１列)
    isAlive = true;
    explodeParticle = nil;
    damageParticle  = nil;
    
    
    //x_loc,y_loc is center point
    rect = CGRectMake(x_loc-mySize/2, y_loc-mySize/2, mySize, mySize);
    iv = [[UIImageView alloc]initWithFrame:rect];
    NSArray *imgArray = [[NSArray alloc] initWithObjects:
                         [UIImage imageNamed:@"player.png"],
                         [UIImage imageNamed:@"player2.png"],
                         [UIImage imageNamed:@"player3.png"],
                         [UIImage imageNamed:@"player4.png"],
                         [UIImage imageNamed:@"player4.png"],
                         [UIImage imageNamed:@"player3.png"],
                         [UIImage imageNamed:@"player2.png"],
                         [UIImage imageNamed:@"player.png"],
                         nil];
    iv.animationImages = imgArray;
    iv.animationRepeatCount = 0;
    iv.animationDuration = 1.0f; // アニメーション全体で1秒（＝各間隔は0.5秒）
    [iv startAnimating]; // アニメーション開始
    
    ivAnother0 = [[UIImageView alloc] initWithFrame:iv.bounds];//分身の作成
    ivAnother0.animationImages = imgArray;
    ivAnother0.animationRepeatCount = 0;
    ivAnother0.animationDuration = 1.0f;
    ivAnother0.alpha=0.5f;
    ivAnother0.center = CGPointMake(iv.bounds.size.width,
                                    iv.bounds.size.height);
    
    ivAnother1 = [[UIImageView alloc] initWithFrame:iv.bounds];
    ivAnother1.animationImages = imgArray;
    ivAnother1.animationRepeatCount = 0;
    ivAnother1.animationDuration = 1.0f;
    ivAnother1.alpha=0.5f;
    ivAnother1.center = CGPointMake(0, iv.bounds.size.height);
    arrIvAnother = [NSArray arrayWithObjects:
                    ivAnother0,
                    ivAnother1,
                    nil];
    
    //ivanotherの位置(center)はアイテム取得時のsetStatus内で定義
    
    arrayLaserRImg = [[NSArray alloc] initWithObjects:
                              [UIImage imageNamed:@"laser_r01.png"],
                              [UIImage imageNamed:@"laser_r02.png"],
                              [UIImage imageNamed:@"laser_r03.png"],
                              nil];
    
    arrayLaserGImg = [[NSArray alloc] initWithObjects:
                              [UIImage imageNamed:@"laser_g01.png"],
                              [UIImage imageNamed:@"laser_g02.png"],
                              [UIImage imageNamed:@"laser_g03.png"],
                              nil];
    arrayLaserBImg = [[NSArray alloc] initWithObjects:
                              [UIImage imageNamed:@"laser_b01.png"],
                              [UIImage imageNamed:@"laser_b02.png"],
                              [UIImage imageNamed:@"laser_b03.png"],
                              nil];
    
    //laser-relatings
    CGRect rectLaser = CGRectMake(0, 0, 200, 500);
    ivLaserR = [[UIImageView alloc] initWithFrame:rectLaser];
    ivLaserR.animationImages = arrayLaserRImg;
    ivLaserR.animationRepeatCount = 0;
    ivLaserR.animationDuration = 0.3f;
//    [ivLaserR startAnimating];
    
    ivLaserG = [[UIImageView alloc] initWithFrame:rectLaser];
    ivLaserG = [[UIImageView alloc] initWithFrame:rectLaser];
    ivLaserG.animationImages = arrayLaserGImg;
    ivLaserG.animationRepeatCount = 0;
    ivLaserG.animationDuration = 0.3f;
//    [ivLaserG startAnimating];
    
    ivLaserB = [[UIImageView alloc] initWithFrame:rectLaser];
    ivLaserB = [[UIImageView alloc] initWithFrame:rectLaser];
    ivLaserB.animationImages = arrayLaserBImg;
    ivLaserB.animationRepeatCount = 0;
    ivLaserB.animationDuration = 0.3f;
//    [ivLaserB startAnimating];
    
    //heal-relatings
    healEffectArray = [[NSMutableArray alloc]init];//1セル毎に疑似パーティクルセルを格納
    imgArrayHeal = [[NSArray alloc] initWithObjects:
                    [UIImage imageNamed:@"img03.png"],
                    [UIImage imageNamed:@"img04.png"],
                    [UIImage imageNamed:@"img05.png"],
                    [UIImage imageNamed:@"img06.png"],
                    [UIImage imageNamed:@"img07.png"],
                    [UIImage imageNamed:@"img08.png"],
                    [UIImage imageNamed:@"img09.png"],
                    [UIImage imageNamed:@"img10.png"],
                    [UIImage imageNamed:@"img11.png"],
                    nil];
    
    //defense0-relatings
//    imgArrayDefense0 = [[NSArray alloc] initWithObjects:
//                        [UIImage imageNamed:@"defense_barrier.png"],//dummy
//                        [UIImage imageNamed:@"defense_shield.png"],
//                        nil];
    
    
//    machine_type = arc4random() % 3;
    beamArray = [[NSMutableArray alloc]init];
    
    //status=GameClassのアイテム取得時と対応
//    status = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//              @"0",@"StatusWpBomb",//
//              @"0",@"StatusWpDiffuse",
//              @"0",@"StatusWpLaser",
//              @"0",@"StatusDfBarrier",
//              @"0",@"StatusDfShield",
//              @"0",@"StatusTlBomb",
//              @"0",@"StatusTlHeal",
//              @"0",@"StatusTlMagnet",
//              @"0",@"StatusTlBig",
//              @"0",@"StatusTlSmall",
//              @"0",@"StatusTlTransparancy",
//              nil];
    
//    status = [[NSMutableDictionary alloc]init];
    /*
     ItemTypeWeapon0,//0
     ItemTypeWeapon1,
     ItemTypeWeapon2,
     ItemTypeDeffense0,
     ItemTypeDeffense1,
     ItemTypeMagnet,
     ItemTypeBomb,
     ItemTypeHeal,
     ItemTypeBig,
     ItemTypeSmall,
     ItemTypeTransparency,
     ItemTypeYellowGold,
     ItemTypeGreenGold,
     ItemTypeBlueGold,
     ItemTypePurpleGold,
     ItemTypeRedGold
     */
    status = [NSMutableDictionary dictionaryWithObjectsAndKeys:
              @"0", [NSNumber numberWithInt:ItemTypeWeapon0],//0
              @"0", [NSNumber numberWithInt:ItemTypeWeapon1],
              @"0", [NSNumber numberWithInt:ItemTypeWeapon2],
              @"0", [NSNumber numberWithInt:ItemTypeDeffense0],
              @"0", [NSNumber numberWithInt:ItemTypeDeffense1],
              @"0", [NSNumber numberWithInt:ItemTypeMagnet],
              @"0", [NSNumber numberWithInt:ItemTypeBomb],
              @"0", [NSNumber numberWithInt:ItemTypeHeal],
              @"0", [NSNumber numberWithInt:ItemTypeBig],
              @"0", [NSNumber numberWithInt:ItemTypeCookie],
              @"0", [NSNumber numberWithInt:ItemTypeTransparency],
              @"0", [NSNumber numberWithInt:ItemTypeYellowGold],
              @"0", [NSNumber numberWithInt:ItemTypeGreenGold],
              @"0", [NSNumber numberWithInt:ItemTypeBlueGold],
              @"0", [NSNumber numberWithInt:ItemTypePurpleGold],
              @"0", [NSNumber numberWithInt:ItemTypeRedGold],
              nil];
    
    
    //attr情報を読み込んでフィールドを設定(上限時間)
    [self readAttrSetMaxCount];
    
    return self;
}
-(id) init{
    NSLog(@"call mymachine class ""DEFAULT"" initialization");
    return [self init:0 size:50];
}


-(void)setType:(int)_type{
    
    machine_type = _type;
}

-(void)setDamage:(int)damage location:(CGPoint)location{
    int _damage = damage;

    //バリア(defense0Count)を優先して判断
    if(defense0Count > 0){//if barrier is valid
        _damage = 0;//(damage/2==0)?1:damage/2;
        [self barrierValidEffect];
        
        return;
    }else if(shieldLife > 0 &&//バリアがなければシールドを判断
             defense1Count > 0 &&
             defense1Count != INT_MAX)//シールドが有効ならば
    {//else if shield is valid
        //この期間、自機を透明化することで被弾不可状態を明示する
        //shieldが有効でdefense1Countによるカウントダウン中：全ての攻撃は無効
        //ここで何らかのエフェクトを実行すると連続して発動してしまう

//        [self destroySheildEffect];//透明化の方が分かりやすい
        _damage = 0;
        
        return;
    }else if(defense1Count == INT_MAX){
        //defense1(shield)のみ他のカウンターと異なる：被弾してから(shieldLife回のみ)次にシールドを張るまでの時間
        //シールドは被弾した回数だけ減る(shieldLife)
        //被弾して100カウント(1秒間)はダメージを受けない
        //100カウント超過したらshieldLifeを１減らす
        if(shieldLife != 0){
            shieldLife--;
            if(shieldLife==0){
                //カウントダウンモードへの移行
                iv.alpha = 1.0f;
                [self destroySheildEffect];//シールド解除されたことを示すためのエフェクト
                [ivDefense1 removeFromSuperview];//ユーザーからの見た目ではこの瞬間にシールド解除
                defense1Count = defense1CountMax;//これによりdonextでカウントダウンが始まる
            }else{
                iv.alpha = 0.5f;
            }
        }else{
            NSLog(@"error!");
        }
        _damage = 0;
        return;
    }
    damageParticle =
    [[DamageParticleView alloc]
     initWithFrame:CGRectMake(location.x, location.y, 30, 30)];
    
    [UIView animateWithDuration:0.5f
                     animations:^{
                         [damageParticle setAlpha:0.0f];//徐々に薄く
                     }
                     completion:^(BOOL finished){
                         //終了時処理
                         [damageParticle setIsEmitting:NO];
                         [damageParticle removeFromSuperview];
                     }];
    
    
    
//    if(defensePower >= 0){
        if(hitPoint > 0){
            hitPoint -= _damage;
            if(hitPoint <= 0){
                [self die:location];
            }
        }else{
//            [self die:location];
        }
//    }else{
//        defensePower--;
//    }
}

-(int)die:(CGPoint) location{
    //爆発用パーティクルの初期化
    bomb_size = 200;
    //以下生成後、GameClassViewController側で(貼付けてから)透明化
    explodeParticle = [[ExplodeParticleView alloc] initWithFrame:CGRectMake(x_loc, y_loc, bomb_size, bomb_size)];
    isAlive = false;
    [iv removeFromSuperview];
    dead_time ++;
    return -1;
}


-(int)getHitPoint{
    return hitPoint;
}

-(Boolean) getIsAlive{
    return isAlive;
}

-(void)setSize:(int)s{
    mySize = s;
    iv.frame = CGRectMake(x_loc-mySize/2, y_loc-mySize/2, mySize, mySize);
}
-(int)getSize{
    return mySize;
}
-(void)setBeamArrayClear{
//    NSLog(@"setBeamArrayClear start");
//    for(int i = 0; i < [beamArray count] ; i++){
    for(int i = [beamArray count] - 1;i >= 0;i--){
//NSLog(@"c=%d, i=%d, a=%d, %@",[beamArray count], i, [[beamArray objectAtIndex:i]getIsAlive], [[beamArray objectAtIndex:i] getImageView].superview);
        if(![[beamArray objectAtIndex:i] getIsAlive]){
            [[[beamArray objectAtIndex:i] getImageView] removeFromSuperview];
            [beamArray removeObjectAtIndex:i];
        }
        
//        if([beamArray count] == 0){//no need
////            NSLog(@"break");
//            break;
//        }
    }
//    NSLog(@"setBeamArrayClear complete");
}


-(void)doNext{
    for(int i = 0; i < [beamArray count];i++){//ordinay & special beam
        if([[beamArray objectAtIndex:i] getIsAlive]){
            [(BeamClass *)[beamArray objectAtIndex:i] doNext];
        }else{
            //これをすると点滅
//            [[[MyMachine getBeam:i] getImageView] removeFromSuperview];
        }
    }

    //死んでいる弾丸を画面から削除して配列から削除
    [self setBeamArrayClear];
    
//    NSLog(@"donext set beam array complete");
    
    //    [iv removeFromSuperview];
    //    NSLog(@"更新前 y = %d", y_loc);
    
//    NSLog(@"%d" , lifetime_count);
    
//            NSLog(@"machine iv generated");    
//    iv = [[UIImageView alloc]initWithFrame:CGRectMake(x_loc-mySize/2, y_loc-mySize/2, mySize, mySize)];
    
//    
//    switch(machine_type){//lifetime_count%8を引数に取る？
    
    
    
    
//    switch ((int)(lifetime_count/10) % 8){//タイマーの間隔による
//        case 0:{
//            iv.image = [UIImage imageNamed:@"player.png"];
//            break;
//        }
//        case 1:{
//            iv.image = [UIImage imageNamed:@"player2.png"];
//            break;
//        }
//        case 2:{
//            iv.image = [UIImage imageNamed:@"player3.png"];
//            break;
//        }
//        case 3:{
//            iv.image = [UIImage imageNamed:@"player4.png"];
//            break;
//        }
//        case 4:{
//            iv.image = [UIImage imageNamed:@"player4.png"];
//            break;
//        }
//        case 5:{
//            iv.image = [UIImage imageNamed:@"player3.png"];
//            break;
//        }
//        case 6:{
//            iv.image = [UIImage imageNamed:@"player2.png"];
//            break;
//        }
//        case 7:{
//            iv.image = [UIImage imageNamed:@"player.png"];
//            break;
//        }
//    }
    if(magnetCount > 0){
        if(magnetCount % 100 == 0){//per 1sec
            [self healEffectWithViewKira:0.5f];//per 0.5sec
        }
        magnetCount--;
        if(magnetCount == 0){
            [status setObject:@"0" forKey:[NSNumber numberWithInt:ItemTypeMagnet]];
        }
        
    }
    if(cookieCount > 0){
        cookieCount --;
        if(cookieCount == 0){
            numOfAnother = 0;
            [status setObject:@"0" forKey:[NSNumber numberWithInt:ItemTypeCookie]];
            [arrIvAnother[0] removeFromSuperview];
            [arrIvAnother[1] removeFromSuperview];
            
            
//            NSLog(@"super of 0 = %@",[arrIvAnother[0] superview]);
//            NSLog(@"super of 0 = %@",[arrIvAnother[1] superview]);
            
            [arrIvAnother[0] stopAnimating];
            [arrIvAnother[1] stopAnimating];
            
        }
    }
    
    if(weapon0Count > 0){
        weapon0Count--;
        if(weapon0Count == 0){
            [status setObject:@"0" forKey:[NSNumber numberWithInt:ItemTypeWeapon0]];//bomb
        }
    }
    
    if(weapon1Count > 0){
        weapon1Count--;
        if(weapon1Count == 0){
            numOfBeam = 1;
            [status setObject:@"0" forKey:[NSNumber numberWithInt:ItemTypeWeapon1]];
        }
    }
    
    if(weapon2Count > 0){
        if(weapon2Count % 100 == 0){//1time in 1.0sec
            //            NSLog(@"heal");
            //            for(int i = 0; i < 30;i++){
//            [self healEffectInit:30];
//            [self healEffectRepeat];
            [self healEffectWithViewKira:0.5f];
            //            }
        }
        weapon2Count--;
        if(weapon2Count <= 0){
            numOfBeam = 1;
            [ivLaserR stopAnimating];
            [ivLaserR removeFromSuperview];
            [status setObject:@"0" forKey:[NSNumber numberWithInt:ItemTypeWeapon2]];
        }
    }
    
    if(bigCount > 0){
        bigCount--;
        if(bigCount == 0){
            mySize = originalSize;
            iv.frame = CGRectMake(x_loc-mySize/2, y_loc-mySize/2, mySize, mySize);
            [status setObject:@"0" forKey:[NSNumber numberWithInt:ItemTypeBig]];
        }
    }
    
    if(bombCount > 0){
        bombCount--;
        if(bombCount == 0){
            [status setObject:@"0" forKey:[NSNumber numberWithInt:ItemTypeBomb]];
        }
    }else{
        
    }
    
    if(defense0Count > 0){
        defense0Count--;
        if(defense0Count == 0){
            [self barrierValidEffect];
            [ivDefense0 removeFromSuperview];
            [status setObject:@"0" forKey:[NSNumber numberWithInt:ItemTypeDeffense0]];
        }
    }

    //shieldは一度敵に当たれば破壊されるため、setDamageで解除設定を実行
    //本番中では接触判定が0.01secで行われるので一定期間(defense1CountMax)被弾不可状態を維持する必要がある
    //shield取得後、defense1Countをint_maxに設定
    //ダメージ被弾時(setDamage:)において、ダメージ耐用回数(アイテム購入により変更可能)までは被弾してもダメージを受けない
    //耐用回数を超えて被弾したらdestroyShieldEffectを実行して、以下のコードによりshieldを解除
    if(defense1Count == INT_MAX){//シールドモード(着弾なし)
//    if(defense1Count == INT_MAX){
        //do nothing
    }else if(defense1Count > 0 && defense1Count <= defense1CountMax){//シールドモード(着弾後、シールド解除までのカウントダウン中)
        //現在被弾不可状態であることを示すためシールドの解除少し前まで透明化
        if(defense1Count == defense1CountMax-1){//処理速度を考慮して何度もalpha設定を繰り返さないために
            iv.alpha = 0.5f;
        }else if(defense1Count == 50){
            iv.alpha = 1.0f;
        }
        defense1Count--;
        if(defense1Count == 0){
            iv.alpha = 1.0f;
            shieldLife--;
            if(shieldLife == 0){
                [self barrierValidEffect];
                [ivDefense1 removeFromSuperview];
                [status setObject:@"0" forKey:[NSNumber numberWithInt:ItemTypeDeffense1]];
            }else{
                defense1Count = defense1CountMax;
            }
        }
    }
    
    if(healCount > 0){
        //gameView側で実行
//        NSLog(@"healcount = %d", healCount);
        if(healCount % 150 == 0){//1time in 1.5sec
//            NSLog(@"heal");
//            for(int i = 0; i < 30;i++){
//            [self healEffectInit:30];
//            [self healEffectRepeat];
            [self healEffectWithViewKira:0.5f];
//            }
        }
        if(hitPoint < maxHitPoint){
            hitPoint++;
        }
        healCount--;
    }else{
//        [ivHealEffect removeFromSuperview];
        [status setObject:@"0" forKey:[NSNumber numberWithInt:ItemTypeHeal]];
    }
    
    if(transparancyCount > 0){
        transparancyCount--;
        if(transparancyCount == 300){//3sec
            //点滅
            [self flashImageView:0.3 repeatCount:5];
        }else if(transparancyCount == 150){
            //速い点滅
            [self flashImageView:0.1 repeatCount:15];
        }else if(transparancyCount == 50){
//            [self healEffectInit:10];//transparancy-exit
//            [self healEffectRepeat];
            [self healEffectWithViewKira:0.5f];

        }
    }else{
        iv.alpha = 1.0f;
        [status setObject:@"0" forKey:[NSNumber numberWithInt:ItemTypeTransparency]];
    }
    
    lifetime_count ++;
    if(!isAlive){
        dead_time ++;
//        NSLog(@"dead = %d", dead_time);
    }
    
    
//    NSLog(@"complete donext");
}

-(int) getDeadTime{
    return dead_time;
}
-(void) setLocation:(CGPoint)loc{
    x_loc = (int)loc.x;
    y_loc = (int)loc.y;
}

-(void)setX:(int)x{
    x_loc = x;
}
-(void)setY:(int)y{
    y_loc = y;
}

-(CGPoint) getLocation{
    return CGPointMake((float)x_loc, (float)y_loc);
}

-(int) getX{
    return x_loc;
}

-(int) getY{
    return y_loc;
}

-(UIImageView *)getImageView{
    return iv;
}

-(ExplodeParticleView *)getExplodeParticle{
    //dieしていれば爆発用particleは初期化されているはず=>描画用クラスで描画(self.view addSubview:particle);
//    [explodeParticle setType:0];//自機用パーティクル設定
    [explodeParticle setColor:ExplodeParticleTypeRedFire];
    
    return explodeParticle;
}
-(DamageParticleView *)getDamageParticle{
    //dieしていれば爆発用particleは初期化されているはず=>描画用クラスで描画(self.view addSubview:particle);
    return damageParticle;
}

-(Boolean)yieldBeam:(int)beam_type init_x:(int)x init_y:(int)y{
//    NSLog(@"beam count = %d", [beamArray count]);
//    NSLog(@"start yield beam at weapon2count : %d", weapon2Count);
    if(weapon2Count == 0){
//        NSLog(@"start yield beam");
        //    BeamClass *beam = [[BeamClass alloc] init:x y_init:y width:50 height:50];
        //ビーム配列は先入先出(FIFO)
        /*
         *1列の場合は０が中心位置に、２列の場合は０が左、１が右、３列の場合、０が左、１が中心、２が右
         */
        int _beamSize = 50;
        //specialBeam
        if(spWeapon != -1){//spWeapon=type(-code) of special weapon
            //左側
            [beamArray insertObject:[[SpecialBeamClass alloc] init:x - _beamSize/2 y_init:y width:_beamSize height:_beamSize type:spWeapon] atIndex:0];
            //右側
            [beamArray insertObject:[[SpecialBeamClass alloc] init:x + _beamSize/2 y_init:y width:_beamSize height:_beamSize type:spWeapon] atIndex:0];
        }
    
        
        
        //ordinaryBeam
        switch (numOfBeam) {//ビーム列毎にビーム位置を変える
            case 1:{
                [beamArray insertObject:[[OrdinaryBeamClass alloc] init:x
                                                                 y_init:y
                                                                  width:_beamSize
                                                                 height:_beamSize
                                                                  level:level]
                                atIndex:0];//全て最初に格納
                //分身のビーム
                if(cookieCount > 0){
                    for(int i = 0; i < numOfAnother;i++){
                        [beamArray insertObject:
                         [[OrdinaryBeamClass alloc]
                          init:x+((UIImageView *)arrIvAnother[i]).center.x-iv.bounds.size.width/2
                          y_init:y+((UIImageView *)arrIvAnother[i]).center.y-iv.bounds.size.height/2
                                    width:_beamSize
                                    height:_beamSize
                                    level:level]
                          atIndex:0];
                    }
                }
                break;
            }
            case 2:{
                
                for(int i = 0; i < numOfBeam;i++){
                    [beamArray insertObject:[[OrdinaryBeamClass alloc] init:x+(20*pow(-1,i+1))//(30*(-1)^i)
                                                                     y_init:y
                                                                      width:_beamSize
                                                                     height:_beamSize
                                                                      level:level]
                                    atIndex:0];//全て最初に格納
                    //分身のビーム
                    if(cookieCount > 0){
                        for(int i = 0; i < numOfAnother;i++){
                            [beamArray insertObject:
                             [[OrdinaryBeamClass alloc]
                              init:x+((UIImageView *)arrIvAnother[i]).center.x-iv.bounds.size.width/2+(20*pow(-1,i+1))
                              y_init:y+((UIImageView *)arrIvAnother[i]).center.y-iv.bounds.size.height/2
                              width:_beamSize
                              height:_beamSize
                              level:level]
                                            atIndex:0];
                        }
                    }
                }
                break;
            }
            case 3:{
                
                for(int i = 0; i < numOfBeam;i++){
                    [beamArray insertObject:[[OrdinaryBeamClass alloc] init:x+40*(i-1)//30*(i-1)
                                                                     y_init:y
                                                                      width:_beamSize
                                                                     height:_beamSize
                                                                      level:level]
                                    atIndex:0];//全て最初に格納
                    //分身のビーム
                    if(cookieCount > 0){
                        for(int i = 0; i < numOfAnother;i++){
                            [beamArray insertObject:
                             [[OrdinaryBeamClass alloc]
                              init:x+((UIImageView *)arrIvAnother[i]).center.x-iv.bounds.size.width/2+40*(i-1)
                              y_init:y+((UIImageView *)arrIvAnother[i]).center.y-iv.bounds.size.height/2
                              width:_beamSize
                              height:_beamSize
                              level:level]
                                            atIndex:0];
                        }
                    }
                }
                break;
            }
        }
        
        return true;

//    [beamArray addObject:beam];
//    if([beamArray count] > 10){
////        最後のビームを削除
//        [[[beamArray lastObject] getImageView] removeFromSuperview];
//        [beamArray removeLastObject];
////        [beamArray addObject:beam];
//    }
//        
//        [self setBeamArrayClear];
//    }else{//レーザーモードの時、なぜか一つだけ弾丸が消えない
//        for(int i = 0; i < [beamArray count] ; i++){
//            NSLog(@"c=%d, i=%d, a=%d, %@",[beamArray count], i, [[beamArray objectAtIndex:i]getIsAlive], [[beamArray objectAtIndex:i] getImageView].superview);
//            [[beamArray objectAtIndex:i] die];
//            if(![[beamArray objectAtIndex:i] getIsAlive]){
//                [[[beamArray objectAtIndex:i] getImageView] removeFromSuperview];
//                [beamArray removeObjectAtIndex:i];
//            }
//            
//            if([beamArray count] == 0){
//                NSLog(@"break");
//                break;
//            }
//        }
        
//        for(int i = [beamArray count]-1; i >= 0; i--){
//            NSLog(@"%d, %d, %@", i, [[beamArray objectAtIndex:i]getIsAlive], [[beamArray objectAtIndex:i] getImageView].superview);
//            if(![[beamArray objectAtIndex:i] getIsAlive]){
//                NSLog(@")
            
//            NSLog(@"%d, %d", i, [[beamArray objectAtIndex:i]getIsAlive]);
//            [[beamArray objectAtIndex:i] die];
//            if(![[beamArray objectAtIndex:i] getIsAlive]){
////                [[beamArray objectAtIndex:i] die];
//                NSLog(@"removeView");
//                [[[beamArray objectAtIndex:i] getImageView] removeFromSuperview];
//                NSLog(@"removeObject");
//                [beamArray removeObjectAtIndex:i];
//                NSLog(@"remove complete");
//            }
//            
//            if([beamArray count] == 0){
//                break;
//            }
//        }
//        [beamArray removeAllObjects];
    }
    
    return false;
    
}

-(BeamClass *)getBeam:(int)i{
    return (BeamClass *)[beamArray objectAtIndex:i];
}

-(int)getBeamCount{
    return [beamArray count];
}

-(int)getAliveBeamCount{
    int c = 0;
    for(int i = 0;i < [beamArray count];i++){
        if([[beamArray objectAtIndex:i] getIsAlive]){
            c ++;
        }
    }
    return c;
}

-(void)setOffensePow:(int)_power{
    offensePower = _power;
}

-(void)setDefensePow:(int)_power{
    defensePower = _power;
}

-(int)getStatus:(ItemType)_statusKey{
    NSString *returnStr = [status objectForKey:[NSNumber numberWithInt:_statusKey]];
    return [returnStr integerValue];
}
//edit status
-(void)setStatus:(NSString *)statusValue key:(ItemType)_statusKey{
    itemType = _statusKey;
    
//    NSLog(@"status: %@, key: %d", statusValue, itemType);
    [status setObject:statusValue forKey:[NSNumber numberWithInt:itemType]];
    
    
    
    //    iv.alpha = 0.1f;
    //    [UIView animateWithDuration:10.0f
    //                     animations:^{
    //                         iv.alpha = 0.6f;
    //                     }
    //                     completion:^(BOOL finished){
    //                         iv.alpha = 1.0f;
    //                     }];
    
    
    switch(_statusKey){
            
        case ItemTypeMagnet:{
            if([statusValue integerValue]){
                magnetCount = magnetCountMax;
            }else{
                magnetCount = 0;
            }
            break;
        }
        case ItemTypeBig:{
            if([statusValue integerValue]){
                
                //bigger
                bigCount = bigCountMax;
                mySize = bigSize;
                iv.frame = CGRectMake(x_loc-mySize/2, y_loc-mySize/2, mySize, mySize);
            }else{
                mySize = originalSize;
                iv.frame = CGRectMake(x_loc-mySize/2, y_loc-mySize/2, mySize, mySize);
            }
//            [UIView animateWithDuration:10.0f
//                             animations:^{
//                                 iv.frame = CGRectMake(x_loc-bigSize/2, y_loc-bigSize/2, bigSize, bigSize);
//                             }
//                             completion:^(BOOL finished){
//                                 //original size
//                                 iv.frame = CGRectMake(x_loc-originalSize/2, y_loc-originalSize/2, originalSize, originalSize);
//                             }];
            break;
        }
        case ItemTypeBomb:{
            if([statusValue integerValue]){
                bombCount = bombCountMax;//爆弾アイテムを取得した瞬間に爆発(連続して取得できないようにステータス時間は短め)
            }else{
                bombCount = 0;
            }
            break;
        }
        case ItemTypeDeffense0:{
            if([statusValue integerValue]){
                defense0Count = defense0CountMax;
                [self defense0Effect];//addSubview simultaneously
            }else{
                defense0Count = 0;
            }
            break;
        }
        case ItemTypeDeffense1:{
            if([statusValue integerValue]){
                shieldLife = shieldLifeMax;
                defense1Count = INT_MAX;//時間で減らずに被弾時に減少する
                [self defense1Effect];
            }else{
                shieldLife = 0;
                defense1Count = 0;
            }
            break;
        }
        case ItemTypeHeal:{//tlHeal
            if([statusValue integerValue]){
                healCount = healCountMax;
            }else{
                healCount = 0;
            }
            break;
        }
        case ItemTypeCookie:{
            if([statusValue integerValue]){
                if(numOfAnother < 2){//0(=ordinary),1=>1,2
                    cookieCount = cookieCountMax;
                    numOfAnother++;
                    //分身を作成
                    [iv addSubview:arrIvAnother[numOfAnother-1]];
                    [arrIvAnother[numOfAnother-1] startAnimating];
                }
                
            }else{
                cookieCount = 0;
                numOfAnother = 0;
            }
            break;
        }
        case ItemTypeTransparency:{
            if([statusValue integerValue]){
                transparancyCount = transparancyCountMax;
                iv.alpha = 0.2f;
            }else{
                transparancyCount = 0;
            }
            break;
        }
        case ItemTypeWeapon0:{//wpBomb:throwing bomb
            if([statusValue integerValue]){
                weapon0Count = weapon0CountMax;
            }else{
                weapon0Count = 0;
            }
            break;
        }
        case ItemTypeWeapon1:{//wpDiffuse
            //ビームが３列になるまでは追加取得可能(新規取得する毎にカウンターが初期化)
            if([statusValue integerValue]){
//                NSLog(@"nB=%d", numOfBeam);
                if(numOfBeam < 3){
//                    NSLog(@"++ nB=%d", numOfBeam);
                    weapon1Count = weapon1CountMax;
                    numOfBeam++;//max:3
                }
            }else{
                weapon1Count = 0;
                numOfBeam = 1;
            }
            break;
        }
        case ItemTypeWeapon2:{//wpLaser:red
            
            if([statusValue integerValue]){
                weapon2Count = weapon2CountMax;
//                [self doNext];//?
                numOfBeam = 0;
                //弾丸を全て削除
                for(int i = 0 ;i < [beamArray count];i++){
                    [(BeamClass *)[beamArray objectAtIndex:i] die];
                }
                
                [iv addSubview:ivLaserR];
                [ivLaserR startAnimating];
//                ivLaserR.center = CGPointMake(viewMyEffect.bounds.size.width/2,-[MyMachine getLaserImageView].bounds.size.height/2 + 40);
                ivLaserR.center = CGPointMake(mySize/2, -ivLaserR.bounds.size.height/2 + 40);
//                [self setBeamArrayClear];
            }else{
                numOfBeam = 1;
                weapon2Count = 0;
            }
            break;
        }
        default:
            break;
    }
}


-(int)getNumOfAnother{
    return numOfAnother;
}
/*
 *本体のビーム数：分身は含めない
 */
-(int)getNumOfBeam{
    
    return numOfBeam;
}

-(void)defense0Effect{

    ivDefense0 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mySize, mySize)];
    ivDefense0.center = CGPointMake(mySize/2, mySize/2);
//    ivDefense0.animationImages = imgArrayDefense0;
    ivDefense0.image = [UIImage imageNamed:@"defense_barrier.png"];
    ivDefense0.alpha = 0.5f;
//    ivDefense0.animationDuration = 1.0f;
//    ivDefense0.animationRepeatCount = 0;
//    [ivDefense0 startAnimating];
    
    [iv addSubview:ivDefense0];
    
//    NSLog(@"defense0 mode complete");
}

-(void)defense1Effect{
    ivDefense1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mySize, mySize)];
    ivDefense1.center = CGPointMake(mySize/2, mySize/2);
//    ivDefense1.animationImages = imgArrayDefense0;
    ivDefense1.image = [UIImage imageNamed:@"defense_shield.png"];
    ivDefense1.alpha = 0.5f;
//    ivDefense1.animationDuration = 1.0f;
//    [ivDefense1 startAnimating];
    
    [iv addSubview:ivDefense1];
}


//未使用＝＞healEffectInit＆healEffectRepeatの代用
//arg:描画タイム
//-(void)healEffectWithViewKira:(int)numCell{
-(void)healEffectWithViewKira:(float)_secAnimate{
    NSLog(@"healeffectiwithviewkira size = %d", mySize);
    
    KiraType _kiraType = KiraTypeRed;//デフォルトは青
    if(magnetCount > 0){//マグネットモードのときは優先的に青
        _kiraType = KiraTypeBlue;
    }else if(healCount > 0){//healモードのときは優先的に緑
        _kiraType = KiraTypeGreen;
    }else if(defense1Count > 0){
        _kiraType = KiraTypeYellow;
    }else if(transparancyCount > 0){
        _kiraType = KiraTypeBlue;
    }
    ViewKira *viewKira =
    [[ViewKira alloc]
    initWithFrame:CGRectMake(0, 0, mySize, mySize)
            type:KiraTypeRed
            image:@"krkr_many.png"];
    viewKira.alpha = 1.0f;
    [iv addSubview:viewKira];
    [iv bringSubviewToFront:viewKira];
    [UIView animateWithDuration:_secAnimate
                     animations:^{
                         viewKira.center = CGPointMake(viewKira.center.x +
                                                       pow(-1, arc4random()%2) * (arc4random() % (int)(viewKira.bounds.size.width/4)),
                                                       viewKira.center.y + viewKira.bounds.size.height/2);
                         viewKira.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         if(finished){
                             [viewKira removeFromSuperview];
                         }
                     }];
    
    //検証結果＝メモリリークのため実行してはいけない：描画を何度も実行してremoveできていないviewKiraが存在し、他のアニメーションに影響
//    for(int i = 0;i < numCell;i++){
//        viewKira =
//        [[ViewKira alloc]
//         initWithFrame:CGRectMake(0,0,
//                                  originalSize/30, originalSize/30)
//         type:KiraTypeRed];
//        viewKira.center = CGPointMake(mySize/4 + arc4random() % mySize/2,
//                                      arc4random() % mySize/4);
//        [iv addSubview:viewKira];
//        [iv bringSubviewToFront:viewKira];
//        
//        [UIView animateWithDuration:0.5f
//                              delay:0.0
//                            options:UIViewAnimationOptionCurveLinear
//                         animations:^{
//                             viewKira.center = CGPointMake(viewKira.center.x + arc4random()%originalSize/2,
//                                                           viewKira.center.y + mySize*4/5+arc4random()%mySize/2);
//                             viewKira.alpha = 0.7f;
//                             CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/4);
//                             viewKira.transform = transform;//...ok?
//                         }
//                         completion:^(BOOL finished){
//                             
//                             if(finished){
//                                 [viewKira removeFromSuperview];
//                                 NSLog(@"view kira finished : %d", i);
//                             }
//                         }];
        //上記で設定したUIImageViewを配列格納
//        [self.view addSubview:ivItemAcq];
//        [self.view bringSubviewToFront:ivItemAcq];
//    }
}

//arg:降らせる星の数
-(void)healEffectInit:(int)numCell{
    
//    NSLog(@"healeffect init");
    healCompleteCount = 0;
    for(int i = 0; i < numCell;i++){
        //回復時アニメーション->frame:主人公の左上起点基準
//        int y = - (arc4random() % originalSize);
//        NSLog(@"y = %d", y);
        rectHeal= CGRectMake(0,//- (arc4random() % originalSize),//左端
                             0,//- (arc4random() % originalSize),//上端
                             arc4random() % originalSize, arc4random() % originalSize);
        ivHealEffect = [[UIImageView alloc] initWithFrame:rectHeal];
        ivHealEffect.center = CGPointMake(mySize/4 + (arc4random() % (mySize/2)),//中心付近から
                                          arc4random() % (mySize/2));//上端付近から(降下)
//        ivHealEffect.center = CGPointMake(0, 0);//test;zero-start
        ivHealEffect.animationImages = imgArrayHeal;
        ivHealEffect.animationRepeatCount = 0;
        ivHealEffect.alpha = MIN(exp(((float)(arc4random() % 100))*4.0f / 100.0f - 1),1);//0-1の指数関数(１の確率が４分の３)
        ivHealEffect.animationDuration = 1.0f; // アニメーション全体で1秒（＝各画像描画間隔は「枚数」分の１秒）
        [ivHealEffect startAnimating]; // アニメーション開始!!(アイテム取得時に実行)
        
        //上記で設定したUIImageViewを配列格納
        [healEffectArray addObject:ivHealEffect];
        
        //格納されたUIImageViewを描画
        [iv addSubview:[healEffectArray objectAtIndex:i]];
    }
}

-(void)healEffectRepeat{
    /*
     *同時に全ての配列に格納されたセルを降らせる
     */
//    NSLog(@"healeffect repeat");
    int x0, y0, moveX, moveY;
    for(int i = 0; i < [healEffectArray count];i++){
        x0 = ((UIImageView*)[healEffectArray objectAtIndex:i]).center.x;
        y0 = ((UIImageView*)[healEffectArray objectAtIndex:i]).center.y;
        moveX = arc4random() % mySize/4 - mySize/4;//変化量は全体の±1/4
        //移動距離には熱関数を使い、かつy0が小さい程、移動を大きくする(温度係数を2にする):２分の１の確率でmySize移動
        moveY = mySize * MIN(exp(((float)(arc4random() % 100))*2.0f / 100.0f - 1), 1);
        
        //test:move
//        moveX = mySize/2;
//        moveY = mySize/2;
        [UIView animateWithDuration:0.8f * MIN(exp(((float)(arc4random()%10))*4.0f/10.0f-1), 1.0f)//0.4f
                              delay:0.2f*exp((float)(arc4random()%10)/10.0f-1)//((float)(arc4random() % 10) /10.0f)//max0.1
//                            options:UIViewAnimationOptionCurveLinear
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             ((UIImageView*)[healEffectArray objectAtIndex:i]).center = CGPointMake(x0 + moveX, y0 + moveY);//down
//                             ((UIImageView*)[healEffectArray objectAtIndex:i]).center = CGPointMake(0,  0);//down

                             ((UIImageView*)[healEffectArray objectAtIndex:i]).alpha = 0.0f;
                         }
                         completion:^(BOOL finished){
                             if(finished){
                                 healCompleteCount++;
                                 [[healEffectArray objectAtIndex:i] removeFromSuperview];
//                                 [healEffectArray removeObjectAtIndex:i];
                                 if(healCompleteCount == [healEffectArray count]){//最後完了後
                                     [healEffectArray removeAllObjects];
                                 }

                                 
//                                 int x1 = ((UIImageView*)[healEffectArray objectAtIndex:i]).center.x;
//                                 int y1 = ((UIImageView*)[healEffectArray objectAtIndex:i]).center.y;
//                                 int x2 = ((CALayer *)[((UIImageView*)[healEffectArray objectAtIndex:i]).layer presentationLayer]).position.x;
//                                 int y2 =((CALayer *)[((UIImageView*)[healEffectArray objectAtIndex:i]).layer presentationLayer]).position.y;
//                                 NSLog(@"x = %d-> %d, y = %d->%d", x1, x2, y1, y2);
                                 
//                                 //次のアニメーションを描画しようとしても番号iが既に削除されていることがあり、
//                                 //削除出来なかったり、out of index exceptionエラーになるので断念。
                                 
//                                 [UIView animateWithDuration:0.2f
//                                                  animations:^{
//                                                      ((UIImageView*)[healEffectArray objectAtIndex:i]).alpha = 0.0f;
//                                                      
//                                                      ((UIImageView*)[healEffectArray objectAtIndex:i]).center = CGPointMake(x0 + moveX*6/4, y0 + moveY*6/4);//down
//                                                  }
//                                                  completion:^(BOOL finished2){
//                                                      if(finished2){
//                                                          if(i < [healEffectArray count]){
//                                                              
//                                                              [[healEffectArray objectAtIndex:i] removeFromSuperview];
//                                                              [healEffectArray removeObjectAtIndex:i];
//                                                          }
//                                                      }
//                                                  }
//                                  ];
                                 
                             }
                         }];
    }
    
    
//    ivHealEffect = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, originalSize, originalSize)];
    
//    ivHealEffect.animationImages = imgArrayHeal;
//    ivHealEffect.animationRepeatCount = 0;
//    ivHealEffect.animationDuration = 0.3f; // アニメーション全体で1秒（＝各間隔は0.5秒）
    
//    ivHealEffect.center = CGPointMake(arc4random() % mySize, 0);
//    ivHealEffect.alpha = 1.0f;
//    [iv addSubview:ivHealEffect];
//    [ivHealEffect startAnimating];
    //アニメーション:回復は緑系で上昇の方が良い？
//    [UIView animateWithDuration:0.8f//random?
//                     animations:^{
//                         ivHealEffect.center = CGPointMake(arc4random() % mySize - mySize/2, mySize);//down
//                         ivHealEffect.alpha = 0.5f;
//                     }
//                     completion:^(BOOL finished){
//                         if(finished){
//                             [ivHealEffect removeFromSuperview];
//                             if(repeatCount > 0){
////                                 NSLog(@"repeatcount = %d", repeatCount);
//                                 [self healEffectRepeat:repeatCount-1];
//                             }
//                         }
//                     }];
}


//myMachineクラス内で直接ivにaddsiているため、外部からのアクセス不必要にしたので、以下メソッド使用せず
-(UIImageView *)getLaserImageView{
    if(weapon2Count > 0){
        return ivLaserR;
    }else if(weapon3Count > 0){
        return ivLaserG;
    } else if(weapon4Count > 0){
        return ivLaserB;
    }
    return nil;
}

//transparant-mode
-(void)flashImageView:(float)duration repeatCount:(int)count{
    float newAlpha = (iv.alpha>0.9)?0.2f:1.0f;
    
    [UIView animateWithDuration:duration
                     animations:^{
                         iv.alpha = newAlpha;
                     }
                     completion:^(BOOL finished){
                         if(count > 0){
                             [self flashImageView:duration repeatCount:count-1];
                         }
                     }];
}

-(int)getLaserPower{
    return laserPower;
}

-(BeamType)getSpWeapon{
    return spWeapon;
}

-(ViewExplode *)getExplodeEffect{
    viewExplode = [[ViewExplode alloc] initWithFrame:CGRectMake(x_loc, y_loc, 50, 50)
                                                type:ExplodeTypeRed];
    viewExplode.center = CGPointMake(x_loc, y_loc);
    [viewExplode explode:120 angle:30 x:x_loc y:y_loc];
    return viewExplode;
}


//if shield is destroyed
-(void)destroySheildEffect{
    NSLog(@"destroy shield effect");
    int _sizeEffect = originalSize;
    ViewKira *viewKiraDestroy = [[ViewKira alloc]
                           initWithFrame:CGRectMake(0, 0, _sizeEffect/2, _sizeEffect/2)
                           type:KiraTypeYellow];
    viewKiraDestroy.center = CGPointMake(mySize/2, mySize/2);
    viewKiraDestroy.alpha = 1.0f;
    
    [UIView animateWithDuration:0.3f
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         viewKiraDestroy.frame = CGRectMake(0, 0, _sizeEffect*5, _sizeEffect*5);
                         viewKiraDestroy.center = CGPointMake(_sizeEffect/2, _sizeEffect/2 - _sizeEffect*4/5);//OBJECT_SIZE/2, -OBJECT_SIZE);
                         viewKiraDestroy.alpha = 1.0f;
                         CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/2);
                         viewKiraDestroy.transform = transform;//...ok?
                     }
                     completion:^(BOOL finished){
                         
                         if(finished){
                             [UIView animateWithDuration:0.2f
                                                   delay:0.0
                                                 options:UIViewAnimationOptionCurveLinear
                                              animations:^{
                                                  //add rotation
                                                  CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
                                                  viewKiraDestroy.transform = transform;//...ok?
                                                  viewKiraDestroy.center = CGPointMake(_sizeEffect/2,
                                                                                       _sizeEffect/2 - _sizeEffect);
                                                  viewKiraDestroy.alpha = 0.1f;
                                              }
                                              completion:^(BOOL finished){
                                                  
                                                  if(finished){
                                                      [viewKiraDestroy removeFromSuperview];
                                                  }
                                              }];
                         }
                     }];
    //上記で設定したUIImageViewを配列格納
    [iv addSubview:viewKiraDestroy];
    [iv bringSubviewToFront:viewKiraDestroy];
    
}

-(void)barrierValidEffect{//バリアで攻撃を防いだ時&消滅時のエフェクト
    int _sizeEffect = originalSize;
    ViewKira *viewKiraBarrier = [[ViewKira alloc]
                                 initWithFrame:CGRectMake(0, 0, _sizeEffect/2, _sizeEffect/2)
                                 type:KiraTypeBlue];
    viewKiraBarrier.center = CGPointMake(_sizeEffect/2, _sizeEffect/2);
    viewKiraBarrier.alpha = 1.0f;
    
    [UIView animateWithDuration:0.3f
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         viewKiraBarrier.frame = CGRectMake(0, 0, _sizeEffect*2, _sizeEffect*2);
                         viewKiraBarrier.center = CGPointMake(_sizeEffect/2, _sizeEffect/2 - _sizeEffect*4/5);//OBJECT_SIZE/2, -OBJECT_SIZE);
                         viewKiraBarrier.alpha = 1.0f;
                         CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/2);
                         viewKiraBarrier.transform = transform;//...ok?
                     }
                     completion:^(BOOL finished){
                         
                         if(finished){
                             [UIView animateWithDuration:0.2f
                                                   delay:0.0
                                                 options:UIViewAnimationOptionCurveLinear
                                              animations:^{
                                                  //add rotation
                                                  CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
                                                  viewKiraBarrier.transform = transform;//...ok?
                                                  viewKiraBarrier.center = CGPointMake(_sizeEffect/2,
                                                                                       _sizeEffect/2 - _sizeEffect);
                                                  viewKiraBarrier.alpha = 0.1f;
                                              }
                                              completion:^(BOOL finished){
                                                  
                                                  if(finished){
                                                      [viewKiraBarrier removeFromSuperview];
                                                  }
                                              }];
                         }
                     }];
    //上記で設定したUIImageViewを配列格納
    [iv addSubview:viewKiraBarrier];
    [iv bringSubviewToFront:viewKiraBarrier];
    
}

/*
 *購入アイテムの読み込み
 */
-(void)readAttrSetMaxCount{
    
    //all "Max"-field-initialization
    
    magnetCountMax = 200;
    weapon0CountMax = 500;//爆弾投下時間
    weapon1CountMax = 500;//通常弾強化時間
    weapon2CountMax = 500;//レーザー発射時間
    weapon3CountMax = 500;
    weapon4CountMax = 500;
    defense0CountMax = 500;//barrier
    //defense1(shield)のみ他のカウンターと異なる：被弾してから(shieldLife回のみ)次にシールドを張るまでの時間
    //シールドは被弾した回数だけ減る(shieldLife)
    //被弾して100カウント(1秒間)はダメージを受けない
    //100カウント超過したらshieldLifeを１減らす
    defense1CountMax = 100;//被弾して100カウント(1秒間)はダメージを受けない
    shieldLifeMax = 1;//setting at [self readAttrSetMaxCount]
    transparancyCountMax = 500;
    bigCountMax = 500;
    bombCountMax = 500;
    healCountMax = 500;
    cookieCountMax=500;
    
    

    
    
    
    
    AttrClass *_attr = [[AttrClass alloc]init];
    
    //defense
//    @"itemlistShield0",
//    @"itemlistShield1",
//    @"itemlistBarrier0",
//    @"itemlistBomb1",
//    @"次回以降全てのゲームにおいて、シールドアイテム獲得後の耐久回数を現状に+1上乗せする。\n15枚のコインが必要です。",//1=10coin
//    @"1回のゲームにのみ、シールドアイテム獲得後のダメージ耐久回数を現状の２倍に長持ちさせる。\n18枚のコインが必要です。",//1=9coin
//    @"次回以降全てのゲームにおいて、バリアアイテム獲得後の耐久時間を現状に0.5秒上乗せする。\n24枚のコインが必要です。",//1=8coin
//    @"1回のゲームにのみ、バリアアイテム獲得後の耐久時間を現状の２倍に長持ちさせる。\n28枚のコインが必要です。",//1=7coin
    
    
    //整理：defense0=barrier , defense1=shield
    
    //strKeyShieldは別の場所にグローバルに設定してDefenseUpListViewControllerからも同じ値が読み込まれるように設定すべき
    
    //itemlistShield0の設定＝@"次回以降全てのゲームにおいて、シールドアイテム(ItemTypeDeffense1)獲得後の耐久回数を現状に+1上乗せ
    //attrフィールドの読み込みあり、attrフィールドへの新規設定なし
    NSString *strKeyShield0 = @"itemlistShield0";
    int valueShield0 = [[_attr getValueFromDevice:strKeyShield0] integerValue];
    for(int _valueAttr = 0; _valueAttr < valueShield0; _valueAttr++){
        shieldLifeMax++;
    }
    NSLog(@"shieldLifeMaxを%dに設定", shieldLifeMax);
    
    
    //itemlistShield1の設定＝@"1回のゲームにのみ、シールドアイテム獲得後のダメージ耐久回数を現状の２倍に長持ちさせる
    //attrフィールドの読み込みあり、attrフィールドへの新規設定あり(−１消耗させる)
    NSString *strKeyShield1 = @"itemlistShield1";
    int valueShield1 = [[_attr getValueFromDevice:strKeyShield1] integerValue];
    if(valueShield1 > 0){
        shieldLifeMax *= 2;
        
        //消耗
        [_attr setValueToDevice:strKeyShield1
                       strValue:[NSString stringWithFormat:@"%d", valueShield1-1]];
    }
    NSLog(@"shieldLifeMaxを%dに設定", shieldLifeMax);
    
    
    //itemlistBarrier0の設定=@"次回以降全てのゲームにおいて、バリアアイテム獲得後の耐久時間を現状に0.5秒上乗せする。
    //attrフィールドの読み込みあり、attrフィールドへの新規設定なし
    NSString *strKeyBarrier0 = @"itemlistBarrier0";
    int valueBarrier0 = [[_attr getValueFromDevice:strKeyBarrier0] integerValue];
    for(int _valueAttr = 0; _valueAttr < valueBarrier0; _valueAttr++){
        defense0CountMax += 50;
    }
    NSLog(@"defense0CountMaxを%dに設定", defense0CountMax);
    
    
    //itemlistBarrier1の設定=@"1回のゲームにのみ、バリアアイテム獲得後の耐久時間を現状の２倍に長持ちさせる。
    NSString *strKeyBarrier1 = @"itemlistBarrier1";
    int valueBarrier1 = [[_attr getValueFromDevice:strKeyBarrier1] integerValue];
    if(valueBarrier1 > 0){
        defense0CountMax *= 2;
        //消耗
        [_attr setValueToDevice:strKeyBarrier1
                       strValue:[NSString stringWithFormat:@"%d", valueBarrier1-1]];
    }
    NSLog(@"defense0CountMaxを%dに設定", defense0CountMax);
    
    
//    @"itemlistBomb0",
//    @"itemlistBomb1",
//    @"itemlistDiffuse0",
//    @"itemlistDiffuse1",
//    @"itemlistLaser0",
//    @"itemlistLaser1",
//
//    @"次回以降全てのゲームにおいて、爆弾投下の持続時間を0.5秒上乗せする。\n15枚のコインが必要です。",//1=10coin
//    @"1回のゲームでのみ、爆弾投下の持続時間を現状の２倍に長持ちさせる。\n18枚のコインが必要です。",//1=9coin
//    @"次回以降全てのゲームにおいて、通常弾の攻撃力強化持続時間を0.5秒上乗せする。\n15枚のコインが必要です。",//1=10coin
//    @"1回のゲームでのみ、通常弾の攻撃力持続時間を現状の２倍に長持ちさせる。\n18枚のコインが必要です。",//1=9coin
//    @"次回以降全てのゲームにおいて、レーザー発射持続時間を0.5秒上乗せする。\n15枚のコインが必要です。",//1=10coin
//    @"1回のゲームでのみ、レーザー発射持続時間を現状の２倍に長持ちさせる。\n18枚のコインが必要です。",//1=9coin
    
    
    
    //itemlistBomb0の設定＝@"次回以降全てのゲームにおいて、爆弾投下の持続時間を0.5秒上乗せする
    //attrフィールドの読み込みあり、attrフィールドへの新規設定なし
    NSString *strKeyWeapon00 = @"itemlistWeapon00";
    int valueWeapon00 = [[_attr getValueFromDevice:strKeyWeapon00] integerValue];
    for(int _valueAttr = 0; _valueAttr < valueWeapon00; _valueAttr++){
        weapon0CountMax += 50;
    }
    NSLog(@"weapon0CountMaxを%dに設定", weapon0CountMax);
    
    
    //itemlistBomb1の設定＝@"1回のゲームでのみ、爆弾投下の持続時間を現状の２倍に長持ちさせる。
    //attrフィールドの読み込みあり、attrフィールドへの新規設定あり(−１消耗させる)
    NSString *strKeyWeapon01 = @"itemlistWeapon01";
    int valueWeapon01 = [[_attr getValueFromDevice:strKeyWeapon01] integerValue];
    if(valueWeapon01 > 0){
        weapon0CountMax *= 2;
        
        //消耗
        [_attr setValueToDevice:strKeyWeapon01
                       strValue:[NSString stringWithFormat:@"%d", valueWeapon01-1]];
    }
    NSLog(@"weapon0CountMaxを%dに設定", weapon0CountMax);
    
    
    //itemlistDiffuse0の設定=@"次回以降全てのゲームにおいて、通常弾の攻撃力強化持続時間を0.5秒上乗せする。
    //attrフィールドの読み込みあり、attrフィールドへの新規設定なし
    NSString *strKeyWeapon10 = @"itemlistWeapon10";
    int valueWeapon10 = [[_attr getValueFromDevice:strKeyWeapon10] integerValue];
    for(int _valueAttr = 0; _valueAttr < valueWeapon10; _valueAttr++){
        weapon1CountMax += 50;
    }
    NSLog(@"weapon1CountMaxを%dに設定", weapon1CountMax);
    
    
    //itemlistDiffuse1の設定=@"1回のゲームでのみ、通常弾の攻撃力持続時間を現状の２倍に長持ちさせる。
    //attrフィールドの読み込みあり、attrフィールドへの新規設定あり
    NSString *strKeyWeapon11 = @"itemlistWeapon11";
    int valueWeapon11 = [[_attr getValueFromDevice:strKeyWeapon11] integerValue];
    if(valueWeapon11 > 0){
        weapon1CountMax *= 2;
        //消耗
        [_attr setValueToDevice:strKeyWeapon11
                       strValue:[NSString stringWithFormat:@"%d", valueWeapon11-1]];
    }
    NSLog(@"weapon1CountMaxを%dに設定", weapon1CountMax);
    
    
    //itemlistLaser0の設定=@"次回以降全てのゲームにおいて、レーザー発射持続時間を0.5秒上乗せする。
    //attrフィールドの読み込みあり、attrフィールドへの新規設定なし
    NSString *strKeyWeapon20 = @"itemlistWeapon20";
    int valueWeapon20 = [[_attr getValueFromDevice:strKeyWeapon20] integerValue];
    for(int _valueAttr = 0; _valueAttr < valueWeapon20; _valueAttr++){
        weapon2CountMax += 50;
    }
    NSLog(@"weapon2CountMaxを%dに設定",weapon2CountMax);
    
    
    //itemlistLaser1の設定=@"1回のゲームでのみ、レーザー発射持続時間を現状の２倍に長持ちさせる。
    //attrフィールドの読み込みあり、attrフィールドへの新規設定あり
    NSString *strKeyWeapon21 = @"itemlistWeapon21";
    int valueWeapon21 = [[_attr getValueFromDevice:strKeyWeapon21] integerValue];
    if(valueWeapon21 > 0){
        weapon2CountMax *= 2;
        //消耗
        [_attr setValueToDevice:strKeyWeapon21
                       strValue:[NSString stringWithFormat:@"%d", valueWeapon21-1]];
    }
    NSLog(@"weapon2CountMaxを%dに設定", weapon2CountMax);
    
    
    
//    @"itemlistBig0",
//    @"itemlistBig1",
//    @"itemlistTrans0",
//    @"itemlistTrans1",
//    @"itemlistBomb0",
//    @"itemlistBomb1",
//    @"itemlistMagnet0",
//    @"itemlistMagnet1",
//    @"次回以降全てのゲームにおいて、巨大化の持続時間を0.5秒延長します。\n100枚のコインが必要です。",
//    @"1回のゲームでのみ、巨大化の持続時間を2倍にします。\n100枚のコインが必要です。",
//    @"次回以降の全てのゲームにおいて、透明化の持続時間を0.5秒延長します。\n100枚のコインが必要です。",
//    @"1回のゲームにおいてのみ、透明化の持続時間を2倍にします。\n100枚のコインが必要です。",
//    @"次回以降の全てのゲームにおいて、周囲で爆発が発生する時間を0.5秒延長します。\n100枚のコインが必要です。",
//    @"1回のゲームにおいてのみ、周囲で爆発が発生する時間を2倍にします。\n100枚のコインが必要です。",
//    @"次回以降の全てのゲームにおいて、磁石が有効になっている時間を0.5秒延長します。\n100枚のコインが必要です。",
//    @"1回のゲームにおいてのみ、磁石が有効になっている時間を2倍にします。\n100枚のコインが必要です。",
    //big0
    NSString *strKeyBig0 = @"itemlistBig0";
    int valueBig0 = [[_attr getValueFromDevice:strKeyBig0] integerValue];
    for(int _valueAttr = 0; _valueAttr < valueBig0; _valueAttr++){
        bigCountMax += 50;
    }
    NSLog(@"bigCountMax=%d", bigCountMax);
    
    //big1
    NSString *strKeyBig1 = @"itemlistBig1";
    int valueBig1 = [[_attr getValueFromDevice:strKeyBig1] integerValue];
    if(valueBig1 > 0){
        bigCountMax *= 2;
        //消耗
        [_attr setValueToDevice:strKeyBig1
                       strValue:[NSString stringWithFormat:@"%d", valueBig1-1]];
    }
    NSLog(@"bigCountMax=%d", bigCountMax);
    
    
    //trans0
    NSString *strKeyTrans0 = @"itemlistTrans0";
    int valueTrans0 = [[_attr getValueFromDevice:strKeyTrans0] integerValue];
    for(int _valueAttr = 0;_valueAttr < valueTrans0;_valueAttr++){
        transparancyCountMax += 50;
    }
    NSLog(@"transparancyCountMax=%d", transparancyCountMax);
    
    //trans1
    NSString *strKeyTrans1 = @"itemlistTrans1";
    int valueTrans1 = [[_attr getValueFromDevice:strKeyTrans1] integerValue];
    if(valueTrans1 > 0){
        transparancyCountMax *= 2;
        //消耗
        [_attr setValueToDevice:strKeyTrans1
                       strValue:[NSString stringWithFormat:@"%d", valueTrans1-1]];
    }
    
    
    //bomb0
    NSString *strKeyBomb0 = @"itemlistBomb0";
    int valueBomb0 = [[_attr getValueFromDevice:strKeyBomb0] integerValue];
    for(int _valueAttr = 0;_valueAttr < valueBomb0;_valueAttr++){
        bombCountMax += 50;
    }
    NSLog(@"bombCountMax=%d", bombCountMax);
    
    //bomb1
    NSString *strKeyBomb1 = @"itemlistBomb1";
    int valueBomb1 = [[_attr getValueFromDevice:strKeyBomb1] integerValue];
    if(valueBomb1 > 0){
        bombCountMax *= 2;
        //消耗
        [_attr setValueToDevice:strKeyBomb1
                       strValue:[NSString stringWithFormat:@"%d", valueBomb1-1]];
    }
    NSLog(@"bombCountMax=%d", bombCountMax);
    
    
    
    //Magnet0
    NSString *strKeyMagnet0 = @"itemlistMagnet0";
    int valueMagnet0 = [[_attr getValueFromDevice:strKeyMagnet0] integerValue];
    for(int _valueAttr = 0;_valueAttr < valueMagnet0;_valueAttr++){
        magnetCountMax += 50;
    }
    NSLog(@"MagnetCountMax=%d", magnetCountMax);
    
    //Magnet1
    NSString *strKeyMagnet1 = @"itemlistMagnet1";
    int valueMagnet1 = [[_attr getValueFromDevice:strKeyMagnet1] integerValue];
    if(valueMagnet1 > 0){
        magnetCountMax *= 2;
        //消耗
        [_attr setValueToDevice:strKeyMagnet1
                       strValue:[NSString stringWithFormat:@"%d", valueMagnet1-1]];
    }
    NSLog(@"MagnetCountMax=%d", magnetCountMax);
    
    
    //Cookie0
    NSString *strKeyCookie0 = @"itemlistCookie0";
    int valueCookie0 = [[_attr getValueFromDevice:strKeyCookie0] integerValue];
    for(int _valueAttr = 0; _valueAttr < valueCookie0;_valueAttr++){
        cookieCountMax += 50;
    }
    NSLog(@"CookieCountMax=%d", cookieCountMax);
    
    //Cookie1
    NSString *strKeyCookie1 = @"itemlistCookie1";
    int valueCookie1 = [[_attr getValueFromDevice:strKeyCookie1] integerValue];
    if(valueCookie1 > 0){
        cookieCountMax *= 2;
        //消耗
        [_attr setValueToDevice:strKeyCookie1
                       strValue:[NSString stringWithFormat:@"%d", valueCookie1-1]];
    }
    NSLog(@"CookieCountMax=%d", cookieCountMax);
    
    
    
    
}

@end
