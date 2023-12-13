//
//  PotentailCustomerViewController.m
//  Mcr_2
//
//  Created by 黄佳峰 on 2017/6/22.
//  Copyright © 2017年 bipi. All rights reserved.
//

#import "PotentailCustomerListViewController.h"
#import "CGCNavSearchTextView.h"
#import "CFDropDownMenuView.h"
#import "CGCCustomDateView.h"
#import "PotentailCustomerListCell.h"
#import "CGCAlertDateView.h"
#import "CGCMoreCollection.h"
#import "DBAssignBottomChooseView.h"   //底部的view
#import "ShowHelpViewController.h"//查看协助列表
#import "EmployeesModel.h"
#import "ShopModel.h"
#import "ChannelModel.h"

#import "CFDropDownMenuViewNew.h"

#import "MJKClueListViewModel.h"   //销售列表的
#import "PotentailCustomerListModel.h"   //数据model
#import "CGCAppointmentModel.h"   //预约的model
#import "MJKClueListViewModel.h" //协助人

#import "MJKVoiceCViewController.h"
#import "CommonCallViewController.h"
#import "SendMessageViewController.h"   //发送信息
#import "MJKMarketViewController.h"    //选择销售  之后的回调
#import "AddOrEditlCustomerViewController.h"    //新增潜客或者编辑
#import "CustomerDetailViewController.h"    //潜客详情界面
#import "CGCTemplateVC.h"   //短信  微信
#import "CustomerFollowAddEditViewController.h"   //跟进详情
#import "CGCNewAddAppointmentVC.h"  //预约详情
#import "AddHelperViewController.h"//设计师

#import "MJKCustomerSeaModel.h"
#import "MJKCustomerSeaSubModel.h"
#import "MJKCustomReturnSubModel.h"
#import "MJKNewUserModel.h"

#import "VoiceView.h"
#import "MJKNoteModel.h"
#import "MJKChooseEmployeesViewController.h"
#import "CGCNewAlertDateView.h"

#import "MJKAddOrEditCarSourceViewController.h"
#import "ServiceTaskAddViewController.h"
#import "MJKChooseBrandModel.h"
#import "MJKProductShowModel.h"

#import "MJKOrderAddOrEditViewController.h"

#import "CGCCustomModel.h"


#define CELL0   @"PotentailCustomerListCell"

@interface PotentailCustomerListViewController ()<UITableViewDataSource,UITableViewDelegate,AddOrEditlCustomerViewControllerDelegate> {
//    NSMutableArray *shopCodeArray;
//    NSMutableArray *shopNameArray;
}

/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *shopCodeArray;
@property (nonatomic, strong) NSMutableArray *shopNameArray;

@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)CGCNavSearchTextView*CurrentTitleView;  //不做属性 警告。。
@property(nonatomic,strong)UILabel*allNumberLabel;   //总计label
@property(nonatomic,strong)DBAssignBottomChooseView*bottomChooseView; //底部的选择view

@property(nonatomic,assign)BOOL isNewAssign;    //是否是重新指派  

/** <#备注#>*/
@property (nonatomic, strong) NSArray *noteArray;

@property(nonatomic,assign)NSInteger pagen;
@property(nonatomic,assign)NSInteger pages;
//下面4个 筛选条件    有就 加进去  没有就算了
@property(nonatomic,strong)NSString*searchStr;
@property(nonatomic,strong)NSMutableDictionary*saveSelTableDict;
@property(nonatomic,strong)NSMutableDictionary*saveSelFunnelDict;
@property(nonatomic,strong)NSMutableDictionary*saveSelTimeDict;

@property(nonatomic,strong)NSMutableArray*TableChooseDatas;    //筛选的数据
@property(nonatomic,strong)NSMutableArray*TableSelectedChooseDatas;   //筛选选中的数据
@property(nonatomic,strong)NSMutableArray*FunnelDatas;     //漏斗的所有数据

@property(nonatomic,strong)NSMutableArray<PotentailCustomerListModel*>*allListDatas;  //保存所有的潜客列表
@property(nonatomic,strong)NSMutableArray*saveAllSelectedAssignModelArray; //所有选中的分配的model
@property(nonatomic,strong)PotentailCustomerListDetailModel*detailModel;
/** 协助人*/
@property (nonatomic, strong) MJKClueListViewModel *saleDatasModel;
/** pxDataArray*/
@property (nonatomic, strong) NSArray *pxDataArray;

/** segment*/
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
/** 公海列表*/
@property (nonatomic, strong) NSMutableArray *seaDataArray;
/** 语音*/
@property (nonatomic, strong) VoiceView *vv;
/** <#备注#>*/
@property (nonatomic, strong) CFDropDownMenuView*menuView;
@property (nonatomic, strong) CFDropDownMenuViewNew*dropDownMenuView;
/** 重新指派id*/
@property (nonatomic, strong) NSString *assCodeStr;
/** 介绍人*/
@property (nonatomic, strong) NSString *jieshorenStr;
/** 到店次数*/
@property (nonatomic, strong) NSString *arriveTimes;

/** <#注释#>*/
@property (nonatomic, strong) NSString *C_GHLX_DD_ID;
/** <#注释#>*/
@property (nonatomic, strong) NSString *X_GHLY;
@property (nonatomic, strong) NSString *C_A70600_C_ID;
@property (nonatomic, strong) NSString *C_A49600_C_ID;
/** <#注释#>*/
@property (nonatomic, strong) NSArray *dataArray;


@end

@implementation PotentailCustomerListViewController

- (void)setIsAdd:(BOOL)isAdd {
	_isAdd = isAdd;
	if (isAdd == YES) {
		if ([self.isListOrSea isEqualToString:@"list"]) {
			[self addNewPotentailCustomer];
		}
	}
}

- (void)setLoudou:(NSString *)loudou {
    _loudou = loudou;
    CGRect frame = self.tableView.frame;
    frame.size.height = frame.size.height + WD_TabBarHeight;
    self.tableView.frame = frame;
}

- (void)setTabSearchStr:(NSString *)tabSearchStr {
	_tabSearchStr = tabSearchStr;
	self.searchStr = tabSearchStr;
	[self.tableView.mj_header beginRefreshing];
}


-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	if (self.isNewAssign == YES) {
//        self.tabBarController.tabBar.hidden = YES;
	}
    
	//[[NSUserDefaults standardUserDefaults]setObject:@"no" forKey:@"refresh"];
	NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"refresh"];
	if ([str isEqualToString:@"YES"]) {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			
			[self.tableView.mj_header beginRefreshing];
			[[NSUserDefaults standardUserDefaults]removeObjectForKey:@"refresh"];
		});
	}
	
    NSArray*arraySel=@[@"",@"5",@"0",@"1",@"2",@"4"]; NSArray*arraycode=@[@"",@"A47500_C_KHPX_0004",@"A47500_C_KHPX_0000",@"A47500_C_KHPX_0001",@"A47500_C_KHPX_0002",@"A47500_C_KHPX_0003"];
    NSInteger index = 0;
    NSString *typeStr;
    
    if ([arraycode containsObject:[NewUserSession instance].configData.C_KHPX]) {
        index = [arraycode indexOfObject:[NewUserSession instance].configData.C_KHPX];
    }
    if ([arraySel containsObject:[NewUserSession instance].configData.C_KHPX]) {
        index = [arraySel indexOfObject:[NewUserSession instance].configData.C_KHPX];
    }
    if (self.saveSelTableDict[@"TYPE"] != nil) {
        typeStr = self.saveSelTableDict[@"TYPE"];
    }
    
    if (![typeStr isEqualToString:arraySel[index]]) {
        
        [self.saveSelTableDict setObject:arraySel[index] forKey:@"TYPE"];
        [self.tableView.mj_header beginRefreshing];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
	if (@available(iOS 11.0,*)) {
		self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
	}else{
		if (@available(iOS 11.0, *)) {
			self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
		}else {
			self.automaticallyAdjustsScrollViewInsets = NO;
		}
	}
    
    //TYPE  一定要传  后台问题   默认给他0
	if (self.isTab == YES) {
		UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"列表",@"公海"]];
		self.segmentedControl = segmentedControl;
		self.segmentedControl.selectedSegmentIndex = 1;
		if ([self.isListOrSea isEqualToString:@"list"]) {
            if (self.C_STATUS_DD_ID.length > 0) {
                self.saveSelTableDict[@"C_STATUS_DD_ID"] = self.C_STATUS_DD_ID;
            } else {
                self.saveSelTableDict[@"C_STATUS_DD_ID"] = @"1";
            }
            if (self.LASTFOLLOW_START_TIME.length > 0) {
                self.saveSelFunnelDict[@"LASTFOLLOW_START_TIME"] = self.LASTFOLLOW_START_TIME;
            }
            if (self.LASTFOLLOW_END_TIME.length > 0) {
                self.saveSelFunnelDict[@"LASTFOLLOW_END_TIME"] = self.LASTFOLLOW_END_TIME;
            }
			self.segmentedControl.selectedSegmentIndex = 0;
		} else {
			self.segmentedControl.selectedSegmentIndex = 1;
		}
	} else {
		[self createNav];
		self.segmentedControl.selectedSegmentIndex = 0;
		self.isListOrSea = @"list";
        if (self.C_STATUS_DD_ID.length > 0) {
            self.saveSelTableDict[@"C_STATUS_DD_ID"] = self.C_STATUS_DD_ID;
        } else {
            self.saveSelTableDict[@"C_STATUS_DD_ID"] = @"1";
        }
        if (self.LASTFOLLOW_START_TIME.length > 0) {
            self.saveSelFunnelDict[@"LASTFOLLOW_START_TIME"] = self.LASTFOLLOW_START_TIME;
        }
        if (self.LASTFOLLOW_END_TIME.length > 0) {
            self.saveSelFunnelDict[@"LASTFOLLOW_END_TIME"] = self.LASTFOLLOW_END_TIME;
        }
	}
    
    NSArray*arraySel=@[@"",@"5",@"0",@"1",@"2",@"4"]; NSArray*arraycode=@[@"",@"A47500_C_KHPX_0004",@"A47500_C_KHPX_0000",@"A47500_C_KHPX_0001",@"A47500_C_KHPX_0002",@"A47500_C_KHPX_0003"];
    NSInteger index = 0;
    if ([arraycode containsObject:[NewUserSession instance].configData.C_KHPX]) {
        index = [arraycode indexOfObject:[NewUserSession instance].configData.C_KHPX];
        [self.saveSelTableDict setObject:arraySel[index] forKey:@"TYPE"];
        
    } else {
        [self.saveSelTableDict setObject:[NewUserSession instance].configData.C_KHPX forKey:@"TYPE"];
    }
    [self.view addSubview:self.tableView];
    
    [self addTotailView];
    [self createChooseView];
    
    [self setupRefresh];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
    
	[self.tableView.mj_header beginRefreshing];
    
    [self getList];
    
    [self getShopValues];
}

