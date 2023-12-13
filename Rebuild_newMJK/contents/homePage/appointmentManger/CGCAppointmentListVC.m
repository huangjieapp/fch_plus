//
//  CGCAppointmentListVC.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/8/29.
//  Copyright © 2017年 月见黑. All rights reserved.
//预约管理列表

#import "CGCAppointmentListVC.h"

#import "CGCAppointmentCell.h"
#import "CGCAppointmentModel.h"
#import "CGCAppointDetailModel.h"
#import "CGCNavSearchTextView.h"
#import "CGCSellModel.h"
#import "CGCMoreActionView.h"
#import "CGCAlertDateView.h"
#import "CGCCustomDateView.h"

#import "CGCNewAaddAppiontModel.h"
#import "CGCNewAddAppointmentVC.h"
#import "CGCAppiontDetailVC.h"
#import "MJKFunnelChooseModel.h"
#import "MJKClueListViewModel.h"

#import "CFDropDownMenuView.h"
#import "CommonCallViewController.h"
#import "MJKVoiceCViewController.h"

#import "CustomerFollowAddEditViewController.h"
#import "CustomerDetailInfoModel.h"
#import "MJKClueListSubModel.h"

#import "VoiceView.h"


@interface CGCAppointmentListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,strong) NSMutableArray *dataArray;
    
@property (nonatomic,strong) NSMutableArray *sellArray;

@property (nonatomic,strong) CGCNavSearchTextView *titleView;

@property (assign) NSInteger currPage;

@property (nonatomic, copy) NSString *SEARCH_NAMEORCONTACT;
    
@property (nonatomic,strong) CFDropDownMenuView * menuView;

@property (nonatomic,strong) CGCSellModel * sellModel;

@property (nonatomic,strong) CGCMoreActionView * moreView;//更多操作弹层

@property (nonatomic,strong) CGCAlertDateView * alertDateView;

@property (nonatomic, strong) NSMutableDictionary * operationDict;

@property (nonatomic, strong) UILabel *totalLab;

@property (nonatomic, copy) NSString *totalStr;

@property (nonatomic, strong) UIButton *totalBtn;

@property (nonatomic, strong) CGCAppointmentModel *detailModel;
@end

@implementation CGCAppointmentListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.totalStr=@"总计:0";
    [self HTTPGetSellList];
    [self createNav];
//    [self chooseView];
//    self.currPage=1;
//    [self HTTPGetAppointmentList];
    [self.view addSubview:self.tableView];
    
    // Do any additional setup after loading the view.
}

#pragma mark -- createUI
- (void)createNav{
    self.sellModel=[[CGCSellModel alloc] init];
    self.sellModel.IS_ARRIVE_SHOP=self.IS_ARRIVE_SHOP.length>0?self.IS_ARRIVE_SHOP:nil;
    self.sellModel.BOOK_TIME_TYPE=self.BOOK_TIME_TYPE.length>0?self.BOOK_TIME_TYPE:nil;
//	self.sellModel.START_BOOK_TIME=self.END_BOOK_TIME.length>0?self.END_BOOK_TIME:nil;
    self.sellModel.END_BOOK_TIME=self.END_BOOK_TIME.length>0?self.END_BOOK_TIME:nil;
    //START_BOOK_TIME
    self.sellModel.ARRIVE_TIME_TYPE=self.ARRIVE_TIME_TYPE.length>0?self.ARRIVE_TIME_TYPE:nil;
    self.sellModel.C_TYPE_DD_ID=self.C_TYPE_DD_ID.length>0?self.C_TYPE_DD_ID:nil;
    self.sellModel.BOOK_START_TIME=self.BOOK_START_TIME.length>0?self.BOOK_START_TIME:nil;
    self.sellModel.BOOK_END_TIME=self.BOOK_END_TIME.length>0?self.BOOK_END_TIME:nil;
    
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
   self.titleView=[[CGCNavSearchTextView alloc] initWithFrame:self.view.bounds withPlaceHolder:@"请输入手机/客户姓名" withRecord:^{//点击录音
      
//       MJKVoiceCViewController *voiceVC = [[MJKVoiceCViewController alloc]initWithNibName:@"MJKVoiceCViewController" bundle:nil];
//       [voiceVC setBackStrBlock:^(NSString *str){
////           if (str.length>0) {
//               weakSelf.titleView.textField.text = str;
//               self.SEARCH_NAMEORCONTACT=str;
//               self.currPage=1;
//               [self HTTPGetAppointmentList];
////           }
//
//       }];
//       [weakSelf presentViewController:voiceVC animated:YES completion:nil];
	   VoiceView *vv = [[VoiceView alloc]initWithFrame:self.view.frame];
	   [self.view addSubview:vv];
	   [vv start];
	   vv.recordBlock = ^(NSString *str) {
		   weakSelf.titleView.textField.text = str;
		   self.SEARCH_NAMEORCONTACT=str;
		   self.currPage=1;
		   [self HTTPGetAppointmentList];

	   };
	   
   } withText:^{//开始编辑
      
       
       
   }withEndText:^(NSString *str) {//结束编辑
       NSLog(@"%@____",str);
//       if (str.length>0) {
           self.SEARCH_NAMEORCONTACT=str;
             self.currPage=1;
           [self HTTPGetAppointmentList];
//       }
      
   }];
    self.navigationItem.titleView=self.titleView;

    if ([[NewUserSession instance].appcode containsObject:@"APP006_0002"]) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"新增预约-head" highImage:@"" isLeft:NO target:self andAction:@selector(addNewAppointment)];
    }
    

    
  
    self.tableView.mj_header=[MJRefreshHeader headerWithRefreshingBlock:^{

        self.currPage=1;
        [self HTTPGetAppointmentList];
    }];

    self.tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{

        self.currPage++;
        [self HTTPGetAppointmentList];

    }];
    [self.tableView.mj_header beginRefreshing];
    
  
}




