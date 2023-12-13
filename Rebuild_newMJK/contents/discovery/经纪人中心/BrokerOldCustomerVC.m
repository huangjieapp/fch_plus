//
//  BrokerCustomVC.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/5/15.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "BrokerOldCustomerVC.h"

#import "CustomLabelHeaderView.h"
#import "CustomerDetailFirstRowTableViewCell.h"
#import "CustomerDetailSecondTableViewCell.h"
#import "CustomerDetailBottomToolView.h"
#import "CGCAlertDateView.h"
#import "ScaleView.h"  //放大view
#import "MJKHistoryFlowViewController.h"//历史记录
#import "FansFollowAddEditViewController.h"
#import "MJKAgentChangeStatusViewController.h"
#import "MJKQuestionnaireViewController.h"


#import "CustomerDetailInfoModel.h"
#import "CustomerDetailPathModel.h"
#import "MJKClueListMainSecondModel.h"   //线索列表的model
#import "CGCAppointmentModel.h"   //预约的model
#import "PotentailCustomerListDetailModel.h"
#import "CustomerDetailViewController.h"

#import "WXApi.h"
#import <MessageUI/MessageUI.h>

#import "scribeCustomLabelViewController.h"
#import "AddOrEditlCustomerViewController.h"
#import "CommonCallViewController.h"
#import "CustomerFollowAddEditViewController.h"   //跟进
#import "MJKMarketViewController.h"  //选择销售
#import "OrderDetailViewController.h"   //订单详情
#import "CGCNewAddAppointmentVC.h"   //新预约
#import "CGCAppiontDetailVC.h"   //预约详情
#import "MJKClueDetailViewController.h"   //线索详情
#import "MJKFlowDetailViewController.h"   //流量详情
#import "AssistFollowViewController.h"

#import "CGCTemplateVC.h"       //短信 微信  界面

#import "AssistFollowViewController.h"

#import "ServiceTaskAddViewController.h"

#import "ServiceTaskDetailModel.h"
#import "ShowHelpViewController.h"

#import "ServiceTaskPerformViewController.h"
#import "ServiceTaskTrueDetailViewController.h"
#import "MJKOldCustomerSalesViewController.h"
#import "MJKOldCustomerConsultViewController.h"

#import "MJKClueAddViewController.h"
#import "CGCAddBrokerVC.h"
#import "MJKHistoryFlowViewController.h"

#import "BrokerOldCustomerModel.h"

#define CELLHeader  @"CustomLabelHeaderView"
#define CELL0       @"CustomerDetailFirstRowTableViewCell"
#define CELL1       @"CustomerDetailSecondTableViewCell"

@interface BrokerOldCustomerVC ()<UITableViewDelegate,UITableViewDataSource,CustomerDetailBottomToolViewDelegate,MFMessageComposeViewControllerDelegate>

@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)CustomerDetailBottomToolView*toolView;



@property(nonatomic,assign)NSInteger pagen;
@property(nonatomic,assign)NSInteger pages;
@property(nonatomic,assign)NSInteger touchButtonIndex;
@property(nonatomic,strong)CustomerDetailInfoModel*detailInfoModel;
@property(nonatomic,strong)CustomerDetailInfoModel*detailFollowInfoModel;
@property(nonatomic,strong)CustomerDetailPathModel*mainPathModel;
@property(nonatomic,strong)NSMutableArray<CustomerDetailPathDetailModel*>*secondSectionAllDatas;

/** <#注释#>*/
@property (nonatomic, strong) NSArray *oldArray;


//全部中的第一条 跟进  数据
@property(nonatomic,strong)CustomerDetailPathDetailModel*fitstFollowInAll;
@property(nonatomic,strong)CustomerDetailPathDetailModel*assistfitstFollowInAll;


@property(nonatomic,assign)BOOL isZhanbai;  //如果战败了   那么tools 潜客编辑 标签编辑 点击不了。

/** <#注释#>*/
@property (nonatomic, assign) CGFloat toolMainViewHeight;
@end

@implementation BrokerOldCustomerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self defineBackButton];
    self.title=@"粉丝详情";
    if ([self.mainModel.C_STATUS_DD_NAME isEqualToString:@"战败"]) {
        self.isZhanbai=YES;
    }else{
        self.isZhanbai=NO;
    }
    
    
    self.touchButtonIndex = 0;
    
    [self creatNavi];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:CELLHeader bundle:nil] forHeaderFooterViewReuseIdentifier:CELLHeader];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
    [self.tableView registerNib:[UINib nibWithNibName:CELL1 bundle:nil] forCellReuseIdentifier:CELL1];
    [self setUpRefresh];
    
    [self.view addSubview:self.toolView];
    if (self.isZhanbai) {
        self.toolView.hidden=YES;
    }else{
        self.toolView.hidden=NO;
    }
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIButton *rightItemButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightItemButton addTarget:self action:@selector(clickHistory)];
    [rightItemButton setImage:@"23-顶右button"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightItemButton];
    
    DBSelf(weakSelf);
//    [self httpPostGetCustomerDetailInfoWithSuccessBlock:^{
//        [weakSelf.tableView reloadData];
//    }];
}

//- (void)clickHistroy {
//    MJKHistoryFlowViewController *vc = [[MJKHistoryFlowViewController alloc]init];
//    vc.C_A41500_C_ID = self.detailInfoModel.C_ID;
//    vc.VCName = @"粉丝";
//    [self.navigationController pushViewController:vc animated:YES];
//}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    DBSelf(weakSelf);
    if ([[KUSERDEFAULT objectForKey:@"isRefresh"] isEqualToString:@"yes"]) {
        if (self.touchButtonIndex == 1) {
            [self getCrmA855List];
        } else {
            [self httpPostGetCustomerDetailInfoWithSuccessBlock:^{
                [weakSelf httpGetCustomerPathWithsuccess:^(id data) {
                    
                        [weakSelf getCrmA855List];
                }];
            }];
        }
        [KUSERDEFAULT removeObjectForKey:@"isRefresh"];
    }
    
}

#pragma mark  --UI
-(void)defineBackButton{
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem= [UIBarButtonItem itemWithImage:@"btn-返回" highImage:nil isLeft:YES target:self andAction:@selector(goBack)];
    self.navigationItem.leftItemsSupplementBackButton = YES;
    
}


