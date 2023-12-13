//
//  MJKSearchWorkViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/10/9.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKSearchWorkViewController.h"

@interface MJKSearchWorkViewController ()<UISearchBarDelegate>
/** A49000_C_TYPE*/
@property (nonatomic, strong) NSArray *A49000_C_TYPE;
/** searchText*/
@property (nonatomic, strong) NSString *searchText;
@end

@implementation MJKSearchWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    [self configUI];
}

- (void)backBarButtonClick {
    if (self.searchBackButtonBlock) {
        self.searchBackButtonBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configUI {
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth - 80, StatusBarHeight, 80, 45)];
    [button setTitleNormal:@"取消"];
    [button setTitleColor:[UIColor colorWithHex:@"#576a94"]];
    [button addTarget:self action:@selector(dismissVC)];
    [self.view addSubview:button];
    UISearchBar *bar = [[UISearchBar alloc]initWithFrame:CGRectMake(10, StatusBarHeight, KScreenWidth - 90, 45)];
    bar.placeholder = @"搜索";
    bar.delegate = self;
    [self.view addSubview:bar];
    for (UIView *view in bar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bar.frame) + 80, KScreenWidth, 44)];
    label.font = [UIFont systemFontOfSize:14.f];
    label.textColor = [UIColor lightGrayColor];
    label.text = @"搜索指定内容";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    /*
     日报：A49000_C_TYPE_0000
     打卡：A49000_C_TYPE_0001
     红包：A49000_C_TYPE_0003
     喜报：A49000_C_TYPE_0004
     罚单：A49000_C_TYPE_0005
     任务：A49000_C_TYPE_0006
     */
    self.A49000_C_TYPE = @[@"A49000_C_TYPE_0003",@"A49000_C_TYPE_0004",@"A49000_C_TYPE_0001",@"A49000_C_TYPE_0005",@"A49000_C_TYPE_0006",@"A49000_C_TYPE_0000"];
    for (int i = 0; i < 6; i++) {
        UIButton *search_button = [[UIButton alloc]initWithFrame:CGRectMake(40 + ((i % 3) * ((KScreenWidth - 80) / 3)), CGRectGetMaxY(label.frame) + 50 + (i / 3) * 50, (KScreenWidth - 80) / 3, 50)];
        [search_button setTitleNormal:@[@"红包",@"喜报",@"打卡",@"罚单",@"任务",@"日报"][i]];
        [search_button setTitleColor:[UIColor colorWithHex:@"#576a94"]];
        search_button.titleLabel.font = [UIFont systemFontOfSize:16.f];
        search_button.tag = 1000 + i;
        [search_button addTarget:self action:@selector(typeButtonAction:)];
        [self.view addSubview:search_button];
        
        UILabel *sepLabel = [[UILabel alloc]initWithFrame:CGRectMake(search_button.frame.size.width + search_button.frame.origin.x, search_button.frame.origin.y + 15, 1, search_button.frame.size.height - 30)];
        sepLabel.backgroundColor = [UIColor colorWithHex:@"#dadada"];
        [self.view addSubview:sepLabel];
        if (i % 3 == 2) {
            sepLabel.hidden = YES;
        }
    }
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.searchText = searchText;
}

- (void)typeButtonAction:(UIButton *)sender {
    NSInteger tag = sender.tag - 1000;
    if (self.searchBlock) {
        self.searchBlock(self.A49000_C_TYPE[tag], self.searchText);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dismissVC {
    [self backBarButtonClick];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
