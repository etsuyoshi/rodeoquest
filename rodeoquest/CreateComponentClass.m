//
//  CreateComponentClass.m
//  Shooting6
//
//  Created by 遠藤 豪 on 13/10/15.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "AttrClass.h"
#import "MenuButtonWithView.h"
#import "SwitchButtonWithView.h"
#import "CreateComponentClass.h"
#import "SpecialBeamClass.h"
#import "QBFlatButton.h"
#import "SpecialBeamClass.h"
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@implementation CreateComponentClass

-(id)init{
    self = [super init];
//    arrayBow = [NSArray arrayWithObjects:
//                @"RockBow.png",
//                @"FireBow.png",
//                @"WaterBow.png",
//                @"IceBow.png",
//                @"BugBow.png",
//                @"AnimalBow.png",
//                @"GrassBow.png",
//                @"ClothBow.png",
//                @"SpaceBow.png",
//                @"WingBow.png",nil
//                ];
//    arrayBeam = [NSArray arrayWithObjects:
//                 [NSNumber numberWithInt:BeamTypeRock ],
//                 [NSNumber numberWithInt:BeamTypeFire],
//                 [NSNumber numberWithInt:BeamTypeWater ],
//                 [NSNumber numberWithInt:BeamTypeIce ],
//                 [NSNumber numberWithInt:BeamTypeBug],
//                 [NSNumber numberWithInt:BeamTypeAnimal],
//                 [NSNumber numberWithInt:BeamTypeGrass ],
//                 [NSNumber numberWithInt:BeamTypeCloth],
//                 [NSNumber numberWithInt:BeamTypeSpace ],
//                 [NSNumber numberWithInt:BeamTypeWing ],nil
//                 ];
//    dictWeapon = [NSDictionary  dictionaryWithObjects:arrayBeam forKeys:arrayBow];
    
//    dictWeapon = [NSDictionary dictionaryWithObjectsAndKeys:
//                  //value, keys
//                  [NSNumber numberWithInt:BeamTypeRock], @"RockBow.png",
//                  [NSNumber numberWithInt:BeamTypeFire], @"fireBow.png",
//                  [NSNumber numberWithInt:BeamTypeWater], @"IceBow.png",
//                  [NSNumber numberWithInt:BeamTypeBug], @"BugBow.png",
//                  [NSNumber numberWithInt:BeamTypeAnimal], @"AnimalBow.png",
//                  [NSNumber numberWithInt:BeamTypeGrass ], @"GrassBow.png",
//                  [NSNumber numberWithInt:BeamTypeCloth], @"ClothBow.png",
//                  [NSNumber numberWithInt:BeamTypeSpace ], @"SpaceBow.png",
//                  [NSNumber numberWithInt:BeamTypeWing ], @"WingBow.png",
//                  nil];
//
//    arrayBowAsKeys = [dictWeapon allKeys];
//    arrayBeamAsValues = [dictWeapon allValues];
    
    return self;
}


//standard1
+(UITextView *)createTextView:(CGRect)rect
                       text:(NSString *)text{
    
    return [self createTextView:(CGRect)rect
                           text:(NSString *)text
                           font:@"AmericanTypewriter-Bold"
                           size:14
                      textColor:[UIColor whiteColor]
                      backColor:[UIColor blackColor]
                     isEditable:NO];
}

//manufact
+(UITextView *)createTextView:(CGRect)rect
                         text:(NSString *)text
                         font:(NSString *)font
                         size:(int)size
                    textColor:(UIColor *)textColor
                    backColor:(UIColor *)backColor
                   isEditable:(Boolean)isEditable{
    UITextView *tv = [[UITextView alloc]initWithFrame:rect];
    [tv setFont:[UIFont fontWithName:font size:size]];
    tv.text = [NSString stringWithFormat:@"%@", text];
    tv.textColor = textColor;
    tv.backgroundColor = backColor;
    tv.editable = isEditable;
    return tv;
    
    
//    return nil;
}

//standard1
+(UIView *)createView{
    CGRect rect = CGRectMake(10, 50, 300, 400);
    return [self createView:rect];
    
}

//standard2
+(UIView *)createView:(CGRect)rect{
    UIColor *color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
    float cornerRadius = 10.0f;
    UIColor *borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
    float borderWidth = 2.0f;
    
    return [self createView:rect
                      color:color
               cornerRaidus:cornerRadius
                borderColor:borderColor
                borderWidth:borderWidth];
}

