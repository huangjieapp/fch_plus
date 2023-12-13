//
//  MJKTelephoneRobotProcessViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/21.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKTelephoneRobotProcessViewController.h"
#import "CustomerFollowAddEditViewController.h"
#import "MJKClueTabViewController.h"
#import "CustomerDetailViewController.h"
#import "BrokerCustomVC.h"
#import "MJKClueNewProcessViewController.h"

#import "MJKClueTabViewController.h"

#import "MJKTelephoneRobotProcessModel.h"
#import "MJKTelephoneRobotProcessSubModel.h"
#import "CustomerDetailInfoModel.h"
#import "PotentailCustomerListDetailModel.h"

#import "MJKClueDetailTableViewCell.h"
#import "MJKTelephoneRobotProcessCell.h"
#import "MJKTelephoneRobotProcessVoiceView.h"

#import "MJKTelephoneRobotDetailViewController.h"
#import "AddOrEditlCustomerViewController.h"

#import <AVFoundation/AVFoundation.h>

#import "CGCAlertDateView.h"

#import "WXApi.h"

#import "FansFollowAddEditViewController.h"

#import <WebKit/WebKit.h>


@interface MJKTelephoneRobotProcessViewController ()<UITableViewDataSource, UITableViewDelegate,AddOrEditlCustomerViewControllerDelegate,CustomerFollowAddEditViewControllerDelegate, AVAudioPlayerDelegate>
/** tableView*/
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#>*/
@property (nonatomic, strong) UIView *bottomView;
/** listDataArray*/
@property (nonatomic, strong) MJKTelephoneRobotProcessModel *listDataModel;

/** AVPlayer*/
@property (nonatomic, strong) AVPlayer *player;

/** MJKTelephoneRobotProcessVoiceView*/
@property (nonatomic, strong) MJKTelephoneRobotProcessVoiceView *voiceView;
@end

@implementation MJKTelephoneRobotProcessViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.player pause];
    self.player = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.title = @"名单处理";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self HTTPListdData];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.listDataModel.data.count > 0) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    } else  {
        NSArray *arr = self.listDataModel.data;
        return arr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MJKClueDetailTableViewCell *cell = [MJKClueDetailTableViewCell cellWithTableView:tableView];
        cell.contentTextField.enabled = NO;
        cell.sepLabelRightLayout.constant = 0;
        cell.sepLabelLeftLayout.constant = 0;
        cell.titleLabel.font = [UIFont systemFontOfSize:14.f];
        if (indexPath.row == 0) {
            cell.contentTextField.text = self.listDataModel.C_A70100_C_NAME;
            cell.titleLabel.text = @"呼叫任务";
        } else if (indexPath.row == 1) {
            if (self.listDataModel.C_OBJECTID.length > 0) {
                cell.phoneImageView.hidden = NO;
                cell.phoneImageView.image = [UIImage imageNamed:@"跟进详情-客户姓名详细图标"];
                cell.phoneLayoutConstraint.constant = 50;
            }
            cell.contentTextField.text = self.listDataModel.C_NAME;
            cell.titleLabel.text = @"客户姓名";
        } else if (indexPath.row == 2) {
            cell.phoneImageView.hidden = NO;
            cell.phoneImageView.image = [UIImage imageNamed:@"订单电话"];
            cell.phoneCopyutton.hidden = NO;
            [cell.phoneCopyutton addTarget:self action:@selector(copyPhoneAction:)];
            cell.phonePlayButton.hidden = NO;
            [cell.phonePlayButton addTarget:self action:@selector(phonePlayAction:)];
            cell.phoneLayoutConstraint.constant = 78;
            cell.contentTextField.text = self.listDataModel.number;
            cell.titleLabel.text = @"手机号码";
        } else {
            if ([self.listDataModel.C_STATUS_DD_ID isEqualToString:@"A70200_C_STATUS_0002"]) {//未接通
                cell.contentTextField.text = self.listDataModel.daStr;
                cell.titleLabel.text = @"未接通原因";
            } else {
                cell.contentTextField.text = self.listDataModel.intentionDesc;
                cell.titleLabel.text = @"意向标签";
            }
//            cell.sepLabel.hidden = YES;
        }
        return cell;
    } else {
        MJKTelephoneRobotProcessSubModel *model = self.listDataModel.data[indexPath.row];
        MJKTelephoneRobotProcessCell *cell = [MJKTelephoneRobotProcessCell cellWithTableView:tableView];
        cell.model = model;
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            if (self.listDataModel.C_OBJECTID.length > 0) {
                if ([self.listDataModel.C_SOURCE_DD_ID isEqualToString:@"A70100_C_SOURCE_0000"]) {//名单
                    MJKClueNewProcessViewController *vc = [[MJKClueNewProcessViewController alloc]init];
                    vc.c_id = self.listDataModel.C_OBJECTID;
                    [self.navigationController pushViewController:vc animated:YES];
                } else if ([self.listDataModel.C_SOURCE_DD_ID isEqualToString:@"A70100_C_SOURCE_0001"]) {//粉丝
                    BrokerCustomVC *vc = [[BrokerCustomVC alloc]init];
                    PotentailCustomerListDetailModel *model = [[PotentailCustomerListDetailModel alloc]init];
                    model.C_A41500_C_ID = self.listDataModel.C_OBJECTID;
                    model.C_ID = self.listDataModel.C_OBJECTID;
                    vc.mainModel = model;
                    [self.navigationController pushViewController:vc animated:YES];
                } else { //客户
                    CustomerDetailViewController *vc = [[CustomerDetailViewController alloc]init];
                    PotentailCustomerListDetailModel *customerModel = [[PotentailCustomerListDetailModel alloc]init];
                    customerModel.C_A41500_C_ID = self.listDataModel.C_OBJECTID;
                    vc.mainModel = customerModel;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        MJKTelephoneRobotProcessSubModel *model = self.listDataModel.data[indexPath.row];
        return [MJKTelephoneRobotProcessCell cellHeight:model];
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 20;
    }
    return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 30;
    }
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 20)];
        bgView.backgroundColor = [UIColor whiteColor];
        
        NSString *str = @"对话文本";
        
        CGSize size = [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.f]} context:nil].size;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((KScreenWidth - size.width) / 2, 0, size.width, 20)];
        label.font = [UIFont systemFontOfSize:12.f];
        label.textColor = [UIColor darkGrayColor];
        label.text = str;
        [bgView addSubview:label];
        
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 9, (KScreenWidth - label.frame.size.width) / 2 - 5, 1)];
        leftView.backgroundColor = kBackgroundColor;
        [bgView addSubview:leftView];
        
        UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(label.frame.origin.x + label.frame.size.width + 5, 9, leftView.frame.size.width, 1)];
        rightView.backgroundColor = kBackgroundColor;
        [bgView addSubview:rightView];
        
        return bgView;
    } else {
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.listDataModel.data.count > 0) {
        if (section == 0) {
            UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
            bgView.backgroundColor = kBackgroundColor;
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, KScreenWidth - 40, 30)];
            label.text = @"语音信息";
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:14.f];
            [bgView addSubview:label];
            
            return bgView;
        }
    }
    return nil;
    
}


