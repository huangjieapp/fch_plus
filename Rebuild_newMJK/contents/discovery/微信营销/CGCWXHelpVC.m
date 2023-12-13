//
//  CGCWXHelpVC.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/29.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CGCWXHelpVC.h"

#import "CGCHelpView.h"
#import "MJKMarketViewController.h"


@interface CGCWXHelpVC ()

@property (nonatomic, strong) CGCHelpView *helpView;

@end

@implementation CGCWXHelpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.helpView=[[CGCHelpView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-64) withPicB:^(UILabel *lab, UIButton *btn, UILabel *des) {
    
        MJKMarketViewController *vc=[[MJKMarketViewController alloc] init];
        vc.C_ID=self.c_id;
        vc.rootViewController=self;
        vc.backSelectParameterBlock = ^(NSString *codeStr, NSString *nameStr) {
            NSLog(@"%@-=-=-=%@",codeStr,nameStr);
        };
        [self.navigationController pushViewController:vc animated:YES];
        
        
    } withSendB:^(UIButton *btn) {
        
    }];
    
    [self.view addSubview:self.helpView];
    
    // Do any additional setup after loading the view.
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

@end
