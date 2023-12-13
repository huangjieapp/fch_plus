//
//  MJKAuditPerformanceViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/3/27.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import "MJKAuditPerformanceViewController.h"
#import "MJKAuditPerformanceLeftTableViewCell.h"
#import "MJKAuditPerformanceRightTableViewCell.h"

@interface MJKAuditPerformanceViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
/** <#注释#>*/
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;
/** <#注释#>*/
@property (nonatomic, strong) UIScrollView *scrollView;
/** <#注释#>*/
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation MJKAuditPerformanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.leftTableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
        self.rightTableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"绩效";
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.rightTableView];
    [self httpListData];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arr = self.dataArray[indexPath.row];
    if (tableView == self.leftTableView) {
        MJKAuditPerformanceLeftTableViewCell *cell = [MJKAuditPerformanceLeftTableViewCell cellWithTableView:tableView];
        cell.dataArr = arr;
        return cell;;
    } else {
        MJKAuditPerformanceRightTableViewCell *cell = [MJKAuditPerformanceRightTableViewCell cellWithTableView:tableView];
        cell.dataArr = arr;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 100)];
        bgView.backgroundColor = [UIColor colorWithHex:@"#62F4CD"];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 100)];
        label.text = @"姓名";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14.f];
        [bgView addSubview:label];
        
        UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) - 1, 0,1, label.frame.size.height)];
        rightView.backgroundColor = kBackgroundColor;
        [bgView addSubview:rightView];
        
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(label.frame.origin.x, CGRectGetMaxY(label.frame) - 1, label.frame.size.width, 1)];
        bottomView.backgroundColor = kBackgroundColor;
        [bgView addSubview:bottomView];
        
        return bgView;
    } else {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, (KScreenWidth / 3) * 18 , 100)];
        bgView.backgroundColor = [UIColor colorWithHex:@"#62F4CD"];
        NSArray *arr = @[@"2",@"3",@"6",@"2",@"3",@"2"];
        NSArray *nameArr = @[@"销售业绩",@"基盘维护",@"潜客新增",@"技能提升",@"桩脚开发维护",@"老客户维护"];
        NSArray *subArr = @[@[@"成交率",@"个人销量"],@[@"特邀",@"潜客跟进",@"潜客拜访"],@[@"微信添加",@"微信开发",@"异业合作新增",@"电话营销新增",@"其他渠道新增",@"潜客转介绍新增"],@[@"演练",@"录音分享"],@[@"桩脚介绍新增",@"桩脚建立",@"桩脚拜访"],@[@"老客户拜访",@"老客户转介绍"]];
        CGFloat x = 0;
        for (int i = 0; i < arr.count; i++) {
            CGFloat width = (KScreenWidth / 3) * [arr[i] intValue];
            UIView *view = [[UILabel alloc]initWithFrame:CGRectMake(x, 0, width, 100)];
            UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, 50)];
            topLabel.text = nameArr[i];
            topLabel.textAlignment = NSTextAlignmentCenter;
            topLabel.textColor = [UIColor blackColor];
            topLabel.font = [UIFont systemFontOfSize:14.f];
            [view addSubview:topLabel];
            
            UIView *topRightSepView = [[UIView alloc]initWithFrame:CGRectMake(view.frame.size.width - 1, 0, 1, 50)];
            topRightSepView.backgroundColor = kBackgroundColor;
            [view addSubview:topRightSepView];
            
            UIView *bottomSepView = [[UIView alloc]initWithFrame:CGRectMake(0, 49, view.frame.size.width, 1)];
            bottomSepView.backgroundColor = kBackgroundColor;
            [view addSubview:bottomSepView];

            UIView *subBottomSepView = [[UIView alloc]initWithFrame:CGRectMake(0, 99, view.frame.size.width, 1)];
            subBottomSepView.backgroundColor = kBackgroundColor;
            [view addSubview:subBottomSepView];
            
            x = x + width;
            NSArray *tarr = subArr[i];
            for (int j = 0; j < [tarr count]; j++) {
                UILabel *bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(j * (view.frame.size.width / [tarr count]), 50, view.frame.size.width / [tarr count], 50)];
                bottomLabel.text = subArr[i][j];
                bottomLabel.textAlignment = NSTextAlignmentCenter;
                bottomLabel.textColor = [UIColor blackColor];
                bottomLabel.font = [UIFont systemFontOfSize:14.f];
                [view addSubview:bottomLabel];
                
                UIView *bottomRightSepView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(bottomLabel.frame) - 1, 50, 1, 50)];
                bottomRightSepView.backgroundColor = kBackgroundColor;
                [view addSubview:bottomRightSepView];
                
            }
            [bgView addSubview:view];
        }
        return bgView;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

-(void)scrollViewDidScroll:(UIScrollView *)sender
{

    if (sender == self.rightTableView) {

        
        [self tableView:self.leftTableView scrollFollowTheOther:self.rightTableView];

    }else{

        [self tableView:self.rightTableView scrollFollowTheOther:self.leftTableView];

    }
}

- (void)tableView:(UITableView *)tableView scrollFollowTheOther:(UITableView *)other{

    CGFloat offsetY= other.contentOffset.y;

    CGPoint offset=tableView.contentOffset;

    offset.y=offsetY;

    tableView.contentOffset=offset;

}

#pragma mark - list
- (void)httpListData {
    DBSelf(weakSelf);
    NSMutableDictionary*mainDic=[DBObjectTools getAddressDicWithAction:@"A70900WebService-getJxListByA425Id"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.C_ID.length > 0) {
        
        [dict setObject:self.C_ID forKey:@"C_ID"];
    } else {
        [JRToast showWithText:@"暂无审批ID"];
        return;
    }
    [mainDic setObject:dict forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mainDic withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.dataArray = [NSArray mj_keyValuesArrayWithObjectArray:data[@"returnList"]];
            [weakSelf.leftTableView reloadData];
            [weakSelf.rightTableView reloadData];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

#pragma mark - set
- (UITableView *)leftTableView {
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, 120, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight) style:UITableViewStyleGrouped];
        _leftTableView.dataSource = self;
        _leftTableView.delegate = self;
        _leftTableView.estimatedRowHeight = 0;
        _leftTableView.estimatedSectionFooterHeight = 0;
        _leftTableView.estimatedSectionHeaderHeight = 0;
        _leftTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.showsHorizontalScrollIndicator = NO;
        _leftTableView.tableFooterView = [[UIView alloc]init];
    }
    return _leftTableView;
}

- (UITableView *)rightTableView {
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, (KScreenWidth / 3) * 18, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight) style:UITableViewStyleGrouped];
        _rightTableView.dataSource = self;
        _rightTableView.delegate = self;
        _rightTableView.estimatedRowHeight = 0;
        _rightTableView.estimatedSectionFooterHeight = 0;
        _rightTableView.estimatedSectionHeaderHeight = 0;
        _rightTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _rightTableView.showsVerticalScrollIndicator = NO;
        _rightTableView.showsHorizontalScrollIndicator = NO;
        _rightTableView.tableFooterView = [[UIView alloc]init];
    }
    return _rightTableView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(120, SafeAreaTopHeight, KScreenWidth - 120, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight)];
        _scrollView.contentSize = CGSizeMake((KScreenWidth / 4) * 18, _scrollView.frame.size.height);
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

@end