#pragma mark - 点击
- (void)copyPhoneAction:(UIButton *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.listDataModel.number;
    [JRToast showWithText:@"复制成功"];
}

- (void)phonePlayAction:(UIButton *)sender {
    NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.listDataModel.number];
    WKWebView * callWebview = [[WKWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
}

- (void)playButtonAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected == YES) {
        [sender setImage:@"暂停"];
        if (self.player == nil) {
            [self playSound];
        }
        [self.player play];
    } else {
        [sender setImage:@"开始"];
        [self.player pause];
    }
    
}

#pragma maek - 下载分享
- (void)downloadButtonAction:(UIButton *)sender {
    NSString *voiceUrl=self.listDataModel.C_LYURL;
    NSLog(@"---voiceUrl--%@",voiceUrl);
    NSURL *url = [[NSURL alloc]initWithString:voiceUrl];
    NSData * audioData = [NSData dataWithContentsOfURL:url];
    
    
    //将数据保存到本地指定位置
    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.mp3", docDirPath , @"temp"];
    [audioData writeToFile:filePath atomically:YES];
    
    SendMessageToWXReq *req1 = [[SendMessageToWXReq alloc]init];

    // 是否是文档
    req1.bText =  NO;

    //    WXSceneSession  = 0,        /**< 聊天界面    */
    //    WXSceneTimeline = 1,        /**< 朋友圈      */
    //    WXSceneFavorite = 2,


    req1.scene = WXSceneSession;

    //创建分享内容对象
    WXMediaMessage *urlMessage = [WXMediaMessage message];
    urlMessage.title = @"AI外呼";//分享标题
    NSString *callTime = @"";
    if (self.listDataModel.calldatetime.length > 0) {
        callTime = [self.listDataModel.calldatetime substringToIndex:16];
    }
    urlMessage.description = [NSString stringWithFormat:@"%@\n%@的通话录音",callTime,self.listDataModel.number];//分享描述

    [urlMessage setThumbImage:[UIImage imageNamed:@"XXshar"]];//分享图片,使用SDK的setThumbImage方法可压缩图片大小

    //创建多媒体对象

    NSString *kLinkURL = self.listDataModel.C_LYURL;

    WXWebpageObject *music = [WXWebpageObject object];
    music.webpageUrl = kLinkURL;//分享链接

    //完成发送对象实例
    urlMessage.mediaObject = music;
    req1.message = urlMessage;

    //发送分享信息
    [WXApi sendReq:req1 completion:nil];
}

