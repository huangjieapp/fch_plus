//
//  MJKNewAddDealViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/5/10.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKNewAddDealViewController.h"
#import "MJKMessagePushNotiViewController.h"
#import "CGCOrderListVC.h"

#import "MJKDealDetailModel.h"
#import "CGCOrderDetailModel.h"
#import "MJKOrderMoneyListModel.h"

#import "AddCustomerInputTableViewCell.h"
#import "CGCNewAppointTextCell.h"

#import "MJKPhotoView.h"

#import "WXApi.h"

@interface MJKNewAddDealViewController ()<UITableViewDataSource, UITableViewDelegate>
/** tableView*/
@property (nonatomic, strong)  UITableView *tableView;
/** cell array title*/
@property (nonatomic, strong) NSMutableArray *cellArray;
/** detail model*/
@property (nonatomic, strong) MJKDealDetailModel *detailModel;
/** (MJKPhotoView *)tableFootPhoto*/
@property (nonatomic, strong) MJKPhotoView *tableFootPhoto;
/** bottom*/
@property (nonatomic, strong) UIView *bottomView;
/** 按钮 id*/
@property (nonatomic, strong)  NSString *payC_STATUS_DD_ID;

/** <#注释#>*/
@property (nonatomic, strong) NSString *buttonTitleStr;
@end

@implementation MJKNewAddDealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.title = @"收款/退款详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.tableView];
    [self httpGetDealDetail];
}


#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionDetailArray = self.cellArray[section][@"sectionDetail"];
    return sectionDetailArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sectionArray = self.cellArray[indexPath.section][@"sectionDetail"];
    NSString *titleStr = sectionArray[indexPath.row];
    if ([titleStr isEqualToString:@"图片"]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"image"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"image"];
        }
        if (self.detailModel.urlList.count > 0) {
            [cell.contentView addSubview:self.tableFootPhoto];
        }
        return cell;
    } else if ([titleStr isEqualToString:@"备注"]) {
        CGCNewAppointTextCell*cell=[CGCNewAppointTextCell cellWithTableView:tableView];
        cell.topTitleLabel.text=titleStr;
        cell.titleLeftLayout.constant = 10;
        cell.textView.editable = NO;
        cell.topTitleLabel.font = [UIFont systemFontOfSize:14.f];
        if (self.detailModel.X_REMARK.length > 0) {
            cell.beforeText=self.detailModel.X_REMARK;
        }
        return cell;
    } else {
        AddCustomerInputTableViewCell *cell = [AddCustomerInputTableViewCell cellWithTableView:tableView];
        cell.titleLeftLayout.constant = 10;
        cell.inputTextField.hidden=YES;
        cell.inputTextView.hidden = YES;
        cell.contentLabel.hidden = NO;
        cell.nameTitleLabel.text=titleStr;   //标题
        cell.inputTextField.textColor = [UIColor blackColor];
        if ([titleStr isEqualToString:@"收款金额"]) {
            cell.nameTitleLabel.text=@"收/退款金额";   //标题
            cell.contentLabel.text = self.detailModel.B_AMOUNT;
        } else if ([titleStr isEqualToString:@"收款类型"]) {
            cell.nameTitleLabel.text=@"类型";   //标题
            cell.contentLabel.text = self.detailModel.C_TYPE_DD_NAME;
        } else if ([titleStr isEqualToString:@"收款方式"]) {
            cell.contentLabel.text = self.detailModel.C_PAYCHANNELNAME;
        } else if ([titleStr isEqualToString:@"收据编号"]) {
            cell.contentLabel.text = self.detailModel.C_MERCHANT_ORDER_NO;
        } else if ([titleStr isEqualToString:@"收款时间"]) {
            cell.contentLabel.text = self.detailModel.D_COLLECTION_TIME;
        } else if ([titleStr isEqualToString:@"收款人"]) {
            cell.contentLabel.text = self.detailModel.C_OWNER_ROLENAME;
        } else if ([titleStr isEqualToString:@"收款状态"]) {
            cell.contentLabel.text = self.detailModel.C_STATUS_DD_NAME;
        } else if ([titleStr isEqualToString:@"到账时间"]) {
            cell.contentLabel.text = self.detailModel.D_DZSJ;
        } else if ([titleStr isEqualToString:@"到账金额"]) {
            cell.contentLabel.text = self.detailModel.B_DZJE;
        } else if ([titleStr isEqualToString:@"手续费"]) {
            cell.contentLabel.text = self.detailModel.B_SXF;
        } else if ([titleStr isEqualToString:@"完工返点金额"]) {
            cell.contentLabel.text = self.detailModel.B_WGFDJE;
        } else if ([titleStr isEqualToString:@"渠道员"]) {
            cell.contentLabel.text = self.detailModel.C_QDY;
        } else if ([titleStr isEqualToString:@"完工返点时间"]) {
            cell.contentLabel.text = self.detailModel.D_WGFDSJ_TIME;
        } else if ([titleStr isEqualToString:@"个人返点金额"]) {
            cell.contentLabel.text = self.detailModel.B_GRFDJE;
        } else if ([titleStr isEqualToString:@"设计师"]) {
            cell.contentLabel.text = self.detailModel.C_SJS;
        } else if ([titleStr isEqualToString:@"个人返点时间"]) {
            cell.contentLabel.text = self.detailModel.D_GRFDSJ_TIME;
        } else if ([titleStr isEqualToString:@"公司返点金额"]) {
            cell.contentLabel.text = self.detailModel.B_GSFDJE;
        } else if ([titleStr isEqualToString:@"公司"]) {
            cell.contentLabel.text = self.detailModel.C_GS;
        } else if ([titleStr isEqualToString:@"公司返点时间"]) {
            cell.contentLabel.text = self.detailModel.D_GSFDSJ_TIME;
        } else if ([titleStr isEqualToString:@"客户姓名"]) {
            cell.contentLabel.text = self.detailModel.C_A41500_C_NAME;
        } else if ([titleStr isEqualToString:@"订单编号"]) {
            cell.contentLabel.text = self.detailModel.C_VOUCHERID;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sectionArray = self.cellArray[indexPath.section][@"sectionDetail"];
    NSString *titleStr = sectionArray[indexPath.row];
    if ([titleStr isEqualToString:@"图片"])  {
        if (self.detailModel.urlList.count > 0) {
            return 170;
        } else {
            return .1;
        }
    } else if ([titleStr isEqualToString:@"备注"]) {
        return 120;
    } else {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    bgView.backgroundColor = kBackgroundColor;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth - 20, 30)];
    label.text = self.cellArray[section][@"sectionTitle"];
    label.font = [UIFont systemFontOfSize:14.f];
    label.textColor = [UIColor darkGrayColor];
    [bgView addSubview:label];
    
    return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)sendWX:(NSString *)C_A04200_C_ID {
    WXMiniProgramObject *object = [WXMiniProgramObject object];
    object.webpageUrl = @"http://www.qq.com";
    object.userName = [NewUserSession instance].C_GID;
    NSString *str = [NSString stringWithFormat:@"/pages/bill/bill?a420id=%@&accountid=%@&shareopenid=%@",C_A04200_C_ID,[NewUserSession instance].user.u051Id,[NewUserSession instance].user.C_OPENID];
    object.path = str;
    //    object.miniprogramType =
    UIImage *image = [UIImage imageNamed:@"支付功能_03"];
    object.hdImageData = UIImagePNGRepresentation(image);
    object.withShareTicket = NO;
    object.miniProgramType = WXMiniProgramTypeRelease;
    //        object.miniProgramType = WXMiniProgramTypeTest;
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"账单";
    //                message.description = @"小程序描述";
    message.thumbData = nil;  //兼容旧版本节点的图片，小于32KB，新版本优先
    //使用WXMiniProgramObject的hdImageData属性
    message.mediaObject = object;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;  //目前只支持会话
    [WXApi sendReq:req completion:nil];
}

