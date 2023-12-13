//   订单列表
//  CGCOrderListVC.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/7.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CGCOrderListVC.h"
#import "CGCAddBrokerVC.h"
#import "MJKCustomerChooseViewController.h"

#import "CGCAppointmentCell.h"
#import "CGCAppointmentModel.h"
#import "CGCOrderDetailModel.h"
#import "CGCOrderModel.h"
#import "CGCNavSearchTextView.h"
#import "CGCSellModel.h"
#import "CGCMoreActionView.h"
#import "CGCAlertDateView.h"
#import "CGCCustomDateView.h"
#import "MJKNewUserModel.h"
#import "CFDropDownMenuViewNew.h"
#import "CustomTimeView.h"

#import "OrderDetailViewController.h"
#import "MJKFunnelChooseModel.h"

#import "CFDropDownMenuView.h"
#import "CommonCallViewController.h"
#import "MJKVoiceCViewController.h"
#import "CGCMoreCollection.h"
#import "WXApi.h"

#import "CGCTemplateVC.h"
#import "NewUserSession.h"
#import "MJKMarketSubModel.h"
#import "EmployeesModel.h"

#import "MJKSingleBackView.h"
#import "ServiceTaskAddViewController.h"
#import "MJKOrderRecordViewController.h"
#import "MJKOrderAddOrEditViewController.h"
#import "MJKMarketViewController.h"//选择销售顾问
#import "ShowHelpViewController.h"//协助
#import "AddHelperViewController.h"//设计师

#import "DBAssignBottomChooseView.h"

#import "ServiceTaskDetailModel.h"

#import "MJKOrderFllowViewController.h"
#import "MJKClueListSubModel.h"

#import "VoiceView.h"


#import "SingleIntegarModel.h"

#import "MJKTabView.h"

#import "MJKChooseEmployeesViewController.h"

typedef enum {
    kShareTool_WeiXinFriends = 0, // 微信好友
    kShareTool_WeiXinCircleFriends, // 微信朋友圈
} ShareToolType;
@interface CGCOrderListVC ()<UITableViewDelegate,UITableViewDataSource>
{

enum WXScene _scene;
}
@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSMutableArray *sellArray;

@property (nonatomic,strong) CGCNavSearchTextView *titleView;

@property (assign) NSInteger currPage;

@property (nonatomic, copy) NSString *SEARCH_NAMEORCONTACT;

@property (nonatomic,strong) CFDropDownMenuView * menuView;
/** <#注释#> */
@property (nonatomic, strong) CFDropDownMenuViewNew *dropDownMenuView;

@property (nonatomic,strong) CGCSellModel * sellModel;

@property (nonatomic,strong) CGCMoreActionView * moreView;//更多操作弹层

@property (nonatomic,strong) CGCAlertDateView * alertDateView;

@property (nonatomic, strong) NSMutableDictionary * operationDict;

@property (nonatomic, strong) UIButton *totalBtn;

@property (nonatomic, strong) UILabel *totalLab;

@property (nonatomic, copy) NSString *totalStr;

@property (nonatomic, assign) BOOL isAssAgain;//是否重新指派
@property (nonatomic, assign) BOOL isAllSelected;//重新指派时是否全选
@property (nonatomic, assign) BOOL isRefresh;//重新指派时直接返回不刷新

@property (nonatomic, strong) DBAssignBottomChooseView *bottomChooseView;
@property (nonatomic, strong) CGCOrderDetailModel *detailModel;

@property (nonatomic, strong) NSMutableArray *allArray;
/** 协助人*/
@property (nonatomic, strong) NSString *assistStr;
/** 协助发起人*/
@property (nonatomic, strong) NSString *assistFromStr;
/** salesPromotionArray 促销活动*/
@property (nonatomic, strong) NSArray *salesPromotionArray;

/** <#注释#>*/
@property (nonatomic, strong) UILabel *totalLabel;

/** <#注释#>*/
@property (nonatomic, strong) NSString *jiesharenstr;
/** MJKTabView*/
@property (nonatomic, strong) MJKTabView *tabView;
/** <#注释#>*/
@property (nonatomic, strong) NSString *tabStr;
/** 协助人*/
@property (nonatomic, strong) NSDictionary *dic16;
/** 协助发起人*/
@property (nonatomic, strong) NSDictionary *dic17;
/** 漏斗*/
@property (nonatomic, strong) FunnelShowView*funnelView;
/** <#注释#>*/
@property (nonatomic, strong) NSArray *saleSubArray;

/** <#注释#>*/
@property (nonatomic, strong) NSMutableDictionary *saveTableDataDic;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableDictionary *saveTimeDataDic;

@property (nonatomic, strong) UIView *naviSearchView;

@property (nonatomic, strong) UITextField *searchTextField;
@end

@implementation CGCOrderListVC

- (void)setLoudou:(NSString *)loudou {
    _loudou = loudou;
//    CGRect frame = self.tableView.frame;
//    frame.origin.y += 40;
//    frame.size.height = frame.size.height + WD_TabBarHeight;
//    self.tableView.frame = frame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    if (@available(iOS 11.0,*)) {
//        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
//    }else{
//        self.automaticallyAdjustsScrollViewInsets=NO;
//    }
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAVIHEIGHT + 40);
        make.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(-SafeAreaBottomHeight);
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
//    [_tableView registerClass:[MJKCarSourceHomeTableViewCell class] forCellReuseIdentifier:@"MJKCarSourceHomeTableViewCell"];
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.tableFooterView = [UIView new];
    if (@available(iOS 15.0,*)) {
        _tableView.sectionHeaderTopPadding = YES;
    }
    DBSelf(weakSelf);
    self.currPage=20;
	self.isAssAgain = NO;
	self.isRefresh = YES;
    self.totalStr=@"总计:0";
    if (self.IS_ASSISTANT.length <= 0) {
        self.IS_ASSISTANT = @"0";
    }
    [self httpGetUserListWithModelArrayBlock:nil];
    [self createNav];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.tableView.mj_header beginRefreshing];
    });
    
    
    // Do any additional setup after loading the view.
}