-(void)creatNavi{
//    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
//    [button setBackgroundImage:[UIImage imageNamed:@"23-顶右button"] forState:UIControlStateNormal];
//    //    [button addTarget:self action:@selector(clickShare)];
//    [button addTarget:self action:@selector(clickHistory)];
//    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithCustomView:button];
////    self.navigationItem.rightBarButtonItem=item;
    
}


-(void)setUpRefresh{
    self.pagen=20;
    self.pages=1;
    self.touchButtonIndex=0;
    DBSelf(weakSelf);
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        if (weakSelf.touchButtonIndex == 1) {
//            weakSelf.pagen = 20;
//            [weakSelf getCrmA855List];
//        } else {
        self.pages=1;
            [weakSelf httpPostGetCustomerDetailInfoWithSuccessBlock:^{
            [weakSelf httpGetCustomerPathWithsuccess:^(id data) {
                
                [weakSelf getCrmA855List];
//                [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
                [weakSelf.tableView reloadData];
            }];
            }];
//        }
        
    }];
    
    self.tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        if (weakSelf.touchButtonIndex == 1) {
//            weakSelf.pagen += 20;
//            [weakSelf getCrmA855List];
//        } else {
        self.pages++;
        [self httpGetCustomerPathWithsuccess:^(id data) {
            
            [weakSelf getCrmA855List];
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        }];
//        }
        
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else{
//        if (self.touchButtonIndex == 1) {
//            return self.oldArray.count;
//        } else {
        return self.secondSectionAllDatas.count;
//        }
    }
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    DBSelf(weakSelf);
    
    
    if (indexPath.section==0&&indexPath.row==0) {
        CustomerDetailFirstRowTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
        cell.editButton.hidden = cell.cardButton.hidden = NO;
        cell.tag = [NSString stringWithFormat:@"%ld",self.touchButtonIndex];
        cell.type=@"fans";
        
//        if (self.mainPathModel) {
//
//            cell.numberArray=[@[self.mainPathModel.B_ORDERCOUNT.length > 0 ? self.mainPathModel.B_ORDERCOUNT : @"",self.mainPathModel.B_DT.length > 0 ? self.mainPathModel.B_DT : @"", self.mainPathModel.B_BB.length > 0 ? self.mainPathModel.B_BB : @""] mutableCopy];
//        }
        if (self.detailInfoModel.X_REMRAK) {
            cell.remarkText=self.detailInfoModel.X_REMRAK;
        }
        
        
        cell.clickTopThreeButtonBlock = ^(NSInteger index) {
            MyLog(@"%lu",index);
            if (index==0) {
                if (![[NewUserSession instance].appcode containsObject:@"APP015_0008"]) {
                    [JRToast showWithText:@"账号无权限"];
                    return ;
                }
                NSInteger index=indexPath.section*100+indexPath.row;
                [weakSelf selectTelephone:index];
                
            }else if (index==1){
                if (![[NewUserSession instance].appcode containsObject:@"APP015_0009"]) {
                    [JRToast showWithText:@"账号无权限"];
                    return ;
                }
                //                [JRToast showWithText:@"短信"];
                MFMessageComposeViewController *vc = [[MFMessageComposeViewController alloc] init];
                // 设置短信内容
            //    vc.body = @"吃饭了没？";
                // 设置收件人列表
                vc.recipients = @[weakSelf.detailInfoModel.C_PHONE];
                // 设置代理
                vc.messageComposeDelegate = self;
                // 显示控制器
                [self presentViewController:vc animated:YES completion:nil];
                
                
                
                
            }else if (index==2){
                if (![[NewUserSession instance].appcode containsObject:@"APP015_0010"]) {
                    [JRToast showWithText:@"账号无权限"];
                    return ;
                }
                UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *wechat = [UIAlertAction actionWithTitle:@"复制微信号跳转" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                    pasteboard.string = weakSelf.detailInfoModel.C_WECHAT;
                    [weakSelf openWechat];
                }];
                
                UIAlertAction *phone = [UIAlertAction actionWithTitle:@"复制手机号跳转" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                    pasteboard.string = weakSelf.detailInfoModel.C_PHONE;
                    [weakSelf openWechat];
                }];
                
                UIAlertAction *message = [UIAlertAction actionWithTitle:@"发送消息模版" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    CGCTemplateVC*vc=[[CGCTemplateVC alloc]init];
                    vc.templateType=CGCTemplateWeiXin;
                    vc.titStr=self.detailInfoModel.C_NAME;
                    vc.customIDArr=[@[self.mainModel.C_A41500_C_ID] mutableCopy];
                    vc.cusDetailModel.C_ID=self.detailInfoModel.C_ID;
                    vc.cusDetailModel.C_HEADIMGURL=self.detailInfoModel.C_HEADIMGURL;
                    vc.cusDetailModel.C_NAME=self.detailInfoModel.C_NAME;
                    vc.cusDetailModel.C_LEVEL_DD_NAME=self.detailInfoModel.C_LEVEL_DD_NAME;
                    vc.cusDetailModel.C_LEVEL_DD_ID=self.detailInfoModel.C_LEVEL_DD_ID;
                    [self.navigationController pushViewController:vc animated:YES];
                }];
                
                
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                
                if (weakSelf.detailInfoModel.C_WECHAT.length > 0) {
                    [ac addAction:wechat];
                }
                
                if (weakSelf.detailInfoModel.C_PHONE.length > 0) {
                    [ac addAction:phone];
                }
                
                [ac addAction:message];
                [ac addAction:cancel];
                
                [weakSelf presentViewController:ac animated:YES completion:nil];
                
                
            } else if (index == 3) {
                if (![[NewUserSession instance].appcode containsObject:@"crm:a477:edit"]) {
                    [JRToast showWithText:@"账号无权限"];
                    return ;
                }
                CGCAddBrokerVC * avc=[[CGCAddBrokerVC alloc] init];
                //    avc.title = self.type == BrokerCenterAgent ? @"新增经纪人" : @"新增会员";
                avc.c_id = weakSelf.detailInfoModel.C_ID;
                avc.type = CGCAddBrokerEdit;
                [self.navigationController pushViewController:avc animated:NO];
            }  else if (index == 4) {
//                if (![[NewUserSession instance].appcode containsObject:@"APP015_0011"]) {
//                    [JRToast showWithText:@"账号无权限"];
//                    return ;
//                }
//                [weakSelf HTTPCardData];
                if (self.detailInfoModel.C_ADDRESS.length <= 0) {
                    [JRToast showWithText:@"暂无客户地址"];
                    return;
                }
                MJKMapNavigationViewController *alertVC = [MJKMapNavigationViewController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                alertVC.C_ADDRESS = self.detailInfoModel.C_ADDRESS;
                [self presentViewController:alertVC animated:YES completion:nil];
            }
            
            
        };
        cell.clickBottomEightButtonBlock = ^(NSInteger index) {
            MyLog(@"%lu",index);
            weakSelf.touchButtonIndex=index;
            [weakSelf.tableView.mj_header beginRefreshing];
//            if (index == 1) {
//
//                [weakSelf getCrmA855List];
//            } else {
//            [weakSelf httpGetCustomerPathWithsuccess:^(id data) {
//                self.pages=1;
//                [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
//
//            }];
//            }
            
            
        };
        
        
        
        return cell;
    }else if (indexPath.section==1){
        CustomerDetailSecondTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL1];
