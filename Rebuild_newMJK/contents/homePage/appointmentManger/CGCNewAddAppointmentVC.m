//
//  CGCNewAddAppointmentVC.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/8/30.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CGCNewAddAppointmentVC.h"
#import "CGCNewAppointmentCell.h"
#import "CGCNewAppointTextCell.h"
#import "CGCNewAaddAppiontModel.h"
#import "CGCSellModel.h"
#import "CGCAppointmentModel.h"


#import "PickerChoiceView.h"
#import "CGCCustomModel.h"
#import "DBPickerView.h"

#import "MJKShowSendView.h"
#import "MJKMessagePushNotiViewController.h"
#import "MJKChooseEmployeesViewController.h"

#import "CGCAppointmentListVC.h"
#import "MJKClueListSubModel.h"

#import "MJKClueListViewModel.h"

@interface CGCNewAddAppointmentVC ()<UITableViewDelegate,UITableViewDataSource,TFPickerDelegate,UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) UIButton * pickerBtn;
@property (nonatomic,strong) PickerChoiceView * sexPicker;
@property (nonatomic,strong) PickerChoiceView * sellPicker;
@property (nonatomic,strong) CGCNewAaddAppiontModel * addmodel;
@property (nonatomic, strong) NSMutableArray  *sellNameArr;

/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *btArray;

@end

@implementation CGCNewAddAppointmentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self HTTPGetSellList];
    [self createData];
    [self.view addSubview:self.tableView];
    [self createUI];
    // Do any additional setup after loading the view.
    self.btArray = [NSMutableArray array];
    NSArray *btNormalArray = [NewUserSession instance].configData.btListMapKh;
    for (NSDictionary *dic in btNormalArray) {
        [self.btArray addObject:dic[@"CODE"]];
    }
}


#pragma mark -- createUI
- (void)createUI{

    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(10, KScreenHeight-54, KScreenWidth-20, 44);
    [btn setTitleNormal:@"提交" ];
    [btn setTitleColor:DBColor(0, 0, 0)];
    btn.layer.cornerRadius=4;
    btn.layer.masksToBounds=YES;
    btn.backgroundColor=KNaviColor;
    [btn addTarget:self action:@selector(HTTPAddCustom)];
    [self.view addSubview:btn];

}


#pragma mark -- createData//初始化操作
- (void)createData{
    self.title=@"新增预约";
  
    self.view.backgroundColor=CGCTABBGColor;
 
    

        self.addmodel=[[CGCNewAaddAppiontModel alloc] init];
        self.addmodel.C_OWNER_ROLENAME=[NewUserSession instance].user.nickName;
        self.addmodel.C_OWNER_ROLEID=[NewUserSession instance].user.u051Id;

        self.addmodel.C_ID=[NSString stringWithFormat:@"A41600%@-%@%@",[NewUserSession instance].user.u051Id,[DBTools getCurrentTimeStamp],[DBTools GetRandomChar]];
        self.addmodel.D_BOOK_TIME= [DBTools getTimeFomatFromCurrentTimeStamp];

    
    if (self.amodel.C_A41500_C_ID.length>0) {
        self.addmodel.C_A41500_C_ID=self.amodel.C_A41500_C_ID;
        self.addmodel.C_A41500_C_NAME=self.amodel.C_A41500_C_NAME;
        self.addmodel.C_PHONE=self.amodel.C_PHONE;
        self.addmodel.C_SEX_DD_NAME=self.amodel.C_SEX_DD_NAME;
        self.addmodel.C_SEX_DD_ID=self.amodel.C_SEX_DD_ID;
//        self.addmodel.C_ID=self.amodel.C_ID;
    }
}