-(void)passText:(NSString *)text
{
    
   
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.menuView.hidden=NO;
    if ([[KUSERDEFAULT objectForKey:@"refresh"] isEqualToString:@"yes"]) {
        [self.tableView.mj_header beginRefreshing];
        [KUSERDEFAULT removeObjectForKey:@"refresh"];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.menuView.hidden=YES;

}

    
- (void)chooseView{

    CFDropDownMenuView*menuView=[[CFDropDownMenuView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth-40, 40)];
    
    NSMutableArray * arr=[NSMutableArray arrayWithArray:@[@"全部",@"我的"]];
    if (self.sellArray.count>1) {
        for (CGCSellModel* model in self.sellArray) {
            NSString * str= model.nickName.length>0?model.nickName:@" ";
            [arr addObject:str];
            
        }
    }
    
    menuView.dataSourceArr=[@[arr,
                              @[@"全部",@"未到店",@"已到店",@"已取消"],
                              @[@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"今年",@"去年",@"最近7天",@"最近30天",@"自定义"],
                              @[@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"今年",@"去年",@"最近7天",@"最近30天",@"自定义"]] mutableCopy];
    menuView.defaulTitleArray=@[@"员工",@"状态",@"预约时间",@"到店时间"];
     NSArray * sidArr=@[@"", @"1", @"2", @"3", @"4", @"5", @"6", @"9", @"10", @"7",@"30",@"100"];
    NSArray * ddSidArr=@[@"", @"1", @"2", @"3", @"4", @"5", @"6", @"9", @"10", @"7",@"30",@"100"];
  
    menuView.startY=CGRectGetMaxY(menuView.frame);
    self.menuView=menuView;
    [self.view addSubview:self.menuView];
    
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(KScreenWidth-60, NavStatusHeight + 40, 60, 20);
    [btn setBgImage:@"all_bg"];
    [btn setTitleNormal:self.totalStr];
    btn.titleLabel.font=[UIFont systemFontOfSize:12];
    [btn setTitleColor:[UIColor lightGrayColor]];
    [self.view addSubview:btn];
    self.totalBtn=btn;
#pragma   各种筛选的点击事件
    DBSelf(weakSelf);
    menuView.chooseConditionBlock = ^(NSString *selectedSection, NSString *selectedRow, NSString *title) {
     
        NSLog(@"%@---%@--%@",selectedSection,selectedRow,title);
        
        
        
        switch ([selectedSection intValue]) {
            case 0://销售
                if ([title isEqualToString:@"全部"]) {
                    weakSelf.sellModel.C_OWNER_ROLEID=@"";
                }
                if ([title isEqualToString:@"我的"]) {
                   weakSelf.sellModel.C_OWNER_ROLEID=[NewUserSession instance].user.u051Id;
                }
                if (weakSelf.sellArray.count>1) {
                    for (CGCSellModel* model in self.sellArray) {
                        NSString * str= model.nickName.length>0?model.nickName:@" ";
                        if ([str isEqualToString:title]) {
                            weakSelf.sellModel.C_OWNER_ROLEID=model.u051Id;
                        }
                        
                    }
                }
                
                break;
                
            case 1://状态
                if ([title isEqualToString:@"全部"]) {
                    weakSelf.sellModel.IS_ARRIVE_SHOP=@"";
                } else {
                    weakSelf.sellModel.IS_ARRIVE_SHOP = title;
                }
//                if ([title isEqualToString:@"已到店"]) {
//                    weakSelf.sellModel.IS_ARRIVE_SHOP=@"2";
//                }
//                if ([title isEqualToString:@"未到店"]) {
//                    weakSelf.sellModel.IS_ARRIVE_SHOP=@"1";
//                }
//                if ([title isEqualToString:@"已取消"]) {
//                    weakSelf.sellModel.IS_ARRIVE_SHOP=@"3";
//                }
                
                break;
                
            case 2://预约时间
			{
				NSString *str = sidArr[[selectedRow intValue]];
				if ([str isEqualToString:@"100"] ) {
					CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
						
					} withEnd:^{
						
					} withSure:^(NSString *start, NSString *end) {
						
						self.sellModel.BOOK_START_TIME=start;
						self.sellModel.BOOK_END_TIME=end;
						weakSelf.sellModel.BOOK_TIME_TYPE = @"";
						self.currPage=1;
//						[self HTTPGetAppointmentList];
                        [self.tableView.mj_header beginRefreshing];
						
					}];
					[[UIApplication sharedApplication].keyWindow addSubview:dateView];
					return ;
//					self.sellModel.CREATE_TIME_TYPE=@"";
//					[self HTTPGetAppointmentList];
					
				}else{
					weakSelf.sellModel.BOOK_TIME_TYPE=sidArr[[selectedRow intValue]];
					self.sellModel.BOOK_START_TIME=@"";
					self.sellModel.BOOK_END_TIME = @"";
//					[self HTTPGetAppointmentList];
				}
			}
               
				
                break;
                
            case 3:{//到店时间
                NSString *str = sidArr[[selectedRow intValue]];
                if ([str isEqualToString:@"100"] ) {
                    CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
                        
                    } withEnd:^{
                        
                    } withSure:^(NSString *start, NSString *end) {
                        
                        self.sellModel.ARRIVE_START_TIME=start;
                        self.sellModel.ARRIVE_END_TIME=end;
                        weakSelf.sellModel.ARRIVE_TIME_TYPE = @"";
                        self.currPage=1;
//                        [self HTTPGetAppointmentList];
                        [self.tableView.mj_header beginRefreshing];
                        
                    }];
                    [[UIApplication sharedApplication].keyWindow addSubview:dateView];
                    return ;
//                    self.sellModel.CREATE_TIME_TYPE=@"";
//                    [self HTTPGetAppointmentList];
                    
                }else{
                    weakSelf.sellModel.ARRIVE_TIME_TYPE=ddSidArr[[selectedRow intValue]];
                    self.sellModel.ARRIVE_START_TIME=@"";
                    self.sellModel.ARRIVE_END_TIME = @"";
//                    [self HTTPGetAppointmentList];
                }
            }
                
                break;
            default:
                break;
        }
        self.currPage=1;
        [self.tableView.mj_header beginRefreshing];
    };
    
   
    //这个是筛选的view
    FunnelShowView*funnelView=[FunnelShowView funnelShowView];
   
    NSArray * titleArr=@[@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"今年",@"去年",@"最近7天",@"最近30天",@"自定义"];
    NSArray * idArr=@[@"", @"1", @"2", @"3", @"4", @"5", @"6", @"9", @"10", @"7",@"30",@"999"];
    NSMutableArray * contentArr=[NSMutableArray array];
    for (int i=0;i<titleArr.count;i++) {
       
        MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
        model.name=titleArr[i];
        model.c_id=idArr[i];
        [contentArr addObject:model];
        
    }
    NSDictionary*dic=@{@"title":@"创建时间",@"content":contentArr};
    funnelView.allDatas =  (NSMutableArray *)@[dic];
    
    //回调
    funnelView.sureBlock = ^(NSMutableArray *array) {
        NSString * name = [[array firstObject][@"model"] name];
        NSString * c_id = [[array firstObject][@"model"] c_id];
        if ([name isEqualToString:@"自定义"]) {
            self.sellModel.CREATE_TIME_TYPE=@"";
            [self.tableView.mj_header beginRefreshing];
            
        }else{
            self.sellModel.CREATE_TIME_TYPE=c_id;
            [self.tableView.mj_header beginRefreshing];
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
        
    };
    
    
    funnelView.resetBlock = ^{
        self.sellModel.CREATE_TIME_TYPE=@"0";
        self.sellModel.CREATE_START_TIME=nil;
        self.sellModel.CREATE_END_TIME=nil;
        
        [weakSelf.tableView.mj_header beginRefreshing];
    };
  

    funnelView.viewCustomTimeBlock = ^(NSInteger selectionSection){
        MyLog(@"自定义时间");

        CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
            
        } withEnd:^{
            
        } withSure:^(NSString *start, NSString *end) {
            
            self.sellModel.CREATE_START_TIME=start;
            self.sellModel.CREATE_END_TIME=end;
            self.sellModel.CREATE_TIME_TYPE=@"";
            [self.tableView.mj_header beginRefreshing];

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
    CGCAppointDetailModel * model=self.dataArray[section];
    return model.content.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGCAppointmentCell * cell=[CGCAppointmentCell cellWithTableView:tableView];
    cell.starImg.hidden = YES;
    CGCAppointmentModel *model=[self.dataArray[indexPath.section] content][indexPath.row];
    [cell reloadCellWithModel:model];
    
    
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

   CGCAppointDetailModel *model = self.dataArray[section];
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 20)];
    view.backgroundColor=DBColor(247, 247, 247);
    
    UILabel * lab=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 20)];
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
        CGCAppointmentModel *model=[self.dataArray[indexPath.section] content][indexPath.row];
        
        if ([model.IS_ARRIVE_SHOP isEqualToString:@"已取消"]) {
                return NO;
        }
    
        return YES;
}
   
    
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    
     CGCAppointmentModel *model=[self.dataArray[indexPath.section] content][indexPath.row];
    self.detailModel = model;
    
    UITableViewRowAction *tel = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                         title:@"电话"
                                                                       handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                           NSInteger index=indexPath.section*100+indexPath.row;
                                                                           [self selectTelephone:index];
                                                                       }];
    tel.backgroundColor=DBColor(255,195,0);
    UITableViewRowAction *agin = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                            title:@"再次预约"
                                                                          handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                              [self againAppiontment:indexPath];
                                                                          }];
    UITableViewRowAction *shop = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                            title:@"已到店"
                                                                          handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
																			  if (![[NewUserSession instance].appcode containsObject:@"crm:a416_yuyue:dd"]) {
																				  [JRToast showWithText:@"账号无权限"];
																				  return ;
																			  }
                                                                              [self alreadyArrive:indexPath];
                                                                          }];
    UITableViewRowAction *more = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                            title:@"更多操作"
                                                                          handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                              self.moreView.tag=indexPath.section*100+indexPath.row;
                                                                                 [self.moreView.delayBtn addTarget:self action:@selector(delayClick:) forControlEvents:UIControlEventTouchUpInside];
                                                                              [self.view addSubview:self.moreView];
                                                                              
                                                                          }];
    more.backgroundColor=DBColor(50,151,234);
   agin.backgroundColor= shop.backgroundColor=DBColor(153,153,153);
  
    NSArray *arr = nil;
    //IS_ARRIVE_SHOP
    if ([model.IS_ARRIVE_SHOP isEqualToString:@"已到店"]) {
        arr=@[agin,tel];
        return arr;

    }else{
         arr=@[more,shop,tel];
        return arr;

    }
  
   
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 21.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 75;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (![[NewUserSession instance].appcode containsObject:@"APP006_0006"]) {
        [JRToast showWithText:@"账号无权限"];
        return ;
    }
    CGCAppiontDetailVC * vc=[[CGCAppiontDetailVC alloc] init];
    CGCAppointmentModel *model=[self.dataArray[indexPath.section] content][indexPath.row];
    vc.C_ID= model.C_ID;
    vc.isDiss=model.IS_ARRIVE_SHOP;
    
    vc.rootVC = self;
    DBSelf(weakSelf);
    vc.reBlock = ^{
        weakSelf.currPage=1;
        [weakSelf HTTPGetAppointmentList];
    };
    [self.navigationController pushViewController:vc animated:YES];

}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//
//
//    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 1)];
//    view.backgroundColor=DBColor(221, 220, 223);
//
//    return view;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//
//    return 1;
//}
#pragma mark -- touch