//        if (self.touchButtonIndex == 1) {
//            BrokerOldCustomerModel *bmodel = self.oldArray[indexPath.row];
//            CustomerDetailPathDetailModel*model=[[CustomerDetailPathDetailModel alloc]init];
//            model.C_TYPE = bmodel.C_TYPE_DD_NAME;
//            model.D_SHOW_TIME = bmodel.D_SHOW_TIME;
//            model.X_REMARK = bmodel.X_REMARK;
//            cell.MainModel=model;
//        } else {
            CustomerDetailPathDetailModel*model=self.secondSectionAllDatas[indexPath.row];
    //            cell.MainModel=model;
        model.C_TYPE = model.C_TYPE_DD_NAME;
        
        model.C_OBJECT_ID = model.C_OBJECTID;
                    cell.MainModel=model;
//        }
        
        cell.clickScaleBlock = ^(CustomerDetailPathDetailModel *model) {
            MyLog(@"%@",model);
            [ScaleView scaleViewWithModel:model];
            
        };
        
        
        return cell;
        
        
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==1) {
//        if (self.touchButtonIndex == 1) {
//            BrokerOldCustomerModel *model=self.oldArray[indexPath.row];
//            if ([model.C_TYPE_DD_ID isEqualToString:@"A85500_C_TYPE_0001"]) { //售后
//                MJKOldCustomerSalesViewController *vc = [[MJKOldCustomerSalesViewController alloc]init];
//                vc.C_ID = model.C_OBJECTID;
//                [self.navigationController pushViewController:vc animated:YES];
//            } else if ([model.C_TYPE_DD_ID isEqualToString:@"A85500_C_TYPE_0003"]) { //老客户关怀
//            } else if ([model.C_TYPE_DD_ID isEqualToString:@"A85500_C_TYPE_0000"]) { //咨询
//                MJKOldCustomerConsultViewController *vc = [[MJKOldCustomerConsultViewController alloc]init];
//                vc.C_ID = model.C_OBJECTID;
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//        } else {
        CustomerDetailPathDetailModel*model=self.secondSectionAllDatas[indexPath.row];
        //        [JRToast showWithText:model.C_TYPE];
//        if ([model.C_TYPE_DD_ID isEqualToString:@""]) {
//            [self assistFollowDetailVCWithModel:model andIndexPath:indexPath];
//        }
        
//        if ([model.C_TYPE_DD_ID isEqualToString:@"A85500_C_TYPE_0003"]) {//跟进
//            [self FollowDetailVCWithModel:model andIndexPath:indexPath];
//        }
        
        if ([model.I_TYPE isEqualToString:@"12"]) {
            MJKClueDetailViewController *vc = [[MJKClueDetailViewController alloc]init];
            MJKClueListMainSecondModel *clueListModel = [[MJKClueListMainSecondModel alloc]init];
            clueListModel.C_ID = model.C_OBJECT_ID;
            vc.clueListMainSecondModel = clueListModel;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        if ([model.C_TYPE isEqualToString:@"售后满意度"]) {
            MJKQuestionnaireViewController * vc=[[MJKQuestionnaireViewController alloc] init];
            vc.vcName = @"售后满意度";
            vc.C_ID=model.C_OBJECT_ID;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if ([model.C_TYPE isEqualToString:@"报备"]) {
            MJKClueListMainSecondModel*postModel=[[MJKClueListMainSecondModel alloc]init];
            postModel.C_ID=model.C_OBJECT_ID;
            
            MJKClueDetailViewController * vc=[[MJKClueDetailViewController alloc] init];
            vc.clueListMainSecondModel=postModel;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        
        if ([model.C_TYPE_DD_ID isEqualToString:@"A85500_C_TYPE_0003"] || [model.C_TYPE_DD_ID isEqualToString:@"A85500_C_TYPE_0004"] || [model.C_TYPE_DD_ID isEqualToString:@"A85500_C_TYPE_0006"]) {
            [self FollowDetailVCWithModel:model andIndexPath:indexPath];
            
        }else if ([model.C_TYPE isEqualToString:@"预约"]){
            CGCAppiontDetailVC * vc=[[CGCAppiontDetailVC alloc] init];
            vc.C_ID= model.C_OBJECT_ID;
            vc.rootVC = self;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if ([model.C_TYPE_DD_ID isEqualToString:@"A85500_C_TYPE_0007"]){
            OrderDetailViewController * vc=[[OrderDetailViewController alloc] init];
            [[NSUserDefaults standardUserDefaults]setObject:@"order" forKey:@"VCName"];
            vc.orderId=model.C_OBJECT_ID;
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if ([model.C_TYPE isEqualToString:@"名单"]){
            
            MJKClueListMainSecondModel*postModel=[[MJKClueListMainSecondModel alloc]init];
            postModel.C_ID=model.C_OBJECT_ID;
            
            MJKClueDetailViewController * vc=[[MJKClueDetailViewController alloc] init];
            vc.clueListMainSecondModel=postModel;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if ([model.C_TYPE isEqualToString:@"流量"]){
            MJKFlowDetailViewController * vc=[[MJKFlowDetailViewController alloc] init];
            vc.C_ID=model.C_OBJECT_ID;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if ([model.C_TYPE isEqualToString:@"工单"]){
            
            [JRToast showWithText:@"工单暂无"];
            
        } else if ([model.C_TYPE isEqualToString:@"任务"]) {
            if ([model.C_OBJECTSTATUS_DD_NAME isEqualToString:@"未执行"]) {
                ServiceTaskPerformViewController *vc = [[ServiceTaskPerformViewController alloc]init];
                vc.title = @"任务执行";
                vc.C_ID = model.C_OBJECT_ID;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                ServiceTaskTrueDetailViewController *vc = [[ServiceTaskTrueDetailViewController alloc]init];
                vc.title = @"任务详情";
                vc.C_ID = model.C_OBJECT_ID;
                [self.navigationController pushViewController:vc animated:YES];
            }
        } else if ([model.C_TYPE_DD_ID isEqualToString:@"A85500_C_TYPE_0001"]) { //售后
            MJKOldCustomerSalesViewController *vc = [[MJKOldCustomerSalesViewController alloc]init];
            vc.C_ID = model.C_OBJECTID;
            vc.C_TYPE_DD_ID = @"A81500_C_TYPE_0001";
            vc.C_FSLX_DD_ID = self.mainModel.C_FSLX_DD_ID;
            [self.navigationController pushViewController:vc animated:YES];
        }
//        }
        
        
        
        
        
        
        
        
        
    }
    
}


-(void)FollowDetailVCWithModel:(CustomerDetailPathDetailModel*)model andIndexPath:(NSIndexPath*)indexPath{
    DBSelf(weakSelf);
    //存在的话 必定是全部 状态 不是跟进里面的
    CustomerDetailPathDetailModel *subModel = self.mainPathModel.content[indexPath.row];
    
//        //            indexPath.row==0  可编辑  其他不可编辑。
//        if (indexPath.row==0&&self.isZhanbai==NO&&[subModel.C_TYPE isEqualToString:@"粉丝关怀"]) {
//            //可编辑
//            FansFollowAddEditViewController*vc=[[FansFollowAddEditViewController alloc]init];
//            vc.Type=CustomerFollowUpEdit;
//            vc.infoModel=weakSelf.detailInfoModel;
//            vc.vcSuper=weakSelf;
//            vc.canEdit=YES;
//            vc.followText = model.X_REMARK;
//            vc.objectID=model.C_OBJECT_ID;
//            [weakSelf.navigationController pushViewController:vc animated:YES];
//
//
//
//        }else{
            //不可编辑
            
            [self httpPostGetBeforeDatas:model.C_OBJECTID andSuccess:^{
                FansFollowAddEditViewController*vc=[[FansFollowAddEditViewController alloc]init];
                vc.Type=CustomerFollowUpEdit;
                //            vc.infoModel=weakSelf.detailInfoModel;
                vc.infoModel = weakSelf.detailFollowInfoModel;
                vc.vcSuper=weakSelf;
                vc.canEdit=NO;
                vc.objectID=model.C_OBJECTID;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }];
            
//        }
    
}

-(void)httpPostGetBeforeDatas:(NSString *)objectID andSuccess:(void(^)(void))complet{
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_ID"] = objectID;
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkWithUrl:HTTP_FollowInfo parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            
            self.detailFollowInfoModel=[CustomerDetailInfoModel yy_modelWithDictionary:data];
            if (complet) {
                complet();
            }
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
    }];
    
    
}

-(void)assistFollowDetailVCWithModel:(CustomerDetailPathDetailModel*)model andIndexPath:(NSIndexPath*)indexPath{
    DBSelf(weakSelf);
    //存在的话 必定是全部 状态 不是跟进里面的
    CustomerDetailPathDetailModel *subModel = self.mainPathModel.content[indexPath.row];
    if (self.assistfitstFollowInAll&&self.isZhanbai==NO&&[subModel.C_TYPE isEqualToString:@"协助跟进"]) {
        if ([self.assistfitstFollowInAll.C_OBJECT_ID isEqualToString:model.C_OBJECT_ID]) {
            //可编辑
            AssistFollowViewController*vc=[[AssistFollowViewController alloc]init];
            vc.Type=AssistFollowUpEdit;
            vc.infoModel=weakSelf.detailInfoModel;
            vc.vcSuper=weakSelf;
            vc.canEdit=YES;
            vc.objectID=model.C_OBJECT_ID;
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
            
            
            
        }else{
            //不可编辑
            AssistFollowViewController*vc=[[AssistFollowViewController alloc]init];
            vc.Type=AssistFollowUpEdit;
            vc.infoModel=weakSelf.detailInfoModel;
            vc.vcSuper=weakSelf;
            vc.canEdit=NO;
            vc.objectID=model.C_OBJECT_ID;
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        }
        
        
    }else{
        //            indexPath.row==0  可编辑  其他不可编辑。
        if (indexPath.row==0&&self.isZhanbai==NO&&[subModel.C_TYPE isEqualToString:@"跟进"]) {
            //可编辑
            AssistFollowViewController*vc=[[AssistFollowViewController alloc]init];
            vc.Type=AssistFollowUpEdit;
            vc.infoModel=weakSelf.detailInfoModel;
            vc.vcSuper=weakSelf;
            vc.canEdit=YES;
            vc.objectID=model.C_OBJECT_ID;
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
            
            
        }else{
            //不可编辑
            
            AssistFollowViewController*vc=[[AssistFollowViewController alloc]init];
            vc.Type=AssistFollowUpEdit;
            vc.infoModel=weakSelf.detailInfoModel;
            vc.vcSuper=weakSelf;
            vc.canEdit=NO;
            vc.objectID=model.C_OBJECT_ID;
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        }
        
        
    }
    
    
}



-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    DBSelf(weakSelf);
    if (section==0) {
        CustomLabelHeaderView*header=[tableView dequeueReusableHeaderFooterViewWithIdentifier:CELLHeader];
        header.isZhanbai=self.isZhanbai;
        header.nameType = @"粉丝";
//        header.mainModel=self.detailInfoModel;
        header.membersDetailModel = self.detailInfoModel;
        header.allLabelArray=self.detailInfoModel.labelsList;
        header.Type=CusomterInfoDetail;
        UIButton *button = [header viewWithTag:917];
        button.hidden = YES;
//        header.clickDetailBlock = ^{
//            //进入 编辑潜客 界面
//            if (self.isAssist == YES) {
//                return ;
//            } AddOrEditlCustomerViewController*vc=[[AddOrEditlCustomerViewController alloc]init];
//            vc.Type=customerTypeEdit;
//            vc.mainModel=weakSelf.detailInfoModel;
//            [weakSelf.navigationController pushViewController:vc animated:YES];
//
//
//        };
        header.clickLinkCustomerBlock = ^{
            CustomerDetailViewController *vc = [[CustomerDetailViewController alloc]init];
            PotentailCustomerListDetailModel *model = [[PotentailCustomerListDetailModel alloc]init];
            model.C_ID = weakSelf.detailInfoModel.C_A41500_C_ID;
            model.C_A41500_C_ID = weakSelf.detailInfoModel.C_A41500_C_ID;
            vc.mainModel = model;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        header.clickToEditTagViewBlock = ^{
            //编辑标签  界面
            scribeCustomLabelViewController*vc=[[scribeCustomLabelViewController alloc]init];
            vc.mainModel=weakSelf.detailInfoModel;
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
            
        };
        
        
        return header;
        
    }else if (section==1){
        UIView*mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 10)];
        mainView.backgroundColor=[UIColor whiteColor];
        
        UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(105-5, 0, 10, 10)];
        imageView.image=[UIImage imageNamed:@"topimg"];
        [mainView addSubview:imageView];
        
        return mainView;
    }
    
    
    else{
        return nil;
    }
    
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==1) {
        UIView*mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 10)];
        mainView.backgroundColor=[UIColor whiteColor];
        
        UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(105-5, 0, 10, 10)];
        imageView.image=[UIImage imageNamed:@"bottomimg"];
        [mainView addSubview:imageView];
        
        return mainView;
        
        
    }else{
        return nil;
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return [CustomLabelHeaderView headerHeight:self.detailInfoModel.labelsList andType:CusomterInfoDetail] + 20;
    }else if (section==1){
        return 10;
    }
    
    else{
        return 0.01;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else if (section==1){
        return 10;
    }else{
        return 0.01;
    }
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&indexPath.row==0) {
        return 180;
    }else{
        return 80;
    }
}

