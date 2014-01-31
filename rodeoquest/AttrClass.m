//
//  IDClass.m
//  Shooting5
//
//  Created by 遠藤 豪 on 13/10/14.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "AttrClass.h"


@implementation AttrClass{
    NSMutableArray *MaxExpArray;
}


/*
 *
 *(NSString *)getValueFromDevice:(NSString)name=name属性の値を取得する
 *(NSDictionary *)getAttrDict:
 */

-(id)init{
    self = [super init];
    
    
//    NSLog(@"aaa");//
    MaxExpArray = [[NSMutableArray alloc]init];
//    attrDict = [[NSDictionary alloc] init];
    maxLevel = 90;
    for(int i = 0; i < maxLevel; i ++){//level 100がマックス
        [MaxExpArray addObject:[NSNumber numberWithInt:((i+1)*100)]];//100, 200, 300, 400, 500, ・・・
    }
//    NSLog(@"bbb");//
    
    //game内で逐次呼び出すよりもデータクラスを定義した方が良いかも。
    dictWeapon = [NSDictionary dictionaryWithObjectsAndKeys:
                  //value, keys
                  @"FireBow.png",[NSNumber numberWithInt:BowTypeFire],
                  @"RockBow.png",[NSNumber numberWithInt:BowTypeRock],
                  @"IceBow.png",[NSNumber numberWithInt:BowTypeIce],
                  @"WaterBow.png",[NSNumber numberWithInt:BowTypeWater],
                  @"BugBow.png",[NSNumber numberWithInt:BowTypeBug],
                  @"AnimalBow.png",[NSNumber numberWithInt:BowTypeAnimal],
                  @"ClothBow.png",[NSNumber numberWithInt:BowTypeCloth],
                  @"GrassBow.png",[NSNumber numberWithInt:BowTypeGrass],
                  @"SpaceBow.png",[NSNumber numberWithInt:BowTypeSpace],
                  @"WingBow.png",[NSNumber numberWithInt:BowTypeWing],
                  nil];
    
    dictBeam = [NSDictionary dictionaryWithObjectsAndKeys:
                @"Fire.png",[NSNumber numberWithInt:BeamTypeFire],
                @"Rock.png",[NSNumber numberWithInt:BeamTypeRock],
                @"Ice.png",[NSNumber numberWithInt:BeamTypeIce],
                @"Water.png",[NSNumber numberWithInt:BeamTypeWater],
                @"Bug.png",[NSNumber numberWithInt:BeamTypeBug],
                @"Animal.png",[NSNumber numberWithInt:BeamTypeAnimal],
                @"Cloth.png",[NSNumber numberWithInt:BeamTypeCloth],
                @"Grass.png",[NSNumber numberWithInt:BeamTypeGrass],
                @"Space.png",[NSNumber numberWithInt:BeamTypeSpace],
                @"Wing.png",[NSNumber numberWithInt:BeamTypeWing],
                nil];
    
    //device-memory-information
    nameArray = [NSMutableArray arrayWithObjects:
                 @"name",
                 @"score",
                 @"exp",
                 @"gold",
                 @"login",
                 @"lastlogin",
                 @"gameCnt",
                 @"level",
                 @"exp_accum",
                 @"break_enemy",
                 @"gold_max",
                 @"time_max",
                 @"bgm",
                 @"se",
                 
                 @"weaponID0",
                 @"weaponID1",
                 @"weaponID2",
                 @"weaponID3",
                 @"weaponID4",
                 @"weaponID5",
                 @"weaponID6",
                 @"weaponID7",
                 @"weaponID8",
                 @"weaponID9",
                 
                 
                 @"weaponID0_exp",
                 @"weaponID1_exp",
                 @"weaponID2_exp",
                 @"weaponID3_exp",
                 @"weaponID4_exp",
                 @"weaponID5_exp",
                 @"weaponID6_exp",
                 @"weaponID7_exp",
                 @"weaponID8_exp",
                 @"weaponID9_exp",
                 
                 
                 @"weaponID0_level",
                 @"weaponID1_level",
                 @"weaponID2_level",
                 @"weaponID3_level",
                 @"weaponID4_level",
                 @"weaponID5_level",
                 @"weaponID6_level",
                 @"weaponID7_level",
                 @"weaponID8_level",
                 @"weaponID9_level",
                 nil];
    
    NSLog(@"search in the device");
    
    
    //グローバル辞書attrDictにデバイス内データを保存(それを吐き出している)
    NSDictionary *_dict = [self getAttrDict];

    //初期値をdeviceにセットする：getAttrDictはデバイスから取得しているので以下は読み込んだ属性値をそのまま上書きしているだけなので不要？
    for(int i = 0 ; i < [nameArray count] ; i++){
        [self setValueToDevice:[nameArray objectAtIndex:i]
                      strValue:[_dict objectForKey:[nameArray objectAtIndex:i]]];
    }
    
    return self;
}

