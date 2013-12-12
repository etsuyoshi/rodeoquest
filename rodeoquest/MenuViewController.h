//
//  ItemSelectViewController.h
//  Shooting5
//
//  Created by 遠藤 豪 on 13/10/07.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <AVFoundation/AVFoundation.h>
#import "GADBannerView.h"
#import <GameKit/GameKit.h>

@interface MenuViewController : UIViewController<UITextViewDelegate,GKLeaderboardViewControllerDelegate>{
    //admob
    GADBannerView *bannerView_;

}
//@property (nonatomic, retain) AVAudioPlayer *audioPlayer;

//- (AVAudioPlayer*)getAVAudioPlayer:(NSString*)soudFileName;

@end
