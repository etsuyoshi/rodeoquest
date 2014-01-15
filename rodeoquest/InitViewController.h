//
//  ViewController.h
//  ShootingTest
//
//  Created by 遠藤 豪 on 13/09/25.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import <CoreLocation/CoreLocation.h>

@interface InitViewController : UIViewController<CLLocationManagerDelegate>{
    BOOL isSuccessAccess;
    
    CLLocationManager *locationManager;
    CLLocation *bestEffortAtLocation;
}

@end