#pragma mark -- createUI
-(void)addTotailView{   
    UIImageView*BGImageV=[[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth-60, NavStatusHeight+40-1, 60, 20)];
    BGImageV.image=[UIImage imageNamed:@"all_bg"];
    BGImageV.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:BGImageV];
    
    UILabel*allNumberLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, BGImageV.width, BGImageV.height)];
    allNumberLabel.font=[UIFont systemFontOfSize:11];
    allNumberLabel.textColor=KColorGrayTitle;
    allNumberLabel.text=@"总计:0";
    allNumberLabel.textAlignment=NSTextAlignmentCenter;
    self.allNumberLabel=allNumberLabel;
    [BGImageV addSubview:allNumberLabel];

    
}
#pragma mark - SegmentedControl 列表 / 公海
- (UISegmentedControl *)setSegmentedControl {
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"列表",@"公海"]];
	self.segmentedControl = segmentedControl;
	segmentedControl.frame = CGRectMake(0, 0, 150, 30);
	segmentedControl.tintColor = [UIColor whiteColor];
	[segmentedControl addTarget:self action:@selector(selectListOrSea:) forControlEvents:UIControlEventValueChanged];
	return segmentedControl;
}
#pragma mark - confing navi

- (void)createNav{
	
    self.view.backgroundColor=CGCTABBGColor;
    DBSelf(weakSelf);
    self.CurrentTitleView=[[CGCNavSearchTextView alloc] initWithFrame:self.view.bounds withPlaceHolder:@"请输入姓名/手机/地址/微信号" withRecord:^{//点击录音
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
			self.searchStr=str;
			[self.tableView.mj_header beginRefreshing];

		};
        
    } withText:^{//开始编辑
        MyLog(@"编辑");
        
        
    }withEndText:^(NSString *str) {//结束编辑
        NSLog(@"%@____",str);
        if (str.length>0) {
            self.searchStr=str;
            [self.tableView.mj_header beginRefreshing];
        }else{
            self.searchStr=@"";
            [self.tableView.mj_header beginRefreshing];
        }
		if (self.segmentedControl.selectedSegmentIndex == 0) {
			self.menuView.defaulTitleArray= @[@"员工",@"车型",@"等级",@"状态"];
		}
    }];
	
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"icon_customer_add" highImage:@"" isLeft:NO target:self andAction:@selector(addNewPotentailCustomer)];
    
    self.navigationItem.titleView = self.CurrentTitleView;
    
//    self.navigationItem.rightBarButtonItems = @[[UIBarButtonItem itemWithImage:@"icon_customer_add" highImage:@"" isLeft:NO target:self andAction:@selector(addNewPotentailCustomer)],[UIBarButtonItem itemWithImage:@"搜索按钮" highImage:@"" isLeft:NO target:self andAction:@selector(searchAction:)]];
//
//    self.navigationItem.titleView = [self setSegmentedControl];
//    self.segmentedControl.selectedSegmentIndex = 0;
//    self.segmentedControl.userInteractionEnabled = NO;
}



-(void)addChooseView{
    DBSelf(weakSelf);
    CFDropDownMenuView*menuView=[[CFDropDownMenuView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth-40, 40)];
	self.menuView = menuView;
	menuView.VCName = @"客户管理";
    menuView.dataSourceArr=self.TableChooseDatas;
    
   
    menuView.defaulTitleArray=self.segmentedControl.selectedSegmentIndex == 0 ? @[@"员工",@"车型",@"等级",@"有意向"] : @[@"原负责人",@"归还原因",@"转入时间",@"转入方式"];
    menuView.startY=CGRectGetMaxY(menuView.frame);
    menuView.chooseConditionBlock = ^(NSString *selectedSection, NSString *selectedRow, NSString *title) {
        MyLog(@"%@  %@   %@",selectedSection,selectedRow,title);
        NSMutableArray*subArray=self.TableSelectedChooseDatas[[selectedSection integerValue]];
        NSString*selectValue=subArray[[selectedRow integerValue]];
        
        NSString*selectKey;
		if (self.segmentedControl.selectedSegmentIndex == 0) {
			if ([selectedSection isEqualToString:@"0"]) {
				//销售
				selectKey=@"C_OWNER_ROLEID";
				
			}else if ([selectedSection isEqualToString:@"2"]){
				//等级
				selectKey=@"C_LEVEL_DD_ID";
			}else if ([selectedSection isEqualToString:@"3"]){
				//状态
				selectKey=@"C_STATUS_DD_ID";
			}
			
			
			if (selectKey) {
				if ([selectKey isEqualToString:@"C_STATUS_DD_ID"] || [selectKey isEqualToString:@"TYPE"]) {
					self.FOLLOW_TIME_TYPE = @"";
				}
				[self.saveSelTableDict setObject:selectValue forKey:selectKey];
				[self.tableView.mj_header beginRefreshing];
			}
		} else {
			if ([selectedSection isEqualToString:@"0"]) {
				//原负责人
				selectKey=@"C_SOURCEOWNERID";
				
			}else if ([selectedSection isEqualToString:@"1"]){
				//归还原因
				selectKey=@"C_GHLX_DD_ID";
			}else if ([selectedSection isEqualToString:@"2"]){
				//转入时间
				selectKey=@"CHANGEIN_TIME_TYPE";
				
            } else if ([selectedSection isEqualToString:@"3"]) {
                selectKey = @"C_CHANGEINTO_DD_ID";
            }
			if (selectKey) {
				if ([title isEqualToString:@"自定义"]) {
					CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
						
					} withEnd:^{
						
						
					} withSure:^(NSString *start, NSString *end) {
						MyLog(@"11--%@   22--%@",start,end);
						
						[self.saveSelTimeDict setObject:start forKey:@"CHANGEIN_START_TIME"];
						[self.saveSelTimeDict setObject:end forKey:@"CHANGEIN_END_TIME"];
						
						[self.tableView.mj_header beginRefreshing];
						
					}];
					
					
					dateView.clickCancelBlock = ^{
//						NSIndexPath*indexPath=[NSIndexPath indexPathForRow:6 inSection:2];
//						[weakFunnelView unselectedDetailRow:indexPath];
						
						[self.saveSelTimeDict removeObjectForKey:@"CHANGEIN_START_TIME"];
						[self.saveSelTimeDict removeObjectForKey:@"CHANGEIN_END_TIME"];
						[self.saveSelFunnelDict setObject:@"" forKey:@"CREATE_TIME"];
						
					};
					
					
					
					[[UIApplication sharedApplication].keyWindow addSubview:dateView];
//					[self.saveSelTableDict setObject:selectValue forKey:@"CHANGEIN_START_TIME"];
//					[self.saveSelTableDict setObject:selectValue forKey:@"CHANGEIN_END_TIME"];
				} else {
					//其他时间状态下移除自定义时间
					if ([selectKey isEqualToString:@"CHANGEIN_TIME_TYPE"]) {
						[self.saveSelTimeDict removeObjectForKey:@"CHANGEIN_START_TIME"];
						[self.saveSelTimeDict removeObjectForKey:@"CHANGEIN_END_TIME"];
						
					}
					[self.saveSelTableDict setObject:selectValue forKey:selectKey];
					
					[self.tableView.mj_header beginRefreshing];
				}
				
				
			}
		}
		

       
    };
    [self.view addSubview:menuView];

    menuView.chooseCarTypeBlock = ^(NSString *typeStr) {
        MyLog(@"");
        NSArray *arr = [typeStr componentsSeparatedByString:@","];
        weakSelf.saveSelTableDict[@"C_A70600_C_ID"] = arr[0];
        weakSelf.saveSelTableDict[@"C_A49600_C_ID"] = arr[1];
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    
    
    
    
    
    
    
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
      
        [self.saveSelFunnelDict removeAllObjects];
        for (NSDictionary*dict in array) {
            NSString*indexStr=dict[@"index"];
            MJKFunnelChooseModel*model=dict[@"model"];
            if (self.segmentedControl.selectedSegmentIndex == 0) {
                
            
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
            } else {
                if ([indexStr isEqualToString:@"0"]) {
                    //战败原因
                    [weakSelf.saveSelFunnelDict setObject:model.c_id forKey:@"C_CUSTOMERFAIL_DD_ID"];
                }
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
	
	
	funnelView.resetBlock = ^{
		[weakSelf.saveSelTimeDict removeObjectForKey:@"CREATE_START_TIME"];
		[weakSelf.saveSelTimeDict removeObjectForKey:@"CREATE_END_TIME"];
//		[self.saveSelFunnelDict removeObjectForKey:@"FOLLOW_TIME"];
		
		[weakSelf.saveSelTimeDict removeObjectForKey:@"FOLLOW_START_TIME"];
		[weakSelf.saveSelTimeDict removeObjectForKey:@"FOLLOW_END_TIME"];
//		[self.saveSelFunnelDict removeObjectForKey:@"LASTUPDATE_TIME"];
		
		[weakSelf.saveSelTimeDict removeObjectForKey:@"CUSTOMERFAIL_START_TIME"];
		[weakSelf.saveSelTimeDict removeObjectForKey:@"CUSTOMERFAIL_END_TIME"];
        
        [weakSelf.saveSelTimeDict removeObjectForKey:@"LASTFOLLOW_START_TIME"];
        [weakSelf.saveSelTimeDict removeObjectForKey:@"LASTFOLLOW_END_TIME"];
		
//		[self.saveSelFunnelDict removeObjectForKey:@"CREATE_TIME"];
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
        [menuView hide];
        //显示 左边的view
        [funnelView show];
    };

 
    //要写在 chooseView  加载完之后
    


    
    
}


-(void)setupRefresh{
    DBSelf(weakSelf);
    self.pagen=20;
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pages=1;
//		self.segmentedControl.userInteractionEnabled = NO;
		if (weakSelf.segmentedControl.selectedSegmentIndex == 0) {
			[weakSelf getListDatas];
		} else {
			[weakSelf httpGetSeaList];
		}
//		if ([weakSelf.isListOrSea isEqualToString:@"list"]) {
//			[weakSelf getListDatas];
//		} else {
//			[weakSelf httpGetSeaList];
//		}
		
        
    }];
    
    self.tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pages++;
//		self.segmentedControl.userInteractionEnabled = NO;
		if ([weakSelf.isListOrSea isEqualToString:@"list"]) {
			[weakSelf getListDatas];
		} else {
			[weakSelf httpGetSeaList];
		}
    
    }];

