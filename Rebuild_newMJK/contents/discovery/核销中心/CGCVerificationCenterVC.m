//
//  CGCVerificationCenterVC.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/5/14.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "CGCVerificationCenterVC.h"

#import "VerificationModel.h"
#import "PointorderModel.h"
#import "VerificationDetailVC.h"
#import "CGCVerListCell.h"


#import "CGCCustomCell.h"
#import "CGCCustomModel.h"
#import "CGCCustomDetailModel.h"
#import "CGCNavSearchTextView.h"
#import "CFDropDownMenuView.h"
#import "CGCSellModel.h"
#import "MJKDataDicModel.h"
#import "MJKFunnelChooseModel.h"
#import "CGCCustomDateView.h"


#import "MJKVoiceCViewController.h"
//#import "WLBarcodeViewController.h"
#import "MQVC.h"

@interface CGCVerificationCenterVC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) CGCNavSearchTextView *textNav;

@property (nonatomic, strong) NSMutableArray *shopTimeArr;
@property (nonatomic, strong) NSMutableArray * shopTimeCodeArr;

@property (assign) NSInteger currPage;


@property (nonatomic, strong) CGCSellModel * uploadModel;

@property (nonatomic, strong) NSMutableArray *saveFunnelAllDatas;

@property (nonatomic, strong) UIView *bottomView;


@property(nonatomic,copy)void(^myLocalBlock)();

@property (nonatomic, strong) NSMutableArray *selArr;

@property (nonatomic, strong) CGCCustomModel *flowModel;

@property (nonatomic, strong) UILabel *totalLab;

@property (nonatomic, copy) NSString *totalStr;

@property (nonatomic, strong) UIButton *totalBtn;

@property (nonatomic, copy) NSString *startTime;

@property (nonatomic, copy) NSString *endTime;

@property (nonatomic, copy) NSString *typeStr;

@property (nonatomic, copy) NSString *create_type;

@property (nonatomic, copy) NSString *create_start_time;

@property (nonatomic, copy) NSString *create_end_time;

@property (nonatomic, copy) NSString *stabStr;

//@property (nonatomic, strong) WLBarcodeViewController*CCQRCode;

@end

@implementation CGCVerificationCenterVC

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadList) name:@"RELOADLIST" object:nil];
    self.currPage=1;
    self.totalStr=@"总计:0";
    self.uploadModel=[[CGCSellModel alloc] init];
    [self.view addSubview:self.tableView];
    [self createNav];
    [self chooseView];
    [self getMarketActionDatas];
    [self httpRequestList];
    
    DBSelf(weakSelf);
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currPage=1;
        [weakSelf httpRequestList];
        
    }];
    
    self.tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.currPage++;
        [weakSelf httpRequestList];
        
    }];
    
    if ([self.VCName isEqualToString:@"模板"]) {
        
        //        [[UIApplication sharedApplication].keyWindow addSubview:self.bottomView];
        
        [self.view addSubview:self.bottomView];
    }
}

- (void)reloadList{
    
    self.currPage=1;
    [self httpRequestList];
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.VCName isEqualToString:@"模板"]) {
        self.bottomView.hidden=NO;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.bottomView.hidden=YES;
    
}