-(int)getMaxExpAtTheLevel:(int)level{
    return [[MaxExpArray objectAtIndex:level] intValue];
}
/**
 *デバイス側にname,score,gold,login,gameCnt,level,expをNSString型として保存
 *returnAttrDictではそれらを読み込ませたattrDict(Dictionary)を作成
 */
-(NSDictionary *)getAttrDict{
    
    //initial value:最初に起動した時に値が入っていないものは以下の値に設定される
//    NSMutableArray *valueArray = [[NSMutableArray alloc]init];
    NSMutableArray *valueArray = [NSMutableArray arrayWithObjects:
                                  @"no_name",//name
                                  @"0",//score
                                  @"0",//exp
                                  @"0",//gold
                                  @"0",//login
                                  @"0",//lastlogin
                                  @"0",//gameCnt
                                  @"1",//level
                                  @"0",//exp_accum",
                                  @"0",//break_enemy",
                                  @"0",//gold_max",
                                  @"0",//@"time_max,
                                  @"1",//@"bgm"
                                  @"1",//@"se"
                                  
                                  
                                  @"0",//@"weaponID0",
                                  @"0",//@"weaponID1",
                                  @"0",//@"weaponID2",
                                  @"0",//@"weaponID3",
                                  @"0",//@"weaponID4",
                                  @"0",//@"weaponID5",
                                  @"0",//@"weaponID6",
                                  @"0",//@"weaponID7",
                                  @"0",//@"weaponID8",
                                  @"0",//@"weaponID9",
                                  
                                  @"0",//@"weaponID0_exp",
                                  @"0",//@"weaponID1_exp",
                                  @"0",//@"weaponID2_exp",
                                  @"0",//@"weaponID3_exp",
                                  @"0",//@"weaponID4_exp",
                                  @"0",//@"weaponID5_exp",
                                  @"0",//@"weaponID6_exp",
                                  @"0",//@"weaponID7_exp",
                                  @"0",//@"weaponID8_exp",
                                  @"0",//@"weaponID9_exp",
                                  
                                  
                                  @"1",//@"weaponID0_level",
                                  @"1",//@"weaponID1_level",
                                  @"1",//@"weaponID2_level",
                                  @"1",//@"weaponID3_level",
                                  @"1",//@"weaponID4_level",
                                  @"1",//@"weaponID5_level",
                                  @"1",//@"weaponID6_level",
                                  @"1",//@"weaponID7_level",
                                  @"1",//@"weaponID8_level",
                                  @"1",//@"weaponID9_level",
                           nil];
//    attrDict = [NSDictionary dictionaryWithObjects:valueArray forKeys:nameArray];
    
    for(int i = 0; i < [nameArray count]; i++){
        if([self getValueFromDevice:[nameArray objectAtIndex:i]] != NULL){
            NSLog(@"getAttrDict : 番号：%d , 属性：%@ , 値：%@", i,
                  [nameArray objectAtIndex:i], 
                  [self getValueFromDevice:[nameArray objectAtIndex:i]]);
//            valueArray set = [[self getValueFromDevice:@"score"] intValue];
            [valueArray replaceObjectAtIndex:i withObject:(NSString *)[self getValueFromDevice:[nameArray objectAtIndex:i]]];
//            NSLog(@"test");
            
        }else{
            NSLog(@"device search for %@, but no data...", [nameArray objectAtIndex:i]);
            //nullならそのまま
        }
    }
    attrDict = [NSDictionary dictionaryWithObjects:valueArray forKeys:nameArray];
    
    
    return attrDict;
}

-(Boolean)removeAllData{
//    テスト用初期化=全データ消去
    
    NSUserDefaults *_ud = [NSUserDefaults standardUserDefaults];
    for(int i = 0 ; i < [nameArray count]; i++){
        [_ud removeObjectForKey:[nameArray objectAtIndex:i]];
        NSLog(@"removeAllData- attr:%@ , value:%@", [nameArray objectAtIndex:i],
              [_ud objectForKey:[nameArray objectAtIndex:i]]);
    }

    return true;
}