#pragma mark -- tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 8;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGCNewAppointmentCell * cell=[CGCNewAppointmentCell cellWithTableView:tableView];
    
    cell.detailWidthLayout.constant = KScreenWidth - 120;
    if (indexPath.row==1) {
        cell.detailLab.hidden=YES;
        cell.telLab.placeholder=@"请输入";
        cell.telLab.delegate=self;
        
    }
       
    [cell hidenStar:indexPath withModel:self.addmodel];
    
    if (indexPath.row==7) {
        CGCNewAppointTextCell * cell=[CGCNewAppointTextCell cellWithTableView:tableView];
//        cell.remarkLab.text=self.addmodel.X_REMARK;
        if ([self.btArray containsObject:@"A47500_C_BTX_0010"]) {
            cell.mustLabel.hidden = NO;
        }
        cell.textView.text=self.addmodel.X_REMARK;
        cell.textView.delegate=self;
        cell.textView.tag=1234;
        return cell;
    }

    
    
     return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row==7) {
        
       
        return 100;
    }

    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[self.view endEditing:YES];
    DBSelf(weakSelf);
    if (indexPath.row==0) {
        if (![[NewUserSession instance].appcode containsObject:@"APP006_0009"] &&
            ![[NewUserSession instance].appcode containsObject:@"APP006_0008"] &&
            ![[NewUserSession instance].appcode containsObject:@"APP006_0007"]) {
            [JRToast showWithText:@"暂无权限选择客户"];
            return;
        }
        MJKCustomerChooseViewController *vc = [MJKCustomerChooseViewController new];
        vc.rootVC = self;
        vc.chooseCustomerBlock = ^(CGCCustomModel * _Nonnull cmodel) {
            if (cmodel==nil) {
                return ;
            }
            weakSelf.addmodel.C_A41500_C_ID=cmodel.C_A41500_C_ID;
            weakSelf.addmodel.C_A41500_C_NAME=cmodel.C_NAME;
            weakSelf.addmodel.C_SEX_DD_NAME=cmodel.C_SEX_DD_NAME;
            weakSelf.addmodel.C_SEX_DD_ID=cmodel.C_SEX_DD_ID;

            weakSelf.addmodel.C_PHONE=cmodel.C_PHONE;
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row==2) {
        [self datePickerAndMethod];
    }
    
    if (indexPath.row==3) {
        NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41600_C_YYLX"];
        NSMutableArray*mtArray=[NSMutableArray array];
        NSMutableArray*postArray=[NSMutableArray array];
        for (MJKDataDicModel*model in dataArray) {
            [mtArray addObject:model.C_NAME];
            [postArray addObject:model.C_VOUCHERID];
        }
        DBSelf(weakSelf);
        DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:@"" andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
            MyLog(@"%@    %@",title,indexStr);
            NSInteger number=[indexStr integerValue];
            NSString*postStr=postArray[number];
            weakSelf.addmodel.C_MODEFOLLOW_DD_ID=postStr;
            weakSelf.addmodel.C_MODEFOLLOW_DD_NAME=title;
            
            [weakSelf.tableView reloadData];
        }];
        [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
 
    }
    
    if (indexPath.row==4) {
        NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41600_C_YYMB"];
        NSMutableArray*mtArray=[NSMutableArray array];
        NSMutableArray*postArray=[NSMutableArray array];
        for (MJKDataDicModel*model in dataArray) {
            [mtArray addObject:model.C_NAME];
            [postArray addObject:model.C_VOUCHERID];
        }
        DBSelf(weakSelf);
        DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:@"" andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
            MyLog(@"%@    %@",title,indexStr);
            NSInteger number=[indexStr integerValue];
            NSString*postStr=postArray[number];
            weakSelf.addmodel.C_ISDRIVE_DD_ID=postStr;
            weakSelf.addmodel.C_ISDRIVE_DD_NAME=title;
            
            [weakSelf.tableView reloadData];
        }];
        [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
 
    }
    
    if (indexPath.row==5) {
        
//        self.sexPicker=nil;
//        [self.view addSubview:self.sexPicker];
        NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41500_C_SEX"];
        NSMutableArray*mtArray=[NSMutableArray array];
        NSMutableArray*postArray=[NSMutableArray array];
        for (MJKDataDicModel*model in dataArray) {
            [mtArray addObject:model.C_NAME];
            [postArray addObject:model.C_VOUCHERID];
        }
        DBSelf(weakSelf);
        DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:@"" andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
            MyLog(@"%@    %@",title,indexStr);
            NSInteger number=[indexStr integerValue];
            NSString*postStr=postArray[number];
            weakSelf.addmodel.C_SEX_DD_ID=postStr;
            weakSelf.addmodel.C_SEX_DD_NAME=title;
            
            [weakSelf.tableView reloadData];
        }];
        [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
        
 
    }
    if (indexPath.row==6) {
        MJKChooseEmployeesViewController *vc = [[MJKChooseEmployeesViewController alloc]init];
//        vc.isAllEmployees = @"是";
        vc.noticeStr = @"无提示";
        vc.chooseEmployeesBlock = ^(MJKClueListSubModel * _Nonnull model) {
            weakSelf.addmodel.C_OWNER_ROLENAME=model.nickName;
            weakSelf.addmodel.C_OWNER_ROLEID=model.u051Id;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    


}
    
- (void)textViewDidEndEditing:(UITextView *)textView{
    
     self.addmodel.X_REMARK=textView.text;
}



#pragma mark -- touch


- (void)showDate:(UIDatePicker *)datePicker
    {
        if (datePicker.tag==100) {
            
            NSDate *date = datePicker.date;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSString *outputString = [formatter stringFromDate:date];
            if ([self compareDate:[formatter stringFromDate:[NSDate date]] withDate:outputString] == 1) {
                self.addmodel.D_BOOK_TIME=outputString;
                [self.tableView reloadData];
            } else {
                [JRToast showWithText:@"预约时间必须大于当前时间"];
                return;
            }
            
        }
        
}

- (void)donePicker {
        NSDate *date = self.datePicker.date;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *outputString = [formatter stringFromDate:date];
        if ([self compareDate:[formatter stringFromDate:[NSDate date]] withDate:outputString] == 1) {
//            self.addmodel.D_BOOK_TIME=outputString;
//            [self.tableView reloadData];
        } else {
            [JRToast showWithText:@"预约时间必须大于当前时间"];
            return;
        }
        MyLog(@"datePicker ===== %@",self.datePicker.date);
    
    [super donePicker];
}

//比较两个日期的大小  日期格式为2016-08-14 08：46：20
- (NSInteger)compareDate:(NSString*)aDate withDate:(NSString*)bDate
{
    NSInteger aa = 0;
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    dateformater.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [dateformater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dta = [[NSDate alloc] init];
    NSDate *dtb = [[NSDate alloc] init];
    
    dta = [dateformater dateFromString:aDate];
    dtb = [dateformater dateFromString:bDate];
    NSComparisonResult result = [dta compare:dtb];
    if (result==NSOrderedSame)
    {
        //        相等  aa=0
    }else if (result==NSOrderedAscending)
    {
        //bDate比aDate大
        aa=1;
    }else if (result==NSOrderedDescending)
    {
        //bDate比aDate小
        aa=-1;
        
    }
    
    return aa;
}

    

    
    
    
#pragma mark -- 网络请求 request
- (void)HTTPAddCustom{
    DBSelf(weakSelf);
    if (self.addmodel.C_A41500_C_NAME.length==0) {
         [JRToast showWithText:@"请选择客户姓名"];
        return;
    }
//    if (self.addmodel.C_PHONE.length==0) {
//        [JRToast showWithText:@"请输入手机号码"];
//        return;
//    }
    if (self.addmodel.C_A41500_C_ID.length==0) {
        [JRToast showWithText:@"无效的客户"];
        return;
    }
    if (self.addmodel.C_OWNER_ROLEID.length==0) {
        [JRToast showWithText:@"请选择员工"];
        return;
    }
    
//    NSArray *btArr = [NewUserSession instance].btListMapKh;
    if ([self.btArray containsObject:@"A47500_C_BTX_0010"]) {
        if (self.addmodel.X_REMARK.length <= 0) {
            [JRToast showWithText:@"请输入预约备注"];
            return;
        }
    }
    if (self.addmodel.C_MODEFOLLOW_DD_ID.length==0) {
        [JRToast showWithText:@"请选择邀约类型"];
        return;
    }
    if (self.addmodel.C_ISDRIVE_DD_ID.length==0) {
        [JRToast showWithText:@"请选择邀约目标"];
        return;
    }
    
//    for (NSDictionary *dic in btArr) {
//        if ([dic[@"CODE"] isEqualToString:@"A47500_C_BTX_0010"]) {
//            if (self.addmodel.X_REMARK.length <= 0) {
//                [JRToast showWithText:@"请输入预约备注"];
//                return;
//            }
//        }
//    }
    
    
    NSMutableDictionary *dic=[NSMutableDictionary new];
	
	if (self.C_A42000_C_ID.length > 0) {
		dic[@"C_A42000_C_ID"] = self.C_A42000_C_ID;
	}
    self.addmodel.C_OWNER_ROLEID.length>0?[dic setObject:self.addmodel.C_OWNER_ROLEID forKey:@"USER_ID"]:0;
    self.addmodel.C_ID.length>0?[dic setObject:self.addmodel.C_ID forKey:@"C_ID"]:0;
    self.addmodel.C_A41500_C_NAME.length>0?[dic setObject:self.addmodel.C_A41500_C_NAME forKey:@"C_A41500_C_NAME"]:0;
    self.addmodel.C_A41500_C_ID.length>0?[dic setObject:self.addmodel.C_A41500_C_ID forKey:@"C_A41500_C_ID"]:0;
    self.addmodel.C_PHONE.length>0?[dic setObject:self.addmodel.C_PHONE forKey:@"C_PHONE"]:0;
//    [dic setObject:[DBObjectTools getVustomerFollowC_id] forKey:@"C_ID"];
    self.addmodel.D_BOOK_TIME.length>0?[dic setObject:self.addmodel.D_BOOK_TIME forKey:@"D_BOOK_TIME"]:0;
    self.addmodel.C_SEX_DD_ID.length>0?[dic setObject:self.addmodel.C_SEX_DD_ID forKey:@"C_SEX_DD_ID"]:0;
    self.addmodel.C_OWNER_ROLEID.length>0?[dic setObject:self.addmodel.C_OWNER_ROLEID forKey:@"C_OWNER_ROLEID"]:0;
    
    self.addmodel.C_MODEFOLLOW_DD_ID.length>0?[dic setObject:self.addmodel.C_MODEFOLLOW_DD_ID forKey:@"C_MODEFOLLOW_DD_ID"]:0;
    
    self.addmodel.C_ISDRIVE_DD_ID.length>0?[dic setObject:self.addmodel.C_ISDRIVE_DD_ID forKey:@"C_ISDRIVE_DD_ID"]:0;
    self.addmodel.X_REMARK.length>0?[dic setObject:self.addmodel.X_REMARK forKey:@"X_REMARK"]:[dic setObject:@"" forKey:@"X_REMARK"];
    
    
    HttpManager*manager=[[HttpManager alloc]init];
    
    [manager postNewDataFromNetworkWithUrl:[NSString stringWithFormat:@"%@/api/crm/a416Yy/add", HTTP_IP] parameters:dic compliation:^(id data, NSError *error) {
        [weakSelf.view addSubview:weakSelf.tableView];
        if ([data[@"code"] integerValue]==200) {
//            if ([[NewUserSession instance].configData.khtsList containsObject:@"A47500_C_YYTSDW_0000"]) {
//                [weakSelf pushInfoWithC_A41500_C_ID:weakSelf.addmodel.C_A41500_C_ID andC_ID:weakSelf.addmodel.C_ID andC_TYPE_DD_ID:@"A47500_C_YYTSDW_0000"];
//            }  else {
//                if (weakSelf.rloadBlock) {
//                    weakSelf.rloadBlock();
//                }
            [KUSERDEFAULT setObject:@"yes" forKey:@"refresh"];
                [weakSelf.navigationController popViewControllerAnimated:YES];
//            }
            
            
            
        }else{
            
            [JRToast showWithText:data[@"msg"]];
        
        }
  
    }];
    
//    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
//        [self.view addSubview:self.tableView];
//        if ([data[@"code"] integerValue]==200) {
//            if ([[NewUserSession instance].configData.khtsList containsObject:@"A47500_C_YYTSDW_0000"]) {
//                [weakSelf pushInfoWithC_A41500_C_ID:self.addmodel.C_A41500_C_ID andC_ID:self.addmodel.C_ID andC_TYPE_DD_ID:@"A47500_C_YYTSDW_0000"];
//            }  else {
//                if (self.rloadBlock) {
//                    self.rloadBlock();
//                }
//
//                [self.navigationController popViewControllerAnimated:YES];
//            }
//
//
//
//        }else{
//
//            [JRToast showWithText:data[@"message"]];
//
//        }
//
//    }];


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
                    if (self.rloadBlock) {
                        self.rloadBlock();
                    }
                    
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    NSMutableDictionary *contentDic = [NSMutableDictionary dictionaryWithDictionary:data[@"content"]];
//                    NSMutableArray *paramDic = [NSMutableArray array];
//                    [paramDic addObject:self.addmodel.C_A41500_C_NAME];
//                    if ([self.addmodel.C_SEX_DD_NAME isEqualToString:@"男"]) {
//                        [paramDic addObject:@"先生"];
//                    } else if ([self.addmodel.C_SEX_DD_NAME isEqualToString:@"女"]){
//                        [paramDic addObject:@"女士"];
//                    } else {
//                        [paramDic addObject:@" "];
//                    }
//                    [paramDic addObject:[NewUserSession instance].C_ABBREVATION];
//
//                    [paramDic addObject:self.addmodel.D_BOOK_TIME];
//                    [paramDic addObject:[NewUserSession instance].storeAddress];
//
//                    [paramDic addObject:[NewUserSession instance].user.nickName];
//                    [paramDic addObject:[NewUserSession instance].user.phonenumber];
//                    contentDic[@"params"] = paramDic;
                    
                    MJKMessagePushNotiViewController *vc = [[MJKMessagePushNotiViewController alloc]init];
                    vc.dataDic = contentDic;
                    vc.C_A41500_C_ID = C_A41500_C_ID;
                    vc.C_TYPE_DD_ID = C_TYPE_DD_ID;
                    vc.C_ID = C_ID;
                    vc.rootVC = self.rootVC;
                    vc.titleNameXCX = @"预约确认通知";
                    vc.backActionBlock = ^{
                        //CGCAppointmentListVC
//                        for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
//                            if ([vc isKindOfClass:[CGCAppointmentListVC class]]) {
                                [weakSelf.navigationController popToViewController:weakSelf.rootVC animated:YES];
//                            }
//                        }
                    };
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
            };
//            if ([[NewUserSession instance].configData.khtsList containsObject:@"A47500_C_YYTSDW_0000"]) {
                [weakSelf.view addSubview:showView];
//            }  else {
//                if (self.rloadBlock) {
//                    self.rloadBlock();
//                }
//
//                [self.navigationController popViewControllerAnimated:YES];
//            }
            
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
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
                [weakSelf.sellArr addObject:model];
            }
            
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
        
    }];
    
    
    
}