//MARK:-跟新付款状态
- (void)payStatusAction:(UIButton *)sender {
    self.buttonTitleStr = sender.titleLabel.text;
    if ([sender.titleLabel.text isEqualToString:@"收入确认"] || [sender.titleLabel.text isEqualToString:@"退款确认"]) {
        self.payC_STATUS_DD_ID = @"A04200_C_STATUS_0001";
    } else {
        self.payC_STATUS_DD_ID = @"A04200_C_STATUS_0000";
    }
    
    [self httpPostAddDeal];
}

#pragma mark  --datas
- (void)httpGetDealDetail {
    DBSelf(weakSelf);
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:@"A04200WebService-getBeanById"];
    NSMutableDictionary*contentDict = [NSMutableDictionary dictionary];
    contentDict[@"C_ID"] = self.model.C_ID;
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.detailModel = [MJKDealDetailModel yy_modelWithDictionary:data];
            weakSelf.tableFootPhoto.imageURLArray = weakSelf.detailModel.urlList;
            [weakSelf.tableView reloadData];
            
            if ([weakSelf.detailModel.C_TYPE_DD_ID isEqualToString:@"A04200_C_TYPE_0002"] || [weakSelf.detailModel.C_TYPE_DD_ID isEqualToString:@"A04200_C_TYPE_0005"]) {
                UIButton *button = weakSelf.bottomView.subviews[0];
                [button setTitleNormal:@"退款确认"];
                UIButton *button1 = weakSelf.bottomView.subviews[1];
                [button1 setTitleNormal:@"待退款"];
                
            } else {
                UIButton *button = weakSelf.bottomView.subviews[0];
                [button setTitleNormal:@"收入确认"];
                UIButton *button1 = weakSelf.bottomView.subviews[1];
                [button1 setTitleNormal:@"待支付"];
            }
            
            if ([weakSelf.detailModel.C_STATUS_DD_ID isEqualToString:@"A04200_C_STATUS_0000"]) {//未支付
                //                [weakSelf.view addSubview:weakSelf.bottomView];
                //                CGRect tableFrame = weakSelf.tableView.frame;
                //                tableFrame.size.height = tableFrame.size.height - 44;
                //                weakSelf.tableView.frame = tableFrame;
            } else {
                weakSelf.bottomView.hidden = YES;
                CGRect tableFrame = weakSelf.tableView.frame;
                tableFrame.size.height = tableFrame.size.height + 50;
                weakSelf.tableView.frame = tableFrame;
            }
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
    }];
}