//    [self.tableView.mj_header beginRefreshing];
    
}

#pragma mark - tableview datasource / delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	
    return [self.isListOrSea isEqualToString:@"list"] ? self.allListDatas.count : self.seaDataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if ([self.isListOrSea isEqualToString:@"list"]) {
		PotentailCustomerListModel*model=self.allListDatas[section];
		return model.content.count;
	} else {
		MJKCustomerSeaModel *seaModel = self.seaDataArray[section];
		return seaModel.content.count;
	}
	
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PotentailCustomerListCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
	if ([self.isListOrSea isEqualToString:@"list"]) {
		PotentailCustomerListModel*model=self.allListDatas[indexPath.section];
		PotentailCustomerListDetailModel*detailModel=model.content[indexPath.row];
        detailModel.C_A41500_C_ID = detailModel.C_ID;
		cell.detailModel=detailModel;
		cell.isNewAssign=self.isNewAssign;
        cell.phoneLayout.constant = 8;
        cell.detailLayout.constant = 8;
		
		if (indexPath.row==model.content.count-1) {
			cell.bottomVIewLeftValue.constant=0;
		}else{
			cell.bottomVIewLeftValue.constant=15;
		}
	} else {
		MJKCustomerSeaModel *model = self.seaDataArray[indexPath.section];
		MJKCustomerSeaSubModel *subModel = model.content[indexPath.row];
		cell.seaModel = subModel;
		cell.isNewAssign = self.isNewAssign;
		
	}
	
	
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	PotentailCustomerListDetailModel*detailModel;
	MJKCustomerSeaSubModel *subModel;
	if ([self.isListOrSea isEqualToString:@"list"]) {
		PotentailCustomerListModel*model=self.allListDatas[indexPath.section];
		detailModel = model.content[indexPath.row];
        detailModel.C_A41500_C_ID = detailModel.C_ID;
	} else  {
		MJKCustomerSeaModel *seaModel = self.seaDataArray[indexPath.section];
		subModel = seaModel.content[indexPath.row];
	}
	
	
	
	
	

    if (self.isNewAssign) {
        //重新分配
        detailModel.isSelected=!detailModel.isSelected;
		subModel.selected = !subModel.isSelected;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }else{
		if (![self.isListOrSea isEqualToString:@"list"]) {
			return;
		}
        if (self.timerType==customerListTimeTypeRecordToFollow) {
            CustomerDetailInfoModel*infoModel=[[CustomerDetailInfoModel alloc]init];
            infoModel.C_ID=detailModel.C_A41500_C_ID;
            infoModel.C_HEADIMGURL=detailModel.C_HEADIMGURL;
            infoModel.C_NAME=detailModel.C_NAME;
            infoModel.C_LEVEL_DD_NAME=detailModel.C_LEVEL_DD_NAME;
            infoModel.C_LEVEL_DD_ID=detailModel.C_LEVEL_DD_ID;
            
          
            //去跟进界面
            CustomerFollowAddEditViewController*vc=[[CustomerFollowAddEditViewController alloc]init];
            vc.vcSuper=self.followVC;
            vc.Type=CustomerFollowUpAdd;
            vc.infoModel=infoModel;
            vc.recordID=self.recordID;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            if (![[NewUserSession instance].appcode containsObject:@"crm:a415:info"]) {
                [JRToast showWithText:@"账号无权限"];
                return;
            }
         //单独的点击  进入 详情页面
        CustomerDetailViewController*vc=[[CustomerDetailViewController alloc]init];
			//客户详情里输入框下面弹框内容，如果是协助就只有新增预约
			[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VCName"];
        vc.mainModel=detailModel;
        [self.navigationController pushViewController:vc animated:YES];
        
        }
    }
    
    
   
    
    
    
}




-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
      if (self.timerType==customerListTimeTypeRecordToFollow) {
          return NO;
      }
    return YES;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    DBSelf(weakSelf);
	if ([self.isListOrSea isEqualToString:@"list"]) {
	
    PotentailCustomerListModel*model=self.allListDatas[indexPath.section];
    PotentailCustomerListDetailModel*detailModel=model.content[indexPath.row];
        detailModel.C_A41500_C_ID = detailModel.C_ID;
    self.detailModel = detailModel;
    
    UITableViewRowAction*phoneAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"电话" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        MyLog(@"1");
        if (![[NewUserSession instance].appcode containsObject:@"APP004_0021"]) {
            [JRToast showWithText:@"账号无权限"];
            return ;
        }
         NSInteger index=indexPath.section*100+indexPath.row;
         [self selectTelephone:index];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
    phoneAction.backgroundColor=DBColor(255,195,0);
    
    
    
//    UITableViewRowAction*failAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"战败" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        MyLog(@"2");
//		if (![[NewUserSession instance].appcode containsObject:@"APP004_0007"]) {
//			[JRToast showWithText:@"账号无权限"];
//			return ;
//		}
//        [self showChooseFailDatasWith:indexPath];
//
//    }];
//    failAction.backgroundColor=DBColor(153,153,153);
		
		UITableViewRowAction*failAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"转出" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
			MyLog(@"2");
			if (![[NewUserSession instance].appcode containsObject:@"crm:a415:zc"]) {
				[JRToast showWithText:@"账号无权限"];
				return;
			}
            NSMutableArray*failChooseArray=[NSMutableArray array];
            NSMutableArray*failChooseCodeArray=[NSMutableArray array];
            for (MJKDataDicModel *model in[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A42500_C_ZRGHLY"] ) {
                [failChooseArray addObject:model.C_NAME];
                [failChooseCodeArray addObject:model.C_VOUCHERID];
                
            }
//            if ([[NewUserSession instance].IS_QKZC isEqualToString:@"A47500_C_STATUS_0000"]) {
                CGCNewAlertDateView *v = [[CGCNewAlertDateView alloc]initWithFrame:self.view.frame withSelClick:^{
                    
                } withSureClick:^(NSString *title,NSString *secondTitle, NSString *dateStr) {
                    NSInteger index = [weakSelf.shopNameArray indexOfObject:title];
                    NSInteger seIndex = [failChooseArray indexOfObject:secondTitle];
                    [MJKHttpApproval DefeatGetHttpValuesWithC_VOUCHERID:weakSelf.shopCodeArray[index] andX_REMARK:dateStr andC_REMARK_TYPE_DD_ID:failChooseCodeArray[seIndex] andC_OBJECT_ID:detailModel.C_ID andTYPE:@"A42500_C_TYPE_0004" andSuccessBlock:^{
                        [weakSelf.tableView.mj_header beginRefreshing];
                    }];
                } withHight:240 withText:@"请选择" withDatas:weakSelf.shopNameArray andSecondChooseArray:failChooseArray];
            if (weakSelf.shopNameArray.count > 0) {
                
                NSInteger index = [weakSelf.shopCodeArray indexOfObject:[NewUserSession instance].user.C_LOCCODE];
                v.textfield.text = weakSelf.shopNameArray[index];
            } else {
                
                v.textfield.placeholder = @"请选择门店";
            }
                v.textfield1.placeholder = @"请选择转出理由";
                v.remarkText.placeholder = @"请填写转出理由";
                [[UIApplication sharedApplication].keyWindow addSubview:v];
                
//            } else {
//               
//                CGCAlertDateView *av = [[CGCAlertDateView alloc]initWithFrame:self.view.frame withSelClick:^{
//                    
//                } withSureClick:^(NSString *title, NSString *dateStr) {
//                    NSInteger index = [failChooseArray indexOfObject:title];
//                    weakSelf.C_GHLX_DD_ID = [failChooseCodeArray objectAtIndex:index];
//                    if (dateStr.length > 0) {
//                        weakSelf.X_GHLY = [dateStr substringFromIndex:title.length];
//                    }
//                    [weakSelf httpCustomerToSeaWithType:@"1" andCustomerId:detailModel.C_A41500_C_ID andSuccessBlock:nil];
//                } withHight:195 withText:@"归还理由" withDatas:failChooseArray];
//                av.remarkText.placeholder=@"请输入归还理由";
//                av.textfield.placeholder=@"请选择归还类型";
//                [[UIApplication sharedApplication].keyWindow addSubview:av];
//            }
            
			
		}];
		failAction.backgroundColor=DBColor(153,153,153);

    
    UITableViewRowAction*moreAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"更多操作" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        MyLog(@"3");
        [self MoreChooseWithIndexPath:indexPath];
        
        
    }];
    moreAction.backgroundColor=DBColor(50,151,234);

    
    
    UITableViewRowAction*activateAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"激活" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
		if (![[NewUserSession instance].appcode containsObject:@"APP004_0006"]) {
			[JRToast showWithText:@"账号无权限"];
			return ;
		}
        UIAlertController *alert=[DBObjectTools getAlertVCwithTitle:@"提示" withMessage:@"是否激活客户?" clickCanel:^{
            
        } sureClick:^{
                [MJKHttpApproval DefeatGetHttpValuesWithC_VOUCHERID:@"" andX_REMARK:@"" andC_REMARK_TYPE_DD_ID:@"" andC_OBJECT_ID:detailModel.C_ID andTYPE:@"A42500_C_TYPE_0001" andSuccessBlock:^{
                    [weakSelf.tableView.mj_header beginRefreshing];
                }];
            
        } canelActionTitle:@"取消" sureActionTitle:@"确定"];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        
        
        
        
    }];
    activateAction.backgroundColor=[UIColor grayColor];

    
		UITableViewRowAction*returnAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"转出" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
			MyLog(@"3");
			if (![[NewUserSession instance].appcode containsObject:@"crm:a415:zc"]) {
				[JRToast showWithText:@"账号无权限"];
				return;
            }
            NSMutableArray*failChooseArray=[NSMutableArray array];
            NSMutableArray*failChooseCodeArray=[NSMutableArray array];
            for (MJKDataDicModel *model in[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A42500_C_ZRGHLY"] ) {
                [failChooseArray addObject:model.C_NAME];
                [failChooseCodeArray addObject:model.C_VOUCHERID];
                
            }
//            if ([[NewUserSession instance].IS_QKZC isEqualToString:@"A47500_C_STATUS_0000"]) {
                CGCNewAlertDateView *v = [[CGCNewAlertDateView alloc]initWithFrame:self.view.frame withSelClick:^{
                    
                } withSureClick:^(NSString *title,NSString *secondTitle, NSString *dateStr) {
                    NSInteger index = [ weakSelf.shopNameArray indexOfObject:title];
                    NSInteger seIndex = [failChooseArray indexOfObject:secondTitle];
                    [MJKHttpApproval DefeatGetHttpValuesWithC_VOUCHERID:weakSelf.shopCodeArray[index] andX_REMARK:dateStr andC_REMARK_TYPE_DD_ID:failChooseCodeArray[seIndex] andC_OBJECT_ID:detailModel.C_ID andTYPE:@"A42500_C_TYPE_0004" andSuccessBlock:^{
                        [weakSelf.tableView.mj_header beginRefreshing];
                    }];
                    
                } withHight:240 withText:@"请选择" withDatas:weakSelf.shopNameArray andSecondChooseArray:failChooseArray];
                v.textfield.placeholder = @"请选择门店";
                v.textfield1.placeholder = @"请选择转出理由";
                v.remarkText.placeholder = @"请填写转出理由";
                
                [[UIApplication sharedApplication].keyWindow addSubview:v];
                
//            } else{
//                
//                CGCAlertDateView *av = [[CGCAlertDateView alloc]initWithFrame:self.view.frame withSelClick:^{
//                    
//                } withSureClick:^(NSString *title, NSString *dateStr) {
//                    NSInteger index = [failChooseArray indexOfObject:title];
//                    weakSelf.C_GHLX_DD_ID = [failChooseArray objectAtIndex:index];
//                    if (dateStr.length > 0) {
//                        weakSelf.X_GHLY = [dateStr substringFromIndex:title.length];
//                    }
//                    [weakSelf httpCustomerToSeaWithType:@"1" andCustomerId:detailModel.C_A41500_C_ID andSuccessBlock:nil];
//                } withHight:195 withText:@"归还理由" withDatas:failChooseArray];
//                av.remarkText.placeholder=@"请输入归还理由";
//                av.textfield.placeholder=@"请选择归还类型";
//                [[UIApplication sharedApplication].keyWindow addSubview:av];
//            }
		}];
		returnAction.backgroundColor=DBColor(50,151,234);
    
    
    
       if ([detailModel.C_STATUS_DD_ID isEqualToString:@"A41500_C_STATUS_0003"]) {
        return @[returnAction,activateAction];
        
    }else{
        //正常 订单 逾期    都3个
        return @[moreAction,failAction,phoneAction];
   

    }
	} else {
		MJKCustomerSeaModel*model=self.seaDataArray[indexPath.section];
		MJKCustomerSeaSubModel*detailModel=model.content[indexPath.row];
		UITableViewRowAction*receiveAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"领用" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
			if (![[NewUserSession instance].appcode containsObject:@"crm:a415_pond:receive"]) {
				[JRToast showWithText:@"账号无权限"];
				return;
			}
            [weakSelf checkCustomerCountWithCompleteBlock:^{
                [weakSelf httpCustomerToSeaWithType:@"3" andCustomerId:detailModel.C_ID andSuccessBlock:nil];
            }];
		}];
		receiveAction.backgroundColor=DBColor(255,195,0);
		
		UITableViewRowAction*assignAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"指派" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
			MyLog(@"3");
			if (![[NewUserSession instance].appcode containsObject:@"crm:a415_pond:assign"]) {
				[JRToast showWithText:@"账号无权限"];
				return;
			}
				_isNewAssign=YES;
			
