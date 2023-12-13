//
//  CGCBrokerCenterVC.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/5/10.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "CGCBrokerCenterVC.h"
#import "BrokerOldCustomerVC.h"

#import "AddBrokerView.h"
#import "BrokerCustomVC.h"

#import "VoiceView.h"

#import "CGCCustomCell.h"
#import "CGCCustomDetailModel.h"
#import "CGCNavSearchTextView.h"
#import "CFDropDownMenuView.h"
#import "CGCSellModel.h"
#import "MJKDataDicModel.h"
#import "MJKFunnelChooseModel.h"
#import "CGCCustomDateView.h"


#import "MJKVoiceCViewController.h"

#import "CGCAddBrokerVC.h"

#import "CGCVerListCell.h"

#import "CGCShowWXHY.h"

#import "WXApi.h"

#import "MJKBrokerCenterCell.h"

#import "SingleIntegarModel.h"
#import "MJKTabView.h"

@interface CGCBrokerCenterVC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
/** <#注释#>*/
@property (nonatomic, strong) MJKTabView *tabView;

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,strong) NSMutableArray *dataArray;
/** <#注释#>*/
@property (nonatomic, strong) VoiceView *vv;

@property (nonatomic,strong) CGCNavSearchTextView *CurrentTitleView;

@property (assign) NSInteger currPage;

@property (nonatomic, strong) NSMutableArray *sellArray;

@property (nonatomic, strong) CGCSellModel * uploadModel;

@property (nonatomic, strong) NSMutableArray *saveFunnelAllDatas;

@property (nonatomic, strong) UIView *bottomView;

@property(nonatomic,copy)void(^localBlock)();

@property(nonatomic,copy)void(^myLocalBlock)();

@property (nonatomic, strong) NSMutableArray *selArr;

@property (nonatomic, strong) CGCCustomModel *flowModel;

@property (nonatomic, strong) UILabel *totalLab;

@property (nonatomic, copy) NSString *totalStr;

@property (nonatomic, strong) UIButton *totalBtn;

@property (nonatomic, strong) NSMutableArray *shopTimeArr;

@property (nonatomic, strong) NSMutableArray * shopTimeCodeArr;



@property (nonatomic, copy) NSString *CREATE_START_TIME;

@property (nonatomic, copy) NSString *CREATE_END_TIME;


/** <#备注#>*/
@property (nonatomic, strong) NSString *C_LEVEL_DD_ID;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UITextField *searchBar;

@end

@implementation CGCBrokerCenterVC

- (void)setIsAdd:(BOOL)isAdd {
    _isAdd = isAdd;
    if (isAdd == YES) {
        [self addNewAppointment];
    }
}

- (void)setLoudou:(NSString *)loudou {
    _loudou = loudou;
    CGRect frame = self.tableView.frame;
    frame.origin.y = frame.origin.y + 40;
    frame.size.height = frame.size.height + WD_TabBarHeight;
    self.tableView.frame = frame;
}

- (void)setTabSearchStr:(NSString *)tabSearchStr {
    _tabSearchStr = tabSearchStr;
    self.uploadModel.SEARCH_NAMEORCONTACT = tabSearchStr;
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.currPage=1;
    self.totalStr=@"总计:0";
    self.uploadModel=[[CGCSellModel alloc] init];
    [self.view addSubview:self.tableView];
    [self createNav];
    [self chooseView];
    [self HTTPGetSellList];
    [self HTTPGetLogList];
    [self getMarketActionDatas];
    
    DBSelf(weakSelf);
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currPage=1;
        [weakSelf HTTPGetLogList];
        
    }];
    
    self.tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.currPage++;
        [weakSelf HTTPGetLogList];
        
    }];
    
    if ([self.VCName isEqualToString:@"模板"]) {
        
        //        [[UIApplication sharedApplication].keyWindow addSubview:self.bottomView];
        
        [self.view addSubview:self.bottomView];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"isRefresh"] isEqualToString:@"yes"]) {
        [self.tableView.mj_header beginRefreshing];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isRefresh"];
    }
    
    if ([self.VCName isEqualToString:@"模板"]) {
        self.bottomView.hidden=NO;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.bottomView.hidden=YES;
    
}