- (void)chooseView{
    
    CFDropDownMenuView*menuView=[[CFDropDownMenuView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, 40)];
    
    DBSelf(weakSelf);
        
        
        menuView.dataSourceArr=[@[
                                  @[@"全部",@"已核销",@"待核销"],
                                  weakSelf.shopTimeArr,
                                  weakSelf.shopTimeArr] mutableCopy];
        menuView.defaulTitleArray=@[@"状态",@"兑换日期",@"预约时间"];
        
    
    
    
   
    
    
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
                    weakSelf.stabStr=@"";
                }
                if ([title isEqualToString:@"已核销"]) {
                    weakSelf.stabStr=@"1";
                }
                if ([title isEqualToString:@"待核销"]) {
                    weakSelf.stabStr=@"0";
                }
            
                break;
                
            case 1://日期
                if ([title isEqualToString:@"自定义"]) {
                    DBSelf(weakSelf);
                    CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
                        
                    } withEnd:^{
                        
                    } withSure:^(NSString *start, NSString *end) {
                     
                       
                        weakSelf.currPage = 1;
                        weakSelf.startTime=start;
                        weakSelf.endTime=end;
                        weakSelf.typeStr =@"";
                        [weakSelf httpRequestList];
                    }];
                    [[UIApplication sharedApplication].keyWindow  addSubview:dateView];
                } else {
                    weakSelf.startTime=@"";
                    weakSelf.endTime=@"";
                  
                    weakSelf.typeStr =weakSelf.shopTimeCodeArr[[selectedRow intValue]];
                }
                
                break;
            case 2://日期
                if ([title isEqualToString:@"自定义"]) {
                    DBSelf(weakSelf);
                    CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
                        
                    } withEnd:^{
                        
                    } withSure:^(NSString *start, NSString *end) {
                        
                        
                        weakSelf.currPage = 1;
                        weakSelf.create_start_time=start;
                        weakSelf.create_end_time=end;
                        weakSelf.create_type =@"";
                        [weakSelf httpRequestList];
                    }];
                    [[UIApplication sharedApplication].keyWindow  addSubview:dateView];
                } else {
                    weakSelf.create_start_time=@"";
                    weakSelf.create_end_time=@"";
                    
                    weakSelf.create_type =weakSelf.shopTimeCodeArr[[selectedRow intValue]];
                }
                
                break;
            default:
                break;
        }
        self.currPage=1;
        [weakSelf httpRequestList];
        
    };
    
    
    //这个是筛选的view
    FunnelShowView*funnelView=[FunnelShowView funnelShowView];
    
    NSDictionary * dic1=[self getDateDictWithTitle:@"创建时间" withSid:@"999"];
    NSDictionary * dic2=[self getDateDictWithTitle:@"下次跟进时间" withSid:@"111"];
    NSDictionary * dic3=[self getDateDictWithTitle:@"活跃时间" withSid:@"222"];
    
    //延迟 传入参数
    
    self.myLocalBlock = ^{
        [weakSelf.saveFunnelAllDatas addObject:dic1];
        [weakSelf.saveFunnelAllDatas addObject:dic2];
        [weakSelf.saveFunnelAllDatas addObject:dic3];
        
        funnelView.allDatas=weakSelf.saveFunnelAllDatas;
    };
    //回调
    funnelView.sureBlock = ^(NSMutableArray *array) {
        
        
        for (NSDictionary * dict in array) {
            NSString* index=dict[@"index"];
            MJKFunnelChooseModel * model=dict[@"model"];
            if ([index intValue]==0) {
                self.uploadModel.C_STAR_DD_ID=model.c_id;
            }
            if ([index intValue]==1) {
                self.uploadModel.C_CLUESOURCE_DD_ID=model.c_id;
            }
            if ([index intValue]==2) {
                self.uploadModel.C_A41200_C_ID=model.c_id;
            }
            if ([index intValue]==3) {
                self.uploadModel.CREATE_TIME=model.c_id;
            }
            if ([index intValue]==4) {
                self.uploadModel.FOLLOW_TIME=model.c_id;
            }
            if ([index intValue]==5) {
                self.uploadModel.LASTUPDATE_TIME=model.c_id;
            }
            
            
        }
        self.currPage=1;
        [weakSelf HTTPGetLogList];
        
    };
    [[UIApplication sharedApplication].keyWindow addSubview:funnelView];
    
    //这个是漏斗按钮
    CFRightButton*funnelButton=[[CFRightButton alloc]initWithFrame:CGRectMake( KScreenWidth-40,NavStatusHeight, 40, 40)];
    
//    [self.view addSubview:funnelButton];
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


#pragma mark -- createUI
- (void)createNav{
    
    
    
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    self.view.backgroundColor=CGCTABBGColor;
    DBSelf(weakSelf);
    
    self.textNav=[[CGCNavSearchTextView alloc] initWithFrame:self.view.bounds withPlaceHolder:@"" withRecord:^{//点击录音
        
        MJKVoiceCViewController *voiceVC = [[MJKVoiceCViewController alloc]initWithNibName:@"MJKVoiceCViewController" bundle:nil];
        [voiceVC setBackStrBlock:^(NSString *str){
            if (str.length>0) {
                self.currPage=1;
                self.uploadModel.SEARCH_NAMEORCONTACT=str;
                [weakSelf HTTPGetLogList];
            }
            
        }];
        [weakSelf presentViewController:voiceVC animated:YES completion:nil];
        
    } withText:^{//开始编辑
        NSLog(@"");
    }withEndText:^(NSString *str) {//结束编辑
        self.currPage=1;
        self.uploadModel.SEARCH_NAMEORCONTACT=str;
        [weakSelf HTTPGetLogList];
    }];
    self.navigationItem.titleView=self.textNav;
    
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem MyitemWithImage:@"icon_customer_add" highImage:@"" target:self andAction:@selector(addNewAppointment)];
    
    if (self.textFieldText.length > 0) {
        self.currPage=1;
        self.textNav.textField.text = self.textFieldText;
        self.uploadModel.SEARCH_NAMEORCONTACT=self.textFieldText;
        [weakSelf HTTPGetLogList];
    }
}