//            weakSelf.tabBarController.tabBar.hidden = NO;
				//当前的选择的  设置为选中  再刷新
				detailModel.selected = YES;
				[weakSelf.tableView reloadData];
				
//				//底部放个view
//				self.bottomChooseView=[DBAssignBottomChooseView AssignBottomChooseViewAndcancel:^{
//
//					weakSelf.tabBarController.tabBar.hidden = NO;
//					//所有数据  选中状态都设为no   刷新
////					for (MJKCustomerSeaSubModel*model in weakSelf.allListDatas) {
//						for (MJKCustomerSeaSubModel*detailModel in model.content) {
//							detailModel.selected=NO;
//						}
//
////					}
//					weakSelf.isNewAssign=NO;
//					[weakSelf.tableView reloadData];
//					[weakSelf.bottomChooseView removeFromSuperview];
//
//				} allChoose:^{
//					//所有数据 选中状态 都设为yes   刷新
////					for (PotentailCustomerListModel*model in weakSelf.allListDatas) {
//						for (MJKCustomerSeaSubModel*detailModel in model.content) {
//							detailModel.selected=YES;
//						}
//
////					}
//
//					[weakSelf.tableView reloadData];
//
//
//
//				} sure:^{
//					//获取到所有的选中   然后 跳转
//					NSMutableArray*saveAllChooseArray=[NSMutableArray array];
//					self.saveAllSelectedAssignModelArray=saveAllChooseArray;
////					for (PotentailCustomerListModel*model in weakSelf.allListDatas) {
//						for (MJKCustomerSeaSubModel*detailModel in model.content) {
//							if (detailModel.isSelected) {
//								[saveAllChooseArray addObject:detailModel];
//							}
//
//						}
//
////					}
//
//					MyLog(@"saveAllChooseArray===%@",saveAllChooseArray);
//					if (saveAllChooseArray.count<1) {
//						[JRToast showWithText:@"至少选择一条重新分配"];
//						return;
//					}
//
//
//					NSMutableArray*strArray=[NSMutableArray array];
//					for (MJKCustomerSeaSubModel*detailModel in saveAllChooseArray) {
//						[strArray addObject:detailModel.C_ID];
//					}
//					NSString*customerIDS=[strArray componentsJoinedByString:@","];
			
					//跳转  到下一个界面  选择好  销售之后  回调  来用  saveAllChooseArray 的东西和销售吊接口  完成之后 在移除这个view
					MJKChooseEmployeesViewController*vc=[[MJKChooseEmployeesViewController alloc]init];
            if ([[NewUserSession instance].appcode containsObject:@"APP003_0007"]) {
                vc.isAllEmployees = @"是";
            }
            vc.noticeStr = @"无提示";
            vc.chooseEmployeesBlock = ^(MJKClueListSubModel * _Nonnull model) {
						weakSelf.assCodeStr = model.u031Id;
						[weakSelf httpCustomerToSeaWithType:@"3" andCustomerId:detailModel.C_ID andSuccessBlock:^{
//							[weakSelf.bottomChooseView removeFromSuperview];
//							weakSelf.bottomChooseView=nil;
							weakSelf.isNewAssign=NO;
//                            weakSelf.tabBarController.tabBar.hidden = NO;
						}];
						

						
						
						
					};
					[weakSelf.navigationController pushViewController:vc animated:YES];
					
					
//				}];
//				self.bottomChooseView.frame=CGRectMake(0, KScreenHeight-40, KScreenWidth, 40);
//				[self.view addSubview:self.bottomChooseView];
				
			
		}];
		assignAction.backgroundColor=DBColor(153,153,153);
		return @[assignAction,receiveAction];
	}
}

- (void)checkCustomerCountWithCompleteBlock:(void(^)(void))successBlock {
    DBSelf(weakSelf);
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:@"CustomerWebService-validateMaxCustomer"];
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            if ([data[@"FLAG"] isEqualToString:@"soon"]) {
                UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:data[@"message"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *knowAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    if (successBlock) {
                        successBlock();
                    }
                }];
                [ac addAction:knowAction];
                [weakSelf presentViewController:ac animated:YES completion:nil];
            } else if ([data[@"FLAG"] isEqualToString:@"exceed"]){
                //exceed
                UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:data[@"message"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *knowAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
                [ac addAction:knowAction];
                [weakSelf presentViewController:ac animated:YES completion:nil];
            } else {
                if (successBlock) {
                    successBlock();
                }
            }
            
            
        }
        else{
            [JRToast showWithText:data[@"message"]];
        }
        
    }];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView*BGView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 25)];
    BGView.backgroundColor=KColorGrayBGView;
	
    NSString*Strr;
	if ([self.isListOrSea isEqualToString:@"list"]) {
		PotentailCustomerListModel*model=self.allListDatas[section];
		Strr = model.total;
	} else {
		MJKCustomerSeaModel *seaModel = self.seaDataArray[section];
		Strr = seaModel.total;
	}
    
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, KScreenWidth/2, 15)];
    titleLabel.textColor=KColorGrayTitle;
    titleLabel.font=[UIFont systemFontOfSize:14];
    titleLabel.text=Strr;
    [BGView addSubview:titleLabel];
    
    return BGView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 84;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}