- (void)againAppiontment:(NSIndexPath *)indexPath{
   DBSelf(weakSelf);
//    CGCAppointmentModel *model=[self getSingleModel:self.moreView.tag withMess:@"客户id错误"];
     CGCAppointmentModel *model=[self.dataArray[indexPath.section] content][indexPath.row];
    if (model.C_ID.length==0) {
        [JRToast showWithText:@"客户不存在"];
        return;
    }
    CGCNewAddAppointmentVC *vc=[[CGCNewAddAppointmentVC alloc] init];
    vc.sellArr=self.sellArray;
    vc.rootVC = self;
    vc.amodel=model;
    vc.rloadBlock = ^{
        weakSelf.currPage=1;
        [weakSelf HTTPGetAppointmentList];
    };
    
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)addNewAppointment{//导航右边新增预约点击
	if (![[NewUserSession instance].appcode containsObject:@"crm:a416_yuyue:add"]) {
		[JRToast showWithText:@"账号无权限"];
		return ;
	}
    CGCNewAddAppointmentVC *vc=[[CGCNewAddAppointmentVC alloc] init];
//    vc.sellArr=self.sellArray;
  
    vc.rootVC = self;
    DBSelf(weakSelf);
    
    vc.rloadBlock = ^{
//        self.currPage=1;
//        [weakSelf HTTPGetAppointmentList];
        [weakSelf.tableView.mj_header beginRefreshing];
    };
   
    [self.navigationController pushViewController:vc animated:YES];

}
//更多操作弹窗事件
- (void)moreViewDissmiss:(UIButton *)btn{

    [self.moreView removeFromSuperview];
    self.moreView=nil;
}