-(void)httpPostAddDeal{
    NSString *urlStr;
        //        urlStr = HTTP_ChangePayRecord;
        if ([self.payC_STATUS_DD_ID isEqualToString:@"A04200_C_STATUS_0001"]) {
            urlStr = @"A04200WebService-updateStatus";
        } else {
            if (![self.buttonTitleStr isEqualToString:@"待退款"]) {
                [self sendWX:self.detailModel.C_ID];
                return;
            }
        }
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:urlStr];
    
    NSMutableDictionary*contentDict;
    contentDict = [NSMutableDictionary dictionary];
    contentDict[@"C_ID"] = self.detailModel.C_ID;
    
    
    
    DBSelf(weakSelf);
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            if ([weakSelf.payC_STATUS_DD_ID isEqualToString:@"A04200_C_STATUS_0001"]) {
                if ([[NewUserSession instance].configData.khtsList containsObject:@"A47500_C_DDTSDW_0008"]) {
                    [MJKPushMsgHttp pushInfoWithC_A41500_C_ID:weakSelf.orderDetailModel.C_A41500_C_ID andC_ID:weakSelf.model.C_A04200_C_ID.length > 0 ? weakSelf.model.C_A04200_C_ID : contentDict[@"C_A04200_C_ID"] andC_TYPE_DD_ID:@"A47500_C_DDTSDW_0008" andVC:self andYesBlock:^(NSDictionary * _Nonnull data) {
                        MJKMessagePushNotiViewController *vc = [[MJKMessagePushNotiViewController alloc]init];
                        vc.dataDic = data[@"content"];
                        vc.titleNameXCX = @"收款确认消息";
                        vc.C_A41500_C_ID = weakSelf.orderDetailModel.C_A41500_C_ID;
                        vc.C_TYPE_DD_ID = @"A47500_C_DDTSDW_0008";
                        vc.C_ID = weakSelf.orderDetailModel.C_ID;
                        vc.backActionBlock = ^{
                            for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                                if ([vc isKindOfClass:[CGCOrderListVC class]]) {
                                    [weakSelf.navigationController popToViewController:vc animated:YES];
                                }
                            }
                        };
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    } andNoBlock:^{
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }];
                } else {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
            }else {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
        
    }];
    
    
}

#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight - 44) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

- (NSMutableArray *)cellArray {
    if (!_cellArray) {
        _cellArray = [NSMutableArray array];
        NSArray *section0Array;
        if ([self.vcName isEqualToString:@"收款目标明细"]) {
            section0Array = @[@"客户姓名",@"订单编号",@"收款金额",@"收款类型",@"收款方式",@"收据编号",@"收款时间",@"收款人",@"收款状态",@"备注",@"图片"];
        } else {
            section0Array = @[@"收款金额",@"收款类型",@"收款方式",@"收据编号",@"收款时间",@"收款人",@"收款状态",@"备注",@"图片"];
        }
        [_cellArray addObject:@{@"sectionTitle" : @"收款信息", @"sectionDetail" : section0Array}];
        NSArray *section1Array = @[@"到账时间",@"到账金额",@"手续费"];
        [_cellArray addObject:@{@"sectionTitle" : @"到账信息", @"sectionDetail" : section1Array}];
        NSArray *section2Array = @[@"完工返点金额",@"渠道员",@"完工返点时间",@"个人返点金额",@"设计师",@"个人返点时间",@"公司返点金额",@"公司",@"公司返点时间"];
        [_cellArray addObject:@{@"sectionTitle" : @"返点信息", @"sectionDetail" : section2Array}];
    }
    return _cellArray;
}

- (MJKPhotoView *)tableFootPhoto {
    if (!_tableFootPhoto) {
        _tableFootPhoto = [[MJKPhotoView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 150)];
        _tableFootPhoto.isEdit = NO;
        _tableFootPhoto.isCamera = NO;
        _tableFootPhoto.rootVC = self;
    }
    return _tableFootPhoto;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - SafeAreaBottomHeight - 44, KScreenWidth, 44)];
        _bottomView.backgroundColor = kBackgroundColor;
        
        for (int i = 0; i < 2; i++) {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i * (KScreenWidth / 2), 0, KScreenWidth / 2, 44)];
            if (i == 1) {
                [button setBackgroundColor:KNaviColor];
            }
            [button setTitleColor:[UIColor blackColor]];
            [button setTitleNormal:@[@"收入确认",@"待支付"][i]];
            button.titleLabel.font = [UIFont systemFontOfSize:14.f];
            [button addTarget:self action:@selector(payStatusAction:)];
            [_bottomView addSubview:button];
        }
        
        
    }
    return _bottomView;
}

@end
