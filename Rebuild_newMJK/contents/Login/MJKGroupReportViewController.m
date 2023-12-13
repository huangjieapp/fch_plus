//
//  MJKGroupReportViewController.m
//  Rebuild_newMJK
//
//  Created by huangjie on 2022/12/6.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import "MJKGroupReportViewController.h"
#import "MJKCollectionListViewController.h"
#import "MJKApprolViewController.h"
#import "MJKMessageHomeViewController.h"
#import "MJKNewGroupShopsViewController.h"
#import "MJKLouDouDetailViewController.h"


#import "MJKHomePagePersonNewCell.h"
#import "MJKHomeJXTableViewCell.h"

#import "MJKGroupReportTableViewCell.h"
#import "MJKGroupReportListTableViewCell.h"
#import "ReportTopTableViewCellNoGroup.h"
#import "FunnelShowView.h"
#import "CGCCustomDateView.h"

#import "MJKApprovalModel.h"
#import "MJKMessageDetailModel.h"
#import "MJKGroupReportModel.h"
#import "ReportSheetModel.h"

@interface MJKGroupReportViewController ()<UITableViewDataSource, UITableViewDelegate>
/** <#注释#> */
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#> */
@property (nonatomic, strong) NSArray *cellArray;
/** <#注释#> */
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic,strong) UILabel *approvalLabel;
@property (nonatomic,strong) UILabel *messageLabel;
/** <#注释#> */
@property (nonatomic, strong) NSString *timeStr;
/** <#注释#> */
@property (nonatomic, strong) NSString *tableType;
/** <#注释#> */
@property (nonatomic, strong) NSArray *dataArray;
/** <#注释#> */
@property (nonatomic, strong) NSString *C_GRPCODE;
@property (nonatomic, strong) NSString *C_ORGCODE;


@property(nonatomic,strong)NSString  *timeType;   //时间筛选的类型
@property(nonatomic,strong)NSString *START_TIME;
@property(nonatomic,strong)NSString *END_TIME;
@property (nonatomic, strong) NSString *shijiaoStr;
/** <#注释#> */
@property (nonatomic, strong) ReportSheetModel *mainModel;
/** <#注释#> */
@property (nonatomic, strong) FunnelShowView *funnelView;
/** <#注释#> */
@property (nonatomic, strong) NSString *chooseDateStr;
@end