- (void)chooseView{
    
    CFDropDownMenuView*menuView=[[CFDropDownMenuView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth-40, 40)];
    
    DBSelf(weakSelf);
    
    NSArray *titleArr=@[@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"今年",@"去年",@"最近7天",@"最近30天",@"自定义"];
    NSArray *idArr=@[@"", @"1", @"2", @"3", @"4", @"5", @"6", @"9", @"10", @"7",@"30",@"999"];
    self.localBlock = ^{
        //销售
        NSMutableArray * arr=[NSMutableArray arrayWithArray:@[@"全部",@"我的"]];
        if (weakSelf.sellArray.count>1) {
            for (CGCSellModel* model in weakSelf.sellArray) {
                NSString * str= model.nickName.length>0?model.nickName:@" ";
                [arr addObject:str];
                
            }
        }
        //等级
        NSMutableArray * typeArr =[weakSelf getArrayWithType:@"A47700_C_TYPE"];
        
        NSMutableArray *levelArr =[weakSelf getArrayWithType:@"A47700_C_LEVEL"];
        
        
        
        menuView.dataSourceArr=[@[
                                  arr,
                                  levelArr,
                                  typeArr,
                                  titleArr] mutableCopy];
        menuView.defaulTitleArray=@[@"员工",  @"等级",@"类型" ,@"最后活跃"];
        
    };
    
    
    NSArray * sidArr=@[@"0",@"1",@"2",@"3"];
    
    
    menuView.startY=CGRectGetMaxY(menuView.frame);
    
    
    
    [self.view addSubview:menuView];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(KScreenWidth-60, NavStatusHeight + 40, 60, 20);
    [btn setBgImage:@"all_bg"];
    [btn setTitleNormal:self.totalStr];
    btn.titleLabel.font=[UIFont systemFontOfSize:12];
    [btn setTitleColor:[UIColor lightGrayColor]];
    [self.view addSubview:btn];
    
    self.totalBtn=btn;
    
#pragma   各种筛选的点击事件
    
    menuView.chooseConditionBlock = ^(NSString *selectedSection, NSString *selectedRow, NSString *title) {
        
        NSLog(@"%@---%@--%@",selectedSection,selectedRow,title);
        switch ([selectedSection intValue]) {
            case 0://状态
                if ([title isEqualToString:@"全部"]) {
                    weakSelf.uploadModel.USER_ID=@"";
                } else if ([title isEqualToString:@"我的"]) {
                    weakSelf.uploadModel.USER_ID = [NewUserSession instance].user.u051Id;
                } else {
                    weakSelf.uploadModel.USER_ID=[weakSelf.sellArray[[selectedRow intValue]-2] u051Id];
                }
                
                
                break;
                
                
                
            case 1://等级
                if ([title isEqualToString:@"全部"]) {
                    weakSelf.C_LEVEL_DD_ID=@"全部";
                }
                weakSelf.C_LEVEL_DD_ID=[self getIdWithType:@"A47700_C_LEVEL" withTitle:title];
                
                
                
                break;
                
            case 2: {
                if ([title isEqualToString:@"全部"]) {
                    weakSelf.C_TYPE_DD_ID=@"全部";
                }
                weakSelf.C_TYPE_DD_ID=[self getIdWithType:@"A47700_C_TYPE" withTitle:title];
            }
                break;
            case 3://
                if ([title isEqualToString:@"自定义"]) {
                    DBSelf(weakSelf);
                    CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
                        
                    } withEnd:^{
                        
                    } withSure:^(NSString *start, NSString *end) {
                        
                        
                        weakSelf.currPage = 1;
                        weakSelf.uploadModel.LASTUPDATE_START_TIME=start;
                        weakSelf.uploadModel.LASTUPDATE_END_TIME=end;
                        weakSelf.uploadModel.LASTUPDATE_TIME_TYPE =@"";
                        [weakSelf HTTPGetLogList];
                    }];
                    [[UIApplication sharedApplication].keyWindow  addSubview:dateView];
                } else {
                    weakSelf.uploadModel.LASTUPDATE_START_TIME=@"";
                    weakSelf.uploadModel.LASTUPDATE_END_TIME=@"";
                    
                    weakSelf.uploadModel.LASTUPDATE_TIME_TYPE =idArr[[selectedRow intValue]];
                }
                
                break;
                
                
            default:
                break;
        }
        self.currPage=1;
        [weakSelf HTTPGetLogList];
        
    };
    
    
    //这个是筛选的view
    FunnelShowView*funnelView=[FunnelShowView funnelShowView];
    NSDictionary *dicCjh = @{@"title" : @"车架号", @"content" : @[]};
    funnelView.allDatas = [@[dicCjh] mutableCopy];
    //回调
    funnelView.sureBlock = ^(NSMutableArray *array) {
        
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    [[UIApplication sharedApplication].keyWindow addSubview:funnelView];
    
    funnelView.resetBlock = ^{
        weakSelf.uploadModel.C_VIN = @"";
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    
    
    funnelView.jieshaorenAndLastTimeBlock = ^(NSString *jieshaoren, NSString *arriveTimes) {
        if (arriveTimes.length > 0) {
            if ([jieshaoren isEqualToString:@"vin"]) {
                weakSelf.uploadModel.C_VIN = arriveTimes;
            }
        }
    };
    [[UIApplication sharedApplication].keyWindow addSubview:funnelView];
    
    //这个是漏斗按钮
    CFRightButton*funnelButton=[[CFRightButton alloc]initWithFrame:CGRectMake( KScreenWidth-40,NavStatusHeight, 40, 40)];
    
    [self.view addSubview:funnelButton];
    funnelButton.clickFunnelBlock = ^(BOOL isSelected) {
        [menuView hide];
        //显示 左边的view
        [funnelView show];
        NSLog(@"%d-==-",isSelected);
    };
    
    
    funnelView.viewCustomTimeBlock = ^(NSInteger selectedSession){//创建时间
        MyLog(@"创建时间");
        
        CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
            
        } withEnd:^{
            
        } withSure:^(NSString *start, NSString *end) {
            
            self.uploadModel.START_TIME=start;
            self.uploadModel.END_TIME=end;
            self.uploadModel.CREATE_TIME=@"";
            
            if (start.length>0||end.length>0) {
                self.currPage=1;
                [weakSelf HTTPGetLogList];
            }
            
        }];
        [self.view addSubview:dateView];
        
    };
    funnelView.indexTimeBlock  = ^{//下次跟进时间
        MyLog(@"下次跟进时间");
        
        CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
            
        } withEnd:^{
            
        } withSure:^(NSString *start, NSString *end) {
            
            self.uploadModel.FOLLOW_START_TIME=start;
            self.uploadModel.FOLLOW_END_TIME=end;
            self.uploadModel.FOLLOW_TIME=@"";
            
            if (start.length>0||end.length>0) {
                self.currPage=1;
                [weakSelf HTTPGetLogList];
            }
        }];
        [self.view addSubview:dateView];
        
    };
    
    funnelView.TimeBlock= ^{//活跃时间
        MyLog(@"活跃时间");
        
        CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
            
        } withEnd:^{
            
        } withSure:^(NSString *start, NSString *end) {
            
            self.uploadModel.LASTUPDATE_START_TIME=start;
            self.uploadModel.LASTUPDATE_END_TIME=end;
            self.uploadModel.LASTUPDATE_TIME=@"";
            if (start.length>0||end.length>0) {
                self.currPage=1;
                [weakSelf HTTPGetLogList];
            }
            
        }];
        [self.view addSubview:dateView];
        
    };
    
    
}