//manufact
+(UIView *)createView:(CGRect)rect
                color:(UIColor*)color
         cornerRaidus:(float)cornerRadius
          borderColor:(UIColor*)borderColor
          borderWidth:(float)borderWidth{
    
    
    UIView *view = [[UIView alloc]init];
    
    //            view.frame = self.view.bounds;//画面全体
    view.frame = rect;
    
    view.backgroundColor = color;
//    view.alpha = alpha;
    
    //丸角にする
    [[view layer] setCornerRadius:cornerRadius];
    [view setClipsToBounds:YES];
    
    //UIViewに枠線を追加する
    [[view layer] setBorderColor:[borderColor CGColor]];
    [[view layer] setBorderWidth:borderWidth];
    
    //    [self.view bringSubviewToFront:view];
    //    [self.view addSubview:view];
    return view;
}

//manufact2:tapイベントを付ける(フレームなし)
+(UIView *)createViewNoFrame:(CGRect)rect
                       color:(UIColor *)color
                         tag:(int)tag
                      target:(id)target
                    selector:(NSString *)selName{
//    UIView *v = [self createView:rect];
    UIView *v = [[UIView alloc]initWithFrame:rect];
    [v setBackgroundColor:color];
    v.tag = tag;
    v.userInteractionEnabled = YES;
    //NSSelectorFromString(selName)
    [v addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:target
                                                                   action:NSSelectorFromString(selName)]];
    return v;
}
//manufact3:tapイベントを付ける(フレームあり)
+(UIView *)createViewWithFrame:(CGRect)rect
                       color:(UIColor *)color
                         tag:(int)tag
                      target:(id)target
                    selector:(NSString *)selName{
    
    float cornerRadius = 10.0f;
    UIColor *borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
    float borderWidth = 2.0f;
    
    UIView *v = [self createView:rect
                           color:color
                    cornerRaidus:cornerRadius
                     borderColor:borderColor
                     borderWidth:borderWidth];
    v.tag = tag;
    v.userInteractionEnabled = YES;
    [v addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:target
                                                                   action:NSSelectorFromString(selName)]];
    return v;
}




+(UIImageView *)createImageView:(CGRect)rect
                          image:(NSString *)image{
    
    if(image != nil){
        UIImageView *iv = [[UIImageView alloc]initWithFrame:rect];
        iv.image = [UIImage imageNamed:image];
        return iv;
    }
    
    return nil;
}

+(UIImageView *)createImageView:(CGRect)rect
                          image:(NSString *)image
                            tag:(int)tag
                         target:(id)target
                       selector:(NSString *)selName{
    if(image != nil){
        UIImageView *iv = [self createImageView:rect
                                          image:image];
        iv.tag = tag;
        iv.userInteractionEnabled = YES;
        //NSSelectorFromString(selName)
        [iv addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:target
                                                                        action:NSSelectorFromString(selName)]];
        return iv;
    }
    
    return nil;
}

+(UIImageView *)createSwitchButton:(CGRect)rect
                          backType:(ButtonMenuBackType)_backType
                         imageType:(ButtonSwitchImageType)_imageType
                            tag:(int)tag
                         target:(id)target
                       selector:(NSString *)selName{
    
    UIImageView *iv = [[SwitchButtonWithView alloc]initWithFrame:rect
                                                        backType:_backType
                                                       imageType:_imageType
                                                          target:target
                                                        selector:selName
                                                             tag:tag];
    return iv;
}
+(UIImageView *)createCountButton:(CGRect)rect
                         backType:(ButtonMenuBackType)_backType
                        imageType:(ButtonCountImageType)_imageType
                              tag:(int)tag
                           target:(id)target
                         selector:(NSString *)selName{
    
    return [[CountButtonWithView alloc] initWithFrame:rect
                                             backType:_backType
                                            imageType:_imageType
                                               target:target
                                             selector:selName
                                                  tag:tag];
}


//standard
+(UIButton *)createButton:(id)target
                 selector:(NSString *)selName{
    int btWidth = 100;
    int btHeight = 40;
    
    return [self createButtonWithType:ButtonMenuBackTypeDefault
                                 rect:CGRectMake(320/2-btWidth/2, 480/2-btHeight/2, btWidth, btHeight)//center
                                image:nil
                               target:target
                             selector:selName];
//    return nil;
}

//manufact
+(UIButton *)createButtonWithType:(ButtonMenuBackType)buttonType
                             rect:(CGRect)rect
                            image:(NSString *)image
                           target:(id)target
                         selector:(NSString *)selName{
    
    
    if (buttonType == ButtonMenuBackTypeDefault) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:rect];
        
        NSLog(@"button pressed now! , %@, %@, %f, %f", image, selName, button.center.x, button.center.y);
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        button.contentMode = UIViewContentModeScaleToFill;
        [button setBackgroundImage:[UIImage imageNamed:image]
                          forState:UIControlStateNormal];
        [button setTitle:@""
                forState:UIControlStateNormal];
        [button addTarget:target
                   action:NSSelectorFromString(selName)
         forControlEvents:UIControlEventTouchUpInside];
        return button;
    }else if(buttonType == ButtonMenuBackTypeBlue){
        UIButton *button = [[UIButton alloc] initWithFrame:rect];
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        button.contentMode = UIViewContentModeScaleToFill;
        [button addTarget:target
                   action:NSSelectorFromString(selName)
         forControlEvents:UIControlEventTouchUpInside];
        UIImage *img = [UIImage imageNamed:image];
        [button setImage:img forState:UIControlStateNormal];
        return button;
        
    }
    
    return nil;
}