#pragma mark  -- click
-(void)addNewPotentailCustomer{
    if ([self.isListOrSea isEqualToString:@"list"]) {
        if (![[NewUserSession instance].appcode containsObject:@"crm:a415:add"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
    }
    AddOrEditlCustomerViewController*vc=[[AddOrEditlCustomerViewController alloc]init];
    vc.Type=customerTypeAdd;
    vc.delegate=self;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
#pragma mark segment or search
- (void)searchAction:(UIButton *)sender {
	sender.selected = !sender.isSelected;
	[sender setImage:sender.isSelected == YES ? @"X图标" : @"搜索按钮"];
	self.navigationItem.titleView=sender.isSelected == YES ? self.CurrentTitleView : [self setSegmentedControl];
	self.segmentedControl.selectedSegmentIndex = [self.isListOrSea isEqualToString:@"list"] ? 0 : 1;
}
#pragma mark list or sea
- (void)selectListOrSea:(UISegmentedControl *)sender {
//	self.pages=1;   APP004_0015
	[self.saveSelTimeDict removeAllObjects];
	[self.saveSelTableDict removeAllObjects];
	[self.saveSelFunnelDict removeAllObjects];
	[self.menuView hide];

//	sender.userInteractionEnabled = NO;
	if (sender.selectedSegmentIndex == 0) {
        
        [self.saveSelTableDict setObject:[NewUserSession instance].configData.C_KHPX forKey:@"TYPE"];
        self.saveSelTableDict[@"C_STATUS_DD_ID"] = @"1";
//		self.isListOrSea = @"list";
//		[self getListDatas];
	} else {
//		self.isListOrSea = @"sea";
//		[self httpGetSeaList];
	}
	[self createChooseView];
	
	[self.tableView.mj_header beginRefreshing];
}


-(void)MoreChooseWithIndexPath:(NSIndexPath*)indexPath{
    DBSelf(weakSelf);
    
    PotentailCustomerListModel*model=self.allListDatas[indexPath.section];
    PotentailCustomerListDetailModel*detailModel=model.content[indexPath.row];
    detailModel.C_A41500_C_ID = detailModel.C_ID;
    
    NSArray*titleArray=@[/* @"设计师",@"归还",*/@"短信",@"微信",@"跟进",@"预约",@"订单",@"指派",@"星标",@"战败",@"任务"];
    NSArray*imageArray;
    if ([detailModel.C_STAR_DD_ID isEqualToString:@"A41500_C_STAR_0000"]) {
        imageArray=@[/* @"设计师",@"icon_transfer",*/@"icon-短信",@"icon-微信",@"more_新增跟进",@"moree_新增预约",@"打印订单",@"重新指派",@"星标客户",@"战败-详情页",@"新增任务1"];
    }else{
        imageArray=@[/* @"设计师",@"icon_transfer",*/@"icon-短信",@"icon-微信",@"more_新增跟进",@"moree_新增预约",@"打印订单",@"重新指派",@"未星标客户",@"战败-详情页",@"新增任务1"];
    }
		
 
    CGCMoreCollection*moreOperation=[[CGCMoreCollection alloc]initWithFrame:self.view.bounds withPicArr:imageArray withTitleArr:titleArray withTitle:@"更多操作" withSelectIndex:^(NSInteger index, NSString *title) {
        MyLog(@"index==%lu,title==%@",index,title);
        if ([title isEqualToString:@"跟进"]) {
			if (![[NewUserSession instance].appcode containsObject:@"crm:a415:gj"]) {
				[JRToast showWithText:@"账号无权限"];
				return ;
			}
//            [JRToast showWithText:@"新增跟进？"];
            CustomerDetailInfoModel*infoModel=[[CustomerDetailInfoModel alloc]init];
            infoModel.C_ID=detailModel.C_A41500_C_ID;
            infoModel.C_HEADIMGURL=detailModel.C_HEADIMGURL;
            infoModel.C_NAME=detailModel.C_NAME;
            infoModel.C_LEVEL_DD_NAME=detailModel.C_LEVEL_DD_NAME;
            infoModel.C_LEVEL_DD_ID=detailModel.C_LEVEL_DD_ID;
            
            
            CustomerFollowAddEditViewController*vc=[[CustomerFollowAddEditViewController alloc]init];
            vc.Type=CustomerFollowUpAdd;
            vc.infoModel=infoModel;
            vc.vcSuper=weakSelf;
            vc.followText=nil;
            [weakSelf.navigationController pushViewController:vc animated:YES];

            
            
            
        }
        
        if ([title isEqualToString:@"预约"]) {
			if (![[NewUserSession instance].appcode containsObject:@"crm:a415:yy"]) {
				[JRToast showWithText:@"账号无权限"];
				return ;
			}
            CGCAppointmentModel*postModel=[[CGCAppointmentModel alloc]init];
            postModel.C_A41500_C_NAME=detailModel.C_NAME;
            postModel.C_A41500_C_ID=detailModel.C_A41500_C_ID;
            postModel.C_PHONE=detailModel.C_PHONE;
            postModel.C_SEX_DD_ID=detailModel.C_SEX_DD_ID;
            postModel.C_SEX_DD_NAME=detailModel.C_SEX_DD_NAME;
            
            
            CGCNewAddAppointmentVC *vc=[[CGCNewAddAppointmentVC alloc] init];
            vc.amodel=postModel;
            vc.rootVC = self;
            [self.navigationController pushViewController:vc animated:YES];

            
        }
        
        if ([title isEqualToString:@"订单"]) {
			if (![[NewUserSession instance].appcode containsObject:@"crm:a415:dd"]) {
				[JRToast showWithText:@"账号无权限"];
				return ;
			}

            
            MJKOrderAddOrEditViewController *vc = [[MJKOrderAddOrEditViewController alloc]init];
            vc.Type = orderTypeAdd;
            NSMutableDictionary *dic = [detailModel yy_modelToJSONObject];
            CGCCustomModel *tempModel = [CGCCustomModel mj_objectWithKeyValues:dic];
            vc.customerModel = tempModel;
            [self.navigationController pushViewController:vc animated:YES];

            
            
            
        }
        
        
        
        
        
        
        
        if ([title isEqualToString:@"指派"]) {
			if (![[NewUserSession instance].appcode containsObject:@"crm:a415:zp"]) {
				[JRToast showWithText:@"账号无权限"];
				return ;
			}
            self.tabBarController.tabBar.hidden = YES;
            _isNewAssign=YES;
//            self.tabBarController.tabBar.hidden = YES;
            //当前的选择的  设置为选中  再刷新
            detailModel.isSelected=YES;
            [weakSelf.tableView reloadData];
            
            //底部放个view
            self.bottomChooseView=[DBAssignBottomChooseView AssignBottomChooseViewAndcancel:^{
//                weakSelf.tabBarController.tabBar.hidden = NO;
//                所有数据  选中状态都设为no   刷新

                self.tabBarController.tabBar.hidden = NO;
                for (PotentailCustomerListModel*model in weakSelf.allListDatas) {
                    for (PotentailCustomerListDetailModel*detailModel in model.content) {
                        detailModel.isSelected=NO;
                    }
                    
                }
                weakSelf.isNewAssign=NO;
                [weakSelf.tableView reloadData];
                [weakSelf.bottomChooseView removeFromSuperview];
                
            } allChoose:^{
                //所有数据 选中状态 都设为yes   刷新
                for (PotentailCustomerListModel*model in weakSelf.allListDatas) {
                    for (PotentailCustomerListDetailModel*detailModel in model.content) {
                        detailModel.isSelected=YES;
                    }
                    
                }
                
                [weakSelf.tableView reloadData];

 
                
            } sure:^{
                //获取到所有的选中   然后 跳转
                NSMutableArray*saveAllChooseArray=[NSMutableArray array];
                self.saveAllSelectedAssignModelArray=saveAllChooseArray;
                for (PotentailCustomerListModel*model in weakSelf.allListDatas) {
                    for (PotentailCustomerListDetailModel*detailModel in model.content) {
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
                for (PotentailCustomerListDetailModel*detailModel in saveAllChooseArray) {
                    detailModel.C_A41500_C_ID = detailModel.C_ID;
                    [strArray addObject:detailModel.C_A41500_C_ID];
                }
                NSString*customerIDS=[strArray componentsJoinedByString:@","];
                
                //跳转  到下一个界面  选择好  销售之后  回调  来用  saveAllChooseArray 的东西和销售吊接口  完成之后 在移除这个view
                MJKChooseEmployeesViewController *vc = [[MJKChooseEmployeesViewController alloc]init];
                if ([[NewUserSession instance].appcode containsObject:@"crm:a415:kdzp"]) {
                    vc.isAllEmployees = @"是";
                }
                vc.noticeStr = @"无提示";
                vc.chooseEmployeesBlock = ^(MJKClueListSubModel * _Nonnull model) {
                    [weakSelf.bottomChooseView removeFromSuperview];
                    weakSelf.bottomChooseView=nil;
                    weakSelf.isNewAssign=NO;
                    
                    [HttpWebObject AssignCustomerToSaleWithSalerID:model.user_id andCustomerIDS:customerIDS success:^(id data) {
                        MyLog(@"%@",data);
                        if ([data[@"code"] integerValue]==200) {

                            self.tabBarController.tabBar.hidden = NO;
                            
                        }else{
                            [JRToast showWithText:data[@"msg"]];
                        }
                        
                        
                        //这里需要调用接口    重新分配的接口
                        [self.tableView.mj_header beginRefreshing];
                    }];
                   
                    
                    
                };
                [weakSelf.navigationController pushViewController:vc animated:YES];
                
                
            }];
            self.bottomChooseView.frame=CGRectMake(0, KScreenHeight-40, KScreenWidth, 40);
            [self.view addSubview:self.bottomChooseView];
         
        }

        
        
		if ([title isEqualToString:@"转出"]) {
			if (![[NewUserSession instance].appcode containsObject:@"crm:a415:zc"]) {
				[JRToast showWithText:@"账号无权限"];
				return;
			}
            
            NSMutableArray*failChooseArray=[NSMutableArray array];
            NSMutableArray*failChooseCodeArray=[NSMutableArray array];
            for (MJKDataDicModel *model in[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41500_C_GHLX"] ) {
                [failChooseArray addObject:model.C_NAME];
                [failChooseCodeArray addObject:model.C_VOUCHERID];
                
            }
            CGCAlertDateView *av = [[CGCAlertDateView alloc]initWithFrame:self.view.frame withSelClick:^{
                
            } withSureClick:^(NSString *title, NSString *dateStr) {
                NSInteger index = [failChooseArray indexOfObject:title];
                weakSelf.C_GHLX_DD_ID = [failChooseArray objectAtIndex:index];
                if (dateStr.length > 0) {
                    weakSelf.X_GHLY = [dateStr substringFromIndex:title.length];
                }
                [weakSelf httpCustomerToSeaWithType:@"1" andCustomerId:detailModel.C_A41500_C_ID andSuccessBlock:nil];
            } withHight:195 withText:@"转出理由" withDatas:failChooseArray];
            av.remarkText.placeholder=@"请输入转出理由";
            av.textfield.placeholder=@"请选择转出类型";
            [[UIApplication sharedApplication].keyWindow addSubview:av];
			
		}
        
        
        
        
        if ([title isEqualToString:@"星标"]) {
            if (![[NewUserSession instance].appcode containsObject:@"crm:a415:xb"]) {
                [JRToast showWithText:@"账号无权限"];
                return;
            }
        
            NSString*starID;
            if ([detailModel.C_STAR_DD_ID isEqualToString:@"A41500_C_STAR_0000"]) {
                starID=@"A41500_C_STAR_0001";
            }else{
                starID=@"A41500_C_STAR_0000";
            }
            
            NSString*customerID=detailModel.C_A41500_C_ID;
            
            [HttpWebObject setStarStatusWithStarID:starID andCustomerID:customerID success:^(id data) {
                MyLog(@"%@",data);
                if ([data[@"code"] integerValue]==200) {
//                    [JRToast showWithText:data[@"message"]];
                    [self.tableView.mj_header beginRefreshing];
                }else{
                    [JRToast showWithText:data[@"msg"]];
                }
            
            }];
     
        }

        
        
        
        
        
        
        if ([title isEqualToString:@"短信"]) {
            if (![[NewUserSession instance].appcode containsObject:@"APP004_0022"]) {
                [JRToast showWithText:@"账号无权限"];
                return ;
            }
//            [self messageClick:detailModel];
            
            CGCTemplateVC*vc=[[CGCTemplateVC alloc]init];
            vc.templateType=CGCTemplateMessage;
            vc.titStr=detailModel.C_NAME;
            vc.customPhoneArr =[@[detailModel.C_PHONE] mutableCopy];
            
            vc.cusDetailModel.C_ID=detailModel.C_A41500_C_ID;
            vc.cusDetailModel.C_HEADIMGURL=detailModel.C_HEADIMGURL;
            vc.cusDetailModel.C_NAME=detailModel.C_NAME;
            vc.cusDetailModel.C_LEVEL_DD_NAME=detailModel.C_LEVEL_DD_NAME;
            vc.cusDetailModel.C_LEVEL_DD_ID=detailModel.C_LEVEL_DD_ID;
            
            [self.navigationController pushViewController:vc animated:YES];

            
            
        }
        
        
        
        
        
        
        if ([title isEqualToString:@"微信"]) {
//            [self shareWeiXin:detailModel];
            if (![[NewUserSession instance].appcode containsObject:@"APP004_0023"]) {
                [JRToast showWithText:@"账号无权限"];
                return ;
            }
            CGCTemplateVC*vc=[[CGCTemplateVC alloc]init];
            vc.templateType=CGCTemplateWeiXin;
            vc.titStr=detailModel.C_NAME;
            vc.customIDArr=[@[detailModel.C_A41500_C_ID] mutableCopy];
            
            vc.cusDetailModel.C_ID=detailModel.C_A41500_C_ID;
            vc.cusDetailModel.C_HEADIMGURL=detailModel.C_HEADIMGURL;
            vc.cusDetailModel.C_NAME=detailModel.C_NAME;
            vc.cusDetailModel.C_LEVEL_DD_NAME=detailModel.C_LEVEL_DD_NAME;
            vc.cusDetailModel.C_LEVEL_DD_ID=detailModel.C_LEVEL_DD_ID;
            
            [self.navigationController pushViewController:vc animated:YES];

            
        }
		
//        if ([title isEqualToString:@"协助"]) {
//            NSLog(@"协助");
//            ShowHelpViewController *vc = [[ShowHelpViewController alloc]init];
//            vc.C_A41500_C_ID = detailModel.C_A41500_C_ID;
//            [self.navigationController pushViewController:vc animated:YES];
//        }
        if ([title isEqualToString:@"设计师"]) {
//            if (![[NewUserSession instance].appcode containsObject:@"APP004_0012"]) {
//                [JRToast showWithText:@"账号无权限"];
//                return;
//            }
            AddHelperViewController *vc = [[AddHelperViewController alloc]init];
            vc.vcName = @"设计师";
            vc.userBlock = ^(NSString *nameStr, NSString *codeStr) {
                [weakSelf HttpAddDesignerWithAndCustomer:detailModel.C_ID andDesigner:codeStr];
            };
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }//
        
        if ([title isEqualToString:@"战败"]) {
            if (![[NewUserSession instance].appcode containsObject:@"crm:a415:zb"]) {
                [JRToast showWithText:@"账号无权限"];
                return ;
            }
            //战败
            NSMutableArray*failChooseArray=[NSMutableArray array];
            NSMutableArray *failChooseCodeArray = [NSMutableArray array];
            for (MJKDataDicModel *model in[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A42500_C_REMARK_TYPE"] ) {
                [failChooseArray addObject:model.C_NAME];
                [failChooseCodeArray addObject:model.C_VOUCHERID];
            }
            
            
            
            CGCAlertDateView *alertDate=[[CGCAlertDateView alloc] initWithFrame:self.view.bounds  withSelClick:^{
                
            } withSureClick:^(NSString *title, NSString *dateStr) {
                if (dateStr.length>0) {
                    MyLog(@"11--%@   22---%@",title,dateStr);
                    NSInteger index = [failChooseArray indexOfObject:title];
                    [MJKHttpApproval DefeatGetHttpValuesWithC_VOUCHERID:@"" andX_REMARK:dateStr andC_REMARK_TYPE_DD_ID:failChooseCodeArray[index] andC_OBJECT_ID:detailModel.C_ID andTYPE:@"A42500_C_TYPE_0000" andSuccessBlock:^{
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }];
                }else{
                    [JRToast showWithText:@"战败类型和战败理由必填才能提交"];
                }
                
            } withHight:195.0 withText:@"请填写战败信息" withDatas:failChooseArray];
            alertDate.VCName = @"必填";
            alertDate.remarkText.placeholder=@"请输入战败理由";
            alertDate.textfield.placeholder=@"请选择战败类型";
            
            
            
            [self.view addSubview:alertDate];
        }
        
        if ([title isEqualToString:@"任务"]) {
            
           
            if (![[NewUserSession instance].appcode containsObject:@"APP007_0002"]) {
                [JRToast showWithText:@"账号无权限"];
                return ;
            }
            
            //任务
            ServiceTaskAddViewController *vc = [[ServiceTaskAddViewController alloc]init];
            vc.title = @"新增任务";
            vc.detailModel = [[ServiceTaskDetailModel alloc]init];
            vc.detailModel.C_A41500_C_ID = detailModel.C_A41500_C_ID;
            vc.detailModel.C_A41500_C_NAME = detailModel.C_NAME;
            vc.detailModel.C_ADDRESS = detailModel.C_ADDRESS;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:moreOperation];
    
}


-(void)showChooseFailDatasWith:(NSIndexPath*)indexPath{
    DBSelf(weakSelf);
    PotentailCustomerListModel*model=self.allListDatas[indexPath.section];
    PotentailCustomerListDetailModel*detailModel=model.content[indexPath.row];
    detailModel.C_A41500_C_ID = detailModel.C_ID;

    
    
    NSMutableArray*failChooseArray=[NSMutableArray array];
    NSMutableArray *failChooseCodeArray = [NSMutableArray array];
    for (MJKDataDicModel *model in[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A42500_C_REMARK_TYPE"] ) {
        [failChooseArray addObject:model.C_NAME];
        [failChooseCodeArray addObject:model.C_VOUCHERID];
    }
    

    
    CGCAlertDateView *alertDate=[[CGCAlertDateView alloc] initWithFrame:self.view.bounds  withSelClick:^{
        
    } withSureClick:^(NSString *title, NSString *dateStr) {
         MyLog(@"11--%@   22---%@",title,dateStr);
        if (dateStr.length<1) {

           [JRToast showWithText:@"战败类型和战败理由必填才能提交"];
          
        
        }else{
            NSString*remarkReason=[NSString stringWithFormat:@"%@,%@",title,dateStr];
            
            NSInteger index = [failChooseArray indexOfObject:title];
            [MJKHttpApproval DefeatGetHttpValuesWithC_VOUCHERID:@"" andX_REMARK:dateStr andC_REMARK_TYPE_DD_ID:failChooseCodeArray[index] andC_OBJECT_ID:detailModel.C_ID andTYPE:@"A42500_C_TYPE_0000" andSuccessBlock:^{
                [weakSelf getListDatas];
            }];
 
        }
        
    } withHight:195.0 withText:@"请填写战败信息" withDatas:failChooseArray];
    
    alertDate.remarkText.placeholder=@"请输入战败理由";
    alertDate.textfield.placeholder=@"请选择战败类型";
    
    
    [[UIApplication sharedApplication].keyWindow addSubview:alertDate];

    
    
}



-(void)showTimeAlertVC{
    //自定义的选择时间界面。
    DBSelf(weakSelf);
    CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
        
    } withEnd:^{
        
    } withSure:^(NSString *start, NSString *end) {
        weakSelf.pagen = 10;
        weakSelf.pages = 1;
//        weakSelf.startTime=start;
//        weakSelf.endTime=end;
//        weakSelf.shopTimeCode =@"";
//        [weakSelf getClueListDatas];
    }];
    [self.view addSubview:dateView];
}

//重写
//电话
- (void)telephoneCall:(NSInteger)index{
    
    
    long section=index/100;
    int row=index%100;
    
    if (self.allListDatas.count<section||[[self.allListDatas[section] content] count]<row) {
        [JRToast showWithText:@"section row 错误"];
        return;
    }

    
    PotentailCustomerListModel*model=self.allListDatas[section];
    PotentailCustomerListDetailModel*detailModel=model.content[row];
    detailModel.C_A41500_C_ID = detailModel.C_ID;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:detailModel.C_PHONE]]];
}


- (void)whbcallBack:(NSInteger)index {
    long section=index/100;
    int row=index%100;
    
    if (self.allListDatas.count<section||[[self.allListDatas[section] content] count]<row) {
        [JRToast showWithText:@"section row 错误"];
        return;
    }

    
    PotentailCustomerListModel*model=self.allListDatas[section];
    PotentailCustomerListDetailModel*detailModel=model.content[row];
    detailModel.C_A41500_C_ID = detailModel.C_ID;
    if (detailModel.C_PHONE.length > 0) {
    [DBObjectTools whbCallWithC_OBJECT_ID:detailModel.C_ID andC_CALL_PHONE:detailModel.C_PHONE andC_NAME:detailModel.C_NAME andC_OBJECTTYPE_DD_ID:@"A83100_C_OBJECTTYPE_0001" andCompleteBlock:nil];
    } else {
       [JRToast showWithText:@"无电话号码"];
   }
}


//座机
- (void)landLineCall:(NSInteger)index{
    
    long section=index/100;
    int row=index%100;
    if (self.allListDatas.count<section||[[self.allListDatas[section] content] count]<row) {
        [JRToast showWithText:@"section row 错误"];
        return;
    }
    PotentailCustomerListModel*model=self.allListDatas[section];
    PotentailCustomerListDetailModel*detailModel=model.content[row];
    detailModel.C_A41500_C_ID = detailModel.C_ID;

    
    CommonCallViewController *myView=[[CommonCallViewController alloc]initWithNibName:@"CommonCallViewController" bundle:nil];
    myView.typeStr=@"用座机拨打";
    myView.nameStr=detailModel.C_NAME;
    myView.callStr=detailModel.C_PHONE;
    [self.navigationController pushViewController:myView animated:YES];
    
}

//回呼
- (void)callBack:(NSInteger)index{
    long section=index/100;
    int row=index%100;
    if (self.allListDatas.count<section||[[self.allListDatas[section] content] count]<row) {
        [JRToast showWithText:@"section row 错误"];
        return;
    }
    PotentailCustomerListModel*model=self.allListDatas[section];
    PotentailCustomerListDetailModel*detailModel=model.content[row];
    detailModel.C_A41500_C_ID = detailModel.C_ID;

    CommonCallViewController *myView=[[CommonCallViewController alloc]initWithNibName:@"CommonCallViewController" bundle:nil];
    myView.typeStr=@"回呼到手机";
    myView.nameStr=detailModel.C_NAME;
    myView.callStr=detailModel.C_PHONE;
    [self.navigationController pushViewController:myView animated:YES];
    
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
        CustomerDetailInfoModel*infoModel=[[CustomerDetailInfoModel alloc]init];
        infoModel.C_ID=weakSelf.detailModel.C_A41500_C_ID;
        infoModel.C_HEADIMGURL=weakSelf.detailModel.C_HEADIMGURL;
        infoModel.C_NAME=weakSelf.detailModel.C_NAME;
        infoModel.C_LEVEL_DD_NAME=weakSelf.detailModel.C_LEVEL_DD_NAME;
        infoModel.C_LEVEL_DD_ID=weakSelf.detailModel.C_LEVEL_DD_ID;
        infoModel.C_STAGE_DD_ID = weakSelf.detailModel.C_STAGE_DD_ID;
        infoModel.C_STAGE_DD_NAME = weakSelf.detailModel.C_STAGE_DD_NAME;
        
        
        CustomerFollowAddEditViewController*vc=[[CustomerFollowAddEditViewController alloc]init];
        vc.Type=CustomerFollowUpAdd;
        vc.infoModel=infoModel;
        vc.vcSuper=weakSelf;
        vc.followText=nil;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [alertV addAction:cancelAction];
    [alertV addAction:trueAction];
    
    [self presentViewController:alertV animated:YES completion:nil];
}



////短信
//- (void)messageClick:(PotentailCustomerListDetailModel *)model{
//    
//    SendMessageViewController *myView=[[SendMessageViewController alloc]initWithNibName:@"SendMessageViewController" bundle:nil];
//    myView.Name=model.C_NAME;
//    myView.PhoneNumber=model.C_PHONE;
//    myView.CustomerID=model.C_A41500_C_ID;
//    myView.Type=@"duanxin";
//    [self.navigationController pushViewController:myView animated:YES];
//    
//}
//
////微信
//- (void)shareWeiXin:(PotentailCustomerListDetailModel *)model{
//    SendMessageViewController *myView=[[SendMessageViewController alloc]initWithNibName:@"SendMessageViewController" bundle:nil];
//    myView.Name=model.C_NAME;
//    myView.PhoneNumber=model.C_PHONE;
//    myView.CustomerID=model.C_A41500_C_ID;
//    myView.Type=@"weixin";
//    
//    [self.navigationController pushViewController:myView animated:YES];
//    
//}

#pragma mark  --delegate
-(void)DelegateForCompleteAddCustomerShowAlertVCToFollow:(CustomerDetailInfoModel *)newModel{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction*cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction*sure=[UIAlertAction actionWithTitle:@"新增跟进" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [DBObjectTools httpPostGetCustomerDetailInfoWithC_ID:newModel.C_A41500_C_ID andCompleteBlock:^(CustomerDetailInfoModel *customerDetailModel) {
                CustomerFollowAddEditViewController*vc=[[CustomerFollowAddEditViewController alloc]init];
                vc.Type=CustomerFollowUpAdd;
                customerDetailModel.C_A41500_C_ID=customerDetailModel.C_ID;
                vc.infoModel=customerDetailModel;
                vc.vcSuper=self;
                vc.followText=nil;
                [self.navigationController pushViewController:vc animated:YES];
            }];
            
        }];
        UIAlertAction*car=[UIAlertAction actionWithTitle:@"新增二手车源" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            MJKAddOrEditCarSourceViewController *vc = [[MJKAddOrEditCarSourceViewController alloc]init];
            vc.type = CarSourceAdd;
            vc.vcName = @"客户新增二手车";
            vc.customerModel = newModel;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [alertVC addAction:cancel];
        [alertVC addAction:sure];
        if ([newModel.C_BUYTYPE_DD_ID isEqualToString:@"A41500_C_BUYTYPE_0002"]) {
            [alertVC addAction:car];
        }
        [self presentViewController:alertVC animated:YES completion:nil];

        
        
    });
    
    
    
}

#pragma mark 门店
-(void)getShopValues{
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/crm/a403/list", HTTP_IP] parameters:@{} compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.shopCodeArray = [NSMutableArray array];
            weakSelf.shopNameArray = [NSMutableArray array];
        
            NSArray *itemArray=[data objectForKey:@"data"];
            for (int i = 0; i < itemArray.count; i++) {
                [weakSelf.shopNameArray addObject:itemArray[i][@"C_NAME"]];
                [weakSelf.shopCodeArray addObject:itemArray[i][@"C_LOCCODE"]];
            }
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
    
    
    
    
}



- (void)httpGetUserListWithModelArrayBlock:(void(^)(NSArray *saleArray))saleArrayBlock{
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
            
            
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}



//设计师
- (void)HttpAddDesignerWithAndCustomer:(NSString *)customerID andDesigner:(NSString *)designer {
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:@"CustomerWebService-operationDesigner"];
    NSMutableDictionary *contentDict = [NSMutableDictionary dictionary];
    contentDict[@"C_ID"] = customerID;
    contentDict[@"C_DESIGNER_ROLEID"] = designer;
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            [JRToast showWithText:data[@"message"]];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
         
    }];
}



