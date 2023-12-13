//
//  MJKHomePageNewViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/9/12.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKHomePageNewViewController.h"
#import "MJKQrCodeViewController.h"
#import "MJKHomePageTodoNewCell.h"
#import "MJKHomePagePersonNewCell.h"
#import "MJKHomePageSelectTypeNewView.h"
#import "MJKPendingModel.h"
#import "MJKMessageDetailModel.h"
#import "MJKApprolViewController.h"

#import "CGCAdressBookVC.h"//通讯录
#import "MJKMessageCenterViewController.h"//消息中心
#import "MJKIntegralDetailViewController.h"//积分明细列表
#import "NoticeInfoDetailViewController.h"//公司公告

#import "MJKPKShowView.h"
#import "ReportTopTableViewCellNoGroup.h"
#import "FunnelShowView.h"
#import "CGCCustomDateView.h"

#import "MJKApprovalModel.h"

#import "NoticeInfoModel.h"

#import "MJKHomePageJXModel.h"
#import "MJKPKSheetModel.h"
#import "MJKPKSheetSubModel.h"
#import "ReportSheetModel.h"

#import "MJKCheckVersionView.h"

#import "MJKHomeJXTableViewCell.h"
#import "SHHomePageThirdTableViewCell.h"
#import "MJKRemindHomeViewController.h"
#import "MJKCustomReturnViewController.h"
#import "MJKCollectionListViewController.h"
#import "MJKPersonalPerformanceTargetViewController.h"//MJKCustomReturnViewController
#import "MJKGroupShowShopsViewController.h"
#import "MJKMessageHomeViewController.h"
#import "MJKNewGroupShopsViewController.h"

#import "MJKGroupReportViewController.h"
#import "DBNavigationController.h"
#import "MJKLouDouDetailViewController.h"

#import "CGCExpandVC.h"
#import "MJKShowSendView.h"
#import "WXApi.h"

#import "MJKRedPackageView.h"
#import "MJKRedPackageViewController.h"

#import "MJReportDataModel.h"

#import "MJKRedPackageModel.h"
#import "MJKA807MainModel.h"

@interface MJKHomePageNewViewController ()<UITableViewDataSource, UITableViewDelegate>
/** tableview*/
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSString *typeStr;
@property (nonatomic, strong) NSString *typeCodeStr;
/** <#注释#> */
@property (nonatomic,strong) NSArray *pendingArray;
/** saveNoticeArray*/
@property (nonatomic, strong) NSMutableArray *saveNoticeArray;
/** pk array*/
@property (nonatomic, strong) NSArray *pkArray;
/** <#备注#>*/
@property (nonatomic, strong) NSString *C_YEARMONTH;
@property(nonatomic,strong)ReportSheetModel*mainModel;
@property(nonatomic,strong)NSString  *timeType;   //时间筛选的类型
@property(nonatomic,strong)NSString *START_TIME;
@property(nonatomic,strong)NSString *END_TIME;
@property(nonatomic,strong)NSString *CREATE_START_TIME;
@property(nonatomic,strong)NSString *CREATE_END_TIME;
/** funnelView*/
@property (nonatomic, strong) FunnelShowView *funnelView;
/** header bgView*/
@property (nonatomic, strong) UIView *headerBGView;
/** <#备注#>*/
@property (nonatomic, strong) NSString *chooseDateStr;
@property (nonatomic, strong) NSString *jxChooseDateStr;
/** <#注释#>*/
@property (nonatomic, assign) BOOL isHaveDot;
/** <#注释#>*/
@property (nonatomic, strong) NSString *headerType;
/** <#注释#>*/
@property (nonatomic, strong) NSArray *redPackageArray;
@property (nonatomic, strong) NSMutableArray *xsTjArray;
@property (nonatomic, strong) NSString *reportType;
@property (nonatomic, strong) NSString *shijiaoStr;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, strong) NSMutableArray *syArray;

