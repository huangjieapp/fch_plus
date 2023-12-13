//
//  MJKGroupReportListTableViewCell.m
//  Rebuild_newMJK
//
//  Created by huangjie on 2022/12/7.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import "MJKGroupReportListTableViewCell.h"
#import "MJKGroupReportDetailTableViewCell.h"

#import "MJKGroupReportModel.h"

@interface MJKGroupReportListTableViewCell ()<UITableViewDataSource, UITableViewDelegate>
/** <#注释#> */
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#> */
@property (nonatomic, strong) UIScrollView *scrollView;
/** <#注释#> */
@property (nonatomic, strong) NSArray *cArray;
/** <#注释#> */
@property (nonatomic, strong) NSArray *mArray;
@end

@implementation MJKGroupReportListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _scrollView = [UIScrollView new];
        [self.contentView addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(82 + self.dataArray.count * 46);
        }];
        
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_scrollView addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(0);
            make.width.mas_equalTo(90 * 12);
            make.height.mas_equalTo(82 + self.dataArray.count * 45);
        }];
        _tableView.scrollEnabled = NO;
        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[MJKGroupReportDetailTableViewCell class] forCellReuseIdentifier:@"MJKGroupReportDetailTableViewCell"];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.tableFooterView = [UIView new];
        if (@available(iOS 15.0,*)) {
            _tableView.sectionHeaderTopPadding = YES;
        }
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.scrollView.contentSize = CGSizeMake(90 * 12, 80);
        self.scrollView.bounces = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(dataArray.count * 44 + 80);
    }];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(dataArray.count * 44 + 80);
    }];
    [self.tableView reloadData];
}

#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    MJKGroupReportModel *model = self.dataArray[indexPath.row];
    MJKGroupReportDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MJKGroupReportDetailTableViewCell"];
    cell.tableType = self.tableType;
    cell.model = model;
    [[[cell.toButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if (self.backToDetailBlock) {
            self.backToDetailBlock(model.code);
        }
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 90 * 12, 80)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    
    CGFloat x = 0;
    for (int i = 0; i < 6; i++) {
        UIView *view = [UILabel new];
        [bgView addSubview:view];
        if (i < 3) {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(x);
                make.top.bottom.mas_equalTo(0);
                make.width.mas_equalTo(90);
            }];
            x += 90;
            UILabel *label = [UILabel new];
            [view addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.bottom.mas_equalTo(0);
            }];
            if ([self.tableType isEqualToString:@"2"] || [self.tableType isEqualToString:@"3"]) {
                label.text = @[@"门店",@"目标",@"库存",@"新增订单",@"订单交车",@"销量"][i];
            } else if ([self.tableType isEqualToString:@"1"]) {
                label.text = @[@"区域",@"目标",@"库存",@"新增订单",@"订单交车",@"销量"][i];
            } else if ([self.tableType isEqualToString:@"0"]) {
                label.text = @[@"事业部",@"目标",@"库存",@"新增订单",@"订单交车",@"销量"][i];
            }
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:14.f];
            label.textAlignment = NSTextAlignmentCenter;
        } else {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(x);
                make.top.bottom.mas_equalTo(0);
                make.width.mas_equalTo(270);
            }];
            x += 270;
            for (int j = 0; j < 2; j++) {
                UIView *topView = [UIView new];
                [view addSubview:topView];
                [topView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.mas_equalTo(0);
                    make.top.mas_equalTo(j * 40);
                    make.height.mas_equalTo(40);
                }];
                UIView *sepViewTop = [UIView new];
                [topView addSubview:sepViewTop];
                if (j == 0) {
                    [sepViewTop mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.bottom.mas_equalTo(-1);
                        make.height.mas_equalTo(1);
                        make.left.right.mas_equalTo(0);
                    }];
                    sepViewTop.backgroundColor = kBackgroundColor;
                    
                    UILabel *label = [UILabel new];
                    [topView addSubview:label];
                    [label mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.top.bottom.mas_equalTo(0);
                    }];
                    if ([self.tableType isEqualToString:@"2"] || [self.tableType isEqualToString:@"3"]) {
                        label.text = @[@"门店",@"目标",@"库存",@"新增订单",@"订单交车",@"销量"][i];
                    } else if ([self.tableType isEqualToString:@"1"]) {
                        label.text = @[@"区域",@"目标",@"库存",@"新增订单",@"订单交车",@"销量"][i];
                    } else if ([self.tableType isEqualToString:@"0"]) {
                        label.text = @[@"事业部",@"目标",@"库存",@"新增订单",@"订单交车",@"销量"][i];
                    }
                    label.textColor = [UIColor blackColor];
                    label.font = [UIFont systemFontOfSize:14.f];
                    label.textAlignment = NSTextAlignmentCenter;
                } else {
                    for (int k = 0; k <  3; k++) {
                        UIView *bottomView = [UIView new];
                        [topView addSubview:bottomView];
                        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(k * 90);
                            make.top.bottom.mas_equalTo(0);
                            make.width.mas_equalTo(90);
                        }];
                        
                        UILabel *label = [UILabel new];
                        [bottomView addSubview:label];
                        [label mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.right.top.bottom.mas_equalTo(0);
                        }];
                        label.text = @[@"线上",@"线下",@"合计"][k];
                        label.textColor = [UIColor blackColor];
                        label.font = [UIFont systemFontOfSize:14.f];
                        label.textAlignment = NSTextAlignmentCenter;
                        
                        UIView *sepViewBottom = [UIView new];
                        [bottomView addSubview:sepViewBottom];
                        [sepViewBottom mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.bottom.mas_equalTo(-1);
                            make.width.mas_equalTo(1);
                            make.left.equalTo(bottomView).offset(-1);
                        }];
                        sepViewBottom.backgroundColor = kBackgroundColor;
                    }
                }
                
            }
        }
        
        UIView *sepView = [UIView new];
        [bgView addSubview:sepView];
        [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(1);
            make.left.equalTo(view).offset(-1);
        }];
        sepView.backgroundColor = kBackgroundColor;
        
        UIView *sepTopView = [UIView new];
        [bgView addSubview:sepTopView];
        [sepTopView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        sepTopView.backgroundColor = kBackgroundColor;
        
        UIView *sepBottomView = [UIView new];
        [bgView addSubview:sepBottomView];
        [sepBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-1);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        sepBottomView.backgroundColor = kBackgroundColor;
        
    }
    return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
