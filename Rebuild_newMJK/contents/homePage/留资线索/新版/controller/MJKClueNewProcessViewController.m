//
//  CustomerDetailViewController.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/9/20.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKClueNewProcessViewController.h"
#import "MJKTelephoneRobotProcessViewController.h"
#import "MJKClueTabViewController.h"
#import "BrokerCustomVC.h"

#import "CustomerAddOrEditViewController.h"
#import "CustomerFollowAddEditViewController.h"

#import "MJKClueDetailViewController.h"

#import "MJKClueNewProcessHeaderView.h"
#import "MJKClueNewProcessTypeView.h"
#import "CGCAlertDateView.h"

#import "MJKClueDetailModel.h"
#import "MJKHistoryModel.h"
#import "MJKClueListMainSecondModel.h"
#import "CustomerListModel.h"

#import "CGCTemplateVC.h"

#import "CGCLogCell.h"
#import "HistoryDetailView.h"
#import "CGCLogModel.h"

#import "BrokerCustomVC.h"
#import "PotentailCustomerListDetailModel.h"
#import "CustomerDetailViewController.h"

#import "MJKTextRemarkView.h"

#import <WebKit/WebKit.h>

#import <MessageUI/MessageUI.h>

@interface MJKClueNewProcessViewController ()<UITableViewDataSource, UITableViewDelegate, CustomerFollowAddEditViewControllerDelegate,MFMessageComposeViewControllerDelegate>
/** tableView*/
@property (nonatomic, strong) UITableView *tableView;
/** MJKClueNewProcessTypeView*/
@property (nonatomic, strong) MJKClueNewProcessTypeView *typeView;
/** MJKClueNewProcessHeaderView *headerView*/
@property (nonatomic, strong) MJKClueNewProcessHeaderView *headerView;
/** bottom view*/
@property (nonatomic, strong) UIView *bottomView;
/** MJKClueDetailModel*/
@property (nonatomic, strong) MJKClueDetailModel *clueDetailModel;
/** historyModel*/
@property (nonatomic, strong) MJKHistoryModel *historyModel;
/** <#注释#>*/
@property (nonatomic, assign) NSInteger pagen;
/** <#注释#>*/
@property (nonatomic, strong) NSString *typeStr;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *titleArray;

@end

@implementation MJKClueNewProcessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.title = @"线索处理";
    self.view.backgroundColor = [UIColor whiteColor];
    [self configUI];
//    DBSelf(weakSelf);
    [self HTTPGetVoiceHistoryFlowDatas];
    [self HTTPGetHistoryFlowDatas:nil];
//    }];
}

-(void)openWechat{
    NSURL * url = [NSURL URLWithString:@"weixin://"];
//    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
//    //先判断是否能打开该url
//    if (canOpen)
//    {   //打开微信
        [[UIApplication sharedApplication] openURL:url];
//    }else {
//        [JRToast showWithText:@"您的设备未安装微信APP"];
//    }
}

