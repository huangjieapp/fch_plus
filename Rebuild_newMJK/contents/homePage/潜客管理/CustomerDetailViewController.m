//
//  CustomerDetailViewController.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/9/20.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CustomerDetailViewController.h"
#import "CustomLabelHeaderView.h"
#import "CustomerDetailFirstRowTableViewCell.h"
#import "CustomerDetailSecondTableViewCell.h"
#import "CustomerDetailBottomToolView.h"
#import "CGCAlertDateView.h"
#import "ScaleView.h"  //放大view
#import "MJKHistoryFlowViewController.h"//历史记录
#import "MJKSingleDetailViewController.h"//签到
#import "MJKClueNewProcessViewController.h"


#import "CustomerDetailInfoModel.h"
#import "CustomerDetailPathModel.h"
#import "MJKClueListMainSecondModel.h"   //线索列表的model
#import "CGCAppointmentModel.h"   //预约的model

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

#import "MJKOrderFllowViewController.h"
#import "AddHelperViewController.h"//设计师

#import "MJKFlowProcessViewController.h"
#import "MJKFlowMeterSubSecondModel.h"
#import "MJKChooseEmployeesViewController.h"

#import "CGCNewAlertDateView.h"

#import "MJKOrderAddOrEditViewController.h"

#import "CGCCustomModel.h"
#import "VoiceRecordModel.h"


#define CELLHeader  @"CustomLabelHeaderView"
#define CELL0       @"CustomerDetailFirstRowTableViewCell"
#define CELL1       @"CustomerDetailSecondTableViewCell"
@interface CustomerDetailViewController ()<UITableViewDelegate,UITableViewDataSource,CustomerDetailBottomToolViewDelegate,MFMessageComposeViewControllerDelegate>{
    NSMutableArray *shopCodeArray;
    NSMutableArray *shopNameArray;
    NSIndexPath *_indexPath;
}

@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)CustomerDetailBottomToolView*toolView;


@property(nonatomic,assign)NSInteger pagen;
@property(nonatomic,assign)NSInteger pages;
@property(nonatomic,strong)CustomerDetailInfoModel*detailInfoModel;
@property(nonatomic,strong)CustomerDetailInfoModel*detailFollowInfoModel;
@property(nonatomic,strong)CustomerDetailPathModel*mainPathModel;
@property(nonatomic,strong)NSMutableArray<CustomerDetailPathDetailModel*>*secondSectionAllDatas;


//全部中的第一条 跟进  数据
@property(nonatomic,strong)CustomerDetailPathDetailModel*fitstFollowInAll;
@property(nonatomic,strong)CustomerDetailPathDetailModel*assistfitstFollowInAll;
/** <#备注#>*/
@property (nonatomic, strong) CustomerDetailPathDetailModel *orderfitstFollowInAll;
@property(nonatomic,assign) CGFloat returnHeight;

@property(nonatomic,assign)BOOL isZhanbai;  //如果战败了   那么tools 潜客编辑 标签编辑 点击不了。
/** <#备注#>*/
@property (nonatomic, assign) NSInteger toolMainViewHeight;


@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UILabel *errorLabel;
/** <#注释#>*/
@property (nonatomic, strong) NSString *errorStr;
/** <#注释#> */
@property (nonatomic, assign) BOOL isVoice;
/** <#注释#> */
@property (nonatomic, strong) NSArray *pathArray;
/** <#注释#> */
@property (nonatomic, strong) NSString *voiceNubmer;
@property (nonatomic, strong) AVPlayer *player;
@end

@implementation CustomerDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self defineBackButton];
    self.title=@"潜客详情";
    if ([self.mainModel.C_STATUS_DD_ID isEqualToString:@"A41500_C_STATUS_0003"]) {
        self.isZhanbai=YES;
    }else{
        self.isZhanbai=NO;
    }
    self.isVoice = YES;
    
    [self creatNavi];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:CELLHeader bundle:nil] forHeaderFooterViewReuseIdentifier:CELLHeader];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
    [self.tableView registerNib:[UINib nibWithNibName:CELL1 bundle:nil] forCellReuseIdentifier:CELL1];
    [self setUpRefresh];
    
    [self.view addSubview:self.toolView];
    if (self.isZhanbai) {
        self.toolView.hidden=YES;
        CGRect frame = self.tableView.frame;
        frame.size.height = KScreenHeight-NavStatusHeight - WD_TabBarHeight - SafeAreaBottomHeight;
        self.tableView.frame = frame;
    }else{
        self.toolView.hidden=NO;
    }
	if (@available(iOS 11.0, *)) {
		self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}
		self.automaticallyAdjustsScrollViewInsets = NO;
	
    
    [self getShopValues];
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.errorLabel];
    
    self.errorLabel.hidden = self.maskView.hidden = YES;

    
}

#pragma mark 门店
-(void)getShopValues{
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/crm/a403/list", HTTP_IP] parameters:@{} compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            shopCodeArray = [NSMutableArray array];
            shopNameArray = [NSMutableArray array];
            
            NSArray *itemArray=[data objectForKey:@"data"];
            for (int i = 0; i < itemArray.count; i++) {
                [shopNameArray addObject:itemArray[i][@"C_NAME"]];
                [shopCodeArray addObject:itemArray[i][@"C_LOCCODE"]];
            }
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //监听手机挂电话
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(alertViewFollow) name:@"CTCallStateDisconnected" object:nil];
    [self.tableView.mj_header beginRefreshing];
	if ([self.assistStr isEqualToString:@"协助"]) {
		[[NSUserDefaults standardUserDefaults]setObject:@"协助" forKey:@"VCName"];
	}
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"CTCallStateDisconnected" object:nil];
    
    [self.player pause];
    self.player = nil;
}

#pragma mark  --UI
-(void)defineBackButton{
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem= [UIBarButtonItem itemWithImage:@"btn-返回" highImage:nil isLeft:YES target:self andAction:@selector(goBack)];
    self.navigationItem.leftItemsSupplementBackButton = YES;
    
}


-(void)creatNavi{
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [button setBackgroundImage:[UIImage imageNamed:@"23-顶右button"] forState:UIControlStateNormal];
//    [button setTitleNormal:@"..." forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(clickShare)];
	[button addTarget:self action:@selector(clickHistory)];
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem=item;
    
}