- (void)alreadyArrive:(NSIndexPath *)indexPath{
   
  CGCAppointmentModel *model=[self.dataArray[indexPath.section] content][indexPath.row];
    if (model.C_ID.length==0) {
        [JRToast showWithText:@"客户不存在"];
        return;
    }
    CGCAlertDateView *alertDate=[[CGCAlertDateView alloc] initWithFrame:self.view.bounds  withSelClick:^{
        
    } withSureClick:^(NSString *title, NSString *dateStr) {
        if (dateStr.length>0) {
            
            self.operationDict=[NSMutableDictionary dictionary];
            [self.operationDict setObject:model.C_ID forKey:@"C_ID"];
            [self.operationDict setObject:@"0" forKey:@"type"];
             [self.operationDict setObject:title forKey:@"D_ARRIVE_TIME"];
            dateStr.length>0?[self.operationDict setObject:[dateStr substringFromIndex:title.length] forKey:@"X_REMARK"]:[self.operationDict setObject:@"" forKey:@"X_REMARK"];
            [self HTTPoperationReservationById];
        }
        
    } withHight:195.0 withText:@"请填写已到店信息" withDatas:nil];
    alertDate.VCName = @"预约";
    
    [self.view addSubview:alertDate];

    
}

//延期
- (void)delayClick:(UIButton *)btn{
	if (![[NewUserSession instance].appcode containsObject:@"crm:a416_yuyue:yq"]) {
		[JRToast showWithText:@"账号无权限"];
		return ;
	}
  
    CGCAppointmentModel *model=[self getSingleModel:self.moreView.tag withMess:@"延期失败！"];
  self.operationDict=[NSMutableDictionary dictionary];
    [self.operationDict setObject:model.C_ID forKey:@"C_ID"];
    [self.operationDict setObject:@"1" forKey:@"type"];
    [self.operationDict setObject:@"A41600_C_STATUS_0002" forKey:@"C_STATUS_DD_ID"];
    [self.operationDict setObject:[DBTools getTimeFomatFromCurrentTimeStamp] forKey:@"D_ARRIVE_TIME"];
    
    [self moreViewDissmiss:btn];

    
    self.alertDateView=[[CGCAlertDateView alloc] initWithFrame:self.view.bounds  withSelClick:^{
        
    } withSureClick:^(NSString *title, NSString *dateStr) {
        if (dateStr.length>0) {
            [self.operationDict setObject:dateStr forKey:@"D_ARRIVE_TIME"];
            
            [self HTTPoperationReservationById];

        }
        
    } withHight:150.0 withText:@"请填写延期到店信息" withDatas:nil];
    
    
    [self.view addSubview:self.alertDateView];
}