/** <#注释#> */
@property (nonatomic,strong) UILabel *approvalLabel;
@property (nonatomic,strong) UILabel *messageLabel;
/** <#注释#> */
@property (nonatomic,strong) UIView *bgView;

/** <#注释#>*/
@property (nonatomic, strong) MJKHomePageJXModel *bdModel;

@end

@implementation MJKHomePageNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self initUI];
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat screenX = KScreenWidth * scale;
    CGFloat screenY = KScreenHeight * scale;
    CGFloat fbl = screenX * screenY;
    NSLog(@"分辨率 %f",fbl);
    
}

- (void)getOpenRedPackageData:(MJKRedPackageModel *)model {
    DBSelf(weakSelf);
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A71100WebService-open"];
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_ID"] = model.C_ID;
    [dict setObject:contentDic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            MJKRedPackageViewController *vc = [[MJKRedPackageViewController alloc]init];
            vc.C_ID = model.C_ID;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else if ([data[@"code"] integerValue]==201) {//已领取
//            MJKRedPackageViewController *vc = [[MJKRedPackageViewController alloc]init];
//            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else if ([data[@"code"] integerValue]==202) {//未关注公众号
            WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
            launchMiniProgramReq.userName = [NewUserSession instance].C_GID;  //拉起的小程序的username
            launchMiniProgramReq.path = [NSString stringWithFormat:@"/pages/homepage/homepage?usertoken=%@&accountid=%@&phone=%@",[NewUserSession instance].accountId,[NewUserSession instance].user.u051Id, [NewUserSession instance].user.phonenumber] ;    //拉起小程序页面的可带参路径，不填默认拉起小程序首页
            launchMiniProgramReq.miniProgramType = WXMiniProgramTypeRelease; //拉起小程序的类型
            [WXApi sendReq:launchMiniProgramReq completion:nil];
        } else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    [self configNavi];
	[self httpAllRequest];
    
}


- (NSInteger)compareDate:(NSString*)aDate withDate:(NSString*)bDate
{
    NSInteger aa = 0;
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    dateformater.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [dateformater setDateFormat:@"yyyy-MM-dd"];
    NSDate *dta = [[NSDate alloc] init];
    NSDate *dtb = [[NSDate alloc] init];
    
    dta = [dateformater dateFromString:aDate];
    dtb = [dateformater dateFromString:bDate];
    NSComparisonResult result = [dta compare:dtb];
    if (result==NSOrderedSame)
    {
        aa=0;
    }else if (result==NSOrderedAscending)
    {
        //bDate比aDate大
        aa=1;
    }else {
        //bDate比aDate小
        aa=-1;
        
    }
    
    return aa;
}

- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        appearance.backgroundColor = KNaviColor;
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    } else {
     // Fallback on earlier versions
//        self.navigationController.navigationController.navigationBarHidden=NO;
//     self.navigationController.navigationBar.barTintColor = DBColor(247, 247, 247);
        [self.navigationController.navigationBar setBarTintColor:KNaviColor];
    }
//	[self.navigationController.navigationBar setBarTintColor:KNaviColor];
}

- (void)configNavi {
    self.navigationController.navigationBarHidden=NO;
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        appearance.backgroundColor = DBColor(247, 247, 247);
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    } else {
     // Fallback on earlier versions
     self.navigationController.navigationBar.barTintColor = DBColor(247, 247, 247);
    }
//    [self.navigationController.navigationBar setBarTintColor:DBColor(247, 247, 247)];
//    self.navigationItem.title = [NewUserSession instance].C_ABBREVATION;
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    if (![[NewUserSession instance].user.groupType isEqualToString:@"U03100_C_ISGROUP_0001"]) {
//        [button setTitleNormal:[[NewUserSession instance].user.C_LOCNAME stringByAppendingString:@"v"]];
//        [button addTarget:self action:@selector(changeShop:)];
        [button setTitleNormal:[NewUserSession instance].user.C_LOCNAME];
        [button addTarget:self action:@selector(toGroupReport)];
        
        UIButton *button1 = [UIButton new];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button1];
        [button1 setTitle:@"选择门店" forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button1.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [button1 addTarget:self action:@selector(changeShop:) forControlEvents:UIControlEventTouchUpInside];
        
    }  else {
    
//        [button setTitleNormal:[NewUserSession instance].C_ABBREVATION];
        [button setTitleNormal: [NewUserSession instance].user.C_LOCNAME];
    }
    [button setTitleColor:[UIColor blackColor]];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