-(void)setUpRefresh{
    self.pagen=10;
    self.pages=1;
    self.touchButtonIndex=0;
    
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pages=1;
//        self.touchButtonIndex=0;
        [self httpPostGetCustomerDetailInfo];
        if (self.touchButtonIndex == 4) {
            [self getVoiceRecord];
        } else {
            [self httpGetCustomerPathWithIndex:_touchButtonIndex andsuccess:^(id data) {
                [self.tableView reloadData];
            }];
            if (self.isVoice) {
                [self getVoiceRecord];
            }
        }
        
    }];
    
    self.tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pages++;
        if (self.touchButtonIndex == 4) {
            [self getVoiceRecord];
        } else {
            [self httpGetCustomerPathWithIndex:_touchButtonIndex andsuccess:^(id data) {
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
            }];
        }
        
    }];
    
    
    
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


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else{
        if ([self.errorStr isEqualToString:@"无权限"]) {
            return 0;
        }
        if (self.touchButtonIndex == 4) {
            return self.pathArray.count;
        } else {
            return self.secondSectionAllDatas.count;
        }
    }
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    DBSelf(weakSelf);
    
    
    if (indexPath.section==0&&indexPath.row==0) {
        CustomerDetailFirstRowTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
        if (self.mainPathModel) {
             cell.numberArray=[@[_mainPathModel.B_ALLCOUNT,_mainPathModel.B_FLOWCOUNT,_mainPathModel.B_FOLLOWCOUNT,_mainPathModel.B_ORDERCOUNT,self.voiceNubmer] mutableCopy];
        }
        if (self.detailInfoModel.X_REMRAK) {
            cell.remarkText=self.detailInfoModel.X_REMRAK;
        }
        
       
        cell.clickTopThreeButtonBlock = ^(NSInteger index) {
            MyLog(@"%lu",index);
            if (index==0) {
                if ([self.assistStr isEqualToString:@"协助"]) {
                    if (![[NewUserSession instance].appcode containsObject:@"APP016_0001"]) {
                        [JRToast showWithText:@"账号无权限"];
                        return ;
                    }
                } else {
                    if (![[NewUserSession instance].appcode containsObject:@"APP004_0021"]) {
                        [JRToast showWithText:@"账号无权限"];
                        return ;
                    }
                }
                    
                
                NSInteger index=indexPath.section*100+indexPath.row;
                [weakSelf selectTelephone:index];
                
            }else if (index==1){
                if ([self.assistStr isEqualToString:@"协助"]) {
                    if (![[NewUserSession instance].appcode containsObject:@"APP016_0002"]) {
                        [JRToast showWithText:@"账号无权限"];
                        return ;
                    }
                } else {
                    if (![[NewUserSession instance].appcode containsObject:@"APP004_0022"]) {
                        [JRToast showWithText:@"账号无权限"];
                        return ;
                    }
                }
                MFMessageComposeViewController *vc = [[MFMessageComposeViewController alloc] init];
                // 设置短信内容
            //    vc.body = @"吃饭了没？";
                // 设置收件人列表
                vc.recipients = @[weakSelf.detailInfoModel.C_PHONE];
                // 设置代理
                vc.messageComposeDelegate = self;
                // 显示控制器
                [self presentViewController:vc animated:YES completion:nil];
                
                
//                [JRToast showWithText:@"短信"];
            }else if (index==2){
//                 [JRToast showWithText:@"微信"];
                
                if ([self.assistStr isEqualToString:@"协助"]) {
                    if (![[NewUserSession instance].appcode containsObject:@"APP016_0003"]) {
                        [JRToast showWithText:@"账号无权限"];
                        return ;
                    }
                } else {
                    if (![[NewUserSession instance].appcode containsObject:@"APP004_0023"]) {
                        [JRToast showWithText:@"账号无权限"];
                        return ;
                    }
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
                if ([self.assistStr isEqualToString:@"协助"]) {
                    if (![[NewUserSession instance].appcode containsObject:@"APP016_0005"] && ![[NewUserSession instance].appcode containsObject:@"APP016_0016"]) {
                        [JRToast showWithText:@"账号无权限"];
                        return ;
                    }
                } else {
                    if (![[NewUserSession instance].appcode containsObject:@"crm:a415:edit"]) {
                        [JRToast showWithText:@"账号无权限"];
                        return ;
                    }
                }
                //        if (weakSelf.isAssist == YES) {
                //            return ;
                //        }
                AddOrEditlCustomerViewController*vc=[[AddOrEditlCustomerViewController alloc]init];
                vc.Type=customerTypeEdit;
                vc.mainModel=weakSelf.detailInfoModel;
                vc.C_A49600_C_ID = weakSelf.detailInfoModel.C_A49600_C_ID;
                vc.C_A70600_C_ID = weakSelf.detailInfoModel.C_A70600_C_ID;
                vc.assistStr = self.assistStr;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            } else if (index == 4) {
                NSString *str = [NSString stringWithFormat:@"%@ %@",self.detailInfoModel.C_A48200_C_NAME, self.detailInfoModel.C_ADDRESS];
                if (str.length <= 0) {
                    [JRToast showWithText:@"暂无客户地址"];
                    return;
                }
                MJKMapNavigationViewController *alertVC = [MJKMapNavigationViewController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                alertVC.C_ADDRESS = str;
                [self presentViewController:alertVC animated:YES completion:nil];
                
//                if ([self.assistStr isEqualToString:@"协助"]) {
//                    if (![[NewUserSession instance].appcode containsObject:@"APP016_0004"]) {
//                        [JRToast showWithText:@"账号无权限"];
//                        return ;
//                    }
//                } else {
//                    if (![[NewUserSession instance].appcode containsObject:@"APP004_0024"]) {
//                        [JRToast showWithText:@"账号无权限"];
//                        return ;
//                    }
//                }
//                [weakSelf HTTPCardData];
            }
            
            
        };
        cell.clickBottomEightButtonBlock = ^(NSInteger index) {
            MyLog(@"%lu",index);
            self.player = nil;
            self.touchButtonIndex=index;
            if (index == 4) {
                [weakSelf.tableView.mj_header beginRefreshing];
            } else {
                [weakSelf httpGetCustomerPathWithIndex:_touchButtonIndex andsuccess:^(id data) {
                    self.pages=1;
                    [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
                    
                }];
            }
            
            
        };
        
        
        
        return cell;
    }else if (indexPath.section==1){
        if (self.touchButtonIndex == 4) {
            VoiceRecordModel *model = self.pathArray[indexPath.row];
            CustomerDetailSecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL1];
            cell.voiceModel = model;
            return cell;
        } else {
            CustomerDetailSecondTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL1];
            CustomerDetailPathDetailModel*model=self.secondSectionAllDatas[indexPath.row];
            cell.MainModel=model;
            cell.clickScaleBlock = ^(CustomerDetailPathDetailModel *model) {
                MyLog(@"%@",model);
                [ScaleView scaleViewWithModel:model];
                
            };
            
            
            return cell;
        }
        
        
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section==1) {
        if (self.touchButtonIndex == 4) {
            if (indexPath.row != _indexPath.row) {
                self.player = nil;
            }
            _indexPath = indexPath;
            VoiceRecordModel *model = self.pathArray[indexPath.row];
            model.selected = !model.isSelected;
            CustomerDetailSecondTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.voiceModel = model;
            
            [self playButtonAction];
        } else {
            
            CustomerDetailPathDetailModel*model=self.secondSectionAllDatas[indexPath.row];
            //        [JRToast showWithText:model.C_TYPE];
            if ([model.I_TYPE isEqualToString:@"9"]) {
                [self assistFollowDetailVCWithModel:model andIndexPath:indexPath];
            }
            
            if ([model.I_TYPE isEqualToString:@"8"]) {
                [self orderFollowDetailVCWithModel:model andIndexPath:indexPath];
            }
            
            if ([model.I_TYPE isEqualToString:@"2"]) {
                [self FollowDetailVCWithModel:model andIndexPath:indexPath];
                
            }else if ([model.I_TYPE isEqualToString:@"3"]){
                CGCAppiontDetailVC * vc=[[CGCAppiontDetailVC alloc] init];
                vc.C_ID= model.C_OBJECT_ID;
                vc.rootVC = self;
                vc.assitStr = self.assistStr;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([model.I_TYPE isEqualToString:@"4"]){
                OrderDetailViewController * vc=[[OrderDetailViewController alloc] init];
                [[NSUserDefaults standardUserDefaults]setObject:@"order" forKey:@"VCName"];
                vc.orderId=model.C_OBJECT_ID;
                
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([model.I_TYPE isEqualToString:@"5"]){
                MJKClueNewProcessViewController *vc = [[MJKClueNewProcessViewController alloc]init];
                vc.c_id = model.C_OBJECT_ID;
                [self.navigationController pushViewController:vc animated:YES];
                
                
            }else if ([model.I_TYPE isEqualToString:@"0"] || [model.I_TYPE isEqualToString:@"null"]){
                if ([self.getFrom isEqualToString:@"流量详情"]) {
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    
                    MJKFlowProcessViewController *vc = [[MJKFlowProcessViewController alloc]init];
                    //                vc.model = subSecondModel;
                    MJKFlowMeterSubSecondModel *flowModel = [[MJKFlowMeterSubSecondModel alloc]init];
                    flowModel.C_ID = model.C_OBJECT_ID;
                    vc.model = flowModel;
                    vc.type = MJKFlowProcessOneImage;
                    vc.vcName = @"详情";
                    vc.clueName = @"已处理流量详情";
                    vc.typeName = @"有效流量";
                    vc.fromStr = @"轨迹详情";
                    //            MJKFlowDetailViewController * vc=[[MJKFlowDetailViewController alloc] init];
                    //            vc.C_ID=model.C_OBJECT_ID;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }else if ([model.C_TYPE isEqualToString:@"工单"]){
                
                [JRToast showWithText:@"工单暂无"];
                
            } else if ([model.I_TYPE isEqualToString:@"10"]) {
                if ([model.C_OBJECTSTATUS_DD_ID isEqualToString:@"A01200_C_STATUS_0003"] || [model.C_OBJECTSTATUS_DD_ID isEqualToString:@"A01200_C_STATUS_0001"]) {
                    ServiceTaskPerformViewController *vc = [[ServiceTaskPerformViewController alloc]init];
                    vc.title = @"任务执行";
                    vc.C_ID = model.C_OBJECT_ID;
                    vc.vcName = @"客户";
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    ServiceTaskTrueDetailViewController *vc = [[ServiceTaskTrueDetailViewController alloc]init];
                    vc.title = @"任务详情";
                    vc.C_ID = model.C_OBJECT_ID;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            } else if ([model.I_TYPE isEqualToString:@"11"]) {
                MJKSingleDetailViewController *vc = [[MJKSingleDetailViewController alloc]init];
                vc.C_ID = model.C_OBJECT_ID;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
            
            
        }
        
        
        
        
        
    }
    
}

- (void)playButtonAction {
    VoiceRecordModel *model = self.pathArray[_indexPath.row];
    if (model.C_URL.length > 0) {
        if (model.isSelected == YES) {
            if (self.player == nil) {
                [self playSound];
            }
            [self.player play];
        } else {
            [self.player pause];
        }
    }
    
}

#pragma mark - 播放语音
- (void)playSound {
    VoiceRecordModel *model = self.pathArray[_indexPath.row];
    NSURL * url  = [NSURL URLWithString:model.C_URL];
    AVPlayerItem * songItem = [[AVPlayerItem alloc]initWithURL:url];
    self.player = [[AVPlayer alloc]initWithPlayerItem:songItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
//    //@"http://cdn.51mcr.com/wav/2019-02-26/c5b29fe0-ae0e-46d7-ab74-fa9b75ec84ac.wav"
}

- (void)playbackFinished{
    self.player = nil;
    VoiceRecordModel *model = self.pathArray[_indexPath.row];
    model.selected = NO;
    CustomerDetailSecondTableViewCell *cell = [self.tableView cellForRowAtIndexPath:_indexPath];
    cell.voiceModel = model;
}


-(void)orderFollowDetailVCWithModel:(CustomerDetailPathDetailModel*)model andIndexPath:(NSIndexPath*)indexPath {
    DBSelf(weakSelf);
    //存在的话 必定是全部 状态 不是跟进里面的
    CustomerDetailPathDetailModel *subModel = self.secondSectionAllDatas[indexPath.row];
    if (self.orderfitstFollowInAll&&self.isZhanbai==NO&&[subModel.C_TYPE isEqualToString:@"订单跟进"]) {
        if ([self.orderfitstFollowInAll.C_OBJECT_ID isEqualToString:model.C_OBJECT_ID]) {
            //可编辑
            MJKOrderFllowViewController *vc = [[MJKOrderFllowViewController alloc]init];
//            vc.detailModel = self.detailModel;
            vc.objectID = model.C_OBJECT_ID;
//            vc.orderID = model.;
                vc.canEdit = YES;
                vc.isDetail = @"编辑";
            
            [self.navigationController pushViewController:vc animated:YES];
            
            
            
            
        }else{
            //不可编辑
            [self httpPostGetCustomerFollowDetailInfo:model.C_OBJECT_ID andSuccess:^{
                MJKOrderFllowViewController *vc = [[MJKOrderFllowViewController alloc]init];
//                vc.detailModel = self.detailModel;
                vc.objectID = model.C_OBJECT_ID;
//                vc.orderID = self.orderId;
                    vc.canEdit = NO;
                    vc.isDetail = @"详情";
                
                [self.navigationController pushViewController:vc animated:YES];
            }];
            
        }
        
        
    }else{
        //            indexPath.row==0  可编辑  其他不可编辑。
        if (indexPath.row==0&&self.isZhanbai==NO&&[subModel.C_TYPE isEqualToString:@"订单跟进"]) {
            //可编辑
            MJKOrderFllowViewController *vc = [[MJKOrderFllowViewController alloc]init];
            //            vc.detailModel = self.detailModel;
            vc.objectID = model.C_OBJECT_ID;
            //            vc.orderID = model.;
            vc.canEdit = YES;
            vc.isDetail = @"编辑";
            
            [self.navigationController pushViewController:vc animated:YES];
            
            
            
        }else{
            //不可编辑
            
            [self httpPostGetCustomerFollowDetailInfo:model.C_OBJECT_ID andSuccess:^{
                MJKOrderFllowViewController *vc = [[MJKOrderFllowViewController alloc]init];
                //                vc.detailModel = self.detailModel;
                vc.objectID = model.C_OBJECT_ID;
                //                vc.orderID = self.orderId;
                vc.canEdit = NO;
                vc.isDetail = @"详情";
                
                [self.navigationController pushViewController:vc animated:YES];
            }];
            
        }
        
        
    }
}

-(void)FollowDetailVCWithModel:(CustomerDetailPathDetailModel*)model andIndexPath:(NSIndexPath*)indexPath{
    DBSelf(weakSelf);
    //存在的话 必定是全部 状态 不是跟进里面的
	CustomerDetailPathDetailModel *subModel = self.secondSectionAllDatas[indexPath.row];
	
//        //            indexPath.row==0  可编辑  其他不可编辑。
//        if (self.fitstFollowInAll&&self.isZhanbai==NO&&[subModel.I_TYPE isEqualToString:@"2"]) {
//            //可编辑
//			if ([self.fitstFollowInAll.C_OBJECT_ID isEqualToString:model.C_OBJECT_ID]) {
//            CustomerFollowAddEditViewController*vc=[[CustomerFollowAddEditViewController alloc]init];
//            vc.Type=CustomerFollowUpEdit;
//            vc.infoModel=weakSelf.detailInfoModel;
//            vc.vcSuper=weakSelf;
//            vc.canEdit=YES;
//            vc.objectID=model.C_OBJECT_ID;
//                vc.forRemark = @"否";
//            [weakSelf.navigationController pushViewController:vc animated:YES];
//
//
//
//			}else{
//				//不可编辑
//
//				[self httpPostGetCustomerFollowDetailInfo:model.C_OBJECT_ID andSuccess:^{
//					CustomerFollowAddEditViewController*vc=[[CustomerFollowAddEditViewController alloc]init];
//					vc.Type=CustomerFollowUpNil;
//					//            vc.infoModel=weakSelf.detailInfoModel;
//					vc.infoModel = weakSelf.detailFollowInfoModel;
//					vc.vcSuper=weakSelf;
//					vc.canEdit=NO;
//					vc.objectID=model.C_OBJECT_ID;
//                    vc.forRemark = @"否";
//					[weakSelf.navigationController pushViewController:vc animated:YES];
//				}];
//
//			}
//
//		} else {
			[self httpPostGetCustomerFollowDetailInfo:model.C_OBJECT_ID andSuccess:^{
				CustomerFollowAddEditViewController*vc=[[CustomerFollowAddEditViewController alloc]init];
				vc.Type=CustomerFollowUpNil;
				//            vc.infoModel=weakSelf.detailInfoModel;
				vc.infoModel = weakSelf.detailFollowInfoModel;
				vc.vcSuper=weakSelf;
				vc.canEdit=NO;
				vc.objectID=model.C_OBJECT_ID;
                vc.forRemark = @"否";
				[weakSelf.navigationController pushViewController:vc animated:YES];
			}];
//		}
	

    
}

-(void)assistFollowDetailVCWithModel:(CustomerDetailPathDetailModel*)model andIndexPath:(NSIndexPath*)indexPath{
	DBSelf(weakSelf);
	//存在的话 必定是全部 状态 不是跟进里面的
	CustomerDetailPathDetailModel *subModel = self.secondSectionAllDatas[indexPath.row];
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
			vc.Type=AssistFollowUpNil;
			vc.infoModel=weakSelf.detailInfoModel;
			vc.vcSuper=weakSelf;
			vc.canEdit=NO;
			vc.objectID=model.C_OBJECT_ID;
			[weakSelf.navigationController pushViewController:vc animated:YES];
			
		}
		
		
	} else {
		//不可编辑
		AssistFollowViewController*vc=[[AssistFollowViewController alloc]init];
		vc.Type=AssistFollowUpNil;
		vc.infoModel=weakSelf.detailInfoModel;
		vc.vcSuper=weakSelf;
		vc.canEdit=NO;
		vc.objectID=model.C_OBJECT_ID;
		[weakSelf.navigationController pushViewController:vc animated:YES];
	}
//	else{
//		//            indexPath.row==0  可编辑  其他不可编辑。
//		if (indexPath.row==0&&self.isZhanbai==NO&&[subModel.C_TYPE isEqualToString:@"跟进"]) {
//			//可编辑
//			AssistFollowViewController*vc=[[AssistFollowViewController alloc]init];
//			vc.Type=AssistFollowUpEdit;
//			vc.infoModel=weakSelf.detailInfoModel;
//			vc.vcSuper=weakSelf;
//			vc.canEdit=YES;
//			vc.objectID=model.C_OBJECT_ID;
//			[weakSelf.navigationController pushViewController:vc animated:YES];
//
//
//
//		}else{
//			//不可编辑
//
//			AssistFollowViewController*vc=[[AssistFollowViewController alloc]init];
//			vc.Type=AssistFollowUpEdit;
//			vc.infoModel=weakSelf.detailInfoModel;
//			vc.vcSuper=weakSelf;
//			vc.canEdit=NO;
//			vc.objectID=model.C_OBJECT_ID;
//			[weakSelf.navigationController pushViewController:vc animated:YES];
//
//		}
//
	
//	}
	
	
}



-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	DBSelf(weakSelf);
    if (section==0) {
        CustomLabelHeaderView*header=[tableView dequeueReusableHeaderFooterViewWithIdentifier:CELLHeader];
        header.isZhanbai=self.isZhanbai;
        header.mainModel=self.detailInfoModel;
        header.returnHeightBlock = ^(CGFloat height) {
//            weakSelf.returnHeight = height;
//            [tableView beginUpdates];
//            [tableView endUpdates];
//            [tableView reloadData];
        };
        header.allLabelArray=self.detailInfoModel.labelsList;
        header.Type=CusomterInfoDetail;
        
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
//        if (self.returnHeight > 0) {
//            return self.returnHeight;
//        } else {
		CGSize size = [[NSString stringWithFormat:@"%@  %@",self.detailInfoModel.C_PHONE,self.detailInfoModel.C_ADDRESS] boundingRectWithSize:CGSizeMake(KScreenWidth - 150, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
		if (self.detailInfoModel.C_PHONE.length > 0 || self.detailInfoModel.C_ADDRESS.length > 0) {
			return [CustomLabelHeaderView headerHeight:self.detailInfoModel.labelsList andType:CusomterInfoDetail] + size.height + 10;
		} else {
			return [CustomLabelHeaderView headerHeight:self.detailInfoModel.labelsList andType:CusomterInfoDetail] + 10;
		}
		
//        }
//        NSString *str = self.detailInfoModel.C_ADDRESS;
//        CGSize size = [str boundingRectWithSize:CGSizeMake(KScreenWidth - 150, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
//        return size.height + 30 + 70;
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
        CustomerDetailPathDetailModel*model=self.secondSectionAllDatas[indexPath.row];
        CGFloat height = [model.X_REMARK boundingRectWithSize:CGSizeMake(KScreenWidth - 167, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.height;
        if (height + 10 > 50) {
            return height + 10;
        }
        return 50;
    }
}

#pragma mark  --click
- (void)clickHistory {
//    DBSelf(weakSelf);
//    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//
//    UIAlertAction *editAction = [UIAlertAction actionWithTitle:@"客户编辑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        if (![[NewUserSession instance].appcode containsObject:@"APP004_0003"]) {
//            [JRToast showWithText:@"账号无权限"];
//            return ;
//        }
////        if (weakSelf.isAssist == YES) {
////            return ;
////        }
//        AddOrEditlCustomerViewController*vc=[[AddOrEditlCustomerViewController alloc]init];
//        vc.Type=customerTypeEdit;
//        vc.mainModel=weakSelf.detailInfoModel;
//        [weakSelf.navigationController pushViewController:vc animated:YES];
//
//    }];
//    UIAlertAction *historyAction = [UIAlertAction actionWithTitle:@"操作记录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        MJKHistoryFlowViewController *vc = [[MJKHistoryFlowViewController alloc]init];
        vc.title = @"客户操作记录";
        vc.C_A41500_C_ID = self.detailInfoModel.C_ID;
        [self.navigationController pushViewController:vc animated:YES];
//    }];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//    }];
//    [alertC addAction:cancelAction];
//    [alertC addAction:editAction];
//    [alertC addAction:historyAction];
//
//    [self presentViewController:alertC animated:YES completion:nil];
	
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
			toolFrame.size.height = 50+70 + 70;
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
        CGFloat y = [[[NSUserDefaults standardUserDefaults]objectForKey:@"VCName"] isEqualToString:@"协助"] ? 0 : 70;
        CGRect rect=self.toolView.frame;
        rect.origin.y=KScreenHeight-self.toolView.toolMainViewHeightLayout.constant-70 - y ;
        self.toolView.frame=rect;
        
    }];
    
    
}
-(void)delegateShowKeyBoardViewWithY:(CGFloat)keyBoardY{
    [UIView animateWithDuration:0.25 animations:^{
        CGRect rect=self.toolView.frame;
//        rect.origin.y=KScreenHeight-258-30-50;
        rect.origin.y=keyBoardY-30 - self.toolView.toolMainViewHeightLayout.constant;
        self.toolView.frame=rect;
        
    }];
    
}


#pragma mark  --getDatas
- (void)getVoiceRecord {
    @weakify(self);
    NSMutableDictionary *contentDict = [NSMutableDictionary dictionary];
    contentDict[@"pageNum"] = @"1";
    contentDict[@"pageSize"] = @(self.pages);
    contentDict[@"C_CREATOR_ROLEID"] = [NewUserSession instance].user.u051Id;
    contentDict[@"C_OBJECT_ID"] = self.mainModel.C_A41500_C_ID;
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/crm/a831/list", HTTP_IP] parameters:contentDict compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue] == 200) {
            @strongify(self);
            self.pathArray = [VoiceRecordModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"list"]];
                        self.voiceNubmer = [NSString stringWithFormat:@"%@",data[@"data"][@"count"]];
            
            if (!self.isVoice) {
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            }
            self.isVoice = NO;
        } else {
            [JRToast showWithText:data[@"msg"]];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
    }];
    
}

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

-(void)httpPostGetCustomerDetailInfo{
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
    if (self.mainModel.C_A41500_C_ID) {
        contentDict[@"C_ID"] = self.mainModel.C_A41500_C_ID;
    }
   
    DBSelf(weakSelf);
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/crm/a415/info", HTTP_IP] parameters:contentDict compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            
            self.detailInfoModel=[CustomerDetailInfoModel yy_modelWithDictionary:data[@"data"]];
            
            [self getRealLabelsList:self.detailInfoModel.labelsList];
            [self toolView];
            
            //刷新 现在是不是战败
            if ([self.detailInfoModel.C_STATUS_DD_ID isEqualToString:@"A41500_C_STATUS_0003"]) {
                self.isZhanbai=YES;
                self.toolView.hidden=YES;
                CGRect frame = self.tableView.frame;
                frame.size.height = KScreenHeight-NavStatusHeight - WD_TabBarHeight - SafeAreaBottomHeight;
                self.tableView.frame = frame;
            }else{
                self.isZhanbai=NO;
                self.toolView.hidden=NO;
            }
            
            
            
            [self.tableView reloadData];

            
        }else if ([data[@"code"] integerValue]==201) {
            weakSelf.errorLabel.hidden = weakSelf.maskView.hidden = NO;
            weakSelf.errorStr = @"无权限";
            weakSelf.errorLabel.text = data[@"msg"];
            weakSelf.navigationItem.rightBarButtonItem.customView.hidden = YES;
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
//    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
//        MyLog(@"%@",data);
//        if ([data[@"code"] integerValue]==200) {
//
//            self.detailInfoModel=[CustomerDetailInfoModel yy_modelWithDictionary:data];
//            [self getRealLabelsList:self.detailInfoModel.labelsList];
//            [self toolView];
//
//            //刷新 现在是不是战败
//            if ([self.detailInfoModel.C_STATUS_DD_ID isEqualToString:@"A41500_C_STATUS_0003"]) {
//                self.isZhanbai=YES;
//                self.toolView.hidden=YES;
//                CGRect frame = self.tableView.frame;
//                frame.size.height = KScreenHeight-NavStatusHeight - WD_TabBarHeight - SafeAreaBottomHeight;
//                self.tableView.frame = frame;
//            }else{
//                self.isZhanbai=NO;
//                self.toolView.hidden=NO;
//            }
//
//
//
//            [self.tableView reloadData];
//
//
//        }else if ([data[@"code"] integerValue]==201) {
//            weakSelf.errorLabel.hidden = weakSelf.maskView.hidden = NO;
//            weakSelf.errorStr = @"无权限";
//            weakSelf.errorLabel.text = data[@"message"];
//            weakSelf.navigationItem.rightBarButtonItem.customView.hidden = YES;
//        }else{
//            [JRToast showWithText:data[@"message"]];
//        }
//
//        [self.tableView.mj_header endRefreshing];
//        [self.tableView.mj_footer endRefreshing];
//
//    }];
    
    
    
}

-(void)httpPostGetCustomerFollowDetailInfo:(NSString *)objectID andSuccess:(void(^)(void))complet {
	
    self.tableView.userInteractionEnabled = NO;
	HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/crm/a416/info",HTTP_IP] parameters:@{@"C_A41600_C_ID":objectID} compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			
			self.detailFollowInfoModel=[CustomerDetailInfoModel yy_modelWithDictionary:data[@"data"]];
			if (complet) {
				complet();
			}
		}
        self.tableView.userInteractionEnabled = YES;
	}];
	
	
	
}

