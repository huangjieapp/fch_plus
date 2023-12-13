//
//  MJKPerformanceViewController.m
//  Rebuild_newMJK
//
//  Created by huangjie on 2022/10/9.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import "MJKPerformanceViewController.h"

#import "MJKJxInfoModel.h"
#import "MJKJxInfoA821PojoList.h"
#import "MJKJxInfoXlIdModel.h"

#import "MJKJxInfoNameTableViewCell.h"
#import "MJKJxInfoTableViewCell.h"

@interface MJKPerformanceViewController ()<UITableViewDataSource, UITableViewDelegate>
/** <#注释#> */
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITableView *leftableView;
/** <#注释#> */
@property (nonatomic, strong) UIScrollView *scrollView;
/** <#注释#> */
@property (nonatomic, strong) NSArray *dataTypeArray;
@property (nonatomic, strong) NSArray *A821PojoList;
@property (nonatomic, strong) NSArray *JxInfoXlIdList;
@end

@implementation MJKPerformanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绩效进度";
    self.view.backgroundColor = [UIColor whiteColor];
    _leftableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_leftableView];
    [_leftableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAVIHEIGHT);
        make.left.equalTo(self.view);
        make.bottom.mas_equalTo(-AdaptSafeBottomHeight);
        make.width.mas_equalTo(100);
    }];
    _leftableView.delegate = self;
    _leftableView.dataSource = self;
    _leftableView.backgroundColor = [UIColor clearColor];
    [_leftableView registerClass:[MJKJxInfoNameTableViewCell class] forCellReuseIdentifier:@"MJKJxInfoNameTableViewCell"];
    _leftableView.estimatedRowHeight = 300;
    if (@available(iOS 15.0,*)) {
        _leftableView.sectionHeaderTopPadding = YES;
    }
    
    _scrollView = [UIScrollView new];
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAVIHEIGHT);
        make.left.equalTo(self.leftableView.mas_right);
        make.right.equalTo(self.view);
        make.bottom.mas_equalTo(-AdaptSafeBottomHeight);
    }];