-(void)getListDatas{
   
    
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
    [contentDict setObject:@(self.pages) forKey:@"pageNum"];
    [contentDict setObject:@(self.pagen) forKey:@"pageSize"];
    
    if (self.searchStr.length > 0) {
        contentDict[@"SEARCH_NAMEORCONTACT"] = self.searchStr;
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
		

        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
				self.isListOrSea = @"list";
            if (self.pages==1) {
                [self.allListDatas removeAllObjects];
            }
            
            for (NSDictionary*dict in data[@"data"][@"content"]) {
                PotentailCustomerListModel*model=[PotentailCustomerListModel yy_modelWithDictionary:dict];
                [self.allListDatas addObject:model];
            }
            
            NSNumber*number=data[@"data"][@"countNumber"];
            self.allNumberLabel.text=[NSString stringWithFormat:@"总计:%@",number];
            
            [self.tableView reloadData];
			[self.tableView.mj_header endRefreshing];
			[self.tableView.mj_footer endRefreshing];
			
            
        }else{
            [JRToast showWithText:data[@"msg"]];
			[self.tableView.mj_header endRefreshing];
			[self.tableView.mj_footer endRefreshing];
        }
		
        
        
    }];
    
	
}


//得到市场活动
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

#pragma mark sea list
- (void)httpGetSeaList {
	DBSelf(weakSelf);
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	dict[@"pageNum"] = [NSString stringWithFormat:@"%ld",self.pages];
	dict[@"pageSize"] = [NSString stringWithFormat:@"%ld",self.pagen];
	if (self.searchStr.length > 0) {
		dict[@"SEARCH_NAMEORCONTACT"] = self.searchStr;
	}
	
	[self.saveSelTableDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
		[dict setObject:obj forKey:key];
	}];
	[self.saveSelTimeDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
		[dict setObject:obj forKey:key];
	}];
	