//回调 来决定是  全盘刷新  还是就刷新section1
-(void)httpGetCustomerPathWithIndex:(NSInteger)index andsuccess:(void(^)(id data))successBlock{
    if ([self.assistStr isEqualToString:@"协助"]) {
        if (index == 0) {
            if (![[NewUserSession instance].appcode containsObject:@"APP016_0011"]) {
                [self.secondSectionAllDatas removeAllObjects];
                [self.tableView reloadData];
                [JRToast showWithText:@"账号无权限"];
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                return;
            }
        }
        
        if (index == 1) {
            if (![[NewUserSession instance].appcode containsObject:@"APP016_0012"]) {
                [self.secondSectionAllDatas removeAllObjects];
                [self.tableView reloadData];
                [JRToast showWithText:@"账号无权限"];
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                return;
            }
        }
        
        if (index == 2) {
            if (![[NewUserSession instance].appcode containsObject:@"APP016_0013"]) {
                [self.secondSectionAllDatas removeAllObjects];
                [self.tableView reloadData];
                [JRToast showWithText:@"账号无权限"];
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                return;
            }
        }
        
        if (index == 3) {
            if (![[NewUserSession instance].appcode containsObject:@"APP016_0014"]) {
                [self.secondSectionAllDatas removeAllObjects];
                [self.tableView reloadData];
                [JRToast showWithText:@"账号无权限"];
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                return;
            }
        }
    } else {
        if (index == 0) {
            if (![[NewUserSession instance].appcode containsObject:@"APP004_0017"]) {
                [self.secondSectionAllDatas removeAllObjects];
                [self.tableView reloadData];
                [JRToast showWithText:@"账号无权限"];
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                return;
            }
        }
        
        if (index == 1) {
            if (![[NewUserSession instance].appcode containsObject:@"APP004_0018"]) {
                [self.secondSectionAllDatas removeAllObjects];
                [self.tableView reloadData];
                [JRToast showWithText:@"账号无权限"];
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                return;
            }
        }
        
        if (index == 2) {
            if (![[NewUserSession instance].appcode containsObject:@"APP004_0019"]) {
                [self.secondSectionAllDatas removeAllObjects];
                [self.tableView reloadData];
                [JRToast showWithText:@"账号无权限"];
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                return;
            }
        }
        
        if (index == 3) {
            if (![[NewUserSession instance].appcode containsObject:@"APP004_0020"]) {
                [self.secondSectionAllDatas removeAllObjects];
                [self.tableView reloadData];
                [JRToast showWithText:@"账号无权限"];
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                return;
            }
        }

    }
	self.view.userInteractionEnabled = NO;
    //index  0全部  1线索   2来电   3流量  4预约  5跟进  6订单  7工单
    NSString*C_TYPE;
    switch (index) {
        case 0:{
            C_TYPE=@"";
            break;}
        case 1:{
            C_TYPE=@"0";
            break;}
        case 2:{
            C_TYPE=@"1";
            break;}
        case 3:{
            C_TYPE=@"2";
            break;}
        default:
            break;
    }
    
    
    NSMutableDictionary *contentDict = [NSMutableDictionary dictionary];
    contentDict[@"pageNum"] = @(self.pages);
    contentDict[@"pageSize"] = @(self.pagen);
    contentDict[@"C_A41500_C_ID"] = self.mainModel.C_ID;
    if (C_TYPE.length > 0) {
        contentDict[@"C_TYPE"] = C_TYPE;
    }
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a456/list", HTTP_IP] parameters:contentDict compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue] == 200) {
            
            if (self.pages==1) {
                [self.secondSectionAllDatas removeAllObjects];
            }
            self.mainPathModel=[CustomerDetailPathModel yy_modelWithDictionary:data[@"data"]];
            for (int i = 0; i < self.mainPathModel.content.count; i++) {
                [self.secondSectionAllDatas addObject:self.mainPathModel.content[i]];
            }
//            [self.secondSectionAllDatas addObjectsFromArray:self.mainPathModel.content];
            
            //全部
            if (index==0) {
                for (CustomerDetailPathDetailModel*subModel in self.secondSectionAllDatas) {
                    if ([subModel.I_TYPE isEqualToString:@"2"]) {
                        self.fitstFollowInAll=subModel;
                        break;
                        
                    }
                    if ([subModel.C_TYPE isEqualToString:@"协助跟进"]) {
                        self.assistfitstFollowInAll = subModel;
                        break;
                    }
                    if ([subModel.C_TYPE isEqualToString:@"订单跟进"]) {
                        self.orderfitstFollowInAll = subModel;
                        break;
                    }
                }
                
//                for (CustomerDetailPathDetailModel*subModel in self.secondSectionAllDatas)  {
//                    if ([subModel.C_TYPE isEqualToString:@"协助跟进"]) {
//                        self.assistfitstFollowInAll = subModel;
//                        break;
//                    }
//                }
//
//                for (CustomerDetailPathDetailModel*subModel in self.secondSectionAllDatas)  {
//                    if ([subModel.C_TYPE isEqualToString:@"订单跟进"]) {
//                        self.orderfitstFollowInAll = subModel;
//                        break;
//                    }
//                }
            }else{
                self.fitstFollowInAll=nil;
                self.assistfitstFollowInAll = nil;
            }
            
            
            
            successBlock(data);
            
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
        
        
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        self.view.userInteractionEnabled = YES;
    }];
    
}