//获取数据字典数组
- (NSMutableArray *)getArrayWithType:(NSString *)type{
    
    NSMutableArray * arr=[NSMutableArray arrayWithArray:@[@"全部"]];
    for (MJKDataDicModel *model in[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:type] ) {
        NSString * str= model.C_NAME.length>0?model.C_NAME:@" ";
        [arr addObject:str];
    }
    return arr;
    
}

- (NSString *)getIdWithType:(NSString *)type withTitle:(NSString *)title{
    
    NSString * str=@"";
    for (MJKDataDicModel *model in[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:type] ) {
        
        if ([title isEqualToString:model.C_NAME]) {
            
            str = model.C_VOUCHERID;
            
        }
    }
    
    return str;
}

- (NSDictionary *)getdictWith:(NSString *)type withTitle:(NSString *)title{
    
    NSMutableArray * startArr=[self getArrayWithType:type];
    NSMutableArray * contentArr=[NSMutableArray array];
    for (NSString * str in startArr) {
        NSString * sid=[self getIdWithType:type withTitle:str];
        MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
        model.name=str;
        model.c_id=sid;
        [contentArr addObject:model];
    }
    NSDictionary*dic=@{@"title":title,@"content":contentArr};
    return dic;
}

- (NSDictionary *)getDateDictWithTitle:(NSString *)title withSid:(NSString *)sid{
    
    
    NSArray *titleArr=@[@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"今年",@"去年",@"最近7天",@"最近30天",@"自定义"];
    NSArray *idArr=@[@"", @"1", @"2", @"3", @"4", @"5", @"6", @"9", @"10", @"7",@"30",@"999"];
    NSMutableArray * contentArr=[NSMutableArray array];
    for (int i=0;i<titleArr.count;i++) {
        
        MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
        model.name=titleArr[i];
        model.c_id=idArr[i];
        [contentArr addObject:model];
        
    }
    NSDictionary*dic=@{@"title":title,@"content":contentArr};
    return dic;
}

- (NSDictionary *)getStatusDictWithTitle:(NSString *)title{
    
    
    NSArray * titleArr=@[@"全部",@"绑定",@"未绑定"];
    NSArray * idArr=@[@"",@"A47700_C_STATUS_0000",@"A47700_C_STATUS_0001"];
    NSMutableArray * contentArr=[NSMutableArray array];
    for (int i=0;i<titleArr.count;i++) {
        
        MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
        model.name=titleArr[i];
        model.c_id=idArr[i];
        [contentArr addObject:model];
        
    }
    NSDictionary*dic=@{@"title":title,@"content":contentArr};
    return dic;
}


