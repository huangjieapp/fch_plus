//
//  MJKCustomerChooseViewController.m
//  Rebuild_newMJK
//
//  Created by huangjie on 2023/5/15.
//  Copyright © 2023 脉居客. All rights reserved.
//

#import "MJKCustomerChooseViewController.h"
#import "MJKOrderAddOrEditViewController.h"

#import "FunnelShowView.h"
#import "CFDropDownMenuViewNew.h"
#import "CGCCustomDateView.h"
#import "CFDropDownMenuView.h"
#import "CustomerListTableViewCell.h"
#import "NaviCountView.h"

#import "MJKFunnelChooseModel.h"
#import "EmployeesModel.h"
#import "ShopModel.h"
#import "ChannelModel.h"
#import "MJKCustomReturnSubModel.h"
#import "MJKProductShowModel.h"
#import "CGCCustomDetailModel.h"
#import "CGCCustomModel.h"

#import "CGCOrderListVC.h"

@interface MJKCustomerChooseViewController ()<UITableViewDataSource, UITableViewDelegate>
/** <#注释#> */
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#> */
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property(nonatomic,strong)NSMutableArray*FunnelDatas;     //漏斗的所有数据
/** <#注释#> */
@property (nonatomic, strong) CFDropDownMenuViewNew *dropDownMenuView;
@property(nonatomic,strong)NSMutableDictionary*saveSelTableDict;
@property(nonatomic,strong)NSMutableDictionary*saveSelFunnelDict;
@property(nonatomic,strong)NSMutableDictionary*saveSelTimeDict;
@property (nonatomic, strong) NSArray *pxDataArray;
@property (nonatomic, strong) NSString *C_A70600_C_ID;
@property (nonatomic, strong) NSString *C_A49600_C_ID;
@property (nonatomic, strong) NSString *arriveTimes;
@property (nonatomic, strong) NSString *jieshorenStr;
/** <#注释#>*/
@property (nonatomic, assign) NSInteger pagen;
/** <#注释#> */
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NaviCountView *naviCountView;

/** <#注释#> */
@property (nonatomic, strong) UIButton *searchButton;
/** <#注释#> */
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UIView *naviSearchView;
/** <#注释#> */
@property (nonatomic, strong) NSString *SEARCH_NAMEORCONTACT;
@end

@implementation MJKCustomerChooseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.searchButton.isSelected == YES) {
        self.naviSearchView.hidden = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.searchButton.isSelected == YES) {
        self.naviSearchView.hidden = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    @weakify(self);
    self.segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"我的",@"全部"]];
    self.segmentedControl.frame = CGRectMake(0, 0, 150, 30);
    self.navigationItem.titleView = self.segmentedControl;
    self.segmentedControl.selectedSegmentIndex = 0;
    self.saveSelTableDict[@"C_OWNER_ROLEID"] = [NewUserSession instance].user.u051Id;
    
    [[self.segmentedControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(__kindof UISegmentedControl * _Nullable x) {
        @strongify(self);
        if (x.selectedSegmentIndex == 0) {
            self.saveSelTableDict[@"C_OWNER_ROLEID"] = [NewUserSession instance].user.u051Id;
        } else {
            self.saveSelTableDict[@"C_OWNER_ROLEID"] = @"";
        }
        [self.tableView.mj_header beginRefreshing];
    }];
    
    _searchButton = [UIButton new];
   
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_searchButton];
        [_searchButton setImage:[UIImage imageNamed:@"搜索按钮"] forState:UIControlStateNormal];
        

    
    [[_searchButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIButton * _Nullable x) {
        @strongify(self);
        x.selected = !x.isSelected;
        if (x.isSelected == YES) {
            self.navigationItem.title = @"";
            self.segmentedControl.hidden = YES;
            self.naviSearchView.hidden = NO;
            [x setImage:[UIImage imageNamed:@"X图标"] forState:UIControlStateNormal];
        } else {
            self.navigationItem.title = @"订单";
            self.segmentedControl.hidden = NO;
            self.naviSearchView.hidden = YES;
            self.searchTextField.text = @"";
            self.SEARCH_NAMEORCONTACT = @"";
            [x setImage:[UIImage imageNamed:@"搜索按钮"] forState:UIControlStateNormal];
            [self.tableView.mj_header beginRefreshing];
        }
    }];
   
    
   
    
    _naviSearchView = [UIView new];
//    ((KScreenWidth - 210) / 2, NAVIHEIGHT - 30, 3 * 70, 30)
    //((KScreenWidth - 210) / 2, NAVIHEIGHT - 35, 3 * 70, 30)
    [self.navigationController.view addSubview:_naviSearchView];
    _naviSearchView.hidden = YES;
    [_naviSearchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo((KScreenWidth - 190) / 2);
        make.top.mas_equalTo(NAVIHEIGHT - 35);
        make.size.mas_equalTo(CGSizeMake(190, 30));
    }];
    
    _naviSearchView.layer.cornerRadius = 13;
    _naviSearchView.backgroundColor = [UIColor colorWithHexString:@"#55ffffff"];
    
    UIImageView *iconImageView = [UIImageView new];
    [_naviSearchView addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(7);
        make.bottom.mas_equalTo(-7);
        make.width.mas_equalTo(iconImageView.mas_height);
    }];
    iconImageView.image = [UIImage imageNamed:@"放大镜"];
    
    
    _searchTextField = [UITextField new];
    [_naviSearchView addSubview:_searchTextField];
    [_searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(26);
        make.right.mas_equalTo(-10);
    }];
    _searchTextField.returnKeyType = UIReturnKeyDone;
    _searchTextField.textColor = [UIColor darkGrayColor];
    _searchTextField.font = [UIFont  systemFontOfSize:12.f];
    _searchTextField.placeholder = @"请输入姓名/手机/地址/微信号";
    [[_searchTextField rac_signalForControlEvents:UIControlEventEditingDidEnd] subscribeNext:^(__kindof UITextField * _Nullable x) {
        @strongify(self);
        self.SEARCH_NAMEORCONTACT=x.text;
             [self.tableView.mj_header beginRefreshing];
    }];
    NSArray*arraySel=@[@"",@"5",@"0",@"1",@"2",@"4"]; NSArray*arraycode=@[@"",@"A47500_C_KHPX_0004",@"A47500_C_KHPX_0000",@"A47500_C_KHPX_0001",@"A47500_C_KHPX_0002",@"A47500_C_KHPX_0003"];
    NSInteger index = 0;
    if ([arraycode containsObject:[NewUserSession instance].configData.C_KHPX]) {
        index = [arraycode indexOfObject:[NewUserSession instance].configData.C_KHPX];
        [self.saveSelTableDict setObject:arraySel[index] forKey:@"TYPE"];
        
    } else {
        [self.saveSelTableDict setObject:[NewUserSession instance].configData.C_KHPX forKey:@"TYPE"];
    }
    
    [self createChooseView];
    [self getList];
    
    _tableView = [UITableView new];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(NAVIHEIGHT + 40));
        make.left.right.equalTo(@0);
        make.bottom.equalTo(@(-AdaptSafeBottomHeight));
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerClass:[CustomerListTableViewCell class] forCellReuseIdentifier:@"CustomerListTableViewCell"];
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.tableFooterView = [UIView new];
    if (@available(iOS 15.0,*)) {
        _tableView.sectionHeaderTopPadding = YES;
    }
    _naviCountView = [NaviCountView new];
    [self.view addSubview:_naviCountView];
    [_naviCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.equalTo(self.tableView.mas_top);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(20);
    }];
    
    [self configRefresh];
}

