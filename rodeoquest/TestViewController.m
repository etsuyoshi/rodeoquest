//
//  TestViewController.m
//  Shooting7
//
//  Created by 遠藤 豪 on 2013/10/27.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//
//timerでの実行モード
//#define MODE1
//#define MODE2
//#define MODE3
//#define MODE4

//#define CATRANSACTION_TEST
//#define TEST_EFFECT
//#define ORBITPATH_TEST
//#define TRACK_TEST
//#define EXPLOSTION_TEST
//#define BOMB_TEST
//#define MYMACHINE_TEST
//#define BUTTON_TEST
//#define BACKGROUND_TEST
//#define BTNPRESS_TEST
//#define COOLBUTTON_TEST
//#define SPECIALWEAPON_TEST
//#define PARTICLE_TEST
//#define KIRA_Test
//#define EXPLODE_TEST
//#define VIEWWITHEFFECTLEVELUP_TEST
//#define LDPROGRESS_TEST
//#define PAYPRODUCTBUTTON_TEST
//#define LOCATION_TEST
#define SPWeapon_TEST
//#define Animation_TEST
//#define BLOG_UP_TEST

#import <CoreLocation/CoreLocation.h>
#import "LDProgressView.h"
#import "ViewWithEffectLevelUp.h"
#import "ViewExplode.h"
#import "ViewKira.h"
#import "ViewFireWorks.h"
#import "KiraParticleView.h"
#import "SpecialBeamClass.h"
#import "Common.h"
#import "CoolButton.h"
#import "MenuButtonWithView.h"
#import "ExplodeParticleView.h"
#import "DamageParticleView.h"
#import "EnemyClass.h"
#import "ItemClass.h"
#import "CreateComponentClass.h"
#import "TestViewController.h"
#import "UIView+Animation.h"
#import "Effect.h"
#import "BackGroundClass2.h"
#import "MyMachineClass.h"
#import <QuartzCore/QuartzCore.h>

@interface TestViewController ()<CLLocationManagerDelegate>
#ifdef LDPROGRESS_TEST
@property (nonatomic, strong) NSMutableArray *progressViews;//progressを格納する配列
#endif


#ifdef LOCATION_TEST
@property (strong, nonatomic) CLLocationManager *locationManager;
#endif


@end

@implementation TestViewController

UIView *uiv;
UIImageView *uiiv;
NSString *imageName;
NSTimer *tm;
NSMutableArray *uiArray;

#ifdef PARTICLE_TEST
int tempInt1;
int tempInt2;
NSMutableArray *array;
#endif

#ifdef TRACK_TEST
    NSMutableArray *array_uiv;
    NSMutableArray *array_layer;
    NSMutableArray *array_item;
#endif

#ifdef BTNPRESS_TEST
    UIImageView *imv_test;
#endif


#ifdef MYMACHINE_TEST
UIImageView *ivAnimateEffect;
#endif

#ifdef BACKGROUND_TEST
UIImageView *ivOscillate;
UIImageView *notif;
CABasicAnimation * appearance;
#endif

#ifdef COOLBUTTON_TEST

CoolButton *coolButton;
UITextView *tv_hue;
UITextView *tv_saturation;
UITextView *tv_brightness;

#endif


int counter;
UIView *circleView;
CALayer *mylayer;
UIView *viewLayerTest;
ExplodeParticleView *explodeParticle;
KiraParticleView *kiraParticle;
KiraParticleView *kiraMovingParticle;


BackGroundClass2 *BackGround;

int tempCount = 0;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
//
    
    //counter初期化用ブロック
//    uiv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];//赤、大正方形
//    [uiv setBackgroundColor:[UIColor colorWithRed:0.5f green:0 blue:0 alpha:0.5f]];
//    [self.view addSubview:uiv];
//    uiv.userInteractionEnabled = YES;
//    UIPanGestureRecognizer *flick_frame = [[UIPanGestureRecognizer alloc] initWithTarget:self
//                                                          action:@selector(onFlickedFrame:)];
//    
//    [uiv addGestureRecognizer:flick_frame];
    
    
    
//
//    
//    NSMutableArray *ar = [NSMutableArray arrayWithObjects:
////                           [NSValue valueWithCGPoint:CGPointMake(0, 100)],
//                           nil];
//    NSLog(@"first log");
//    
//    [ar insertObject:[NSValue valueWithCGPoint:CGPointMake(99, 99)] atIndex:0];
//    NSLog(@"first log = %f", [[ar objectAtIndex:0] CGPointValue].x);
//    
//    for(int i = 0; i < 10;i++){
////        [ar addObject:[NSValue valueWithCGPoint:CGPointMake(i, 100*i)]];
//        [ar insertObject:[NSValue valueWithCGPoint:CGPointMake(i, 100*i)] atIndex:0];
//    }
//    for(int i  = 0; i < [ar count] ;i++){
//        NSLog(@"x=%f,y=%f",
//              [[ar objectAtIndex:i] CGPointValue].x,
//              [[ar objectAtIndex:i] CGPointValue].y);
//    }
    
#ifdef KIRA_TEST
    
    [self.view setBackgroundColor:[UIColor blueColor]];
    
    ViewKira *_viewKira = [[ViewKira alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];//
//                                                                     self.view.bounds.size.width,
//                                                                     self.view.bounds.size.height)];
    _viewKira.center = CGPointMake(self.view.bounds.size.width/2,
                                   self.view.bounds.size.height/2);
    [self.view addSubview:_viewKira];
    NSLog(@"viewkira.center = %f, %f", _viewKira.center.x, _viewKira.center.y);

#endif
    
//    int diameter = 300;//直径
//    CGPoint saveCenter = self.view.center;
//    CGRect newFrame = CGRectMake(0, 0, diameter, diameter);//中心は後で修正
//    circleView = [[UIView alloc]initWithFrame:newFrame];
//    circleView.layer.cornerRadius = diameter / 2.0;
//    circleView.center = saveCenter;
////    circleView.layer.borderWidth = 3.0f;
////    circleView.layer.borderColor = [UIColor blueColor].CGColor;
//    [circleView setBackgroundColor:[UIColor colorWithRed:0.5f green:0.1f blue:0.1f alpha:0.9f]];
//    [self.view addSubview:circleView];
    
//    uiiv = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
//    imageName = [NSString stringWithFormat:@"coin_red.png"];
//    uiiv.image = [UIImage imageNamed:imageName];
//    [self.view addSubview:uiiv];
    
    
    //紫色のブロックを下に下げる
//    viewLayerTest = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];//紫、小正方形
//    [viewLayerTest setBackgroundColor:[UIColor purpleColor]];
//    [self.view addSubview:viewLayerTest];
////    mylayer = [CALayer layer];
//    mylayer = (CALayer*)(viewLayerTest.layer.presentationLayer);
    
    
    
    
//    mylayer = viewLayerTest.layer;

//    mylayer = [CALayer layer]; //mylayer declared in .h file
//    mylayer.bounds = CGRectMake(0, 0, 100, 100);
//    mylayer.position = CGPointMake(100, 100); //In parent coordinate
//    mylayer.backgroundColor = [UIColor redColor].CGColor;
//    mylayer.contents = (id)[UIImage imageNamed:@"glasses"].CGImage;
//    [self.view.layer addSublayer:mylayer];
    
    
    
    imageName = [NSString stringWithFormat:@"tool_bomb.png"];
    
    uiArray = [[NSMutableArray alloc]init];
    
#ifdef TRACK_TEST
    array_uiv = [[NSMutableArray alloc] init];
    array_layer = [[NSMutableArray alloc]init];
    array_item = [[NSMutableArray alloc]init];
#endif
    
    
    tm = [NSTimer scheduledTimerWithTimeInterval:0.1
                                          target:self
                                        selector:@selector(time:)//タイマー呼び出し
                                        userInfo:nil
                                         repeats:YES];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
#ifdef BACKGROUND_TEST
    notif = [[UIImageView alloc] initWithFrame:CGRectMake(100, 0, 100, 100)];
    [notif setBackgroundColor:[UIColor colorWithRed:0 green:1.0f blue:0 alpha:0.9f]];
    [self.view addSubview:notif];
    
    
    [CATransaction begin];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [CATransaction setCompletionBlock:^{
        CAAnimation *animationKeyFrame = [notif.layer animationForKey:@"position"];
        if(animationKeyFrame){
            NSLog(@"completion");
//            [notif.layer removeAnimationForKey:@"position"];
//            notif.center = CGPointMake(0, 0);//これは実行されない
//            [self animationDidStop:appearance finished:YES];
            [self nextAnimation];
        }else{
            NSLog(@"not completion");
        }
    }];
    
    {
//        appearance =[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        CABasicAnimation *appearance = [CABasicAnimation animationWithKeyPath:@"position"];
        [appearance setValue:@"animation1" forKey:@"id"];
//        appearance.delegate = self;
//        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:)];
        appearance.duration = 1.0f;
//        appearance.fromValue = [NSNumber numberWithFloat:0];
//        appearance.toValue = [NSNumber numberWithFloat:340];//]1.0f*M_PI];
        appearance.fromValue = [NSValue valueWithCGPoint:CGPointMake(100, 0)];//start
        appearance.toValue = [NSValue valueWithCGPoint:CGPointMake(100, 300)];//end
        appearance.repeatCount = 1;
        appearance.fillMode = kCAFillModeForwards;
        appearance.removedOnCompletion = NO;
//        [notif.layer addAnimation:appearance forKey:@"transform.translation.y"];
        [notif.layer addAnimation:appearance forKey:@"position"];
        
    }
    [CATransaction commit];
    
    BackGround = [[BackGroundClass2 alloc]init:WorldTypeForest
                                         width:self.view.bounds.size.width
                                        height:self.view.bounds.size.height
                                          secs:3.0f];//3secで一回転する背景
    
    
    [self.view addSubview:[BackGround getImageView1]];
    [self.view addSubview:[BackGround getImageView2]];
    [self.view bringSubviewToFront:[BackGround getImageView1]];
    [self.view bringSubviewToFront:[BackGround getImageView2]];
    [BackGround startAnimation];
    
    NSLog(@"complete start animation");
    
#endif //background_test
    
    
    
    
//    [CATransaction begin];
//    [CATransaction setAnimationDuration:0.5f];
//    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
//    {
//        [CATransaction setAnimationDuration:2];
////        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//
////        viewLayerTest.layer.position=CGPointMake(200, 200);
////        viewLayerTest.layer.opacity=0.5;
//        
//        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
//        [anim setDuration:0.5f];
//        anim.fromValue = [NSValue valueWithCGPoint:((CALayer *)[viewLayerTest.layer presentationLayer]).position];//現在位置
//        anim.toValue = [NSValue valueWithCGPoint:CGPointMake(0, self.view.bounds.size.height)];
//        
//        anim.removedOnCompletion = NO;
//        anim.fillMode = kCAFillModeForwards;
//        [viewLayerTest.layer addAnimation:anim forKey:@"position"];
//        
////        mylayer.position=CGPointMake(200, 200);
////        mylayer.opacity=0.5;
//    } [CATransaction commit];
    
    
//    [CATransaction begin];
//    [CATransaction setAnimationDuration:0.5f];
//    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
//    
//    {
//        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
//        [anim setDuration:3.0f];
//        anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(x, y)];
//        anim.toValue = [NSValue valueWithCGPoint:CGPointMake(0, 420)];//myview.superview.bounds.size.height)];
//        
//        anim.removedOnCompletion = NO;
//        anim.fillMode = kCAFillModeForwards;
//        [myview.layer addAnimation:anim forKey:@"position"];//uiviewから生成したlayerをanimation
//        
//    }
//    [CATransaction commit];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onFlickedFrame:(UIPanGestureRecognizer*)gr {
//    NSLog(@"onflicked : gr");
    
    CGPoint point = [gr translationInView:uiv];
    
    CGPoint movedPoint = CGPointMake(uiv.center.x + point.x, uiv.center.y + point.y);
    uiv.center = movedPoint;
    NSLog(@"uiv.x=%f, uiv.y=%f",
          uiv.center.x,
          uiv.center.y);
    [gr setTranslation:CGPointZero inView:uiv];//ここでself.viewを指定するのではなく、myMachineをセットする

    // 指が移動したとき、上下方向にビューをスライドさせる
    if (gr.state == UIGestureRecognizerStateChanged) {//移動中
    }else if (gr.state == UIGestureRecognizerStateEnded) {//指を離した時
    }
    
//    counter = 0;
}