#pragma mark -- createUI
- (void)createNav{
    self.view.backgroundColor=CGCTABBGColor;
    DBSelf(weakSelf);
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 220, 30)];
    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.borderColor = kBackgroundColor.CGColor;
    CGRect rect = self.bgView.frame;
    rect.size.height = 30;
    self.bgView.frame = rect;
    self.bgView.layer.cornerRadius = 15;
    
    self.searchBar = [[UITextField alloc]initWithFrame:CGRectMake(10, 0,200, 30)];
    self.searchBar.placeholder =@"请输入姓名/手机号";
    self.searchBar.font = [UIFont systemFontOfSize:12];
    [self.bgView addSubview:self.searchBar];
    [self.searchBar addTarget:self action:@selector(endEdit:) forControlEvents:UIControlEventEditingDidEnd];
    
    self.CurrentTitleView=[[CGCNavSearchTextView alloc] initWithFrame:self.view.bounds withPlaceHolder:@"请输入姓名/手机" withRecord:^{//点击录音
//        MJKVoiceCViewController *voiceVC = [[MJKVoiceCViewController alloc]initWithNibName:@"MJKVoiceCViewController" bundle:nil];
//        [voiceVC setBackStrBlock:^(NSString *str){
//            if (str.length>0) {
//                _CurrentTitleView.textField.text = str;
//                self.searchStr=str;
//                [self.tableView.mj_header beginRefreshing];
//            }
//        }];
        self.vv = [[VoiceView alloc]initWithFrame:self.view.frame];
        
        [self.view addSubview:self.vv];
//        [weakSelf presentViewController:voiceVC animated:YES completion:nil];
        [weakSelf.vv start];
        weakSelf.vv.recordBlock = ^(NSString *str) {
            
            _CurrentTitleView.textField.text = str;
            weakSelf.uploadModel.SEARCH_NAMEORCONTACT=str;
            [weakSelf.tableView.mj_header beginRefreshing];

        };
        
    } withText:^{//开始编辑
        MyLog(@"编辑");
        
        
    }withEndText:^(NSString *str) {//结束编辑
        NSLog(@"%@____",str);
        if (str.length>0) {
            weakSelf.uploadModel.SEARCH_NAMEORCONTACT=str;
//            [weakSelf.tableView.mj_header beginRefreshing];
        }
    }];
   
    UIButton *searchButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [searchButton setImage:@"搜索按钮"];
    [searchButton addTarget:self action:@selector(searchButtonAction:)];
    if (![self.typeName isEqualToString:@"名单经纪人"]) {
        self.navigationItem.rightBarButtonItems = @[ [UIBarButtonItem itemWithImage:@"icon_customer_add" highImage:@"" isLeft:NO target:self andAction:@selector(addNewAppointment)], [[UIBarButtonItem alloc]initWithCustomView:searchButton] ];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:searchButton];
    }
    
    
    
    if (self.textFieldText.length > 0) {
        self.currPage=1;
        self.CurrentTitleView.textField.text = self.textFieldText;
        self.uploadModel.SEARCH_NAMEORCONTACT=self.textFieldText;
        [weakSelf HTTPGetLogList];
    }
    self.uploadModel.C_FSLX_DD_ID = self.index.length > 0 ? @"1" : @"A47700_C_FSLX_0000";
    NSMutableArray *nameArray = [NSMutableArray array];
    if ([[NewUserSession instance].appcode containsObject:@"crm:a477_zj:list"]) {
        [nameArray addObject:@"桩脚"];
    } else {
        self.uploadModel.C_FSLX_DD_ID = @"1";
    }
    if ([[NewUserSession instance].appcode containsObject:@"crm:a477:list"]) {
        [nameArray addObject:@"老客户"];
    } else {
        self.uploadModel.C_FSLX_DD_ID = @"A47700_C_FSLX_0000";
    }
    self.tabView = [[MJKTabView alloc]initWithFrame:CGRectMake(0, 7, 2 * 70, 30) andNameItems:nameArray  withDefaultIndex:self.index.length > 0 ? self.index.integerValue : 0  andIsSaveItem:NO andClickButtonBlock:^(NSString * _Nonnull str) {
        if ([str isEqualToString:@"桩脚"]) {
            weakSelf.uploadModel.C_FSLX_DD_ID = @"A47700_C_FSLX_0000";
        } else {
            weakSelf.uploadModel.C_FSLX_DD_ID = @"1";
        }
        [weakSelf.tableView.mj_header beginRefreshing];
    }];
//    self.navigationItem.titleView=self.bgView;
    self.navigationItem.titleView=self.tabView;
}

- (void)searchButtonAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected == YES) {
        [sender setImage:@"X图标"];
        self.navigationItem.titleView = self.bgView;
    } else {
        [sender setImage:@"搜索按钮"];
        self.searchBar.text = @"";
        self.uploadModel.SEARCH_NAMEORCONTACT = @"";
        [self.tableView.mj_header beginRefreshing];
        self.navigationItem.titleView = self.tabView;
    }
}

- (void)endEdit:(UITextField*)sender {
    self.uploadModel.SEARCH_NAMEORCONTACT = sender.text;
    [self.tableView.mj_header beginRefreshing];
}


