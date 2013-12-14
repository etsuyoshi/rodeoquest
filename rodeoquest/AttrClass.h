//
//  IDClass.h
//  Shooting5
//
//  Created by 遠藤 豪 on 13/10/14.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttrClass : NSObject{
    NSString *myId;
    NSDictionary *attrDict;
    
    NSMutableArray *nameArray;
    
    
    NSDictionary *dictWeapon;
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
-(Boolean)addExp:(int)addingVal;
-(Boolean)setValueToDevice:(NSString *)NAME strValue:(NSString *)VALUE;
-(NSString *)getValueFromDevice:(NSString *)NAME;
-(NSString *)getIdFromDevice;
-(NSDictionary *)getWeaponDict;
@end
