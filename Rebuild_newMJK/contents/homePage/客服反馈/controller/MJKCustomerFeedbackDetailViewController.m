//
//  MJKCustomerFeedbackDetailViewController.m
//  Rebuild_newMJK
//
//  Created by huangjie on 2022/9/24.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import "MJKCustomerFeedbackDetailViewController.h"

#import "AddCustomerChooseTableViewCell.h"
#import "AddCustomerInputTableViewCell.h"

#import "MJKCustomerFeedbackModel.h"

#import "PotentailCustomerEditModel.h"
#import "MJKCustomerFeedbackModel.h"

@interface MJKCustomerFeedbackDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
/** <#注释#> */
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *localDatas;
/** <#注释#> */
@property (nonatomic, strong) MJKCustomerFeedbackModel *detailModel;
/** <#注释#> */
@property (nonatomic, strong) UIView *bottomView;
@end

@implementation MJKCustomerFeedbackDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"咨询信息";
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAVIHEIGHT);
        make.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(-AdaptSafeBottomHeight-55);
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.estimatedRowHeight = 300;
    if (@available(iOS 15.0,*)) {
        _tableView.sectionHeaderTopPadding = YES;
    }
    [self.view addSubview:self.bottomView];
    [self getLocalDatas];
    [self getDetail];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.localDatas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.localDatas[section];
    return arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PotentailCustomerEditModel *model = self.localDatas[indexPath.section][indexPath.row];
    AddCustomerChooseTableViewCell *ccell = [AddCustomerChooseTableViewCell cellWithTableView:tableView];
    AddCustomerInputTableViewCell *icell= [AddCustomerInputTableViewCell cellWithTableView:tableView];
    if ([model.locatedTitle isEqualToString:@"客户"]) {
        icell.nameTitleLabel.text = model.locatedTitle;
        icell.textStr = model.nameValue;
        return icell;
    } else if ([model.locatedTitle isEqualToString:@"客户电话"]) {
        icell.nameTitleLabel.text = model.locatedTitle;
        icell.textStr = model.nameValue;
        return icell;
    } else if ([model.locatedTitle isEqualToString:@"车架号"]) {
        icell.nameTitleLabel.text = model.locatedTitle;
        icell.textStr = model.nameValue;
        return icell;
    } else if ([model.locatedTitle isEqualToString:@"咨询类型"]) {
        ccell.nameTitleLabel.text = model.locatedTitle;
        ccell.textStr = model.nameValue;
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"紧急程度"]) {
        ccell.nameTitleLabel.text = model.locatedTitle;
        ccell.textStr = model.nameValue;
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"责任人"]) {
        icell.nameTitleLabel.text = model.locatedTitle;
        icell.textStr = model.nameValue;
        return icell;
    } else if ([model.locatedTitle isEqualToString:@"销售顾问"]) {
        icell.nameTitleLabel.text = model.locatedTitle;
        icell.textStr = model.nameValue;
        return icell;
    } else if ([model.locatedTitle isEqualToString:@"接待人"]) {
        icell.nameTitleLabel.text = model.locatedTitle;
        icell.textStr = model.nameValue;
        return icell;
    } else if ([model.locatedTitle isEqualToString:@"接待时间"]) {
        ccell.Type = ChooseTableViewTypeBirthday;
        ccell.nameTitleLabel.text = model.locatedTitle;
        ccell.textStr = model.nameValue;
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"解决时间"]) {
        ccell.Type = ChooseTableViewTypeBirthday;
        ccell.nameTitleLabel.text = model.locatedTitle;
        ccell.textStr = model.nameValue;
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"跟进情况反馈"]) {
        icell.nameTitleLabel.text = model.locatedTitle;
        icell.textStr = model.nameValue;
        return icell;
    } else if ([model.locatedTitle isEqualToString:@"最终结果"]) {
        icell.nameTitleLabel.text = model.locatedTitle;
        icell.textStr = model.nameValue;
        return icell;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)getDetail {
    @weakify(self);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    HttpManager*manager=[[HttpManager alloc]init];
    contentDic[@"C_ID"] = self.model.C_ID;
    contentDic[@"C_A47700_C_ID"] = self.model.C_A47700_C_ID;
    [manager getNewDataFromNetworkWithUrl:[NSString stringWithFormat:@"%@/api/crm/a814/info", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
        @strongify(self);
        if ([data[@"code"] integerValue] == 200) {
            self.detailModel = [MJKCustomerFeedbackModel mj_objectWithKeyValues:data[@"data"]];
            [self getPostValueAndBeforeValue];
            
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)getLocalDatas {
        NSArray*localArr=@[@"客户",@"客户电话",@"车架号",@"咨询类型",@"紧急程度",@"责任人",@"销售顾问",@"接待人",@"接待时间",@"解决时间",@"跟进情况反馈",@"最终结果"];
        NSArray*localValueArr=@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
        NSArray*localPostNameArr=@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
        NSArray*localKeyArr=@[@"C_KH_NAME",@"C_KH_PHONE",@"C_VIN",@"C_ZXLX_DD_ID",@"C_JJCD_DD_ID",@"C_OWNER_ROLEID",@"C_XSGW_ROLENAME",@"C_JDR",@"D_JDSJ",@"D_JJSJ",@"C_GJQKFK",@"C_ZZJG"];
    
    
   
    
        NSMutableArray*saveLocalArr=[NSMutableArray array];
        for (int i=0; i<localArr.count; i++) {
            PotentailCustomerEditModel*model=[[PotentailCustomerEditModel alloc]init];
            model.locatedTitle=localArr[i];
            model.nameValue=localValueArr[i];
            model.postValue=localPostNameArr[i];
            model.keyValue=localKeyArr[i];
            
            [saveLocalArr addObject:model];
        }
    
    self.localDatas = [NSMutableArray arrayWithObject:saveLocalArr];
    
//    if ([self.detailModel.C_TYPE_DD_ID isEqualToString:@"A80600_C_TYPE_0001"]) {
        [self getPostValueAndBeforeValue];
//    }
}

-(void)getPostValueAndBeforeValue{
    
    NSArray*section0ShowNameArray =@[self.detailModel.C_KH_NAME.length > 0 ? self.detailModel.C_KH_NAME : @"",
                                     self.detailModel.C_KH_PHONE.length > 0 ? self.detailModel.C_KH_PHONE : @"",
                                     self.detailModel.C_VIN.length > 0 ? self.detailModel.C_VIN : @"",
                                     self.detailModel.C_ZXLX_DD_NAME.length > 0 ? self.detailModel.C_ZXLX_DD_NAME : @"",
                                     self.detailModel.C_JJCD_DD_NAME.length > 0 ? self.detailModel.C_JJCD_DD_NAME : @"",
                                     self.detailModel.C_OWNER_ROLENAME.length > 0 ? self.detailModel.C_OWNER_ROLENAME : @"",
                                     self.detailModel.C_XSGW_ROLENAME.length > 0 ? self.detailModel.C_XSGW_ROLENAME : @"",
                                     self.detailModel.C_JDR.length > 0 ? self.detailModel.C_JDR : @"",
                                     self.detailModel.D_JDSJ.length > 0 ? self.detailModel.D_JDSJ: @"",
                                     self.detailModel.D_JJSJ.length > 0 ? self.detailModel.D_JJSJ : @"",
                                     self.detailModel.C_GJQKFK.length > 0 ? self.detailModel.C_GJQKFK : @"",
                                     self.detailModel.C_ZZJG.length > 0 ? self.detailModel.C_ZZJG : @""];
    
    NSArray*section0PostNameArray =@[self.detailModel.C_KH_NAME.length > 0 ? self.detailModel.C_KH_NAME : @"",
                                     self.detailModel.C_KH_PHONE.length > 0 ? self.detailModel.C_KH_PHONE : @"",
                                     self.detailModel.C_VIN.length > 0 ? self.detailModel.C_VIN : @"",
                                     self.detailModel.C_ZXLX_DD_ID.length > 0 ? self.detailModel.C_ZXLX_DD_ID : @"",
                                     self.detailModel.C_JJCD_DD_ID.length > 0 ? self.detailModel.C_JJCD_DD_ID : @"",
                                     self.detailModel.C_OWNER_ROLEID.length > 0 ? self.detailModel.C_OWNER_ROLEID : @"",
                                     self.detailModel.C_XSGW_ROLENAME.length > 0 ? self.detailModel.C_XSGW_ROLENAME : @"",
                                     self.detailModel.C_JDR.length > 0 ? self.detailModel.C_JDR : @"",
                                     self.detailModel.D_JDSJ.length > 0 ? self.detailModel.D_JDSJ: @"",
                                     self.detailModel.D_JJSJ.length > 0 ? self.detailModel.D_JJSJ : @"",
                                     self.detailModel.C_GJQKFK.length > 0 ? self.detailModel.C_GJQKFK : @"",
                                     self.detailModel.C_ZZJG.length > 0 ? self.detailModel.C_ZZJG : @""];
    
    
   
    NSMutableArray*MainArray0=self.localDatas[0];
    for (int i=0; i<MainArray0.count; i++) {
        PotentailCustomerEditModel*model=MainArray0[i];
        model.nameValue=section0ShowNameArray[i];
        model.postValue=section0PostNameArray[i];
    }
    
    [self.tableView reloadData];
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - SafeAreaBottomHeight - 55, KScreenWidth, 55)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, KScreenWidth - 10, 45)];
        [button setTitleNormal:@"提交"];
        [button setTitleColor:[UIColor blackColor]];
        button.layer.cornerRadius = 5.f;
        [button addTarget:self action:@selector(submitAction:)];
        [button setBackgroundColor:KNaviColor];
        [_bottomView addSubview:button];
    }
    return _bottomView;
}


@end