#pragma mark -- createUI
- (void)createNav{
    self.sellModel=[[CGCSellModel alloc] init];
    self.startTime.length>0?self.sellModel.START_TIME_TYPE=self.startTime:nil;
    self.statusID.length>0?self.sellModel.C_STATUS_DD_ID=self.statusID:0;
    self.endTime.length>0?self.sellModel.JF_END_TIME=self.endTime:0;
	self.LASTFOLLOW_TIME_TYPE.length > 0 ? self.sellModel.LASTFOLLOW_TIME_TYPE = self.LASTFOLLOW_TIME_TYPE : 0;
	self.LASTFOLLOW_END_TIME.length > 0 ? self.sellModel.LASTFOLLOW_END_TIME = self.LASTFOLLOW_END_TIME : 0;
    
    self.view.backgroundColor=CGCTABBGColor;
    DBSelf(weakSelf);
    _naviSearchView = [UIView new];
//    ((KScreenWidth - 210) / 2, NAVIHEIGHT - 30, 3 * 70, 30)
    //((KScreenWidth - 210) / 2, NAVIHEIGHT - 35, 3 * 70, 30)
    [self.navigationController.view addSubview:_naviSearchView];
//    _naviSearchView.hidden = YES;
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
    _searchTextField.textColor = [UIColor darkGrayColor];
    _searchTextField.font = [UIFont  systemFontOfSize:12.f];
    _searchTextField.placeholder = @"请输入手机/客户姓名/订单编号/地址";
    [[_searchTextField rac_signalForControlEvents:UIControlEventEditingDidEnd] subscribeNext:^(__kindof UITextField * _Nullable x) {
        [weakSelf.allArray removeAllObjects];
         weakSelf.currPage=20;
         weakSelf.SEARCH_NAMEORCONTACT=x.text;
             [weakSelf HTTPGetOrderList];
    }];
    
    self.titleView=[[CGCNavSearchTextView alloc] initWithFrame:self.view.bounds withPlaceHolder:@"请输入手机/客户姓名/订单编号/地址" withRecord:^{//点击录音
        
//        MJKVoiceCViewController *voiceVC = [[MJKVoiceCViewController alloc]initWithNibName:@"MJKVoiceCViewController" bundle:nil];
//        [voiceVC setBackStrBlock:^(NSString *str){
//           [self.allArray removeAllObjects];
//            self.currPage=20;
//            weakSelf.titleView.textField.text = str;
//            self.SEARCH_NAMEORCONTACT=str;
//            [self HTTPGetOrderList];
//        }];
//        [weakSelf presentViewController:voiceVC animated:YES completion:nil];
		VoiceView *vv = [[VoiceView alloc]initWithFrame:self.view.frame];
        [weakSelf.view addSubview:vv];
		[vv start];
		vv.recordBlock = ^(NSString *str) {
			[weakSelf.allArray removeAllObjects];
            weakSelf.currPage=20;
			weakSelf.titleView.textField.text = str;
            weakSelf.SEARCH_NAMEORCONTACT=str;
			[weakSelf HTTPGetOrderList];

			
			
		};
    } withText:^{//开始编辑
        [weakSelf.allArray removeAllObjects];
        
        
    }withEndText:^(NSString *str) {//结束编辑
        NSLog(@"%@____",str);
       [weakSelf.allArray removeAllObjects];
        weakSelf.currPage=20;
        weakSelf.SEARCH_NAMEORCONTACT=str;
            [weakSelf HTTPGetOrderList];
       
        
    }];
    self.titleView.recordBtn.hidden = YES;
//    self.navigationItem.titleView=self.titleView;
    NSArray *jpArray = [NewUserSession instance].appcode;
//    if ([jpArray containsObject:@"crm:a420:list"] && [jpArray containsObject:@"A40300_X_HOTAPP_0006"]) {
//        self.tabView = [[MJKTabView alloc]initWithFrame:CGRectMake(0, 7, 2 * 70, 30) andNameItems:@[@"订单",@"协助"]  withDefaultIndex:0  andIsSaveItem:NO andClickButtonBlock:^(NSString * _Nonnull str) {
//            if ([str isEqualToString:@"订单"]) {
//                weakSelf.tabStr = str;
//                weakSelf.assistFromStr = @"";
//                weakSelf.assistStr = @"";
//                weakSelf.sellModel.USER_ID = @"";
//                //            NSMutableArray *saleArr = [weakSelf.menuView.dataSourceArr mutableCopy];
//                //            [saleArr replaceObjectAtIndex:0 withObject:weakSelf.saleSubArray];
//                //            weakSelf.menuView.dataSourceArr = saleArr;
//                weakSelf.menuView.setNil = @"nil";
//
////                NSMutableArray *arr = [weakSelf.funnelView.allDatas mutableCopy];
////                [arr replaceObjectAtIndex:2 withObject:weakSelf.dic16];
////                weakSelf.funnelView.allDatas = arr;
//                weakSelf.IS_ASSISTANT = @"0";
//                [weakSelf.tableView.mj_header beginRefreshing];
//            } else if ([str isEqualToString:@"协助"]) {
//                weakSelf.tabStr = str;
//                weakSelf.assistFromStr = @"";
//                weakSelf.assistStr = @"";
//                weakSelf.sellModel.USER_ID = @"";
//                //            NSMutableArray *saleArr = [weakSelf.menuView.dataSourceArr mutableCopy];
//                //            [saleArr replaceObjectAtIndex:0 withObject:weakSelf.saleSubArray];
//                //            weakSelf.menuView.dataSourceArr = saleArr;
//
//                weakSelf.menuView.setNil = @"nil";
//
////                NSMutableArray *arr = [weakSelf.funnelView.allDatas mutableCopy];
////                [arr replaceObjectAtIndex:2 withObject:weakSelf.dic17];
////                weakSelf.funnelView.allDatas = arr;
//                weakSelf.IS_ASSISTANT = @"1";
//                [weakSelf.tableView.mj_header beginRefreshing];
//            }
//        }];
//        self.navigationItem.titleView=self.tabView;
//    } else if ([jpArray containsObject:@"crm:a420:list"] && ![jpArray containsObject:@"A40300_X_HOTAPP_0006"]) {
        self.navigationItem.title = @"";
        self.tabStr = @"订单";
        self.assistFromStr = @"";
        self.assistStr = @"";
        self.sellModel.USER_ID = @"";
        //            NSMutableArray *saleArr = [weakSelf.menuView.dataSourceArr mutableCopy];
        //            [saleArr replaceObjectAtIndex:0 withObject:weakSelf.saleSubArray];
        //            weakSelf.menuView.dataSourceArr = saleArr;
        self.menuView.setNil = @"nil";
        
//        NSMutableArray *arr = [weakSelf.funnelView.allDatas mutableCopy];
//        [arr replaceObjectAtIndex:2 withObject:self.dic16];
//        self.funnelView.allDatas = arr;
        self.IS_ASSISTANT = @"0";
        [self.tableView.mj_header beginRefreshing];
//    } else if (![jpArray containsObject:@"crm:a420:list"] && [jpArray containsObject:@"A40300_X_HOTAPP_0006"]) {
//        self.navigationItem.title = @"协助";
//        self.tabStr = @"协助";
//        self.assistFromStr = @"";
//        self.assistStr = @"";
//        self.sellModel.USER_ID = @"";
//        //            NSMutableArray *saleArr = [weakSelf.menuView.dataSourceArr mutableCopy];
//        //            [saleArr replaceObjectAtIndex:0 withObject:weakSelf.saleSubArray];
//        //            weakSelf.menuView.dataSourceArr = saleArr;
//
//        self.menuView.setNil = @"nil";
//
////        NSMutableArray *arr = [self.funnelView.allDatas mutableCopy];
////        [arr replaceObjectAtIndex:2 withObject:self.dic17];
////        self.funnelView.allDatas = arr;
//        self.IS_ASSISTANT = @"1";
//        [self.tableView.mj_header beginRefreshing];
//    }
    
    
    UIButton *searchButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [searchButton setImage:@"搜索按钮"];
    [searchButton addTarget:self action:@selector(searchButtonAction:)];
    //    searchButton.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 5, -40);
    UIBarButtonItem *searchItem =[[UIBarButtonItem alloc]initWithCustomView:searchButton];
    
//    if (![[NewUserSession instance].appcode containsObject:@"APP005_0002"] ) {
//        self.navigationItem.rightBarButtonItem = searchItem;
//    } else {
//        self.navigationItem.rightBarButtonItems = @[[UIBarButtonItem MyitemWithImage:@"订单" highImage:@"" target:self andAction:@selector(addNewAppointment)], searchItem];
//    }
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem MyitemWithImage:@"订单" highImage:@"" target:self andAction:@selector(addNewAppointment)];
    
    
    
    
    
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currPage=20;
		[self.allArray removeAllObjects];
        [weakSelf HTTPGetOrderList];
        
    }];
    
    self.tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.currPage += 20;
        [weakSelf HTTPGetOrderList];
        
        
    }];
    
}

//MARK:搜索
- (void)searchButtonAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected == YES) {
        [sender setImage:@"X图标"];
        self.titleView.textField.text = @"";
        self.navigationItem.titleView = self.titleView;
    } else {
        [sender setImage:@"搜索按钮"];
        self.SEARCH_NAMEORCONTACT = @"";
        [self.tableView.mj_header beginRefreshing];
        self.navigationItem.titleView = self.tabView;
    }
}


-(void)passText:(NSString *)text
{
    
    
}


-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
   
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
	//重新指派的时候没有选人直接返回需要
	if (self.isAssAgain == YES) {
		self.tabBarController.tabBar.hidden = YES;
	}
	if (self.isRefresh == NO) {
		
	} else {
		[self.allArray removeAllObjects];
        if (![[KUSERDEFAULT objectForKey:@"refresh"] isEqualToString:@"no"]) {
            [KUSERDEFAULT removeObjectForKey:@"refresh"];
            [self HTTPGetOrderList];
        }
	}
	
    self.menuView.hidden=NO;
    self.naviSearchView.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.menuView.hidden=YES;
    self.naviSearchView.hidden = YES;
    [self.navigationController.view endEditing:YES];
    
}