- (void)time:(NSTimer*)timer{
#ifdef MODE1
    if(counter > 10){
        [uiv moveTo:CGPointMake(0, 300)
           duration:3.0f
             option:0];
    }
#elif defined MODE2
    [self createBox];
    [self moveBox];
#elif defined MODE3
    if(counter == 0){
        [self animateChangeImage];
    }
#elif defined MODE4
    if(counter % 5 == 0){
//    if(counter == 0){
        [self explodeTest];
    }
#elif defined TRACK_TEST
    if([array_uiv count] == 0){//最初に100個作成
        [self createView:1];
    }
    if(counter % 50 == 0){//uivを動かすとcounterがゼロになるので実行される
        
        //５秒毎に一個作成
//        [self createView:1];//これをやらずにoccureAnimFreeOrbitを実行した段階で初期位置に移動する
        //５秒毎に発生したviewとuivのcenterが異なればuiv.centerへの移動アニメーションを実行させる
//        [self occureAnim];//createViewで生成した全てのビューに対して実行
//        [self occureViewAnimFreeOrbit];//array_uiv内のuiviewに対して、occureAnimの任意軌道版
        [self occureItemAnimFreeOrbit];//array_item内のitemClassのviewに対して、同様にアニメーション
        
        //trackさせる
        
        /*
         CATRANSACTION_TESTと変わらないのに、なぜかスタート位置が異なる
         (恐らく前アニメーションの終了状態の違い？！
         */
        
        
//        [CATransaction begin];
//        //        [CATransaction setAnimationDuration:0.5f];
//        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
//        {
//            [CATransaction setAnimationDuration:2];
//            //        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//            
//            //        viewLayerTest.layer.position=CGPointMake(200, 200);
//            //        viewLayerTest.layer.opacity=0.5;
//            
//            CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
//            [anim setDuration:0.5f];
//            anim.fromValue = [NSValue valueWithCGPoint:((CALayer *)[viewLayerTest.layer presentationLayer]).position];//現在位置
//            //            anim.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.bounds.size.width,
//            //                                                                 self.view.bounds.size.height)];
//            
//            anim.toValue = [NSValue valueWithCGPoint:uiv.center];
//            
//            
//            anim.removedOnCompletion = NO;
//            anim.fillMode = kCAFillModeForwards;
//            [viewLayerTest.layer addAnimation:anim forKey:@"position"];
//            
//            //        mylayer.position=CGPointMake(200, 200);
//            //        mylayer.opacity=0.5;
        
        
        
        
        
        
        
//        CGPoint kStartPos = ((CALayer *)[viewLayerTest.layer presentationLayer]).position;//viewLayerTest.center;//((CALayer *)[iv.layer presentationLayer]).position;
////        CGPoint kStartPos = mylayer.position;
//        CGPoint kEndPos = uiv.center;//CGPointMake(kStartPos.x + arc4random() % 100 - 50,//iv.bounds.size.width,
////                                      500);//iv.superview.bounds.size.height);//480);//
//        NSLog(@"x=%f, y=%f", kStartPos.x, kStartPos.y);
//        [CATransaction begin];
//        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
//        [CATransaction setCompletionBlock:^{//終了処理
//            CAAnimation* animationKeyFrame = [viewLayerTest.layer animationForKey:@"track"];
//            if(animationKeyFrame){
//                //途中で強制終了せずにアニメーションが全て完了したら
//                NSLog(@"animation key frame already exit");
////                [viewLayerTest.layer removeAnimationForKey:@"track"];
//            }else{
//                //途中で何らかの理由で遮られた場合
//                NSLog(@"animation key frame not exit");
//            }
//            
//        }];
//        
//        {
//            
//            
//            [CATransaction setAnimationDuration:2];
//            //        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//            
//            //        viewLayerTest.layer.position=CGPointMake(200, 200);
//            //        viewLayerTest.layer.opacity=0.5;
//            
//            CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
//            [anim setDuration:0.5f];
//            anim.fromValue = [NSValue valueWithCGPoint:((CALayer *)[viewLayerTest.layer presentationLayer]).position];//現在位置
//            anim.toValue = [NSValue valueWithCGPoint:kEndPos];
//            
//            anim.removedOnCompletion = NO;
//            anim.fillMode = kCAFillModeForwards;
//            [viewLayerTest.layer addAnimation:anim forKey:@"track"];
        
            //任意軌道を飛ぶ場合
//            // CAKeyframeAnimationオブジェクトを生成
//            CAKeyframeAnimation *animation;
//            animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//            animation.fillMode = kCAFillModeForwards;
//            animation.removedOnCompletion = NO;
//            animation.duration = 3.0;
//            
//            // 放物線のパスを生成
//            //    CGFloat jumpHeight = kStartPos.y * 0.2;
//            CGPoint peakPos = CGPointMake((kStartPos.x + kEndPos.x)/2, kStartPos.y * 0.05);//test
//            CGMutablePathRef curvedPath = CGPathCreateMutable();
//            CGPathMoveToPoint(curvedPath, NULL, kStartPos.x, kStartPos.y);//始点に移動
//            CGPathAddCurveToPoint(curvedPath, NULL,
//                                  peakPos.x, peakPos.y,
//                                  (peakPos.x + kEndPos.x)/2, (peakPos.y + kEndPos.y)/2,
//                                  //                          kStartPos.x + jumpHeight/2, kStartPos.y - jumpHeight,
//                                  //                          kEndPos.x - jumpHeight/2, kStartPos.y - jumpHeight,
//                                  kEndPos.x, kEndPos.y);
//            
//            // パスをCAKeyframeAnimationオブジェクトにセット
//            animation.path = curvedPath;
//            
//            // パスを解放
//            CGPathRelease(curvedPath);
//            
//            // レイヤーにアニメーションを追加
//            [viewLayerTest.layer addAnimation:animation forKey:@"freeDown"];
            
//        }
//        [CATransaction commit];
    }
    
#elif defined CATRANSACTION_TEST//うまくいってる
    
    NSLog(@"y=%f", ((CALayer *)viewLayerTest.layer.presentationLayer).position.y);
    if(((CALayer *)viewLayerTest.layer.presentationLayer).position.y >= self.view.bounds.size.height - 10 ||
       counter % 50 == 0){//５秒に一回
        
        
        [CATransaction begin];
//        [CATransaction setAnimationDuration:0.5f];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        {
            [CATransaction setAnimationDuration:2];
            //        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            
            //        viewLayerTest.layer.position=CGPointMake(200, 200);
            //        viewLayerTest.layer.opacity=0.5;
            
            CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
            [anim setDuration:0.5f];
            anim.fromValue = [NSValue valueWithCGPoint:((CALayer *)[viewLayerTest.layer presentationLayer]).position];//現在位置
//            anim.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.bounds.size.width,
//                                                                 self.view.bounds.size.height)];
            
            anim.toValue = [NSValue valueWithCGPoint:uiv.center];
            
            
            anim.removedOnCompletion = NO;
            anim.fillMode = kCAFillModeForwards;
            [viewLayerTest.layer addAnimation:anim forKey:@"position"];
            
            //        mylayer.position=CGPointMake(200, 200);
            //        mylayer.opacity=0.5;
        } [CATransaction commit];
        
        
//        [CATransaction begin];
//        [CATransaction setAnimationDuration:1.5f];
//        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
//        [CATransaction setCompletionBlock:^{
//            NSLog(@"die");
//            [uiv setBackgroundColor:[UIColor blueColor]];
//        }];
//        uiv.layer.position = CGPointMake(uiv.center.x,
//                                         self.view.bounds.size.height);
//        [CATransaction commit];
        
        
        
//        uiv.center = CGPointMake(0, 0);
//        CAMediaTimingFunction *tf;
//        tf = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//        
//        [CATransaction begin];
//        [CATransaction setAnimationDuration:100.0f];
//        [CATransaction setAnimationTimingFunction:tf];
//        uiv.layer.position = CGPointMake(self.view.bounds.size.width,
//                                         self.view.bounds.size.height);
//        [CATransaction commit];
        
        
//        //http://mm-workmode.blogspot.jp/2011/11/coreanimation-catransaction.html
//        [CATransaction begin];
//        [CATransaction setAnimationDuration:5.0];
//        uiv.frame = CGRectMake(200.0, 340.0, 100.0, 100.0);
//        [CATransaction begin];
//        [CATransaction setAnimationDuration:1.0];
//        uiv.layer.opacity = 1.3;
//        [CATransaction commit];
//        [CATransaction commit];
        
    }
#elif defined TEST_EFFECT
    if(counter == 0){
        [self effectTest];
    }
#elif defined EXPLOSTION_TEST
    if(counter == 0){
        
        int x_loc = self.view.center.x;
        int y_loc = self.view.center.y;
        int bomb_size = 200;
//        ExplodeParticleView *ex = [[ExplodeParticleView alloc]init];
        explodeParticle = [[ExplodeParticleView alloc] initWithFrame:CGRectMake(x_loc, y_loc, bomb_size, bomb_size)];
//        explodeParticle set
        [UIView animateWithDuration:1.5f
                         animations:^{
                             [explodeParticle setAlpha:0.0f];//徐々に薄く
                         }
                         completion:^(BOOL finished){
                             //終了時処理
                             [explodeParticle setIsEmitting:NO];
                             [explodeParticle removeFromSuperview];
                         }];
        [self.view addSubview:explodeParticle];
        NSLog(@"explode");
    }
    
