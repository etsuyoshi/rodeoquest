//
//  LocationDataClass.m
//  Rodeoquest
//
//  Created by 遠藤 豪 on 2014/01/15.
//  Copyright (c) 2014年 endo.tuyo. All rights reserved.
//

#import "LocationDataClass.h"

@implementation LocationDataClass

-(id)init{
    self = [super init];
    
    //latitude, longitude
    arrLatitudeLongitude =
    [NSMutableArray arrayWithObjects:
     @35.644302,@139.669769,
     @35.698683,@139.774219,
     @35.659888,@139.700315,
     @35.692723,@139.701309,
     @35.632547,@139.88133,
     @35.626188,@139.885832,
     @35.729534,@139.718055,
     @35.659094,@139.700765,
     nil];
    
    
    arrLocation = [[NSMutableArray alloc] init];
    CLLocation *_location;
    double _longitude;
    double _latitude;
    for(int i = 0; i < [arrLatitudeLongitude count];i+=2){
        _latitude = [[arrLatitudeLongitude objectAtIndex:i] floatValue];
        _longitude = [[arrLatitudeLongitude objectAtIndex:i+1] floatValue];
        _location = [[CLLocation alloc]initWithLatitude:_latitude longitude:_longitude];
        NSLog(@"cllocation=%@", _location);
        [arrLocation addObject:_location];
    }
    
    for(int i = 0 ; i < [arrLocation count];i++){
        NSLog(@"location = %@", [arrLocation objectAtIndex:i]);
    }
    
    return self;
}

-(int)getNearestLocationNo:(CLLocation *)_location{
    double _distance = 0;
    double _nearrestDist = 99999;
    int _nearrestNo = -1;
    for(int i = 0; i < [arrLocation count];i++){
        _distance = [self getDistanceFrom:[arrLocation objectAtIndex:i] to:_location];
        NSLog(@"%d : distance = %f", i, _distance);
        
        if(_nearrestDist > _distance){
            _nearrestDist = _distance;
            _nearrestNo = i;
            NSLog(@"距離が近いので採用 %d", i);
        }
    }
    
    if(_nearrestNo != -1){
        return  _nearrestNo;
    }else{
        if([arrLocation count] == 0){
            NSLog(@"配列に格納されていません。");
        }else{
            NSLog(@"最近接値を取得できませんでした。");
        }
        return -1;
    }
    return -1;
}


-(float)getDistanceFrom:(CLLocation *)location1 to:(CLLocation *)location2{
    CLLocationDistance distance = [location1 distanceFromLocation:location2];
    return distance;
}
@end