-(void)openWechat{
    NSURL * url = [NSURL URLWithString:@"weixin://"];
//    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
    //先判断是否能打开该url
//    if (canOpen)
//    {   //打开微信
        [[UIApplication sharedApplication] openURL:url];
//    }else {
//        [JRToast showWithText:@"您的设备未安装微信APP"];
//    }
}

#pragma mark  --click
- (void)clickHistory {
    MJKHistoryFlowViewController *vc = [[MJKHistoryFlowViewController alloc]init];
    vc.VCName = @"粉丝";
    vc.C_A41500_C_ID = self.detailInfoModel.C_ID;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)clickShare{
    MyLog(@"分享");
    //分享的内容：  姓名：  电话：   意向等级：    意向产品：
    NSString*nameStr=[NSString stringWithFormat:@"客户姓名:%@",self.detailInfoModel.C_NAME];
    NSString*phoneStr=[NSString stringWithFormat:@"联系电话:%@",self.detailInfoModel.C_PHONE];
    NSString*levelStr=[NSString stringWithFormat:@"客户等级:%@",self.detailInfoModel.C_LEVEL_DD_NAME];
    NSString*productStr=[NSString stringWithFormat:@"意向产品:%@",self.detailInfoModel.X_INTENTIONREMARK];
    NSString*totailStr=[NSString stringWithFormat:@"%@\n%@\n%@\n%@",nameStr,phoneStr,levelStr,productStr];
    
    
    
    UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction*cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    //修改按钮
    
    [cancelAction setValue:[UIColor lightGrayColor] forKey:@"titleTextColor"];
    
    
    UIAlertAction*wechatAction=[UIAlertAction actionWithTitle:@"微信分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.text =totailStr;
        req.bText = YES;
        req.scene = 0;
        [WXApi sendReq:req completion:nil];
        return;
        
        
        
    }];
    
    [wechatAction setValue:[UIColor lightGrayColor] forKey:@"titleTextColor"];
    
    
    UIAlertAction*shortMessageAction=[UIAlertAction actionWithTitle:@"短信分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        MFMessageComposeViewController *vc = [[MFMessageComposeViewController alloc] init];
        // 设置短信内容
        vc.body = totailStr;
        
        // 设置收件人列表
        vc.recipients = @[@"666666"];  // 号码数组
        // 设置代理
        vc.messageComposeDelegate = self;
        // 显示控制器
        [self presentViewController:vc animated:YES completion:nil];
        
        
        
    }];
    
    [shortMessageAction setValue:[UIColor lightGrayColor] forKey:@"titleTextColor"];
    
    
    [alertVC addAction:wechatAction];
    [alertVC addAction:shortMessageAction];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
    
    
    
    
    
    
    
}