- (void)chooseView{
    _dropDownMenuView = [[CFDropDownMenuViewNew alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.dropDownMenuView];
    [_dropDownMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(-40);
        make.top.equalTo(@(NAVIHEIGHT));
        make.height.mas_equalTo(40);
    }];
    
    _dropDownMenuView.funnelW = 40;
    
    NSMutableArray *statusNameArray = [NSMutableArray array];
    NSMutableArray *statusCodeArray = [NSMutableArray array];
    [statusCodeArray addObject:@""];
    [statusNameArray addObject:@"全部"];
    NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A42000_C_STATUS"];
    for (MJKDataDicModel*model in dataArray) {
        [statusNameArray addObject:model.C_NAME];
        [statusCodeArray addObject:model.C_VOUCHERID];
    }
    DBSelf(weakSelf);
    
    NSArray * createIdTimeArr=@[@"", @"1", @"2", @"3", @"4", @"5", @"6", @"9", @"10", @"7",@"30",@"999"];
    NSArray * createNameTimeArr=@[@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"今年",@"去年",@"最近7天",@"最近30天",@"自定义"];
    
    NSMutableArray*saleCodeArray=[NSMutableArray array];
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/user/list",HTTP_IP] parameters:@{@"C_LOCCODE" : [NewUserSession instance].user.C_LOCCODE} compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
            MyLog(@"");
            NSArray *dataArray = [EmployeesSubModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            NSMutableArray*saleNameArray=[NSMutableArray array];
            
            [saleNameArray addObject:@"全部"];
            [saleCodeArray addObject:@""];
            for (EmployeesSubModel*model in dataArray) {
                [saleNameArray addObject:model.nickName];
                [saleCodeArray addObject:model.u051Id];
            }
            weakSelf.dropDownMenuView.dataSourceArr[0] = saleNameArray;
            
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
    // 注:  需先 赋值数据源dataSourceArr二维数组  再赋值defaulTitleArray一维数组
    
    // 注:  需先 赋值数据源dataSourceArr二维数组  再赋值defaulTitleArray一维数组
    _dropDownMenuView.dataSourceArr = @[
                                        @[],
                                        @[],
                                        statusNameArray,
                                        createNameTimeArr
                                        ].mutableCopy;
    
    _dropDownMenuView.defaulTitleArray = [NSArray arrayWithObjects:@"销售",@"车型",@"状态", @"创建时间", nil];
    
    
    // 下拉列表 起始y
    _dropDownMenuView.startY = NAVIHEIGHT + 40;
    
    /**
     *  回调方式一: block
     */
    @weakify(self);
    _dropDownMenuView.chooseProductConditionBlock = ^(NSString *code) {
        @strongify(self);
        NSArray *arr = [code componentsSeparatedByString:@","];
        self.saveTableDataDic[@"C_A70600_C_ID"] = arr[0];
        self.saveTableDataDic[@"C_A49600_C_ID"] = arr[1];
        [self.tableView.mj_header beginRefreshing];
    };
    
    _dropDownMenuView.chooseConditionNewBlock = ^(NSInteger titleIndex, NSInteger selectIndex , NSString *currentTitle, NSArray *currentTitleArray){
        @strongify(self);
        if ([currentTitle isEqualToString:@"自定义"]) {
           if (titleIndex == 3) {
                CustomTimeView *timeView = [CustomTimeView new];
                [[UIApplication sharedApplication].windows[0] addSubview:timeView];
                [timeView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.top.bottom.mas_equalTo(0);
                }];
                
                timeView.chooseTimeBlock = ^(NSString * _Nonnull startTime, NSString * _Nonnull endTime) {
                    MyLog(@"startTime --- %@, endTime --- %@",  startTime, endTime);
                    self.saveTableDataDic[@"ORDER_START_TIME"] = startTime;
                    self.saveTableDataDic[@"ORDER_END_TIME"] = endTime;
                    [self.saveTableDataDic removeObjectForKey:@"ORDER_TIME_TYPE"];
                    [self.tableView.mj_header beginRefreshing];
                };
            }
        } else {
            if (titleIndex == 0) {
                self.saveTableDataDic[@"C_OWNER_ROLEID"] = saleCodeArray[selectIndex];
            } else if (titleIndex == 1) {
                
            } else if (titleIndex == 2) {
                self.saveTableDataDic[@"C_STATUS_DD_ID"] = statusCodeArray[selectIndex];
            } else if (titleIndex == 3) {
                self.saveTableDataDic[@"ORDER_TIME_TYPE"] = createIdTimeArr[selectIndex];
                [self.saveTableDataDic removeObjectForKey:@"ORDER_START_TIME"];
                [self.saveTableDataDic removeObjectForKey:@"ORDER_END_TIME"];
            }
            
            [self.tableView.mj_header beginRefreshing];
        }
        
    };
    
    
    CGFloat strWith=[self.totalStr boundingRectWithSize:CGSizeMake(999, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.width;
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(KScreenWidth-1-strWith, NavStatusHeight + 40, strWith, 20);
    btn.titleLabel.textAlignment=NSTextAlignmentRight;
    [btn setBgImage:@"all_bg"];
//    [btn setTitleNormal:self.totalStr];
    btn.titleLabel.font=[UIFont systemFontOfSize:12];
    [btn setTitleColor:[UIColor lightGrayColor]];
    [self.view addSubview:btn];
    self.totalBtn=btn;
    
    UILabel *label = [[UILabel alloc]initWithFrame:btn.frame];
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:12];
    label.text = self.totalStr;
    label.textAlignment= NSTextAlignmentCenter;
    [self.view addSubview:label];
    self.totalLabel = label;
    
    
    
    
    
    
    //这个是筛选的view
    FunnelShowView*funnelView=[FunnelShowView funnelShowView];
    self.funnelView = funnelView;
    funnelView.rootVC = self;
    
    NSString*sortStr=@"订单列表排序";
    NSMutableArray*sortArr=[NSMutableArray array];
    for (int i = 0; i < 2; i++) {
        MJKFunnelChooseModel*sortFunnelModel=[[MJKFunnelChooseModel alloc]init];
        sortFunnelModel.name=@[@"活跃时间", @"创建时间"][i];
        sortFunnelModel.c_id=@[@"A47500_C_DDPX_0000", @"A47500_C_DDPX_0001"][i];
        [sortArr addObject:sortFunnelModel];
    }
    
    
    
    NSString*Str20=@"业务 3";
    NSMutableArray*mtArr20=[NSMutableArray array];
    MJKFunnelChooseModel*funnelModel20=[[MJKFunnelChooseModel alloc]init];
    funnelModel20.name=@"全部";
    funnelModel20.c_id=@"";
    [mtArr20 addObject:funnelModel20];
    //            NSArray*array17=@[@"全部",@"今天",@"最近7天",@"最近30天",@"本周",@"本月",@"自定义"];
    //            NSArray*arraySel16=@[@"",@"1",@"7",@"30",@"2",@"3",@"999"];
//    for (MJKClueListSubModel *model in self.saleDatasModel.content) {
//        MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
//        funnelModel.name=model.user_name;
//        funnelModel.c_id=model.user_id;
//        [mtArr20 addObject:funnelModel];
//    }
    
    
    
    NSArray * titleArr=@[@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"今年",@"去年",@"最近7天",@"最近30天",@"自定义"];
    NSArray * idArr=@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"9",@"10",@"7",@"30",@"999"];
    NSMutableArray * contentArr=[NSMutableArray array];
    for (int i=0;i<titleArr.count;i++) {
        
        MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
        model.name=titleArr[i];
        model.c_id=idArr[i];
        [contentArr addObject:model];
        
    }
    NSMutableArray * contentArr1=[NSMutableArray array];
    for (int i=0;i<titleArr.count;i++) {
        
        MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
        model.name=titleArr[i];
        model.c_id=idArr[i];
        [contentArr1 addObject:model];
        
    }
    NSMutableArray * contentArr2=[NSMutableArray array];
    for (int i=0;i<titleArr.count;i++) {
        
        MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
        model.name=titleArr[i];
        model.c_id=idArr[i];
        [contentArr2 addObject:model];
        
    }
    NSMutableArray * contentArr3=[NSMutableArray array];
    for (int i=0;i<titleArr.count;i++) {
        
        MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
        model.name=titleArr[i];
        model.c_id=idArr[i];
        [contentArr3 addObject:model];
        
    }
    NSMutableArray * contentArr4=[NSMutableArray array];
    for (int i=0;i<titleArr.count;i++) {
        
        MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
        model.name=titleArr[i];
        model.c_id=idArr[i];
        [contentArr4 addObject:model];
        
    }
    NSMutableArray * contentArr5=[NSMutableArray array];
    for (int i=0;i<titleArr.count;i++) {
        
        MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
        model.name=titleArr[i];
        model.c_id=idArr[i];
        [contentArr5 addObject:model];
        
    }
    NSMutableArray * contentArr6=[NSMutableArray array];
    for (int i=0;i<titleArr.count;i++) {
        
        MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
        model.name=titleArr[i];
        model.c_id=idArr[i];
        [contentArr6 addObject:model];
        
    }
    NSMutableArray * contentArr7=[NSMutableArray array];
    for (int i=0;i<titleArr.count;i++) {
        
        MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
        model.name=titleArr[i];
        model.c_id=idArr[i];
        [contentArr7 addObject:model];
        
    }
    NSMutableArray * contentArr8=[NSMutableArray array];
    for (int i=0;i<titleArr.count;i++) {
        
        MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
        model.name=titleArr[i];
        model.c_id=idArr[i];
        [contentArr8 addObject:model];
        
    }
    NSMutableArray * contentArr20=[NSMutableArray array];
    for (int i=0;i<titleArr.count;i++) {
        
        MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
        model.name=titleArr[i];
        model.c_id=idArr[i];
        [contentArr20 addObject:model];
        
    }
    NSMutableArray * contentArr9=[NSMutableArray array];
    for (int i=0;i<titleArr.count;i++) {
        
        MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
        model.name=titleArr[i];
        model.c_id=idArr[i];
        [contentArr9 addObject:model];
        
    }
    NSMutableArray * contentArr10=[NSMutableArray array];
    for (int i=0;i<titleArr.count;i++) {
        
        MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
        model.name=titleArr[i];
        model.c_id=idArr[i];
        [contentArr10 addObject:model];
        
    }
    NSMutableArray * contentArr11=[NSMutableArray array];
    for (int i=0;i<titleArr.count;i++) {
        
        MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
        model.name=titleArr[i];
        model.c_id=idArr[i];
        [contentArr11 addObject:model];
        
    }
    
    NSMutableArray * contentArr111=[NSMutableArray array];
    for (int i=0;i<titleArr.count;i++) {
        
        MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
        model.name=titleArr[i];
        model.c_id=idArr[i];
        [contentArr111 addObject:model];
        
    }
    NSMutableArray * contentArr12=[NSMutableArray array];
    for (int i=0;i<titleArr.count;i++) {
        
        MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
        model.name=titleArr[i];
        model.c_id=idArr[i];
        [contentArr12 addObject:model];
        
    }
    NSMutableArray * contentArr13=[NSMutableArray array];
    for (int i=0;i<titleArr.count;i++) {
        
        MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
        model.name=titleArr[i];
        model.c_id=idArr[i];
        [contentArr13 addObject:model];
        
    }
    NSMutableArray * contentArr14=[NSMutableArray array];
    for (int i=0;i<titleArr.count;i++) {
        
        MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
        model.name=titleArr[i];
        model.c_id=idArr[i];
        [contentArr14 addObject:model];
        
    }
    NSMutableArray * contentArr15=[NSMutableArray array];
    for (int i=0;i<titleArr.count;i++) {
        
        MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
        model.name=titleArr[i];
        model.c_id=idArr[i];
        [contentArr15 addObject:model];
        
    }
    NSMutableArray * contentArr16=[NSMutableArray array];
    for (int i=0;i<titleArr.count;i++) {
        
        MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
        model.name=titleArr[i];
        model.c_id=idArr[i];
        [contentArr16 addObject:model];
        
    }
    NSMutableArray * contentArr17=[NSMutableArray array];
    for (int i=0;i<titleArr.count;i++) {
        
        MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
        model.name=titleArr[i];
        model.c_id=idArr[i];
        [contentArr17 addObject:model];
        
    }
    NSMutableArray * contentArr18=[NSMutableArray array];
    for (int i=0;i<titleArr.count;i++) {
        
        MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
        model.name=titleArr[i];
        model.c_id=idArr[i];
        [contentArr18 addObject:model];
        
    }
    NSMutableArray * contentArr19=[NSMutableArray array];
    for (int i=0;i<titleArr.count;i++) {
        
        MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
        model.name=titleArr[i];
        model.c_id=idArr[i];
        [contentArr19 addObject:model];
        
    }
    
    NSDictionary*dic=@{@"title":@"客户姓名",@"content":@[]};
    NSDictionary*dic1=@{@"title":@"手机号",@"content":@[]};
    NSDictionary*dic2=@{@"title":@"车架号全号",@"content":@[]};
    NSDictionary*dic3=@{@"title":@"发动机号",@"content":@[]};
    
    
    NSDictionary*dic4=@{@"title":@"合同交车日期",@"content":contentArr};
    
    
    NSDictionary*dic5=@{@"title":@"全款时间",@"content":contentArr1};
    
    NSDictionary*dic6=@{@"title":@"出库时间",@"content":contentArr2};
    NSDictionary*dic7=@{@"title":@"开票名称",@"content":@[]};
    
    NSMutableArray *hyCodeArr = [NSMutableArray  array];
    MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
    model.name=@"全部";
    model.c_id=@"";
    [hyCodeArr addObject:model];
    
    for (MJKDataDicModel *modeli in[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41500_C_INDUSTRY"] ) {
        MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
        model.name=modeli.C_NAME;
        model.c_id=modeli.C_VOUCHERID;
        [hyCodeArr addObject:model];
    }
    NSDictionary*dic8=@{@"title":@"行业",@"content":hyCodeArr};
    
    NSMutableArray *djztCodeArr = [NSMutableArray  array];
    MJKFunnelChooseModel*djztmodel=[[MJKFunnelChooseModel alloc]init];
    djztmodel.name=@"全部";
    djztmodel.c_id=@"";
    [djztCodeArr addObject:djztmodel];
    
    for (MJKDataDicModel *modeli in[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A42000_C_DJTYPE"] ) {
        MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
        model.name=modeli.C_NAME;
        model.c_id=modeli.C_VOUCHERID;
        [djztCodeArr addObject:model];
    }
    NSDictionary*dicdjzt=@{@"title":@"定金状态",@"content":djztCodeArr};
    
    NSDictionary*dic9=@{@"title":@"审批状态",@"content":@[]};
    
    
    NSMutableArray*mydztDataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A81300_C_STATUS"];
    NSMutableArray*mydztArray=[NSMutableArray array];
    MJKFunnelChooseModel*funnelModelmydzt=[[MJKFunnelChooseModel alloc]init];
    funnelModelmydzt.name=@"全部";
    funnelModelmydzt.c_id=@"";
    [mydztArray addObject:funnelModelmydzt];
    for (MJKDataDicModel*model in mydztDataArray) {
        MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
        funnelModel.name=model.C_NAME;
        funnelModel.c_id=model.C_VOUCHERID;
        [mydztArray addObject:funnelModel];
    }
    
    NSDictionary *mydztDic = @{@"title" : @"满意度状态", @"content" : mydztArray};
    
    NSMutableArray*mydhfjgDataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A81300_C_HFJG"];
    NSMutableArray*mydhfjgArray=[NSMutableArray array];
    MJKFunnelChooseModel*funnelModelmydhfjg=[[MJKFunnelChooseModel alloc]init];
    funnelModelmydhfjg.name=@"全部";
    funnelModelmydhfjg.c_id=@"";
    [mydhfjgArray addObject:funnelModelmydhfjg];
    for (MJKDataDicModel*model in mydhfjgDataArray) {
        MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
        funnelModel.name=model.C_NAME;
        funnelModel.c_id=model.C_VOUCHERID;
        [mydhfjgArray addObject:funnelModel];
    }
    
    NSDictionary *mydhfjgtDic = @{@"title" : @"满意度回访结果", @"content" : mydhfjgArray};
    
            NSDictionary*sortDic=@{@"title":sortStr,@"content":sortArr};
            
            
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
            
            
            
            
            [weakSelf getActionOfMarketComplication:^(NSArray<MJKFunnelChooseModel *> *actionMarketArray) {
                
                
                
                //市场活动
                NSString*actionMarketStr=@"渠道细分";
                NSDictionary*actionMarketDic=@{@"title":actionMarketStr,@"content":actionMarketArray};
                
                
                
                //            if ([weakSelf.tabStr isEqualToString:@"订单"]) {
                funnelView.allDatas =  (NSMutableArray *)@[sortDic,dic,dic1,dic2,dic3,dic4,customerSourceDic,actionMarketDic,dic5,dic6,dic7,dic8,dicdjzt,dic9,mydztDic, mydhfjgtDic];
                //            } else {
                //                funnelView.allDatas =  (NSMutableArray *)@[dic20, dic21,dic17, dic,finshTimeDic];
                //            }
            }];
//    }];
    
	
    funnelView.jieshaorenAndLastTimeBlock = ^(NSString *jieshaoren, NSString *arriveTimes) {
        if ([jieshaoren isEqualToString:@"phone"]) {
            self.saveTimeDataDic[@"SEARCH_NAMEORCONTACT"] = arriveTimes;
       } else if ([jieshaoren isEqualToString:@"vinall"]) {
           self.saveTimeDataDic[@"C_VIN"] = arriveTimes;
       } else if ([jieshaoren isEqualToString:@"name"]) {
           self.saveTimeDataDic[@"SEARCH_NAMEORCONTACT"] = arriveTimes;
       } else if ([jieshaoren isEqualToString:@"fdj"]) {
           self.saveTimeDataDic[@"C_GDSPR"] = arriveTimes;
       } else if ([jieshaoren isEqualToString:@"kpmc"]) {
           self.saveTimeDataDic[@"C_BILLING"] = arriveTimes;
       } else if ([jieshaoren isEqualToString:@"spzt"]) {
           self.saveTimeDataDic[@"approvalStatus"] = arriveTimes;
       }

    };
    //介绍人1、协助人2、业务3、设计师4、项目经理5、下单员6、送货人7、安装技师9、验收人10、是否有退单意图12、是否过单13、是否免测14、是否全款15、首次沟通时间16、VIP建群时间17、初量时间18、计划出图时间19、实际出图时间20、计划确图时间21、实际确图时间22、方案时间23、签约时间24、合同归档时间25、复尺时间26、预计下单时间27、过单时间29、到货时间30、送货时间31、计划安装时间32、实际安装时间33、订单下次跟进时间36、
    //回调
    funnelView.sureBlock = ^(NSMutableArray *array) {
		[weakSelf.allArray removeAllObjects];
        NSString *keyValue = @"";
		for (NSDictionary*dict in array) {
			NSString*indexStr=dict[@"index"];
			MJKFunnelChooseModel*model=dict[@"model"];
            if ([indexStr isEqualToString:@"0"]) {
                keyValue = @"C_SORTIDXTYPE";
            }
            else if ([indexStr isEqualToString:@"5"]) {//下单时间
                NSString * name = [[array firstObject][@"model"] name];
                if ([name isEqualToString:@"自定义"]) {
                    
                }else{
                    [weakSelf.saveTimeDataDic removeObjectForKey:@"START_START_TIME"];
                    [weakSelf.saveTimeDataDic removeObjectForKey:@"START_END_TIME"];
                    keyValue  = @"START_TIME_TYPE";
                    
                }
            }  else if ([indexStr isEqualToString:@"6"]) {//来源渠道
                    keyValue  = @"C_CLUESOURCE_DD_ID";
                
            } else if ([indexStr isEqualToString:@"7"]) {//渠道细分
                    keyValue  = @"C_A41200_C_ID";
                    
                
            } else if ([indexStr isEqualToString:@"8"]) {//下单时间
                NSString * name = [[array firstObject][@"model"] name];
                if ([name isEqualToString:@"自定义"]) {
                    
                }else{
                    [weakSelf.saveTimeDataDic removeObjectForKey:@"SEND_START_TIME"];
                    [weakSelf.saveTimeDataDic removeObjectForKey:@"SEND_END_TIME"];
                    keyValue  = @"SEND_TIME_TYPE";
                    
                }
            }  else if ([indexStr isEqualToString:@"9"]) {//下单时间
                NSString * name = [[array firstObject][@"model"] name];
                if ([name isEqualToString:@"自定义"]) {
                    
                }else{
                    [weakSelf.saveTimeDataDic removeObjectForKey:@"SHSJ_START_TIME"];
                    [weakSelf.saveTimeDataDic removeObjectForKey:@"SHSJ_END_TIME"];
                    keyValue  = @"SHSJ_TIME_TYPE";
                    
                }
            }else if ([indexStr isEqualToString:@"11"]) {//渠道细分
                keyValue  = @"C_INDUSTRY_DD_ID";
                
            
            }else if ([indexStr isEqualToString:@"12"]) {//渠道细分
                keyValue  = @"C_XDSPR";
                
            
            }else if ([indexStr isEqualToString:@"14"]) {//渠道细分
                keyValue  = @"C_A812STATUS_DD_ID";
                
            
            }else if ([indexStr isEqualToString:@"15"]) {//渠道细分
                keyValue  = @"C_A812HFJG_DD_ID";
                
            
            }
            
            [self.saveTableDataDic setObject:model.c_id forKey:keyValue];
		}
		
		
//        [self HTTPGetOrderList];
		[self.tableView.mj_header beginRefreshing];
		
    };
    [[UIApplication sharedApplication].keyWindow addSubview:funnelView];
    
	funnelView.resetBlock = ^{
		self.currPage=20;
        self.sellModel.START_CREATE_TIME=@"";
        self.sellModel.END_CREATE_TIME=@"";
        self.sellModel.LASTFOLLOW_TIME_TYPE=@"";
        self.assistStr = @"";
        self.assistFromStr = @"";
        self.sellModel.C_A47700_C_ID = @"";
        self.sellModel.C_CLUEPROVIDER_ROLEID = @"";
        [weakSelf.saveTableDataDic removeAllObjects];
        [weakSelf.saveTimeDataDic removeAllObjects];
        [weakSelf.tableView.mj_header beginRefreshing];
	};
    
    //这个是漏斗按钮
    CFRightButton*funnelButton=[[CFRightButton alloc]initWithFrame:CGRectMake( KScreenWidth-40,NavStatusHeight, 40, 40)];
    
    [self.view addSubview:funnelButton];
    funnelButton.clickFunnelBlock = ^(BOOL isSelected) {
        [weakSelf.dropDownMenuView hide];
        //显示 左边的view
        [funnelView show];
        
    };
    
    
    funnelView.viewCustomTimeBlock = ^(NSInteger selectedSession){
        MyLog(@"自定义时间");
        
        CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
            
        } withEnd:^{
            
        } withSure:^(NSString *start, NSString *end) {
            self.currPage=20;
            
			if (selectedSession == 5) {
                [weakSelf.saveTableDataDic removeObjectForKey:@"START_TIME_TYPE"];
                [weakSelf.saveTimeDataDic setObject:start forKey:@"START_START_TIME"];
                [weakSelf.saveTimeDataDic setObject:end forKey:@"START_END_TIME"];
			} else if (selectedSession == 8) {
                [weakSelf.saveTableDataDic removeObjectForKey:@"SEND_TIME_TYPE"];
                [weakSelf.saveTimeDataDic setObject:start forKey:@"SEND_START_TIME"];
                [weakSelf.saveTimeDataDic setObject:end forKey:@"SEND_END_TIME"];
            } else if (selectedSession == 9) {
                [weakSelf.saveTableDataDic removeObjectForKey:@"SHSJ_TIME_TYPE"];
                [weakSelf.saveTimeDataDic setObject:start forKey:@"SHSJ_START_TIME"];
                [weakSelf.saveTimeDataDic setObject:end forKey:@"SHSJ_END_TIME"];
            }
            
            
            
			
//            [self HTTPGetOrderList];
			
        }];
        [[UIApplication sharedApplication].keyWindow addSubview:dateView];
        
    };

    
}