#elif defined BOMB_TEST
    
    if(counter == 0){
        
        UIImageView *bombView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,100, 100)];
        bombView.image = [UIImage imageNamed:@"bomb026"];
        //    bombView.center = [MyMachine getImageView].center;
        CGPoint kStartPos = bombView.center;//((CALayer *)[view.layer presentationLayer]).position;
        CGPoint kEndPos = CGPointMake(320, 480);//CGPointMake(self.view.center.x,//test: + arc4random() % 320 - 160,
//                                      bombView.center.y * 0.5f);
        [CATransaction begin];
        //    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [CATransaction setCompletionBlock:^{//終了処理
            //        [self animAirView:view];
            CAAnimation *animationKeyFrame = [bombView.layer animationForKey:@"position"];
            if(animationKeyFrame){
                //途中で終わらずにアニメーションが全て完了した場合
//                NSLog(@"bomb throwerd!!");
                //            [bombView removeFromSuperview];
            }else{
                //途中で何らかの理由で遮られた場合
//                NSLog(@"animation key frame not exit");
            }
            
        }];
        
        {
            
            // CAKeyframeAnimationオブジェクトを生成
            CAKeyframeAnimation *animation;
            animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            animation.fillMode = kCAFillModeForwards;
            animation.removedOnCompletion = NO;
            animation.duration = 2.0f;
            
            // 放物線のパスを生成
            CGPoint peakPos = CGPointMake(kStartPos.x + arc4random() * 100 - 50,
                                          (kStartPos.y + kEndPos.y)/2.0f);//test
            CGMutablePathRef curvedPath = CGPathCreateMutable();
            CGPathMoveToPoint(curvedPath, NULL, kStartPos.x, kStartPos.y);//始点に移動
            CGPathAddCurveToPoint(curvedPath, NULL,
                                  peakPos.x, peakPos.y,
                                  (peakPos.x + kEndPos.x)/2, (peakPos.y + kEndPos.y)/2,
                                  kEndPos.x, kEndPos.y);
            
            // パスをCAKeyframeAnimationオブジェクトにセット
            animation.path = curvedPath;
            
            // パスを解放
            CGPathRelease(curvedPath);
            
            // レイヤーにアニメーションを追加
            //                        [[[ItemArray objectAtIndex:i] getImageView].layer addAnimation:animation forKey:@"position"];
            [bombView.layer addAnimation:animation forKey:@"position"];
            
        }
        [CATransaction commit];
        
        //    [UIView animateWithDuration:3.0f
        //                     animations:^{
        //                         bombView.center = self.view.center;
        //                     }];
        
        [self.view bringSubviewToFront:bombView];
        [self.view addSubview:bombView];
    }
    
#elif defined MYMACHINE_TEST
    if(counter == 0){
        
        NSLog(@"start");
        //http://stackoverflow.com/questions/5475380/uiimageview-animation-is-not-displayed-on-view
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
        UIImageView *animationView = [[UIImageView alloc] initWithFrame:CGRectMake(124,204,72,72)];
        animationView.animationImages = imgArray;
        animationView.animationDuration = 1.0f; // アニメーション全体で3秒（＝各間隔は0.5秒）
        animationView.animationRepeatCount = 0;
        [animationView startAnimating]; // アニメーション開始!!
        animationView.image = [UIImage imageNamed:@"player.png"];//最終状態?
        [self.view addSubview:animationView];
        
        
        ivAnimateEffect = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, 72, 72)];
        ivAnimateEffect.animationImages = [[NSArray alloc] initWithObjects:
                                           [UIImage imageNamed:@"kira.png"],
                                           [UIImage imageNamed:@"kira2.png"],
                                           [UIImage imageNamed:@"snow.png"], nil];
        ivAnimateEffect.animationDuration = 1.0f;
        ivAnimateEffect.animationRepeatCount = 0;
        [ivAnimateEffect startAnimating];
        [animationView addSubview:ivAnimateEffect];
        
        [self repeatAnimEffect:10];
        
//        [self.view addSubview:ivAnimateEffect];
        NSLog(@"complete");
    }

#elif defined BUTTON_TEST
    
    if(counter == 0){
        
        NSLog(@"button test");
        
        [self.view addSubview:[CreateComponentClass createMenuButton:ButtonTypeBlue
                                                                rect:CGRectMake(7, 262, 46, 46)
                                                              target:self
                                                            selector:nil]];
        
        [self.view addSubview:[CreateComponentClass createMenuButton:ButtonTypeGreen
                                                                rect:CGRectMake(7, 362, 46, 46)
                                                              target:self
                                                            selector:nil]];
        
    }
#elif defined BACKGROUND_TEST
//    if(counter % 10 == 0){
    if(counter == 0){
    
        NSLog(@"back-ground -test execute");
        
        
//        UIView *filter = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
//        [filter setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8f]];
//        [self.view addSubview:filter];
        
//        [BackGround startAnimation:12.0f];
        
        
//        notif = [[UIImageView alloc] initWithFrame:CGRectMake(100, 0, 100, 100)];
//        [notif setBackgroundColor:[UIColor colorWithRed:0 green:1.0f blue:0 alpha:0.9f]];
//        [self.view addSubview:notif];
//        
//        appearance =[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
////        appearance = [CABasicAnimation animationWithKeyPath:@"position"];
//        [appearance setValue:@"animation1" forKey:@"id"];
//        appearance.delegate = self;
//        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:)];
//        appearance.duration = 0.5;
//        appearance.fromValue = [NSNumber numberWithFloat:0];
//        appearance.toValue = [NSNumber numberWithFloat:340];//]1.0f*M_PI];
////        appearance.fromValue = [NSValue valueWithCGPoint:CGPointMake(100, 0)];//start
////        appearance.toValue = [NSValue valueWithCGPoint:CGPointMake(100, 300)];//end
//        appearance.repeatCount = 1;
//        appearance.fillMode = kCAFillModeForwards;
//        appearance.removedOnCompletion = NO;
//        [notif.layer addAnimation:appearance forKey:@"transform.translation.y"];
////        [notif.layer addAnimation:appearance forKey:@"position"];
//        
        
//    }else if((int)counter % 10 == 0){
    }
    else if((int)counter % 30 == 0){
//    if((int)counter % 50 == 0 && [BackGround getY1] > 0){
        
        if([BackGround getImageView1].layer.speed > 0){
            NSLog(@"speed = %f", [BackGround getImageView1].layer.speed);
            NSLog(@"oscillate from controller");
            [BackGround pauseAnimations];
            
//            [BackGround addIvOscillate];
            [self.view addSubview:[BackGround getIvOscillate1]];
            [self.view addSubview:[BackGround getIvOscillate2]];
            [self.view bringSubviewToFront:[BackGround getIvOscillate1]];
            [self.view bringSubviewToFront:[BackGround getIvOscillate2]];
            [BackGround oscillateEffect:10];
        }else{
            NSLog(@"speed = %f", [BackGround getImageView1].layer.speed);
        }
        
//        [notif.layer removeAllAnimations];
        
//        if(notif.layer.speed > 0){
//            NSLog(@"oscillate notif at speed=%f", notif.layer.speed);
//            [self pauseAnimations];//:notif.layer];//一旦停止
//        
//            ivOscillate = [[UIImageView alloc]initWithFrame:notif.frame];
//            
////            ivOscillate = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,
////                                                                       notif.bounds.size.width,
////                                                                       notif.bounds.size.height)];
////            ivOscillate.center = ((CALayer *)[notif.layer presentationLayer]).position;
//            [ivOscillate setBackgroundColor:[UIColor colorWithRed:1.0f green:0 blue:0 alpha:0.5f]];
//            [self.view addSubview:ivOscillate];
//            
//            
//            [self oscillate:5];
//        }
        
        
//    }else if(counter % 40 == 0){
//        if(notif.layer.speed == 0){
//            NSLog(@"resume at speed = %f", notif.layer.speed);
//            [self resumeAnimations];
//        }
    }
//    NSLog(@"count : %d , y=%f", counter, ((CALayer *)[notif.layer presentationLayer]).position.y);
#elif defined BTNPRESS_TEST
    if(counter == 0){
//        UIButton *btn = [UIButton allo
//        imv_test = [[UIImageView alloc]initWithFrame:CGRectMake(100, 200, 60, 60)];
//        imv_test.image = [UIImage imageNamed:@"btn_g_off2.png"];
//        [self.view addSubview:imv_test];
//        imv_test.userInteractionEnabled = YES;
        imv_test = [[MenuButtonWithView alloc]initWithFrame:CGRectMake(100, 200, 60, 60)
                                                   backType:ButtonMenuBackTypeBlue
                                                  imageType:ButtonMenuImageTypeInn
                                                     target:self
                                                   selector:@"buttonPressed:"
                                                        tag:0];//arg

        [self.view addSubview:imv_test];
        
    }
    
#elif defined COOLBUTTON_TEST
    if(counter == 0){
//        [self.view setBackgroundColor:[UIColor whiteColor]];
        NSLog(@"coolbutton test");
//        coolButton = [[CoolButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        coolButton = [CoolButton buttonWithType:UIButtonTypeRoundedRect];
        coolButton.frame = CGRectMake(50, 50, 100, 70);
        [coolButton setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:coolButton];
        
        tv_hue = [[UITextView alloc] initWithFrame:CGRectMake(120, 10, 200, 30)];
        tv_saturation = [[UITextView alloc] initWithFrame:CGRectMake(120, 40, 200, 30)];
        tv_brightness = [[UITextView alloc] initWithFrame:CGRectMake(120, 70, 200, 30)];
        
        tv_hue.textColor = [UIColor whiteColor];
        tv_saturation.textColor = [UIColor whiteColor];
        tv_brightness.textColor = [UIColor whiteColor];
        
        tv_hue.backgroundColor = [UIColor clearColor];
        tv_saturation.backgroundColor = [UIColor clearColor];
        tv_brightness.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:tv_hue];
        [self.view addSubview:tv_saturation];
        [self.view addSubview:tv_brightness];
        
        UISlider *sl1 = [[UISlider alloc] initWithFrame:CGRectMake(20, 200, 200, 10)];
        UISlider *sl2 = [[UISlider alloc] initWithFrame:CGRectMake(20, 250, 200, 10)];
        UISlider *sl3 = [[UISlider alloc] initWithFrame:CGRectMake(20, 300, 200, 10)];
        //デフォルトでは以下のようになっているハズ
