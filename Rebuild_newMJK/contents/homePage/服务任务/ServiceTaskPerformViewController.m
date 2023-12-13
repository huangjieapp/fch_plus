//
//  ServiceTaskPerformViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/4/14.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "ServiceTaskPerformViewController.h"
#import "MJKTaskConfirmViewController.h"

#import "ServiceTaskDetailModel.h"

#import "CGCNewAppointTextCell.h"

#import "CGCCustomDateView.h"

#import "MJKUploadMemoView.h"
#import "MJKHistoryFlowViewController.h"

//定位
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Base/BMKMapManager.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearchOption.h>

#import "CGCAlertDateView.h"

#import "CGCNewAppointmentCell.h"
#import "CustomerDetailViewController.h"

#import "MJKTaskConfirmView.h"
#import "MJKTaskSignInView.h"

#import "MJKPhotoView.h"

#import "MJKShowSendView.h"
#import "MJKMessagePushNotiViewController.h"
#import "OrderDetailViewController.h"

#import "ServiceTaskViewController.h"
#import "MJKTaskCommentTableViewCell.h"

#import "MJKCommentsListModel.h"

#import "MJKTaskCommentModel.h"
#import "ShowHelpViewController.h"
#import "MJKChooseMoreEmployeesViewController.h"


#define RemarkCell    @"CGCNewAppointTextCell"
@interface ServiceTaskPerformViewController ()<UITableViewDataSource, UITableViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UITextViewDelegate,UIScrollViewDelegate>{
    UIView *commentsView;
    UITextView *commentText;
    UIButton *_commentButton;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ServiceTaskDetailModel *mainDatasModel;
@property (nonatomic, strong) NSString *D_ORDER_TIME;//期望完成时间
@property (nonatomic, strong) NSString *D_CONFIRMED_TIME;//期望开始时间
@property(nonatomic, strong) NSString *performStr;
@property(nonatomic, strong) NSString *imageStr;

@property (nonatomic, strong)  BMKLocationService* locService;
@property (nonatomic, assign) CLLocationCoordinate2D local;
/** baidu search*/
@property (nonatomic, strong) BMKGeoCodeSearch *searcher;
@property (nonatomic, strong) NSString  *locationAddress;
@property (nonatomic, strong) CGCAlertDateView *alertDateView;
/** 照片*/
@property (nonatomic, strong) NSArray *urlList;
/** 确认返回的dic*/
@property (nonatomic, strong) NSDictionary *confirmDic;
/** CLLocationCoordinate2D*/

/** confirm button*/
@property (nonatomic, strong) UIButton *confirmButton;
/** signIn button*/
@property (nonatomic, strong) UIButton *signInButton;
/** complete button*/
@property (nonatomic, strong) UIButton *completeButton;
/** tableFootPhoto*/
@property (nonatomic, strong) MJKPhotoView *tableFootPhoto;

/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *sectionArray;
/** <#注释#>*/
@property (nonatomic, strong) NSArray *dataArray;
/** <#注释#>*/
@property (nonatomic, strong) NSString *textStr;
/** commentTabelView*/
@property (nonatomic, strong) UITableView *commentTabelView;
/** <#注释#>*/
@property (nonatomic, strong) NSString *typeStr;
/** <#注释#>*/
@property (nonatomic, strong) NSString *IDStr;
@property (nonatomic, strong) NSString *saleStr;
@property (nonatomic, strong) NSString *saleNameStr;
/** <#注释#>*/
@property (nonatomic, strong) UIScrollView *scrollView;

/** u*/
@property (nonatomic, strong) UIView *commentNewView;
/** <#注释#>*/
@property (nonatomic, strong) UIButton *noticeButton;
@end

@implementation ServiceTaskPerformViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.locService startUserLocationService];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.locService stopUserLocationService];
    [commentText resignFirstResponder];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	if (@available(iOS 11.0,*)){
		self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}else{
		self.automaticallyAdjustsScrollViewInsets=NO;
	}
	self.view.backgroundColor = [UIColor whiteColor];
	[self initUI];
    [self configUI];
	[self initLocation];
    [self commentNewView];
}

- (void)configUI {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - 55 - SafeAreaBottomHeight, KScreenWidth, 55)];
    bgView.backgroundColor = [UIColor whiteColor];
    UIButton *commentButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, KScreenWidth - 130, 45)];
    [commentButton setImage:@"跟进"];
    commentButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    [commentButton setTitleNormal:@"发表评论"];
    commentButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [commentButton setTitleColor:[UIColor darkGrayColor]];
    commentButton.layer.cornerRadius = 5.f;
    commentButton.backgroundColor = kBackgroundColor;
    [commentButton addTarget:self action:@selector(commentButtonAction:)];
    _commentButton = commentButton;
    [bgView addSubview:commentButton];
    
    for (int i = 0; i < 2; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i * 60 + CGRectGetMaxX(commentButton.frame) + 10, 5, 50, 45)];
        [button setImage:@[@"任务_处理",@"任务_协助"][i]];
        [button setTitleNormal:@[@"处理",@"协助"][i]];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 20, 0);
        button.titleEdgeInsets = UIEdgeInsetsMake(20, -18, 0, 0);
        
        [button setTitleColor:[UIColor blackColor]];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        button.layer.cornerRadius = 5.f;
        [button setTitleColor:[UIColor colorWithHex:@"#989898"]];
//        button.backgroundColor = KNaviColor;
        
        [button addTarget:self action:@selector(opreationButtonAction:)];
        [bgView addSubview:button];
    }
    [self.view addSubview:bgView];
}

- (void)initUI {
	[self HttpGetDetail];
	[self.tableView registerNib:[UINib nibWithNibName:RemarkCell bundle:nil] forCellReuseIdentifier:RemarkCell];
//    [self.view addSubview:self.tableView];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.tableView];
    [self.scrollView addSubview:self.commentTabelView];
	self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"23-顶右button" highImage:@"" isLeft:NO target:self andAction:@selector(clickHistory)];
}

- (void)initLocation {
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;//定位
    [_locService startUserLocationService];
    //地理编码
    _searcher =[[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
//	[self.locationManage startUpdatingLocation];
}



#pragma mark - 定位
#pragma mark - BMKLocationServiceDelegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    //（如果直接写在代理方法中，需要在代理方法末尾调用[_locService stopUserLocationService] 方法，让定位停止，要不然一直定位，你的地图就一直锁定在一个位置）。
    
    
    //发起反向地理编码检索
    BMKReverseGeoCodeSearchOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeSearchOption alloc]init];
    reverseGeoCodeSearchOption.location = userLocation.location.coordinate;
    BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
    
    [_locService stopUserLocationService];
    self.local = userLocation.location.coordinate;
    
}