- (void)HTTPListdData {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A70200WebService-getBeanById"];
    NSMutableDictionary *dic=[NSMutableDictionary new];
    dic[@"C_ID"] = self.C_ID;
    [dict setObject:dic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    
    DBSelf(weakSelf);
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
            weakSelf.listDataModel = [MJKTelephoneRobotProcessModel mj_objectWithKeyValues:data];
            [weakSelf.tableView reloadData];
            if (weakSelf.listDataModel.data.count > 0) {
                weakSelf.voiceView.secondsLabel.text = [NSString stringWithFormat:@"%@秒",weakSelf.listDataModel.bill];
                [weakSelf.view addSubview:weakSelf.voiceView];
            }
            
            //A41300_C_STATUS_0005 激活
            if (([weakSelf.listDataModel.C_OBJECTSTATUSID isEqualToString:@"A41300_C_STATUS_0003"] || [weakSelf.listDataModel.C_OBJECTSTATUSID isEqualToString:@"A41300_C_STATUS_0000"] || [weakSelf.listDataModel.C_OBJECTSTATUSID isEqualToString:@"A41300_C_STATUS_0002"] || [weakSelf.listDataModel.C_OBJECTSTATUSID isEqualToString:@"A41300_C_STATUS_0006"] || [weakSelf.listDataModel.C_OBJECTSTATUSID isEqualToString:@"A41300_C_STATUS_0007"] || [weakSelf.listDataModel.C_OBJECTSTATUSID isEqualToString:@"A41300_C_STATUS_0005"]) && [weakSelf.listDataModel.C_STATUS_DD_ID isEqualToString:@"A70200_C_STATUS_0001"]) {
                [weakSelf.view addSubview:weakSelf.bottomView];
                CGRect tableFrame = weakSelf.tableView.frame;
                tableFrame.size.height  = tableFrame.size.height - 110;
                weakSelf.tableView.frame = tableFrame;
                
                CGRect rect = weakSelf.voiceView.frame;
                rect.origin.y = CGRectGetMinY(weakSelf.bottomView.frame) - 68;
                weakSelf.voiceView.frame = rect;
            } else if ([weakSelf.listDataModel.C_SOURCE_DD_ID isEqualToString:@"A70100_C_SOURCE_0002"] || [weakSelf.listDataModel.C_SOURCE_DD_ID isEqualToString:@"A70100_C_SOURCE_0001"]) {
                //客户
                [weakSelf.view addSubview:weakSelf.bottomView];
                CGRect tableFrame = weakSelf.tableView.frame;
                
                tableFrame.size.height  = tableFrame.size.height - 40;
                weakSelf.tableView.frame = tableFrame;
                
                CGRect rect = weakSelf.voiceView.frame;
                rect.origin.y = CGRectGetMinY(weakSelf.bottomView.frame) - 68;
                weakSelf.voiceView.frame = rect;
            } else {
                CGRect rect = weakSelf.voiceView.frame;
                rect.origin.y = KScreenHeight - 68 - SafeAreaBottomHeight;
                weakSelf.voiceView.frame = rect;
            }
            [weakSelf playSound];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
    
}

#pragma mark - 播放语音
- (void)playSound {
    NSURL * url  = [NSURL URLWithString:self.listDataModel.C_LYURL];
    AVPlayerItem * songItem = [[AVPlayerItem alloc]initWithURL:url];
    self.player = [[AVPlayer alloc]initWithPlayerItem:songItem];
    //@"http://cdn.51mcr.com/wav/2019-02-26/c5b29fe0-ae0e-46d7-ab74-fa9b75ec84ac.wav"
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag == YES) {
        self.voiceView.playButton.selected = NO;
        [self.voiceView.playButton setImage:@"开始"];
    }
}