- (void)addNewAppointment{
    
    DBSelf(weakSelf);
    CGCAddBrokerVC * avc=[[CGCAddBrokerVC alloc] init];
    //    avc.title = self.type == BrokerCenterAgent ? @"新增经纪人" : @"新增会员";
    SingleIntegarModel *memberModel = [[SingleIntegarModel alloc]init];
    memberModel.C_FSLX_DD_ID = self.uploadModel.C_FSLX_DD_ID;
    if ([memberModel.C_FSLX_DD_ID isEqualToString:@"A47700_C_FSLX_0000"]) {
        memberModel.leixing = @"开发桩脚";
        memberModel.lxID = @"A47700_C_TYPE_0000";
    } else {
        memberModel.leixing = @"会员";
        memberModel.lxID = @"A47700_C_TYPE_0006";
    }
    avc.type = CGCAddBrokerAdd;
    avc.model = memberModel;
    avc.addBlock = ^{
        weakSelf.currPage=1;
        [weakSelf HTTPGetLogList];
    };
    [self.navigationController pushViewController:avc animated:NO];
}




#pragma mark -- tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count>0?self.dataArray.count:0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    CGCCustomDetailModel * model=self.dataArray[section];
    return model.content.count>0?model.content.count:0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MJKBrokerCenterCell * cell=[MJKBrokerCenterCell cellWithTableView:tableView];
    CGCCustomModel *model=[self.dataArray[indexPath.section] content][indexPath.row];
    [cell brokerCellWithModel:model];
    
    if ([self.typeName isEqualToString:@"名单经纪人"]) {
        cell.selectImageView.hidden = NO;
        cell.imageLeftLayout.constant = 40;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 84;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![[NewUserSession instance].appcode containsObject:@"APP015_0012"]) {
        [JRToast showWithText:@"账号无权限"];
        return;
    }
    if ([self.uploadModel.C_FSLX_DD_ID isEqualToString:@"A47700_C_FSLX_0000"]) {
        CGCCustomModel *model=[self.dataArray[indexPath.section] content][indexPath.row];
        if (self.backSelectFansBlock) {
            self.backSelectFansBlock(model);
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        BrokerCustomVC * bvc=[[BrokerCustomVC alloc] init];
        
        bvc.mainModel=[[PotentailCustomerListDetailModel alloc] init];
        bvc.mainModel.C_A41500_C_ID=model.C_OBJECTID;
        bvc.mainModel.C_ID=model.C_ID;
        [self.navigationController pushViewController:bvc animated:NO];
    } else {
        CGCCustomModel *model=[self.dataArray[indexPath.section] content][indexPath.row];
        if (self.backSelectFansBlock) {
            self.backSelectFansBlock(model);
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        BrokerOldCustomerVC * bvc=[[BrokerOldCustomerVC alloc] init];
        
        bvc.mainModel=[[PotentailCustomerListDetailModel alloc] init];
        bvc.mainModel.C_A41500_C_ID=model.C_OBJECTID;
        bvc.mainModel.C_ID=model.C_ID;
        bvc.mainModel.C_FSLX_DD_ID = model.C_FSLX_DD_ID;
        
        [self.navigationController pushViewController:bvc animated:NO];
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return YES;
}


- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DBSelf(weakSelf);
    
    
    UITableViewRowAction *shop = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                    title:@"绑定"
                                                                  handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                      if ([[NewUserSession instance].appcode containsObject:@"APP015_0005"]) {
                                                                          [JRToast showWithText:@"账号无权限"];
                                                                          return ;
                                                                      }
                                                                      [weakSelf httpRequestQrcode];
                                                                  }];
    
    shop.backgroundColor=KNaviColor;
    
    
    NSArray *arr = @[shop];
    
    
    return arr;
    
    
    
    
}

#pragma mark -- request网络请求