#pragma mark -- createData


#pragma mark -- tableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    CGCOrderModel * model=self.dataArray[section];
    return model.content.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGCOrderDetailModel *model=[self.dataArray[indexPath.section] content][indexPath.row];
    CGCAppointmentCell * cell=[CGCAppointmentCell cellWithTableView:tableView];
	if (self.isAssAgain == YES) {
		cell.imageLeftLayout.constant = 60;
		cell.selectBtn.hidden = NO;
		if (self.isAllSelected == YES) {
			model.selected = YES;
		}
	} else {
		cell.imageLeftLayout.constant = 15;
		cell.selectBtn.hidden = YES;
	}
	
	
	cell.model = model;
    [cell reloadOrderCellWithModel:model];
    
    
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    CGCOrderModel *model = self.dataArray[section];
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    view.backgroundColor=DBColor(247, 247, 247);
    
    UILabel * lab=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 30)];
    lab.text=model.total;
    lab.textColor=DBColor(153, 153, 153);
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
 
//     CGCOrderDetailModel *model=[self.dataArray[indexPath.section] content][indexPath.row];
//	if ([model.C_STATUS_DD_NAME isEqualToString:@"已下单"] || [model.C_STATUS_DD_NAME isEqualToString:@"已收款"] || [model.C_STATUS_DD_NAME isEqualToString:@"订金"] || [model.C_STATUS_DD_NAME isEqualToString:@"已完成"] || [model.C_STATUS_DD_NAME isEqualToString:@"待安装"]) {
//
//          return YES;
//    }
//
//    return NO;
    if ([self.carChoose isEqualToString:@"是"]) {
        return NO;
    } else {
        return YES;
    }
}


- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
   CGCOrderDetailModel *model=[self.dataArray[indexPath.section] content][indexPath.row];
    NSInteger index=indexPath.section*100+indexPath.row;
    self.detailModel = model;
    
    UITableViewRowAction *tel = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                   title:@"电话"
                                                                 handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                     if (![[NewUserSession instance].appcode containsObject:@"APP005_0029"]) {
                                                                         [JRToast showWithText:@"账号无权限"];
                                                                         return;
                                                                     }
                                                                     [self selectTelephone:index];
                                                                 }];
    tel.backgroundColor=DBColor(255,195,0);
    
    
    UITableViewRowAction *message = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                    title:@"短信"
                                                                  handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                      if (![[NewUserSession instance].appcode containsObject:@"APP005_0030"]) {
                                                                          [JRToast showWithText:@"账号无权限"];
                                                                          return;
                                                                      }
                                                                      [self messageClick:model];

                                                                  }];
    

    
    UITableViewRowAction *more = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"更多" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
		
         [self moreAction:indexPath];
     }];
    more.backgroundColor=DBColor(50,151,234);
	
	UITableViewRowAction *assAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"重新指派" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
		if (![[NewUserSession instance].appcode containsObject:@"crm:a420:zp"]) {
			[JRToast showWithText:@"账号无权限"];
			return ;
		}
		CGCOrderDetailModel *model=[self.dataArray[indexPath.section] content][indexPath.row];
		DBSelf(weakSelf);
		weakSelf.isAssAgain = YES;
		
		weakSelf.tabBarController.tabBar.hidden = YES;
		model.selected = YES;
		[weakSelf.tableView reloadData];
		self.bottomChooseView=[DBAssignBottomChooseView AssignBottomChooseViewAndcancel:^{
			weakSelf.isAllSelected = NO;
			weakSelf.isRefresh = YES;
			//所有数据  选中状态都设为no   刷新
			for (CGCOrderModel*model in self.dataArray) {
				for (CGCOrderDetailModel*detailModel in model.content) {
					detailModel.selected=NO;
				}
			}
			weakSelf.isAssAgain=NO;
			
			weakSelf.tabBarController.tabBar.hidden = NO;
//			weakSelf.tableView.frame = CGRectMake(weakSelf.tableView.frame.origin.x, weakSelf.tableView.frame.origin.y, weakSelf.tableView.frame.size.width, weakSelf.tableView.frame.size.height + 40);
			[weakSelf.tableView reloadData];
			[weakSelf.bottomChooseView removeFromSuperview];
			
		} allChoose:^{
			weakSelf.isAllSelected = YES;
			//所有数据 选中状态 都设为yes   刷新
			for (CGCOrderModel*model in self.dataArray) {
				for (CGCOrderDetailModel*detailModel in model.content) {
					//						if ([detailModel.C_STATUS_DD_NAME isEqualToString:@"已完成"] || [detailModel.C_STATUS_DD_NAME isEqualToString:@"退单"]) {
					//							detailModel.selected = NO;
					//						} else {
					detailModel.selected=YES;
					//						}
					
				}
			}
			
			[weakSelf.tableView reloadData];
			
			
			
		} sure:^{
			weakSelf.isRefresh = NO;
			//获取到所有的选中   然后 跳转
			NSMutableArray*saveAllChooseArray=[NSMutableArray array];
			//				self.saveAllSelectedAssignModelArray=saveAllChooseArray;
			for (CGCOrderModel*model in weakSelf.dataArray) {
				for (CGCOrderDetailModel*detailModel in model.content) {
					if (detailModel.isSelected) {
						[saveAllChooseArray addObject:detailModel];
					}
					
				}
				
			}
			
			MyLog(@"saveAllChooseArray===%@",saveAllChooseArray);
			if (saveAllChooseArray.count<1) {
				[JRToast showWithText:@"至少选择一条重新分配"];
				return;
			}
			
			
			NSMutableArray*strArray=[NSMutableArray array];
			for (CGCOrderDetailModel*detailModel in saveAllChooseArray) {
				[strArray addObject:detailModel.C_ID];
			}
			NSString*customerIDS=[strArray componentsJoinedByString:@","];
			
			//跳转  到下一个界面  选择好  销售之后  回调  来用  saveAllChooseArray 的东西和销售吊接口  完成之后 在移除这个view
            MJKChooseEmployeesViewController *vc = [[MJKChooseEmployeesViewController alloc]init];
            if ([[NewUserSession instance].appcode containsObject:@"crm:a420:kdzp"]) {
                vc.isAllEmployees = @"是";
            }
            vc.noticeStr = @"无提示";
            vc.chooseEmployeesBlock = ^(MJKClueListSubModel * _Nonnull model) {
				weakSelf.isRefresh = YES;
				[weakSelf.bottomChooseView removeFromSuperview];
				weakSelf.bottomChooseView=nil;
				weakSelf.isAssAgain=NO;
				
				weakSelf.tabBarController.tabBar.hidden = NO;
				[weakSelf HTTPUpdataAssWithID:customerIDS andUserID:model.user_id];
				
				
				//这里需要调用接口    重新分配的接口
				[weakSelf.tableView.mj_header beginRefreshing];
			};
			
			
			
			
			[weakSelf.navigationController pushViewController:vc animated:YES];
			
			
		}];
		self.bottomChooseView.frame=CGRectMake(0, KScreenHeight-40, KScreenWidth, 40);
