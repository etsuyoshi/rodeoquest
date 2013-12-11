//
//  DBAccessClass.h
//  Shooting5
//
//  Created by 遠藤 豪 on 13/10/13.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBAccessClass : NSObject{
    
}

-(Boolean)setIdToDB:(NSString *)arg_id;
-(Boolean)insertDemandToDB:(NSString *)_date subject:(NSString *)_subject demand:(NSString *)_demand;
-(Boolean)updateValueToDB:(NSString *)user_id column:(NSString *)column newVal:(NSString *)newValue;
-(NSString *)getValueFromDB:(NSString *)user_id column:(NSString *)column;
-(Boolean)getIsRegisteredID:(NSString *)_strId;
-(Boolean)initUserRegister:(NSString *)_strId;
-(NSData *)formEncodedDataFromDictionary:(NSDictionary *)dict;
@end