- (void)HTTPGetLogList{
    
    
    NSMutableDictionary *dic=[NSMutableDictionary new];
    
    
//    [dic setObject:@"10" forKey:@"pageSize"];
//    [dic setObject:@(self.currPage) forKey:@"currPage"];
    [dic setObject:@"10" forKey:@"pageSize"];
    [dic setObject:@(self.currPage) forKey:@"pageNum"];
    //等级
    if (self.C_LEVEL_DD_ID.length>0) {
        [dic setObject:self.C_LEVEL_DD_ID forKey:@"C_LEVEL_DD_ID"];
    }
    if (self.C_TYPE_DD_ID.length > 0) {
        [dic setObject:self.C_TYPE_DD_ID forKey:@"C_TYPE_DD_ID"];
    }
    if (self.C_STATUS_DD_ID.length>0) {
        [dic setObject:self.C_STATUS_DD_ID forKey:@"C_STATUS_DD_ID"];
    }
    if (self.uploadModel.CREATE_TIME.length>0) {
        [dic setObject:self.uploadModel.CREATE_TIME forKey:@"CREATE_TIME_TYPE"];
    }
    if (self.uploadModel.START_TIME.length>0&&self.uploadModel.END_TIME.length>0) {
        [dic setObject:self.uploadModel.END_TIME forKey:@"CREATE_END_TIME"];
        [dic setObject:self.uploadModel.START_TIME forKey:@"CREATE_START_TIME"];
    }
    if (self.uploadModel.FOLLOW_TIME.length > 0 ) {
        [dic setObject:self.uploadModel.FOLLOW_TIME forKey:@"LASTFOLLOW_TIME_TYPE"];
    } else {
        if (self.LASTFOLLOW_TIME_TYPE.length > 0) {
            [dic setObject:self.LASTFOLLOW_TIME_TYPE forKey:@"LASTFOLLOW_TIME_TYPE"];
        }
    }
    //self.uploadModel.FOLLOW_START_TIME
    if (self.uploadModel.FOLLOW_START_TIME.length>0&&self.uploadModel.FOLLOW_END_TIME.length>0) {
        [dic setObject:self.uploadModel.FOLLOW_END_TIME forKey:@"LASTFOLLOW_END_TIME"];
        [dic setObject:self.uploadModel.FOLLOW_START_TIME forKey:@"LASTFOLLOW_START_TIME"];
    }
    if (self.LASTFOLLOW_START_TIME.length > 0) {
        [dic setObject:self.LASTFOLLOW_START_TIME forKey:@"LASTFOLLOW_START_TIME"];
    }
    
    if (self.LASTFOLLOW_END_TIME.length > 0) {
        [dic setObject:self.LASTFOLLOW_END_TIME forKey:@"LASTFOLLOW_END_TIME"];
    }
    
    if (self.uploadModel.LASTUPDATE_TIME_TYPE.length > 0 ) {
        [dic setObject:self.uploadModel.LASTUPDATE_TIME_TYPE forKey:@"LASTUPDATE_TIME_TYPE"];
    }
    //self.uploadModel.FOLLOW_START_TIME
    if (self.uploadModel.LASTUPDATE_START_TIME.length>0&&self.uploadModel.LASTUPDATE_END_TIME.length>0) {
        [dic setObject:self.uploadModel.LASTUPDATE_END_TIME forKey:@"LASTUPDATE_END_TIME"];
        [dic setObject:self.uploadModel.LASTUPDATE_START_TIME forKey:@"LASTUPDATE_START_TIME"];
    }
    
    if ( self.uploadModel.SEARCH_NAMEORCONTACT.length>0) {
        [dic setObject:self.uploadModel.SEARCH_NAMEORCONTACT forKey:@"SEARCH_NAMEORCONTACT"];
    }
    if (self.uploadModel.C_STAR_DD_ID.length > 0) {
        
        [dic setObject:self.uploadModel.C_STAR_DD_ID forKey:@"C_STAR_DD_ID"];
    }
    
    if (self.uploadModel.USER_ID.length > 0) {
        [dic setObject:self.uploadModel.USER_ID forKey:@"USER_ID"];
    }
    if (self.uploadModel.C_FSLX_DD_ID.length > 0) {
        [dic setObject:self.uploadModel.C_FSLX_DD_ID forKey:@"C_FSLX_DD_ID"];
    } else {
        if (self.C_FSLX_DD_ID.length > 0) {
            [dic setObject:self.C_FSLX_DD_ID forKey:@"C_FSLX_DD_ID"];
        }
    }
    
    if (self.SEARCH_TYPE.length > 0) {
        dic[@"SEARCH_TYPE"] = self.SEARCH_TYPE;
    }
    
    if (self.uploadModel.C_VIN.length > 0) {
        [dic setObject:self.uploadModel.C_VIN forKey:@"C_VIN"];
    }
    
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a477/list",HTTP_IP] parameters:dic compliation:^(id data, NSError *error) {
        
//    }
//    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        
        if ([data[@"code"] integerValue]==200) {
            
            if (self.currPage==1) {
                [self.dataArray removeAllObjects];
            }
            
            
            
            for (NSDictionary * div in data[@"data"][@"content"]) {
                CGCCustomDetailModel * model=[CGCCustomDetailModel yy_modelWithDictionary:div];
                if(model.content.count>0){
                    [self.dataArray addObject:model];
                }
                
            }
            
            if (self.dataArray.count==0) {
                self.tableView.tableFooterView=[[UIView alloc] init];
                //                [self createLabStr:@"暂无客户" withbool:NO];
            }else{
                
                //             [self createLabStr:@"" withbool:YES];
            }
            
            
            self.totalStr=[NSString stringWithFormat:@"总计:%@",data[@"data"][@"countNumber"]];
            [self.totalBtn setTitleNormal:self.totalStr];
            
            
        }else{
            self.currPage>1?self.currPage--:0;
            
            [JRToast showWithText:data[@"msg"]];
        }
        
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
//        if ([data[@"data"][@"countNumber"] integerValue] < 10) {
//            [self.tableView.mj_footer endRefreshingWithNoMoreData];
//        }
    }];
    
    
}