#pragma mark -- set
- (UITableView *)tableView{

    if (_tableView==nil) {
        _tableView=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.tableFooterView=[[UIView alloc] init];
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }

    return _tableView;
}

- (NSMutableArray *)sellArr{
    if (!_sellArr) {
        _sellArr=[NSMutableArray array];
    }

    return _sellArr;
}

- (NSMutableArray *)sellNameArr{

    if (_sellNameArr==nil) {
        _sellNameArr=[NSMutableArray array];
    }
    
    return _sellNameArr;
}



- (PickerChoiceView *)sexPicker{

    if (_sexPicker==nil) {
        _sexPicker=[[PickerChoiceView alloc]initWithFrame:self.view.bounds];
        _sexPicker.delegate=self;
        _sexPicker.arrayType=GenderArray;
    }
    return _sexPicker;
}

//- (PickerChoiceView *)sellPicker{
//    
//    if (_sellPicker==nil) {
//        NSMutableArray * nameArr=[NSMutableArray array];
//        for (CGCSellModel *model in self.sellArr) {
//            [nameArr addObject:model.C_NAME];
//        }
//        _sellPicker=[[PickerChoiceView alloc]initWithFrame:self.view.bounds withArray:nameArr];
//        _sellPicker.delegate=self;
//        _sellPicker.arrayType=sellType;
//       
//       
//    }
//    return _sellPicker;
//}
#pragma mark -- otherDelegate



    //性别、销售顾问
