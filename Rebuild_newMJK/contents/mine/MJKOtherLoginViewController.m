//
//  MJKOtherLoginViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/1/15.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKOtherLoginViewController.h"

@interface MJKOtherLoginViewController ()

@end

@implementation MJKOtherLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"MATCH智能导购登陆";
    [self initUI];
}

- (void)initUI {
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((KScreenWidth - 100) / 2, SafeAreaTopHeight + 100, 100, 100)];
    imageView.image = [UIImage imageNamed:@"智能导购.png"];
    [self.view addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), KScreenWidth, 20)];
    titleLabel.font = [UIFont systemFontOfSize:14.f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = @"MATCH智能导购登录确认";
    [self.view addSubview:titleLabel];
    
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake((KScreenWidth - 150) / 2, KScreenHeight - SafeAreaTopHeight - SafeAreaBottomHeight - WD_TabBarHeight -50, 150, 44)];
    [cancelButton setTitleNormal:@"登录取消"];
    [cancelButton setTitleColor:[UIColor grayColor]];
    [cancelButton addTarget:self action:@selector(buttonAction:)];
    cancelButton.layer.cornerRadius = 5.f;
    [self.view addSubview:cancelButton];
    
    
    UIButton *loginButton = [[UIButton alloc]initWithFrame:CGRectMake((KScreenWidth - 150) / 2, CGRectGetMinY(cancelButton.frame) - 44 - 20, 150, 44)];
    [loginButton setTitleNormal:@"登录"];
    [loginButton setTitleColor:[UIColor whiteColor]];
    loginButton.backgroundColor = KNaviColor;
    [loginButton addTarget:self action:@selector(buttonAction:)];
    loginButton.layer.cornerRadius = 5.f;
    [self.view addSubview:loginButton];
    
}

- (void)buttonAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"登录"]) {
        [self Login];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)Login {
    DBSelf(weakSelf);
    NSMutableDictionary * dict=[NSMutableDictionary dictionary];
    [dict setObject:self.deviceID forKey:@"alias"];
    [dict setObject:@"daping" forKey:@"project"];
    [dict setObject:[NewUserSession instance].user.u051Id forKey:@"userId"];
    [dict setObject:[NewUserSession instance].user.nickName forKey:@"userName"];
    [dict setObject:[NewUserSession instance].user.C_GRPCODE forKey:@"grpcode"];
    [dict setObject:[NewUserSession instance].user.C_ORGCODE forKey:@"orgcode"];
    [dict setObject:[NewUserSession instance].user.C_LOCCODE forKey:@"loccode"];
    
    
    NSURL *url = [NSURL URLWithString:@"http://121.41.13.95:8080/MJK2.0/HomeFurnishing/login.bk"];;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    // 告诉服务器数据为json类型
    //    if (model.images.count > 0) {
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NewUserSession instance].accountId forHTTPHeaderField:@"accountId"];
    
    
    [request setValue:[NewUserSession instance].user.C_LOCCODE forHTTPHeaderField:@"loccode"];
    
    
    NSLog(@"%@-=-=%@",[NewUserSession instance].accountId,[NewUserSession instance].user.C_LOCCODE);
    
    [request setValue:@"ios" forHTTPHeaderField:@"app"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPBody = jsonData;
    
    NSURLSession *sharedSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@",[NSThread currentThread]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    }];
    [dataTask resume];
}

@end