//    button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.navigationItem.titleView = button;
}

- (void)toGroupReport {
    MJKGroupReportViewController *vc = [[MJKGroupReportViewController alloc]init];
    
    DBNavigationController *nav=[[DBNavigationController alloc]initWithRootViewController:vc];
    [UIApplication sharedApplication].keyWindow.rootViewController=nav;
}
//MARK:切换门店
- (void)changeShop:(UIButton *)sender {
        MJKNewGroupShopsViewController *vc = [[MJKNewGroupShopsViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
}
//MARK:-UI
- (void)initUI {
	self.typeStr = @"今日待办";
    self.typeCodeStr = @"0";
    self.chooseDateStr = self.jxChooseDateStr = @"本月";
    self.shijiaoStr = @"1";
    [KUSERDEFAULT setObject:@"动态发生视角" forKey:@"funnelSelectValue"];
    self.timeType = @"3";
    [KUSERDEFAULT setObject:@"本月" forKey:@"timeName"];
    self.C_YEARMONTH = @"3";
	[self makeNaviBar];
	
	[self addFunnelView];
	[self.view addSubview:self.tableView];

}

- (void)httpAllRequest {
    DBSelf(weakSelf);
    NSArray *arr = [NewUserSession instance].configData.sybbxsszList;
    [self getReportDatas];
    self.reportType = @"月度";
#warning 等发布成功放开并在后台改地址
//	[self judgeShowUpdateVersion];
    
    [self getPendingDatas];
    [self httpGetAllMessageUnreadCount];
    [self getCountApproval];
}

- (void)makeNaviBar {
	UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
	[button setImage:[UIImage imageNamed:@"通讯录"] forState:UIControlStateNormal];
	[button addTarget:self action:@selector(clickLeftItem) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem*leftItem=[[UIBarButtonItem alloc]initWithCustomView:button];
	self.navigationItem.leftBarButtonItem=leftItem;
	//收到推送消息图标
//	UIBarButtonItem*rightItem=[UIBarButtonItem itemWithImage:@"收到推送消息图标" highImage:nil isLeft:NO target:self andAction:@selector(clickRightItem)];
////	[rightItem pp_addBadgeWithNumber:77];
//	[rightItem pp_moveBadgeWithX:-2 Y:10];
//	self.navigationItem.rightBarButtonItem=rightItem;
    
    
    
}
//筛选漏斗
-(void)addFunnelView {
	FunnelShowView*funnelView=[FunnelShowView funnelShowView];
	self.funnelView=funnelView;
    funnelView.rootVC = self;
    NSArray*timeStr;
    NSArray*timeKeyStr;
    if ([self.headerType isEqualToString:@"漏斗"]) {
//        timeStr=@[@"全部",@"本周",@"上周",@"本月",@"上月",@"今年",@"去年",@"今天",@"昨天",@"最近7天",@"最近30天",@"自定义"];
//        timeKeyStr=@[@" ",@"9",@"10",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"999"];
        timeStr=@[@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"今年",@"去年",@"近7天",@"最近30天",@"自定义"];
        timeKeyStr=@[@" ",@"1",@"2",@"3",@"4",@"5",@"6",@"9",@"10",@"7",@"30",@"999"];
    }
    
	NSMutableArray*timeArr=[NSMutableArray array];
	for (int i=0; i<timeStr.count; i++) {
		MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
		model.name=timeStr[i];
		model.c_id=timeKeyStr[i];
		[timeArr addObject:model];
	}
	
	
	
	
	DBSelf(weakSelf);
    
    if ([self.headerType isEqualToString:@"漏斗"]) {
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
    }
	
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
                        
                        weakSelf.chooseDateStr = model.name;
						if ([model.c_id isEqualToString:@"999"]) {
							//自定义
						} else {
                            if ([weakSelf.headerType isEqualToString:@"漏斗"]) {
                                weakSelf.START_TIME=@"";
                                weakSelf.END_TIME=@"";
                                self.timeType=model.c_id;
                                self.chooseDateStr = model.name;
                                
                                [KUSERDEFAULT setObject:model.name forKey:@"timeName"];
                            }
							
						}
					} else {
//						weakSelf.shopCode = model.c_id;
                        weakSelf.shijiaoStr = model.c_id;
                        [KUSERDEFAULT setObject:model.name forKey:@"funnelSelectValue"];
					}
				}
			}
            if ([weakSelf.headerType isEqualToString:@"漏斗"]) {
                
                [self getReportDatas];
            }
			
		}
		
		
	};
	
	funnelView.resetBlock = ^{
        if ([weakSelf.headerType isEqualToString:@"漏斗"]) {
            self.timeType=0;
            self.START_TIME = self.END_TIME = @"";
            self.shijiaoStr = @"1";
            self.chooseDateStr = @"本月";
            [self getReportDatas];
        }
	};
	
	
	[[UIApplication sharedApplication].keyWindow addSubview:funnelView];
	
	
}