//manufacture
+(UIButton *)createQBButton:(ButtonMenuBackType)type
                       rect:(CGRect)rect
                      image:(NSString *)image
                      title:(NSString *)title
                     target:(id)target
                   selector:(NSString *)selName{
    
    if (type == ButtonMenuBackTypeDefault) {
        QBFlatButton *qbBtn = [QBFlatButton buttonWithType:UIButtonTypeCustom];
        qbBtn.frame = rect;
//        qbBtn.faceColor = [UIColor colorWithRed:154.0/255.0 green:255.0/255.0 blue:154.0/255.0 alpha:1.0];//palegreen 1
//        qbBtn.faceColor = [UIColor colorWithRed:0.0/255.0 green:250.0/255.0 blue:154.0/255.0 alpha:1.0];//mediumspringgreen
//        qbBtn.sideColor = [UIColor colorWithRed:0.0/255.0 green:205.0/255.0 blue:102.0/255.0 alpha:1.0];//springgreen 2
        qbBtn.faceColor = [UIColor colorWithRed:0.333 green:0.631 blue:0.851 alpha:1.0];//default
        qbBtn.sideColor = [UIColor colorWithRed:0.310 green:0.498 blue:0.702 alpha:1.0];//default
        qbBtn.radius = 8.0;
        qbBtn.margin = 4.0;
        qbBtn.depth = 3.0;
//        [qbBtn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        qbBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [qbBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [qbBtn setTitle:title forState:UIControlStateNormal];
        [qbBtn addTarget:target
                  action:NSSelectorFromString(selName)
        forControlEvents:UIControlEventTouchUpInside];
        return qbBtn;
    }
    
    if (type == ButtonMenuBackTypeBlue) {
        QBFlatButton *qbBtn = [QBFlatButton buttonWithType:UIButtonTypeCustom];
        qbBtn.frame = rect;
        //        qbBtn.faceColor = [UIColor colorWithRed:154.0/255.0 green:255.0/255.0 blue:154.0/255.0 alpha:1.0];//palegreen 1
        //        qbBtn.faceColor = [UIColor colorWithRed:0.0/255.0 green:250.0/255.0 blue:154.0/255.0 alpha:1.0];//mediumspringgreen
        //        qbBtn.sideColor = [UIColor colorWithRed:0.0/255.0 green:205.0/255.0 blue:102.0/255.0 alpha:1.0];//springgreen 2
        qbBtn.faceColor = [UIColor colorWithRed:0.333 green:0.631 blue:0.851 alpha:1.0];//default
        qbBtn.sideColor = [UIColor colorWithRed:0.310 green:0.498 blue:0.702 alpha:1.0];//default
        qbBtn.radius = 8.0;
        qbBtn.margin = 4.0;
        qbBtn.depth = 3.0;
        [qbBtn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        qbBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [qbBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [qbBtn setTitle:title forState:UIControlStateNormal];
        [qbBtn addTarget:target
                  action:NSSelectorFromString(selName)
        forControlEvents:UIControlEventTouchUpInside];
        return qbBtn;
    }

    
    return nil;
}

+(UIView *)createSlideShowHorizon:(CGRect)rect
                 imageFile:(NSArray *)imageArray
                    target:(id)target
                 selector1:(NSString *)selector1
                 selector2:(NSString *)selector2{
    
    NSLog(@"create=slideshowにおいてattr初期化");
    
    AttrClass *_attr = [[AttrClass alloc] init];
    NSDictionary *dictWeapon = [_attr getWeaponDict];//key:image.png, value:beamtype
    
    int imageHeight = 300;
    int imageWidth = 300;
    int imageMarginHorizon = 10;
//    int amountOfImage = [imageArray count];
    int amountOfImage = 0;
    //購入済のみ表示する
    for( int i = 0 ;i < [imageArray count]; i++){
        int holdWeaponID = [_attr getValueFromDevice:
                            [NSString stringWithFormat:@"weaponID%d", i]].integerValue;
        if(holdWeaponID > 0){//0非保有,1保有,2装備
            amountOfImage ++;//表示イメージ数を増やす
        }
    }
    
    UIView *superView = [self createViewNoFrame:rect
                                          color:[UIColor clearColor]
                                            tag:9999//closeScrollに渡しているので不要
                                         target:target
                                       selector:selector1 ];//NSSelectorFromString(selector1)];//@"closeView:"];
    //            UIView *superView = [[UIView alloc]initWithFrame:self.view.bounds];
    
    CGRect uv_rect = CGRectMake(rect.origin.x,
                                rect.origin.y,
                                rect.size.width,
                                rect.size.height - 80);
    
    //            UIScrollView *sv = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:uv_rect];
    sv.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
    
    UIView *uvOnScroll = [[UIView alloc] initWithFrame:CGRectMake(uv_rect.origin.x,
                                                                  uv_rect.origin.y,
                                                                  imageMarginHorizon + amountOfImage * (imageWidth + imageMarginHorizon),
                                                                  uv_rect.size.height)];
    [uvOnScroll setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f]];
    sv.contentSize = uvOnScroll.bounds.size;
    
    
    
//    NSArray *arrImage = [dictWeapon allKeys];
//    NSArray *arrBeamType = [dictWeapon allValues];
//    
//    for(int i = 0 ;i < [arrImage count] ;i++){
//        NSLog(@"arrimage=%@", [arrImage objectAtIndex:i]);
//    }
    
    //sort:caz,gettin like uppon description disturbs order
//    arrImage = [arrImage sortedArrayUsingComparator:^(id a, id b) {
//        return [a compare:b options:NSNumericSearch];
//    }];
//    arrBeamType = [arrBeamType sortedArrayUsingComparator:^(id a, id b){
//        return [a compare:b options:NSNumericSearch];
//    }];
    
    //uvにタップリスナーを付けて、画像以外がタップされたら閉じる(selfを渡してremovefromsuperview?)=>できない
    //xボタンを付けるuiviewを付けるしかないか。。
    
    //http://qiita.com/tatsuof0126/items/46a41a897df2cd2684d4

    NSLog(@"start loop");
    int countDisplay = 0;
    for(int numImage = 0; numImage < [imageArray count]; numImage++){
        
        int holdWeaponID = [_attr getValueFromDevice:
                            [NSString stringWithFormat:@"weaponID%d", numImage]].integerValue;
        if(holdWeaponID > 0){//0非保有,1保有,2装備
            
            //        NSLog(@"tag=%d, image=%@", numImage, [dictWeapon objectForKey:[NSNumber numberWithInt:numImage]]);
            //imageViewには、タグ付けとtarget設定ができないので
            CGRect imageRect =
            CGRectMake(imageMarginHorizon + countDisplay * (imageWidth + imageMarginHorizon),
                       -30, imageWidth, imageHeight);
            UIView *frameView = [self createView:imageRect];//imageのframe
            [frameView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8f]];
            [uvOnScroll addSubview:frameView];
            
            //現在装備中のアイテムに背景追加：やってもいいけど、選択した後にも反映させるにはグローバルに設定する必要がある。
            
             if([[_attr getValueFromDevice:[NSString stringWithFormat:@"weaponID%d", numImage]]
                 isEqualToString:@"2"]){
                 NSLog(@"equipping...");
                 UIImageView *viewEquip = [CreateComponentClass
                                           //                                      createImageView:frameView.bounds
                                           createImageView:imageRect
                                           image:@"close.png"];
                 [viewEquip setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5]];
                 [uvOnScroll addSubview:viewEquip];
//                 [frameView addSubview:viewEquip];
             }
            
            
            
            UIImageView *imageView = [self createImageView:imageRect
                                                     image:[dictWeapon objectForKey:[NSNumber numberWithInt:numImage]]//[arrImage objectAtIndex:numImage]//[imageArray objectAtIndex:numImage]
                                                       tag:(BowType)numImage//[[arrBeamType objectAtIndex:numImage] intValue]//[[dictWeapon objectForKey:[imageArray objectAtIndex:numImage]] intValue]//beamtype
                                                    target:target
                                                  selector:selector2];
            [uvOnScroll addSubview:imageView];
            //                [_iv addTarget:self action:@selector(pushed_button:) forControlEvents:UIControlEventTouchUpInside];
            //タップリスナーを追加してタップされたらダイアログで購入確認。
            
            countDisplay++;//表示順番と位置を示す
        }
        
    }