/*
 *経験値を足してexpとして記憶
 *レベルを足してlevelとして記憶
 *最大経験値になったら次のレベルに上昇して記憶(何度でも繰り返す)
 *返り値はlevel-max=>false, otherwise:true
 */
-(Boolean)addExp:(int)addingVal{
    //格納成功判定必要->格納失敗時はfalse
    NSLog(@"addExp");
    int beforeExp = [[self getValueFromDevice:@"exp"] intValue];
    int beforeLevel = [[self getValueFromDevice:@"level"] intValue];
    if(beforeLevel < [MaxExpArray count]){//until-89
        NSLog(@"現在レベル%dの経験値%dに%dを加算", beforeLevel, beforeExp , addingVal);
        
        int afterExp = beforeExp + addingVal;
        int _maxExp = [[MaxExpArray objectAtIndex:beforeLevel] intValue];//現在レベルでの最高経験値を取得
        NSLog(@"beforeExp = %d, beforeLevel = %d, afterExp = %d, _maxExp = %d",
              beforeExp, beforeLevel, afterExp, _maxExp);
        if (afterExp >= _maxExp){//現在レベルの最高経験値を超えたら
            int afterLevel = beforeLevel + 1;//レベルアップ
            if(afterLevel < [MaxExpArray count]){//上昇後レベルが上限(90)未満なら
                [self setValueToDevice:@"level" strValue:[NSString stringWithFormat:@"%d", afterLevel]];//レベルアップを反映
                NSLog(@"レベルアップ!%d->%d", beforeLevel, afterLevel);
                
                //前のレベルにおける最高経験値を差し引いた後に残っている(次のレベルにおいて)追加すべき経験値を計算(beforeLevelにおける最高経験値)
                afterExp = afterExp - _maxExp;// - [[MaxExpArray objectAtIndex:afterLevel - 1] intValue];
                
                
                //_maxExpの更新(再取得)
                _maxExp = [[MaxExpArray objectAtIndex:afterLevel] intValue];
                if(afterExp < _maxExp){
                    [self setValueToDevice:@"exp" strValue:[NSString stringWithFormat:@"%d", afterExp]];
                    return true;
                }else{
                    [self addExp:afterExp];
                }
            }else{
                //if become level90=>displayed "MAX"
                
                //以下別途対応必要！：レベルが90になったらmaxと表示させる等＠menuviewcon
                [self setValueToDevice:@"level" strValue:@"90"];
                [self setValueToDevice:@"exp" strValue:@"9999"];
                
                return true;
            }
        }else{//if (afterExp >= _maxExp)
            [self setValueToDevice:@"exp" strValue:[NSString stringWithFormat:@"%d", afterExp]];
            return true;
        }
        
    }else{
        NSLog(@"レベルが90以上なのでレベルアップせず");
        return false;
    }//if(beforeLevel < [MaxExpArray count]){//until-89
    return false;
}

//返り値は意味なし
-(Boolean)addWeaponExp:(int)addingVal weaponID:(int)_id{
    NSString *_weaponId = [NSString stringWithFormat:@"weaponID%d", _id];
    NSString *strID_exp = [NSString stringWithFormat:@"%@_exp", _weaponId];
    NSString *strID_level = [NSString stringWithFormat:@"%@_level", _weaponId];
    int beforeExp = [[self getValueFromDevice:strID_exp] intValue];
    int beforeLevel = [[self getValueFromDevice:strID_level] intValue];
    NSLog(@"経験値とレベル更新開始");
    if(beforeLevel < [MaxExpArray count]-1){//until-88
        int afterExp = beforeExp + addingVal;
        int _maxExp = [[MaxExpArray objectAtIndex:beforeLevel] intValue];
        
        if(afterExp >= _maxExp){
            int afterLevel = beforeLevel + 1;
            [self setValueToDevice:strID_level strValue:[NSString stringWithFormat:@"%d", afterLevel]];
            NSLog(@"武器レベルアップ!%d->%d", beforeLevel, afterLevel);
            
            
            //前のレベルにおける最高経験値を差し引いた後に残っている(次のレベルにおいて)追加すべき経験値を計算(beforeLevelにおける最高経験値)
            afterExp = afterExp - _maxExp;// - [[MaxExpArray objectAtIndex:afterLevel - 1] intValue];
            
            
            
            //_maxExp(最高経験値)の更新と現在の(前レベルの差し引き後の)経験値が(更新後)最高経験値よを上回っていれば再起呼出し②、そうでなければ経験値の書き込み
            _maxExp = [[MaxExpArray objectAtIndex:afterLevel] intValue];
            if(afterExp < _maxExp){//①
                [self setValueToDevice:strID_exp strValue:[NSString stringWithFormat:@"%d", afterExp]];
                return true;
            }else{//②
                [self addWeaponExp:afterExp weaponID:(BowType)_weaponId];
            }
        }
        [self setValueToDevice:strID_exp strValue:[NSString stringWithFormat:@"%d", afterExp]];
    }else{
        NSLog(@"level max");
        return false;
    }
    return false;
}