- (void)PickerSelectorIndixString:(NSString *)str{

}

- (void)PickerSelectorIndixColour:(UIColor *)color{

}
- (void)Picker:(PickerChoiceView *)pick SelectorIndixString:(NSString *)str{
    
    
    if (pick==self.sexPicker) {
        
        for (MJKDataDicModel *model in[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41500_C_SEX"] ) {
            
            if ([str isEqualToString:model.C_NAME]) {
                
                self.addmodel.C_SEX_DD_ID=model.C_VOUCHERID;
                self.addmodel.C_SEX_DD_NAME=str;
            }
        }
        
    }
    
    if (pick==self.sellPicker) {
        
        for (CGCSellModel * model in self.sellArr) {
            if ([model.nickName isEqualToString:str]) {
                self.addmodel.C_OWNER_ROLENAME=str;
                self.addmodel.C_OWNER_ROLEID=model.u051Id;
            }
            
        }
    }
    [self.tableView reloadData];
    
}

//- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    [UIView animateWithDuration:0.25 animations:^{
//        self.tableView.frame=CGRectMake(0, -30, KScreenWidth, KScreenHeight);
//    }];
//}
//    
- (void)textFieldDidEndEditing:(UITextField *)textField{

    self.addmodel.C_PHONE=textField.text;
//    [UIView animateWithDuration:0.25 animations:^{
//        self.tableView.frame=self.view.bounds;
//    }];
}
    
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    
//    [[UIApplication sharedApplication].keyWindow endEditing:YES];
//    
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//
//    [[UIApplication sharedApplication].keyWindow endEditing:YES ];
//}
//    

@end