@implementation MJKGroupReportViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        appearance.backgroundColor = DBColor(247, 247, 247);
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    } else {
     // Fallback on earlier versions
     self.navigationController.navigationBar.barTintColor = DBColor(247, 247, 247);
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        appearance.backgroundColor = KNaviColor;
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    } else {
        [self.navigationController.navigationBar setBarTintColor:KNaviColor];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"集团首页";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.chooseDateStr = @"请选择";
    
    NSDate *date = [NSDate new];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    df.dateFormat = @"yyyy-MM";
    self.timeStr = [df stringFromDate:date];
    
    self.tableType = @"0";
    
    self.timeType = @"3";
    self.chooseDateStr = @"本月";
    self.shijiaoStr = @"1";
    [KUSERDEFAULT setObject:@"动态发生视角" forKey:@"groupfunnelSelectValue"];
    [KUSERDEFAULT setObject:@"本月" forKey:@"grouptimeName"];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAVIHEIGHT);
        make.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(-SafeAreaBottomHeight);
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerClass:[MJKGroupReportTableViewCell class] forCellReuseIdentifier:@"MJKGroupReportTableViewCell"];
    [_tableView registerClass:[MJKGroupReportListTableViewCell class] forCellReuseIdentifier:@"MJKGroupReportListTableViewCell"];
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.tableFooterView = [UIView new];
    if (@available(iOS 15.0,*)) {
        _tableView.sectionHeaderTopPadding = YES;
    }
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self httpGetAllMessageUnreadCount];
    [self getCountApproval];
    [self httpGetReport];
    [self httpGetLouDou];
    
    UIButton *button = [UIButton new];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    [button setTitle:@"选择门店" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [button addTarget:self action:@selector(chooseShop) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)chooseShop {
    MJKNewGroupShopsViewController *vc = [[MJKNewGroupShopsViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

//筛选漏斗
-(void)addFunnelView {
    FunnelShowView*funnelView=[FunnelShowView funnelShowView];
    self.funnelView=funnelView;
    funnelView.rootVC = self;
//        NSArray  *timeStr=@[@"全部",@"本周",@"上周",@"本月",@"上月",@"今年",@"去年",@"今天",@"昨天",@"最近7天",@"最近30天",@"自定义"];
//        NSArray *timeKeyStr=@[@" ",@"9",@"10",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"999"];
    
    NSArray  *timeStr=@[@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"今年",@"去年",@"近7天",@"最近30天",@"自定义"];
    NSArray  *timeKeyStr=@[@" ",@"1",@"2",@"3",@"4",@"5",@"6",@"9",@"10",@"7",@"30",@"999"];
    
    
    NSMutableArray*timeArr=[NSMutableArray array];
    for (int i=0; i<timeStr.count; i++) {
        MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
        model.name=timeStr[i];
        model.c_id=timeKeyStr[i];
        [timeArr addObject:model];
    }
    DBSelf(weakSelf);
    
   
        NSDictionary*dict=@{@"title":@"选择时间",@"content":timeArr};
        NSArray *nameArr = @[@"动态发生视角",@"历史追溯视角"];
        NSArray *codeArr = @[@"1",@"2"];
        NSMutableArray *tempArr = [NSMutableArray array];
        for (int i = 0; i < nameArr.count; i++) {
            MJKFunnelChooseModel *model = [[MJKFunnelChooseModel alloc]init];
            model.name = nameArr[i];
            model.c_id = codeArr[i];
            [tempArr addObject:model];
        }
        NSDictionary*dict1=@{@"title":@"视角",@"content":tempArr};
        funnelView.allDatas=[@[dict, dict1] mutableCopy];
    
    
    funnelView.viewCustomTimeBlock = ^(NSInteger selectSection){
        MyLog(@"自定义时间");
        [weakSelf showTimeAlertVC];
    };
    
    funnelView.sureBlock = ^(NSMutableArray *array) {
        MyLog(@"%@",array);
        if (array.count>0) {
            for (int i = 0; i < array.count; i++) {
                NSMutableArray <NSString *>*backArray = [NSMutableArray array];
                for (int i = 0; i < array.count; i++) {
                    [backArray addObject:array[i][@"index"]];
                }
                for (int j = 0; j < backArray.count; j++) {
                    MJKFunnelChooseModel *model = array[j][@"model"];
                    if ([backArray[j] isEqualToString:@"0"] ) {
                        
                        if ([model.c_id isEqualToString:@"999"]) {
                            //自定义
                        } else {
                            
                            weakSelf.START_TIME=@"";
                            weakSelf.END_TIME=@"";
                            weakSelf.timeType = model.c_id;
                            weakSelf.chooseDateStr = model.name;
                            [KUSERDEFAULT setObject:model.name forKey:@"grouptimeName"];
                        }
                    } else {
                        weakSelf.chooseDateStr = model.name;
                        weakSelf.shijiaoStr = model.c_id;
                        [KUSERDEFAULT setObject:model.name forKey:@"groupfunnelSelectValue"];
                    }
                }
            }
                
            [self httpGetLouDou];
            
        }
        
        
    };
    
    funnelView.resetBlock = ^{
        self.START_TIME = self.END_TIME = @"";
        self.shijiaoStr = @"";
        [self httpGetLouDou];
    };
    
    
    [[UIApplication sharedApplication].keyWindow addSubview:funnelView];
    
    
}

-(void)showTimeAlertVC{
    //自定义的选择时间界面。
    DBSelf(weakSelf);
    CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
        
    } withEnd:^{
        
    } withSure:^(NSString *start, NSString *end) {
        weakSelf.timeType = @"";
        weakSelf.START_TIME=start;
        weakSelf.END_TIME=end;
    }];
    [[UIApplication sharedApplication].keyWindow  addSubview:dateView];
}

#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
//    if (self.pkArray.count > 1) {
    NSString *cellTitle = self.cellArray[indexPath.section];
        if ([cellTitle isEqualToString:@"用户"]) {
            MJKHomePagePersonNewCell *cell = [MJKHomePagePersonNewCell cellWithTableView:tableView];
            cell.qcodeButton.hidden = YES;
            return cell;
        }  else if ([cellTitle isEqualToString:@"榜单"]) {
            MJKHomeJXTableViewCell *cell = [MJKHomeJXTableViewCell cellWithTableView:tableView];
            cell.buttonActionBlock = ^(NSInteger tag) {
                @strongify(self);
                MJKCollectionListViewController *vc = [[MJKCollectionListViewController alloc]init];
                if (tag == 0) {
                    //收款目标
                    vc.tabStr = @"销量榜";
                } else if (tag == 1) {
                    //累计完成
                    vc.tabStr = @"预约榜";
                } else if (tag == 2) {
                    //今日完成
                    vc.tabStr = @"跟进榜";
                } else if (tag == 4) {
                    //今日完成
                    vc.tabStr = @"逾期榜";
                } else if (tag == 3) {
                    //今日完成
                    vc.tabStr = @"资源榜";
                }
                [self.navigationController pushViewController:vc animated:YES];
            };
            return cell;
        } else if ([cellTitle isEqualToString:@"战报"]) {
            MJKGroupReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MJKGroupReportTableViewCell"];
            cell.timeLabel.text = self.timeStr;
            if ([self.tableType isEqualToString:@"1"] || [self.tableType isEqualToString:@"2"]) {
                [cell.backButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(35);
                }];
                cell.backButton.hidden = NO;
                [[[cell.backButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
                    @strongify(self);
                    if ([self.tableType isEqualToString:@"2"]) {
                        self.tableType = @"1";
                    } else if ([self.tableType isEqualToString:@"1"]) {
                        self.tableType = @"0";
                        [cell.backButton mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.height.mas_equalTo(0);
                        }];
                        cell.backButton.hidden = YES;
                    }
                    
                    [self httpGetReport];
                }];
            }
            
            [[[cell.timeButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
                @strongify(self);
                [BRDatePickerView showDatePickerWithMode:BRDatePickerModeYM title:self.timeStr   selectValue:self.timeStr resultBlock:^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
                    MyLog(@"yyyy-mm == %@", selectValue);
                    self.timeStr = selectValue;
                    cell.timeLabel.text = self.timeStr;
                    [self httpGetReport];
                }];
            }];
            [[[cell.leftButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
                @strongify(self);
                cell.leftButton.selected = YES;
                cell.rightButton.selected = NO;
                self.tableType = @"0";
                [cell.backButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(0);
                }];
                cell.backButton.hidden = YES;
                [self httpGetReport];
            }];
            [[[cell.rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
                @strongify(self);
                cell.rightButton.selected = YES;
                cell.leftButton.selected = NO;
                self.tableType = @"3";
                [cell.backButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(0);
                }];
                cell.backButton.hidden = YES;
                [self httpGetReport];
            }];
            return cell;
        } else if ([cellTitle isEqualToString:@"详情"]) {
            MJKGroupReportListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MJKGroupReportListTableViewCell"];
            cell.tableType = self.tableType;
            cell.dataArray = self.dataArray;
            cell.backToDetailBlock = ^(NSString * _Nonnull code) {
                @strongify(self);
                if ([self.tableType isEqualToString:@"0"]) {
                    self.tableType = @"1";
                    self.C_GRPCODE = code;
                } else if ([self.tableType isEqualToString:@"1"]) {
                    self.tableType = @"2";
                    self.C_ORGCODE = code;
                }
                
                
                [self httpGetReport];
            };
            return cell;
        } else if ([cellTitle isEqualToString:@"销售漏斗"]) {
            ReportTopTableViewCellNoGroup*cell=[ReportTopTableViewCellNoGroup cellWithTableView:tableView];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.rootVC = self;
            [cell getValue:self.mainModel];
            cell.buttonClickBlock = ^(NSInteger tag) {
                @strongify(self);
                MJKLouDouDetailViewController *vc = [MJKLouDouDetailViewController new];
                if (tag == 2000 ||tag == 2003 || tag == 2006 || tag == 2009 || tag == 2012 || tag == 2015) {
                    vc.title = @"到店流量";
                    vc.bangDanType = [NSString stringWithFormat:@"%ld", tag - 1999];
                } else if (tag == 2001 ||tag == 2004 || tag == 2007 || tag == 2010 || tag == 2013 || tag == 2016) {
                    vc.title = @"网络推广";
                    vc.bangDanType = [NSString stringWithFormat:@"%ld", tag - 1999];
                } else if (tag == 2002 ||tag == 2005 || tag == 2008 || tag == 2011 || tag == 2014  || tag == 2017) {
                    vc.title = @"私域运营";
                    vc.bangDanType = [NSString stringWithFormat:@"%ld", tag - 1999];
                }
                
                vc.CREATE_END_TIME = self.END_TIME;
                vc.CREATE_START_TIME = self.START_TIME;
                vc.CREATE_TIME_TYPE = self.timeType;
                [self.navigationController pushViewController:vc animated:YES];
            };
            return cell;
        }
    return [UITableViewCell new];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellTitle = self.cellArray[indexPath.section];
        if ([cellTitle isEqualToString:@"用户"]) {
            return 60;
        }  else if ([cellTitle isEqualToString:@"榜单"]) {
            return 100;
        } else if ([cellTitle isEqualToString:@"战报"]) {
            return UITableViewAutomaticDimension;
        } else if ([cellTitle isEqualToString:@"详情"]) {
            return UITableViewAutomaticDimension;
        } else if ([cellTitle isEqualToString:@"销售漏斗"]) {
            return 355;
        }
    return 44;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSString *cellTitle = self.cellArray[section];
    if ([cellTitle isEqualToString:@"用户"] || [cellTitle isEqualToString:@"详情"]) {
        return .1f;
    }
    return 30.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    NSString *cellTitle = self.cellArray[section];
    if ([cellTitle isEqualToString:@"用户"]) {
        return 100;
    }
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *cellTitle = self.cellArray[section];
    
    UIView*BGView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    BGView.backgroundColor=kBackgroundColor;
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth/2, 30)];
    titleLabel.font=[UIFont systemFontOfSize:14];
    titleLabel.textColor=[UIColor blackColor];
    [BGView addSubview:titleLabel];
    if ([cellTitle isEqualToString:@"榜单"]) {
        titleLabel.text = @"绩效榜单";
        return BGView;
    }
    if ([cellTitle isEqualToString:@"战报"]) {
        titleLabel.text = cellTitle;
        return BGView;
    }
    if ([cellTitle isEqualToString:@"销售漏斗"]) {
        titleLabel.text = cellTitle;
        
        UIButton*chooseButton=[[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth-12-100, 7, 100, 12)];
        [chooseButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [chooseButton setTitleNormal:[NSString stringWithFormat:@"%@>",self.chooseDateStr]];
        [chooseButton setTitleColor:[UIColor grayColor]];
        chooseButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [chooseButton addTarget:self action:@selector(clickChoose) forControlEvents:UIControlEventTouchUpInside];
        [BGView addSubview:chooseButton];
        
        return BGView;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSString *cellTitle = self.cellArray[section];
    if ([cellTitle isEqualToString:@"用户"]) {
        if (self.bgView != nil) {
            return self.bgView;
        }
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 200)];
        self.bgView = bgView;
        bgView.backgroundColor = [UIColor whiteColor];
        for (int i = 0; i < 2; i++) {
            UIView *v = [[UIView alloc]initWithFrame:CGRectMake(i * (KScreenWidth  / 2), 0, KScreenWidth / 2, 100)];
            v.backgroundColor = [UIColor whiteColor];
            [bgView addSubview:v];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, (v.frame.size.height - 50) / 2, 50, 50)];
            [v addSubview:imageView];
            imageView.image = [UIImage imageNamed:@[@"icon_home_approve", @"icon_home_message"][i]];
            UILabel  *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) - 10, CGRectGetMinY(imageView.frame), (v.frame.size.width - 50 - 10 - 10), 30)];
            UILabel  *bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) - 10, CGRectGetMaxY(imageView.frame) - 20, (v.frame.size.width - 50 - 10 - 10), 30)];
            topLabel.text = @[@"0",@"0"][i];
            if (i == 0) {
                self.approvalLabel = topLabel;
            } else {
                self.messageLabel = topLabel;
            }
            bottomLabel.text = @[@"业务审核",@"我的消息"][i];
            topLabel.textAlignment = bottomLabel.textAlignment = NSTextAlignmentCenter;
            topLabel.textColor  = bottomLabel.textColor = [UIColor blackColor];
            topLabel.font = bottomLabel.font = [UIFont systemFontOfSize:14.f];
            [v addSubview:topLabel];
            [v addSubview:bottomLabel];
            
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, v.frame.size.width, v.frame.size.height)];
            [v addSubview:button];
            button.tag = i + 100;
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        return bgView;
       
    }
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void)clickChoose{
    [self.funnelView removeFromSuperview];
    [self addFunnelView];
    [_funnelView show];
}