#pragma mark 设计师
- (void)HttpAddDesignerWithAndCustomer:(NSString *)customerID andDesigner:(NSString *)designer {
//	DBSelf(weakSelf);
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
//			[weakSelf httpPostGetCustomerDetailInfo];
			[JRToast showWithText:data[@"message"]];
		}else{
			[JRToast showWithText:data[@"message"]];
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
        _toolView=[[CustomerDetailBottomToolView alloc]initWithFrame:CGRectMake(0, KScreenHeight-50 - SafeAreaBottomHeight, KScreenWidth, 50+70 + 70) andIsMoreLines:YES];
        _toolView.delegate=self;
		__block CustomerDetailBottomToolView *toolView = _toolView;
		_toolView.textChangeBlock = ^(NSString *str) {
			CGSize size = [str boundingRectWithSize:CGSizeMake(KScreenWidth - 115, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
			toolView.toolTextViewHeightLayout.constant = size.height + 20;
			toolView.toolMainViewHeightLayout.constant = size.height + 32;
//			CGRect rect = self.ToolMainView.frame;
			NSInteger tempHeight = size.height;
			CGRect toolrect = toolView.frame;
			if (weakSelf.toolMainViewHeight != tempHeight && weakSelf.toolMainViewHeight != 0) {
				
//				rect.origin.y = rect.origin.y - self.toolMainViewHeightLayout.constant;
						toolrect.origin.y = toolrect.origin.y - (tempHeight - weakSelf.toolMainViewHeight);
				toolrect.size.height =  toolrect.size.height + (tempHeight - weakSelf.toolMainViewHeight);
			}
			weakSelf.toolMainViewHeight = size.height;
			//	self.ToolTextField.frame = toolrect;
			
			toolView.frame = toolrect;
		};
        weakSelf.toolView.followBlock = ^(NSString *text) {
			
			[[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"refresh"];
            MyLog(@"%@",text);
			if (![[[NSUserDefaults standardUserDefaults]objectForKey:@"VCName"] isEqualToString:@"协助"]) {
				if (![[NewUserSession instance].appcode containsObject:@"crm:a415:gj"]) {
					[JRToast showWithText:@"账号无权限"];
					return ;
				}
				CustomerFollowAddEditViewController*vc=[[CustomerFollowAddEditViewController alloc]init];
				vc.Type=CustomerFollowUpAdd;
                weakSelf.detailInfoModel.C_A41500_C_ID = weakSelf.detailInfoModel.C_ID;
				vc.infoModel=weakSelf.detailInfoModel;
				vc.vcSuper=weakSelf;
				vc.followText=text;
                vc.forRemark = @"否";
				vc.successBlock = ^{
					_toolView.ToolTextField.text = @"";
				};
				[weakSelf.navigationController pushViewController:vc animated:YES];
			} else {
				if (![[NewUserSession instance].appcode containsObject:@"APP016_0006"]) {
					[JRToast showWithText:@"账号无权限"];
					return ;
				}
				AssistFollowViewController*vc=[[AssistFollowViewController alloc]init];
				vc.Type=AssistFollowUpAdd;
				vc.infoModel=weakSelf.detailInfoModel;
				vc.vcSuper=weakSelf;
				vc.followText=text;
				vc.successBlock = ^{
					_toolView.ToolTextField.text = @"";
				};
				[weakSelf.navigationController pushViewController:vc animated:YES];
			}
            //新增跟进
			
        };
        
        

        weakSelf.toolView.endRecordBlock = ^(NSString *recordStr) {
            MyLog(@"%@",recordStr);
			
			[[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"refresh"];//操作返回才刷新
            weakSelf.toolView.ToolTextField.text=recordStr;
			if (![[[NSUserDefaults standardUserDefaults]objectForKey:@"VCName"] isEqualToString:@"协助"]) {
				if (![[NewUserSession instance].appcode containsObject:@"crm:a415:gj"]) {
					[JRToast showWithText:@"账号无权限"];
					return ;
				}
				CustomerFollowAddEditViewController*vc=[[CustomerFollowAddEditViewController alloc]init];
				vc.Type=CustomerFollowUpAdd;
                weakSelf.detailInfoModel.C_A41500_C_ID = weakSelf.detailInfoModel.C_ID;
				vc.infoModel=weakSelf.detailInfoModel;
				vc.vcSuper=weakSelf;
				vc.followText=recordStr;
                vc.forRemark = @"否";
				vc.successBlock = ^{
					_toolView.ToolTextField.text = @"";
				};
				[weakSelf.navigationController pushViewController:vc animated:YES];
			} else {
				if (![[NewUserSession instance].appcode containsObject:@"APP016_0006"]) {
					[JRToast showWithText:@"账号无权限"];
					return ;
				}
				AssistFollowViewController*vc=[[AssistFollowViewController alloc]init];
				vc.Type=AssistFollowUpAdd;
				vc.infoModel=weakSelf.detailInfoModel;
				vc.vcSuper=weakSelf;
				vc.followText=recordStr;
				vc.successBlock = ^{
					_toolView.ToolTextField.text = @"";
				};
				[weakSelf.navigationController pushViewController:vc animated:YES];
			}
      
            
        };
        
        
        
        
        weakSelf.toolView.clickChooseButtonBlock = ^(NSInteger index, NSString *title) {
			[[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"refresh"];
            MyLog(@"%lu",index);
			if ([title isEqualToString:@"跟进"]) {
				if (![[[NSUserDefaults standardUserDefaults]objectForKey:@"VCName"] isEqualToString:@"协助"]) {
					if (![[NewUserSession instance].appcode containsObject:@"crm:a415:gj"]) {
						[JRToast showWithText:@"账号无权限"];
						return ;
					}
					CustomerFollowAddEditViewController*vc=[[CustomerFollowAddEditViewController alloc]init];
					vc.Type=CustomerFollowUpAdd;
                    weakSelf.detailInfoModel.C_A41500_C_ID = weakSelf.detailInfoModel.C_ID;
					vc.infoModel=weakSelf.detailInfoModel;
					vc.vcSuper=weakSelf;
                    vc.forRemark = @"否";
					//						vc.followText=text;
					//						vc.successBlock = ^{
					//							_toolView.ToolTextField.text = @"";
					//						};
					[weakSelf.navigationController pushViewController:vc animated:YES];
				} else {
					if (![[NewUserSession instance].appcode containsObject:@"APP016_0006"]) {
						[JRToast showWithText:@"账号无权限"];
						return ;
					}
					AssistFollowViewController*vc=[[AssistFollowViewController alloc]init];
					vc.Type=AssistFollowUpAdd;
					vc.infoModel=weakSelf.detailInfoModel;
					vc.vcSuper=weakSelf;
					vc.assitStr = self.assistStr;
					//						vc.followText=text;
					//						vc.successBlock = ^{
					//							_toolView.ToolTextField.text = @"";
					//						};
					[weakSelf.navigationController pushViewController:vc animated:YES];
				}
				//新增跟进
			} else if ([title isEqualToString:@"预约"]) {
                if ([self.assistStr isEqualToString:@"协助"]) {
                    //APP016_0006
                    if (![[NewUserSession instance].appcode containsObject:@"APP016_0007"]) {
                        [JRToast showWithText:@"账号无权限"];
                        return ;
                    }
                } else {
                    if (![[NewUserSession instance].appcode containsObject:@"crm:a415:yy"]) {
                        [JRToast showWithText:@"账号无权限"];
                        return ;
                    }
                }
				//新增预约
				CGCAppointmentModel*postModel=[[CGCAppointmentModel alloc]init];
				postModel.C_A41500_C_NAME=self.detailInfoModel.C_NAME;
                postModel.C_A41500_C_ID=self.detailInfoModel.C_A41500_C_ID = self.detailInfoModel.C_ID;
				postModel.C_PHONE=self.detailInfoModel.C_PHONE;
				postModel.C_SEX_DD_ID=self.detailInfoModel.C_SEX_DD_ID;
				postModel.C_SEX_DD_NAME=self.detailInfoModel.C_SEX_DD_NAME;
				
				
				CGCNewAddAppointmentVC *vc=[[CGCNewAddAppointmentVC alloc] init];
				vc.amodel=postModel;
                vc.rootVC = self;
				vc.assitStr = self.assistStr;
				
				[self.navigationController pushViewController:vc animated:YES];
			} else if ([title isEqualToString:@"任务"]) {
				
                if ([self.assistStr isEqualToString:@"协助"]) {
                    //APP016_0006
                    if (![[NewUserSession instance].appcode containsObject:@"APP016_0008"]) {
                        [JRToast showWithText:@"账号无权限"];
                        return ;
                    }
                } else {
                    if (![[NewUserSession instance].appcode containsObject:@"APP007_0002"]) {
                        [JRToast showWithText:@"账号无权限"];
                        return ;
                    }
                }
				//任务
				ServiceTaskAddViewController *vc = [[ServiceTaskAddViewController alloc]init];
				vc.title = @"新增任务";
				vc.detailModel = [[ServiceTaskDetailModel alloc]init];
				vc.detailModel.C_A41500_C_ID = self.detailInfoModel.C_A41500_C_ID;
				vc.detailModel.C_A41500_C_NAME = self.detailInfoModel.C_NAME;
				vc.detailModel.C_ADDRESS = self.detailInfoModel.C_ADDRESS;
				[self.navigationController pushViewController:vc animated:YES];
			} else if ([title isEqualToString:@"订单"]) {
                if ([self.assistStr isEqualToString:@"协助"]) {
                    //APP016_0006
                    if (![[NewUserSession instance].appcode containsObject:@"APP016_0009"]) {
                        [JRToast showWithText:@"账号无权限"];
                        return ;
                    }
                } else {
                    if (![[NewUserSession instance].appcode containsObject:@"crm:a415:dd"]) {
                        [JRToast showWithText:@"账号无权限"];
                        return ;
                    }
                }
				//新增订单

                MJKOrderAddOrEditViewController *vc = [[MJKOrderAddOrEditViewController alloc]init];
                vc.Type = orderTypeAdd;
                NSMutableDictionary *dic = [self.detailInfoModel yy_modelToJSONObject];
                CGCCustomModel *tempModel = [CGCCustomModel mj_objectWithKeyValues:dic];
                vc.customerModel = tempModel;
                [self.navigationController pushViewController:vc animated:YES];
				
			} else if ([title isEqualToString:@"协助"]) {
				
                if ([self.assistStr isEqualToString:@"协助"]) {
                    //APP016_0006
                    if (![[NewUserSession instance].appcode containsObject:@"APP016_0010"]) {
                        [JRToast showWithText:@"账号无权限"];
                        return ;
                    }
                } else {
                    if (![[NewUserSession instance].appcode containsObject:@"APP004_0011"]) {
                        [JRToast showWithText:@"账号无权限"];
                        return ;
                    }
                }
				ShowHelpViewController *vc = [[ShowHelpViewController alloc]init];
				vc.vcName = @"客户";
				vc.C_A41500_C_ID = self.detailInfoModel.C_A41500_C_ID;
				vc.C_DESIGNER_ROLEID = self.detailInfoModel.C_DESIGNER_ROLEID;
				vc.C_ID = self.detailInfoModel.C_ID;
                vc.assistStr = self.assistStr;
				[self.navigationController pushViewController:vc animated:YES];
			} else if ([title isEqualToString:@"指派"]) {
				if (![[NewUserSession instance].appcode containsObject:@"crm:a415:zp"]) {
					[JRToast showWithText:@"账号无权限"];
					return ;
				}
				//重新指派
				//跳转  到下一个界面  选择好  销售之后  回调  来用  saveAllChooseArray 的东西和销售吊接口  完成之后 在移除这个view
				MJKChooseEmployeesViewController*vc=[[MJKChooseEmployeesViewController alloc]init];
                if ([[NewUserSession instance].appcode containsObject:@"crm:a415:kdzp"]) {
                    vc.isAllEmployees = @"是";
                }
                vc.noticeStr = @"无提示";
                vc.employeesType  = @"我和我的下级";
                vc.chooseEmployeesBlock = ^(MJKClueListSubModel * _Nonnull model) {
					
					[HttpWebObject AssignCustomerToSaleWithSalerID:model.user_id andCustomerIDS:self.mainModel.C_A41500_C_ID success:^(id data) {
						MyLog(@"%@",data);
						if ([data[@"code"] integerValue]==200) {
                            if ([data[@"FLAG"] isEqualToString:@"soon"]) {
                                UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:data[@"message"] preferredStyle:UIAlertControllerStyleAlert];
                                UIAlertAction *knowAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                    [weakSelf.toolView initialStatus];
                                    [weakSelf.tableView.mj_header beginRefreshing];
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
                                //这里需要调用接口    重新分配的接口
//                                [weakSelf.toolView initialStatus];
//                                [weakSelf.tableView.mj_header beginRefreshing];
                                [weakSelf.navigationController popViewControllerAnimated:YES];
                            }
                            
							
						}else{
							[JRToast showWithText:data[@"msg"]];
						}
						
						
						
					}];
					
					
					
				};
				[weakSelf.navigationController pushViewController:vc animated:YES];
				
			} else if ([title isEqualToString:@"星标"]) {
                if (![[NewUserSession instance].appcode containsObject:@"crm:a415:xb"]) {
                    [JRToast showWithText:@"账号无权限"];
                    return ;
                }
				//星标客户
				NSString*starStr;
				if ([self.detailInfoModel.C_STAR_DD_ID isEqualToString:@"A41500_C_STAR_0000"]) {
					starStr=@"A41500_C_STAR_0001";
				}else{
					starStr=@"A41500_C_STAR_0000";
				}
				[HttpWebObject setStarStatusWithStarID:starStr andCustomerID:self.mainModel.C_A41500_C_ID success:^(id data) {
					MyLog(@"%@",data);
					[weakSelf.toolView initialStatus];
					[self.tableView.mj_header beginRefreshing];
					
				}];
				
			} else if ([title isEqualToString:@"战败"]) {
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
                            [MJKHttpApproval DefeatGetHttpValuesWithC_VOUCHERID:@"" andX_REMARK:dateStr andC_REMARK_TYPE_DD_ID:failChooseCodeArray[index] andC_OBJECT_ID:weakSelf.detailInfoModel.C_ID andTYPE:@"A42500_C_TYPE_0000" andSuccessBlock:^{
                                [weakSelf.navigationController popViewControllerAnimated:YES];
                            }];
//
						
					}else{
						[JRToast showWithText:@"战败类型和战败理由必填才能提交"];
					}
					
				} withHight:195.0 withText:@"请填写战败信息" withDatas:failChooseArray];
                alertDate.VCName = @"必填";
				alertDate.remarkText.placeholder=@"请输入战败理由";
				alertDate.textfield.placeholder=@"请选择战败类型";
				
				
				
				[self.view addSubview:alertDate];
			} else if ([title isEqualToString:@"转出"]) {
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
                    NSInteger index = [shopNameArray indexOfObject:title];
                    NSInteger seIndex = [failChooseArray indexOfObject:secondTitle];
                    [MJKHttpApproval DefeatGetHttpValuesWithC_VOUCHERID:shopCodeArray[index] andX_REMARK:dateStr andC_REMARK_TYPE_DD_ID:failChooseCodeArray[seIndex] andC_OBJECT_ID:self.detailInfoModel.C_ID andTYPE:@"A42500_C_TYPE_0004" andSuccessBlock:^{
                        [weakSelf.tableView.mj_header beginRefreshing];
                    }];
                } withHight:240 withText:@"请选择" withDatas:shopNameArray andSecondChooseArray:failChooseArray];
                v.textfield.placeholder = @"请选择门店";
                v.textfield1.placeholder = @"请选择转出理由";
                v.remarkText.placeholder = @"请填写转出理由";
                [[UIApplication sharedApplication].keyWindow addSubview:v];
			} else if ([title isEqualToString:@"共享"]) {
				
			}
			
			
            switch (index) {
				
				/*case 4:{
					if (![[NewUserSession instance].appcode containsObject:@"APP004_0012"]) {
						[JRToast showWithText:@"账号无权限"];
						return;
					}
					AddHelperViewController *vc = [[AddHelperViewController alloc]init];
					vc.vcName = @"设计师";
					vc.userBlock = ^(NSString *nameStr, NSString *codeStr) {
						[weakSelf HttpAddDesignerWithAndCustomer:self.detailInfoModel.C_ID andDesigner:codeStr];
					};
					[weakSelf.navigationController pushViewController:vc animated:YES];
				}
					break;*/
                
				case 100:{//协助页面进入只有
					if (![[NewUserSession instance].appcode containsObject:@"APP004_0008"]) {
						[JRToast showWithText:@"账号无权限"];
						return ;
					}
					//新增预约
					CGCAppointmentModel*postModel=[[CGCAppointmentModel alloc]init];
					postModel.C_A41500_C_NAME=self.detailInfoModel.C_NAME;
					postModel.C_A41500_C_ID=self.detailInfoModel.C_A41500_C_ID;
					postModel.C_PHONE=self.detailInfoModel.C_PHONE;
					postModel.C_SEX_DD_ID=self.detailInfoModel.C_SEX_DD_ID;
					postModel.C_SEX_DD_NAME=self.detailInfoModel.C_SEX_DD_NAME;
					
					
					CGCNewAddAppointmentVC *vc=[[CGCNewAddAppointmentVC alloc] init];
					vc.amodel=postModel;
                    vc.rootVC = self;
					[self.navigationController pushViewController:vc animated:YES];
					
					break;}
                    
                default:
                    break;
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
    if (self.detailInfoModel.C_PHONE.length > 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:self.detailInfoModel.C_PHONE]]];
    } else {
        [JRToast showWithText:@"无电话号码"];
    }
    
}
- (void)whbcallBack:(NSInteger)index {
    if (self.detailInfoModel.C_PHONE.length > 0) {
    [DBObjectTools whbCallWithC_OBJECT_ID:self.detailInfoModel.C_ID andC_CALL_PHONE:self.detailInfoModel.C_PHONE andC_NAME:self.detailInfoModel.C_NAME andC_OBJECTTYPE_DD_ID:@"A83100_C_OBJECTTYPE_0001" andCompleteBlock:nil];
    } else {
       [JRToast showWithText:@"无电话号码"];
   }
}