- (void)addNewAppointment{
    
    
    
}




#pragma mark -- tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count>0?self.dataArray.count:0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    VerificationModel * model=self.dataArray[section];
    return model.pointorder.count>0?model.pointorder.count:0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGCVerListCell * cell=[CGCVerListCell cellWithTableView:tableView];
    PointorderModel *model=[self.dataArray[indexPath.section] pointorder][indexPath.row];
    [cell verificationCellReloadCell:model];
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DBSelf(weakSelf);
    PointorderModel *model=[self.dataArray[indexPath.section] pointorder][indexPath.row];
    VerificationDetailVC * vcc=[[VerificationDetailVC alloc] init];
    vcc.pModel=model;
    ;
    vcc.hxBlock = ^{
        weakSelf.currPage=1;
        [weakSelf httpRequestList];
    };
    [self.navigationController pushViewController:vcc animated:NO];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
    return YES;
}


- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DBSelf(weakSelf);
    
     PointorderModel *model=[self.dataArray[indexPath.section] pointorder][indexPath.row];
    
    UITableViewRowAction *tel = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                   title:@"拨打电话"
                                                                 handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                   
                                                                     [weakSelf telephone:model.phone];
                                                                 }];
    tel.backgroundColor=DBColor(254,184,11);
    UITableViewRowAction *agin = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                    title:@"扫码核销"
                                                                  handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//                                                                      [weakSelf verification:model];
                                                                  }];
    UITableViewRowAction *shop = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                    title:@"手动核销"
                                                                  handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                      [weakSelf goMQ:model];
                                                                  }];
    
   shop.backgroundColor=DBColor(41,130,228);
   agin.backgroundColor= DBColor(44,165,89);
    NSArray *arr;
    if ([model.status isEqualToString:@"已兑换"]) {
        arr = @[tel];
    }else{
        
        arr = @[shop,agin,tel];
    }
   
   
    
        return arr;
        
   
    
    
}

//电话
- (void)telephone:(NSString *)tel{
        if (tel.length>0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:tel]]];
        }else{
            [JRToast showWithText:@"暂无号码"];
        }
    
}

//- (void)verification:(PointorderModel *)model{
//
//
//    DBSelf(weakSelf);
//    WLBarcodeViewController*QRCode=[[WLBarcodeViewController alloc]initWithBlock:^(NSString *str, BOOL isSuccess) {
//
//        if (isSuccess) {
//            //成功
//            [weakSelf httpRequestQRCodeWithStr:str];
//
//
//        }else{
//            //
//
//
//            [JRToast showWithText:@"无法识别" duration:5];
//
//
//        }
//
//
//    }];
//    self.CCQRCode=QRCode;
//    QRCode.isType=@"isOk";
//    QRCode.qrBlock = ^{
//        [weakSelf goMQ:model];
//    };
//    [self presentViewController:QRCode animated:YES completion:nil];
//
//
//
//
//
//
//
//
//}
- (void)httpRequestQRCodeWithStr:(NSString *)codeStr{
    
    
    DBSelf(weakSelf);
    NSArray * arr=  [codeStr componentsSeparatedByString:@","];
    
    for (NSString * str in arr) {
        if (str.length==0) {
            [JRToast showWithText:@"扫码失败"];
            return;
        }
    }
    
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    [dic setObject:arr[0] forKey:@"phone"];
    [dic setObject:arr[1] forKey:@"takecode"];
    [dic setObject:arr[2] forKey:@"id"];
    
    
    [[POPRequestManger defaultManger] requestWithMethod:POST url:HTTP_pointTake dict:dic target:self finished:^(id responsed) {
        if ([responsed[@"code"] intValue]==200) {
            
            [JRToast showWithText:@"核销成功"];
            weakSelf.currPage=1;
            [weakSelf httpRequestList];
//            [weakSelf.CCQRCode dismissViewControllerAnimated:NO completion:^{
//
//            }];
            
        }else{
            
        }
        
        
    } failed:^(id error) {
        
    }];
}