//        sl.minimumValue = 0.0;  // 最小値を0に設定
//        sl.maximumValue = 1.0f;  // 最大値を500に設定
//        sl.value = 0.5f;  // 初期値を250に設定
        // 値が変更された時にhogeメソッドを呼び出す
        [sl1 addTarget:self action:@selector(hueValueChanged:) forControlEvents:UIControlEventValueChanged];
        [sl2 addTarget:self action:@selector(saturationValueChanged:) forControlEvents:UIControlEventValueChanged];
        [sl3 addTarget:self action:@selector(brightnessValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        
        [self.view addSubview:sl1];
        [self.view addSubview:sl2];
        [self.view addSubview:sl3];
    }
    
#elif defined SPECIALWEAPON_TEST
    BeamClass *a = [[SpecialBeamClass alloc] init:100 y_init:100 width:50 height:50 type:0];
    [self.view addSubview:[a getImageView]];
    
#elif defined PARTICLE_TEST
    if(counter == 0){
//        array = [[NSMutableArray alloc] init];
        ViewFireWorks *v = [[ViewFireWorks alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [self.view addSubview:v];
        

    }else if(counter % 4 == 0){//every 3sec
//        NSLog(@"damageParticle%d", (int)(counter / 4));
        DamageParticleView *damageParticle;
        damageParticle =
        [[DamageParticleView alloc]
         initWithFrame:CGRectMake(self.view.bounds.size.width/2 + (arc4random() % 50) * pow(-1, arc4random()%2+1),
                                  self.view.bounds.size.height - arc4random()%50, 30, 30)];
        [damageParticle setIsEmitting:YES];
        
        [damageParticle setColor:(DamageParticleType)(counter % 10)];
        [self.view addSubview:damageParticle];
        
        [UIView animateWithDuration:0.3f
                         animations:^{
                             [damageParticle setAlpha:0.0f];//徐々に薄く
                         }
                         completion:^(BOOL finished){
                             if(finished){//終了時処理
                                 [damageParticle setIsEmitting:NO];
                                 [damageParticle removeFromSuperview];
                             }
                         }];
    }
    
    
    if(false){//counter % 20 != 0){//0, 1, ..., 19
        tempInt1 = counter % 320;
        
        kiraParticle = [[KiraParticleView alloc] initWithFrame:CGRectMake(tempInt1, 240,
                                                                          30, 30)
                                                  particleType:ParticleTypeFireworks];
        [array insertObject:kiraParticle atIndex:0];
        [self.view addSubview:[array objectAtIndex:0]];
        
        
        
        NSLog(@"counter=%d, %d", counter, [array count]);
//        [UIView animateWithDuration:2.0f
//                         animations:^{
//                             kiraParticle.alpha = 0.0f;
//                         }
//                         completion:^(BOOL finished){
//                             tempInt2 = 0;
//                             [[array lastObject] removeFromSuperview];
//                         }];
        
    }else if(false){
        NSLog(@"remove object , num of array = %d", [array count]);
        for(;[array count]>0;){
            [[array lastObject] removeFromSuperview];
            [array removeLastObject];
        }
        
        kiraMovingParticle = [[KiraParticleView alloc] initWithFrame:CGRectMake((counter+80) % 320,
                                                                                480,
                                                                                30,30)
                                                        particleType:ParticleTypeMoving];
        [self.view addSubview:kiraMovingParticle];
        [UIView animateWithDuration:1.0f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             kiraMovingParticle.center = CGPointMake((counter+80) % 320, 240);
                             kiraMovingParticle.alpha = 0.2f;
                         }
                         completion:^(BOOL finished){
                             [kiraMovingParticle removeFromSuperview];
                         }];
//        [array removeAllObjects];
    }
    
    
#elif defined EXPLODE_TEST
    if(counter == 0){
        [self.view setBackgroundColor:[UIColor grayColor]];
        
        ViewExplode *_viewEx = [[ViewExplode alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2,
                                                                             self.view.bounds.size.height/2, 1, 1)
                                                             type:ExplodeTypeRed];
//                                type:ExplodeTypeFireBomb];
        [self.view addSubview:_viewEx];
        
        
        NSLog(@"viewkira.center = %f, %f", _viewEx.center.x, _viewEx.center.y);
        [_viewEx explode:(int)100 angle:(int)60 x:(float)_viewEx.center.x y:(float)_viewEx.center.y];
    }
#elif defined VIEWWITHEFFECTLEVELUP_TEST
    if(counter == 0){
        UIView *vwel = [[ViewWithEffectLevelUp alloc]
                        initWithFrame:self.view.bounds
                        beforeLevel:30
                        afterLevel:31
                        ];
        [self.view addSubview:vwel];
    }
#elif defined LDPROGRESS_TEST
    if(counter == 0){
        // default color, animated
        LDProgressView *progressView = [[LDProgressView alloc] initWithFrame:CGRectMake(20, 130, self.view.frame.size.width-40, 22)];
        progressView.progress = 0.40;
        [self.progressViews addObject:progressView];
        [self.view addSubview:progressView];
        
        
        // flat, green, animated
        progressView = [[LDProgressView alloc] initWithFrame:CGRectMake(20, 160, self.view.frame.size.width-40, 22)];
        progressView.color = [UIColor colorWithRed:0.00f green:0.64f blue:0.00f alpha:1.00f];
        progressView.flat = @YES;
        progressView.progress = 0.40;
        progressView.animate = @YES;
        [self.progressViews addObject:progressView];
        [self.view addSubview:progressView];
    }
    
#elif defined PAYPRODUCTBUTTON_TEST
    if(counter == 0){
        UIImageView *button =
        [CreateComponentClass
         createMenuButton:ButtonMenuBackTypeBlue
         imageType:ButtonMenuImageTypeBuyCoin0
         rect:CGRectMake(100, 100, 60, 60)
         target:nil selector:nil];
        
        UIView *shadowView =
        [CreateComponentClass
         createShadowView:CGRectMake(5, 5, button.bounds.size.width-10, button.bounds.size.height/4)
         viewColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f]
         borderColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5f]
         text:@"test"
         textSize:14];
        [button addSubview:shadowView];
        
        [self.view addSubview:button];
    }
#elif defined LOCATION_TEST
    
    if(counter == 0){
        
        
        //        // プロパティではなくクラスメソッドです
        //        if ([CLLocationManager locationServicesEnabled]) {
        //            // インスタンスを生成し、デリゲートの設定
        //            CLLocationManager *_manager = [[CLLocationManager alloc] init];
        //
        //            _manager.delegate = self;
        //
        //            // 取得精度
        //            _manager.desiredAccuracy = kCLLocationAccuracyBest;
        //            // 更新頻度（メートル）
        //            _manager.distanceFilter = kCLDistanceFilterNone;
        //            // サービスの開始
        //            [_manager startUpdatingLocation];
        //
        //            NSLog(@"location service is started");
        //        }else{
        //            
        //            NSLog(@"location service is not enabled");
        //        }
        
        //通常viewWillAppear等で呼出しを実行
        [self startLocationService];
        
        
    }
#elif defined SPWeapon_TEST
    if(counter == 0){
        
        
        //ice-effect
        UIImageView *iceView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 1, 1)];
        iceView.image = [UIImage imageNamed:@"ice_icon.png"];
        [self.view addSubview:iceView];
        
        [UIView animateWithDuration:1.0f
                         animations:^{
                             iceView.frame = CGRectMake(100, 100, 100, 100);
                         }
                         completion:^(BOOL finished){
                             [iceView removeFromSuperview];
                         }];
        
        
        //red-fire
        ExplodeParticleView *explode;
        explode =
        //            viewEffect =
        (ExplodeParticleView *)[[ExplodeParticleView alloc]initWithFrame:CGRectMake(200, 100, 100, 100)];
        [explode setColor:ExplodeParticleTypeRedFire];//orange-fire
        [explode setOnOffEmitting];//発火と消火の繰り返し
        [self.view addSubview:explode];
        
        
        //blue-fire
        ExplodeParticleView *blueFire;
        blueFire =
        //            viewEffect =
        (ExplodeParticleView *)[[ExplodeParticleView alloc]initWithFrame:CGRectMake(200, 200, 100, 100)];
//        [blueFire setType:3];//blue-fire
         [blueFire setColor:ExplodeParticleTypeBlueFire];
        [blueFire setBirthRate:150];
        [blueFire setOnOffEmitting];//発火と消火の繰り返し
        [self.view addSubview:blueFire];
        
        
        
        //orange-fire
        ExplodeParticleView *orangeFire;
        orangeFire =
        //            viewEffect =
        (ExplodeParticleView *)[[ExplodeParticleView alloc]initWithFrame:CGRectMake(200, 300, 100, 100)];
        [orangeFire setColor:ExplodeParticleTypeOrangeFire];
        [orangeFire setBirthRate:150];
        [orangeFire setOnOffEmitting];//発火と消火の繰り返し
        [self.view addSubview:orangeFire];
        
        
        //black-fire
        ExplodeParticleView *blackFire;
        blackFire =
        //            viewEffect =
        (ExplodeParticleView *)[[ExplodeParticleView alloc]initWithFrame:CGRectMake(200, 350, 100, 100)];
        [blackFire setColor:ExplodeParticleTypeBlackFire];
        [blackFire setBirthRate:150];
        [blackFire setOnOffEmitting];//発火と消火の繰り返し
        [self.view addSubview:blackFire];
        
        
        
//        KiraParticleView *water = [[KiraParticleView alloc] initWithFrame:CGRectMake(200, 300, 100, 100)
//                                                    particleType:ParticleTypeKilled];
//        [water setParticleType:ParticleTypeMoving];
//        [self.view addSubview:water];
        
        //bubble
        ExplodeParticleView *water =
        (ExplodeParticleView *)[[ExplodeParticleView alloc]initWithFrame:CGRectMake(200, 300, 100, 100)
                                                                    type:ExplodeParticleTypeWater];
        [water setOnOffEmitting];
        [self.view addSubview:water];

//        BeamTypeWing
        //http://jp.123rf.com/photo_7276437_abstract-spiral-galaxy-icon-isolated-on-white.html
//        UIImageView *ivWind = [[UIImageView alloc]initWithFrame:CGRectMake(200, 300, 50, 50)];
//        ivWind.image = [UIImage imageNamed:@"wind_effect.png"];
////        ivWind.image = [UIImage imageNamed:@"wing_swirl.png"];
//        [self.view addSubview:ivWind];
//        [ivWind setAlpha:0.5f];
//        [self spinWith:ivWind times:30];
        
        
//        BeamTypeCloth
//        UIImageView *ivCloth = [[UIImageView alloc]initWithFrame:CGRectMake(200,350, 1, 50)];
//        ivCloth.image = [UIImage imageNamed:@"sozai_maki.png"];
//        [self.view addSubview:ivCloth];
//        ivCloth.alpha = 0.3f;
//        [self extendWith:ivCloth times:30];
        