//		self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height - 40);
		[self.view addSubview:self.bottomChooseView];
		
	}];
	assAction.backgroundColor=DBColor(50,151,234);
	
    NSArray *arr = nil;
    //C_STATUS_DD_ID
    if([model.C_STATUS_DD_ID isEqualToString:@"A42000_C_STATUS_0003"]){
        arr=@[assAction];
        return arr;
        
    }else{
        arr=@[more,tel];
        return arr;
    }
    
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 84;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CGCOrderDetailModel *model=[self.dataArray[indexPath.section] content][indexPath.row];
    if ([self.carChoose isEqualToString:@"是"]) {
        if (self.chooseOrderBlock) {
            self.chooseOrderBlock(model.C_ID);
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if (self.isAssAgain == YES) {
            return;
        }
        if (![[NewUserSession instance].appcode containsObject:@"crm:a420:info"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        OrderDetailViewController * order=[[OrderDetailViewController alloc] init];
        [[NSUserDefaults standardUserDefaults]setObject:@"order" forKey:@"VCName"];
        
        if ([model.C_STATUS_DD_ID isEqualToString:@"A42000_C_STATUS_0005"]) {//报价
            order.URL=model.C_OFFERPIC;
            
        }else{
            order.URL=model.C_ORDERPIC;
        }
        
        order.isEdit=model.C_STATUS_DD_ID;
        order.statusType = model.C_STATUS_DD_NAME;
        order.orderId=model.C_ID;
        
        DBSelf(weakSelf);
        order.reloadBlock=^(){
            
            self.currPage=20;
            //        [weakSelf HTTPGetOrderList];
            [weakSelf.tableView.mj_header beginRefreshing];
        };
        
        
        [self.navigationController pushViewController:order animated:YES];
    }
    
}

#pragma mark -- touch


- (void)addNewAppointment{//导航右边新增预约点击
    
    if (![[NewUserSession instance].appcode containsObject:@"crm:a420:add"]) {
        [JRToast showWithText:@"账号无权限"];
        return;
    }
    
    MJKCustomerChooseViewController *vc = [MJKCustomerChooseViewController new];
    vc.rootVC = self;
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark --- 更多操作弹窗事件
- (void)moreAction:(NSIndexPath *)index{

   
    CGCOrderDetailModel *model=[self.dataArray[index.section] content][index.row];
    
			[self getViewWithArrTitle:@[ @"下单关注", @"短信",@"微信",@"转会员"] withpicArr:@[[model.C_STAR_DD_ID isEqualToString:@"A42000_C_STAR_0000"] ? @"星标客户" : @"未星标客户",@"icon-短信",@"icon-微信",@"转会员"] WithIndex:index];


}

- (void)getViewWithArrTitle:(NSArray *)titArr withpicArr:(NSArray *)picArr WithIndex:(NSIndexPath *)indexPath{

    CGCOrderDetailModel *model=[self.dataArray[indexPath.section] content][indexPath.row];
	DBSelf(weakSelf);
    CGCMoreCollection * more=[[CGCMoreCollection alloc] initWithFrame:self.view.bounds withPicArr:picArr withTitleArr:titArr withTitle:@"更多操作" withSelectIndex:^(NSInteger index, NSString *title) {
		
		
        if ([title isEqualToString:@"短信"]) {
            if (![[NewUserSession instance].appcode containsObject:@"APP005_0030"]) {
                [JRToast showWithText:@"账号无权限"];
                return;
            }
            [weakSelf messageClick:model];
           
        }
        if ([title isEqualToString:@"微信"]) {
            if (![[NewUserSession instance].appcode containsObject:@"APP005_0031"]) {
                [JRToast showWithText:@"账号无权限"];
                return;
            }
            [weakSelf shareWeiXin:model];
            
        }
       
		
		if ([title isEqualToString:@"下单关注"]) {
			NSString *codeStr;
			if ([model.C_STAR_DD_ID isEqualToString:@"A42000_C_STAR_0000"]) {
				codeStr = @"A42000_C_STAR_0001";
			} else {
				codeStr = @"A42000_C_STAR_0000";
			}
			[weakSelf uploadOrderStar:model andStarCode:codeStr];
			
		}
        
        if ([title isEqualToString:@"转会员"]) {
            if (![[NewUserSession instance].appcode containsObject:@"APP005_0024"]) {
                [JRToast showWithText:@"账号无权限"];
                return;
            }
            SingleIntegarModel *memberModel = [[SingleIntegarModel alloc]init];
            memberModel.name = model.C_A41500_C_NAME;
            memberModel.tel = model.C_PHONE;
            memberModel.sex = model.C_SEX_DD_NAME;
            memberModel.sexID = model.C_SEX_DD_ID;
            memberModel.adress = model.C_ADDRESS;
            memberModel.leixing = @"会员";
            memberModel.lxID = @"A47700_C_TYPE_0006";
            memberModel.C_FSLX_DD_ID = @"A47700_C_FSLX_0001";
            
            CGCAddBrokerVC *vc = [[CGCAddBrokerVC alloc]init];
            vc.type = CGCAddBrokerAdd;
            vc.model = memberModel;
            vc.portraitAddress = model.C_HEADIMGURL;
            vc.C_A41500_C_IDStr = model.C_A41500_C_ID;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    
       
    } ];
    
   
    
    [self.view addSubview:more];


}

//发给客户预览
- (void)sendCustomPreView:(CGCOrderDetailModel *)model{

    UIImage *image=[self handleImageWithURLStr:model.C_ORDERPIC];
    
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:image];
    WXImageObject *webObj = [WXImageObject object];
    webObj.imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:model.C_ORDERPIC]];
    message.mediaObject = webObj;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.scene = _scene;
    req.bText = NO;
    req.message = message;
    [WXApi sendReq:req completion:nil];
}

//微信
- (void)shareWeiXin:(CGCOrderDetailModel *)model{
  
    
    CGCTemplateVC * cvc=[[CGCTemplateVC alloc] init];
    cvc.templateType=CGCTemplateWeiXin;
    cvc.titStr=model.C_BUYNAME;
    cvc.customIDArr=[NSMutableArray arrayWithArray:@[model.C_ID]];
    cvc.customPhoneArr=[NSMutableArray arrayWithArray:@[model.C_PHONE]];
    
    [self.navigationController pushViewController:cvc animated:YES];
    
    
    
    

}










//短信
- (void)messageClick:(CGCOrderDetailModel *)model{

   
    CGCTemplateVC * cvc=[[CGCTemplateVC alloc] init];
    cvc.titStr=model.C_BUYNAME;
    cvc.templateType=CGCTemplateMessage;
    cvc.customIDArr=[NSMutableArray arrayWithArray:@[model.C_ID]];
    cvc.customPhoneArr=[NSMutableArray arrayWithArray:@[model.C_PHONE]];
   
    [self.navigationController pushViewController:cvc animated:YES];

}


//电话
- (void)telephoneCall:(NSInteger)index{
//    if (![[NewUserSession instance].appcode containsObject:@"APP005_0029"]) {
//        [JRToast showWithText:@"账号无权限"];
//        return;
//    }
    CGCOrderDetailModel *model= [self getSingleModel:index withMess:@"号码不存在"];
    
    if (model.C_PHONE.length > 0) {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:model.C_PHONE]]];
    } else {
       [JRToast showWithText:@"无电话号码"];
   }
}