- (void)goMQ:(PointorderModel*)model{
    MQVC * mvc=[[MQVC alloc] init];
    mvc.sid=model.sid;
    mvc.phone=model.phone;
    [self.navigationController pushViewController:mvc animated:NO];
}
#pragma mark -- request网络请求

- (void)httpRequestList{
     NSMutableDictionary *dic=[NSMutableDictionary new];
//    [dic setObject:[NewUserSession instance].TOKEN forKey:@"usertoken"];
    if (self.stabStr.length>0) {
      [dic setObject:self.stabStr forKey:@"stab"];
    }
    if (self.typeStr.length>0) {
        [dic setObject:self.typeStr forKey:@"type"];
    }
    if (self.startTime.length>0&&self.endTime.length>0) {
        [dic setObject:self.startTime forKey:@"start_time"];
        [dic setObject:self.endTime forKey:@"end_time"];
    }
    
    if (self.create_type.length>0) {
        [dic setObject:self.create_type forKey:@"create_type"];
    }
    if (self.create_start_time.length>0&&self.create_end_time.length>0) {
        [dic setObject:self.create_start_time forKey:@"create_start_time"];
        [dic setObject:self.create_end_time forKey:@"create_end_time"];
    }
    self.uploadModel.SEARCH_NAMEORCONTACT.length>0?[dic setObject:self.uploadModel.SEARCH_NAMEORCONTACT forKey:@"SEARCH_NAMEORCONTACT"]:0;
    [dic setObject:@"true" forKey:@"searchAll"];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.currPage] forKey:@"page"];
    [[POPRequestManger defaultManger] requestWithMethod:POST url:HTTP_pointApplist dict:dic target:self finished:^(id responsed) {
        if ([responsed[@"code"] intValue]==200) {
         
            if (self.currPage==1) {
                [self.dataArray removeAllObjects];
            }

            
           for (NSDictionary * dict in responsed[@"list"]) {
             VerificationModel *model=[VerificationModel yy_modelWithJSON:dict];
             [self.dataArray addObject:model];
           }
           
            if (self.dataArray.count==0) {
                self.tableView.tableFooterView=[[UIView alloc] init];
              
            }else{
                
            }
            
        }else{
              self.currPage>1?self.currPage--:0;
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    } failed:^(id error) {
        self.currPage>1?self.currPage--:0;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
    
}



- (void)HTTPGetLogList{
    
    
    NSMutableDictionary *dic=[NSMutableDictionary new];
    
    
    [dic setObject:@"10" forKey:@"pageSize"];
    [dic setObject:@(self.currPage) forKey:@"pageNum"];
    [dic setObject:@"0" forKey:@"TYPE"];
    self.uploadModel.C_STAR_DD_ID.length>0?[dic setObject:self.uploadModel.C_STAR_DD_ID forKey:@"C_STAR_DD_ID"]:0;
    
    self.uploadModel.C_CLUESOURCE_DD_ID.length>0?[dic setObject:self.uploadModel.C_CLUESOURCE_DD_ID forKey:@"C_CLUESOURCE_DD_ID"]:0;
    
    self.uploadModel.C_A41200_C_ID.length>0?[dic setObject:self.uploadModel.C_A41200_C_ID forKey:@"C_A41200_C_ID"]:0;
    
    self.uploadModel.CREATE_TIME.length>0?[dic setObject:self.uploadModel.CREATE_TIME forKey:@"CREATE_TIME"]:0;
    self.uploadModel.FOLLOW_TIME.length>0?[dic setObject:self.uploadModel.FOLLOW_TIME forKey:@"FOLLOW_TIME"]:0;
    self.uploadModel.LASTUPDATE_TIME.length>0?[dic setObject:self.uploadModel.LASTUPDATE_TIME forKey:@"LASTUPDATE_TIME"]:0;
    
    if ( self.uploadModel.CREATE_TIME.length==0) {
        self.uploadModel.START_TIME.length>0?[dic setObject:self.uploadModel.START_TIME forKey:@"START_TIME"]:0;
        self.uploadModel.END_TIME.length>0?[dic setObject:self.uploadModel.END_TIME forKey:@"END_TIME"]:0;
    }
    if ( self.uploadModel.FOLLOW_TIME.length==0) {
        self.uploadModel.FOLLOW_START_TIME.length>0?[dic setObject:self.uploadModel.FOLLOW_START_TIME forKey:@"FOLLOW_START_TIME"]:0;
        self.uploadModel.FOLLOW_END_TIME.length>0?[dic setObject:self.uploadModel.FOLLOW_END_TIME forKey:@"FOLLOW_END_TIME"]:0;
    }
    if ( self.uploadModel.LASTUPDATE_TIME.length==0) {
        self.uploadModel.LASTUPDATE_START_TIME.length>0?[dic setObject:self.uploadModel.LASTUPDATE_START_TIME forKey:@"LASTUPDATE_START_TIME"]:0;
        self.uploadModel.LASTUPDATE_END_TIME.length>0?[dic setObject:self.uploadModel.LASTUPDATE_END_TIME forKey:@"LASTUPDATE_END_TIME"]:0;
    }
    
    self.uploadModel.SEARCH_NAMEORCONTACT.length>0?[dic setObject:self.uploadModel.SEARCH_NAMEORCONTACT forKey:@"SEARCH_NAMEORCONTACT"]:0;
    
    self.uploadModel.USER_ID.length>0?[dic setObject:self.uploadModel.USER_ID forKey:@"USER_ID"]:0;
    self.uploadModel.C_LEVEL_DD_ID.length>0?[dic setObject:self.uploadModel.C_LEVEL_DD_ID forKey:@"C_LEVEL_DD_ID"]:[dic setObject:@" " forKey:@"C_LEVEL_DD_ID"];
    self.uploadModel.TYPE.length>0?[dic setObject:self.uploadModel.TYPE forKey:@"TYPE"]:0;
    self.uploadModel.C_STATUS_DD_ID.length>0?[dic setObject:self.uploadModel.C_STATUS_DD_ID forKey:@"C_STATUS_DD_ID"]:0;
    
    
    
    dic[@"C_LOCCODE"] = [NewUserSession instance].user.C_LOCCODE;
    HttpManager*manager=[[HttpManager alloc]init];
    
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a415/list", HTTP_IP] parameters:dic compliation:^(id data, NSError *error) {
        
        if ([data[@"code"] integerValue]==200) {
            
            if (self.currPage==1) {
                [self.dataArray removeAllObjects];
            }
            
            for (NSDictionary * div in data[@"data"][@"content"]) {
                CGCCustomDetailModel * model=[CGCCustomDetailModel yy_modelWithDictionary:div];
                
                [self.dataArray addObject:model];
            }
            if (self.dataArray.count==0) {
                self.tableView.tableFooterView=[[UIView alloc] init];
                //                [self createLabStr:@"暂无客户" withbool:NO];
            }else{
                
                //             [self createLabStr:@"" withbool:YES];
            }
            
            
            
            
        }else{
            self.currPage>1?self.currPage--:0;
            
            [JRToast showWithText:data[@"msg"]];
        }
        
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
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
            [weakSelf.saveFunnelAllDatas addObject:dic];
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
    
    VerificationModel *model = self.dataArray[section];
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 20)];
    view.backgroundColor=CGCTABBGColor;
    
    UILabel * lab=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 20)];
    lab.text=model.datetime;
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
            _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, NavStatusHeight + 40, KScreenWidth, KScreenHeight-NavStatusHeight - 40-40 - WD_TabBarHeight) style:UITableViewStylePlain];
        }else{
            _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, NavStatusHeight + 40, KScreenWidth, KScreenHeight-NavStatusHeight - 40 - WD_TabBarHeight) style:UITableViewStylePlain];
        }
        
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.estimatedRowHeight=50;
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

- (NSMutableArray *)saveFunnelAllDatas{
    
    if (_saveFunnelAllDatas==nil) {
        
        NSDictionary * startDict=[self getdictWith:@"A41500_C_STAR" withTitle:@"星标客户"];
        NSDictionary * customDict=[self getdictWith:@"A41300_C_CLUESOURCE" withTitle:@"来源细分"];
        _saveFunnelAllDatas=[NSMutableArray arrayWithArray:@[startDict,customDict]];
        
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
