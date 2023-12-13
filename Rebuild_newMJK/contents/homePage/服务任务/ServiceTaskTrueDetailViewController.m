//
//  ServiceTaskTrueDetailViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/4/14.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "ServiceTaskTrueDetailViewController.h"
#import "ServiceTaskDetailModel.h"

#import "CGCOrderDetialFooter.h"//底部图片
#import "MJKPhotoView.h"
#import "KSPhotoItem.h"
#import "KSPhotoBrowser.h"

#import "CGCNewAppointTextCell.h"//任务描述

#import "MJKHistoryFlowViewController.h"
#import "CGCNewAppointmentCell.h"
#import "CustomerDetailViewController.h"

#import "MJKCommentsListModel.h"
#import "MJKTaskCommentModel.h"

#import "ShowHelpViewController.h"
#import "MJKTaskCommentTableViewCell.h"
#import "MJKChooseMoreEmployeesViewController.h"


#define RemarkCell    @"CGCNewAppointTextCell"

@interface ServiceTaskTrueDetailViewController ()<UITableViewDataSource, UITableViewDelegate,UITextViewDelegate,UIScrollViewDelegate>{
    UIView *commentsView;
    UITextView *commentText;
    UIButton *_commentButton;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ServiceTaskDetailModel *mainDatasModel;
@property (nonatomic, strong) NSMutableArray *saveFooterUrlArray;
@property (nonatomic, strong) CGCOrderDetialFooter *footerImageView;
/** (MJKPhotoView *)tableFootPhoto*/
@property (nonatomic, strong) MJKPhotoView *tableFootPhoto;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *dataArray;

/** <#注释#>*/
@property (nonatomic, strong) NSArray *hfDataArray;
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

@implementation ServiceTaskTrueDetailViewController

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
    
    [self commentNewView];
}

- (void)configUI {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - 55 - SafeAreaBottomHeight, KScreenWidth, 55)];
    bgView.backgroundColor = [UIColor whiteColor];
    UIButton *commentButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, KScreenWidth - 80, 45)];
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
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(commentButton.frame) + 10, 5, 50, 45)];
    [button setTitleNormal:@"协助"];
    [button setImage:@"任务_协助"];
    
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 20, 0);
    button.titleEdgeInsets = UIEdgeInsetsMake(20, -18, 0, 0);
    [button setTitleColor:[UIColor blackColor]];
    button.titleLabel.font = [UIFont systemFontOfSize:14.f];
    button.layer.cornerRadius = 5.f;
//    button.backgroundColor = KNaviColor;
    [button addTarget:self action:@selector(opreationButtonAction:)];
    [bgView addSubview:button];
    [self.view addSubview:bgView];
}

- (void)initUI {
	[self HttpGetDetail];
	[self.tableView registerNib:[UINib nibWithNibName:RemarkCell bundle:nil] forCellReuseIdentifier:RemarkCell];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.tableView];
    [self.scrollView addSubview:self.commentTabelView];
	self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"23-顶右button" highImage:@"" isLeft:NO target:self andAction:@selector(clickHistory)];
}

#pragma mark - UITableViewData
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tableView) {
        return self.dataArray.count;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        NSArray *arr = self.dataArray[section][@"array"];
        return arr.count;
    } else {
        return self.hfDataArray.count;
    }
}