//    NSLog(@"complete loop");
    [sv addSubview:uvOnScroll];
    [superView addSubview:sv];
    return superView;

}

//垂直表示：購入済のみ表示
+(UIView *)createSlideShowVertical:(CGRect)rect
                 imageFile:(NSArray *)imageArray
                    target:(id)target
                 selector1:(NSString *)selector1
                 selector2:(NSString *)selector2{
    
    NSLog(@"create=slideshowにおいてattr初期化");
    
    AttrClass *_attr = [[AttrClass alloc] init];
    NSDictionary *dictWeapon = [_attr getWeaponDict];//key:image.png, value:beamtype
    
    int imageHeight = 300;
    int imageWidth = 300;
    int frameHeight = 200;
    int imageMarginVertical = 15;
    //    int amountOfImage = [imageArray count];
    int amountOfImage = 0;
    //購入済のみ表示する
    for( int i = 0 ;i < [imageArray count]; i++){
        int holdWeaponID = [_attr getValueFromDevice:
                            [NSString stringWithFormat:@"weaponID%d", i]].integerValue;
        if(holdWeaponID > 0){//0非保有,1保有,2装備
            amountOfImage ++;//表示イメージ数を増やす
        }
    }
    
    UIView *superView = [self createViewNoFrame:rect
                                          color:[UIColor clearColor]
                                            tag:9999//closeScrollに渡しているので不要
                                         target:target
                                       selector:selector1 ];//NSSelectorFromString(selector1)];//@"closeView:"];
    //            UIView *superView = [[UIView alloc]initWithFrame:self.view.bounds];
    
    CGRect uv_rect = CGRectMake(rect.origin.x,
                                rect.origin.y,
                                rect.size.width,
                                rect.size.height - 80);
    
    //            UIScrollView *sv = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:uv_rect];
    sv.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
    
    UIView *uvOnScroll = [[UIView alloc]
                          initWithFrame:CGRectMake(uv_rect.origin.x,
                                                   uv_rect.origin.y,
                                                   uv_rect.size.width,
                                                   imageMarginVertical + amountOfImage * (frameHeight + imageMarginVertical))];
//                                                 imageMarginHorizon + amountOfImage * (imageWidth + imageMarginHorizon),
//                                                 uv_rect.size.height)];
    [uvOnScroll setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f]];
    sv.contentSize = uvOnScroll.bounds.size;
    
    
    
    //    NSArray *arrImage = [dictWeapon allKeys];
    //    NSArray *arrBeamType = [dictWeapon allValues];
    //
    //    for(int i = 0 ;i < [arrImage count] ;i++){
    //        NSLog(@"arrimage=%@", [arrImage objectAtIndex:i]);
    //    }
    
    //sort:caz,gettin like uppon description disturbs order
    //    arrImage = [arrImage sortedArrayUsingComparator:^(id a, id b) {
    //        return [a compare:b options:NSNumericSearch];
    //    }];
    //    arrBeamType = [arrBeamType sortedArrayUsingComparator:^(id a, id b){
    //        return [a compare:b options:NSNumericSearch];
    //    }];
    
    //uvにタップリスナーを付けて、画像以外がタップされたら閉じる(selfを渡してremovefromsuperview?)=>できない
    //xボタンを付けるuiviewを付けるしかないか。。
    
    //http://qiita.com/tatsuof0126/items/46a41a897df2cd2684d4
    
    NSLog(@"start loop");
    int countDisplay = 0;
    for(int numImage = 0; numImage < [imageArray count]; numImage++){
        
        int holdWeaponID = [_attr getValueFromDevice:
                            [NSString stringWithFormat:@"weaponID%d", numImage]].integerValue;
        if(holdWeaponID > 0){//0非保有,1保有,2装備
            
            //        NSLog(@"tag=%d, image=%@", numImage, [dictWeapon objectForKey:[NSNumber numberWithInt:numImage]]);
            //imageViewには、タグ付けとtarget設定ができないので
            
            CGRect rectFrame =
            CGRectMake(5,imageMarginVertical + countDisplay * (frameHeight + imageMarginVertical),
                       imageWidth, frameHeight);
            
            CGRect rectImage =
            CGRectMake(5,imageMarginVertical + countDisplay * (imageHeight + imageMarginVertical),
                       imageWidth, imageHeight);
//            CGRectMake(imageMarginHorizon + countDisplay * (imageWidth + imageMarginHorizon),
//                       -30, imageWidth, imageHeight);
            UIView *frameView = [self createView:rectFrame];//imageのframe
            [frameView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8f]];
            [uvOnScroll addSubview:frameView];
            
            //装備中の武器
            if([[_attr getValueFromDevice:[NSString stringWithFormat:@"weaponID%d", numImage]]
                isEqualToString:@"2"]){
                NSLog(@"equipping...");
                UIImageView *viewEquip = [CreateComponentClass
                                          createImageView:rectFrame
                                          image:@"close.png"];
                [viewEquip setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5]];
                viewEquip.center = frameView.center;
                [uvOnScroll addSubview:viewEquip];
                //                 [frameView addSubview:viewEquip];
            }
            
            
            
            UIImageView *imageView = [self createImageView:rectImage
                                                     image:[dictWeapon objectForKey:[NSNumber numberWithInt:numImage]]//[arrImage objectAtIndex:numImage]//[imageArray objectAtIndex:numImage]
                                                       tag:(BowType)numImage//[[arrBeamType objectAtIndex:numImage] intValue]//[[dictWeapon objectForKey:[imageArray objectAtIndex:numImage]] intValue]//beamtype
                                                    target:target
                                                  selector:selector2];
            imageView.center = frameView.center;
            [uvOnScroll addSubview:imageView];
            //                [_iv addTarget:self action:@selector(pushed_button:) forControlEvents:UIControlEventTouchUpInside];
            //タップリスナーを追加してタップされたらダイアログで購入確認。
            
            countDisplay++;//表示順番と位置を示す
        }
        
    }//for:numImage
    //    NSLog(@"complete loop");
    [sv addSubview:uvOnScroll];
    [superView addSubview:sv];
    return superView;
    
}