//取消
- (void)canelClick:(UIButton *)btn{
	if (![[NewUserSession instance].appcode containsObject:@"crm:a416_yuyue:qx"]) {
		[JRToast showWithText:@"账号无权限"];
		return ;
	}
    [self.moreView removeFromSuperview];
   
       CGCAppointmentModel *model=[self getSingleModel:self.moreView.tag withMess:@"取消失败！"];
      self.operationDict=[NSMutableDictionary dictionary];
    [self.operationDict setObject:model.C_ID forKey:@"C_ID"];
    [self.operationDict setObject:@"2" forKey:@"type"];
    [self.operationDict setObject:@"A41600_C_STATUS_0003" forKey:@"C_STATUS_DD_ID"];
    [self.operationDict  removeObjectForKey:@"D_ARRIVE_TIME"];

    UIAlertController *alert=[DBObjectTools getAlertVCwithTitle:@"提示" withMessage:@"确认取消预约?" clickCanel:^{
        
    } sureClick:^{
        [self HTTPoperationReservationById];
    } canelActionTitle:@"取消" sureActionTitle:@"确定"];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
    self.moreView=nil;
    
    NSLog(@"-=-=");
}


//电话
- (void)telephoneCall:(NSInteger)index{
    
   CGCAppointmentModel *model= [self getSingleModel:index withMess:@"号码不存在"];
    if (model.C_PHONE.length > 0) {
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:model.C_PHONE]]];
    } else {
        [JRToast showWithText:@"无电话号码"];
    }
   
}