- (void)whbcallBack:(NSInteger)index {
//    if (![[NewUserSession instance].appcode containsObject:@"APP005_0029"]) {
//        [JRToast showWithText:@"账号无权限"];
//        return;
//    }
    CGCOrderDetailModel *model= [self getSingleModel:index withMess:@"号码不存在"];
    if (model.C_PHONE.length > 0) {
    [DBObjectTools whbCallWithC_OBJECT_ID:model.C_ID andC_CALL_PHONE:model.C_PHONE andC_NAME:model.C_BUYNAME andC_OBJECTTYPE_DD_ID:@"A83100_C_OBJECTTYPE_0007" andCompleteBlock:nil];
    } else {
       [JRToast showWithText:@"无电话号码"];
   }
}

- (void)closePhone {
    [self alertViewFollow];
}

- (void)alertViewFollow {
    DBSelf(weakSelf);
    UIAlertController *alertV = [UIAlertController alertControllerWithTitle:@"是否新增跟进" message:nil  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *trueAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        MJKOrderFllowViewController *vc = [[MJKOrderFllowViewController alloc]init];
        vc.canEdit = YES;
        vc.detailModel = self.detailModel;
        vc.followText = nil;
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    }];
    [alertV addAction:cancelAction];
    [alertV addAction:trueAction];
    
    [self presentViewController:alertV animated:YES completion:nil];
}
//座机
- (void)landLineCall:(NSInteger)index{
    
    CGCOrderDetailModel *model= [self getSingleModel:index withMess:@"号码不存在"];
    
    CommonCallViewController *myView=[[CommonCallViewController alloc]initWithNibName:@"CommonCallViewController" bundle:nil];
    myView.typeStr=@"用座机拨打";
    myView.nameStr=model.C_A41500_C_NAME;
    myView.callStr=model.C_PHONE;
    [self.navigationController pushViewController:myView animated:YES];
    
}
//回呼
- (void)callBack:(NSInteger)index{
    CGCOrderDetailModel *model= [self getSingleModel:index withMess:@"号码不存在"];
    CommonCallViewController *myView=[[CommonCallViewController alloc]initWithNibName:@"CommonCallViewController" bundle:nil];
    myView.typeStr=@"回呼到手机";
    myView.nameStr=model.C_A41500_C_NAME;
    myView.callStr=model.C_PHONE;
    [self.navigationController pushViewController:myView animated:YES];
    
}

//重新指派
- (void)assigned:(CGCOrderDetailModel *)model {
	DBSelf(weakSelf);
    MJKChooseEmployeesViewController *vc = [[MJKChooseEmployeesViewController alloc]init];
    if ([[NewUserSession instance].appcode containsObject:@"crm:a420:kdzp"]) {
        vc.isAllEmployees = @"是";
    }
    vc.noticeStr = @"无提示";
    vc.chooseEmployeesBlock = ^(MJKClueListSubModel * _Nonnull model) {
		[weakSelf HTTPUpdataAssWithID:model.C_ID andUserID:model.user_id];
		
	};
	[self.navigationController pushViewController:vc animated:YES];
}


- (CGCOrderDetailModel *)getSingleModel:(NSInteger)index withMess:(NSString *)mess{
    
//    long section=index/100;
//    int row=index%100;
//    if (self.dataArray.count<section||[[self.dataArray[section] content] count]<row) {
//
//        [JRToast showWithText:mess];
//        return nil;
//    }
//    CGCOrderDetailModel *model=[self.dataArray[section] content][row];
//
//    return model;
	long section=index/100;
	int row=index%100;
	NSArray *arr=[self.dataArray[section] content];
	
	if (self.dataArray.count<section|| arr.count<row) {
		
		[JRToast showWithText:mess];
		return nil;
	}
	CGCOrderDetailModel *model=[self.dataArray[section] content][row];
	
	return model;
	
}
#pragma mark -- 网络请求 request
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


- (void)HTTPGetOrderList{//获取订单列表
    DBSelf(weakSelf);

    NSMutableDictionary *dic=[NSMutableDictionary new];
    
    
   
    
    self.SEARCH_NAMEORCONTACT.length>0?[dic setObject:self.SEARCH_NAMEORCONTACT forKey:@"SEARCH_NAMEORCONTACT"]:[dic removeObjectForKey:@"SEARCH_NAMEORCONTACT"];
    [dic setObject:@(self.currPage) forKey:@"pageSize"];
    [dic setObject:@"1" forKey:@"pageNum"];
    dic[@"C_OWNER_ROLEID"] = self.sellModel.USER_ID.length>0?self.sellModel.USER_ID:self.saleCode;
	if (self.sellModel.C_A40600_C_ID.length > 0) {
		dic[@"C_A40600_C_ID"] = self.sellModel.C_A40600_C_ID;
	}
    if (self.sellModel.C_A49600_C_ID.length > 0) {
        dic[@"C_A49600_C_ID"] = self.sellModel.C_A49600_C_ID;
    }
    if (self.sellModel.C_A70600_C_ID.length > 0) {
        dic[@"C_A70600_C_ID"] = self.sellModel.C_A70600_C_ID;
    }
	if (self.statusStr.length > 0) {
		self.sellModel.C_STATUS_DD_ID.length>0?[dic setObject:self.sellModel.C_STATUS_DD_ID forKey:@"C_STATUS_DD_ID"]:0;
	} else {
        if (self.sellModel.C_STATUS_DD_ID.length>0) {
            [dic setObject:self.sellModel.C_STATUS_DD_ID forKey:@"C_STATUS_DD_ID"];
        }
//		self.sellModel.C_STATUS_DD_ID.length>0?[dic setObject:self.sellModel.C_STATUS_DD_ID forKey:@"C_STATUS_DD_ID"]:[dic setObject:@"1" forKey:@"C_STATUS_DD_ID"];
	}
    self.sellModel.START_TIME_TYPE.length>0?[dic setObject:self.sellModel.START_TIME_TYPE forKey:@"START_TIME_TYPE"]:0;
    if (self.createTimeType.length > 0) {
        [dic setObject:self.createTimeType forKey:@"CREATE_TIME_TYPE"];
    } else {
        self.sellModel.CREATE_TIME_TYPE.length>0?[dic setObject:self.sellModel.CREATE_TIME_TYPE forKey:@"CREATE_TIME_TYPE"]:0;
    }
    if (self.QUEREN_TIME_TYPE.length > 0) {
        dic[@"QUEREN_TIME_TYPE"] = self.QUEREN_TIME_TYPE;
    }
    if (self.SEND_TIME_TYPE) {
        dic[@"SEND_TIME_TYPE"] = self.SEND_TIME_TYPE;
    }
    /***************************************/
    self.sellModel.C_CLUEPROVIDER_ROLEID.length>0?[dic setObject:self.sellModel.C_CLUEPROVIDER_ROLEID forKey:@"C_CLUEPROVIDER_ROLEID"]:0;
    self.sellModel.C_A47700_C_ID.length>0?[dic setObject:self.sellModel.C_A47700_C_ID forKey:@"C_A47700_C_ID"]:0;
    self.sellModel.START_TIME.length>0?[dic setObject:self.sellModel.START_TIME forKey:@"START_TIME"]:0;
    self.sellModel.END_TIME.length>0?[dic setObject:self.sellModel.END_TIME forKey:@"END_TIME"]:0;
    self.sellModel.JF_START_TIME.length>0?[dic setObject:self.sellModel.JF_START_TIME forKey:@"JF_START_TIME"]:0;
    self.sellModel.JF_END_TIME.length>0?[dic setObject:self.sellModel.JF_END_TIME forKey:@"JF_END_TIME"]:0;
    self.sellModel.LASTFOLLOW_TIME_TYPE.length > 0 ? [dic setObject:self.sellModel.LASTFOLLOW_TIME_TYPE forKey:@"LASTFOLLOW_TIME_TYPE"] : 0;
    self.sellModel.LASTFOLLOW_END_TIME.length > 0 ?[dic setObject:self.sellModel.LASTFOLLOW_END_TIME forKey:@"LASTFOLLOW_END_TIME"]:0;
    self.sellModel.START_CREATE_TIME.length > 0 ? dic[@"LASTFOLLOW_START_TIME"] =  self.sellModel.START_CREATE_TIME : 0;
    self.sellModel.END_CREATE_TIME.length > 0 ? dic[@"LASTFOLLOW_END_TIME"] =  self.sellModel.END_CREATE_TIME : 0;
    /***************************************/
	if (self.IS_ASSISTANT.length > 0) {
		dic[@"IS_ASSISTANT"] = self.IS_ASSISTANT;
	}
	if (self.assistStr.length > 0) {
		dic[@"C_ASSISTANT"] = self.assistStr;
	}
	if (self.assistFromStr.length > 0) {
		dic[@"C_INITIATORASSISTANT"] = self.assistFromStr;
	}
    if (self.CUSTOMERTYPE.length > 0) {
        dic[@"CUSTOMERTYPE"] = self.CUSTOMERTYPE;
    }

    [self.saveTableDataDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        dic[key] = obj;
    }];
    [self.saveTimeDataDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        dic[key] = obj;
    }];
    
    dic[@"C_LOCCODE"] = [NewUserSession instance].user.C_LOCCODE;
    HttpManager*manager=[[HttpManager alloc]init];
    
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a420/list", HTTP_IP] parameters:dic compliation:^(id data, NSError *error) {
        if (![self.view.subviews containsObject:self.tableView]) {
            [self.view addSubview:self.tableView];
            
        }
        [self.menuView bringSubviewToFront:self.view];
        if ([data[@"code"] integerValue]==200) {
            
            
            
            NSDictionary*dict=[data copy];
//            if (self.currPage==20) {
//                [self.dataArray removeAllObjects];
//            }
            if (self.dataArray.count > 0) {
                [self.dataArray removeAllObjects];
            }
            for (NSDictionary * dic in dict[@"data"][@"content"] ) {
                CGCOrderModel * model=[CGCOrderModel yy_modelWithDictionary:dic];
                [self.dataArray addObject:model];
                ;
                
            }
            if (self.isAssAgain == YES) {
                if (self.allArray.count > 0) {
                    for (int i = 0; i < self.allArray.count; i++) {
                        CGCOrderModel * model = self.dataArray[i];
                        CGCOrderModel * model1 = self.allArray[i];
                        for (int j = 0; j < model1.content.count; j++) {
                            CGCOrderDetailModel *subModel1 =  model1.content[j];
                            CGCOrderDetailModel *subModel = model.content[j];
                            //                    if ([subModel.C_ID isEqualToString:subModel1.C_ID]) {
                            subModel.selected = subModel1.isSelected;
                            //                    }
                        }
                    }
                    
                }
            }
            [self.allArray removeAllObjects];
            [self.allArray addObjectsFromArray:self.dataArray];
            
            
            
        }else{
            
//            self.currPage>1?self.currPage--:0;
            
            [JRToast showWithText:data[@"message"]];
        }
        
        
        //        self.currPage>1?self.currPage--:0;