//垂直表示：購入済のみカラー表示
+(UIView *)createSlideShowVerticalAll:(CGRect)rect
                         imageFile:(NSArray *)imageArray
                            target:(id)target
                         selector1:(NSString *)selector1
                         selector2:(NSString *)selector2{
    
    NSLog(@"create=slideshowにおいてattr初期化");
    
    AttrClass *_attr = [[AttrClass alloc] init];
    NSDictionary *dictWeapon = [_attr getWeaponDict];//key:image.png, value:beamtype
    
    int imageHeight = 300;
    int imageWidth = 300;
    int frameHeight = 200;
    int imageMarginVertical = 15;
    //    int amountOfImage = [imageArray count];
    int amountOfImage = [imageArray count];
    
    UIView *superView = [self createViewNoFrame:rect
                                          color:[UIColor clearColor]
                                            tag:9999//closeScrollに渡しているので不要
                                         target:target
                                       selector:selector1 ];//NSSelectorFromString(selector1)];//@"closeView:"];
    //            UIView *superView = [[UIView alloc]initWithFrame:self.view.bounds];
    
    CGRect uv_rect = CGRectMake(rect.origin.x,
                                rect.origin.y,
                                rect.size.width,
                                rect.size.height - 80);
    
    //            UIScrollView *sv = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:uv_rect];
    sv.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
    
    UIView *uvOnScroll = [[UIView alloc]
                          initWithFrame:CGRectMake(uv_rect.origin.x,
                                                   uv_rect.origin.y,
                                                   uv_rect.size.width,
                                                   imageMarginVertical + amountOfImage * (frameHeight + imageMarginVertical))];
    //                                                 imageMarginHorizon + amountOfImage * (imageWidth + imageMarginHorizon),
    //                                                 uv_rect.size.height)];
    [uvOnScroll setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f]];
    sv.contentSize = uvOnScroll.bounds.size;
    
    
    
    //    NSArray *arrImage = [dictWeapon allKeys];
    //    NSArray *arrBeamType = [dictWeapon allValues];
    //
    //    for(int i = 0 ;i < [arrImage count] ;i++){
    //        NSLog(@"arrimage=%@", [arrImage objectAtIndex:i]);
    //    }
    
    //sort:caz,gettin like uppon description disturbs order
    //    arrImage = [arrImage sortedArrayUsingComparator:^(id a, id b) {
    //        return [a compare:b options:NSNumericSearch];
    //    }];
    //    arrBeamType = [arrBeamType sortedArrayUsingComparator:^(id a, id b){
    //        return [a compare:b options:NSNumericSearch];
    //    }];
    
    //uvにタップリスナーを付けて、画像以外がタップされたら閉じる(selfを渡してremovefromsuperview?)=>できない
    //xボタンを付けるuiviewを付けるしかないか。。
    
    //http://qiita.com/tatsuof0126/items/46a41a897df2cd2684d4
    
    NSLog(@"start loop");
    int countDisplay = 0;
    for(int numImage = 0; numImage < [imageArray count]; numImage++){
        
        int holdWeaponID = [_attr getValueFromDevice:
                            [NSString stringWithFormat:@"weaponID%d", numImage]].integerValue;
        
//        if(holdWeaponID > 0){//0非保有,1保有,2装備
        
        //        NSLog(@"tag=%d, image=%@", numImage, [dictWeapon objectForKey:[NSNumber numberWithInt:numImage]]);
        //imageViewには、タグ付けとtarget設定ができないので
        
        CGRect rectFrame =
        CGRectMake(5,imageMarginVertical + countDisplay * (frameHeight + imageMarginVertical),
                   imageWidth, frameHeight);
        
        CGRect rectImage =
        CGRectMake(5,imageMarginVertical + countDisplay * (imageHeight + imageMarginVertical),
                   imageWidth, imageHeight);
        //            CGRectMake(imageMarginHorizon + countDisplay * (imageWidth + imageMarginHorizon),
        //                       -30, imageWidth, imageHeight);
        UIView *frameView = [self createView:rectFrame];//imageのframe
        [frameView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8f]];
        [uvOnScroll addSubview:frameView];
        
        //装備中の武器
        if(holdWeaponID == 0){
            NSLog(@"equipping...");
            UIImageView *viewEquip = [CreateComponentClass
                                      createImageView:rectFrame
                                      image:@"close.png"];
            [viewEquip setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5]];
            viewEquip.center = frameView.center;
            [uvOnScroll addSubview:viewEquip];
            //                 [frameView addSubview:viewEquip];
        }else{
        
        
            
            UIImageView *imageView = [self createImageView:rectImage
                                                     image:[dictWeapon objectForKey:[NSNumber numberWithInt:numImage]]//[arrImage objectAtIndex:numImage]//[imageArray objectAtIndex:numImage]
                                                       tag:(BowType)numImage//[[arrBeamType objectAtIndex:numImage] intValue]//[[dictWeapon objectForKey:[imageArray objectAtIndex:numImage]] intValue]//beamtype
                                                    target:target
                                                  selector:selector2];
            imageView.center = frameView.center;
            [uvOnScroll addSubview:imageView];
        }
        //                [_iv addTarget:self action:@selector(pushed_button:) forControlEvents:UIControlEventTouchUpInside];
        //タップリスナーを追加してタップされたらダイアログで購入確認。
        
        countDisplay++;//表示順番と位置を示す
        
    }//for:numImage
    //    NSLog(@"complete loop");
    [sv addSubview:uvOnScroll];
    [superView addSubview:sv];
    return superView;
    
}