//        [UIView animateWithDuration:1.0f
//                         animations:^{
//                             ivCloth.alpha = 1.0f;
//                         }
//                         completion:^(BOOL finished){
//                             if(finished){
//                                 [self extendWith:ivCloth times:30];
//                             }
//                         }];
        
        
        
        
    }
    
#elif defined Animation_TEST
    if(counter == 0){
        
        
//        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 5, 200)];
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(100, 50, 1, 100)];
        view.image = [UIImage imageNamed:@"icon_scratch_horizon.png"];
        [view setBackgroundColor:[UIColor colorWithRed:0 green:0.5 blue:0.3f alpha:1.0f]];
        view.transform = CGAffineTransformMakeRotation(45.0f*M_PI/180.0f);//時計回り
        [self.view addSubview:view];
        
        
        UIImageView *view2 = [[UIImageView alloc] initWithFrame:CGRectMake(200, 50, 1, 100)];
        view2.image = [UIImage imageNamed:@"icon_scratch_horizon.png"];
        [view2 setBackgroundColor:[UIColor colorWithRed:0 green:0.5 blue:0.3f alpha:1.0f]];
        view2.transform = CGAffineTransformMakeRotation(-45.0f*M_PI/180.0f);//anti時計回り
        [self.view addSubview:view2];
        
        
        
        
        //最終位置
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
        [view1 setBackgroundColor:[UIColor colorWithRed:0.5f green:0 blue:0 alpha:0.8f]];
        [self.view addSubview:view1];
        
        [UIView
         animateWithDuration:3.0f
         animations:^{
//             view.transform = CGAffineTransformMakeRotation(45.0f*M_PI/180.0f);//時計回り
             view.frame = CGRectMake(150, 150 - 100/sqrt(2),
                                     0, 50 + 100/sqrt(2));
             view.transform =
             CGAffineTransformMakeRotation(45.0f*M_PI/180.0f);
         }
         completion:^(BOOL finished){
             if(finished){
                 [UIView
                  animateWithDuration:3.0f
                  animations:^{
                      view2.frame = CGRectMake(150, 150 - 100/sqrt(2),
                                              0, 50 + 100/sqrt(2));
                      view2.transform =
                      CGAffineTransformMakeRotation(-45.0f*M_PI/180.0f);
                  }
                  completion:^(BOOL finished){
                      
                  }];
                 
                 
             }
         }];
    }
#elif defined BLOG_UP_TEST
    
    if(counter == 0){
//        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(100,100,100,100)];
//        iv.image = nil;
//        [self.view addSubview:iv];
        
        
        CGRect rect = CGRectMake(0, 0, 70, 70);
        uiv = (UIImageView *)[[UIImageView alloc]initWithFrame:rect];

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
        ((UIImageView *)uiv).animationImages = imgArray;
        ((UIImageView *)uiv).animationRepeatCount = 0;
        ((UIImageView *)uiv).animationDuration = 1.0f; // アニメーション全体で1秒（＝各間隔は0.5秒）
        [((UIImageView *)uiv) startAnimating]; // アニメーション開始
        
        [self.view addSubview:uiv];
        
        uiv.center = CGPointMake(self.view.bounds.size.width/2,
                                self.view.bounds.size.height/2);
        
        uiv.userInteractionEnabled = YES;
        UIPanGestureRecognizer *flick_frame = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(onFlickedFrame:)];
        
        [uiv addGestureRecognizer:flick_frame];
        
        

        
//        MyMachineClass *me = [[MyMachineClass alloc]init];
//        [self.view addSubview:[me getImageView]];
    }else if(counter == 10){
        
        
        MyMachineClass *MyMachine = [[MyMachineClass alloc]init];//WithFrame:CGRectMake(10, 10, 60, 60)];
//        [MyMachine getImageView].center = CGPointMake(self.view.bounds.size.width/2,
//                                                      self.view.bounds.size.height/2);
        [MyMachine setDamage:100 location:CGPointMake(self.view.bounds.size.width/2,
                                                      self.view.bounds.size.height/2)];
        
        
        
        [[MyMachine getExplodeParticle] setUserInteractionEnabled: NO];//インタラクション拒否
        [[MyMachine getExplodeParticle] setIsEmitting:YES];//消去するには数秒後にNOに
        
        [self.view addSubview: [MyMachine getExplodeParticle]];//表示する
        [MyMachine getExplodeParticle].center =CGPointMake(self.view.bounds.size.width/2,
                                                           self.view.bounds.size.height/2);
        [self.view bringSubviewToFront: [MyMachine getExplodeParticle]];//最前面に
        
//        [UIView animateWithDuration:5.0f
//                         animations:^{
//                             [[MyMachine getExplodeParticle] setAlpha:0];
//                         }];
        
    }
    
#else
//    NSLog(@"aaa");
    //nothing
#endif
    
#ifdef ORBITPATH_TEST
    if(counter == 0){
        [self orbitPath];
    }
#endif
    counter ++;
}


#ifdef SPWeapon_TEST
-(void)spinWith:(UIView *)_viewArg times:(int)_times{
    [UIView animateWithDuration: 0.5f
                          delay: 0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations: ^{
                         _viewArg.transform = CGAffineTransformRotate(_viewArg.transform, M_PI / 2);
//                         _viewArg.alpha = 1.0f;
                     }
                     completion: ^(BOOL finished) {
                         if (finished) {
                             NSLog(@"times=%d", _times);
                             if (_times > 0) {
                                 // if flag still set, keep spinning with constant speed
//                                 _viewArg.alpha = 0.0f;
                                 [self spinWith:_viewArg times:_times-1];
                             }else{
                                 [_viewArg removeFromSuperview];
                             }
                         }
                     }];
}

-(void)extendWith:(UIView *)_viewArg times:(int)_times{
    [UIView animateWithDuration:0.5f
                     animations:^{
                         //立て幅と同じになるまで広げる
                         _viewArg.frame =
                         CGRectMake(_viewArg.frame.origin.x, _viewArg.frame.origin.y,
                                    _viewArg.bounds.size.height, _viewArg.bounds.size.height);
                         _viewArg.alpha = 1.0f;
                     }
                     completion:^(BOOL finished){
                         if(finished){
                             if(_times > 0){
                                 _viewArg.frame = CGRectMake(_viewArg.frame.origin.x, _viewArg.frame.origin.y,
                                                             1, _viewArg.bounds.size.height);
                                 _viewArg.alpha = 0.1f;
                                 [self extendWith:_viewArg times:_times-1];
                             }else{
                                 [_viewArg removeFromSuperview];
                             }
                         }
                     }];
}

#endif

#ifdef BTNPRESS_TEST
//-(void)buttonPressed:(id)sender{
//    NSLog(@"%d", [sender tag]);
//}
-(void)buttonPressed:(NSNumber *)num{
    NSLog(@"arg = %d", num.integerValue);
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // シングルタッチの場合
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:imv_test];
    NSLog(@"touchedBegan x:%f y:%f", location.x, location.y);
    if(imv_test.image == [UIImage imageNamed:@"btn_g_off2.png"]){
        imv_test.image = [UIImage imageNamed:@"btn_g_on2.png"];
    }else{
        imv_test.image = [UIImage imageNamed:@"btn_g_off2.png"];
    }
    
    
//    // マルチタッチの場合
//    for (UITouch *touch in touches) {
//        CGPoint location = [touch locationInView:self];
//        NSLog(@"x:%f y:%f", location.x, location.y);
//    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:imv_test];
    //離れた位置がボタン中心から離れていれば元に戻して何もしない
    NSLog(@"touchedEnded x:%f y:%f", location.x, location.y);
//    if(ABS(location.x - originalPressedX) > 100 || ...){
    if(imv_test.image == [UIImage imageNamed:@"btn_g_off2.png"]){
        imv_test.image = [UIImage imageNamed:@"btn_g_on2.png"];
    }else{
        imv_test.image = [UIImage imageNamed:@"btn_g_off2.png"];
    }
}

#endif

#ifdef COOLBUTTON_TEST
-(void)hueValueChanged:(id)sender{
    UISlider *sl = (UISlider *)sender;
    coolButton.hue = sl.value;
    tv_hue.text = [NSString stringWithFormat:@"hue=%f", sl.value];
}

-(void)saturationValueChanged:(id)sender{
    UISlider *sl = (UISlider *)sender;
    coolButton.saturation = sl.value;
    tv_saturation.text = [NSString stringWithFormat:@"saturation=%f", sl.value];
}

-(void)brightnessValueChanged:(id)sender{
    UISlider *sl = (UISlider *)sender;
    coolButton.brightness = sl.value;
    tv_brightness.text = [NSString stringWithFormat:@"bright=%f", sl.value];
}

#endif

#ifdef BACKGROUND_TEST
-(void)animationDidStop:(CAAnimation *)theAnimation2 finished:(BOOL)flag {
    NSLog(@"1 animation did stop method call");
    if([[theAnimation2 valueForKey:@"id"] isEqual:@"animation1"]) {
        NSLog(@"2 animation did stop method call");
//        CABasicAnimation * theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
        CABasicAnimation *theAnimation =
            [CABasicAnimation animationWithKeyPath:@"position"];
        theAnimation.duration = 0.5;
//        theAnimation.fromValue = [NSNumber numberWithFloat:0];
//        theAnimation.toValue = [NSNumber numberWithFloat:100];
        theAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(200, 0)];
        theAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(200, 200)];
        theAnimation.repeatCount = 3;
        theAnimation.autoreverses = YES;
        theAnimation.fillMode = kCAFillModeForwards;
        theAnimation.removedOnCompletion = NO;
        NSLog(@"appearance beginTime=%f, duration=%f",
              appearance.beginTime, appearance.duration);
        theAnimation.beginTime = appearance.beginTime + appearance.duration;
//        [notif.layer addAnimation:theAnimation forKey:@"transform.translation.y"];
        [notif.layer addAnimation:theAnimation forKey:@"position"];
    }
}


-(void)nextAnimation{
    [CATransaction begin];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [CATransaction setCompletionBlock:^{
        CAAnimation *animationKeyFrame = [notif.layer animationForKey:@"position"];
        if(animationKeyFrame){
                NSLog(@"completion at %f", ((CALayer *)[notif.layer presentationLayer]).position.y);
                [notif.layer removeAnimationForKey:@"position"];
//                //            notif.center = CGPointMake(0, 0);
//                //            [self animationDidStop:appearance finished:YES];
//                [self nextAnimation];
        }else{
            NSLog(@"not completion");
        }
    }];
    
    {
        //        appearance =[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        CABasicAnimation *appearance = [CABasicAnimation animationWithKeyPath:@"position"];
        [appearance setValue:@"animation1" forKey:@"id"];
        //        appearance.delegate = self;
        //        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:)];
        appearance.duration = 2.0f;
        appearance.repeatCount = HUGE_VAL;//repeat infinitely
        //        appearance.fromValue = [NSNumber numberWithFloat:0];
        //        appearance.toValue = [NSNumber numberWithFloat:340];//]1.0f*M_PI];
        appearance.fromValue = [NSValue valueWithCGPoint:CGPointMake(200, 0)];//start
        appearance.toValue = [NSValue valueWithCGPoint:CGPointMake(200, 400)];//end
//        appearance.repeatCount = 0;//sequential infinitely->already done in catransaction
        appearance.fillMode = kCAFillModeForwards;
        appearance.removedOnCompletion = NO;
        //        [notif.layer addAnimation:appearance forKey:@"transform.translation.y"];
        [notif.layer addAnimation:appearance forKey:@"position"];
        
    }
    [CATransaction commit];
    
}