- (void)configRefresh {
    @weakify(self);
    self.pagen = 20;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.pagen = 20;
        [self getListDatas];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        self.pagen += 20;
        [self getListDatas];
    }];
    [self.tableView.mj_header beginRefreshing];
}

-(void)createChooseView{
    DBSelf(weakSelf);
        [weakSelf getActionOfMarketComplication:^(NSArray<MJKFunnelChooseModel*> *actionMarketArray) {

            NSString*customerSourceStr=@"来源渠道";
            NSMutableArray*customerSourceArr=[NSMutableArray array];
            MJKFunnelChooseModel*customerSourceModel=[[MJKFunnelChooseModel alloc]init];
            customerSourceModel.name=@"全部";
            customerSourceModel.c_id=@"";
            [customerSourceArr addObject:customerSourceModel];
            for (MJKDataDicModel*model in [[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41300_C_CLUESOURCE"]) {
                MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
                funnelModel.name=model.C_NAME;
                funnelModel.c_id=model.C_VOUCHERID;
                [customerSourceArr addObject:funnelModel];
            }
            NSDictionary*customerSourceDic=@{@"title":customerSourceStr,@"content":customerSourceArr};

            //市场活动
            NSString*str9=@"渠道细分";
            NSDictionary*dic9=@{@"title":str9,@"content":actionMarketArray};


            NSString*Str13=@"爱好";
            NSMutableArray*mtArr13=[NSMutableArray array];
            MJKFunnelChooseModel*Model13=[[MJKFunnelChooseModel alloc]init];
            Model13.name=@"全部";
            Model13.c_id=@"";
            [mtArr13 addObject:Model13];
            for (MJKDataDicModel*model in [[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41500_C_HOBBY"]) {
                MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
                funnelModel.name=model.C_NAME;
                funnelModel.c_id=model.C_VOUCHERID;
                [mtArr13 addObject:funnelModel];
            }
            NSDictionary*dic13=@{@"title":Str13,@"content":mtArr13};
//
//
//
            NSString*Str14=@"创建时间";
            NSMutableArray*mtArr14=[NSMutableArray array];
                NSArray * array14=@[@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"今年",@"去年",@"最近7天",@"最近30天",@"自定义"];
                NSArray * arraySel14=@[@"", @"1", @"2", @"3", @"4", @"5", @"6", @"9", @"10", @"7",@"30",@"999"];
            for (int i=0; i<array14.count; i++) {
                MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
                funnelModel.name=array14[i];
                funnelModel.c_id=arraySel14[i];
                [mtArr14 addObject:funnelModel];

            }
            NSDictionary*dic14=@{@"title":Str14,@"content":mtArr14};
//
//
            NSString*Str15=@"下次跟进时间";
            NSMutableArray*mtArr15=[NSMutableArray array];
                NSArray * array15=@[@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"今年",@"去年",@"最近7天",@"最近30天",@"自定义"];
                NSArray * arraySel15=@[@"", @"1", @"2", @"3", @"4", @"5", @"6", @"9", @"10", @"7",@"30",@"999"];
            for (int i=0; i<array15.count; i++) {
                MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
                funnelModel.name=array15[i];
                funnelModel.c_id=arraySel15[i];
                [mtArr15 addObject:funnelModel];

            }
            NSDictionary*dic15=@{@"title":Str15,@"content":mtArr15};
//

//
            NSArray*arraySel=@[@"",@"5",@"0",@"1",@"2",@"4"]; NSArray*arraycode=@[@"",@"A47500_C_KHPX_0004",@"A47500_C_KHPX_0000",@"A47500_C_KHPX_0001",@"A47500_C_KHPX_0002",@"A47500_C_KHPX_0003"];
            NSInteger index = 0;
            if ([arraycode containsObject:[NewUserSession instance].configData.C_KHPX]) {
                index = [arraycode indexOfObject:[NewUserSession instance].configData.C_KHPX];
                [self.saveSelTableDict setObject:arraySel[index] forKey:@"TYPE"];
                
            } else {
                [self.saveSelTableDict setObject:[NewUserSession instance].configData.C_KHPX forKey:@"TYPE"];
            }
                NSString*Str19=@"客户列表排序";
                NSMutableArray*mtArr19=[NSMutableArray array];
                NSArray*array19=@[@"全部",@"创建时间",@"活跃时间",@"下次跟进时间",@"等级",@"首字母"];
                NSArray*arraySel19=@[@"",@"5",@"0",@"1",@"2",@"4"];
                NSArray*arraycode19=@[@"",@"A47500_C_KHPX_0004",@"A47500_C_KHPX_0000",@"A47500_C_KHPX_0001",@"A47500_C_KHPX_0002",@"A47500_C_KHPX_0003"];
                for (int i=0; i<array19.count; i++) {
                    MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
                    funnelModel.name=array19[i];
                    funnelModel.c_id=arraySel19[i];
                    funnelModel.C_VOUCHERID = arraycode19[i];
                    if ([arraycode19[i] isEqualToString:[NewUserSession instance].configData.C_KHPX]) {
                        funnelModel.isSelected = YES;
                    } else if ([arraySel19[i] isEqualToString:[NewUserSession instance].configData.C_KHPX]) {
                        funnelModel.isSelected = YES;
                    }
                    [mtArr19 addObject:funnelModel];

                }
                NSDictionary*dic19=@{@"title":Str19,@"content":mtArr19};
//
//
                NSDictionary*pcDic=@{@"title":@"省市",@"content":@[]};
//

//
                NSString*zjgjStr23=@"最近跟进时间";
                NSMutableArray*zjgjmtArr23=[NSMutableArray array];

                NSArray * zjgjarray23=@[@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"今年",@"去年",@"最近7天",@"最近30天",@"自定义"];
                NSArray * zjgjarraySel23=@[@"", @"1", @"2", @"3", @"4", @"5", @"6", @"9", @"10", @"7",@"30",@"999"];
                for (int i=0; i<zjgjarray23.count; i++) {
                    MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
                    funnelModel.name=zjgjarray23[i];
                    funnelModel.c_id=zjgjarraySel23[i];
                    [zjgjmtArr23 addObject:funnelModel];

                }
                NSDictionary*zjgjdic23=@{@"title":zjgjStr23,@"content":zjgjmtArr23};
//
                NSString*zbStr23=@"战败时间";
                NSMutableArray*zbmtArr23=[NSMutableArray array];

                NSArray * zbarray23=@[@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"今年",@"去年",@"最近7天",@"最近30天",@"自定义"];
                NSArray * zbarraySel23=@[@"", @"1", @"2", @"3", @"4", @"5", @"6", @"9", @"10", @"7",@"30",@"999"];
                for (int i=0; i<zbarray23.count; i++) {
                    MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
                    funnelModel.name=zbarray23[i];
                    funnelModel.c_id=zbarraySel23[i];
                    [zbmtArr23 addObject:funnelModel];

                }
                NSDictionary*zbdic23=@{@"title":zbStr23,@"content":zbmtArr23};
//
//
//            //客户列表排序  协助人  业务  介绍人  到店次数>=  渠道细分  最后到店时间  创建时间  活跃时间  下次跟进事件
            NSMutableArray*funnelTotailArr=[NSMutableArray arrayWithObjects:dic19,pcDic,customerSourceDic,dic9,dic14,zjgjdic23,zbdic23,dic15,dic13, nil];
            self.FunnelDatas=funnelTotailArr;

            
            _dropDownMenuView = [[CFDropDownMenuViewNew alloc] initWithFrame:CGRectZero];
            [self.view addSubview:self.dropDownMenuView];
            _dropDownMenuView.VCName = @"客户";
            [_dropDownMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(-40);
                make.top.mas_equalTo(NavStatusHeight);
                make.height.mas_equalTo(40);
            }];
            _dropDownMenuView.funnelW = 40;
            
            NSMutableArray*levelDataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41500_C_LEVEL"];
            NSMutableArray*levelMtArray=[NSMutableArray array];
            NSMutableArray*levelPostArray=[NSMutableArray array];
            [levelMtArray addObject:@"全部"];
            [levelPostArray addObject:@""];
            for (MJKDataDicModel*model in levelDataArray) {
                [levelMtArray addObject:model.C_NAME];
                [levelPostArray addObject:model.C_VOUCHERID];
            }
            
            NSMutableArray*statusDataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41500_C_STATUS"];
            NSMutableArray*statusMtArray=[NSMutableArray array];
            NSMutableArray*statusPostArray=[NSMutableArray array];
            [statusMtArray addObject:@"全部"];
            [statusPostArray addObject:@""];
            [statusMtArray addObject:@"有意向"];
            [statusPostArray addObject:@"1"];
            for (MJKDataDicModel*model in statusDataArray) {
                [statusMtArray addObject:model.C_NAME];
                [statusPostArray addObject:model.C_VOUCHERID];
            }
            
            @weakify(self);
            NSMutableArray*saleCodeArray=[NSMutableArray array];
            // 注:  需先 赋值数据源dataSourceArr二维数组  再赋值defaulTitleArray一维数组
            
            NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
            contentDic[@"C_LOCCODE"] = [NewUserSession instance].user.C_LOCCODE;
            HttpManager*manager=[[HttpManager alloc]init];
            [manager getNewDataFromNetworkNOHUDWithUrl:HTTP_SYSTEMUserList parameters:contentDic compliation:^(id data, NSError *error) {
                if ([data[@"code"] integerValue] == 200) {
                    MyLog(@"");
                    @strongify(self);
                    NSArray *dataArray = [EmployeesSubModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
                    NSMutableArray*saleNameArray=[NSMutableArray array];
                    
                    [saleNameArray addObject:@"全部"];
                    [saleCodeArray addObject:@""];
                    for (EmployeesSubModel*model in dataArray) {
                        [saleNameArray addObject:model.nickName];
                        [saleCodeArray addObject:model.u051Id];
                    }
                    self.dropDownMenuView.dataSourceArr[0] = saleNameArray;
                    
                } else {
                    [JRToast showWithText:data[@"msg"]];
                }
            }];
            // 注:  需先 赋值数据源dataSourceArr二维数组  再赋值defaulTitleArray一维数组
            _dropDownMenuView.dataSourceArr = @[
                                                @[],
                                                @[],
                                                levelMtArray,
                                                statusMtArray
                                                ].mutableCopy;
            
            _dropDownMenuView.defaulTitleArray = [NSArray arrayWithObjects:@"员工",@"车型",@"等级", @"有意向", nil];
            
            
            // 下拉列表 起始y
            _dropDownMenuView.startY =  NavStatusHeight + 40;
            
            /**
             *  回调方式一: block
             */
            _dropDownMenuView.chooseProductConditionBlock = ^(NSString *code) {
                @strongify(self);
                NSArray *arr = [code componentsSeparatedByString:@","];
                self.saveSelTableDict[@"C_A70600_C_ID"] = arr[0];
                self.saveSelTableDict[@"C_A49600_C_ID"] = arr[1];
                [self.tableView.mj_header beginRefreshing];
            };
            
            _dropDownMenuView.chooseConditionNewBlock = ^(NSInteger titleIndex, NSInteger selectIndex , NSString *currentTitle, NSArray *currentTitleArray){
                @strongify(self);
                    if (titleIndex == 0) {
                        self.saveSelTableDict[@"C_OWNER_ROLEID"] = saleCodeArray[selectIndex];
                    } else if (titleIndex == 1) {
                        
                    } else if (titleIndex == 2) {
                        self.saveSelTableDict[@"C_LEVEL_DD_ID"] = levelPostArray[selectIndex];
                    } else if (titleIndex == 3) {
                        self.saveSelTableDict[@"C_STATUS_DD_ID"] = statusPostArray[selectIndex];
                    }
                    
                    [self.tableView.mj_header beginRefreshing];
                
                
            };
            
            NSMutableArray *khpxArray = [NSMutableArray array];
            NSArray * khpxCodeArr=@[@"", @"0", @"1", @"2", @"3", @"4",@"5"];
            NSArray * khpxNameArr=@[@"全部",@"活跃",@"跟进",@"等级",@"订单",@"首字母",@"创建时间"];
            for (int i=0; i<khpxCodeArr.count; i++) {
                MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
                funnelModel.name=khpxNameArr[i];
                funnelModel.c_id=khpxCodeArr[i];
                [khpxArray addObject:funnelModel];
                
            }
            NSDictionary *khpxDic = @{@"title" : @"客户列表排序", @"content" : khpxArray};
            
            NSMutableDictionary *mdDic = [NSMutableDictionary dictionary];
            HttpManager*manager1=[[HttpManager alloc]init];
            [manager1 getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/crm/a403/list", HTTP_IP] parameters:@{} compliation:^(id data, NSError *error) {
                if ([data[@"code"] integerValue] == 200) {
                    MyLog(@"");
                    NSMutableArray *mdArr = [NSMutableArray array];
                    MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
                    funnelModel.name=@"全部";
                    funnelModel.c_id=@"";
                    [mdArr addObject:funnelModel];
                    NSArray *arr= [ShopModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
                    for (ShopModel *model in arr) {
                        MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
                        funnelModel.name=model.C_NAME;
                        funnelModel.c_id=model.C_LOCCODE;
                        [mdArr addObject:funnelModel];
                        
                    }
                    mdDic[@"title"] = @"门店";
                    mdDic[@"content"] = mdArr;
                    
                } else {
                    [JRToast showWithText:data[@"msg"]];
                }
            }];
        
            
            NSDictionary *ssDic = @{@"title" : @"省市", @"content": @[]};
            
            NSMutableArray*clueSourceDataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41300_C_CLUESOURCE"];
            NSMutableArray*clueSourceArray=[NSMutableArray array];
            MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
            funnelModel.name=@"全部";
            funnelModel.c_id=@"";
            [clueSourceArray addObject:funnelModel];
            for (MJKDataDicModel*model in clueSourceDataArray) {
                MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
                funnelModel.name=model.C_NAME;
                funnelModel.c_id=model.C_VOUCHERID;
                [clueSourceArray addObject:funnelModel];
            }
            
            NSDictionary *clueSourceDic = @{@"title" : @"来源渠道", @"content" : clueSourceArray};
            
            NSMutableDictionary *qdxfDic = [NSMutableDictionary dictionary];
            NSMutableDictionary *crdic = [NSMutableDictionary dictionary];
            crdic[@"C_TYPE_DD_ID"] = @"A41200_C_TYPE_0000";
        //    crdic[@"C_CLUESOURCE_DD_ID"] = @"C_CLUESOURCE_DD_0001";
            HttpManager*manager2=[[HttpManager alloc]init];
            [manager2 getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/masterdata/a412/list", HTTP_IP] parameters:crdic compliation:^(id data, NSError *error) {
                if ([data[@"code"] integerValue] == 200) {
                    MyLog(@"");
                    NSMutableArray *mdArr = [NSMutableArray array];
                    MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
                    funnelModel.name=@"全部";
                    funnelModel.c_id=@"";
                    [mdArr addObject:funnelModel];
                    NSArray *arr= [ChannelModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"list"]];
                    for (ChannelModel *model in arr) {
            //            if ([model.C_STATUS_DD_ID isEqualToString:@"A41200_C_STATUS_0000"]) {//开启状态
                            
                            MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
                            funnelModel.name=model.C_NAME;
                            funnelModel.c_id=model.C_ID;
                            [mdArr addObject:funnelModel];
            //            }
                        
                    }
                    qdxfDic[@"title"] = @"渠道细分";
                    qdxfDic[@"content"] = mdArr;
                    
                } else {
                    [JRToast showWithText:data[@"msg"]];
                }
            }];
            
            
            NSMutableArray *createTimeArr = [NSMutableArray array];
            NSArray * createIdTimeArr=@[@"", @"1", @"2", @"3", @"4", @"5", @"6", @"9", @"10", @"7",@"30",@"999"];
            NSArray * createNameTimeArr=@[@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"今年",@"去年",@"最近7天",@"最近30天",@"自定义"];
            for (int i=0; i<createIdTimeArr.count; i++) {
                MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
                funnelModel.name=createNameTimeArr[i];
                funnelModel.c_id=createIdTimeArr[i];
                [createTimeArr addObject:funnelModel];
                
            }
            NSDictionary *createTimeDic = @{@"title" : @"创建时间", @"content" : createTimeArr};
            
            
            NSMutableArray *zjgjTimeArr = [NSMutableArray array];
            NSArray * zjgjIdTimeArr=@[@"", @"1", @"2", @"3", @"4", @"5", @"6", @"9", @"10", @"7",@"30",@"999"];
            NSArray * zjgjNameTimeArr=@[@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"今年",@"去年",@"最近7天",@"最近30天",@"自定义"];
            for (int i=0; i<zjgjIdTimeArr.count; i++) {
                MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
                funnelModel.name=zjgjNameTimeArr[i];
                funnelModel.c_id=zjgjIdTimeArr[i];
                [zjgjTimeArr addObject:funnelModel];
                
            }
            NSDictionary *zjgjTimeDic = @{@"title" : @"最近跟进时间", @"content" : zjgjTimeArr};
            
            
            NSMutableArray *zbTimeArr = [NSMutableArray array];
            NSArray * zbIdTimeArr=@[@"", @"1", @"2", @"3", @"4", @"5", @"6", @"9", @"10", @"7",@"30",@"999"];
            NSArray * zbNameTimeArr=@[@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"今年",@"去年",@"最近7天",@"最近30天",@"自定义"];
            for (int i=0; i<zbIdTimeArr.count; i++) {
                MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
                funnelModel.name=zbNameTimeArr[i];
                funnelModel.c_id=zbIdTimeArr[i];
                [zbTimeArr addObject:funnelModel];
                
            }
            NSDictionary *zbTimeDic = @{@"title" : @"战败时间", @"content" : zbTimeArr};
            
            
            NSMutableArray *xcgjTimeArr = [NSMutableArray array];
            NSArray * xcgjIdTimeArr=@[@"", @"1", @"2", @"3", @"4", @"5", @"6", @"9", @"10", @"7",@"30",@"999"];
            NSArray * xcgjNameTimeArr=@[@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"今年",@"去年",@"最近7天",@"最近30天",@"自定义"];
            for (int i=0; i<xcgjIdTimeArr.count; i++) {
                MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
                funnelModel.name=xcgjNameTimeArr[i];
                funnelModel.c_id=xcgjIdTimeArr[i];
                [xcgjTimeArr addObject:funnelModel];
                
            }
            NSDictionary *xcgjTimeDic = @{@"title" : @"下次跟进时间", @"content" : xcgjTimeArr};
            
            NSMutableArray*ahDataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41500_C_HOBBY"];
            NSMutableArray*ahArray=[NSMutableArray array];
            MJKFunnelChooseModel*funnelModelah=[[MJKFunnelChooseModel alloc]init];
            funnelModelah.name=@"全部";
            funnelModelah.c_id=@"";
            [ahArray addObject:funnelModel];
            for (MJKDataDicModel*model in ahDataArray) {
                MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
                funnelModel.name=model.C_NAME;
                funnelModel.c_id=model.C_VOUCHERID;
                [ahArray addObject:funnelModel];
            }
            
            NSDictionary *ahDic = @{@"title" : @"爱好", @"content" : ahArray};
            
            
            //这个是筛选的view
            FunnelShowView*funnelView=[FunnelShowView funnelShowView];
            funnelView.rootVC = self;
             __weak typeof(funnelView)weakFunnelView=funnelView;
            //赋值
            funnelView.allDatas=self.FunnelDatas;
            
            

            //c_id 是999 的时候  是选择时间
            funnelView.viewCustomTimeBlock = ^(NSInteger selectedSection) {
                MyLog(@"自定义时间   %lu",selectedSection);
                //      这里加时间   8    9   10   来跳窗口 并保存   测试
                if (selectedSection == 4) {
                    CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
                        
                    } withEnd:^{
                        
                    } withSure:^(NSString *start, NSString *end) {
                        
                        [self.saveSelTimeDict setObject:start forKey:@"CREATE_START_TIME"];
                        [self.saveSelTimeDict setObject:end forKey:@"CREATE_END_TIME"];
                        
                        
                        
                    }];
                    
                    
                    dateView.clickCancelBlock = ^{
        //                NSIndexPath*indexPath=[NSIndexPath indexPathForRow:6 inSection:10];
        //                [weakFunnelView unselectedDetailRow:indexPath];
                        
                        [self.saveSelTimeDict removeObjectForKey:@"CREATE_START_TIME"];
                        [self.saveSelTimeDict removeObjectForKey:@"CREATE_END_TIME"];
                        [self.saveSelFunnelDict setObject:@"" forKey:@"CREATE_TIME_TYPE"];
                        
                    };
                    
                    
                    
                    
                    [[UIApplication sharedApplication].keyWindow addSubview:dateView];
                } else if (selectedSection==5){
                    CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
                        
                    } withEnd:^{
                        
                    } withSure:^(NSString *start, NSString *end) {
                        
                        [self.saveSelTimeDict setObject:start forKey:@"FOLLOW_START_TIME"];
                        [self.saveSelTimeDict setObject:end forKey:@"FOLLOW_END_TIME"];
                        
                        
                        
                    }];
                    
                    
                    dateView.clickCancelBlock = ^{
        //                NSIndexPath*indexPath=[NSIndexPath indexPathForRow:6 inSection:10];
        //                [weakFunnelView unselectedDetailRow:indexPath];
                        
                        [self.saveSelTimeDict removeObjectForKey:@"FOLLOW_START_TIME"];
                        [self.saveSelTimeDict removeObjectForKey:@"FOLLOW_END_TIME"];
                        [self.saveSelFunnelDict setObject:@"" forKey:@"FOLLOW_TIME_TYPE"];
                        
                    };
                    
                    
                    
                    
                    [[UIApplication sharedApplication].keyWindow addSubview:dateView];
                    
                    
                }else if (selectedSection==6) {
                    CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
                        
                    } withEnd:^{
                        
            
                    } withSure:^(NSString *start, NSString *end) {
                        MyLog(@"11--%@   22--%@",start,end);
                        
                        [self.saveSelTimeDict setObject:start forKey:@"CUSTOMERFAIL_START_TIME"];
                        [self.saveSelTimeDict setObject:end forKey:@"CUSTOMERFAIL_END_TIME"];

                        
                        
                    }];
                    
                   
                    dateView.clickCancelBlock = ^{
        //                NSIndexPath*indexPath=[NSIndexPath indexPathForRow:6 inSection:8];
        //                [weakFunnelView unselectedDetailRow:indexPath];
                        
                        [self.saveSelTimeDict removeObjectForKey:@"CUSTOMERFAIL_START_TIME"];
                        [self.saveSelTimeDict removeObjectForKey:@"CUSTOMERFAIL_END_TIME"];
                        [self.saveSelFunnelDict setObject:@"" forKey:@"CUSTOMERFAIL_TIME_TYPE"];
                                     
                    };

                    
                    
                    [[UIApplication sharedApplication].keyWindow addSubview:dateView];

                    
                    
                    
                    
                }else if (selectedSection==7){
                    CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
                        
                    } withEnd:^{
                        
                    } withSure:^(NSString *start, NSString *end) {
            
                        
                        [self.saveSelTimeDict setObject:start forKey:@"LASTFOLLOW_START_TIME"];
                        [self.saveSelTimeDict setObject:end forKey:@"LASTFOLLOW_END_TIME"];
                        
                        
                        
                    }];
                    
                    dateView.clickCancelBlock = ^{
        //                NSIndexPath*indexPath=[NSIndexPath indexPathForRow:6 inSection:9];
        //                [weakFunnelView unselectedDetailRow:indexPath];
                        
                        [self.saveSelTimeDict removeObjectForKey:@"LASTFOLLOW_START_TIME"];
                        [self.saveSelTimeDict removeObjectForKey:@"LASTFOLLOW_END_TIME"];
                        [self.saveSelFunnelDict setObject:@"" forKey:@"LASTFOLLOW_TIME_TYPE"];
                        
                    };

                    
                    
                    
                    [[UIApplication sharedApplication].keyWindow addSubview:dateView];

                    
                    
                }
                
                
                

            };

            
            //    回调
            funnelView.sureBlock = ^(NSMutableArray *array) {

                MyLog(@"%@",array);
                DBSelf(weakSelf);
              
//                [self.saveSelFunnelDict removeAllObjects];
                for (NSDictionary*dict in array) {
                    NSString*indexStr=dict[@"index"];
                    MJKFunnelChooseModel*model=dict[@"model"];
                        
                    
                        if ([indexStr isEqualToString:@"0"]) {
                            //客户排序列表
                            [weakSelf.saveSelFunnelDict setObject:model.c_id forKey:@"TYPE"];
                            NSString *C_VOUCHERID;
                            NSMutableArray *arr = [NSMutableArray array];
                            for (MJKCustomReturnSubModel *model1 in weakSelf.pxDataArray) {
                                if ([model.C_VOUCHERID isEqualToString:model1.C_VOUCHERID]) {
                                    model1.C_STATUS_DD_ID = @"A47500_C_STATUS_0000";
                                } else {
                                    
                                    model1.C_STATUS_DD_ID = @"A47500_C_STATUS_0001";
                                }
                                C_VOUCHERID = model1.C_VOUCHERID;
                                NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
                                contentDic[@"C_ID"] = model1.C_ID;
                                contentDic[@"C_STATUS_DD_ID"] = model1.C_STATUS_DD_ID;
                                [arr addObject:contentDic];
                            }
                            
                            /*
                             A47500_C_KHPX_0000    客户活跃时间
                             A47500_C_KHPX_0001    客户下次跟进时间
                             A47500_C_KHPX_0002    客户等级
                             A47500_C_KHPX_0003    客户首字母
                             */
                            [weakSelf updateDatasWithArray:arr andCompleteBlock:^{
                                [NewUserSession instance].configData.C_KHPX = model.C_VOUCHERID;
                            }];
                        } else if ([indexStr isEqualToString:@"1"]) {
                            //省市
                        } else if ([indexStr isEqualToString:@"2"]) {
                            //来源
                            [weakSelf.saveSelFunnelDict setObject:model.c_id forKey:@"C_CLUESOURCE_DD_ID"];
                        } else if ([indexStr isEqualToString:@"3"]) {
                            //市场活动
                            [weakSelf.saveSelFunnelDict setObject:model.c_id forKey:@"C_A41200_C_ID"];
                        }  else if ([indexStr isEqualToString:@"4"]) {
                            //最后到店时间
                            if ([model.c_id isEqualToString:@"999"]) {
                                //不传这个字段
                                
                                
                            }else{
                                //移除timerDict 里面对应的东西
                                [weakSelf.saveSelTimeDict removeObjectForKey:@"CREATE_START_TIME"];
                                [weakSelf.saveSelTimeDict removeObjectForKey:@"CREATE_END_TIME"];
                                
                                [weakSelf.saveSelFunnelDict setObject:model.c_id forKey:@"CREATE_TIME_TYPE"];
                            }
                        } else if ([indexStr isEqualToString:@"5"]) {
                            //创建时间
                            if ([model.c_id isEqualToString:@"999"]) {
                                //不传这个字段
                                
                                
                            }else{
                                //移除timerDict 里面对应的东西
                                [weakSelf.saveSelTimeDict removeObjectForKey:@"FOLLOW_START_TIME"];
                                [weakSelf.saveSelTimeDict removeObjectForKey:@"FOLLOW_END_TIME"];
                                
                                [weakSelf.saveSelFunnelDict setObject:model.c_id forKey:@"FOLLOW_TIME_TYPE"];
                            }
                        } else if ([indexStr isEqualToString:@"6"]) {
                            //活跃时间
                            if ([model.c_id isEqualToString:@"999"]) {
                                //不传这个字段
                                
                            }else{
                                //移除timerDict 里面对应的东西
                                [weakSelf.saveSelTimeDict removeObjectForKey:@"CUSTOMERFAIL_START_TIME"];
                                [weakSelf.saveSelTimeDict removeObjectForKey:@"CUSTOMERFAIL_END_TIME"];
                                
                                
                                [weakSelf.saveSelFunnelDict setObject:model.c_id forKey:@"CUSTOMERFAIL_TIME_TYPE"];
                                
                            }
                        } else if ([indexStr isEqualToString:@"7"]) {
                            //下次跟进时间
                            if ([model.c_id isEqualToString:@"999"]) {
                                //不传这个字段
                                
                            }else{
                                //移除timerDict 里面对应的东西
                                [weakSelf.saveSelTimeDict removeObjectForKey:@"LASTFOLLOW_START_TIME"];
                                [weakSelf.saveSelTimeDict removeObjectForKey:@"LASTFOLLOW_END_TIME"];
                                
                                
                                [weakSelf.saveSelFunnelDict setObject:model.c_id forKey:@"LASTFOLLOW_TIME_TYPE"];
                            }
                        } else if ([indexStr isEqualToString:@"8"]){
                            //爱好
                             [weakSelf.saveSelFunnelDict setObject:model.c_id forKey:@"C_HOBBY_DD_ID"];
                            
                        }
                }
                    
                    
                
                
                
                 [weakSelf.tableView.mj_header beginRefreshing];
                
                
                
            };
            
            funnelView.chooseProductBlock = ^(MJKProductShowModel *productModel) {
                weakSelf.C_A70600_C_ID = productModel.C_TYPE_DD_ID;
                weakSelf.C_A49600_C_ID = productModel.C_ID;
            };
            
            funnelView.jieshaorenAndLastTimeBlock = ^(NSString *jieshaoren, NSString *arriveTimes) {
        //        if (jieshaoren.length > 0) {
        //            weakSelf.jieshorenStr = jieshaoren;
        //        }
                if (arriveTimes.length > 0) {
                    weakSelf.arriveTimes = arriveTimes;
                }
            };
            
            funnelView.pcBlock = ^(NSString *pcStr, NSString *pcCode) {
                if (pcCode.length > 0) {
                    NSArray *arr = [pcCode componentsSeparatedByString:@","];
                    weakSelf.saveSelFunnelDict[@"C_PROVINCE"] = arr[0];
                    weakSelf.saveSelFunnelDict[@"C_CITY"] = arr[1];
                }
            };
            
            
            
            funnelView.resetBlock = ^{
                [weakSelf.saveSelTimeDict removeObjectForKey:@"CREATE_START_TIME"];
                [weakSelf.saveSelTimeDict removeObjectForKey:@"CREATE_END_TIME"];
        //        [self.saveSelFunnelDict removeObjectForKey:@"FOLLOW_TIME"];
                
                [weakSelf.saveSelTimeDict removeObjectForKey:@"FOLLOW_START_TIME"];
                [weakSelf.saveSelTimeDict removeObjectForKey:@"FOLLOW_END_TIME"];
        //        [self.saveSelFunnelDict removeObjectForKey:@"LASTUPDATE_TIME"];
                
                [weakSelf.saveSelTimeDict removeObjectForKey:@"CUSTOMERFAIL_START_TIME"];
                [weakSelf.saveSelTimeDict removeObjectForKey:@"CUSTOMERFAIL_END_TIME"];
                
                [weakSelf.saveSelTimeDict removeObjectForKey:@"LASTFOLLOW_START_TIME"];
                [weakSelf.saveSelTimeDict removeObjectForKey:@"LASTFOLLOW_END_TIME"];
                
        //        [self.saveSelFunnelDict removeObjectForKey:@"CREATE_TIME"];
                weakSelf.arriveTimes = weakSelf.jieshorenStr = @"";
                weakSelf.C_A49600_C_ID = weakSelf.C_A70600_C_ID = @"";
                [weakSelf.saveSelFunnelDict removeAllObjects];
                
                [weakSelf.tableView.mj_header beginRefreshing];
            };
            [[UIApplication sharedApplication].keyWindow addSubview:funnelView];

            
            //这个是漏斗按钮
            CFRightButton*funnelButton=[[CFRightButton alloc]initWithFrame:CGRectMake( KScreenWidth-40,NavStatusHeight, 40, 40)];
            [self.view addSubview:funnelButton];
            funnelButton.clickFunnelBlock = ^(BOOL isSelected) {
        //        if (![weakSelf.isListOrSea isEqualToString:@"list"]) {
        //            return ;
        //        }
                //tablieView
                [_dropDownMenuView hide];
                //显示 左边的view
                [funnelView show];
            };

        }];
         
        
        
    
}