#pragma mark  --delegate
- (void)messageComposeViewController:(MFMessageComposeViewController*)controller didFinishWithResult:(MessageComposeResult)result
{
    // 关闭短信界面
    [controller dismissViewControllerAnimated:YES completion:nil];
    if(result == MessageComposeResultCancelled) {
        [JRToast showWithText:@"取消发送"];
        //        NSLog(@"取消发送");
    } else if(result == MessageComposeResultSent) {
        [JRToast showWithText:@"已经发出"];
        //        NSLog(@"已经发出");
    } else {
        [JRToast showWithText:@"发送失败"];
        //        NSLog(@"发送失败");
    }
}


-(void)delegateShowFirstView{
    self.toolView.backView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        if (self.toolView.ToolLeftButton.isSelected == NO) {
            CGRect toolFrame = self.toolView.frame;
            //(0, KScreenHeight-50 - SafeAreaBottomHeight, KScreenWidth, 50+70 + 70)
            toolFrame.origin.y = KScreenHeight-50 - SafeAreaBottomHeight;
            toolFrame.size.height = 50+70 + 70 + SafeAreaBottomHeight;
            self.toolView.toolMainViewHeightLayout.constant = 50;
            self.toolView.toolTextViewHeightLayout.constant = 44;
            self.toolMainViewHeight = 0;
            self.toolView.ToolTextField.text = @"";
        }
        CGRect rect=self.toolView.frame;
        rect.origin.y=KScreenHeight-self.toolView.toolMainViewHeightLayout.constant - SafeAreaBottomHeight;
        self.toolView.frame=rect;
        
    }];
    
}
-(void)delegateShowChooseView{
    self.toolView.backView.hidden = YES;
    [UIView animateWithDuration:0.25 animations:^{
        CGRect rect=self.toolView.frame;
        rect.origin.y=KScreenHeight-self.toolView.toolMainViewHeightLayout.constant-80 - SafeAreaBottomHeight - 60 ;
        self.toolView.frame=rect;
        
    }];
    
    
}
-(void)delegateShowKeyBoardViewWithY:(CGFloat)keyBoardY{
    self.toolView.addButton.selected = YES;
    [UIView animateWithDuration:0.25 animations:^{
        CGRect rect=self.toolView.frame;
        //        rect.origin.y=KScreenHeight-258-30-50;
        rect.origin.y=keyBoardY-30 - self.toolView.toolMainViewHeightLayout.constant;
        self.toolView.frame=rect;
        
    }];
    
}