- (void)buttonAction:(UIButton *)sender {
    if (sender.tag == 100) {
        MJKApprolViewController *vc = [[MJKApprolViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        MJKMessageHomeViewController *vc = [[MJKMessageHomeViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)getCountApproval{
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_APPROVAL_ID"] = [NewUserSession instance].user.u051Id;
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:HTTP_SYSTEMD425COUNTRECORD parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
            MJKApprovalModel *model = [MJKApprovalModel mj_objectWithKeyValues:data[@"data"]];
            NSInteger count = model.A42500_C_TYPE_0004.intValue + model.A42500_C_TYPE_0000.intValue + model.A42500_C_TYPE_0001.intValue + model.A42500_C_TYPE_0002.intValue + model.A42500_C_TYPE_0003.intValue + model.A42500_C_TYPE_0006.intValue + model.A42500_C_TYPE_0007.intValue + model.A42500_C_TYPE_0008.intValue + model.A42500_C_TYPE_0009.intValue + model.A42500_C_TYPE_0010.intValue + model.A42500_C_TYPE_0011.intValue + model.A42500_C_TYPE_0012.intValue + model.A42500_C_TYPE_0013.intValue;
            weakSelf.approvalLabel.text = [NSString stringWithFormat:@"%ld", count];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)httpGetAllMessageUnreadCount {
    DBSelf(weakSelf);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:HTTP_A617List parameters:dict compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
             NSArray * dataArray = [MJKMessageDetailModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"list"]];
            NSInteger number = 0;
            for (MJKMessageDetailModel *model in dataArray) {
                if (![model.C_STATE_DD_ID isEqualToString:@"A61700_C_STATE_0000"]) {
                    number += 1;
                }
            }
            weakSelf.messageLabel.text = [NSString stringWithFormat:@"%ld", number];
            [weakSelf.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)httpGetReport {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_YEARMONTH"] = self.timeStr;
    contentDic[@"tableType"] = self.tableType;
    if ([self.tableType isEqualToString:@"1"]) {
        if (self.C_GRPCODE.length > 0) {
            contentDic[@"C_GRPCODE"] = self.C_GRPCODE;
        }
    }
    if ([self.tableType isEqualToString:@"2"]) {
        if (self.C_ORGCODE.length > 0) {
            contentDic[@"C_ORGCODE"] = self.C_ORGCODE;
        }
    }
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/report/zb", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.dataArray = [MJKGroupReportModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            [weakSelf.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)httpGetLouDou {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    
    if (self.START_TIME.length > 0) {
        contentDic[@"CREATE_START_TIME"] = self.START_TIME;
    }
    if (self.END_TIME.length > 0) {
        contentDic[@"CREATE_END_TIME"] = self.END_TIME;
    }
    if (self.timeType.length > 0) {
        contentDic[@"CREATE_TIME_TYPE"] = self.timeType;
    }
    if (self.shijiaoStr.length > 0) {
        contentDic[@"funnelSelectValue"] = self.shijiaoStr;
    }
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/crm/portal/funnel", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.mainModel = [ReportSheetModel mj_objectWithKeyValues:data[@"data"]];
            [weakSelf.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}


- (NSArray *)cellArray {
    if (!_cellArray) {
        _cellArray = @[@"用户",@"榜单",@"战报",@"详情", @"销售漏斗"];
    }
    return _cellArray;
}

@end
