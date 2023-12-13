//
//  MJKOnlineLiveViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/20.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKOnlineLiveViewController.h"


@interface MJKOnlineLiveViewController ()
@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (weak, nonatomic) IBOutlet UILabel *largeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *localRecordLabel;
@property (weak, nonatomic) IBOutlet UIView *qualityView;
@property (weak, nonatomic) IBOutlet UIView *toolBar;
@property (weak, nonatomic) IBOutlet UIButton *largeBackButton;
@property (weak, nonatomic) IBOutlet UIButton *playerPlayButton;
@end

@implementation MJKOnlineLiveViewController

- (void)dealloc {
	
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)largeBack:(UIButton *)sender {
}
- (IBAction)playButtonClick:(UIButton *)sender {
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