//-(void)delegateShowFirstView{
//    [UIView animateWithDuration:0.25 animations:^{
//        CGRect rect=self.toolView.frame;
//        rect.origin.y=KScreenHeight - 50;
//        self.toolView.frame=rect;
//
//    }];
//
//}
//-(void)delegateShowChooseView{
//    [UIView animateWithDuration:0.25 animations:^{
//        CGFloat y = [[[NSUserDefaults standardUserDefaults]objectForKey:@"VCName"] isEqualToString:@"协助"] ? 0 : 70;
//        CGRect rect=self.toolView.frame;
//        rect.origin.y=KScreenHeight-70 - y ;
//        self.toolView.frame=rect;
//
//    }];
//
//
//}
//-(void)delegateShowKeyBoardViewWithY:(CGFloat)keyBoardY{
//    [UIView animateWithDuration:0.25 animations:^{
//        CGRect rect=self.toolView.frame;
//        //        rect.origin.y=KScreenHeight-258-30-50;
//        rect.origin.y=keyBoardY-30 - 70;
//        self.toolView.frame=rect;
//
//    }];
//
//}


#pragma mark  --getDatas

- (void)HTTPCardData {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"UserWebService-qrcodeToCard"];
    
    NSMutableDictionary *dic=[NSMutableDictionary new];
    dic[@"C_ID"] = [NewUserSession instance].user.u051Id;
    dic[@"appid"] = [NewUserSession instance].C_APPID;
    dic[@"appsecret"] = [NewUserSession instance].C_APPSECRET;

    
    [dict setObject:dic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    
    DBSelf(weakSelf);
    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
            MJKCardView *cardView = [[NSBundle mainBundle]loadNibNamed:@"MJKCardView" owner:nil options:nil].firstObject;
            cardView.rootVC = weakSelf;
            cardView.vcName = @"名片";
            [cardView.qrcodeImageView sd_setImageWithURL:[NSURL URLWithString:data[@"qrcode"]]];
            cardView.qrCodeStr = data[@"qrcode"];
            [[UIApplication sharedApplication].keyWindow addSubview:cardView];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
    
}
-(void)httpPostGetCustomerDetailInfoWithSuccessBlock:(void(^)(void))completeBlock{
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/crm/a477/info", HTTP_IP] parameters:@{@"C_ID":self.mainModel.C_ID} compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            
            self.detailInfoModel=[CustomerDetailInfoModel yy_modelWithDictionary:data[@"data"]];
            self.detailInfoModel.isJJR=@"isOK";
            self.toolView.fansStar = [self.detailInfoModel.C_STAR_DD_ID isEqualToString:@"A41500_C_STAR_0000"] ? @"星标客户" : @"未星标客户";
            [self getRealLabelsList:self.detailInfoModel.labelsList];
            [self toolView];
            
            //刷新 现在是不是战败
            if ([self.detailInfoModel.C_STATUS_DD_NAME isEqualToString:@"战败"]) {
                self.isZhanbai=YES;
                self.toolView.hidden=YES;
            }else{
                self.isZhanbai=NO;
                self.toolView.hidden=NO;
            }
            
            if (completeBlock) {
                completeBlock();
            }
            
            [self.tableView reloadData];
            
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
    
    
}

-(void)httpPostGetCustomerFollowDetailInfo:(NSString *)objectID andSuccess:(void(^)(void))complet {
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/crm/a416/info", HTTP_IP] parameters:@{@"C_A41600_C_ID":objectID} compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            
            self.detailFollowInfoModel=[CustomerDetailInfoModel yy_modelWithDictionary:data[@"data"]];
            if (complet) {
                complet();
            }
        }
    }];
    
    
    
}

//回调 来决定是  全盘刷新  还是就刷新section1
-(void)httpGetCustomerPathWithsuccess:(void(^)(id data))successBlock{
    if (![[NewUserSession instance].appcode containsObject:@"crm:a477:gjlist"]) {
        [JRToast showWithText:@"账号无权限"];
        return;
    }
    NSString*C_TYPE=@"1";
    switch (self.touchButtonIndex) {
        case 0:{
            C_TYPE=@"1";
            break;}
        case 1:{
            C_TYPE=@"2";
            break;}
        case 2:{
            C_TYPE=@"3";
            break;}
        case 3:{
            C_TYPE=@"4";
            break;}
        case 4:{
            C_TYPE=@"5";
            break;}
        default:
            break;
    }


    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"pageNum"] = @(self.pages);
    contentDic[@"pageSize"] = @(self.pagen);
    contentDic[@"C_A47700_C_ID"] = self.detailInfoModel.C_ID;
    contentDic[@"tableType"] = C_TYPE;
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/crm/a855/list", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
            
            if (self.pages==1) {
                [self.secondSectionAllDatas removeAllObjects];
            }
            self.mainPathModel=[CustomerDetailPathModel yy_modelWithDictionary:data[@"data"]];
            [self.secondSectionAllDatas addObjectsFromArray:self.mainPathModel.list];
        
            successBlock(data);

        }else{
            [JRToast showWithText:data[@"message"]];
            }
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getCrmA855List{
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"pageNum"] = @(1);
    contentDic[@"pageSize"] = @(10);
    contentDic[@"C_A47700_C_ID"] = self.mainModel.C_ID;
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkWithUrl:HTTP_SYSTEMDA855List parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
            weakSelf.oldArray = [BrokerOldCustomerModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"list"]];
            weakSelf.mainPathModel.B_DT = [NSString stringWithFormat:@"%@",data[@"data"][@"count"]];
            [weakSelf.tableView reloadData];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}
#pragma mark  --set
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight-48-NavStatusHeight - WD_TabBarHeight - SafeAreaBottomHeight) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor=[UIColor whiteColor];
        //        _tableView.scrollEnabled=NO;
        _tableView.estimatedRowHeight=0;
        _tableView.estimatedSectionHeaderHeight=0;
        _tableView.estimatedSectionFooterHeight=0;
    }
    
    return _tableView;
}