+(UIImageView *)createMenuButton:(ButtonMenuBackType)_backType
                       imageType:(ButtonMenuImageType)_imageType
                            rect:(CGRect)rect
                          target:(id)target
                        selector:(NSString *)selector
                             tag:(int)_tag{
    
    
    UIImageView *imv = [[MenuButtonWithView alloc]initWithFrame:rect
                                                       backType:_backType
                                                      imageType:_imageType
                                                         target:target
                                                       selector:selector
                                                            tag:_tag
                        ];
    
    
    return imv;
}

+(UIImageView *)createMenuButton:(ButtonMenuBackType)_backType
                       imageType:(ButtonMenuImageType)_imageType
                         rect:(CGRect)rect
                       target:(id)target
                     selector:(NSString *)selector{
    
    
    return [self createMenuButton:_backType
                        imageType:_imageType
                             rect:rect
                           target:target
                         selector:selector
                              tag:0];
    
}




+(UIButton *)createGradButton{
    //http://d.hatena.ne.jp/Kazzz/20120912/p1
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(10, 10, 300, 460);//100, 100, 150, 150);
    CAGradientLayer* gradient = [CAGradientLayer layer];
    gradient.frame = btn.bounds;//self.view.bounds;
    NSMutableArray *array = [NSMutableArray arrayWithObjects:
                             (id)[[UIColor colorWithRed:0/255.0f
                                                  green:103.0f/255.0f
                                                   blue:100.0f/255.0f
                                                  alpha:1.0f] CGColor],//start
                             (id)[[UIColor colorWithRed:0.0f/255.0f
                                                  green:153.0f/255.0f
                                                   blue:70.0f/255.0f
                                                  alpha:1.0f] CGColor],//end
                             nil];
    
    //test:grad
//    for(int i = 0; i < 255;i++){
//        [array insertObject:(id)[[UIColor colorWithRed:0/255.0f
//                                                 green:103.0f/255.0f
//                                                  blue:100.0f/255.0f
//                                                 alpha:1.0f]
//                                 CGColor]
//                    atIndex:0];
//    }
    
    
//    [array addObject:nil];
//                             (id)[[UIColor colorWithRed:91.0f/255.0f green:153.0f/255.0f blue:100.0f/255.0f
//                                                  alpha:1.0f] CGColor],
//                             (id)[[UIColor colorWithRed:1 green:250.0f/255.0f blue:224.0f/255.0f
//                                                  alpha:1.0f] CGColor],
//                             nil];
    gradient.colors = array;
    
//    [NSArray arrayWithObjects:
//                       (id)[[UIColor colorWithRed:91.0f/255.0f green:153.0f/255.0f blue:100.0f/255.0f
//                                            alpha:1.0f] CGColor],
//                       (id)[[UIColor colorWithRed:1 green:250.0f/255.0f blue:224.0f/255.0f
//                                            alpha:1.0f] CGColor],
////                       (id)[[UIColor redColor] CGColor], //開始色
////                       (id)[[UIColor blueColor] CGColor], //終了色
////                       (id)[[UIColor yellowColor] CGColor], //終了色
//                       nil];
    [gradient setStartPoint:CGPointMake(0.5, 0.0)];
    [gradient setEndPoint:CGPointMake(0.5, 1.0)]; // 0 degree
//    [self.view.layer insertSublayer:gradient atIndex:0];
    [btn.layer insertSublayer:gradient atIndex:0];
    
    return btn;
}