//- (void)closePhone {
//    [self alertViewFollow];
//}

- (void)alertViewFollow {
    DBSelf(weakSelf);
    UIAlertController *alertV = [UIAlertController alertControllerWithTitle:@"是否新增跟进" message:nil  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *trueAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (![[[NSUserDefaults standardUserDefaults]objectForKey:@"VCName"] isEqualToString:@"协助"]) {
            CustomerFollowAddEditViewController*vc=[[CustomerFollowAddEditViewController alloc]init];
            vc.Type=CustomerFollowUpAdd;
            vc.infoModel=weakSelf.detailInfoModel;
            vc.vcSuper=weakSelf;
            vc.followText=nil;
            vc.forRemark = @"否";
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else {
            AssistFollowViewController*vc=[[AssistFollowViewController alloc]init];
            vc.Type=AssistFollowUpAdd;
            vc.infoModel=weakSelf.detailInfoModel;
            vc.vcSuper=weakSelf;
            vc.followText=nil;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        
    }];
    [alertV addAction:cancelAction];
    [alertV addAction:trueAction];
    
    [self presentViewController:alertV animated:YES completion:nil];
}


//座机
- (void)landLineCall:(NSInteger)index{
    
    CommonCallViewController *myView=[[CommonCallViewController alloc]initWithNibName:@"CommonCallViewController" bundle:nil];
    myView.typeStr=@"用座机拨打";
    myView.nameStr=self.mainModel.C_NAME;
    myView.callStr=self.mainModel.C_PHONE;
    [self.navigationController pushViewController:myView animated:YES];
    
}

//回呼
- (void)callBack:(NSInteger)index{
    CommonCallViewController *myView=[[CommonCallViewController alloc]initWithNibName:@"CommonCallViewController" bundle:nil];
    myView.typeStr=@"回呼到手机";
    myView.nameStr=self.mainModel.C_NAME;
    myView.callStr=self.mainModel.C_PHONE;
    [self.navigationController pushViewController:myView animated:YES];
    
}



-(void)goBack{
    if (self.popVC) {
        [self.navigationController popToViewController:self.popVC animated:NO];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.5;
    }
    return _maskView;
}

- (UILabel *)errorLabel {
    if (!_errorLabel) {
        _errorLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, KScreenHeight - 150, KScreenWidth, 30)];
        _errorLabel.textColor = [UIColor whiteColor];
        _errorLabel.font = [UIFont systemFontOfSize:14.f];
        _errorLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _errorLabel;
    
}

@end