-(CustomerDetailBottomToolView *)toolView{
    DBSelf(weakSelf);
    if (!_toolView) {
        NSMutableArray *titleArray = [NSMutableArray array];
        NSMutableArray *imageArray = [NSMutableArray array];
        if ([[NewUserSession instance].appcode containsObject:@"crm:a477:gj"]) {
            [titleArray addObject:@"粉丝关怀"];
            [imageArray addObject:@"more_新增跟进"];
        }
        if ([[NewUserSession instance].appcode containsObject:@"APP015_0002"]) {
            [titleArray addObject:@"转介绍"];
            [imageArray addObject:@"icon_transfer"];
        }
        if ([[NewUserSession instance].appcode containsObject:@"crm:a477:zp"]) {
            [titleArray addObject:@"指派"];
            [imageArray addObject:@"重新指派"];
        }
        
        [titleArray addObject:@"星标"];
        if ([self.mainModel.C_STAR_DD_ID isEqualToString:@"A41500_C_STAR_0000"]) {
            [imageArray addObject:@"星标客户"];
        } else {
            [imageArray addObject:@"未星标客户"];
        }
        
//        [titleArray addObject:@"变更类型"];
//        [imageArray addObject:@"更换类型"];
        
        if ([[NewUserSession instance].appcode containsObject:@"crm:a477:sh"]) {
            [titleArray addObject:@"售后"];
            [imageArray addObject:@"icon_source_sales"];
        }
        
        if ([[NewUserSession instance].appcode containsObject:@"crm:a477:zx"]) {
            [titleArray addObject:@"咨询"];
            [imageArray addObject:@"aab"];
        }
        
        _toolView=[[CustomerDetailBottomToolView alloc]initWithFrame:CGRectMake(0, KScreenHeight-50 - SafeAreaBottomHeight, KScreenWidth, 50+70 + 70) andTitleArray:titleArray andImageArray:imageArray];
        
        _toolView.backView.hidden = NO;
//        _toolView=[[CustomerDetailBottomToolView alloc]initWithFrame:CGRectMake(0, KScreenHeight-50 - SafeAreaBottomHeight, KScreenWidth, 50+70 + 70) andIsMoreLines:YES];
        _toolView.delegate=self;
        __block CustomerDetailBottomToolView *toolView = _toolView;
        _toolView.textChangeBlock = ^(NSString *str) {
            CGSize size = [str boundingRectWithSize:CGSizeMake(KScreenWidth - 115, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
            toolView.toolTextViewHeightLayout.constant = size.height + 20;
            toolView.toolMainViewHeightLayout.constant = size.height + 32;
            //            CGRect rect = self.ToolMainView.frame;
            NSInteger tempHeight = size.height;
            CGRect toolrect = toolView.frame;
            if (weakSelf.toolMainViewHeight != tempHeight && weakSelf.toolMainViewHeight != 0) {
                
                //                rect.origin.y = rect.origin.y - self.toolMainViewHeightLayout.constant;
                toolrect.origin.y = toolrect.origin.y - (tempHeight - weakSelf.toolMainViewHeight);
                toolrect.size.height =  toolrect.size.height + (tempHeight - weakSelf.toolMainViewHeight);
            }
            weakSelf.toolMainViewHeight = size.height;
            //    self.ToolTextField.frame = toolrect;
            
            toolView.frame = toolrect;
        };
        weakSelf.toolView.followBlock = ^(NSString *text) {
            if (![[NewUserSession instance].appcode containsObject:@"crm:a477:gj"]) {
                [JRToast showWithText:@"账号无权限"];
                return;
            }
            MyLog(@"%@",text);
            FansFollowAddEditViewController*vc=[[FansFollowAddEditViewController alloc]init];
            vc.Type=FansFollowUpAdd;
            vc.infoModel=weakSelf.detailInfoModel;
            vc.vcSuper=weakSelf;
            vc.followText=text;
            vc.successBlock = ^{
                _toolView.ToolTextField.text = @"";
                [[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:@"isRefresh"];
            };
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        };
        
        
        
        weakSelf.toolView.endRecordBlock = ^(NSString *recordStr) {
            if (![[NewUserSession instance].appcode containsObject:@"crm:a477:gj"]) {
                [JRToast showWithText:@"账号无权限"];
                return;
            }
            MyLog(@"%@",recordStr);
            weakSelf.toolView.ToolTextField.text=recordStr;
                FansFollowAddEditViewController*vc=[[FansFollowAddEditViewController alloc]init];
                vc.Type=FansFollowUpAdd;
                vc.infoModel=weakSelf.detailInfoModel;
                vc.vcSuper=weakSelf;
                vc.followText=recordStr;
                vc.successBlock = ^{
                    _toolView.ToolTextField.text = @"";
                    [[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:@"isRefresh"];
                };
                [weakSelf.navigationController pushViewController:vc animated:YES];
            
            
        };
        
        
        
        
		weakSelf.toolView.clickChooseButtonBlock = ^(NSInteger index, NSString *title) {
            MyLog(@"%lu",index);
            if ([title isEqualToString:@"星标"]) {
                //星标客户
                NSString*starStr;
                if ([self.detailInfoModel.C_STAR_DD_ID isEqualToString:@"A41500_C_STAR_0000"]) {
                    starStr=@"A41500_C_STAR_0001";
                }else{
                    starStr=@"A41500_C_STAR_0000";
                }
                [weakSelf setStarStatusWithStarID:starStr andCustomerID:self.mainModel.C_ID success:^(id data) {
                    MyLog(@"%@",data);
                    [weakSelf.toolView initialStatus];
//                    [weakSelf.tableView.mj_header beginRefreshing];
                    [weakSelf httpPostGetCustomerDetailInfoWithSuccessBlock:^{
                        [weakSelf.tableView reloadData];
                    }];
                    
                }];
            } else if ([title isEqualToString:@"指派"]) {//重新指派
                //跳转  到下一个界面  选择好  销售之后  回调  来用  saveAllChooseArray 的东西和销售吊接口  完成之后 在移除这个view
                MJKMarketViewController*vc=[[MJKMarketViewController alloc]init];
                vc.backSelectParameterBlock = ^(NSString *codeStr, NSString *nameStr) {
                    MyLog(@"%@   %@",codeStr,nameStr);
                    
                    [weakSelf AssignCustomerToSaleWithSalerID:codeStr andCustomerIDS:self.mainModel.C_ID success:^(id data) {
                        MyLog(@"%@",data);
                        if ([data[@"code"] integerValue]==200) {
                            //这里需要调用接口    重新分配的接口
                            
                            [weakSelf httpPostGetCustomerDetailInfoWithSuccessBlock:^{
//                                [weakSelf.tableView reloadData];
                                [weakSelf.toolView initialStatus];
                                [weakSelf.tableView.mj_header beginRefreshing];
                                [[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:@"isRefresh"];
                            }];
                            
                        }else{
                            [JRToast showWithText:data[@"msg"]];
                        }
                    }];
                };
                [weakSelf.navigationController pushViewController:vc animated:YES];
                
                
            } else if ([title isEqualToString:@"转介绍"]) {
                MJKClueAddViewController *addVC = [[MJKClueAddViewController alloc]init];
                addVC.agentStr = self.detailInfoModel.C_NAME;
                addVC.agentCode = self.detailInfoModel.C_ID;
                addVC.vcName = @"转介绍";
                [self.navigationController pushViewController:addVC animated:YES];
            } else if ([title isEqualToString:@"粉丝关怀"]) {
                //跟进
                FansFollowAddEditViewController*vc=[[FansFollowAddEditViewController alloc]init];
                vc.Type=FansFollowUpAdd;
                vc.infoModel=weakSelf.detailInfoModel;
                vc.vcSuper=weakSelf;
//                vc.followText=text;
                                    vc.successBlock = ^{
                                        [[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:@"isRefresh"];
                                    };
                [weakSelf.navigationController pushViewController:vc animated:YES];
            } else if ([title isEqualToString:@"变更类型"]) {
                MJKAgentChangeStatusViewController *vc = [[MJKAgentChangeStatusViewController alloc]init];
                vc.C_TYPE_DD_ID = self.detailInfoModel.C_TYPE_DD_ID;
                vc.C_ID = self.detailInfoModel.C_ID;
                vc.C_STATUS_DD_ID = self.detailInfoModel.C_STATUS_DD_ID;
                vc.phone= self.detailInfoModel.C_PHONE;
                vc.C_INDUSTRY_DD_ID = self.detailInfoModel.C_INDUSTRY_DD_ID;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            } else if ([title isEqualToString:@"售后"]) {
                MJKOldCustomerSalesViewController *vc = [[MJKOldCustomerSalesViewController alloc]init];
                vc.C_A47700_C_ID = self.mainModel.C_ID;
                vc.C_TYPE_DD_ID = @"A81500_C_TYPE_0001";
                vc.C_FSLX_DD_ID = self.mainModel.C_FSLX_DD_ID;
                vc.C_A41500_C_ID = self.detailInfoModel.C_A41500_C_ID;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            } else if ([title isEqualToString:@"咨询"]) {
                MJKOldCustomerConsultViewController *vc = [[MJKOldCustomerConsultViewController alloc]init];
                vc.C_A47700_C_ID = self.mainModel.C_ID;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        };
        
        
    }
    
    if ([self.detailInfoModel.C_STAR_DD_ID isEqualToString:@"A41500_C_STAR_0000"]) {
        _toolView.isStar=YES;
    }else{
        _toolView.isStar=NO;
    }
    
    
    
    
    return _toolView;
    
}

//星标接口
-(void)setStarStatusWithStarID:(NSString*)starID andCustomerID:(NSString*)customerID success:(void(^)(id data))successBlock{
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:@"A47700WebService-updateStar"];
    NSDictionary*contentDict=@{@"C_ID":customerID,@"C_STAR_DD_ID":starID};
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        if (successBlock) {
            successBlock(data);
        }
        
    }];
    
    
    
}

//重新指派粉丝    salerIDS 潜客的ids  多个就用，隔开
-(void)AssignCustomerToSaleWithSalerID:(NSString*)salerID andCustomerIDS:(NSString*)customerIDS success:(void(^)(id data))successBlock{
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:@"A47700WebService-assign"];
    NSDictionary*contentDict=@{@"C_IDS":customerIDS,@"USER_ID":salerID};
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        if (successBlock) {
            successBlock(data);
        }
        
        
    }];
    
}



-(NSMutableArray<CustomerDetailPathDetailModel *> *)secondSectionAllDatas{
    if (!_secondSectionAllDatas) {
        _secondSectionAllDatas=[NSMutableArray array];
        //        [_secondSectionAllDatas addObjectsFromArray:@[@"",@"",@"",@""]];
    }
    return _secondSectionAllDatas;
}





#pragma mark  --funcation
//给labelsList 没赋值的key 赋值
-(void)getRealLabelsList:(NSMutableArray*)listArray{
    for (CustomLabelModel*model in listArray) {
        model.title=model.C_NAME;
        model.currentColor=[UIColor colorWithHexString:model.C_COLOR_DD_ID];
        model.isSelected=YES;
    }
    
    
}


//电话
- (void)telephoneCall:(NSInteger)index{
    if (self.detailInfoModel.C_PHONE.length>0) {
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:self.detailInfoModel.C_PHONE]]];
    }
  
}