- (void)whbcallBack:(NSInteger)index {
    CGCAppointmentModel *model= [self getSingleModel:index withMess:@"号码不存在"];
     if (model.C_PHONE.length > 0) {
    [DBObjectTools whbCallWithC_OBJECT_ID:model.C_ID andC_CALL_PHONE:model.C_PHONE andC_NAME:model.C_A41500_C_NAME andC_OBJECTTYPE_DD_ID:@"A83100_C_OBJECTTYPE_0006" andCompleteBlock:nil];
         
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

        CustomerDetailInfoModel*infoModel=[[CustomerDetailInfoModel alloc]init];
        infoModel.C_ID=weakSelf.detailModel.C_A41500_C_ID;
        infoModel.C_HEADIMGURL=weakSelf.detailModel.C_HEADIMGURL;
        infoModel.C_NAME=weakSelf.detailModel.C_A41500_C_NAME;
        infoModel.C_STAGE_DD_ID = weakSelf.detailModel.C_STAGE_DD_ID;
        infoModel.C_STAGE_DD_NAME = weakSelf.detailModel.C_STAGE_DD_NAME;
        infoModel.C_LEVEL_DD_NAME=weakSelf.detailModel.C_LEVEL_DD_NAME;
        infoModel.C_LEVEL_DD_ID=weakSelf.detailModel.C_LEVEL_DD_ID;
        


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
//座机
- (void)landLineCall:(NSInteger)index{
    
     CGCAppointmentModel *model= [self getSingleModel:index withMess:@"号码不存在"];
    
    CommonCallViewController *myView=[[CommonCallViewController alloc]initWithNibName:@"CommonCallViewController" bundle:nil];
    myView.typeStr=@"用座机拨打";
    myView.nameStr=model.C_A41500_C_NAME;
    myView.callStr=model.C_PHONE;
    [self.navigationController pushViewController:myView animated:YES];
    
}
//回呼
- (void)callBack:(NSInteger)index{
     CGCAppointmentModel *model= [self getSingleModel:index withMess:@"号码不存在"];
    CommonCallViewController *myView=[[CommonCallViewController alloc]initWithNibName:@"CommonCallViewController" bundle:nil];
    myView.typeStr=@"回呼到手机";
    myView.nameStr=model.C_A41500_C_NAME;
    myView.callStr=model.C_PHONE;
    [self.navigationController pushViewController:myView animated:YES];
    
}

- (CGCAppointmentModel *)getSingleModel:(NSInteger)index withMess:(NSString *)mess{

    long section=index/100;
    int row=index%100;
    
    CGCAppointmentModel *model=[self.dataArray[section] content][row];
    
    return model;

}
#pragma mark -- 网络请求 request

- (void)HTTPGetAppointmentList{//获取预约列表

    
    NSMutableDictionary *dic=[NSMutableDictionary new];
 
    dic[@"SEARCH_NAMEORCONTACT"] = self.SEARCH_NAMEORCONTACT.length > 0 ? self.SEARCH_NAMEORCONTACT : @"";
//    self.SEARCH_NAMEORCONTACT.length>0?[dic setObject:self.SEARCH_NAMEORCONTACT forKey:@"SEARCH_NAMEORCONTACT"]:[dic setObject:@"" forKey:@"SEARCH_NAMEORCONTACT"];
    [dic setObject:@"10" forKey:@"pageSize"];
   
    [dic setObject:@(self.currPage) forKey:@"pageNum"];
    dic[@"USERIDS"] = self.sellModel.USERIDS.length>0? self.sellModel.USERIDS : self.saleCode;
     self.sellModel.IS_ARRIVE_SHOP.length>0?[dic setObject:self.sellModel.IS_ARRIVE_SHOP forKey:@"IS_ARRIVE_SHOP"]:0;
    self.sellModel.BOOK_TIME_TYPE.length>0?[dic setObject:self.sellModel.BOOK_TIME_TYPE forKey:@"BOOK_TIME_TYPE"]:0;
    self.sellModel.C_SEX_DD_ID.length>0?[dic setObject:self.sellModel.C_SEX_DD_ID forKey:@"C_SEX_DD_ID"]:0;
    if (self.CREATE_TIME_TYPE.length > 0) {
        dic[@"CREATE_TIME_TYPE"] = self.CREATE_TIME_TYPE;
    }
    /////////
    self.sellModel.CREATE_TIME_TYPE.length>0?[dic setObject:self.sellModel.CREATE_TIME_TYPE forKey:@"CREATE_TIME_TYPE"]:0;
    self.sellModel.CREATE_START_TIME.length>0?[dic setObject:self.sellModel.CREATE_START_TIME forKey:@"CREATE_START_TIME"]:0;
    self.sellModel.CREATE_END_TIME.length>0?[dic setObject:self.sellModel.CREATE_END_TIME forKey:@"CREATE_END_TIME"]:0;
     self.sellModel.START_CREATE_TIME.length>0?[dic setObject:self.sellModel.START_CREATE_TIME forKey:@"START_CREATE_TIME"]:0;
     self.sellModel.END_CREATE_TIME.length>0?[dic setObject:self.sellModel.END_CREATE_TIME forKey:@"END_CREATE_TIME"]:0;
    ////
	self.sellModel.START_BOOK_TIME.length>0?[dic setObject:self.sellModel.START_BOOK_TIME forKey:@"START_BOOK_TIME"]:0;
    self.sellModel.END_BOOK_TIME.length>0?[dic setObject:self.sellModel.END_BOOK_TIME forKey:@"END_BOOK_TIME"]:0;
    
    
    self.sellModel.ARRIVE_TIME_TYPE.length>0?[dic setObject:self.sellModel.ARRIVE_TIME_TYPE forKey:@"ARRIVE_TIME_TYPE"]:0;
    self.sellModel.ARRIVE_START_TIME.length>0?[dic setObject:self.sellModel.ARRIVE_START_TIME forKey:@"ARRIVE_START_TIME"]:0;
    self.sellModel.ARRIVE_END_TIME.length>0?[dic setObject:self.sellModel.ARRIVE_END_TIME forKey:@"ARRIVE_END_TIME"]:0;
    self.sellModel.C_TYPE_DD_ID.length>0?[dic setObject:self.sellModel.C_TYPE_DD_ID forKey:@"C_TYPE_DD_ID"]:0;
    self.sellModel.BOOK_START_TIME.length>0?[dic setObject:self.sellModel.BOOK_START_TIME forKey:@"BOOK_START_TIME"]:0;
    self.sellModel.BOOK_END_TIME.length>0?[dic setObject:self.sellModel.BOOK_END_TIME forKey:@"BOOK_END_TIME"]:0;
    self.sellModel.C_OWNER_ROLEID.length>0?[dic setObject:self.sellModel.C_OWNER_ROLEID forKey:@"C_OWNER_ROLEID"]:0;
    
    dic[@"C_LOCCODE"] = [NewUserSession instance].user.C_LOCCODE;
    HttpManager*manager=[[HttpManager alloc]init];
    
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a416Yy/list", HTTP_IP] parameters:dic compliation:^(id data, NSError *error) {
        [self.menuView bringSubviewToFront:self.view];
        NSInteger num = 0;
        if ([data[@"code"] integerValue]==200) {
//            NSDictionary*dict=[data copy];
            if (self.currPage==1) {
                [self.dataArray removeAllObjects];
            }
            for (NSDictionary * dic in data[@"data"][@"content"] ) {
                CGCAppointDetailModel * model=[CGCAppointDetailModel yy_modelWithDictionary:dic];
              
                [self.dataArray addObject:model];
                
            }
            for (CGCAppointDetailModel * model in self.dataArray) {
                for (NSArray *tempArr in model.content) {
                    num += 1;
                }
            }
        }else{
            
            self.currPage>1?self.currPage--:0;
            
            [JRToast showWithText:data[@"data"][@"msg"]];
        }
        
        
//        self.currPage>1?self.currPage--:0;

       self.totalStr=[NSString stringWithFormat:@"总计:%@",data[@"data"][@"countNumber"]];
        [self.totalBtn setTitleNormal:self.totalStr];
        [self.tableView.mj_header endRefreshing];
        if (num >= [(NSString *)data[@"data"][@"countNumber"] integerValue]) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
      
        
        [self.tableView reloadData];
            
    }];
    

   
}

    
- (void)HTTPGetSellList{


    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_LOCCODE"] = [NewUserSession instance].user.C_LOCCODE;
    HttpManager *manage = [[HttpManager alloc]init];
    [manage getNewDataFromNetworkWithUrl:HTTP_SYSTEMUserList parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            MJKClueListViewModel *clueListModel = [MJKClueListViewModel yy_modelWithDictionary:data];
            for (MJKClueListSubModel *subModel in clueListModel.data) {
                CGCSellModel * model=[[CGCSellModel alloc]init];
                model.u031Id = subModel.u031Id;
                model.u051Id = subModel.u051Id;
                model.C_NAME = subModel.nickName;
                model.nickName = subModel.nickName;
                model.C_HEADPIC = subModel.avatar;
                [weakSelf.sellArray addObject:model];
            }
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
        
        [weakSelf chooseView];
    }];


}