- (void)httpRequestQrcode{
    DBSelf(weakSelf);
    NSMutableDictionary * dict=[NSMutableDictionary dictionary];
    [dict setObject:[NewUserSession instance].accountId forKey:@"usertoken"];
    
    
    [[POPRequestManger defaultManger] requestWithMethod:POST url:HTTP_getQrcode dict:dict target:self finished:^(id responsed) {
        
        if ([responsed[@"code"] intValue]==200) {
            
            [weakSelf showWXWithDict:responsed[@"mine"]];
            
        }else{
            [JRToast showWithText:responsed[@"message"]];
        }
        
        
    } failed:^(id error) {
        [JRToast showWithText:@"网络连接失败"];
    }];
    
}



- (void)showWXWithDict:(NSDictionary *)dict{
    
    CGCShowWXHY * cView=[CGCShowWXHY getView];
    //    cView.nameLab.text=dict[@"accountName"];
    //    [cView.headImg sd_setImageWithURL:[NSURL URLWithString:dict[@"headurl"]]];
    [cView.img sd_setImageWithURL:[NSURL URLWithString:dict[@"qrcode"]]];
    DBSelf(weakSelf);
    cView.wBlock = ^(NSString *title) {
        
        if ([title isEqualToString:@"wx"]) {
            [weakSelf sendWeiXin:@"" withDesc:@"" withImg:dict[@"qrcode"]];
        }
        
    };
    
    
    [cView showView];
    
}

#pragma mark --- 微信分享
- (void)sendWeiXin:(NSString *)title withDesc:(NSString *)desc withImg:(NSString *)imgUrl{
    
    
    UIImage *image=[self handleImageWithURLStr:imgUrl];
    
    //创建分享内容对象
    WXMediaMessage *urlMessage = [WXMediaMessage message];
    
    [urlMessage setThumbImage:image];//分享图片,使用SDK的setThumbImage方法可压缩图片大小
    
    
    WXImageObject *imageObject=[WXImageObject object];
    imageObject.imageData=UIImagePNGRepresentation(image);
    urlMessage.mediaObject=imageObject;
    
    
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.scene = WXSceneSession;
    req.bText = NO;
    req.message = urlMessage;
    [WXApi sendReq:req completion:nil];
    
    
}

- (UIImage *)handleImageWithURLStr:(NSString *)imageURLStr {
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURLStr]];
    NSData *newImageData = imageData;
    // 压缩图片data大小
    newImageData = UIImageJPEGRepresentation([UIImage imageWithData:newImageData scale:0.1], 0.1f);
    UIImage *image = [UIImage imageWithData:newImageData];
    
    // 压缩图片分辨率(因为data压缩到一定程度后，如果图片分辨率不缩小的话还是不行)
    CGSize newSize = CGSizeMake(100, 100);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)HTTPGetSellList{
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/user/list",HTTP_IP] parameters:@{@"C_LOCCODE" : [NewUserSession instance].user.C_LOCCODE} compliation:^(id data, NSError *error) {
    
   
        
        if ([data[@"code"] integerValue]==200) {
            NSDictionary*dict=[data copy];
            for (NSDictionary * div in dict[@"data"]) {
                CGCSellModel * model=[CGCSellModel yy_modelWithDictionary:div];
                [self.sellArray addObject:model];
            }
            
            if (self.localBlock) {
                self.localBlock();
            }
            
        }else{
            
            [JRToast showWithText:data[@"msg"]];
        }
        
        
    }];
    
}


//得到市场活动的数据
-(void)getMarketActionDatas{
    NSMutableArray*saveMarketArray=[NSMutableArray array];
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/masterdata/a412/list", HTTP_IP] parameters:@{@"C_TYPE_DD_ID":@"A41200_C_TYPE_0000"} compliation:^(id data, NSError *error) {
        DBSelf(weakSelf);
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            NSArray*array=data[@"data"][@"list"];
            for (NSDictionary*dict in array) {
                MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
                model.name=dict[@"C_NAME"];
                model.c_id=dict[@"C_ID"];
                
                [saveMarketArray addObject:model];
            }
            MyLog(@"%@",saveMarketArray);
            NSDictionary*dic=@{@"title":@"渠道细分",@"content":saveMarketArray};
            //            [weakSelf.saveFunnelAllDatas addObject:dic];
            //这里赋值完成后  让漏斗加载视图
            if (self.myLocalBlock) {
                self.myLocalBlock();
            }
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    CGCCustomDetailModel *model = self.dataArray[section];
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 20)];
    view.backgroundColor=CGCTABBGColor;
    
    UILabel * lab=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 20)];
    lab.text=model.total;
    lab.textColor=[UIColor lightGrayColor];
    lab.font=[UIFont systemFontOfSize:14];
    [view addSubview:lab];
    if (section==0) {
        
    }else{
        UIView * line=[[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 1)];
        line.backgroundColor=DBColor(221, 220, 223);
        [view addSubview:line];
        
    }
    
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20.0;
}