- (void)configUI {
    DBSelf(weakSelf);
    self.typeStr = @"操作记录";
    
    MJKClueNewProcessHeaderView *headerView = [[NSBundle mainBundle]loadNibNamed:@"MJKClueNewProcessHeaderView" owner:nil options:nil].firstObject;
    self.headerView = headerView;
    headerView.buttonActionBlock = ^(NSInteger tag) {
        if (tag == 111) {//电话
            if (![[NewUserSession instance].appcode containsObject:@"APP001_0009"]) {
                [JRToast showWithText:@"账号无权限"];
                return ;
            }
            NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.clueDetailModel.C_PHONE];
            WKWebView * callWebview = [[WKWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
        } else if (tag == 222) {//信息
            if (![[NewUserSession instance].appcode containsObject:@"APP001_0010"]) {
                [JRToast showWithText:@"账号无权限"];
                return ;
            }
            MFMessageComposeViewController *vc = [[MFMessageComposeViewController alloc] init];
            // 设置短信内容
        //    vc.body = @"吃饭了没？";
            // 设置收件人列表
            vc.recipients = @[weakSelf.clueDetailModel.C_PHONE];
            // 设置代理
            vc.messageComposeDelegate = self;
            // 显示控制器
            [self presentViewController:vc animated:YES completion:nil];
        } else if (tag == 333) {//微信
            if (![[NewUserSession instance].appcode containsObject:@"APP001_0011"]) {
                [JRToast showWithText:@"账号无权限"];
                return ;
            }
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *wechat = [UIAlertAction actionWithTitle:@"复制微信号跳转" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = weakSelf.clueDetailModel.C_WECHAT;
                [weakSelf openWechat];
            }];
            
            UIAlertAction *phone = [UIAlertAction actionWithTitle:@"复制手机号跳转" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = weakSelf.clueDetailModel.C_PHONE;
                [weakSelf openWechat];
            }];
            
            UIAlertAction *message = [UIAlertAction actionWithTitle:@"发送消息模版" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                CGCTemplateVC*vc=[[CGCTemplateVC alloc]init];
                vc.isFollow = @"noFollow";
                vc.templateType=CGCTemplateWeiXin;
                vc.titStr=self.clueDetailModel.C_NAME;
                vc.customIDArr=[@[self.clueDetailModel.C_NAME] mutableCopy];
                vc.cusDetailModel.C_ID=self.clueDetailModel.C_ID;
                vc.cusDetailModel.C_NAME=self.clueDetailModel.C_NAME;
                vc.textBackBlock = ^(NSString *str) {
                    
                    MJKTextRemarkView *remarkView = [[NSBundle mainBundle]loadNibNamed:@"MJKTextRemarkView" owner:nil options:nil].firstObject;
                    remarkView.inputStr = str;
                    
                    remarkView.buttonActionBlock = ^(NSString * _Nonnull str, NSString * _Nonnull inputStr, NSString * _Nonnull timeStr) {
                        if ([str isEqualToString:@"确定"]) {
                            [weakSelf updateClueOperations:weakSelf.clueDetailModel.C_ID andTimeStr:timeStr andReason:inputStr andSuccessBlock:^{
                                [weakSelf.navigationController popViewControllerAnimated:YES];
                            }];
                        }
                    };
                    [[UIApplication sharedApplication].keyWindow addSubview:remarkView];
                };
                [self.navigationController pushViewController:vc animated:YES];
            }];
            
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            if (weakSelf.clueDetailModel.C_WECHAT.length > 0) {
                [ac addAction:wechat];
            }
            
            if (weakSelf.clueDetailModel.C_PHONE.length > 0) {
                [ac addAction:phone];
            }
            
            [ac addAction:message];
            [ac addAction:cancel];
            
            [weakSelf presentViewController:ac animated:YES completion:nil];
            
        } else if (tag == 444) {//名片
//            if (![[NewUserSession instance].appcode containsObject:@"APP001_0012"]) {
//                [JRToast showWithText:@"账号无权限"];
//                return ;
//            }
//            [weakSelf HTTPCardData];
            NSString *str = [NSString stringWithFormat:@"%@ %@",self.clueDetailModel.C_ADDRESS, self.clueDetailModel.C_A48200_C_NAME];
            if (str.length <= 0) {
                [JRToast showWithText:@"暂无客户地址"];
                return;
            }
            MJKMapNavigationViewController *alertVC = [MJKMapNavigationViewController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            alertVC.C_ADDRESS = str;
            [self presentViewController:alertVC animated:YES completion:nil];
        } else if (tag == 555) {//查看
            if (![[NewUserSession instance].appcode containsObject:@"APP001_0015"]) {
                [JRToast showWithText:@"账号无权限"];
                return ;
            }
            MJKClueDetailViewController *vc = [[MJKClueDetailViewController alloc]init];
            MJKClueListMainSecondModel *model = [[MJKClueListMainSecondModel alloc]init];
            model.C_ID = weakSelf.clueDetailModel.C_ID;
            vc.clueListMainSecondModel = model;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    };
    headerView.secondGotoActionBlock = ^{
        if (weakSelf.clueDetailModel.C_A47700_C_ID.length > 0) {
            if (![[NewUserSession instance].appcode containsObject:@"APP015_0012"]) {
                [JRToast showWithText:@"账号无权限"];
                return ;
            }
            PotentailCustomerListDetailModel*mainModel = [[PotentailCustomerListDetailModel alloc]init];
            BrokerCustomVC *vc = [[BrokerCustomVC alloc]init];
            mainModel.C_A41500_C_ID = weakSelf.clueDetailModel.C_A47700_C_ID;
            mainModel.C_ID = mainModel.C_A41500_C_ID;
            vc.mainModel = mainModel;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        
    };
    //CustomerDetailViewController
    headerView.firstGotoActionBlock = ^{
        if (weakSelf.clueDetailModel.C_A41500_C_ID.length > 0) {
            PotentailCustomerListDetailModel*mainModel = [[PotentailCustomerListDetailModel alloc]init];
            CustomerDetailViewController *vc = [[CustomerDetailViewController alloc]init];
            mainModel.C_A41500_C_ID = weakSelf.clueDetailModel.C_A41500_C_ID;
            mainModel.C_ID = mainModel.C_A41500_C_ID;
            vc.mainModel = mainModel;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    };
    
    [self.view addSubview:headerView];
    
    MJKClueNewProcessTypeView *typeView = [[MJKClueNewProcessTypeView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headerView.frame), KScreenWidth, 50) andTitleArray:@[@"操作记录", @"电话录音"]];
    [self.view addSubview:typeView];
    typeView.titleArray = self.titleArray;;
    self.typeView = typeView;
    typeView.selectTypeBlock = ^(UIButton * _Nonnull sender) {
        if ([sender.titleLabel.text isEqualToString:@"操作记录"]) {
            weakSelf.typeStr = @"操作记录";
        } else {
            weakSelf.typeStr = @"电话录音";
        }
        [self.tableView.mj_header beginRefreshing];
    };
    
    
    self.tableView = nil;
    [self.view addSubview:self.tableView];
    
    [self getClueDetailDatas];
    [self configRefrsh];
}

- (void)configRefrsh {
    DBSelf(weakSelf);
    self.pagen = 20;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pagen = 20;
        if ([weakSelf.typeStr isEqualToString:@"操作记录"]) {
            [weakSelf HTTPGetHistoryFlowDatas:nil];
        } else {
            [weakSelf HTTPGetVoiceHistoryFlowDatas];
        }
        
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pagen += 20;
        if ([weakSelf.typeStr isEqualToString:@"操作记录"]) {
            [weakSelf HTTPGetHistoryFlowDatas:nil];
        } else {
            [weakSelf HTTPGetVoiceHistoryFlowDatas];
        }
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.historyModel.content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    CGCLogModel *model = self.historyModel.content[indexPath.row];
    CGCLogCell *cell = [CGCLogCell cellWithTableView:tableView];
    cell.showDetailViewButton.enabled = NO;
    NSArray *arr = self.historyModel.content;
    if ([self.typeStr isEqualToString:@"操作记录"]) {
        [cell reloadCellWithModel:model];
        cell.showDetailViewButton.enabled = YES;
    } else {
        cell.clueHistoryModel = model;
    }
    cell.statusRightLayout.constant = 10;
    
    
    
    cell.detailButtonClickBlock = ^{
        HistoryDetailView *detailView = [[HistoryDetailView alloc]initWithFrame:weakSelf.view.frame andTimeAndRemark:@[model.D_CREATE_TIME, model.X_REMARK]];
        [[UIApplication sharedApplication].keyWindow addSubview:detailView];
    };
    if (arr.count > 0) {
        if (arr.count == 1) {//如果arr只有一个那么都要显示
            cell.topImage.hidden = cell.iconImg.hidden = NO;
        } else {
            if (indexPath.row == 0) {
                cell.topImage.hidden = NO;
                cell.iconImg.hidden = YES;
            } else if (indexPath.row == arr.count - 1) {
                cell.topImage.hidden = YES;
                cell.iconImg.hidden = NO;
            } else {
                cell.topImage.hidden = cell.iconImg.hidden = YES;
            }
        }
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   CGCLogModel *model = self.historyModel.content[indexPath.row];
    if ([self.typeStr isEqualToString:@"操作记录"]) {
        CGFloat height = [model.X_REMARK boundingRectWithSize:CGSizeMake(KScreenWidth - 167, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.height;
        if (height + 20 > 80) {
            return height + 20;
        }
    }
    
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![self.typeStr isEqualToString:@"操作记录"]) {
    CGCLogModel *model = self.historyModel.content[indexPath.row];
    MJKTelephoneRobotProcessViewController *vc = [[MJKTelephoneRobotProcessViewController alloc]init];
    vc.C_ID = model.C_ID;
    [self.navigationController pushViewController:vc animated:YES];
    }
}

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

#pragma mark - 接口数据请求
- (void)getClueDetailDatas {
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a413/info", HTTP_IP] parameters:@{@"C_ID" :self.c_id} compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.clueDetailModel = [MJKClueDetailModel yy_modelWithDictionary:data[@"data"]];
            weakSelf.headerView.model = weakSelf.clueDetailModel;
            //[weakSelf.clueDetailModel.C_STATUS_DD_ID isEqualToString:@"A41300_C_STATUS_0007"] 公海在下发状态
            //A41300_C_STATUS_0005 在激活
            if (([weakSelf.clueDetailModel.C_STATUS_DD_ID isEqualToString:@"A41300_C_STATUS_0003"] || [weakSelf.clueDetailModel.C_STATUS_DD_ID isEqualToString:@"A41300_C_STATUS_0000"] || [weakSelf.clueDetailModel.C_STATUS_DD_ID isEqualToString:@"A41300_C_STATUS_0002"] || [weakSelf.clueDetailModel.C_STATUS_DD_ID isEqualToString:@"A41300_C_STATUS_0006"] || [weakSelf.clueDetailModel.C_STATUS_DD_ID isEqualToString:@"A41300_C_STATUS_0005"])) {//除开无意向，其他进入这个页面的都有按钮
                if (![weakSelf.haveOpreationButton isEqualToString:@"无"]) {
                    [weakSelf.view addSubview:weakSelf.bottomView];
                } else {
                    CGRect tableFrame = weakSelf.tableView.frame;
                    tableFrame.size.height += 110;
                    weakSelf.tableView.frame = tableFrame;
                }
                
            } else {
                CGRect tableFrame = weakSelf.tableView.frame;
                tableFrame.size.height += 110;
                weakSelf.tableView.frame = tableFrame;
            }
        }else{
            [JRToast showWithText:data[@"msg"]];
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

- (void)HTTPGetVoiceHistoryFlowDatas {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:self.c_id forKey:@"C_OBJECTID"];
    
    
    [dic setObject:@"1" forKey:@"currPage"];
    [dic setObject:[NSString stringWithFormat:@"%ld",self.pagen] forKey:@"pageSize"];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString  stringWithFormat:@"%@/api/crm/a831/list", HTTP_IP] parameters:dic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.historyModel = [MJKHistoryModel yy_modelWithDictionary:data];
            [weakSelf.tableView reloadData];
            [weakSelf.titleArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%ld",weakSelf.historyModel.content.count]];
            weakSelf.typeView.titleArray = weakSelf.titleArray;
//            if (weakSelf.historyModel.content.count <= 0) {
//                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, (KScreenHeight - 90) / 2, KScreenWidth, 90)];
//                label.text = @"暂无操作";
//                label.font = [UIFont systemFontOfSize:16.0f];
//                label.textColor = [UIColor grayColor];
//                label.textAlignment = NSTextAlignmentCenter;
//                [weakSelf.view addSubview:label];
//            }
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        
    }];
}

- (void)HTTPGetHistoryFlowDatas:(void(^)(void))completeBlock {
    DBSelf(weakSelf);
    if (![[NewUserSession instance].appcode containsObject:@"crm:a413:guiji"]) {
        [JRToast showWithText:@"账号无权限"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    NSMutableDictionary *contentDict = [NSMutableDictionary dictionary];
    contentDict[@"pageNum"] = @"1";
    contentDict[@"pageSize"] = @(self.pagen);
    contentDict[@"C_A41300_C_ID"] = self.c_id;
    HttpManager *manager = [[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a426/list", HTTP_IP] parameters:contentDict compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.historyModel = [MJKHistoryModel yy_modelWithDictionary:data[@"data"]];
            [weakSelf.tableView reloadData];
            
            [weakSelf.titleArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%ld",weakSelf.historyModel.content.count]];
            weakSelf.typeView.titleArray = weakSelf.titleArray;
            if (completeBlock) {
                completeBlock();
            }
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        
    }];
}

- (void)checkCustomerCountWithCompleteBlock:(void(^)(void))successBlock {
    DBSelf(weakSelf);
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:@"CustomerWebService-validateMaxCustomer"];
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            if ([data[@"FLAG"] isEqualToString:@"soon"]) {
//                UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:data[@"message"] preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction *knowAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    if (successBlock) {
                        successBlock();
                    }
//                }];
//                [ac addAction:knowAction];
//                [weakSelf presentViewController:ac animated:YES completion:nil];
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

//有意向转客户
- (void)customButtonAction:(UIButton *)sender {
    //    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"确定将此线索转为潜客" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    //    alertView.tag = 1000;
    //    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    //    [alertView show];
    DBSelf(weakSelf);
    if (![[NewUserSession instance].appcode containsObject:@"crm:a413:yyx"]) {
        [JRToast showWithText:@"账号无权限"];
        return;
    }
    [self checkCustomerCountWithCompleteBlock:^{
        CustomerDetailInfoModel *cmodel = [[CustomerDetailInfoModel alloc]init];
        //            MJKClueDetailModel *clueDetailModel
        cmodel.C_NAME=weakSelf.clueDetailModel.C_NAME;
        cmodel.C_PHONE=weakSelf.clueDetailModel.C_PHONE;
        cmodel.C_CLUESOURCE_DD_NAME=weakSelf.clueDetailModel.C_CLUESOURCE_DD_NAME;
        cmodel.C_CLUESOURCE_DD_ID=weakSelf.clueDetailModel.C_CLUESOURCE_DD_ID;
        cmodel.C_A41200_C_NAME=weakSelf.clueDetailModel.C_A41200_C_NAME;
        cmodel.C_A41200_C_ID=weakSelf.clueDetailModel.C_A41200_C_ID;
        cmodel.C_SEX_DD_NAME=weakSelf.clueDetailModel.C_SEX_DD_NAME;
        cmodel.C_SEX_DD_ID=weakSelf.clueDetailModel.C_SEX_DD_ID;
        cmodel.C_WECHAT = weakSelf.clueDetailModel.C_WECHAT;
//        cmodel.C_A40600_NAME = weakSelf.clueDetailModel.C_PURPOSE;
        cmodel.X_REMARK=weakSelf.clueDetailModel.X_REMARK;
        cmodel.C_ADDRESS = weakSelf.clueDetailModel.C_ADDRESS;
//        cmodel.cluePeopleID = weakSelf.clueDetailModel.C_CLUEPROVIDER_ROLEID;
//        cmodel.cluePeople = weakSelf.clueDetailModel.C_CLUEPROVIDER_ROLENAME;
        cmodel.C_A47700_C_NAME = weakSelf.clueDetailModel.C_A47700_C_NAME;
        cmodel.C_A47700_C_ID = weakSelf.clueDetailModel.C_A47700_C_ID;
//        cmodel.C_A48200_C_ID = weakSelf.clueDetailModel.C_A48200_C_ID;
//        cmodel.C_A48200_C_NAME = weakSelf.clueDetailModel.C_A48200_C_NAME;
        CustomerAddOrEditViewController *vc = [CustomerAddOrEditViewController new];
        vc.C_A41300_C_ID = weakSelf.clueDetailModel.C_ID;
        vc.tempCustomerModel = cmodel;
        vc.rootVC = self.rootVC;
        

        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
}

-(void)DelegateForCompleteAddCustomerShowAlertVCToFollow:(CustomerDetailInfoModel*)newModel{
    DBSelf(weakSelf);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:@"提示" message:@"是否新增跟进" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction*cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        UIAlertAction*sure=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [DBObjectTools httpPostGetCustomerDetailInfoWithC_ID:newModel.C_A41500_C_ID andCompleteBlock:^(CustomerDetailInfoModel *customerDetailModel) {
            
                CustomerFollowAddEditViewController*vc=[[CustomerFollowAddEditViewController alloc]init];
                vc.Type=CustomerFollowUpAdd;
                vc.delegate=weakSelf;
                customerDetailModel.C_A41500_C_ID=customerDetailModel.C_ID;
                vc.infoModel=customerDetailModel;
                vc.vcSuper=weakSelf;
                vc.followText=nil;
                [self.navigationController pushViewController:vc animated:YES];
            }];
           
            
            
            
        }];
        [alertVC addAction:cancel];
        [alertVC addAction:sure];
        [self presentViewController:alertVC animated:YES completion:nil];
        
        
        
    });
}

//跟进完了之后
-(void)DelegateCompletePopToDo{
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[MJKClueTabViewController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
            return;
        }
        //BrokerCustomVC
        if ([viewController isKindOfClass:[BrokerCustomVC class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
            return;
        }
    }
    //    [self.navigationController popViewControllerAnimated:YES];
}

//暂时无法联系
- (void)contactButtonAction:(UIButton *)sender {
    if (![[NewUserSession instance].appcode containsObject:@"crm:a413:gjz"]) {
        [JRToast showWithText:@"账号无权限"];
        return;
    }
    DBSelf(weakSelf);
    MJKTextRemarkView *remarkView = [[NSBundle mainBundle]loadNibNamed:@"MJKTextRemarkView" owner:nil options:nil].firstObject;
    remarkView.buttonActionBlock = ^(NSString * _Nonnull str, NSString * _Nonnull inputStr, NSString * _Nonnull timeStr) {
        if ([str isEqualToString:@"确定"]) {
            [weakSelf updateClueOperations:weakSelf.clueDetailModel.C_ID andTimeStr:timeStr andReason:inputStr andSuccessBlock:^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        }
    };
    [[UIApplication sharedApplication].keyWindow addSubview:remarkView];
    
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"确定将此名单登记为\"暂时无法联系\"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    alertView.tag = 1001;
//    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
//    [alertView show];
}

- (void)updateClueOperations:(NSString *)C_ID andTimeStr:(NSString *)timeStr andReason:(NSString *)reasonStr andSuccessBlock:(void(^)(void))completeBlock {
    NSMutableDictionary *parameterDic = [NSMutableDictionary dictionary];
    [parameterDic setObject:C_ID forKey:@"C_ID"];
    [parameterDic setObject:reasonStr forKey:@"X_FLOWREMARK"];
    [parameterDic setObject:timeStr forKey:@"D_NEXTCONTACT_TIME"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a413/follow",HTTP_IP] parameters:parameterDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            if (completeBlock) {
                completeBlock();
            }
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

//无意向关闭
- (void)closeButtonAction:(UIButton *)sender {
    if (![[NewUserSession instance].appcode containsObject:@"crm:a413:xyx"]) {
        [JRToast showWithText:@"账号无权限"];
        return;
    }
    DBSelf(weakSelf);
    NSMutableArray*failChooseArray=[NSMutableArray array];
    NSMutableArray*failChooseCodeArray=[NSMutableArray array];
    for (MJKDataDicModel *model in[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A42600_C_REXMARK_TYPE"] ) {
        [failChooseArray addObject:model.C_NAME];
        [failChooseCodeArray addObject:model.C_VOUCHERID];
    }
    CGCAlertDateView *alertDateView = [[CGCAlertDateView alloc]initWithFrame:self.view.frame withSelClick:^{
        
    } withSureClick:^(NSString *title, NSString *dateStr) {
        NSLog(@"%@",title);
        NSInteger index = [failChooseArray indexOfObject:title];
        if (dateStr.length > 0) {
            dateStr = [dateStr substringFromIndex:title.length];
        }
        [weakSelf updateClueOperations:weakSelf.clueDetailModel.C_ID andReason:dateStr andC_REMARK_TYPE_DD_ID:failChooseCodeArray[index]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    } withHight:195.0 withText:@"请填写关闭原因" withDatas:failChooseArray];
    alertDateView.textfield.placeholder = @"请选择原因类型";
    alertDateView.remarkText.placeholder = @"请填写关闭备注";
    [self.view addSubview:alertDateView];
}

- (void)updateClueOperations:(NSString *)C_ID andReason:(NSString *)str andC_REMARK_TYPE_DD_ID:(NSString *)C_REMARK_TYPE_DD_ID {
    NSMutableDictionary *parameterDic = [NSMutableDictionary dictionary];
    [parameterDic setObject:C_ID forKey:@"C_ID"];
    [parameterDic setObject:C_REMARK_TYPE_DD_ID forKey:@"C_REMARK_TYPE_DD_ID"];
    [parameterDic setObject:str forKey:@"X_REMARK"];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a413/noIntention"] parameters:parameterDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.typeView.frame) + 1, KScreenWidth, KScreenHeight - self.typeView.frame.size.height - self.typeView.frame.origin.y - SafeAreaBottomHeight - 110) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    }
    return _tableView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - SafeAreaBottomHeight - 110, KScreenWidth, 110)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        UIButton *customerButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, KScreenWidth - 20, 40)];
        [customerButton setTitleNormal:@"有意向转客户"];
        [customerButton setTitleColor:[UIColor blackColor]];
        [customerButton setBackgroundColor:KNaviColor];
        customerButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        customerButton.layer.cornerRadius = 5.f;
        [customerButton addTarget:self action:@selector(customButtonAction:)];
        [_bottomView addSubview:customerButton];
        
        UIButton *noContactButton = [[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(customerButton.frame) + 10, (KScreenWidth - 30) / 2 , 40)];
        [noContactButton setTitleNormal:@"跟进中"];
        [noContactButton setTitleColor:[UIColor blackColor]];
        noContactButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [noContactButton setBackgroundColor:[UIColor lightGrayColor]];
        noContactButton.layer.cornerRadius = 5.f;
        [noContactButton addTarget:self action:@selector(contactButtonAction:)];
        [_bottomView addSubview:noContactButton];
        
        UIButton *noIntentionButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(noContactButton.frame) + 10, CGRectGetMaxY(customerButton.frame) + 10, (KScreenWidth - 30) / 2,40)];
        [noIntentionButton setTitleNormal:@"无意向关闭"];
        [noIntentionButton setTitleColor:[UIColor blackColor]];
        noIntentionButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [noIntentionButton setBackgroundColor:[UIColor lightGrayColor]];
        noIntentionButton.layer.cornerRadius = 5.f;
        [noIntentionButton addTarget:self action:@selector(closeButtonAction:)];
        [_bottomView addSubview:noIntentionButton];
    }
    return _bottomView;
}

- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithObjects:@"0",@"0", nil];
    }
    return _titleArray;
}

@end