- (void)HTTPoperationReservationById
{
    
    HttpManager*manager=[[HttpManager alloc]init];
    
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a416Yy/operation",HTTP_IP] parameters:self.operationDict compliation:^(id data, NSError *error) {
       
     
        if ([data[@"code"] integerValue]==200) {
            self.currPage=1;
            [self HTTPGetAppointmentList];
        }else{
            
            [JRToast showWithText:data[@"msg"]];
        }
        
       
    }];
    

}

#pragma mark -- set
- (UITableView *)tableView{

    if (_tableView==nil) {
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, NavStatusHeight + 40, KScreenWidth, KScreenHeight-NavStatusHeight - 40 - WD_TabBarHeight - SafeAreaBottomHeight) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
//        _tableView.estimatedRowHeight=60;
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


- (CGCMoreActionView *)moreView{
    
    if (_moreView==nil) {
        _moreView=[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CGCMoreActionView class]) owner:self options:nil] lastObject];
        [_moreView.bgBtn addTarget:self action:@selector(moreViewDissmiss:)forControlEvents:UIControlEventTouchUpInside];
  
     
        [_moreView.preView addTarget:self action:@selector(canelClick:) forControlEvents:UIControlEventTouchUpInside];
       
        [_moreView.delayImgBtn setImage:@"延期到店"];
        [_moreView.canelImgBtn setImage:@"取消预约"];
        _moreView.firstLab.text=@"延期";
        
    }
    return _moreView;
}


#pragma mark -- otherDelegate
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
}
@end