-(void)showTimeAlertVC{
	//自定义的选择时间界面。
	DBSelf(weakSelf);
	CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
		
	} withEnd:^{
		
	} withSure:^(NSString *start, NSString *end) {
		//        weakSelf.pagen = 20;
		//        weakSelf.pages = 1;
		weakSelf.START_TIME=start;
		weakSelf.END_TIME=end;
		weakSelf.timeType =@"";
		//        [weakSelf getClueListDatas];
	}];
	[[UIApplication sharedApplication].keyWindow  addSubview:dateView];
}

//MARK:-touch
- (void)clickLeftItem {
    
    CGCAdressBookVC * avc=[[CGCAdressBookVC alloc] init];
    [self.navigationController pushViewController:avc animated:YES];
}

- (void)clickRightItem {
    
    
////    CGCExpandVC *vc = [[CGCExpandVC alloc]init];
//    MJKMessageCenterViewController *vc = [[MJKMessageCenterViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
}



// MARK:-UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    if (self.pkArray.count > 1) {
//        return 5;
//    } else {
//        return 4;
//    }
    return self.cellArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	DBSelf(weakSelf);
//    if (self.pkArray.count > 1) {
    NSString *cellTitle = self.cellArray[indexPath.section];
		if ([cellTitle isEqualToString:@"用户"]) {
            MJKHomePagePersonNewCell *cell = [MJKHomePagePersonNewCell cellWithTableView:tableView];
            cell.codeButtonActionBlock = ^{
                MJKQrCodeViewController *vc = [[MJKQrCodeViewController alloc]init];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
			return cell;
        } else if ([cellTitle isEqualToString:@"处理"]) {
            MJKHomePageTodoNewCell *cell = [MJKHomePageTodoNewCell cellWithTableView:tableView];
            cell.typeStr = self.typeStr;
            cell.rootVC = self;
            cell.todoArray = self.pendingArray;
        
            if ([self.typeStr isEqualToString:@"今日待办"]) {
                if (self.pendingArray.count <= 0) {
                    cell.bgView.hidden = NO;
                    cell.noticeLabel.text = @"未设置今日待办\n点击设置";
                    [cell.toSetButton addTarget:self action:@selector(toSetButtonAction)];
                } else {
                    cell.bgView.hidden = YES;
                }
            } else if ([self.typeStr isEqualToString:@"后三天待办"]) {
                if (self.pendingArray.count <= 0) {
                    cell.bgView.hidden = NO;
                    cell.noticeLabel.text = @"未设置后三天待办\n点击设置";
                    [cell.toSetButton addTarget:self action:@selector(toSetButtonAction)];
                } else {
                    cell.bgView.hidden = YES;
                }
            } else if ([self.typeStr isEqualToString:@"逾期未处理"]) {
                if (self.pendingArray.count <= 0) {
                    cell.bgView.hidden = NO;
                    cell.noticeLabel.text = @"未设置逾期未处理\n点击设置";
                    [cell.toSetButton addTarget:self action:@selector(toSetButtonAction)];
                } else {
                    cell.bgView.hidden = YES;
                }
            }
            
            return cell;
        } else if ([cellTitle isEqualToString:@"榜单"]) {
            MJKHomeJXTableViewCell *cell = [MJKHomeJXTableViewCell cellWithTableView:tableView];
            cell.buttonActionBlock = ^(NSInteger tag) {
                MJKCollectionListViewController *vc = [[MJKCollectionListViewController alloc]init];
                if (tag == 0) {
                    //收款目标
                    vc.tabStr = @"销量榜";
                    if (![[NewUserSession instance].appcode containsObject:@"home:bangdan:xlb"]) {
                        [JRToast showWithText:@"账号无权限"];
                        return;
                    }
                } else if (tag == 1) {
                    //累计完成
                    vc.tabStr = @"预约榜";
                    if (![[NewUserSession instance].appcode containsObject:@"home:bangdan:yyb"]) {
                        [JRToast showWithText:@"账号无权限"];
                        return;
                    }
                } else if (tag == 2) {
                    //今日完成
                    vc.tabStr = @"跟进榜";
                    if (![[NewUserSession instance].appcode containsObject:@"home:bangdan:gjb"]) {
                        [JRToast showWithText:@"账号无权限"];
                        return;
                    }
                } else if (tag == 4) {
                    //今日完成
                    vc.tabStr = @"逾期榜";
                    if (![[NewUserSession instance].appcode containsObject:@"home:bangdan:zyb"]) {
                        [JRToast showWithText:@"账号无权限"];
                        return;
                    }
                } else if (tag == 3) {
                    //今日完成
                    vc.tabStr = @"资源榜";
                    if (![[NewUserSession instance].appcode containsObject:@"home:bangdan:yqb"]) {
                        [JRToast showWithText:@"账号无权限"];
                        return;
                    }
                }
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            return cell;
        } else if ([cellTitle isEqualToString:@"应用"]) {
			SHHomePageThirdTableViewCell*  cell=[SHHomePageThirdTableViewCell cellWithTableView:tableView];
			cell.selectionStyle=NO;
			NSMutableArray*ar=[self getLocalImageTitle];
			cell.allDatas=ar;
            cell.isHaveDot = self.isHaveDot;
			[cell.collectionView reloadData];
			return cell;
		} else if ([cellTitle isEqualToString:@"漏斗"]) {
            ReportTopTableViewCellNoGroup*cell=[ReportTopTableViewCellNoGroup cellWithTableView:tableView];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.rootVC = self;
            [cell getValue:self.mainModel];
            cell.buttonClickBlock = ^(NSInteger tag) {
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
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            return cell;
        }
    return [UITableViewCell new];
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellTitle = self.cellArray[indexPath.section];
//    if (self.pkArray.count > 1) {
		if ([cellTitle isEqualToString:@"用户"]) {
			return 60;
		} else if ([cellTitle isEqualToString:@"处理"]) {
            if (self.pendingArray.count > 0) {
                return [MJKHomePageTodoNewCell cellHeightTodoArray:self.pendingArray];
            } else {
                return 120;
            }
        } else if ([cellTitle isEqualToString:@"榜单"]) {
            return 100;
        } else if ([cellTitle isEqualToString:@"应用"]){
			return [SHHomePageThirdTableViewCell getCellHeight];
		} else if ([cellTitle isEqualToString:@"漏斗"]) {
            return 355;
        }
    return UITableViewAutomaticDimension;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSString *cellTitle = self.cellArray[section];
	if ([cellTitle isEqualToString:@"用户"]) {
		return .1f;
	} else if ([cellTitle isEqualToString:@"处理"]) {
		return 50;
	}
	return 25.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    NSString *cellTitle = self.cellArray[section];
    if ([cellTitle isEqualToString:@"用户"]) {
        return 100;
    }
	return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *cellTitle = self.cellArray[section];
	if ([cellTitle isEqualToString:@"处理"]) {
		
		return self.headerBGView;
	}
	UIView*BGView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 25)];
	BGView.backgroundColor=[UIColor clearColor];
	UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth/2, 25)];
	titleLabel.font=[UIFont systemFontOfSize:14];
	titleLabel.textColor=[UIColor blackColor];
	[BGView addSubview:titleLabel];
    if ([cellTitle isEqualToString:@"应用"]) {
        titleLabel.text = @"应用中心";
        return BGView;
    }
    if ([cellTitle isEqualToString:@"榜单"]) {
        titleLabel.text = @"绩效榜单";
        return BGView;
    }
        if ([cellTitle isEqualToString:@"漏斗"]) {
            titleLabel.text=@"销售漏斗";
            //
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
            topLabel.textColor  =  [UIColor blackColor];
            bottomLabel.textColor = kNormalTextColor;
            topLabel.font = [UIFont systemFontOfSize:16.f];
            bottomLabel.font = [UIFont systemFontOfSize:12.f];
            [v addSubview:topLabel];
            [v addSubview:bottomLabel];
            
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, v.frame.size.width, v.frame.size.height)];
            [v addSubview:button];
            button.tag = i + 100;
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        return bgView;
       
    } else  {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 10)];
    bgView.backgroundColor = [UIColor whiteColor];