//    saveSelFunnelDict
    [self.saveSelFunnelDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [dict setObject:obj forKey:key];
    }];
	HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a415/pondList", HTTP_IP] parameters:dict compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
                self.isListOrSea = @"sea";
            
            if (self.pages == 1) {
                [weakSelf.seaDataArray removeAllObjects];
            }
            [weakSelf.seaDataArray addObjectsFromArray:[MJKCustomerSeaModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"content"]]];
            NSNumber*number=data[@"countNumber"];
            weakSelf.allNumberLabel.text=[NSString stringWithFormat:@"总计:%@",number];
            [weakSelf.tableView reloadData];
            
//            weakSelf.segmentedControl.userInteractionEnabled = YES;
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
    
//	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
//		MyLog(@"%@",data);
//		if ([data[@"code"] integerValue]==200) {
//				self.isListOrSea = @"sea";
//
//			if (self.pages == 1) {
//				[weakSelf.seaDataArray removeAllObjects];
//			}
//			[weakSelf.seaDataArray addObjectsFromArray:[MJKCustomerSeaModel mj_objectArrayWithKeyValuesArray:data[@"content"]]];
//			NSNumber*number=data[@"countNumber"];
//			weakSelf.allNumberLabel.text=[NSString stringWithFormat:@"总计:%@",number];
//			[weakSelf.tableView reloadData];
//
////			weakSelf.segmentedControl.userInteractionEnabled = YES;
//		}else{
//			[JRToast showWithText:data[@"message"]];
//		}
//		[weakSelf.tableView.mj_header endRefreshing];
//		[weakSelf.tableView.mj_footer endRefreshing];
//
//	}];
}