//         btn.frame=CGRectMake(KScreenWidth-60, 104, 60, 20);
        
        NSString *totalStr =  [NSString stringWithFormat:@"%@",data[@"data"][@"countNumber"]];
        weakSelf.totalStr = [NSString stringWithFormat:@" 总计:%@",totalStr];
        weakSelf.totalLabel.text = weakSelf.totalStr;

        
        
        CGSize strSize=[self.totalStr boundingRectWithSize:CGSizeMake(KScreenWidth - 20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        self.totalLabel.numberOfLines = 0;
        self.totalLabel.textAlignment = NSTextAlignmentRight;

        self.totalBtn.frame=CGRectMake(KScreenWidth-strSize.width-10, NavStatusHeight + 40, strSize.width + 10, strSize.height + 2);
        self.totalLabel.frame = self.totalBtn.frame;
        
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        
    }];
 
    
    
}

- (void)uploadOrderStar:(CGCOrderDetailModel *)model andStarCode:(NSString *)code{
	NSMutableDictionary *dic=[DBObjectTools getAddressDicWithAction:HTTP_updateByStatus];
	
	NSMutableDictionary *dic1=[NSMutableDictionary new];
	[dic1 setObject:model.C_ID forKey:@"C_ID"];
	[dic1 setObject:code forKey:@"C_STAR_DD_ID"];
	[dic1 setObject:@"6" forKey:@"TYPE"];
	[dic setObject:dic1 forKey:@"content"];
	
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dic withtype:@"1"];
	
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			
			self.currPage=20;
			[self HTTPGetOrderList];
			
		}else{
			[JRToast showWithText:data[@"message"]];
		}
		
		
	}];
	
	
}

#pragma mark 重新指派
- (void)HTTPUpdataAssWithID:(NSString *)idStr andUserID:(NSString *)userID {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A42000WebService-assign"];
	
	NSMutableDictionary *dic=[NSMutableDictionary new];
	dic[@"C_ID"] = idStr;
	dic[@"USER_ID"] = userID;
	
	[dict setObject:dic forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
	
	HttpManager*manager=[[HttpManager alloc]init];
	
	DBSelf(weakSelf);
	[manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		[self.view addSubview:self.tableView];
		if ([data[@"code"] integerValue]==200) {
			[weakSelf HTTPGetOrderList];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
		
		[weakSelf chooseView];
	}];
	
}


- (void)httpGetUserListWithModelArrayBlock:(void(^)(NSArray *saleArray))saleArrayBlock{
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_LOCCODE"] = [NewUserSession instance].user.C_LOCCODE;
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:HTTP_SYSTEMUserList parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
            NSArray *arr = [MJKNewUserModel  mj_objectArrayWithKeyValuesArray:data[@"data"]];
            if (saleArrayBlock) {
                saleArrayBlock(arr);
            }
            [self.sellArray addObjectsFromArray:arr];
            
            [self HTTPSalesPromotionActivityDatas];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
 }



#pragma mark - http 促销活动
- (void)HTTPSalesPromotionActivityDatas {
	DBSelf(weakSelf);
	HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/masterdata/a412/list", HTTP_IP] parameters:@{@"C_TYPE_DD_ID":@"A41200_C_TYPE_0000"} compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.salesPromotionArray = [MJKMarketSubModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"list"]];
			[weakSelf chooseView];
		}else{
			[JRToast showWithText:data[@"msg"]];
		}
	}];
	
}

#pragma mark -- set



//- (UITableView *)tableView{
//    
//    if (_tableView==nil) {
//        CGRect frame;
//        if ([self.isTab isEqualToString:@"无"]) {
//            frame = CGRectMake(0, NavStatusHeight + 40, KScreenWidth, KScreenHeight-NavStatusHeight - 40 - WD_TabBarHeight - SafeAreaBottomHeight);
//        } else {
//            if (SafeAreaBottomHeight > 0) {
//                frame = CGRectMake(0, NavStatusHeight + 40, KScreenWidth, KScreenHeight-NavStatusHeight - WD_TabBarHeight - SafeAreaBottomHeight-WD_TabBarHeight);
//            } else {
//                frame = CGRectMake(0, NavStatusHeight + 40, KScreenWidth, KScreenHeight-NavStatusHeight - 40 - WD_TabBarHeight - SafeAreaBottomHeight-WD_TabBarHeight);
//            }
//            
//        }
//        _tableView=[[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
//        _tableView.delegate=self;
//        _tableView.dataSource=self;
////        _tableView.estimatedRowHeight=60;
//         _tableView.tableFooterView=[[UIView alloc] init];
//        
//    }
//    
//    return _tableView;
//}

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

- (NSMutableDictionary *)saveTableDataDic {
    if (!_saveTableDataDic) {
        _saveTableDataDic = [NSMutableDictionary dictionary];
    }
    return _saveTableDataDic;
}

- (NSMutableDictionary *)saveTimeDataDic {
    if (!_saveTimeDataDic) {
        _saveTimeDataDic = [NSMutableDictionary dictionary];
    }
    return _saveTimeDataDic;
}


#pragma mark -- otherDelegate
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
}








- (UIImage *)handleImageWithURLStr:(NSString *)imageURLStr {
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURLStr]];
    NSData *newImageData = imageData;
    // 压缩图片data大小
    newImageData = UIImageJPEGRepresentation([UIImage imageWithData:newImageData scale:0.1], 0.1f);
    UIImage *image = [UIImage imageWithData:newImageData];
    
    // 压缩图片分辨率(因为data压缩到一定程度后，如果图片分辨率不缩小的话还是不行)
    CGSize newSize = CGSizeMake(200, 200);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (NSMutableArray *)allArray {
	if (!_allArray) {
		_allArray = [NSMutableArray array];
	}
	return _allArray;
}


@end