/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR)
    {
        self.locationAddress = result.address;
    }else if (error == BMK_SEARCH_PERMISSION_UNFINISHED)
    {
        //
    }
}

#pragma mark - UITableViewData

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tableView) {
        return self.sectionArray.count;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        NSArray *arr = self.sectionArray[section][@"dataArray"];
        return arr.count;
    } else {
        return self.dataArray.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    if (tableView == self.tableView) {
        NSArray *arr = self.sectionArray[indexPath.section][@"dataArray"];
        NSString *titleStr = arr[indexPath.row];
        if ([titleStr isEqualToString:@"任务描述"]) {
            CGCNewAppointTextCell*acell=[tableView dequeueReusableCellWithIdentifier:RemarkCell];
            acell.topTitleLabel.text=@"任务描述";
            acell.textView.text = self.mainDatasModel.X_REMARK;
            acell.textView.editable = NO;
            return acell;
        } else if ([titleStr isEqualToString:@"客户"]) {
            
            CGCNewAppointmentCell * cell=[CGCNewAppointmentCell cellWithTableView:tableView];
            cell.detailWidthLayout.constant = KScreenWidth - 120;
            cell.titLab.text = @"客户";
            cell.telLab.hidden = YES;
            if (self.mainDatasModel.C_A41500_C_NAME.length > 0) {
                cell.rightCustomerImageView.hidden = NO;
                cell.leadingWith.constant = 20;
            } else {
                cell.rightCustomerImageView.hidden = YES;
            }
            cell.starLab.hidden = YES;
            cell.jiaoImg.hidden = YES;
            cell.detailLab.text = self.mainDatasModel.C_A41500_C_NAME;
            return cell;
            //                cell.textLabel.text = @"客户";
            //                cell.detailTextLabel.text = self.mainDatasModel.C_A41500_C_NAME;
        } else if ([titleStr isEqualToString:@"执行内容描述"]) {
            CGCNewAppointTextCell*acell=[tableView dequeueReusableCellWithIdentifier:RemarkCell];
            acell.topTitleLabel.text=@"执行内容描述";
            acell.textView.text = self.mainDatasModel.X_TASKCONTENT;
            acell.textView.editable = NO;
            return acell;
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = cell.detailTextLabel.font = [UIFont systemFontOfSize:16.f];
            if ([titleStr isEqualToString:@"类型"]) {
                cell.textLabel.text = @"类型";
                cell.detailTextLabel.text = self.mainDatasModel.C_TYPE_DD_NAME;
            } else if ([titleStr isEqualToString:@"是否外出"]) {
                cell.textLabel.text = @"是否外出";
                cell.detailTextLabel.text = [self.mainDatasModel.I_TYPE isEqualToString:@"1"] ? @"是" : @"否";
            }else if ([titleStr isEqualToString:@"期望开始时间"]) {
                cell.textLabel.text = @"期望开始时间";
                cell.detailTextLabel.text = self.mainDatasModel.D_CONFIRMED_TIME;
            } else if ([titleStr isEqualToString:@"期望完成时间"]) {
                cell.textLabel.text = @"期望完成时间";
                cell.detailTextLabel.text = self.mainDatasModel.D_ORDER_TIME;
            } else if ([titleStr isEqualToString:@"负责人"]) {
                cell.textLabel.text = @"负责人";
                cell.detailTextLabel.text = self.mainDatasModel.C_OWNER_ROLENAME;
            } else if ([titleStr isEqualToString:@"优先等级"]) {
                cell.textLabel.text = @"优先等级";
                cell.detailTextLabel.text = self.mainDatasModel.C_TASKSTATUS_DD_NAME;
            }
            else  if ([titleStr isEqualToString:@"地址"]) {
                CGCNewAppointmentCell * cell=[CGCNewAppointmentCell cellWithTableView:tableView];
                cell.titLab.text = @"地址";
                cell.telLab.hidden = YES;
                if (self.mainDatasModel.C_ADDRESS.length > 0) {
                    cell.rightCustomerImageView.hidden = NO;
                    cell.leadingWith.constant = 20;
                    cell.rightCustomerImageView.image = [UIImage imageNamed:@"导航地址"];
                } else {
                    cell.rightCustomerImageView.hidden = YES;
                }
                cell.starLab.hidden = YES;
                cell.jiaoImg.hidden = YES;
                cell.detailLab.numberOfLines = 0;
                cell.detailWidthLayout.constant = KScreenWidth - 120;
                cell.detailLab.text = self.mainDatasModel.C_ADDRESS;
                return cell;
                
                
    //            cell.textLabel.text = @"地址";
    //            cell.detailTextLabel.numberOfLines = 0;
    //            cell.detailTextLabel.text = self.mainDatasModel.C_ADDRESS;
            } else if ([titleStr isEqualToString:@"创建人"]) {
                cell.textLabel.text = @"创建人";
                cell.detailTextLabel.text = self.mainDatasModel.C_CREATOR_ROLENAME;
            }
            else if ([titleStr isEqualToString:@"创建时间"]) {
                cell.textLabel.text = @"创建时间";
                cell.detailTextLabel.text = self.mainDatasModel.D_CREATE_TIME;
            } else if ([titleStr isEqualToString:@"计划开始时间"]) {
                cell.textLabel.text = @"计划开始时间";
                cell.detailTextLabel.text = self.mainDatasModel.D_START_TIME;
            } else if ([titleStr isEqualToString:@"计划完成时间"]) {
                cell.textLabel.text = @"计划完成时间";
                cell.detailTextLabel.numberOfLines = 0;
                cell.detailTextLabel.text = self.mainDatasModel.D_END_TIME;
            } else if ([titleStr isEqualToString:@"已用时长"]) {
                cell.textLabel.text = @"已用时长";
                cell.detailTextLabel.text = self.mainDatasModel.ALREADYDAY;
            } else if ([titleStr isEqualToString:@"是否超时"]) {
                cell.textLabel.text = @"是否超时";
                cell.detailTextLabel.text = self.mainDatasModel.TIMEOUT;
            } else if ([titleStr isEqualToString:@"签到人"]) {
                cell.textLabel.text = @"签到人";
                cell.detailTextLabel.text = self.mainDatasModel.C_PROPOSER;
            } else if ([titleStr isEqualToString:@"签到时间"]) {
                cell.textLabel.text = @"签到时间";
                cell.detailTextLabel.text = self.mainDatasModel.D_SIGNTIME_TIME;
            } else if ([titleStr isEqualToString:@"签到地址"]) {
                cell.textLabel.text = @"签到地址";
                cell.detailTextLabel.text = self.mainDatasModel.C_SIGNADDRESS;
            } else if ([titleStr isEqualToString:@"完成时间"]) {
                cell.textLabel.text = @"完成时间";
                cell.detailTextLabel.text = self.mainDatasModel.D_FINISH_TIME;
            } else if ([titleStr isEqualToString:@"地点"]) {
                cell.textLabel.text = @"地点";
                cell.detailTextLabel.text = self.mainDatasModel.C_FINISHADDRESS;
                cell.detailTextLabel.numberOfLines = 0;
            } else if ([titleStr isEqualToString:@"执行人"]) {
                cell.textLabel.text = @"执行人";
                cell.detailTextLabel.text = self.mainDatasModel.C_OPERATOR;
            }
            return cell;
            
        }
    } else {
        MJKCommentsListModel *model = self.dataArray[indexPath.row];
        MJKTaskCommentTableViewCell *cell = [MJKTaskCommentTableViewCell cellWithTableView:tableView];
        cell.model = model;
        cell.reCommentActionBlock = ^{
//            weakSelf.noticeButton.hidden = YES;
            weakSelf.IDStr = model.C_ID;
            [commentText becomeFirstResponder];
        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        if (indexPath.section == 0) {
            if (indexPath.row == 1) {
                return 44 + 66;
            } else if (indexPath.section == 0 && indexPath.row == 8) {
                
                NSString *str = self.mainDatasModel.C_ADDRESS;
                
                //        CGSize size = [str sizeWithFont:[UIFont fontWithName:@"Helvetica" size:16] constrainedToSize:CGSizeMake(280, 999) lineBreakMode:NSLineBreakByWordWrapping];
                CGSize size1 = [str boundingRectWithSize:CGSizeMake(KScreenWidth - 100, 999) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.f ]} context:nil].size;
                
                if (str.length > 0) {
                    if (size1.height + 10 > 44) {
                        return size1.height + 10;
                    } else {
                        return 44;
                    }
                    
                } else {
                    return 44;
                }
            }
            else {
                return 44;
            }
        } else {
            if (self.mainDatasModel.D_START_TIME.length > 0 && self.mainDatasModel.C_PROPOSER.length > 0) {
                if (indexPath.section == 1) {
                    return 44;
                } else {
                    if (indexPath.row == 3) {
                        return 44 + 60;
                    }
                }
            } else if (self.mainDatasModel.D_START_TIME.length > 0) {
                return 44;
            } else if (self.mainDatasModel.C_PROPOSER.length > 0) {
                if (indexPath.row == 3) {
                    return 44 + 60;
                }
            }
            return 44;
            
        }
    } else {
        CGFloat rowHeight = 0;
        MJKCommentsListModel *model = self.dataArray[indexPath.row];
        NSString *desStr = model.X_REMARK;
        if (model.X_REMINDING.length > 0) {
            desStr = [NSString stringWithFormat:@"%@\n@%@",model.X_REMARK,model.X_REMINDINGNAME];
        }
        CGFloat desHeight = [desStr boundingRectWithSize:CGSizeMake(KScreenWidth - 80, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.height;
        if (desHeight + 55 > 80) {
            rowHeight = desHeight + 55 + 10;
        } else {
            rowHeight = 80;
        }
        if (model.hf_list.count > 0) {
            for (MJKTaskCommentModel *hfModel in model.hf_list) {
                NSString *subDesStr = hfModel.X_REMARK;
                if (hfModel.X_REMINDING.length > 0) {
                    subDesStr = [NSString stringWithFormat:@"%@\n@%@",hfModel.X_REMARK,hfModel.X_REMINDINGNAME];
                }
                CGFloat hfHeight = [subDesStr boundingRectWithSize:CGSizeMake(KScreenWidth - 100, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.height;
                if (hfHeight + 55 > 70) {
                    rowHeight += hfHeight + 55;
                } else {
                    rowHeight += 70;
                }
            }
        }
        return rowHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return 20;
    } else {
        if (self.dataArray.count > 0) {
            return 30;
        } else {
            return .1f;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 20)];
        //	bgView.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, KScreenWidth - 30, 20)];
        NSString *titleStr = self.sectionArray[section][@"sectionTitle"];
        label.text = titleStr;
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:14.f];
        [bgView addSubview:label];
        return bgView;
    } else {
        if (self.dataArray.count > 0) {
            UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
                bgView.backgroundColor = kBackgroundColor;
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, KScreenWidth - 30, 30)];
            label.text = @"评论";
            label.textColor = [UIColor lightGrayColor];
            label.font = [UIFont systemFontOfSize:14.f];
            [bgView addSubview:label];
            return bgView;
        } else {
            return nil;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        if (section == self.sectionArray.count - 1) {
            CGFloat tableViewHeight = 0;
            if (self.mainDatasModel.urlList.count > 0) {
                tableViewHeight += 160;
            }
//            if (self.dataArray.count > 0) {
//                tableViewHeight += 30;
//                for (MJKCommentsListModel *model in self.dataArray) {
//                    CGFloat desHeight = [model.X_REMARK boundingRectWithSize:CGSizeMake(KScreenWidth - 80, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.height;
//                    if (desHeight + 55 > 80) {
//                        tableViewHeight += desHeight + 55 + 10 ;
//                    } else {
//                        tableViewHeight += 80;
//                    }
//                }
//            }
            
            return tableViewHeight;
        }
        return .1f;
    } else {
        return .1f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 260)];
        if (section == self.sectionArray.count - 1) {
            if (self.mainDatasModel.urlList.count > 0) {
                self.tableFootPhoto.imageURLArray = self.mainDatasModel.urlList;
                [bgView addSubview:self.tableFootPhoto];
            }
//            if (self.dataArray.count > 0) {
//                [bgView addSubview:self.commentTabelView];
//            }
            return bgView;
        }
        return nil;
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        NSArray *arr = self.sectionArray[indexPath.section][@"dataArray"];
        NSString *titleStr = arr[indexPath.row];
        if ([titleStr isEqualToString:@"地址"]) {
            if (self.mainDatasModel.C_ADDRESS.length <= 0) {
                [JRToast showWithText:@"暂无客户地址"];
                return;
            }
            MJKMapNavigationViewController *alertVC = [MJKMapNavigationViewController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            alertVC.C_ADDRESS = self.mainDatasModel.C_ADDRESS;
            [self presentViewController:alertVC animated:YES completion:nil];
        }
        if (indexPath.section == 0) {
            if (indexPath.row == 4) {
                if (self.mainDatasModel.C_A41500_C_ID.length > 0) {
                    if (![[NewUserSession instance].appcode containsObject:@"APP004_0025"]) {
                        [JRToast showWithText:@"账号无权限"];
                        return;
                    }
                    CustomerDetailViewController*vc=[[CustomerDetailViewController alloc]init];
                    //客户详情里输入框下面弹框内容，如果是协助就只有新增预约
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VCName"]; PotentailCustomerListDetailModel*mainModel=[[PotentailCustomerListDetailModel alloc]init];
                    mainModel.C_A41500_C_ID=self.mainDatasModel.C_A41500_C_ID;
                    vc.mainModel=mainModel;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
            }
        }
    }
}