#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CGCCustomDetailModel *model = self.dataArray[section];
    return model.content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    CGCCustomDetailModel *model = self.dataArray[indexPath.section];
    CGCCustomModel *subModel = model.content[indexPath.row];
    CustomerListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomerListTableViewCell"];
    cell.titleLabel.text = subModel.C_NAME;
    cell.headLabel.text = subModel.C_NAME.length > 0 ? [subModel.C_NAME substringToIndex:1] : @"";
    cell.phoneLabel.text = subModel.C_PHONE;
    cell.statusLabel.text = subModel.C_STATUS_DD_NAME;
    cell.saleLabel.text = subModel.C_OWNER_ROLENAME;
    cell.addressLabel.text = subModel.C_A49600_C_NAME;
    cell.chooseButton.hidden = NO;
    [cell.headImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@64);
    }];
    [[[cell.chooseButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIButton * _Nullable x) {
        @strongify(self);
        x.selected = !x.isSelected;
        if ([self.rootVC isKindOfClass:[CGCOrderListVC class]]) {
            MJKOrderAddOrEditViewController *vc=[[MJKOrderAddOrEditViewController alloc]init];
            vc.Type = orderTypeAdd;
            vc.customerModel = subModel;
            vc.vcName = @"订单";
            if (self.rootVC != nil) {
                vc.rootVC = self.rootVC;
            } else {
                vc.rootVC = self;
            }
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            if (self.chooseCustomerBlock) {
                self.chooseCustomerBlock(subModel);
            }
        }
    }];
    if ([subModel.C_SEX_DD_ID isEqualToString:@"A41500_C_SEX_0000"]) {
        cell.genderImageView.image = [UIImage imageNamed:@"iv_man"];
        cell.genderImageView.hidden = NO;
    } else if ([subModel.C_SEX_DD_ID isEqualToString:@"A41500_C_SEX_0001"]) {
        cell.genderImageView.image = [UIImage imageNamed:@"iv_women"];
        cell.genderImageView.hidden = NO;
    } else {
        cell.genderImageView.hidden = YES;
    }
    if (subModel.C_LEVEL_DD_NAME.length >= 1) {
        NSString *level = [subModel.C_LEVEL_DD_NAME substringToIndex:1];
        cell.levelImageView.image = [UIImage imageNamed:level];
    }
    cell.starImageView.image = [UIImage imageNamed:[subModel.C_STAR_DD_ID isEqualToString:@"A41500_C_STAR_0000"] ? @"星标" : @"未星标"];
    if (subModel.C_HEADIMGURL_SHOW.length > 0) {
        cell.headImageView.hidden = NO;
        cell.headLabel.hidden = YES;
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:subModel.C_HEADIMGURL_SHOW]];
    } else {
        cell.headImageView.hidden = YES;
        cell.headLabel.hidden = NO;
        if (subModel.C_NAME.length >= 1) {
            cell.headLabel.text = [subModel.C_NAME substringToIndex:1];
        } else {
            cell.headLabel.text = @"";
        }
    }
    if ([subModel.C_STATUS_DD_ID isEqualToString:@"A41500_C_STATUS_0000"]) {
        
        cell.statusLabel.textColor=DBColor(75,176,196);
        
    }else if ([subModel.C_STATUS_DD_ID isEqualToString:@"A41500_C_STATUS_0004"]){
        cell.statusLabel.textColor=DBColor(129,222,92);
    }else if ([subModel.C_STATUS_DD_ID isEqualToString:@"A41500_C_STATUS_0001"]){
        cell.statusLabel.textColor=DBColor(252,126,111);
    }else{
        cell.statusLabel.textColor=DBColor(153,153,153);
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView*BGView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    BGView.backgroundColor=KColorGrayBGView;
    
    
    CGCCustomDetailModel *model = self.dataArray[section];
    
    UILabel*titleLabel=[UILabel new];
    [BGView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@17);
        make.centerY.equalTo(@0);
    }];
    titleLabel.textColor=KColorGrayTitle;
    titleLabel.font=[UIFont systemFontOfSize:14];
    titleLabel.text=model.total;
    [BGView addSubview:titleLabel];
    
    return BGView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void)getActionOfMarketComplication:(void(^)(NSArray<MJKFunnelChooseModel*>*actionMarketArray))actionMarketBlock{
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/masterdata/a412/list", HTTP_IP] parameters:@{@"C_TYPE_DD_ID":@"A41200_C_TYPE_0000"} compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            
            NSMutableArray*actionArray=[NSMutableArray array];
            MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
            funnelModel.name=@"全部";
            funnelModel.c_id=@"";
            [actionArray addObject:funnelModel];

            NSArray*contentArr=data[@"data"][@"list"];
            for (NSDictionary*dict in contentArr) {
                MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
                funnelModel.name=dict[@"C_NAME"];
                funnelModel.c_id=dict[@"C_ID"];
                [actionArray addObject:funnelModel];
            }
            
            
            actionMarketBlock(actionArray);
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
        
        
    }];

    
    
}