- (void)whbcallBack:(NSInteger)index {
    if (self.detailInfoModel.C_PHONE.length > 0) {
        [DBObjectTools whbCallWithC_OBJECT_ID:self.detailInfoModel.C_ID andC_CALL_PHONE:self.detailInfoModel.C_PHONE andC_NAME:self.detailInfoModel.C_NAME andC_OBJECTTYPE_DD_ID:@"A83100_C_OBJECTTYPE_0002" andCompleteBlock:nil];
    } else {
       [JRToast showWithText:@"无电话号码"];
   }
}


//座机
- (void)landLineCall:(NSInteger)index{
    
    CommonCallViewController *myView=[[CommonCallViewController alloc]initWithNibName:@"CommonCallViewController" bundle:nil];
    myView.typeStr=@"用座机拨打";
    myView.nameStr=self.detailInfoModel.C_NAME;
    myView.callStr=self.detailInfoModel.C_PHONE;
    [self.navigationController pushViewController:myView animated:YES];
    
}

//回呼
- (void)callBack:(NSInteger)index{
    CommonCallViewController *myView=[[CommonCallViewController alloc]initWithNibName:@"CommonCallViewController" bundle:nil];
    myView.typeStr=@"回呼到手机";
    myView.nameStr=self.detailInfoModel.C_NAME;
    myView.callStr=self.detailInfoModel.C_PHONE;
    [self.navigationController pushViewController:myView animated:YES];
    
}



-(void)goBack{
    if (self.popVC) {
        [self.navigationController popToViewController:self.popVC animated:NO];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end