- (UITableViewCell *)tableviewCellTaskDescriptionWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        CGCNewAppointTextCell*acell=[tableView dequeueReusableCellWithIdentifier:RemarkCell];
        acell.topTitleLabel.text=@"任务描述";
        acell.textView.text = self.mainDatasModel.X_REMARK;
        acell.textView.editable = NO;
        return acell;
    } else if (indexPath.row == 3) {
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
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = cell.detailTextLabel.font = [UIFont systemFontOfSize:16.f];
        if (indexPath.row == 1) {
            cell.textLabel.text = @"期望开始时间";
            cell.detailTextLabel.text = self.mainDatasModel.D_CONFIRMED_TIME;
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"期望完成时间";
            cell.detailTextLabel.text = self.mainDatasModel.D_ORDER_TIME;
        } else if (indexPath.row == 4) {
            cell.textLabel.text = @"地址";
            cell.detailTextLabel.numberOfLines = 0;
            cell.detailTextLabel.text = self.mainDatasModel.C_ADDRESS;
        } else if (indexPath.row == 5) {
            cell.textLabel.text = @"类型";
            cell.detailTextLabel.text = self.mainDatasModel.C_TYPE_DD_NAME;
        } else if (indexPath.row == 6) {
            cell.textLabel.text = @"是否外出";
            cell.detailTextLabel.text = [self.mainDatasModel.I_TYPE isEqualToString:@"1"] ? @"是" : @"否";
        }
        else if (indexPath.row == 7) {
            cell.textLabel.text = @"负责人";
            cell.detailTextLabel.text = self.mainDatasModel.C_OWNER_ROLENAME;
        } else if (indexPath.row == 8) {
            cell.textLabel.text = @"优先等级";
            cell.detailTextLabel.text = self.mainDatasModel.C_TASKSTATUS_DD_NAME;
        }
        else if (indexPath.row == 9) {
            cell.textLabel.text = @"创建人";
            cell.detailTextLabel.text = self.mainDatasModel.C_CREATOR_ROLENAME;
        }
        //            else if (indexPath.row == 10) {
        //                cell.textLabel.text = @"是否外出";
        //                cell.detailTextLabel.text = [self.mainDatasModel.I_TYPE isEqualToString:@"1"] ? @"是" : @"否";
        //            }
        else {
            cell.textLabel.text = @"创建时间";
            cell.detailTextLabel.text = self.mainDatasModel.D_CREATE_TIME;
        }
        return cell;
    }
    

}

- (UITableViewCell *)tableviewCellConfirmTheInformationWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellSection1"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellSection1"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = cell.detailTextLabel.font = [UIFont systemFontOfSize:16.f];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"计划开始时间";
        cell.detailTextLabel.text = self.mainDatasModel.D_START_TIME;
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"计划完成时间";
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.text = self.mainDatasModel.D_END_TIME;
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"已用时长";
        cell.detailTextLabel.text = self.mainDatasModel.ALREADYDAY;
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"是否超时";
        cell.detailTextLabel.text = self.mainDatasModel.TIMEOUT;
    } else {
        cell.textLabel.text = @"优先等级";
        cell.detailTextLabel.text = self.mainDatasModel.C_TASKSTATUS_DD_NAME;
    }
    return cell;
}

- (UITableViewCell *)tableviewCellSignTheInformationWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = cell.detailTextLabel.font = [UIFont systemFontOfSize:16.f];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"签到人";
        cell.detailTextLabel.text = self.mainDatasModel.C_PROPOSER;
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"签到时间";
        cell.detailTextLabel.text = self.mainDatasModel.D_SIGNTIME_TIME;
    } else {
        cell.textLabel.text = @"签到地址";
        cell.detailTextLabel.text = self.mainDatasModel.C_SIGNADDRESS;
    }
        return cell;
    
}