+(CoolButton *)createCoolButton:(CGRect)_rect
                       text:(NSString *)_text
                          hue:(float)_hue
                   saturation:(float)_saturation
                   brightness:(float)_brightness
                       target:(id)_target
                     selector:(NSString *)_selector
                          tag:(int)_tag{
    
    CoolButton *coolButton = [CoolButton buttonWithType:UIButtonTypeCustom];
    coolButton.frame = _rect;
    [coolButton setTitle:_text forState:UIControlStateNormal]; //有効時
    [coolButton setTitle:_text forState:UIControlStateHighlighted]; //ハイライト時
    [coolButton setTitle:_text forState:UIControlStateDisabled]; //無効時
    coolButton.hue = _hue;
    coolButton.saturation = _saturation;
    coolButton.brightness = _brightness;
    
    
    [coolButton addTarget:_target
                   action:NSSelectorFromString(_selector)
         forControlEvents:UIControlEventTouchUpInside];
    coolButton.tag = _tag;
    
    return coolButton;
}

+(UIView *)createAlertView:(CGRect)_rectFrame
                dialogRect:(CGRect)_rectDialog
                     title:(NSString *)_title
                  subtitle:(NSString *)_subtitle
                     onYes:(void (^)(void))onYes
                      onNo:(void (^)(void))onNo
                    target:(id)_target
                  selector:(NSString *)_selector
                       tag:(int)_tag{
    //OKボタンとキャンセルボタン：okボタンを押したときの反応は_selector@target
    UIView *superView = [[UIView alloc] initWithFrame:_rectFrame];
    UIView *rectDialog = [CreateComponentClass
                          createView:_rectDialog];
    //test:
//    [rectDialog setBackgroundColor:[UIColor blackColor]];
    [superView addSubview:rectDialog];
    
    //title
    UITextView *tvTitle = [CreateComponentClass
                           createTextView:CGRectMake(0, 0, rectDialog.frame.size.width,
                                                     rectDialog.frame.size.height)
                           text:_title
                           font:@"AmericanTypewriter-Bold"
                           size:20
                           textColor:[UIColor whiteColor]
                           backColor:[UIColor clearColor]
                           isEditable:NO];
    tvTitle.textAlignment = NSTextAlignmentCenter;
    [rectDialog addSubview:tvTitle];
    
    //line
    UIView *viewLine = [CreateComponentClass
                        createView:CGRectMake(0, tvTitle.frame.size.height,
                                              rectDialog.frame.size.width,1)];
    [viewLine setBackgroundColor:[UIColor blackColor]];
    [rectDialog addSubview:viewLine];
    
    
    UIButton *btn1 = [CreateComponentClass
                      createCoolButton:CGRectMake(10, viewLine.frame.origin.y + 10,
                                                  50, 30)
                      text:@"yes"
                      hue:0.3 saturation:0.3 brightness:0.3
                      target:_target selector:onYes tag:0];
//    btn1 addTarget:<#(id)#> action:<#(SEL)#> forControlEvents:<#(UIControlEvents)#>
    [rectDialog addSubview:btn1];
    
    
//    a = [CreateComponentClass createViewNoFrame:self.view.bounds
//                                                          color:[UIColor clearColor]
//                                                            tag:0
//                                                         target:Nil
//                                                       selector:nil];
//    [viewMailSuperForm setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8]];
//    [self.view addSubview:viewMailSuperForm];
//    
//    
//    
//    
//    int xViewFrame = 10;
//    int yViewFrame = 100;
//    int widthViewFrame = 300;
//    int heightViewFrame = 350;
//    
//    //見た目の飾り付け
//    UIView *viewFrame = [CreateComponentClass createView:CGRectMake(xViewFrame,yViewFrame,
//                                                                    widthViewFrame,
//                                                                    heightViewFrame)];
//    [viewFrame setBackgroundColor:[UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:0.6f]];
//    [viewMailSuperForm addSubview:viewFrame];
//    
//    //TextViewから他の場所をタップした時にフォーカスを外すためのview
//    UIView *viewForResign = [CreateComponentClass createViewNoFrame:self.view.bounds
//                                                              color:[UIColor clearColor]
//                                                                tag:0
//                                                             target:self
//                                                           selector:@"setResign"];
//    [viewMailSuperForm addSubview:viewForResign];//only for action
    
    
    
    return superView;
}

@end