//有意向转客户
- (void)customButtonAction:(UIButton *)sender {
    if (![[NewUserSession instance].appcode containsObject:@"APP001_0004"]) {
        [JRToast showWithText:@"账号无权限"];
        return;
    }
    DBSelf(weakSelf);
    AddOrEditlCustomerViewController*vc=[[AddOrEditlCustomerViewController alloc]init];
    vc.Type=customerTypeAdd;
    vc.delegate=self;
    //    vc.superVC = self.;
    vc.vcName = @"名单";
    vc.completeComitBlock = ^(NSString *C_ID, CustomerDetailInfoModel *newModel) {
        //新增完 潜客之后   在调个接口 来绑定
        [weakSelf httpPostClueToCustomerWithCustomerID:C_ID andClueID:self.listDataModel.C_OBJECTID andClueRemark:@"" andModel:newModel];
    };
    
    //            MJKClueDetailModel *clueDetailModel
    vc.pubNameStr=self.listDataModel.C_NAME;
    vc.pubTelStr=self.listDataModel.number;
//    vc.pubSourceStr=self.clueDetailModel.C_CLUESOURCE_DD_NAME;
//    vc.pubSourceIDStr=self.clueDetailModel.C_CLUESOURCE_DD_ID;
//    vc.pubMarketStr=self.clueDetailModel.C_A41200_C_NAME;
//    vc.pubMarketID=self.clueDetailModel.C_A41200_C_ID;
//    vc.pubSexStr=self.clueDetailModel.C_SEX_DD_NAME;
//    vc.pubSetID=self.clueDetailModel.C_SEX_DD_ID;
//    vc.pubWECHAT = self.clueDetailModel.C_WECHAT;
//    vc.C_A40600_NAME = self.clueDetailModel.C_PURPOSE;
//    vc.pubRemarketStr=self.clueDetailModel.X_REMARK;
//    vc.pubAddress = self.clueDetailModel.C_ADDRESS;
//    vc.cluePeopleID = self.clueDetailModel.C_CLUEPROVIDER_ROLEID;
//    vc.cluePeople = self.clueDetailModel.C_OWNER_ROLENAME;
//    vc.pubJieshorenStr = self.clueDetailModel.C_A47700_C_NAME;
//    vc.pubJieshorenID = self.clueDetailModel.C_A47700_C_ID;
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
    
}

//线索转潜客 之后的接口
-(void)httpPostClueToCustomerWithCustomerID:(NSString*)customerC_ID andClueID:(NSString*)clueC_ID andClueRemark:(NSString*)remark andModel:(CustomerDetailInfoModel *)newModel{
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:HTTP_ClueToCustomer];
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionaryWithDictionary:@{@"C_ID":clueC_ID,@"C_A41500_C_ID":customerC_ID,@"X_FLOWREMARK":remark}];
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
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
    }
    //    [self.navigationController popViewControllerAnimated:YES];
}

//暂时无法联系
- (void)contactButtonAction:(UIButton *)sender {
    if (![[NewUserSession instance].appcode containsObject:@"APP001_0006"]) {
        [JRToast showWithText:@"账号无权限"];
        return;
    }
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"确定将此名单登记为\"暂时无法联系\"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 1001;
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}

//无意向关闭
- (void)closeButtonAction:(UIButton *)sender {
    if (![[NewUserSession instance].appcode containsObject:@"APP001_0005"]) {
        [JRToast showWithText:@"账号无权限"];
        return;
    }
    DBSelf(weakSelf);
    NSMutableArray*failChooseArray=[NSMutableArray array];
    for (MJKDataDicModel *model in[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A42600_C_REXMARK_TYPE"] ) {
        [failChooseArray addObject:model.C_NAME];
    }
    CGCAlertDateView *alertDateView = [[CGCAlertDateView alloc]initWithFrame:self.view.frame withSelClick:^{
        
    } withSureClick:^(NSString *title, NSString *dateStr) {
        NSLog(@"%@",title);
        //        if ([title isEqualToString:@"其他原因"]) {
        //            weakSelf.clueDetailModel.C_REMARK_TYPE_DD_ID = @"A42600_C_REXMARK_TYPE_0002";
        //        } else if ([title isEqualToString:@"已购买其他产品"]) {
        //            weakSelf.clueDetailModel.C_REMARK_TYPE_DD_ID = @"A42600_C_REXMARK_TYPE_0001";
        //        } else {
        //            weakSelf.clueDetailModel.C_REMARK_TYPE_DD_ID = @"A42600_C_REXMARK_TYPE_0000";
        //        }
        NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
        contentDic[@"C_ID"] = weakSelf.listDataModel.C_OBJECTID;
        contentDic[@"X_REMARK"] = dateStr;
        HttpManager *manager = [[HttpManager alloc]init];
        [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a413/noIntention", HTTP_IP] parameters:@{} compliation:^(id data, NSError *error) {
            if ([data[@"code"] integerValue]== 200) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } else {
                [JRToast showWithText:data[@"msg"]];
            }
        }];
    } withHight:195.0 withText:@"请填写关闭原因" withDatas:failChooseArray];
    alertDateView.textfield.placeholder = @"请选择原因类型";
    alertDateView.remarkText.placeholder = @"请填写关闭备注";
    [self.view addSubview:alertDateView];
}