- (void)pauseAnimations//:(CALayer *)layer
{
//    NSLog(@"pausing : lay=%f", ((CALayer *)[layer presentationLayer]).position.y);
//    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
//    layer.speed = 0.0;    // 時よ止まれ
//    layer.timeOffset = pausedTime;
    NSLog(@"pausing : lay=%f", ((CALayer *)[notif.layer presentationLayer]).position.y);
    CFTimeInterval pausedTime = [notif.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    notif.layer.speed = 0.0;    // 時よ止まれ
    notif.layer.timeOffset = pausedTime;

}

- (void)resumeAnimations//:(CALayer *)layer
{
    NSLog(@"resume : lay=%f", ((CALayer *)[notif.layer presentationLayer]).position.y);
    CFTimeInterval pausedTime = [notif.layer timeOffset];
    notif.layer.speed = 1.0;    // そして時は動き出す
    notif.layer.timeOffset = 0.0;
    notif.layer.beginTime = 0.0;//これをしないとループアニメーションの二回目以降でストップ後の再開時にストップ場所から開始されない
    CFTimeInterval timeSincePause = [notif.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    notif.layer.beginTime = timeSincePause;
}

-(void)oscillate:(int)repCount{
    
    
    CGPoint nowPos = ((CALayer *)[notif.layer presentationLayer]).position;
    CGPoint rightPos = CGPointMake(nowPos.x + 50,
                                   nowPos.y);
    CGPoint leftPos = CGPointMake(nowPos.x - 50,
                                   nowPos.y);
    [CATransaction begin];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [CATransaction setCompletionBlock:^{
        CAAnimation *animationKeyFrame = [ivOscillate.layer animationForKey:@"position"];
        if(animationKeyFrame){
            NSLog(@"oscillate %d : completion", repCount);
            [ivOscillate.layer removeAnimationForKey:@"position"];
            //            notif.center = CGPointMake(0, 0);
            //            [self animationDidStop:appearance finished:YES];
            if(repCount > 0){
                [self oscillate:repCount-1];
            }else{
                [ivOscillate removeFromSuperview];
                NSLog(@"at oscillate : notif.center=%f, lay=%f", notif.center.y,
                      ((CALayer *)[notif.layer presentationLayer]).position.y);
//                [self nextAnimation];
                [self resumeAnimations];//:notif.layer];//再開
                //次のnextAnimationから正常に実行されていない？->確認？
                //notif.layer上のアニメーションをpauseではなく、stopさせる方法は？次からは現在位置を取得して新規アニメーションで実行
                //nextAnimationを再開する前にnotif.layer presentationLayer . positionにポジショニング？
                //ー＞.center = ... or search for positioning
            }
        }else{
            NSLog(@"not completion");
        }
    }];
    
    {
        //        appearance =[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        //ref:http://stackoverflow.com/questions/7788289/running-cabasicanimation-sequentially
        CABasicAnimation *appearance = [CABasicAnimation animationWithKeyPath:@"position"];
        [appearance setValue:@"animation1" forKey:@"id"];
        //        appearance.delegate = self;
        //        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:)];
        appearance.duration = 0.1f;
        //        appearance.fromValue = [NSNumber numberWithFloat:0];
        //        appearance.toValue = [NSNumber numberWithFloat:340];//]1.0f*M_PI];
        appearance.fromValue = [NSValue valueWithCGPoint:nowPos];//start
        appearance.toValue = [NSValue valueWithCGPoint:((repCount%2==0)?rightPos:leftPos)];//end
//        appearance.repeatCount = 0;//sequential infinitely
        appearance.fillMode = kCAFillModeForwards;
        appearance.removedOnCompletion = NO;
        //        [notif.layer addAnimation:appearance forKey:@"transform.translation.y"];
        [ivOscillate.layer addAnimation:appearance forKey:@"position"];
        
    }
    [CATransaction commit];
}
#endif

-(void)effectTest{
    //uiv-center-circle->radius:Smaller
//    Effect *effect = [[Effect alloc]init];
//    [uiv addSubview:[effect getEffectView:EffectTypeStandard]];
    
//    UIImageView *ivTest = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
//    [ivTest setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.1f]];
//
//    CALayer *orbit1 = [CALayer layer];
//    orbit1.bounds = CGRectMake(0, 0, 200, 200);
//    orbit1.position = ivTest.center;
//    orbit1.cornerRadius = 100;
//    orbit1.borderColor = [UIColor redColor].CGColor;
//    orbit1.borderWidth = 1.5;
//    orbit1.backgroundColor = [UIColor colorWithRed:0.5 green:0.1 blue:0.1 alpha:0.3f].CGColor;
//    [ivTest.layer addSublayer:orbit1];
    
    
//    ivTest.image = [UIImage imageNamed:@"powerGauge2.png"];
    
//    [UIView animateWithDuration:1.0f
//                          delay:0.0f
//                        options:UIViewAnimationOptionRepeat
////                                |UIViewAnimationOptionAutoreverse
//                     animations:^{
//                         [UIView setAnimationRepeatCount: 3.0];
////                         ivTest.bounds = CGRectMake(0, 0, 1, 1);
//                         [[circleView layer] setFrame:CGRectMake(self.view.center.x, self.view.center.y, 1, 1)];
////                         circleView.layer.cornerRadius = 1.0f;
//                     }
//                     completion:^(BOOL finished){
//                         tempCount++;
//                         NSLog(@"counter=%d", tempCount);
//                     }];
////    [uiv addSubview:ivTest];
//    [uiv addSubview:circleView];
    
//    
//    //http://stackoverflow.com/questions/10669051/how-do-i-create-a-smoothly-resizable-circular-uiview
//    UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(30, 30, 100, 100)];
//    circle.center = CGPointMake(100, 100);
//    circle.layer.cornerRadius=50;
//    [[circle layer] setBorderColor:[[UIColor orangeColor] CGColor]];
//    [[circle layer] setBorderWidth:2.0];
//    [[circle layer] setBackgroundColor:[[[UIColor orangeColor] colorWithAlphaComponent:0.5] CGColor]];
//    [[self view] addSubview:circle];
//    
//    CGFloat animationDuration = 1.0; // Your duration
//    CGFloat animationDelay = 0; // Your delay (if any)
//    
//    CABasicAnimation *cornerRadiusAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
//    [cornerRadiusAnimation setFromValue:[NSNumber numberWithFloat:50.0]]; // The current value
//    [cornerRadiusAnimation setToValue:[NSNumber numberWithFloat:10.0]]; // The new value
//    [cornerRadiusAnimation setDuration:animationDuration];
//    [cornerRadiusAnimation setBeginTime:CACurrentMediaTime() + animationDelay];
//    [cornerRadiusAnimation setRepeatCount:3.0f];
//    
//    // If your UIView animation uses a timing funcition then your basic animation needs the same one
//    [cornerRadiusAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//    
//    // This will keep make the animation look as the "from" and "to" values before and after the animation
//    [cornerRadiusAnimation setFillMode:kCAFillModeBoth];
//    [[circle layer] addAnimation:cornerRadiusAnimation forKey:@"keepAsCircle"];
//    [[circle layer] setCornerRadius:10.0]; // Core Animation doesn't change the real value so we have to.
//    
//    [UIView animateWithDuration:animationDuration
//                          delay:animationDelay
//                        options:UIViewAnimationOptionCurveEaseInOut
////                                |UIViewAnimationOptionRepeat
//                     animations:^{
//                         [UIView setAnimationRepeatCount: 3.0];
//                         [[circle layer] setFrame:CGRectMake(50, 50, 20, 20)]; // Arbitrary frame ...
////                         circle.layer.frame = CGRectMake(50, 50, 0, 0);
//                         circle.center = CGPointMake(100, 100);
//                         // You other UIView animations in here...
//                     } completion:^(BOOL finished) {
//                         // Maybe you have your completion in here...
//                         [circle removeFromSuperview];
//                     }];
//    [uiv addSubview:circle];
    
    Effect *effect = [[Effect alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    UIView *circle = [effect getEffectView:EffectTypeStandard];
    [uiv addSubview:circle];
}
-(void)explodeTest{
    
    //ランダムに配置
    //急速に拡大
    //拡大速度をゆっくり
    //徐々に薄く
    
    
    int xinit = 100;
    int yinit = 100;
//    int trans = 50;
    int arc11 = 80;//arc4random() % trans - trans/2;//移動位置x
    int arc21 = 80;//arc4random() % trans - trans/2;//移動位置y
    
    int size = arc4random() % 50;
    size = MIN(size, 30);

    
    //100位置を示す
//    UIImageView *u = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
//    [u setBackgroundColor:[UIColor blueColor]];
//    u.center = CGPointMake(xinit, yinit);
//    [self.view addSubview:u];

    UIView *sv = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 200,200)];
    [sv setBackgroundColor:[UIColor colorWithRed:0.5 green:0.8 blue:0.9 alpha:0.1f]];
    
    UIImageView *uiiv = [[UIImageView alloc]initWithFrame:CGRectMake(xinit,
                                                                     yinit,
                                                                     2, 2)];
    uiiv.center = CGPointMake(xinit, yinit);
    [uiiv setAlpha:1.0f];//init:0
//    UIImageView *uiiv = [[UIImageView alloc]initWithFrame:CGRectMake(arc4random() % 100,
//                                                                     arc4random() % 100,
//                                                                     100, 100)];
    uiiv.image = [UIImage imageNamed:@"smoke.png"];
    [UIView animateWithDuration:0.1f
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut//early-slow-stop
                     animations:^{
                         uiiv.center = CGPointMake(xinit + arc11,
                                                   yinit + arc21);//center
                         uiiv.frame = CGRectMake(xinit + arc11 - size/2, yinit + arc21 - size/2,
                                                 size, size);//resize

                         
                         [uiiv setAlpha:0.5f];
                         [self.view sendSubviewToBack:uiiv];
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.8f
                                               delay:0.0f
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              uiiv.frame = CGRectMake(xinit + arc11 - size*3/2,
                                                                      yinit + arc21 - size*3/2,
                                                                      size*3, size*3);
                                              [uiiv setAlpha:0.0f];
                                          }
                                          completion:^(BOOL finished){
                                              
                                              [uiiv removeFromSuperview];
                                          }];
                         
                         
                         
                     }];
    
    
    [sv addSubview:uiiv];
    [self.view addSubview:sv];
}

