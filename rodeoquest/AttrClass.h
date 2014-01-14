//
//  IDClass.h
//  Shooting5
//
//  Created by 遠藤 豪 on 13/10/14.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import <Foundation/Foundation.h>
//to sort in order
typedef NS_ENUM(NSInteger, BowType) {
    BowTypeRock,
    BowTypeFire,
    BowTypeIce,
    BowTypeWater,
    BowTypeBug,
    BowTypeAnimal,
    BowTypeCloth,
    BowTypeGrass,
    BowTypeSpace,
    BowTypeWing
};



@interface AttrClass : NSObject{
    NSString *myId;
    NSDictionary *attrDict;
    int maxLevel;
    NSMutableArray *nameArray;
    
    
    NSDictionary *dictWeapon;
    NSDictionary *dictBeam;
//    NSString *name;
//    int score;
//    int gold;//max = 2147483647;
//    int gameCnt;
//    int login;
//    int level;
//    int exp;
}
-(int)getMaxExpAtTheLevel:(int)level;
-(Boolean)removeAllData;
-(NSDictionary *)getAttrDict;
-(Boolean)addExp:(int)addingVal;//自機レベル
-(Boolean)addWeaponExp:(int)addingVal weaponID:(int)_weaponId;//武器レベル
-(Boolean)setValueToDevice:(NSString *)NAME strValue:(NSString *)VALUE;
-(NSString *)getValueFromDevice:(NSString *)NAME;
-(NSString *)getIdFromDevice;
-(NSDictionary *)getWeaponDict;
-(NSDictionary *)getBeamDict;

-(int)getMaxLevel;
@end