#pragma mark customer to sea
- (void)httpCustomerToSeaWithType:(NSString *)type andCustomerId:(NSString *)customerID andSuccessBlock:(void(^)(void))completeBlock {
	DBSelf(weakSelf);
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	
	dict[@"C_BACKPOND_TYPE"] = type;
//		dict[@"C_GRPCODE"] = [NewUserSession instance].user.C_GRPCODE;
//		dict[@"C_ORGCODE"] = [NewUserSession instance].user.C_ORGCODE;
//		dict[@"C_LOCCODE"] = [NewUserSession instance].user.C_LOCCODE;
		dict[@"USER_ID"] = self.isNewAssign == YES ? self.assCodeStr : [NewUserSession instance].user.u051Id;
//
//	dict[@"C_ID"] = customerID;
    dict[@"ids"] = @[customerID];
	
    if ([type isEqualToString:@"1"]) {
        if (self.C_GHLX_DD_ID.length > 0) {
            dict[@"C_GHLX_DD_ID"] = self.C_GHLX_DD_ID;
        }
        if (self.X_GHLY.length > 0) {
            dict[@"X_GHLY"] = self.X_GHLY;
        }
    }
	if (self.isNewAssign == YES) {
		//@"3" 领用
		dict[@"IS_ASSIGN"] = @"1";
	}
	
	HttpManager*manager=[[HttpManager alloc]init];
    
    [manager postNewDataFromNetworkWithUrl:[NSString stringWithFormat:@"%@/api/crm/a415/operationCustomerPond", HTTP_IP] parameters:dict compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            if ([type isEqualToString:@"1"]) {
                [JRToast showWithText:@"转出成功"];
            } else if ([type isEqualToString:@"3"]) {
                if (self.isNewAssign == YES) {
                    if ([data[@"FLAG"] isEqualToString:@"soon"]) {
                        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:data[@"message"] preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *knowAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [JRToast showWithText:@"指派成功"];
                        }];
                        [ac addAction:knowAction];
                        [weakSelf presentViewController:ac animated:YES completion:nil];
                    } else if ([data[@"FLAG"] isEqualToString:@"exceed"]){
                        //exceed
                        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:data[@"message"] preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *knowAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
                        [ac addAction:knowAction];
                        [weakSelf presentViewController:ac animated:YES completion:nil];
                    }
                }  else {
                    [JRToast showWithText:@"领用成功"];
                }
            }
            if (completeBlock) {
                completeBlock();
            }
            [weakSelf.tableView.mj_header beginRefreshing];
        } else if ([data[@"code"] integerValue]==201){
            [JRToast showWithText:data[@"msg"]];
        }  else {
            [JRToast showWithText:data[@"msg"]];
        }
        
        
    }];

}


-(void)createChooseView{
    DBSelf(weakSelf);
	
	
		if (self.segmentedControl.selectedSegmentIndex == 0) {
//
//
        [weakSelf getActionOfMarketComplication:^(NSArray<MJKFunnelChooseModel*> *actionMarketArray) {

//
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
//
//
//
//
//
//
//            //市场活动
            NSString*str9=@"渠道细分";
            NSDictionary*dic9=@{@"title":str9,@"content":actionMarketArray};

//
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
//
//
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
            // 注:  需先 赋值数据源dataSourceArr二维数组  再赋值defaulTitleArray一维数组hj35121062
            
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
                    if (self.segmentedControl.selectedSegmentIndex == 0) {
                        
                    
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
                    } else {
                        if ([indexStr isEqualToString:@"0"]) {
                            //战败原因
                            [weakSelf.saveSelFunnelDict setObject:model.c_id forKey:@"C_CUSTOMERFAIL_DD_ID"];
                        }
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
         
            //要写在 chooseView  加载完之后
		} else {
			//公海
			//原负责人
            [weakSelf httpGetUserListWithModelArrayBlock:^(NSArray *saleArray) {
				
				NSMutableArray*saleArr=[NSMutableArray arrayWithObjects:@"全部",@"我的", nil];
				NSMutableArray*saleSelectedArr=[NSMutableArray arrayWithObjects:@"",[NewUserSession instance].user.u051Id, nil];
                for (MJKNewUserModel* model in saleArray) {
                    [saleArr addObject:model.nickName.length > 0 ? model.nickName : @""];
                    [saleSelectedArr addObject:model.u051Id.length > 0 ? model.u051Id : @""];
                }
				//归还原因
				NSMutableArray*returnPeopleArr=[NSMutableArray arrayWithObjects:@"全部", nil];
				NSMutableArray*returnPeopleSelectedArr=[NSMutableArray arrayWithObjects:@"", nil];
				for (MJKDataDicModel*model in [[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41500_C_GHLX"]) {
					[returnPeopleArr addObject:model.C_NAME];
					[returnPeopleSelectedArr addObject:model.C_VOUCHERID];
					
				}
				
				//转入时间
				NSMutableArray*timeArray=[NSMutableArray array];
				NSMutableArray *timeCodeArray = [NSMutableArray array];
				
                NSArray * array14=@[@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"今年",@"去年",@"最近7天",@"最近30天",@"自定义"];
                NSArray * arraySel14=@[@"", @"1", @"2", @"3", @"4", @"5", @"6", @"9", @"10", @"7",@"30",@"999"];
				for (int i=0; i<array14.count; i++) {
					[timeArray addObject:array14[i]];
					[timeCodeArray addObject:arraySel14[i]];
				}
                
                
//                NSMutableArray*failChooseArray=[NSMutableArray array];
//                NSMutableArray*failChooseCodeArray=[NSMutableArray array];
//                NSArray * arrayCS=@[@"全部",@"1次",@"2次",@"3次",@"4次",@"5次",@"5次以上"];
//                NSArray * arrayCodeCS=@[@"0", @"1", @"2", @"3", @"4", @"5", @"6"];
//                for (int i=0; i<arrayCS.count; i++) {
//                    [failChooseArray addObject:arrayCS[i]];
//                    [failChooseCodeArray addObject:arrayCodeCS[i]];
//                }
//
                //归还原因
                NSMutableArray*failChooseArray=[NSMutableArray arrayWithObjects:@"全部", nil];
                NSMutableArray*failChooseCodeArray=[NSMutableArray arrayWithObjects:@"", nil];
                for (MJKDataDicModel*model in [[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41500_C_CHANGEINTO"]) {
                    [failChooseArray addObject:model.C_NAME];
                    [failChooseCodeArray addObject:model.C_VOUCHERID];
                    
                }
            /*
             传1：1次
             传2：2次
             传3：3次
             传4：4次
             传5：5次
             传6：5次以上
             */
				//总的 筛选tableView 的数据
				NSMutableArray*totailTableDatas=[NSMutableArray arrayWithObjects:saleArr,returnPeopleArr,timeArray,failChooseArray, nil];
				self.TableChooseDatas=totailTableDatas;
				NSMutableArray*totailTAbleSelected=[NSMutableArray arrayWithObjects:saleSelectedArr,returnPeopleSelectedArr,timeCodeArray,failChooseCodeArray, nil];
				self.TableSelectedChooseDatas=totailTAbleSelected;
				
                
                NSString*Str13=@"战败原因";
                NSMutableArray*mtArr13=[NSMutableArray array];
                MJKFunnelChooseModel*Model13=[[MJKFunnelChooseModel alloc]init];
                Model13.name=@"全部";
                Model13.c_id=@"";
                [mtArr13 addObject:Model13];
                for (MJKDataDicModel*model in [[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A42500_C_REMARK_TYPE"]) {
                    MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
                    funnelModel.name=model.C_NAME;
                    funnelModel.c_id=model.C_VOUCHERID;
                    [mtArr13 addObject:funnelModel];
                }
                NSDictionary*dic13=@{@"title":Str13,@"content":mtArr13};
				//漏斗
				self.FunnelDatas=[@[dic13]mutableCopy];
				
				[self addChooseView];
			}];
			
			
		}
        
		
    
}


#pragma mark - http
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

#pragma mark  -- set
-(UITableView *)tableView {
    if (!_tableView) {
		CGRect rect = CGRectZero;
//		if (self.isTab) {
//			rect = CGRectMake(0, NavStatusHeight + 40, KScreenWidth, KScreenHeight-NavStatusHeight - 40 - WD_TabBarHeight - SafeAreaBottomHeight - WD_TabBarHeight);
//		} else {
			rect = CGRectMake(0, SafeAreaTopHeight + 40, KScreenWidth, KScreenHeight-SafeAreaTopHeight - 40 - WD_TabBarHeight);
//		}
        _tableView=[[UITableView alloc]initWithFrame:rect style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.estimatedRowHeight=0;
        _tableView.estimatedSectionHeaderHeight=0;
        _tableView.estimatedSectionFooterHeight=0;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

-(NSMutableArray<PotentailCustomerListModel *> *)allListDatas{
    if (!_allListDatas) {
        _allListDatas=[NSMutableArray array];
    }
    return _allListDatas;
}

- (NSMutableArray *)seaDataArray {
	if (!_seaDataArray) {
		_seaDataArray = [NSMutableArray array];
	}
	return _seaDataArray;
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



#pragma mark  --funcation




@end