#pragma mark -- set
- (UITableView *)tableView{
    
    if (_tableView==nil) {
        
        if ([self.VCName isEqualToString:@"模板"]) {
            CGRect rect = CGRectZero;
            if (self.isTab) {
                rect = CGRectMake(0, NavStatusHeight + 40, KScreenWidth, KScreenHeight-NavStatusHeight - 40-40 - WD_TabBarHeight - WD_TabBarHeight);
            } else {
                rect = CGRectMake(0, NavStatusHeight + 40, KScreenWidth, KScreenHeight-NavStatusHeight - 40-40 - WD_TabBarHeight - SafeAreaBottomHeight);
            }
            _tableView=[[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        }else{
            CGRect rect = CGRectZero;
            if (self.isTab) {
                rect = CGRectMake(0, NavStatusHeight + 40, KScreenWidth, KScreenHeight-NavStatusHeight - 40 - WD_TabBarHeight - WD_TabBarHeight);
            } else {
                rect = CGRectMake(0, NavStatusHeight + 40, KScreenWidth, KScreenHeight-NavStatusHeight - 40 - WD_TabBarHeight - SafeAreaBottomHeight);
            }
            _tableView=[[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        }
        
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.estimatedRowHeight=50;
        _tableView.tableFooterView=[[UIView alloc] init];
        //        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        
    }
    
    return _tableView;
}

- (NSMutableArray *)dataArray{
    
    if (_dataArray==nil) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
    
}

- (NSMutableArray *)sellArray{
    
    if (_sellArray==nil) {
        _sellArray=[NSMutableArray array];
    }
    
    return _sellArray;
    
}
- (NSMutableArray *)saveFunnelAllDatas{
    
    if (_saveFunnelAllDatas==nil) {
        
        NSDictionary * startDict=[self getdictWith:@"A41500_C_STAR" withTitle:@"星标客户"];
        NSDictionary * customDict=[self getdictWith:@"A41300_C_CLUESOURCE" withTitle:@"来源细分"];
        _saveFunnelAllDatas=[NSMutableArray arrayWithArray:@[startDict]];
        
    }
    
    return _saveFunnelAllDatas;
    
}


- (UIView *)bottomView{
    
    if (!_bottomView) {
        _bottomView=[[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight-40, KScreenWidth, 40)];
        _bottomView.backgroundColor=KNaviColor;
        UIButton * canel=[self getBtnWithFrame:CGRectMake(10, 0, 50, 40) WithTitle:@"取消"];
        UIButton * selAll=[self getBtnWithFrame:CGRectMake(80, 0, 50, 40) WithTitle:@"全选"];
        UIButton * sure=[self getBtnWithFrame:CGRectMake(KScreenWidth- 60, 0, 50, 40) WithTitle:@"确定"];
        
        [_bottomView addSubview:canel];
        [_bottomView addSubview:selAll];
        [_bottomView addSubview:sure];
        
    }
    
    return _bottomView;
}

- (NSMutableArray *)selArr{
    
    if (!_selArr) {
        _selArr=[NSMutableArray array];
    }
    
    return _selArr;
}


- (UIButton *)getBtnWithFrame:(CGRect)rect WithTitle:(NSString *)title{
    
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=rect;
    btn.titleNormal=title;
    btn.titleColor=DBColor(0, 0, 0);
    [btn addTarget:self action:@selector(bottomClick:)];
    btn.titleLabel.font=[UIFont systemFontOfSize:14];
    return btn;
}

- (void)bottomClick:(UIButton *)btn{
    
    
    if ([btn.titleNormal isEqualToString:@"全选"]) {
        
        
        for (CGCCustomDetailModel * dmodel in self.dataArray) {
            
            for (CGCCustomModel *model in dmodel.content) {
                
                model.isSelChecked=YES;
            }
            
            
        }
        [self.tableView reloadData];
        
    }
    if ([btn.titleNormal isEqualToString:@"取消"]) {
        for (CGCCustomDetailModel * dmodel in self.dataArray) {
            
            for (CGCCustomModel *model in dmodel.content) {
                
                model.isSelChecked=NO;
            }
            
            
        }
        [self.tableView reloadData];
        
    }
    if ([btn.titleNormal isEqualToString:@"确定"]) {
        [self.selArr removeAllObjects];
        for (CGCCustomDetailModel * dmodel in self.dataArray) {
            
            for (CGCCustomModel *model in dmodel.content) {
                
                if(model.isSelChecked==YES){
                    
                    [self.selArr addObject:model];
                }
            }
            
            
        }
        
        
        
        //        NSLog(@"%@-=",self.selArr);
    }
    
}


- (NSMutableArray *)shopTimeArr {
    if (!_shopTimeArr) {
        _shopTimeArr = [NSMutableArray arrayWithObjects:@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"今年",@"去年",@"最近7天",@"最近30天",@"自定义", nil];
    }
    return _shopTimeArr;
}

- (NSMutableArray *)shopTimeCodeArr {
    if (!_shopTimeCodeArr) {
        _shopTimeCodeArr = [NSMutableArray arrayWithObjects:@"", @"1", @"2", @"3", @"4", @"5", @"6", @"9", @"10", @"7",@"30",@"999", nil];
    }
    return _shopTimeCodeArr;
}

@end