#pragma mark - 点击事件
- (void)opreationButtonAction:(UIButton *)sender {
    DBSelf(weakSelf);
    if ([sender.titleLabel.text isEqualToString:@"处理"]) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            MJKTaskConfirmViewController *vc = [[MJKTaskConfirmViewController alloc]initWithNibName:@"MJKTaskConfirmViewController" bundle:nil];
            vc.taskID = weakSelf.mainDatasModel.C_ID;
            vc.mainDatasModel = weakSelf.mainDatasModel;
            vc.vcName = weakSelf.vcName;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"签到" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
                
            } else {
                [JRToast showWithText:@"请开启定位服务\n设置->隐私->定位服务"];
                return;
            }
            MJKTaskSignInView *view = [[NSBundle mainBundle]loadNibNamed:@"MJKTaskSignInView" owner:nil options:nil].firstObject;
            view.rootVC = self;
            [view createAddImageView];
            __block MJKTaskSignInView *view1 = view;
            view.chooseBlock = ^(NSArray * _Nonnull imageArr) {
                NSMutableArray *arr = [NSMutableArray array];
                if (imageArr.count > 0) {
                    [arr addObjectsFromArray:imageArr];
                }
                if (weakSelf.mainDatasModel.urlList.count > 0) {
                    [arr addObjectsFromArray:weakSelf.mainDatasModel.urlList];
                }
                [weakSelf HttpPostChangeServiceTaskStatus:@"3" andTaskID:weakSelf.mainDatasModel.C_ID andImageArray:arr andSuccess:^(id data) {
                    view1.hidden = YES;
                    if ([[NewUserSession instance].configData.khtsList containsObject:@"A47500_C_RWTSDW_0000"]) {
                        [MJKPushMsgHttp pushInfoWithC_A41500_C_ID:weakSelf.mainDatasModel.C_A41500_C_ID andC_ID:weakSelf.mainDatasModel.C_ID andC_TYPE_DD_ID:@"A47500_C_RWTSDW_0000" andVC:self andYesBlock:^(NSDictionary * _Nonnull data) {
                            MJKMessagePushNotiViewController *vc = [[MJKMessagePushNotiViewController alloc]init];
                            vc.dataDic = data[@"content"];
                            vc.C_A41500_C_ID = weakSelf.mainDatasModel.C_A41500_C_ID;
                            vc.C_TYPE_DD_ID = @"A47500_C_RWTSDW_0000";
                            vc.C_ID = weakSelf.mainDatasModel.C_ID;
                            vc.titleNameXCX = [NSString stringWithFormat:@"%@服务通知",self.mainDatasModel.C_TYPE_DD_NAME];
                            vc.backActionBlock = ^{
                                for (UIViewController *vc in self.navigationController.viewControllers) {
                                    if ([vc isKindOfClass:[ServiceTaskViewController class]]) {
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
                }];
            };
            //        [[UIApplication sharedApplication].keyWindow addSubview:view];
            [self.view addSubview:view];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (![[NewUserSession instance].appcode containsObject:@"APP007_0006"]) {
                [JRToast showWithText:@"账号无权限"];
                return;
            }
            if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
                
            } else {
                [JRToast showWithText:@"请开启定位服务\n设置->隐私->定位服务"];
                return;
            }
            MJKUploadMemoView *memoView = [[MJKUploadMemoView alloc]initWithFrame:weakSelf.view.frame andTitle:@"执行内容描述" andSendMassage:YES andRootVC:self];
            //        memoView.rootVC = self;
            memoView.commitButtonBloack = ^(NSArray *imageArr, NSString *remarkText) {
                NSMutableArray *arr = [NSMutableArray array];
                if (imageArr.count > 0) {
                    [arr addObjectsFromArray:imageArr];
                }
                if (weakSelf.mainDatasModel.urlList.count > 0) {
                    [arr addObjectsFromArray:weakSelf.mainDatasModel.urlList];
                }
                
                weakSelf.imageStr = [imageArr componentsJoinedByString:@","];
                weakSelf.urlList = imageArr;
                weakSelf.performStr = remarkText;
                [weakSelf HttpPostChangeServiceTaskStatus:@"4" andTaskID:weakSelf.mainDatasModel.C_ID andImageArray:arr andSuccess:^(id data) {
                    //                [weakSelf.locationManage stopUpdatingLocation];//停止定位
                    if ([weakSelf.trajectoryType isEqualToString:@"order"]) {
                        [weakSelf HTTPGetOrderTrajectoryList];
                    }
                    if ([[NewUserSession instance].configData.khtsList containsObject:@"A47500_C_RWTSDW_0007"]) {
                        [MJKPushMsgHttp pushInfoWithC_A41500_C_ID:weakSelf.mainDatasModel.C_A41500_C_ID andC_ID:weakSelf.mainDatasModel.C_ID andC_TYPE_DD_ID:@"A47500_C_RWTSDW_0007" andVC:self andYesBlock:^(NSDictionary * _Nonnull data) {
                            MJKMessagePushNotiViewController *vc = [[MJKMessagePushNotiViewController alloc]init];
                            vc.dataDic = data[@"content"];
                            vc.titleNameXCX = [NSString stringWithFormat:@"%@服务完成通知",self.mainDatasModel.C_TYPE_DD_NAME];
                            vc.C_A41500_C_ID = weakSelf.mainDatasModel.C_A41500_C_ID;
                            vc.C_TYPE_DD_ID = @"A47500_C_RWTSDW_0007";
                            vc.C_ID = weakSelf.mainDatasModel.C_ID;
                            vc.backActionBlock = ^{
                                for (UIViewController *vc in self.navigationController.viewControllers) {
                                    if ([vc isKindOfClass:[ServiceTaskViewController class]]) {
                                        [weakSelf.navigationController popToViewController:vc animated:YES];
                                    }
                                    if ([vc isKindOfClass:[OrderDetailViewController class]]) {
                                        [weakSelf.navigationController popToViewController:vc animated:YES];
                                    }
                                    if ([vc isKindOfClass:[CustomerDetailViewController class]]) {
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
                }];
            };
            [self.view addSubview:memoView];
            
        }];
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"延时" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (![[NewUserSession instance].appcode containsObject:@"APP007_0004"]) {
                [JRToast showWithText:@"账号无权限"];
                return;
            }
            
            self.alertDateView=[[CGCAlertDateView alloc] initWithFrame:self.view.bounds  withSelClick:^{
                
            } withSureClick:^(NSString *title, NSString *dateStr) {
                if (dateStr.length>0) {
                    
                    weakSelf.D_CONFIRMED_TIME = title;
                    weakSelf.D_ORDER_TIME=dateStr;
                    [weakSelf HttpPostChangeServiceTaskStatus:@"5" andTaskID:weakSelf.mainDatasModel.C_ID andImageArray:nil  andSuccess:^(id data) {
                        //                    if ([weakSelf.trajectoryType isEqualToString:@"order"]) {
                        //                        [weakSelf HTTPGetOrderTrajectoryList];
                        //                    }
                        if ([[NewUserSession instance].configData.khtsList containsObject:@"A47500_C_RWTSDW_0001"]) {
                            
                            [MJKPushMsgHttp pushInfoWithC_A41500_C_ID:weakSelf.mainDatasModel.C_A41500_C_ID andC_ID:weakSelf.mainDatasModel.C_ID andC_TYPE_DD_ID:@"A47500_C_RWTSDW_0001" andVC:self andYesBlock:^(NSDictionary * _Nonnull data) {
                                MJKMessagePushNotiViewController *vc = [[MJKMessagePushNotiViewController alloc]init];
                                vc.C_A41500_C_ID = weakSelf.mainDatasModel.C_A41500_C_ID;
                                vc.C_TYPE_DD_ID = @"A47500_C_RWTSDW_0001";
                                vc.C_ID = weakSelf.mainDatasModel.C_ID;
                                vc.dataDic = data[@"content"];
                                vc.titleNameXCX = @"预约延期消息";
                                vc.backActionBlock = ^{
                                    for (UIViewController *vc in self.navigationController.viewControllers) {
                                        if ([vc isKindOfClass:[ServiceTaskViewController class]]) {
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
                    }];
                    
                }
                
                
            } withHight:190.0 withText:@"延期信息" withDatas:nil];
            //        self.alertDateView.cancelActionBlock = ^{
            //
            //        };
            
            
            [self.view addSubview:self.alertDateView];
        }];
        UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (![[NewUserSession instance].appcode containsObject:@"APP007_0007"]) {
                [JRToast showWithText:@"账号无权限"];
                return;
            }
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"是否确认取消" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *trueAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf HttpPostChangeServiceTaskStatus:@"7" andTaskID:self.mainDatasModel.C_ID andImageArray:nil andSuccess:^(id data) {
                    if ([[NewUserSession instance].configData.khtsList containsObject:@"A47500_C_RWTSDW_0002"]) {
                        [MJKPushMsgHttp pushInfoWithC_A41500_C_ID:weakSelf.mainDatasModel.C_A41500_C_ID andC_ID:weakSelf.mainDatasModel.C_ID andC_TYPE_DD_ID:@"A47500_C_RWTSDW_0002" andVC:self andYesBlock:^(NSDictionary * _Nonnull data) {
                            MJKMessagePushNotiViewController *vc = [[MJKMessagePushNotiViewController alloc]init];
                            vc.dataDic = data[@"content"];
                            vc.C_A41500_C_ID = weakSelf.mainDatasModel.C_A41500_C_ID;
                            vc.C_TYPE_DD_ID = @"A47500_C_RWTSDW_0002";
                            vc.C_ID = weakSelf.mainDatasModel.C_ID;
                            vc.titleNameXCX = [NSString stringWithFormat:@"%@服务取消通知",self.mainDatasModel.C_TYPE_DD_NAME];
                            vc.backActionBlock = ^{
                                for (UIViewController *vc in self.navigationController.viewControllers) {
                                    if ([vc isKindOfClass:[ServiceTaskViewController class]]) {
                                        [weakSelf.navigationController popToViewController:vc animated:YES];
                                    }
                                }
                            };
                            [weakSelf.navigationController pushViewController:vc animated:YES];
                        } andNoBlock:^{
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        }];
                    }else {
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }
                    
                }];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertC addAction:cancelAction];
            [alertC addAction:trueAction];
            [weakSelf presentViewController:alertC animated:YES completion:nil];
            
        }];
        UIAlertAction *action5 = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
        
        if ([self.mainDatasModel.C_OWNER_ROLENAME isEqualToString:self.mainDatasModel.C_CREATOR_ROLENAME]) {
            if (self.mainDatasModel.D_START_TIME.length > 0 && self.mainDatasModel.C_PROPOSER.length > 0) {
                [alertC addAction:action2];
                [alertC addAction:action3];
                [alertC addAction:action4];
                [alertC addAction:action5];
            } else if (self.mainDatasModel.D_START_TIME.length > 0) {
                if ([self.mainDatasModel.I_TYPE isEqualToString:@"1"]) {//是否外出
                    //是本人就不需要确认按钮
                    [alertC addAction:action1];
                    [alertC addAction:action2];
                    [alertC addAction:action3];
                    [alertC addAction:action4];
                    [alertC addAction:action5];
                } else {
                    [alertC addAction:action2];
                    [alertC addAction:action3];
                    [alertC addAction:action4];
                    [alertC addAction:action5];
                }
            } else if (self.mainDatasModel.C_PROPOSER.length > 0) {
                [alertC addAction:action2];
                [alertC addAction:action3];
                [alertC addAction:action4];
                [alertC addAction:action5];
            } else {
                if ([self.mainDatasModel.I_TYPE isEqualToString:@"1"]) {//是否外出 1 外出
                    [alertC addAction:action];
                    [alertC addAction:action1];
                    [alertC addAction:action2];
                    [alertC addAction:action3];
                    [alertC addAction:action4];
                    [alertC addAction:action5];
                } else {
                    [alertC addAction:action];
                    [alertC addAction:action2];
                    [alertC addAction:action3];
                    [alertC addAction:action4];
                    [alertC addAction:action5];
                }
            }
        } else {
            if (self.mainDatasModel.D_START_TIME.length > 0 && self.mainDatasModel.C_PROPOSER.length > 0) {
                [alertC addAction:action2];
                [alertC addAction:action3];
                [alertC addAction:action4];
                [alertC addAction:action5];
            } else if (self.mainDatasModel.D_START_TIME.length > 0) {
                if ([self.mainDatasModel.I_TYPE isEqualToString:@"1"])  {
                    if ([self.mainDatasModel.C_STATUS_DD_ID isEqualToString:@"A01200_C_STATUS_0003"]) {
                        [alertC addAction:action];
                        [alertC addAction:action1];
                        [alertC addAction:action2];
                        [alertC addAction:action3];
                        [alertC addAction:action4];
                        [alertC addAction:action5];
                    } else {
                        [alertC addAction:action1];
                        [alertC addAction:action2];
                        [alertC addAction:action3];
                        [alertC addAction:action4];
                        [alertC addAction:action5];
                    }
                    
                } else {
                    if ([self.mainDatasModel.C_STATUS_DD_ID isEqualToString:@"A01200_C_STATUS_0003"]) {
                        [alertC addAction:action];
                        [alertC addAction:action2];
                        [alertC addAction:action3];
                        [alertC addAction:action4];
                        [alertC addAction:action5];
                    } else {
                        [alertC addAction:action2];
                        [alertC addAction:action3];
                        [alertC addAction:action4];
                        [alertC addAction:action5];
                    }
                    
                }
                
                
            } else if (self.mainDatasModel.C_PROPOSER.length > 0) {
                [alertC addAction:action2];
                [alertC addAction:action3];
                [alertC addAction:action4];
                [alertC addAction:action5];
            } else {
                if ([self.mainDatasModel.I_TYPE isEqualToString:@"1"]) {//是否外出 1 外出
                    [alertC addAction:action];
                    [alertC addAction:action1];
                    [alertC addAction:action2];
                    [alertC addAction:action3];
                    [alertC addAction:action4];
                    [alertC addAction:action5];
                } else {
                    [alertC addAction:action];
                    [alertC addAction:action2];
                    [alertC addAction:action3];
                    [alertC addAction:action4];
                    [alertC addAction:action5];
                }
            }
        }
        
        [self presentViewController:alertC animated:YES completion:nil];
    } else {
        //协助
        ShowHelpViewController *vc = [[ShowHelpViewController alloc]init];
        vc.vcName = @"任务";
        vc.orderID = self.mainDatasModel.C_ID;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)commentButtonAction:(UIButton *)sender {
    self.noticeButton.hidden = NO;
    self.IDStr = @"";
    [commentText becomeFirstResponder];
}

- (void)clickHistory {
	MJKHistoryFlowViewController *vc = [[MJKHistoryFlowViewController alloc]init];
	vc.title = @"任务操作记录";
	vc.C_A41500_C_ID = self.mainDatasModel.C_ID;
	[self.navigationController pushViewController:vc animated:YES];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *kbInfo=[notification userInfo];
    CGSize kbSize=[[kbInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat kbHeight = kbSize.height;// 键盘高度
    CGRect commentViewFrame = self.commentNewView.frame;
    commentViewFrame.origin.y = KScreenHeight - kbHeight - commentViewFrame.size.height - 30;
    self.commentNewView.frame = commentViewFrame;
    [super keyboardWillShow:notification];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGRect commentViewFrame = self.commentNewView.frame;
    commentViewFrame.origin.y = KScreenHeight;
    self.commentNewView.frame = commentViewFrame;
    [super keyboardWillHide:notification];
}



- (void)noticeButtonAction {
    DBSelf(weakSelf);
    MJKChooseMoreEmployeesViewController *vc = [[MJKChooseMoreEmployeesViewController alloc]init];
    vc.isAllEmployees = @"是";
    vc.noticeStr = @"无提示";
    vc.codeStr = self.saleStr;
//    vc.vcName = @"@提醒";
    vc.chooseEmployeesBlock = ^(NSString * _Nonnull codeStr, NSString * _Nonnull nameStr, NSString * _Nonnull u051CodeStr) {
        weakSelf.saleStr = codeStr;
        weakSelf.saleNameStr = nameStr;
        [weakSelf.noticeButton setTitleNormal:[NSString stringWithFormat:@"@%@", nameStr]];
        [commentText becomeFirstResponder];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)sendCommentAction {
    if (self.textStr.length <= 0) {
        [JRToast showWithText:@"请输入评论"];
        return;
    }
    [self httpAddComments];
}

- (void)textViewDidChange:(UITextView *)textView{
    self.textStr = textView.text;
}


#pragma mark - http
#pragma mark 详情
- (void)HttpGetDetail {
	DBSelf(weakSelf);
	NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:HTTP_ServiceTaskDetail];
	NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
	[contentDict setObject:self.C_ID forKey:@"C_ID"];
	[mainDict setObject:contentDict forKey:@"content"];
	NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.mainDatasModel=[ServiceTaskDetailModel yy_modelWithDictionary:data];
            if (weakSelf.mainDatasModel.urlList.count > 0) {
                weakSelf.tableFootPhoto.imageURLArray = weakSelf.mainDatasModel.urlList;
            } else {
                weakSelf.tableFootPhoto.hidden = YES;
            }
            weakSelf.sectionArray = nil;
            [weakSelf.tableView reloadData];
            CGRect tableViewFrame = weakSelf.tableView.frame;
            tableViewFrame.size.height = [weakSelf getTableViewHeight];
            weakSelf.tableView.frame = tableViewFrame;
            [weakSelf httpGetCommentsList];
            
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}
-(CGFloat)getTableViewHeight {
    [self.tableView layoutIfNeeded];
    return self.tableView.contentSize.height;
}
-(CGFloat)getCommentTableViewHeight {
    [self.commentTabelView layoutIfNeeded];
    return self.commentTabelView.contentSize.height;
}

- (void)httpAddComments{
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A46500WebService-insert"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.IDStr.length > 0) {
        dic[@"C_FATHERID"] = self.IDStr;
    } else {
        dic[@"C_OBJECTID"] = self.mainDatasModel.C_ID;
    }
    dic[@"X_REMARK"] = self.textStr;
    if (self.saleStr.length > 0) {
        dic[@"X_REMINDING"] = self.saleStr;
    }
    dic[@"C_ID"] = [DBObjectTools getWorkReportCommentsA46500];
    [dict setObject:dic forKey:@"content"];
    DBSelf(weakSelf);
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            [JRToast showWithText:@"评论成功"];
            [commentText resignFirstResponder];
            weakSelf.saleNameStr = weakSelf.saleStr = weakSelf.textStr = commentText.text = @"";
            [weakSelf.noticeButton setTitleNormal:@"@提醒谁看"];
            [weakSelf httpGetCommentsList];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

- (void)httpGetCommentsList {
    NSString *actionStr = @"A46500WebService-getList";
    
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:actionStr];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"C_OBJECTID"] = self.mainDatasModel.C_ID;
    [dict setObject:dic forKey:@"content"];
    DBSelf(weakSelf);
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.dataArray = [MJKCommentsListModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
            //评论文字的内容高配置commenttableview的高
            CGFloat tableViewHeight = 0;
            for (MJKCommentsListModel *model in weakSelf.dataArray) {
                CGFloat desHeight = [model.X_REMARK boundingRectWithSize:CGSizeMake(KScreenWidth - 80, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.height;
                if (desHeight + 55 > 70) {
                    tableViewHeight += desHeight + 55;
                } else {
                    tableViewHeight += 70;
                }
            }
            [weakSelf.commentTabelView reloadData];
            CGRect commentTVFame = weakSelf.commentTabelView.frame;
            if (commentTVFame.size.height > 1) {
                commentTVFame.size.height = [weakSelf getCommentTableViewHeight];
            } else {
                commentTVFame.size.height = [weakSelf getCommentTableViewHeight] + 30;
            }
//            commentTVFame.size.height = [weakSelf getCommentTableViewHeight];
//            commentTVFame = CGRectMake(0, CGRectGetMaxY(weakSelf.tableView.frame), KScreenWidth, tableViewHeight + 30);
            commentTVFame.origin.y = CGRectGetMaxY(weakSelf.tableView.frame);
            weakSelf.commentTabelView.frame = commentTVFame;
            weakSelf.scrollView.contentSize = CGSizeMake(KScreenWidth, weakSelf.tableView.frame.size.height + weakSelf.commentTabelView.frame.size.height);
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        weakSelf.view.userInteractionEnabled = YES;
    }];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [commentText resignFirstResponder];
    [self.view endEditing:YES];
//    _commentButton.userInteractionEnabled = YES;
}

#pragma mark updateOperation
-(void)HttpPostChangeServiceTaskStatus:(NSString*)statusCode andTaskID:(NSString*)taskID andImageArray:(NSArray *)imageArray andSuccess:(void(^)(id data))successBlock{
    DBSelf(weakSelf);
	NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:HTTP_operationServiceTask];
	NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
	[contentDict setObject:statusCode forKey:@"STATUS_TYPE"];
	[contentDict setObject:taskID forKey:@"C_ID"];
	if ([statusCode isEqualToString:@"1"]) {
		if (self.confirmDic != nil) {
			[contentDict setObject:self.confirmDic[@"startTime"] forKey:@"D_START_TIME"];
			[contentDict setObject:self.confirmDic[@"finishTime"] forKey:@"D_END_TIME"];
			[contentDict setObject:self.confirmDic[@"level"] forKey:@"C_TASKSTATUS_DD_ID"];
		}
		
	} else if ([statusCode isEqualToString:@"3"]) {
		if (imageArray.count > 0) {
			[contentDict setObject:imageArray forKey:@"urlList"];
		}
		[contentDict setObject:@(self.local.longitude) forKey:@"B_SIGN_LON"];
		[contentDict setObject:@(self.local.latitude) forKey:@"B_SIGN_LAT"];
        if (self.locationAddress.length > 0) {
            [contentDict setObject:self.locationAddress forKey:@"C_SIGNADDRESS"];
        }
	} else if ([statusCode isEqualToString:@"4"]){
//		if (self.imageStr.length > 0) {
//			[contentDict setObject:self.imageStr forKey:@"X_PICURL"];
//		}
		
		//urlList
		if (imageArray.count > 0) {
			[contentDict setObject:imageArray forKey:@"urlList"];
		}
		if (self.performStr.length > 0) {
			[contentDict setObject:self.performStr forKey:@"X_TASKCONTENT"];
		}
		if (self.locationAddress.length > 0) {
			[contentDict setObject:self.locationAddress forKey:@"C_FINISHADDRESS"];
		}
		
	}else if ([statusCode isEqualToString:@"5"]){
		if (self.D_ORDER_TIME.length > 0) {
			[contentDict setObject:self.D_ORDER_TIME forKey:@"D_ORDER_TIME"];
		}
		if (self.D_CONFIRMED_TIME.length > 0) {
			[contentDict setObject:self.D_CONFIRMED_TIME forKey:@"D_CONFIRMED_TIME"];
		}
		
	}else if ([statusCode isEqualToString:@"7"]){
		
	}
	[mainDict setObject:contentDict forKey:@"content"];
	NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
//            [weakSelf pushInfoWithC_A41500_C_ID:weakSelf.mainDatasModel.C_A41500_C_ID andC_ID:taskID andC_TYPE_DD_ID:@""];
			successBlock(data);
		}else{
			[JRToast showWithText:data[@"message"]];
		}
		
		
	}];
}

- (void)pushInfoWithC_A41500_C_ID:(NSString *)C_A41500_C_ID andC_ID:(NSString *)C_ID andC_TYPE_DD_ID:(NSString *)C_TYPE_DD_ID {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"UserWebService-getPushMsg"];
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    dic[@"C_A41500_C_ID"] = C_A41500_C_ID;
    dic[@"C_OBJECTID"] = C_ID;
    dic[@"C_TYPE_DD_ID"] = C_TYPE_DD_ID;
    
    [dict setObject:dic forKey:@"content"];
    
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    DBSelf(weakSelf);
    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        
        if ([data[@"code"] integerValue]==200) {
            //            weakSelf.dataDic = data[@"content"];
            MJKShowSendView *showView = [[MJKShowSendView alloc]initWithFrame:weakSelf.view.frame andButtonTitleArray:@[@"否",@"是"] andTitle:@"" andMessage:@"是否给客户发送通知消息?"];
            showView.buttonActionBlock = ^(NSString * _Nonnull str) {
                if ([str isEqualToString:@"否"]) {
                    
                } else {
                    MJKMessagePushNotiViewController *vc = [[MJKMessagePushNotiViewController alloc]init];
                    vc.dataDic = data[@"content"];
                    vc.C_A41500_C_ID = C_A41500_C_ID;
                    vc.C_TYPE_DD_ID = C_TYPE_DD_ID;
                    vc.C_ID = C_ID;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
            };
            if ([[NewUserSession instance].configData.khtsList containsObject:@"A47500_C_DDTSDW_0000"]) {
                [weakSelf.view addSubview:showView];
            }  else {
                
            }
            
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

//MARK:-http
- (void)HTTPGetOrderTrajectoryList{
	DBSelf(weakSelf);
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A47300WebService-operationBean"];
	
	NSMutableDictionary *dic=[NSMutableDictionary new];
	dic[@"C_ID"] = self.moneyModel.C_ID;
	
	
	dic[@"TYPE"] = @"1";
	dic[@"C_COMPLETE_ROLEID"] = [NewUserSession instance].user.u051Id; //self.mainDatasModel.C_OWNER_ROLEID;
	dic[@"X_REMARK"] = self.performStr;
	dic[@"D_ACTUAL_TIME"] = self.mainDatasModel.D_FINISH_TIME.length > 0 ? self.mainDatasModel.D_FINISH_TIME : [DBTools getTimeFomatFromCurrentTimeStamp];
	if (self.urlList.count > 0) {
		dic[@"urlList"] = self.urlList;
	}
	
	
	[dict setObject:dic forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
	
	HttpManager*manager=[[HttpManager alloc]init];
	
	[manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		if ([data[@"code"] integerValue]==200) {
			[JRToast showWithText:data[@"message"]];
			[weakSelf.navigationController popViewControllerAnimated:YES];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

#pragma mark - setter/getter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KScreenWidth, KScreenHeight - SafeAreaTopHeight - SafeAreaBottomHeight - 55)];
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
		_tableView.dataSource = self;
		_tableView.delegate = self;
        _tableView.scrollEnabled = NO;
//        _tableView.tableFooterView = self.tableFootPhoto;
	}
	return _tableView;
}

- (UITableView *)commentTabelView {
    if (!_commentTabelView) {
        _commentTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
        _commentTabelView.dataSource = self;
        _commentTabelView.delegate = self;
        _commentTabelView.scrollEnabled = NO;
        _commentTabelView.backgroundColor = [UIColor whiteColor];
    }
    return _commentTabelView;
}


- (MJKPhotoView *)tableFootPhoto {
	//	DBSelf(weakSelf);
	if (!_tableFootPhoto) {
		_tableFootPhoto = [[MJKPhotoView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 160)];
		_tableFootPhoto.isEdit = NO;
		_tableFootPhoto.isCamera = NO;
		_tableFootPhoto.rootVC = self;
		//		_tableFootPhoto.backUrlArray = ^(NSArray *arr) {
		//			weakSelf.urlList = arr;
		//		};
	}
	return _tableFootPhoto;
}

- (NSMutableArray *)sectionArray {
    if (!_sectionArray) {
        _sectionArray = [NSMutableArray array];
        NSArray *section0Array = @[@"类型",@"任务描述",@"期望开始时间",@"期望完成时间",@"客户",@"地址",@"是否外出",@"负责人",@"优先等级",@"创建人",@"创建时间"];
        NSArray *section1Array = @[@"计划开始时间",@"计划完成时间",@"已用时长",@"是否超时"];
        NSArray *section2Array = @[@"签到人",@"签到时间",@"签到地址"];
        NSArray *section3Array = @[@"完成时间",@"地点",@"执行人",@"执行任务描述"];
        
        [_sectionArray addObject:@{@"sectionTitle" : @"任务信息", @"dataArray" : section0Array}];
        if (![self.mainDatasModel.ISOWN isEqualToString:@"1"]) {
            if (![self.mainDatasModel.C_STATUS_DD_ID isEqualToString:@"A01200_C_STATUS_0003"]) {
                [_sectionArray addObject:@{@"sectionTitle" : @"确认信息", @"dataArray" : section1Array}];
            }
        }
        
        if (self.mainDatasModel.D_SIGNTIME_TIME.length > 0) {
            [_sectionArray addObject:@{@"sectionTitle" : @"签到信息", @"dataArray" : section2Array}];
        }
        if (self.mainDatasModel.D_FINISH_TIME.length > 0) {
            [_sectionArray addObject:@{@"sectionTitle" : @"完成信息", @"dataArray" : section3Array}];
        }
    }
    return _sectionArray;
}

- (UIView *)commentNewView {
    if (!_commentNewView) {
        _commentNewView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, 155)];
        _commentNewView.backgroundColor = [UIColor whiteColor];
        
        commentText = [[UITextView alloc] initWithFrame:CGRectInset(CGRectMake(0.0, 0, KScreenWidth, 100.0), 5.0, 5.0)];
        commentText.layer.borderColor   =  [DBColor(212.0, 212.0, 212.0) CGColor];
        commentText.layer.borderWidth   = 1.0;
        commentText.layer.cornerRadius  = 2.0;
        commentText.layer.masksToBounds = YES;
        
        commentText.backgroundColor     = [UIColor clearColor];
        commentText.returnKeyType       = UIReturnKeySend;
        commentText.delegate            = self;
        commentText.font                = [UIFont systemFontOfSize:15.0];
        
        // _placeholderLabel
        UILabel *placeHolderLabel = [[UILabel alloc] init];
        placeHolderLabel.text = @"请输入您的评论";
        placeHolderLabel.numberOfLines = 0;
        placeHolderLabel.textColor = [UIColor lightGrayColor];
        [placeHolderLabel sizeToFit];
        placeHolderLabel.font = [UIFont systemFontOfSize:13.f];
        [commentText addSubview:placeHolderLabel];
        [commentText setValue:placeHolderLabel forKey:@"_placeholderLabel"];
        [_commentNewView addSubview:commentText];
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(commentText.frame) + 5, KScreenWidth - 120, 45)];
        self.noticeButton = button;
        [button setTitleColor:KNaviColor];
        [button setTitleNormal:@"@提醒谁看"];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [button addTarget:self action:@selector(noticeButtonAction)];
            [_commentNewView addSubview:button];
        
        UIButton *sendButton = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth - 100, CGRectGetMinY(button.frame), 90, 45)];
        [sendButton setTitleColor:[UIColor blackColor]];
        [sendButton setTitleNormal:@"发表"];
        sendButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        sendButton.backgroundColor = KNaviColor;
        sendButton.layer.cornerRadius = 5.f;
        [sendButton addTarget:self action:@selector(sendCommentAction)];
        [_commentNewView addSubview:sendButton];
        
        [self.view addSubview:_commentNewView];
        
    }
    return _commentNewView;
}
@end