//    _scrollView.contentSize = CGSizeMake(5000, 0);
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [_scrollView addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.scrollView);
        make.width.mas_equalTo(0);
        make.bottom.equalTo(self.view).offset(-AdaptSafeBottomHeight);
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerClass:[MJKJxInfoTableViewCell class] forCellReuseIdentifier:@"MJKJxInfoTableViewCell"];
    _tableView.estimatedRowHeight = 300;
    if (@available(iOS 15.0,*)) {
        _tableView.sectionHeaderTopPadding = YES;
    }
    
    [self getjxInfoData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.leftableView) {
        self.tableView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y);
    }
    else {
       self.leftableView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y);
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.A821PojoList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKJxInfoA821PojoList *model = self.A821PojoList[indexPath.row];
    if (tableView == self.leftableView) {
        MJKJxInfoNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MJKJxInfoNameTableViewCell"];
        cell.titleLabel.text = model.C_U03100_C_NAME;
        return cell;
    } else {
        NSDictionary *dict = [model mj_keyValues];
        NSMutableArray *dataArray = [NSMutableArray array];
        MJKJxInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MJKJxInfoTableViewCell"];
        for (int t = 0; t < self.JxInfoXlIdList.count; t++) {
            
            [dataArray addObject:dict[[NSString stringWithFormat:@"%@_STR",self.JxInfoXlIdList[t]]]  ?: @""];
            [dataArray addObject:dict[[NSString stringWithFormat:@"%@_WC_STR",self.JxInfoXlIdList[t]]] ?: @""];
            [dataArray addObject:dict[[NSString stringWithFormat:@"%@_WCL",self.JxInfoXlIdList[t]]] ?: @""];
        }
        cell.arr = dataArray;
        
        cell.timeLabel.text = model.D_CREATE_TIME;
        return cell;;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 93;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    if (tableView == self.leftableView) {
        UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 93)];
        bgView.backgroundColor = kBackgroundColor;
        UILabel *label = [UILabel new];
        [bgView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(bgView);
        }];
        label.font = [UIFont systemFontOfSize:14.f];
        label.textColor = [UIColor blackColor];
        label.text = @"销售";
        label.textAlignment = NSTextAlignmentCenter;
        
        UIView *sepView2 = [UIView new];
        [bgView addSubview:sepView2];
        [sepView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(99);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(93);
        }];
        sepView2.backgroundColor = [UIColor colorWithHex:@"#cccccc"];
        
        return bgView;
    } else {
        UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(100, 0, 63 * 60, 93)];
        bgView.backgroundColor = kBackgroundColor;
        
        
        NSArray *arr = @[
            @{@"title": @"销售业绩", @"content": @[@{@"title": @"成交率", @"content": @[@"目标", @"完成", @"完成率"]},
                                                 @{@"title": @"个人销售", @"content": @[@"目标", @"完成", @"完成率"]}]},
            @{@"title": @"基盘维护", @"content": @[@{@"title": @"邀约", @"content": @[@"目标", @"完成", @"完成率"]},
                                                  @{@"title": @"潜客跟进", @"content": @[@"目标", @"完成", @"完成率"]},
                                               @{@"title": @"潜客拜访", @"content": @[@"目标", @"完成", @"完成率"]}]},
        @{@"title": @"潜客新增", @"content": @[
                                           @{@"title": @"微信添加", @"content": @[@"目标", @"完成", @"完成率"]},
                                           @{@"title": @"微信开发", @"content": @[@"目标", @"完成", @"完成率"]},
                                           @{@"title": @"线下活动新增", @"content": @[@"目标", @"完成", @"完成率"]},
                                           @{@"title": @"电话营销新增", @"content": @[@"目标", @"完成", @"完成率"]},
                                           @{@"title": @"其他渠道新增", @"content": @[@"目标", @"完成", @"完成率"]},
                                           @{@"title": @"潜客转介绍新增", @"content": @[@"目标", @"完成", @"完成率"]}]},
        @{@"title": @"技能提升", @"content": @[@{@"title": @"演练", @"content": @[@"目标", @"完成", @"完成率"]},
                                           @{@"title": @"录音分享", @"content": @[@"目标", @"完成", @"完成率"]},
                                           @{@"title": @"微信群发", @"content": @[@"目标", @"完成", @"完成率"]},
                                           @{@"title": @"客户分享", @"content": @[@"目标", @"完成", @"完成率"]}]},
        @{@"title": @"桩脚开发维护", @"content": @[@{@"title": @"桩脚介绍新增", @"content": @[@"目标", @"完成", @"完成率"]},
                                             @{@"title": @"桩脚建立", @"content": @[@"目标", @"完成", @"完成率"]},
                                             @{@"title": @"桩脚拜访", @"content": @[@"目标", @"完成", @"完成率"]}]},
        @{@"title": @"老客户维护", @"content": @[@{@"title": @"老客拜访", @"content": @[@"目标", @"完成", @"完成率"]},
                                            @{@"title": @"老客转介绍", @"content": @[@"目标", @"完成", @"完成率"]}]}];
        
        arr =self.dataTypeArray;
        CGFloat with = 0;
        for (int i = 0; i < arr.count; i++) {
            MJKJxInfoModel *model = arr[i];
            NSArray *subArr = model.children;
            UIView *view = [UIView new];
            [bgView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(with);
                make.top.mas_equalTo(0);
                make.width.mas_equalTo(subArr.count * 180);
                make.height.mas_equalTo(30);
            }];
            
            
            UILabel *label  = [UILabel new];
            [view addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view);
                make.top.equalTo(view);
                make.width.mas_equalTo(subArr.count * 180);
                make.height.mas_equalTo(30);
            }];
            label.text = model.label;
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:14.f];
            label.textAlignment = NSTextAlignmentCenter;
            
            UIView *sepView = [UIView new];
            [view addSubview:sepView];
            [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view);
                make.top.mas_equalTo(30);
                make.width.mas_equalTo(subArr.count * 180);
                make.height.mas_equalTo(1);
            }];
            sepView.backgroundColor = [UIColor colorWithHex:@"#cccccc"];
            
            UIView *sepView1 = [UIView new];
            [view addSubview:sepView1];
            [sepView1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view);
                make.top.mas_equalTo(61);
                make.width.mas_equalTo(subArr.count * 180);
                make.height.mas_equalTo(1);
            }];
            sepView1.backgroundColor = [UIColor colorWithHex:@"#cccccc"];
            
            UIView *sepView2 = [UIView new];
            [view addSubview:sepView2];
            [sepView2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(label.mas_right);
                make.top.mas_equalTo(0);
                make.width.mas_equalTo(1);
                make.height.mas_equalTo(30);
            }];
            sepView2.backgroundColor = [UIColor colorWithHex:@"#cccccc"];
            
            
            with += (subArr.count * 180);

            for (int j = 0; j < subArr.count; j++) {
                MJKJxInfoModel *subModel = subArr[j];
                NSArray *subSubArr = @[@"目标", @"完成", @"完成率"];
                UILabel *subLabel  = [UILabel new];
                [view addSubview:subLabel];
                [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(j * (subSubArr.count * 60));
                    make.top.mas_equalTo(30);
                    make.width.mas_equalTo(subSubArr.count * 60);
                    make.height.mas_equalTo(30);
                }];
                
                subLabel.text = subModel.label;
                subLabel.textColor = [UIColor blackColor];
                subLabel.font = [UIFont systemFontOfSize:14.f];
                subLabel.textAlignment = NSTextAlignmentCenter;
                
                UIView *subSepView = [UIView new];
                [view addSubview:subSepView];
                [subSepView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(subLabel.mas_right);
                    make.top.mas_equalTo(30);
                    make.width.mas_equalTo(1);
                    make.height.mas_equalTo(32);
                }];
                subSepView.backgroundColor = [UIColor colorWithHex:@"#cccccc"];

                for (int k = 0; k < @[@"目标", @"完成", @"完成率"].count; k++) {
                    UILabel *subSubLabel  = [UILabel new];
                    [view addSubview:subSubLabel];
                    [subSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(((j * 3) * 60) +  k * 60);
                        make.top.mas_equalTo(60);
                        make.width.mas_equalTo(60);
                        make.height.mas_equalTo(30);
                    }];
                    subSubLabel.text = @[@"目标", @"完成", @"完成率"][k];
                    subSubLabel.textColor = [UIColor blackColor];
                    subSubLabel.font = [UIFont systemFontOfSize:14.f];
                    subSubLabel.textAlignment = NSTextAlignmentCenter;

                    UIView *subSubSepView = [UIView new];
                    [view addSubview:subSubSepView];
                    [subSubSepView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(subSubLabel.mas_right);
                        make.top.mas_equalTo(63);
                        make.width.mas_equalTo(1);
                        make.height.mas_equalTo(30);
                    }];
                    subSubSepView.backgroundColor = [UIColor colorWithHex:@"#cccccc"];


                }
                


            }
            
            
        }

        
        
        UILabel *timeLabel = [UILabel new];
        [bgView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(bgView);
            make.top.equalTo(bgView);
            make.size.mas_equalTo(CGSizeMake(180, 93));
        }];
        timeLabel.text = @"创建时间";
        timeLabel.textColor = [UIColor blackColor];
        timeLabel.font = [UIFont systemFontOfSize:14.f];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        
        return bgView;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)getjxInfoData {
    @weakify(self);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_YEARMONTH"] = [DBTools getYearMonthTime];
    contentDic[@"tableType"] = @"4";
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkWithUrl:[NSString stringWithFormat:@"%@/api/crm/portal/jxInfo", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
        @strongify(self);
        if ([data[@"code"] integerValue] == 200) {
            self.dataTypeArray = [MJKJxInfoModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"typeList"]];
            self.A821PojoList = [MJKJxInfoA821PojoList mj_objectArrayWithKeyValuesArray:data[@"data"][@"a821PojoList"]];
            self.JxInfoXlIdList = data[@"data"][@"xlId"];
            
            
            CGFloat with = 0;
            for (int i = 0; i < self.dataTypeArray.count; i++) {
                MJKJxInfoModel *model = self.dataTypeArray[i];
                NSArray *subArr = model.children;
                
                with += (subArr.count * 180);
            }
            
            
            self.scrollView.contentSize = CGSizeMake(with + 180, 0);
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_offset(with + 180);
            }];
            [self.tableView  reloadData];
            [self.leftableView  reloadData];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

@end