- (UITableViewCell *)tableviewCellCompleteTheInformationWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
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
        if (indexPath.row == 0) {
            cell.textLabel.text = @"完成时间";
            cell.detailTextLabel.text = self.mainDatasModel.D_FINISH_TIME;
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"地点";
            cell.detailTextLabel.text = self.mainDatasModel.C_FINISHADDRESS;
            cell.detailTextLabel.numberOfLines = 0;
        } else {
            cell.textLabel.text = @"执行人";
            cell.detailTextLabel.text = self.mainDatasModel.C_OPERATOR;
        }
        return cell;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DBSelf(weakSelf);
    if (tableView == self.tableView) {
        NSArray *arr = self.dataArray[indexPath.section][@"array"];
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
                cell.detailWidthLayout.constant = KScreenWidth - 120;
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
        MJKCommentsListModel *model = self.hfDataArray[indexPath.row];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        NSString *titleStr = self.dataArray[indexPath.section][@"title"];
        if ([titleStr isEqualToString:@"任务信息"]) {
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
        NSArray *arr = self.dataArray[indexPath.section][@"array"];
        NSString *title = arr[indexPath.row];
        if ([title isEqualToString:@"地址"]) {
            if (self.mainDatasModel.C_ADDRESS.length <= 0) {
                [JRToast showWithText:@"暂无客户地址"];
                return;
            }
            MJKMapNavigationViewController *alertVC = [MJKMapNavigationViewController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            alertVC.C_ADDRESS = self.mainDatasModel.C_ADDRESS;
            [self presentViewController:alertVC animated:YES completion:nil];
        }
    }
    
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        NSString *titleStr = self.dataArray[indexPath.section][@"title"];
        if ([titleStr isEqualToString:@"签到信息"]) {
            if (indexPath.row == 2) {
                NSString *str = self.mainDatasModel.C_SIGNADDRESS;
                
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
        } else if ([titleStr isEqualToString:@"完成信息"]) {
            if (indexPath.row == 0) {
                return 120;
            }
            return 44;
    //        if (indexPath.row == 5) {
    //            NSString *str = self.mainDatasModel.C_FINISHADDRESS;
    //
    //            //        CGSize size = [str sizeWithFont:[UIFont fontWithName:@"Helvetica" size:16] constrainedToSize:CGSizeMake(280, 999) lineBreakMode:NSLineBreakByWordWrapping];
    //            CGSize size1 = [str boundingRectWithSize:CGSizeMake(KScreenWidth - 100, 999) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.f ]} context:nil].size;
    //
    //            if (str.length > 0) {
    //                if (size1.height + 10 > 44) {
    //                    return size1.height + 10;
    //                } else {
    //                    return 44;
    //                }
    //
    //            } else {
    //                return 44;
    //            }
    //        } else if (indexPath.row == 3) {
    //            return 44 + 66;
    //        }
        } else if ([titleStr isEqualToString:@"任务信息"]) {
            if (indexPath.row == 3) {
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
            } else if (indexPath.row == 1) {
                return 44 + 66;
            }
        }
        
        return 44;
    } else {
        CGFloat rowHeight = 0;
        MJKCommentsListModel *model = self.hfDataArray[indexPath.row];
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
        if (self.hfDataArray.count > 0) {
            return 30;
        } else {
            return .1f;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        NSString *titleStr = self.dataArray[section][@"title"];
        if ([titleStr isEqualToString:@"完成信息"]) {
            if (self.mainDatasModel.urlList.count > 0) {
                return 160;
            } else {
                return .1f;
            }
        }
        return .1f;
    } else {
        return .1f;
    }
	
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (tableView == self.tableView) {

        UIView *bgView = [[UIView alloc]initWithFrame:self.tableView.tableHeaderView.frame];
    //	bgView.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, KScreenWidth - 30, 20)];
        label.text = self.dataArray[section][@"title"];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:14.f];
        [bgView addSubview:label];
        return bgView;
    } else {
        if (self.hfDataArray.count > 0) {
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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        NSString *titleStr = self.dataArray[section][@"title"];
        if ([titleStr isEqualToString:@"完成信息"]) {
            if (self.mainDatasModel.urlList.count > 0) {
                self.tableFootPhoto.imageURLArray = self.mainDatasModel.urlList;
                
                return self.tableFootPhoto;
            } else {
                return nil;
            }
        }
        
        
        return nil;
    } else {
        return nil;
    }
	
	
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

#pragma mark - 点击事件
- (void)opreationButtonAction:(UIButton *)sender {
    DBSelf(weakSelf);
        //协助
        ShowHelpViewController *vc = [[ShowHelpViewController alloc]init];
        vc.vcName = @"任务";
        vc.orderID = self.mainDatasModel.C_ID;
        [self.navigationController pushViewController:vc animated:YES];
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
    DBSelf(weakSelf)
    MJKChooseMoreEmployeesViewController *vc = [[MJKChooseMoreEmployeesViewController alloc]init];
    vc.isAllEmployees = @"是";
    vc.noticeStr = @"无提示";
    vc.codeStr = self.saleStr;
//    vc.vcName = @"@提醒";
    vc.chooseEmployeesBlock = ^(NSString * _Nonnull codeStr, NSString * _Nonnull nameStr, NSString * _Nonnull u051CodeStr) {
        
        weakSelf.saleStr = codeStr;
        weakSelf.saleNameStr = nameStr;
        [weakSelf.noticeButton setTitleNormal:[NSString stringWithFormat:@"@%@",nameStr]];
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
            weakSelf.dataArray = nil;
			weakSelf.mainDatasModel=[ServiceTaskDetailModel yy_modelWithDictionary:data];
//			NSString*x_pic=self.mainDatasModel.X_PICURL;
//			if (x_pic&&![x_pic isEqualToString:@""]) {
//				NSArray*array=[x_pic componentsSeparatedByString:@","];
			
				if (weakSelf.mainDatasModel.urlList.count>=1) {
					[weakSelf.saveFooterUrlArray addObjectsFromArray:weakSelf.mainDatasModel.urlList];
                    
				}
				
//			}
			
			
			[weakSelf.tableView reloadData];
            CGRect tableViewFrame = weakSelf.tableView.frame;
            if (self.mainDatasModel.urlList.count > 0) {
                if (self.mainDatasModel.C_OPERATOR.length > 0) {
                    tableViewFrame.size.height = [weakSelf getTableViewHeight] + 180;
                } else {
                    tableViewFrame.size.height = [weakSelf getTableViewHeight];
                }
            } else {
                if (self.mainDatasModel.C_OPERATOR.length > 0) {
                    tableViewFrame.size.height = [weakSelf getTableViewHeight] + 120;
                } else {
                    tableViewFrame.size.height = [weakSelf getTableViewHeight] + 60;
                }
            }
//            tableViewFrame.size.height = weakSelf.mainDatasModel.urlList.count > 0 ? [weakSelf getTableViewHeight] : [weakSelf getTableViewHeight] + 60;
//            tableViewFrame.size.height = [weakSelf getTableViewHeight] + 60;
            weakSelf.tableView.frame = tableViewFrame;
            [weakSelf httpGetCommentsList];
			
		}else{
			[JRToast showWithText:data[@"message"]];
		}
		
		
	}];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"%f",self.tableView.contentSize.height);
    [commentText resignFirstResponder];
    [self.view endEditing:YES];
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
            weakSelf.hfDataArray = [MJKCommentsListModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
            //评论文字的内容高配置commenttableview的高
            CGFloat tableViewHeight = 0;
            for (MJKCommentsListModel *model in weakSelf.hfDataArray) {
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
            commentTVFame.origin.y = CGRectGetMaxY(weakSelf.tableView.frame);
            weakSelf.commentTabelView.frame = commentTVFame;
            weakSelf.scrollView.contentSize = CGSizeMake(KScreenWidth, weakSelf.tableView.frame.size.height + weakSelf.commentTabelView.frame.size.height);
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        weakSelf.view.userInteractionEnabled = YES;
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
	}
	return _tableView;
}

-(NSMutableArray *)saveFooterUrlArray{
	if (!_saveFooterUrlArray) {
		_saveFooterUrlArray=[NSMutableArray array];
	}
	return _saveFooterUrlArray;
}


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSMutableArray *section0 = [NSMutableArray array];
        NSMutableArray *section1 = [NSMutableArray array];
        NSMutableArray *section2 = [NSMutableArray array];
        NSMutableArray *section3 = [NSMutableArray array];
        
        for (int i = 0; i < 11; i++) {
            [section0 addObject:@[@"类型",@"任务描述",@"期望开始时间",@"期望完成时间",@"客户",@"地址",@"是否外出",@"负责人",@"优先等级",@"创建人",@"创建时间"][i]];
        }
        for (int i = 0; i < 4; i++) {
            [section1 addObject:@[@"计划开始时间",@"计划完成时间",@"已用时长",@"是否超时"][i]];
        }
        for (int i = 0; i < 3; i++) {
            [section2 addObject:@[@"签到人",@"签到时间",@"签到地址"][i]];
        }
        for (int i = 0; i < 4; i++) {
            [section3 addObject:@[@"执行内容描述",@"完成时间",@"地点",@"执行人"][i]];
        }
        
        [_dataArray addObject:@{@"title" : @"任务信息", @"array" : section0}];
        
        if (![self.mainDatasModel.ISOWN isEqualToString:@"1"]) {
            if (self.mainDatasModel.D_START_TIME.length > 0) {
                [_dataArray addObject:@{@"title" : @"确认信息", @"array" : section1}];
            }
        }
        if (self.mainDatasModel.D_SIGNTIME_TIME.length > 0) {
            [_dataArray addObject:@{@"title" : @"签到信息", @"array" : section2}];
        }
        if (self.mainDatasModel.D_FINISH_TIME.length > 0) {
            [_dataArray addObject:@{@"title" : @"完成信息", @"array" : section3}];
        }
        
    }
    return _dataArray;
}

- (UITableView *)commentTabelView {
    if (!_commentTabelView) {
        _commentTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
        _commentTabelView.dataSource = self;
        _commentTabelView.delegate = self;
        _commentTabelView.scrollEnabled = NO;
    }
    return _commentTabelView;
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