//MARK:- 跟进
- (void)followButtonAction:(UIButton *)sender {
    CustomerDetailInfoModel *model = [[CustomerDetailInfoModel alloc]init];
    if ([sender.titleLabel.text isEqualToString:@"粉丝关怀"]) {
        //跟进
        FansFollowAddEditViewController*vc=[[FansFollowAddEditViewController alloc]init];
        vc.Type=FansFollowUpAdd;
        model.C_ID = self.listDataModel.C_OBJECTID;
        model.C_A47700_C_ID = model.C_ID;
        model.C_NAME = self.listDataModel.C_NAME;
        vc.infoModel=model;
        vc.vcSuper=self;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        CustomerFollowAddEditViewController*vc=[[CustomerFollowAddEditViewController alloc]init];
        vc.Type=CustomerFollowUpAdd;
        model.C_ID = self.listDataModel.C_OBJECTID;
        model.C_A41500_C_ID = model.C_ID;
        model.C_NAME = self.listDataModel.C_NAME;
        vc.infoModel=model;
        vc.vcSuper=self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}



#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight - 68) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        
        
        
        if ([self.listDataModel.C_SOURCE_DD_ID isEqualToString:@"A70100_C_SOURCE_0000"]) {
            _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - SafeAreaBottomHeight - 110, KScreenWidth, 110)];
            _bottomView.backgroundColor = [UIColor whiteColor];
            UIButton *customerButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, KScreenWidth - 20, 40)];
            [customerButton setTitleNormal:@"有意向转客户"];
            [customerButton setTitleColor:[UIColor whiteColor]];
            [customerButton addTarget:self action:@selector(customButtonAction:)];
            [customerButton setBackgroundColor:KNaviColor];
            customerButton.layer.cornerRadius = 5.f;
            [_bottomView addSubview:customerButton];
            
            UIButton *noContactButton = [[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(customerButton.frame) + 10, (KScreenWidth - 30) / 2 , 40)];
            [noContactButton setTitleNormal:@"暂时无法联系"];
            [noContactButton setTitleColor:[UIColor blackColor]];
            [noContactButton setBackgroundColor:[UIColor lightGrayColor]];
            noContactButton.layer.cornerRadius = 5.f;
            [noContactButton addTarget:self action:@selector(contactButtonAction:)];
            [_bottomView addSubview:noContactButton];
            
            UIButton *noIntentionButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(noContactButton.frame) + 10, CGRectGetMaxY(customerButton.frame) + 10, (KScreenWidth - 30) / 2, 40)];
            [noIntentionButton setTitleNormal:@"无意向关闭"];
            [noIntentionButton setTitleColor:[UIColor blackColor]];
            [noIntentionButton setBackgroundColor:[UIColor lightGrayColor]];
            noIntentionButton.layer.cornerRadius = 5.f;
            [noIntentionButton addTarget:self action:@selector(closeButtonAction:)];
            [_bottomView addSubview:noIntentionButton];
        } else {
            //客户
            _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - SafeAreaBottomHeight - 60, KScreenWidth, 60)];
            _bottomView.backgroundColor = [UIColor whiteColor];
            UIButton *customerButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, KScreenWidth - 20, 40)];
            [customerButton setTitleNormal:[self.listDataModel.C_SOURCE_DD_ID isEqualToString:@"A70100_C_SOURCE_0001"] ? @"粉丝关怀" : @"客户跟进"];
            [customerButton setTitleColor:[UIColor whiteColor]];
            [customerButton addTarget:self action:@selector(followButtonAction:)];
            [customerButton setBackgroundColor:KNaviColor];
            customerButton.layer.cornerRadius = 5.f;
            [_bottomView addSubview:customerButton];
        }
    }
    return _bottomView;
}

- (MJKTelephoneRobotProcessVoiceView *)voiceView {
    if (!_voiceView) {
        _voiceView = [[NSBundle mainBundle]loadNibNamed:@"MJKTelephoneRobotProcessVoiceView" owner:nil options:nil].firstObject;
        
        [_voiceView.playButton addTarget:self action:@selector(playButtonAction:)];
        [_voiceView.downloadButton addTarget:self action:@selector(downloadButtonAction:)];
    }
    return _voiceView;
}

- (void)dealloc {
//    NSLog(@"%s",__func__);
    self.player = nil;
}

@end