-(void)getList {
    
    NSMutableDictionary *dic=[NSMutableDictionary new];
    dic[@"TYPE"] = @"16";
    
    
    HttpManager*manager=[[HttpManager alloc]init];
    
    DBSelf(weakSelf);
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/a475/list", HTTP_IP] parameters:dic compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
            weakSelf.pxDataArray = [MJKCustomReturnSubModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"content"]];
        }else{
            
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

-(void)updateDatasWithArray:(NSArray *)array andCompleteBlock:(void(^)(void))completeBlock {
    //    DBSelf(weakSelf);
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/system/a475/editMore", HTTP_IP] parameters:@{@"array" : array} compliation:^(id data, NSError *error) {
   
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            if (completeBlock) {
                completeBlock();
            }
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];
    
    
}

-(void)getListDatas{
    @weakify(self);
    
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
    [contentDict setObject:@(1) forKey:@"pageNum"];
    [contentDict setObject:@(self.pagen) forKey:@"pageSize"];
    
    if (self.SEARCH_NAMEORCONTACT.length > 0) {
        contentDict[@"SEARCH_NAMEORCONTACT"] = self.SEARCH_NAMEORCONTACT;
    }
  
    [self.saveSelTableDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [contentDict setObject:obj forKey:key];
        
    }];
    
    [self.saveSelFunnelDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
         [contentDict setObject:obj forKey:key];
    }];
    
    [self.saveSelTimeDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [contentDict setObject:obj forKey:key];
    }];
    
    
    contentDict[@"C_LOCCODE"] = [NewUserSession instance].user.C_LOCCODE;
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a415/list", HTTP_IP] parameters:contentDict compliation:^(id data, NSError *error) {
        @strongify(self);

        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            self.dataArray = [CGCCustomDetailModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"content"]];
            NSNumber*number=data[@"data"][@"countNumber"];
            self.naviCountView.countLabel.text=[NSString stringWithFormat:@"总计:%@",number];
            [self.tableView reloadData];
            
            
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        
    }];
    
    
}

-(NSMutableDictionary *)saveSelTableDict{
    if (!_saveSelTableDict) {
        _saveSelTableDict=[NSMutableDictionary dictionary];
    }
    return _saveSelTableDict;
}

-(NSMutableDictionary *)saveSelFunnelDict{
    if (!_saveSelFunnelDict) {
        _saveSelFunnelDict=[NSMutableDictionary dictionary];
    }
    return _saveSelFunnelDict;
    
}

-(NSMutableDictionary*)saveSelTimeDict{
    if (!_saveSelTimeDict) {
        _saveSelTimeDict=[NSMutableDictionary dictionary];
    }
    return _saveSelTimeDict;
}


@end
