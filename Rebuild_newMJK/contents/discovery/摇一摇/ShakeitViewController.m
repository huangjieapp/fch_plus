//
//  ShakeitViewController.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/11/3.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import "ShakeitViewController.h"



#import "SingleLocationViewController.h"
#import "MJKAttendanceViewController.h"
#import "MJKAttendReportViewController.h"


@interface ShakeitViewController ()
@property(nonatomic,strong)UIImageView*BGImageView;
/** 状态默认考勤*/
@property (nonatomic, strong) NSString *typeStr;

@end

@implementation ShakeitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title=@"考勤签到";
    self.view.backgroundColor=[UIColor whiteColor];
    
//    UIBarButtonItem*rightButton=[[UIBarButtonItem alloc]initWithTitle:@"定位" style:UIBarButtonItemStylePlain target:self action:@selector(clickLocal)];
//    self.navigationItem.rightBarButtonItem=rightButton;
    
    // 设置允许摇一摇功能
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    // 并让自己成为第一响应者
    [self becomeFirstResponder];
    
    [self creatUI];
//    [self initNavi];
}

- (void)initNavi {
	UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
	[button setImage:[UIImage imageNamed:@"考勤报表图标"] forState:UIControlStateNormal];
	button.imageEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
	[button addTarget:self action:@selector(checkReportList:)];
	UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
	self.navigationItem.rightBarButtonItem = item;
}

#pragma mark - 考勤报表
- (void)checkReportList:(UIButton *)button {
	if (![[NewUserSession instance].appcode containsObject:@"APP012_0001"]) {
		[JRToast showWithText:@"账号无权限"];
		return;
	}
	MJKAttendReportViewController *vc = [[MJKAttendReportViewController alloc]init];
	[self.navigationController pushViewController:vc animated:YES];
}


-(void)creatUI{
	self.typeStr = @"考勤";
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"考勤",@"签到"]];
	segmentedControl.frame = CGRectMake((KScreenWidth - 150) / 2, NavStatusHeight + 10, 150, 35);
	segmentedControl.tintColor = KNaviColor;
	[self.view addSubview:segmentedControl];
	segmentedControl.selectedSegmentIndex = 0;
	[segmentedControl addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventValueChanged];
	
    UIImageView*BGImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth/2, KScreenWidth/2)];
    BGImageView.center=CGPointMake(self.view.centerX, self.view.centerY);
    BGImageView.image=[UIImage imageNamed:@"icon_shake_bg"];
    self.BGImageView=BGImageView;
    [self.view addSubview:BGImageView];
    
    
}

#pragma mark  --选择签到还是考勤
- (void)selectType:(UISegmentedControl *)sender {
	if (sender.selectedSegmentIndex == 0) {
		self.typeStr = @"考勤";
	} else {
		self.typeStr = @"签到";
	}
}

#pragma mark  --click
-(void)clickLocal{
	if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
		
	} else {
		UIAlertController *alertV = [UIAlertController alertControllerWithTitle:@"提示" message:@"请开启定位服务\n设置->隐私->定位服务" preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *openAction = [UIAlertAction actionWithTitle:@"打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
			NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
			if ([[UIApplication sharedApplication] canOpenURL:url]) {
				[[UIApplication sharedApplication] openURL:url];
			}
		}];
		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
			
		}];
		[alertV addAction:cancelAction];
		[alertV addAction:openAction];
		[self presentViewController:alertV animated:YES completion:nil];
		
		return;
	}
	if ([self.typeStr isEqualToString:@"考勤"]) {
		MJKAttendanceViewController *vc = [[MJKAttendanceViewController alloc]initWithNibName:@"MJKAttendanceViewController" bundle:nil];
		[self.navigationController pushViewController:vc animated:YES];
	} else {
		SingleLocationViewController*vc=[[SingleLocationViewController alloc]init];
		[self.navigationController pushViewController:vc animated:YES];
	}
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark  -- funcation
//百度定位得到 经纬度
-(void)BaiduLocated{
   
    
}




//传入经纬度 显示地图




- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"开始摇动");
    self.BGImageView.layer.anchorPoint = CGPointMake(0.5, 0);
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //角度转弧度（这里用1，-1简单处理一下）
    rotationAnimation.toValue = [NSNumber numberWithFloat:1];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:-1];
    rotationAnimation.duration = 1.0f;
    rotationAnimation.repeatCount = MAXFLOAT;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.autoreverses = YES;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnimation.fillMode = kCAFillModeForwards;
    [self.BGImageView.layer addAnimation:rotationAnimation forKey:@"revItUpAnimation"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self.BGImageView.layer removeAllAnimations];
    });
   
    
    return;
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"取消摇动");
    return;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.subtype == UIEventSubtypeMotionShake) { // 判断是否是摇动结束
        NSLog(@"摇动结束");
        [self clickLocal];
        
        
    }
    return;
}



@end