//    if (self.pkArray.count > 1) {
        if ([cellTitle isEqualToString:@"漏斗"]) {
            return bgView;
        }
//    } else {
//        if (section == 3) {
//            return bgView;
//        }
//    }
    return nil;
    }
}

- (void)buttonAction:(UIButton *)sender {
    if (sender.tag == 100) {
        if (![[NewUserSession instance].storecode containsObject:@"crm:a425:list"]) {
            [JRToast showWithText:@"请联系 脉车人 开通增强应用"];
            return;
        }
        
        if (![[NewUserSession instance].appcode containsObject:@"crm:a425:list"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        MJKApprolViewController *vc = [[MJKApprolViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        if (![[NewUserSession instance].appcode containsObject:@"system:a617:list"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        MJKMessageHomeViewController *vc = [[MJKMessageHomeViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark  --click
- (void)toSetYJButtonAction {
//    MJKCustomReturnViewController
    MJKPersonalPerformanceTargetViewController *vc = [[MJKPersonalPerformanceTargetViewController alloc]init];
//    vc.title = @"个人业绩目标设置";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)toSetButtonAction {
    MJKRemindHomeViewController *vc = [[MJKRemindHomeViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)clickChoose{
    self.headerType = @"漏斗";
    [self.funnelView removeFromSuperview];
    [self addFunnelView];
	[_funnelView show];
}

#pragma mark  --Datas

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


-(void)getPendingDatas{
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"pendingType"] = self.typeCodeStr;
    contentDic[@"C_LOCCODE"] = [NewUserSession instance].user.C_LOCCODE;
	HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkWithUrl:HTTP_Pending parameters:contentDic compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
            weakSelf.pendingArray = [MJKPendingModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
			[weakSelf.tableView reloadData];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

-(void)HttpGetNoticeInfo{
    DBSelf(weakSelf);
	[self.saveNoticeArray removeAllObjects];
	NSMutableDictionary*mainDic=[DBObjectTools getAddressDicWithAction:HTTP_NOticeInfo];
	NSDictionary*dict=@{@"TYPE":@"1",@"pageSize":@"1000",@"currPage":@"1", @"CREATE_TIME_TYPE" : @"13"};
	[mainDic setObject:dict forKey:@"content"];
	NSString*params=[DBObjectTools getPostStringAddressWithMainDict:mainDic withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:params parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			NSArray*array=data[@"content"];
			for (NSDictionary*dict in array) {
				NoticeInfoModel*model=[NoticeInfoModel yy_modelWithDictionary:dict];
				[self.saveNoticeArray addObject:model];
			}
			
            NSInteger index = [self.cellArray indexOfObject:@"用户"];
//            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:index]] withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf.tableView reloadData];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}


-(void)getReportDatas{
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

- (void)httpGetAllMessageUnreadCount {
    DBSelf(weakSelf);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    HttpManager*manager=[[HttpManager alloc]init];
//    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
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
//            NSInteger number = [data[@"data"][@"count"] integerValue];
            weakSelf.messageLabel.text = [NSString stringWithFormat:@"%ld", number];
            [weakSelf.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];

	
}




- (void)sendWXOrder:(NSString*)C_A04200_C_ID {
    WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
    launchMiniProgramReq.userName = [NewUserSession instance].C_GID;  //拉起的小程序的username
    launchMiniProgramReq.path = [NSString stringWithFormat:@"/pages/bill/bill?a420id=%@&accountid=%@&shareopenid=%@",C_A04200_C_ID,[NewUserSession instance].user.u051Id,[NewUserSession instance].user.C_OPENID] ;    //拉起小程序页面的可带参路径，不填默认拉起小程序首页
    launchMiniProgramReq.miniProgramType = WXMiniProgramTypeRelease; //拉起小程序的类型
    [WXApi sendReq:launchMiniProgramReq completion:nil];
    
    
}
#pragma mark - 默认三个应用
-(NSMutableArray*)getLocalImageTitle{
    NSMutableArray *myAppArray = [NSMutableArray array];
    NSMutableArray *allArray = [NSMutableArray array];
    NSArray *arr = @[@"工作日历",@"绩效进度",@"预约管理",@"审批管理",@"粉丝管理",@"车源管理",@"任务打卡",@"售后管理",@"客服反馈",@"精品管理",@"上牌管理",@"保险管理",@"按揭管理",@"质保管理"];
    for (NSString *str in arr) {
        MJKManagerModuleModel *model = [[MJKManagerModuleModel alloc] init];
        model.name = str;
        model.imageName = [NSString stringWithFormat:@"%@图标应用", str];
        [allArray addObject:model];
    }
    
    NSArray *myAppDatas = [[NSUserDefaults standardUserDefaults] objectForKey:@"module"];
   
    for (NSString *name in myAppDatas) {
        for (MJKManagerModuleModel *defaultModel in allArray) {
            if ([defaultModel.name isEqualToString:name]) {
                [myAppArray addObject:defaultModel];
            }
        }
    }
    
    MJKManagerModuleModel*model=[[MJKManagerModuleModel alloc]init];
    model.name=@"更多应用";
    model.imageName=@"更多应用";
    model.selected=NO;
    [myAppArray addObject:model];
    
    return myAppArray;
}
#pragma mark  --funcation
-(void)judgeShowUpdateVersion{
//	DBSelf(weakSelf);
	//	获取手机程序的版本号
    
    NSString *ver = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_APP_DD_ID"] = @"A42400_C_APP_0000";
    contentDic[@"C_VERSION_NUMBER"] = ver;
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:@"http://47.95.249.137:9090/prod-api/api/system/a424/versionValidate" parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] intValue] == 200) {
            if ([data[@"data"][@"FLAG"] boolValue] != false) {
                NSString *urlStr = data[@"data"][@"url"];
                if ([urlStr isKindOfClass:[NSNull class]]) {
                    MyLog(@"nsnull");
                    return;
                }
                MJKCheckVersionView *checkView = [[NSBundle mainBundle]loadNibNamed:@"MJKCheckVersionView" owner:nil options:nil].firstObject;
                NSString *content = data[@"data"][@"X_REMARK"];
                if ([content isKindOfClass:[NSNull class]]) {
                    return;
                }
                NSData *data = [content dataUsingEncoding:NSUnicodeStringEncoding];

                NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};

                NSAttributedString *html = [[NSAttributedString alloc]initWithData:data options:options documentAttributes:nil error:nil];
                checkView.updateMessageTextView.attributedText = html;

                checkView.updateButtonActioBlock = ^{

                    NSURL *url = [NSURL URLWithString:urlStr];

                    [[UIApplication sharedApplication] openURL:url];
                };
                [[UIApplication sharedApplication].keyWindow addSubview:checkView];
            } else {
//                [JRToast showWithText:data[@"msg"]];
            }
        }
    }];
    
//	NSString *ver = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//
//	NSMutableDictionary*mainDic=[DBObjectTools getAddressDicWithAction:@"A42400WebService-versionValidate"];
//	NSDictionary*dict=@{@"APPTYPE":@"0",@"VERSIONTYPE":@"5",@"C_VERSION_NUMBER":ver};
//	[mainDic setObject:dict forKey:@"content"];
//	NSString*params=[DBObjectTools getPostStringAddressWithMainDict:mainDic withtype:nil];
//	HttpManager*manager=[[HttpManager alloc]init];
//	[manager postDataFromNetworkNoHudWithUrl:params parameters:nil compliation:^(id data, NSError *error) {
//		MyLog(@"%@",data);
//		if ([data[@"code"] integerValue]==200) {
//                    NSString *str = data[@"FLAG"];
//                    NSString *urlStr = data[@"url"];
//
//                    if (![str isEqualToString:@"false"]) {
//                        MJKCheckVersionView *checkView = [[NSBundle mainBundle]loadNibNamed:@"MJKCheckVersionView" owner:nil options:nil].firstObject;
//                        NSString *content = data[@"X_REMARK"];
//                        NSData *data = [content dataUsingEncoding:NSUnicodeStringEncoding];
//
//                        NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
//
//                        NSAttributedString *html = [[NSAttributedString alloc]initWithData:data options:options documentAttributes:nil error:nil];
//                        checkView.updateMessageTextView.attributedText = html;
//
//                        checkView.updateButtonActioBlock = ^{
//
//                            NSURL *url = [NSURL URLWithString:urlStr];
//
//                            [[UIApplication sharedApplication] openURL:url];
//                        };
//                        [[UIApplication sharedApplication].keyWindow addSubview:checkView];
//
//
//                    }
//                }else{
//			[JRToast showWithText:data[@"message"]];
//		}
//
//	}];
}

//MARK:-set
- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
		_tableView.backgroundColor = kBackgroundColor;
		_tableView.dataSource = self;
		_tableView.delegate = self;
		_tableView.estimatedRowHeight = 0;
		_tableView.estimatedSectionFooterHeight = 0;
		_tableView.estimatedSectionHeaderHeight = 0;
		_tableView.tableFooterView = [[UIView alloc]init];
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	}
	return _tableView;
}

- (NSMutableArray *)saveNoticeArray {
	if (!_saveNoticeArray) {
		_saveNoticeArray = [NSMutableArray array];
	}
	return _saveNoticeArray;
}

- (UIView *)headerBGView {
	DBSelf(weakSelf);
	if (!_headerBGView) {
		_headerBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, KScreenWidth, 40)];
		_headerBGView.backgroundColor = [UIColor whiteColor];
		
		MJKHomePageSelectTypeNewView *view = [[NSBundle mainBundle]loadNibNamed:@"MJKHomePageSelectTypeNewView" owner:nil options:nil].firstObject;
		view.typeSelectBlock = ^(NSString *str, NSInteger tag) {
			weakSelf.typeStr = str;
            weakSelf.typeCodeStr = [NSString stringWithFormat:@"%ld",tag];
            [weakSelf getPendingDatas];
		};
		[_headerBGView addSubview:view];
	}
	return _headerBGView;
}

- (NSMutableArray *)cellArray {
    if (!_cellArray) {
        _cellArray = [NSMutableArray arrayWithObjects:@"用户",@"处理",@"榜单",@"应用",@"漏斗", nil];
    }
    return _cellArray;
}

@end