-(Boolean)setValueToDevice:(NSString *)NAME strValue:(NSString *)VALUE{
    
    NSLog(@"%@に%@を記憶させる", NAME, VALUE);
    //deviceに記憶させる
    NSUserDefaults *_myDefaults = [NSUserDefaults standardUserDefaults];
    [_myDefaults setObject:VALUE forKey:NAME];
    
    return true;
}
-(NSString *)getValueFromDevice:(NSString *)NAME{
    NSUserDefaults *_myDefaults = [NSUserDefaults standardUserDefaults];
//    [myDefaults setObject:dictionary forKey:@"DICTIONARY"];
//    NSDictionary *_dict = [_myDefaults dictionaryForKey:@"attrDict"];
    NSString *rtn_str = [_myDefaults objectForKey:NAME];
    return rtn_str;

}


/**
 *idは端末側に保存されているものとする(なければ新規作成)
 */


-(NSString *)getIdFromDevice{
    NSUserDefaults* id_defaults =
    [NSUserDefaults standardUserDefaults];
    //    [id_defaults removeObjectForKey:@"user_id"];//値を削除：テスト用
    //    [id_defaults removeObjectForKey:@"user_id"];//値を削除：テスト用
    //    [id_defaults removeObjectForKey:@"user_id"];//値を削除：テスト用
    NSString *_registeredId = [id_defaults stringForKey:@"user_id"];
    NSLog(@"userid = %@", _registeredId);
    
    //端末に記録されたIDがない場合、十分に?長い(5桁)乱数を取得してIDとして記憶
    if(_registeredId == NULL){
        //取得
        //        NSLog(@"int max = %010d", INT_MAX);//2147483647
        int random_num = abs(arc4random()%100000);//0-99999=最大5桁の乱数
        //        random_num = 1;
        //        NSLog(@"rand = %d", random_num);
        NSDateFormatter *_dateformat = [[NSDateFormatter alloc] init];
        [_dateformat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
        [_dateformat setDateFormat:@"yyyyMMddHHmmss"];//14桁
        NSString *_now = [_dateformat stringFromDate:[NSDate date]];
        //        NSLog(@"%@", _now);
        NSString *newId = [NSString stringWithFormat:@"%@%05d", _now, random_num];//yyyymmddhhmmss+5桁乱数=19桁=mysqlのbigIntの最大格納桁数
        //        NSString *newId = [NSString stringWithFormat:@"2013010101010100002"];//上記代替のテスト用id
        NSLog(@"新規取得userid = %@", newId);
        //端末記録
        NSUserDefaults *_ud = [NSUserDefaults standardUserDefaults];
        [_ud setObject:newId forKey:@"user_id"];
        
        _registeredId = newId;//
    }else{
        NSLog(@"既存idでログイン完了：user_id = %@", _registeredId);
    }
    return _registeredId;
}

-(NSDictionary *)getWeaponDict{
    return dictWeapon;
}
-(NSDictionary *)getBeamDict{
    return dictBeam;
}

-(void)setWeapon:(BeamType)beamType{
    //ネットワークと連携して確認する必要がある！:当該メソッドを実行する時に確認
    if([[self getValueFromDevice:@"beamtype"] isEqual:[NSNull null]] ||
       [self getValueFromDevice:@"beamtype"] == nil ||
       [[self getValueFromDevice:@"beamtype"] isEqual:@"0"]){
        
        [self setValueToDevice:@"beamtype" strValue:@"1"];
        
    }else{
        NSLog(@"既にセットされています。 : beamType = %@",
              [self getValueFromDevice:@"beamtype"]);
    }
}

-(int)getMaxLevel{
    return maxLevel;
}
@end