-(void)animateChangeImage{
//    uiiv.image = [UIImage imageNamed:(i % 2) ? @"3.jpg" : @"4.jpg"];
//    
//    CATransition *transition = [CATransition animation];
//    transition.duration = 1.0f;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionFade;
//    
//    [uiiv.layer addAnimation:transition forKey:nil];

//UIViewAnimationOptionTransitionCrossDissolve
    [UIView transitionWithView:uiiv
                      duration:3.0f
                       options:UIViewAnimationOptionTransitionCurlDown
                    animations:^{
                        uiiv.image = [UIImage imageNamed:imageName];
                    } completion:^(BOOL finished){
//                        counter++;
//                        if(counter % 2 == 0){
//                            //        uiiv.image = [UIImage imageNamed:@"tool_bomb.png"];
//                            imageName = @"tool_bomb.png";
//                            NSLog(@"tool_bomb.png");
//                        }else{
//                            //        uiiv.image = [UIImage imageNamed:@"coin_red"];
//                            imageName = @"coin_red.png";
//                            NSLog(@"coin_red");
//                        }
//                        [self animateChangeImage];
                        NSLog(@"finished");
                    }];
}

-(void)createBox{
    
#ifndef TEST
    CGRect rect = CGRectMake(arc4random() % (int)self.view.bounds.size.width, 0, 30, 30);
    UIView *newView = [CreateComponentClass createImageView:rect image:@"mob_tanu_01.png"];
    //    [[UIView alloc]initWithFrame:CGRectMake(arc4random() % (int)self.view.bounds.size.width, 0, 30, 30)];
    [newView setBackgroundColor:[UIColor colorWithRed:0.5f green:0 blue:0 alpha:0.5f]];
    
    [uiArray insertObject:newView atIndex:0];
    [self.view addSubview:[uiArray objectAtIndex:0]];
    if([uiArray count] > 10){
        [[uiArray lastObject] removeFromSuperview];
        [uiArray removeLastObject];
    }

#else
    EnemyClass *enemy = [[EnemyClass alloc]init];
    [enemy getImageView].center = CGPointMake(arc4random() % (int)self.view.bounds.size.width, 0);
    [uiArray insertObject:enemy atIndex:0];
    [self.view addSubview:[[uiArray objectAtIndex:0] getImageView]];
    if([uiArray count] > 100){
        [[[uiArray lastObject] getImageView] removeFromSuperview];
        [uiArray removeLastObject];
    }

#endif
    
}

-(void)moveBox{
#ifndef TEST
    for(int i = 0; i < [uiArray count] ;i++){
        ((UIView *)[uiArray objectAtIndex:i]).center =
            CGPointMake(((UIView *)[uiArray objectAtIndex:i]).center.x,
                        ((UIView *)[uiArray objectAtIndex:i]).center.y + 10);
    }
    CGPoint movedPoint = CGPointMake(uiv.center.x + 10, uiv.center.y + 10);
    uiv.center = movedPoint;//CGPointMake(uiv.center.x, uiv.center.y + 100);

#else
    
#ifdef MODE1
    
#else
    for(int i = 0; i < [uiArray count] ;i++){
        ((UIView *)[[uiArray objectAtIndex:i] getImageView]).center =
        CGPointMake(((UIView *)[[uiArray objectAtIndex:i] getImageView]).center.x,
                    ((UIView *)[[uiArray objectAtIndex:i] getImageView]).center.y + 30);
    }
#endif
    
#endif
    
}

-(void)orbitPath{//任意軌道上をアニメーションする
    CGPoint kStartPos = ((CALayer *)[uiv.layer presentationLayer]).position;
    CGPoint kEndPos = CGPointMake(self.view.bounds.size.width,
                                  kStartPos.y);
    // CAKeyframeAnimationオブジェクトを生成
    CAKeyframeAnimation *animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = 1.0;
    
    // 放物線のパスを生成
    CGFloat jumpHeight = 80.0;
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath, NULL, kStartPos.x, kStartPos.y);
    CGPathAddCurveToPoint(curvedPath, NULL,
                          kStartPos.x + jumpHeight/2, kStartPos.y - jumpHeight,
                          kEndPos.x - jumpHeight/2, kStartPos.y - jumpHeight,
                          kEndPos.x, kEndPos.y);
    
    // パスをCAKeyframeAnimationオブジェクトにセット
    animation.path = curvedPath;
    
    // パスを解放
    CGPathRelease(curvedPath);
    
    // レイヤーにアニメーションを追加
    [uiv.layer addAnimation:animation forKey:nil];
}

#ifdef TRACK_TEST
-(void)createView:(int)c{
    UIView *viewInArray = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    [viewInArray setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:((float)[array_uiv count]) /255.0f alpha:1.0f]];
    [self.view bringSubviewToFront:viewInArray];
    
    for(int i = 0 ;i < c;i ++){
        [self.view addSubview:viewInArray];
        [array_uiv addObject:viewInArray];
        
    }
    
    
    
    ItemClass *_item = [[ItemClass alloc] init:5
                                        x_init:30
                                        y_init:30
                                         width:70
                                        height:70];
    for(int i = 0; i < c;i++){
        [array_item addObject:_item];
        [self.view addSubview:[[array_item objectAtIndex:i] getImageView]];
    }
    
    
    /*
     
     tonarinoyatuurusei
     tonarinoyatuurusei
     tonarinoyatuurusei
     
     */
}


