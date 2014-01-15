//
//  LocationDataClass.h
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2014/01/15.
//  Copyright (c) 2014年 endo.tuyo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationDataClass : NSObject{
    NSMutableArray *arrLocation;
    NSMutableArray *arrLatitudeLongitude;
    NSMutableArray *arrName;
    
}

-(id)init;
-(int)getNearestLocationNo:(CLLocation *)_location;
-(float)getDistanceFrom:(CLLocation *)location1 to:(CLLocation *)location2;
-(NSString *)getNameNearestLocation:(CLLocation *)_location;
-(double)getDistanceNearest:(CLLocation *)_location;

@end