-(void) occureAnim{
    
    //createViewで発生させたビューを移動させる
    //NSTimerで毎カウント実行させて、見た目上、uivが動いたタイミングで他のviewInArrayも動かす
    UIView *viewInArray;
    for(int i = 0;i < [array_uiv count];i++){
//        NSLog(@"array count = %d", i);
        viewInArray = (UIView *)[array_uiv objectAtIndex:i];
        //座標位置が異なればアニメーションさせる
//        NSLog(@"judge at %d, uiv.x = %f, uiv.y = %f, x = %f, y = %f", i, uiv.center.x, uiv.center.y, viewInArray.center.x, viewInArray.center.y);
        if(uiv.center.x != viewInArray.center.x ||
           uiv.center.y != viewInArray.center.y){
            
//            NSLog(@"start anim at i=%d", i);
            
            [CATransaction begin];
            //        [CATransaction setAnimationDuration:0.5f];
            [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
            {
                [CATransaction setAnimationDuration:2];
                //        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                
                //        viewLayerTest.layer.position=CGPointMake(200, 200);
                //        viewLayerTest.layer.opacity=0.5;
                
//                CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"toCenterPosition"];
                CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
                [anim setDuration:0.5f];
                anim.fromValue = [NSValue valueWithCGPoint:((CALayer *)[viewInArray.layer presentationLayer]).position];//現在位置
                //            anim.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.bounds.size.width,
                //                                                                 self.view.bounds.size.height)];
                
                anim.toValue = [NSValue valueWithCGPoint:uiv.center];
                
                
                anim.removedOnCompletion = NO;
                anim.fillMode = kCAFillModeForwards;
//                [viewLayerTest.layer addAnimation:anim forKey:@"toCenterPosition"];
                [viewInArray.layer addAnimation:anim forKey:@"position"];
                
                //        mylayer.position=CGPointMake(200, 200);
                //        mylayer.opacity=0.5;
            } [CATransaction commit];
        }

    }

}


-(void) occureViewAnimFreeOrbit{
    
    //createViewで発生させたビューを移動させる
    //NSTimerで毎カウント実行させて、見た目上、uivが動いたタイミングで他のviewInArrayも動かす
    UIView *viewInArray;
    for(int i = 0;i < [array_uiv count];i++){
        //        NSLog(@"array count = %d", i);
        viewInArray = (UIView *)[array_uiv objectAtIndex:i];
        //座標位置が異なればアニメーションさせる
        //        NSLog(@"judge at %d, uiv.x = %f, uiv.y = %f, x = %f, y = %f", i, uiv.center.x, uiv.center.y, viewInArray.center.x, viewInArray.center.y);
//        if(uiv.center.x != viewInArray.center.x ||
//           uiv.center.y != viewInArray.center.y){
        
            //            NSLog(@"start anim at i=%d", i);
            
            CGPoint kStartPos = ((CALayer *)[viewInArray.layer presentationLayer]).position;//viewInArray.center;//((CALayer *)[iv.layer presentationLayer]).position;
//        CGPoint kStartPos = ((CALayer *)[((UIView *)[array_uiv objectAtIndex:i]).layer presentationLayer]).position;
            CGPoint kEndPos = uiv.center;//CGPointMake(kStartPos.x + arc4random() % 100 - 50,//iv.bounds.size.width,
//                                          500);//iv.superview.bounds.size.height);//480);//
            [CATransaction begin];
            [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
            [CATransaction setCompletionBlock:^{//終了処理
                
                
                
                CAAnimation* animationKeyFrame = [viewInArray.layer animationForKey:@"position"];
//                CAAnimation *animationKeyFrame = [((UIView *)[array_uiv objectAtIndex:i]).layer animationForKey:@"position"];
                if(animationKeyFrame){
                    //途中で遮られずにアニメーションが全て完了した場合
                    //            [self die];
//                    [viewInArray removeFromSuperview];
//                    [viewInArray.layer removeAnimationForKey:@"position"];   // 後始末:これをやるとviewが消える。
//                    NSLog(@"animation key frame already exit & die");
                }else{
                    //途中で何らかの理由で遮られた場合=>なぜかここに制御が移らない(既に終了している可能性濃厚)
//                    NSLog(@"animation key frame not exit");
                }
                
            }];
            
            {
                
                // CAKeyframeAnimationオブジェクトを生成
                CAKeyframeAnimation *animation;
                animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
                animation.fillMode = kCAFillModeForwards;
                animation.removedOnCompletion = NO;
                animation.duration = 1.0;
                
                // 放物線のパスを生成
                //    CGFloat jumpHeight = kStartPos.y * 0.2;
                CGPoint peakPos = CGPointMake((kStartPos.x + kEndPos.x)/2, kStartPos.y * 0.05);//test
                CGMutablePathRef curvedPath = CGPathCreateMutable();
                CGPathMoveToPoint(curvedPath, NULL, kStartPos.x, kStartPos.y);//始点に移動
                CGPathAddCurveToPoint(curvedPath, NULL,
                                      peakPos.x, peakPos.y,
                                      (peakPos.x + kEndPos.x)/2, (peakPos.y + kEndPos.y)/2,
                                      kEndPos.x, kEndPos.y);
                
                // パスをCAKeyframeAnimationオブジェクトにセット
                animation.path = curvedPath;
                
                // パスを解放
                CGPathRelease(curvedPath);
                
                // レイヤーにアニメーションを追加
                [viewInArray.layer addAnimation:animation forKey:@"position"];
//                [((UIView *)[array_uiv objectAtIndex:i]).layer addAnimation:animation forKey:@"position"];
                
            }
            [CATransaction commit];
//        }
        
    }
    
}


-(void) occureItemAnimFreeOrbit{
    
    //createViewで発生させたビューを移動させる
    //NSTimerで毎カウント実行させて、見た目上、uivが動いたタイミングで他のviewInArrayも動かす
    UIView *viewInArray;
    for(int i = 0;i < [array_item count];i++){
        //        NSLog(@"array count = %d", i);
        viewInArray = (UIView *)[[array_item objectAtIndex:i] getImageView];
        //座標位置が異なればアニメーションさせる
        //        NSLog(@"judge at %d, uiv.x = %f, uiv.y = %f, x = %f, y = %f", i, uiv.center.x, uiv.center.y, viewInArray.center.x, viewInArray.center.y);
        //        if(uiv.center.x != viewInArray.center.x ||
        //           uiv.center.y != viewInArray.center.y){
        
        //            NSLog(@"start anim at i=%d", i);
        
        CGPoint kStartPos = ((CALayer *)[viewInArray.layer presentationLayer]).position;//viewInArray.center;//((CALayer *)[iv.layer presentationLayer]).position;
        //        CGPoint kStartPos = ((CALayer *)[((UIView *)[array_uiv objectAtIndex:i]).layer presentationLayer]).position;
        CGPoint kEndPos = uiv.center;//CGPointMake(kStartPos.x + arc4random() % 100 - 50,//iv.bounds.size.width,
        //                                          500);//iv.superview.bounds.size.height);//480);//
        [CATransaction begin];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        [CATransaction setCompletionBlock:^{//終了処理
            
            
            
            CAAnimation* animationKeyFrame = [viewInArray.layer animationForKey:@"position"];
            //                CAAnimation *animationKeyFrame = [((UIView *)[array_uiv objectAtIndex:i]).layer animationForKey:@"position"];
            if(animationKeyFrame){
                //途中で遮られずにアニメーションが全て完了した場合
                //            [self die];
                //                    [viewInArray removeFromSuperview];
                //                    [viewInArray.layer removeAnimationForKey:@"position"];   // 後始末:これをやるとviewが消える。
//                NSLog(@"animation key frame already exit & die");
            }else{
                //途中で何らかの理由で遮られた場合=>なぜかここに制御が移らない(既に終了している可能性濃厚)
//                NSLog(@"animation key frame not exit");
            }
            
        }];
        
        {
            
            // CAKeyframeAnimationオブジェクトを生成
            CAKeyframeAnimation *animation;
            animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            animation.fillMode = kCAFillModeForwards;
            animation.removedOnCompletion = NO;
            animation.duration = 1.0;
            
            // 放物線のパスを生成
            //    CGFloat jumpHeight = kStartPos.y * 0.2;
            CGPoint peakPos = CGPointMake((kStartPos.x + kEndPos.x)/2, kStartPos.y * 0.05);//test
            CGMutablePathRef curvedPath = CGPathCreateMutable();
            CGPathMoveToPoint(curvedPath, NULL, kStartPos.x, kStartPos.y);//始点に移動
            CGPathAddCurveToPoint(curvedPath, NULL,
                                  peakPos.x, peakPos.y,
                                  (peakPos.x + kEndPos.x)/2, (peakPos.y + kEndPos.y)/2,
                                  kEndPos.x, kEndPos.y);
            
            // パスをCAKeyframeAnimationオブジェクトにセット
            animation.path = curvedPath;
            
            // パスを解放
            CGPathRelease(curvedPath);
            
            // レイヤーにアニメーションを追加
            [viewInArray.layer addAnimation:animation forKey:@"position"];
            //                [((UIView *)[array_uiv objectAtIndex:i]).layer addAnimation:animation forKey:@"position"];
            
        }
        [CATransaction commit];
        //        }
        
    }
    
}

#endif


#ifdef MYMACHINE_TEST
-(void)repeatAnimEffect:(int)repeatCount{
    ivAnimateEffect.center = CGPointMake(50, 50);
    [UIView animateWithDuration:0.3f
                     animations:^{
                         ivAnimateEffect.center = self.view.bounds.origin;
                     }
                     completion:^(BOOL finished){
                         if(finished){
                             if(repeatCount > 0){
                                 [self repeatAnimEffect:repeatCount-1];
                             }
                             NSLog(@"aaa");
                         }
                     }];

}

#endif


#ifdef LOCATION_TEST

- (void)startLocationService
{
    NSLog(@"startlocationService : %d", counter);
    // このアプリの位置情報サービスへの認証状態を取得する
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    switch (status) {
        case kCLAuthorizationStatusAuthorized: // 位置情報サービスへのアクセスが許可されている
        case kCLAuthorizationStatusNotDetermined: // 位置情報サービスへのアクセスを許可するか選択されていない
        {
            // 位置情報サービスへのアクセスを許可するか確認するダイアログを表示する
            NSLog(@"位置情報サービスへのアクセスを許可するか確認するダイアログを表示する");
            //許可されている場合にはダイアログが表示されない場合がある
            //http://blogios.stack3.net/archives/1137
            UIView *viewDialog;
            viewDialog =
            [CreateComponentClass
             createAlertView2:self.view.bounds
             dialogRect:CGRectMake(0, 0, 300, 250)
             title:@"位置情報サービスを利用します"
             message:@"個人情報を抜き取ったり、他の目的には使用しませんのでご安心下さい。"
             onYes:^{
                 [viewDialog removeFromSuperview];
             }
             onNo:^{
                 [viewDialog removeFromSuperview];
             }];
            [self.view addSubview:viewDialog];
            
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
            [self.locationManager startUpdatingLocation];
            
        }
            break;
            
        case kCLAuthorizationStatusRestricted: // 設定 > 一般 > 機能制限で利用が制限されている
        {
//            UIAlertView *alertView = [[UIAlertView alloc]
//                                      initWithTitle:@"エラー"
//                                      message:@"設定 > 一般 > 機能制限で位置情報利用が制限されています。"
//                                      delegate:nil
//                                      cancelButtonTitle:@"OK"
//                                      otherButtonTitles:nil];
//            [alertView show];
            UIView *dialogView;
            dialogView =
            [CreateComponentClass
             createAlertView2:self.view.bounds
             dialogRect:CGRectMake(0, 0, 290, 250)
             title:@"位置情報の利用が制限されています。"
             message:@"設定 > 一般 > 機能で位置情報の利用が制限されています。"
             onYes:^{
                 [dialogView removeFromSuperview];
             }
             onNo:^{
                 [dialogView removeFromSuperview];
             }];
            [self.view addSubview:dialogView];
            
            
        }
            break;
            
        case kCLAuthorizationStatusDenied: // ユーザーがこのアプリでの位置情報サービスへのアクセスを許可していない
        {
//            UIAlertView *alertView = [[UIAlertView alloc]
//                                      initWithTitle:@"エラー"
//                                      message:@"このアプリでの位置情報サービスへのアクセスを許可されていません。"
//                                      delegate:nil
//                                      cancelButtonTitle:@"OK"
//                                      otherButtonTitles:nil];
//            [alertView show];
            
            UIView *dialogView;
            dialogView =
            [CreateComponentClass
             createAlertView2:self.view.bounds
             dialogRect:CGRectMake(0, 0, 290, 250)
             title:@"位置情報の利用が制限されています。"
             message:@"このアプリでの位置情報サービスへのアクセスを許可されていません。"
             onYes:^{
                 [dialogView removeFromSuperview];
             }
             onNo:^{
                 [dialogView removeFromSuperview];
             }];
            [self.view addSubview:dialogView];
        }
            break;
            
        default:
            break;
    }
}


//位置情報の受取り
- (void)stopLocationService
{
    // 位置情報サービスを停止する
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
    self.locationManager = nil;
}

#pragma mark - CLLocationManagerDelegate methods


// 位置情報サービスへのアクセスが失敗した場合にこのデリゲートメソッドが呼ばれる
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    
    // 標準位置情報サービス・大幅変更位置情報サービスの取得に失敗した場合
    NSLog(@"%s | %@", __PRETTY_FUNCTION__, error);
    
    //    if ([error code] == kCLErrorDenied) {
    //
    //        [manager startUpdatingLocation];
    //    }
    
    
    
    
    
    switch (error.code) {
        case kCLErrorDenied: // 確認ダイアログで許可しないを選択した(位置情報の利用が拒否されているので停止)
        {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"エラー"
                                      message:@"このアプリでの位置情報サービスへのアクセスを許可されませんでした。"
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
        }
            break;
            
        default:
        {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"エラー"
                                      message:@"位置情報の取得に失敗したよ！"
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
        }
            break;
    }
}

// 位置情報サービスの設定が変更された場合にこのデリゲートメソッドが呼ばれる
- (void)locationManager:(CLLocationManager *)manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusRestricted: // 設定 > 一般 > 機能制限で利用が制限されている
        {
            // 位置情報サービスを停止する
            [self stopLocationService];
            
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"エラー"
                                      message:@"設定 > 一般 > 機能制限で利用が制限されてるよ！"
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
        }
            break;
            
        case kCLAuthorizationStatusDenied: // ユーザーがこのアプリでの位置情報サービスへのアクセスを許可していない
        {
            // 位置情報サービスを停止する
            [self stopLocationService];
            
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"エラー"
                                      message:@"このアプリでの位置情報サービスへのアクセスを許可されていないよ！"
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
        }
            break;
            
        default:
            break;
    }
}



// 以下、GPS情報取得が成功した場合に呼出し
// 位置情報サービスへのアクセスが許可されていればこのデリゲートメソッドが定期的に実行される
// 標準位置情報サービス・大幅変更位置情報サービスの取得に成功した場合
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    // ここで任意の処理
//    NSLog(@"%s | newLocation=%@, oldLocaiton=%@", __PRETTY_FUNCTION__, newLocation, oldLocation);
    
    //現在位置：精度が悪かったり、取得時間が古いものは幾つか取り直して、その中から最も精度が高くて新しい物を選ぶ仕組みが必要
    //方法：http://d.hatena.ne.jp/yuum3/20100102/1262448338
    NSLog(@"現在位置：緯度=%f, 経度=%f, 高度=%f, 水平方向精度=%f, 垂直方向精度=%f, 取得時間=%@",
          newLocation.coordinate.latitude,
          newLocation.coordinate.longitude,
          newLocation.altitude,
          newLocation.horizontalAccuracy,
          newLocation.verticalAccuracy,
          newLocation.timestamp);//取得時間が古いものは信用性が低い
    
}

#endif

@end

