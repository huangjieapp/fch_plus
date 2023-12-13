//
//  AddCustomerChooseTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/9/15.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "AddCustomerChooseTableViewCell.h"

#import "DBPickerView.h"

//#import "PickerChoiceView.h"
#import "MJKMarketModel.h"        //市场活动
#import "MJKFunnelChooseModel.h"  //保存市场活动要的两个值
#import "MJKClueListViewModel.h"
#import "CustomerLvevelNextFollowModel.h"
#import "MJKChooseEmployeesModel.h"
#import "MJKAdditionalInfoModel.h"
#import "MJKCustomReturnSubModel.h"
#import "MJKA807MainModel.h"
#import "CustomerPCModel.h"



@interface AddCustomerChooseTableViewCell()<UITextFieldDelegate>
//@property (nonatomic, strong) NSMutableArray *saveTimeNumberArray;



@end

@implementation AddCustomerChooseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.taglabel.hidden=YES;
    self.BottomLineView.hidden=YES;
    self.chooseTextField.delegate=self;
    
    
    
}

#pragma mark  --delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self clickTextField];
    
    return NO;
}

- (void)getDayLevel:(void(^)(NSArray *array))successBlock {
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/masterdata/a411/list", HTTP_IP] parameters:@{} compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            NSMutableArray *saveTimeNumberArray=[NSMutableArray array];
            for (NSDictionary*dict in data[@"data"][@"list"]) {
                CustomerLvevelNextFollowModel*model=[CustomerLvevelNextFollowModel yy_modelWithDictionary:dict];
                [saveTimeNumberArray addObject:model];
                
                
            }
            
            if (successBlock) {
                successBlock(saveTimeNumberArray);
            }
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
    }];
    
}

- (void)getActivityCategory:(void(^)(NSArray *array))successBlock {
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:@"A70600WebService-getList"];
    
    NSDictionary*contentDict=@{@"C_TYPE_DD_ID" : @"A70600_C_TYPE_0000"};
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            NSMutableArray *saveTimeNumberArray=[NSMutableArray array];
            for (NSDictionary*dict in data[@"content"]) {
                CustomerLvevelNextFollowModel*model=[CustomerLvevelNextFollowModel yy_modelWithDictionary:dict];
                [saveTimeNumberArray addObject:model];
                
                
            }
            
            if (successBlock) {
                successBlock(saveTimeNumberArray);
            }
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
    }];
    
}

#pragma mark  --click
-(void)clickTextField{
    UIViewController*superVC=[DBTools getSuperViewWithsubView:self];
    [[DBTools findFirstResponderBeneathView:superVC.view] resignFirstResponder];
    
    
    
    switch (self.Type) {
        case ChooseTableViewTypeLevel:{
            [self getDayLevel:^(NSArray *array) {
                if (array.count <=0) {
                    [JRToast showWithText:@"暂无数据"];
                    return;
                }
                NSMutableArray*mtArray=[NSMutableArray array];
                NSMutableArray*postArray=[NSMutableArray array];
                for (CustomerLvevelNextFollowModel*model in array) {
                    [mtArray addObject:model.C_DAYNAME];
                    [postArray addObject:model.C_VOUCHERID];
                }
                
                DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                    MyLog(@"%@    %@",title,indexStr);
                    NSInteger number=[indexStr integerValue];
                    NSString*postStr=postArray[number];
                    if (self.chooseBlock) {
                        self.chooseBlock(title, postStr);
                    }
                    
                    
                }];
                [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            }];
            //            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41500_C_LEVEL"];
            //            NSMutableArray*mtArray=[NSMutableArray array];
            //            NSMutableArray*postArray=[NSMutableArray array];
            //            for (MJKDataDicModel*model in dataArray) {
            //
            //            }
            
            
            
            
            
            
            break;}
        case ChooseTableViewTypeFolderType: {
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A70800_C_WJGS"];
            
            if (dataArray.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:nil andTitleStr:nil andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;
        }
        case ChooseTableViewTypeFansLevel:{
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A47700_C_LEVEL"];
            if (dataArray.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            DBSelf(weakSelf);
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:@"" andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                if (weakSelf.chooseBlock) {
                    weakSelf.chooseBlock(title, postStr);
                }
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            break;}
        case ChooseTableViewTypeFansType:{
//            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A47700_C_TYPE"];
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41600_C_FSGJFS"];
            if (dataArray.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
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
                
                if ([postStr isEqualToString:@"A41600_C_FSGJFS_0001"]) {
                    if ([DBObjectTools isLocationServiceOpenWithSelfView:superVC.view]) {
                        if (self.chooseBlock) {
                            self.chooseBlock(title, postStr);
                        }
                    }
                } else {
                    if (self.chooseBlock) {
                        self.chooseBlock(title, postStr);
                    }
                }
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            break;}
        case ChooseTableViewTypeShopL: {
            [self getShopWithBlock:^(NSArray *typeArray) {
                if (typeArray.count <=0) {
                    [JRToast showWithText:@"暂无数据"];
                    return;
                }
                NSMutableArray*mtArray=[NSMutableArray array];
                NSMutableArray*postArray=[NSMutableArray array];
                for (MJKA807MainModel *model in typeArray) {
                    [mtArray addObject:model.C_NAME];
                    [postArray addObject:model.C_LOCCODE];
                }
                
                DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                    MyLog(@"%@    %@",title,indexStr);
                    NSInteger number=[indexStr integerValue];
                    NSString*postStr=postArray[number];
                    
                    if (self.chooseBlock) {
                        self.chooseBlock(title, postStr);
                    }
                    
                    
                }];
                [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
                
            }];
        }
            break;
        case ChooseTableViewTypeFansHY:{
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A47700_C_INDUSTRY"];
            if (dataArray.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            DBSelf(weakSelf);
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:@"" andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                if (weakSelf.chooseBlock) {
                    weakSelf.chooseBlock(title, postStr);
                }
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            break;}
        case ChooseTableViewTypeStage:{
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41500_C_STAGE"];
            if (dataArray.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            NSMutableArray*mtArray=[NSMutableArray array];
            
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;}
        case ChooseTableViewTypePaymentMethods: {
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A04200_C_PAYCHANNEL"];
            if (dataArray.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            NSMutableArray*mtArray=[NSMutableArray array];
            
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;}
        case ChooseTableViewTypePaymentType: {
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A04200_C_TYPE"];
            if (dataArray.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            NSMutableArray*mtArray=[NSMutableArray array];
            
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;}
        case ChooseTableViewTypeCategory: {
            [self getActivityCategory:^(NSArray *array) {
                if (array.count <=0) {
                    [JRToast showWithText:@"暂无数据"];
                    return;
                }
                NSMutableArray*mtArray=[NSMutableArray array];
                NSMutableArray*postArray=[NSMutableArray array];
                for (CustomerLvevelNextFollowModel*model in array) {
                    [mtArray addObject:model.C_NAME];
                    [postArray addObject:model.C_ID];
                }
                
                DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                    MyLog(@"%@    %@",title,indexStr);
                    NSInteger number=[indexStr integerValue];
                    NSString*postStr=postArray[number];
                    if (self.chooseBlock) {
                        self.chooseBlock(title, postStr);
                    }
                    
                    
                }];
                [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            }];
            //            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A49600_C_TYPE"];
            //            NSMutableArray*mtArray=[NSMutableArray array];
            //            NSMutableArray*postArray=[NSMutableArray array];
            //            for (MJKDataDicModel*model in dataArray) {
            //                [mtArray addObject:model.C_NAME];
            //                [postArray addObject:model.C_VOUCHERID];
            //            }
            //
            //            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
            //                MyLog(@"%@    %@",title,indexStr);
            //                NSInteger number=[indexStr integerValue];
            //                NSString*postStr=postArray[number];
            //
            //                if (self.chooseBlock) {
            //                    self.chooseBlock(title, postStr);
            //                }
            //
            //
            //            }];
            //            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;}
            
        case ChooseTableViewTypeGender:{
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41500_C_SEX"];
            if (dataArray.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;}
            
        case ChooseTableViewTypeCarLevel: {
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A71000_C_LEVEL"];
            if (dataArray.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;}
        case ChooseTableViewTypeCarType: {
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A71000_C_TYPE"];
            if (dataArray.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;}
            
        case ChooseTableViewTypeCarSpecies: {
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A71000_C_ESC_TYPE"];
            if (dataArray.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;}
            
        case ChooseTableViewTypeCarCity: {
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A71000_C_CPSZD"];
            if (dataArray.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;}
        case ChooseTableViewTypeCarBSX: {
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A71000_C_BSX"];
            if (dataArray.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;}
            
        case ChooseTableViewTypeCarPL: {
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A71000_C_PL"];
            if (dataArray.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;}
        case ChooseTableViewTypeCarRYTYPE: {
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A71000_C_RYTYPE"];
            if (dataArray.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;}
        case ChooseTableViewTypeCustomerCarType:{
            
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41500_C_BUYTYPE"];
            if (dataArray.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;}
            
        case ChooseTableViewTypeCarPFBZ: {
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A71000_C_PFBZ"];
            if (dataArray.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;}
        case ChooseTableViewTypeCarZDSG: {
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A71000_C_ZDSG"];
            if (dataArray.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;}
        case ChooseTableViewTypeCarHSSG: {
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A71000_C_HSSG"];
            if (dataArray.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;}
            case ChooseTableViewTypeMODEFOLLOW: {
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41600_C_MODEFOLLOW"];
                if (dataArray.count <=0) {
                    [JRToast showWithText:@"暂无数据"];
                    return;
                }
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                if ([postStr isEqualToString:@"A41600_C_MODEFOLLOW_0004"] || [postStr isEqualToString:@"A41600_C_MODEFOLLOW_0009"]) {
                    if ([DBObjectTools isLocationServiceOpenWithSelfView:superVC.view]) {
                        if (self.chooseBlock) {
                            self.chooseBlock(title, postStr);
                        }
                    }
                } else {
                    if (self.chooseBlock) {
                        self.chooseBlock(title, postStr);
                    }
                }
                
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;}
        case ChooseTableViewTypeCarPSSG: {
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A71000_C_PSSG"];
            if (dataArray.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;}
        case ChooseTableViewTypeCustomerSource:{
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41300_C_CLUESOURCE"];
            if (dataArray.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            
            
            break;}
        case ChooseTableViewTypecCluesType:{
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41300_C_TYPE"];
            if (dataArray.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            
            
            break;}
            
            //ChooseTableViewTypeCustomerLabel
        case ChooseTableViewTypeCustomerLabel:{
            
            
            [HttpWebObject getNoteDataCompliation:^(id data) {
                MyLog(@"%@",data);
                if ([data[@"code"] integerValue]==200) {
                    NSMutableArray*mtArray=[NSMutableArray array];    //单单要的title
                    NSMutableArray*saveMarketArray=[NSMutableArray array];  //保存model
                    NSArray*array=data[@"content"];
                    if (array.count <=0) {
                        [JRToast showWithText:@"暂无数据"];
                        return;
                    }
                    for (NSDictionary*dict in array) {
                        MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
                        model.name=dict[@"C_NAME"];
                        model.c_id=dict[@"C_ID"];
                        
                        [saveMarketArray addObject:model];
                        [mtArray addObject:model.name];
                    }
                    DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                        MyLog(@"%@    %@",title,indexStr);
                        NSInteger number=[indexStr integerValue];
                        MJKFunnelChooseModel*model=saveMarketArray[number];
                        NSString*postStr=model.c_id;
                        if (self.chooseBlock) {
                            self.chooseBlock(title, postStr);
                        }
                        
                        
                    }];
                    [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
                    
                }else{
                    [JRToast showWithText:data[@"message"]];
                }
                
            }];
            break;}
        case ChooseTableViewTypeAction:{
            //            if (![self.vcName isEqualToString:@"流量仪"]) {
                            if (self.SourceID.length <= 0) {
                                [JRToast showWithText:@"请先选择来源"];
                                return;
                            }
            //            }
            
            
            [HttpWebObject HttpObjectGetMarketActionWithSourceID:self.SourceID Success:^(id data) {
                MyLog(@"%@",data);
                if ([data[@"code"] integerValue]==200) {
                    NSMutableArray*mtArray=[NSMutableArray array];    //单单要的title
                    NSMutableArray*saveMarketArray=[NSMutableArray array];  //保存model
                    NSArray*array=data[@"data"][@"list"];
                    if (array.count <=0) {
                        [JRToast showWithText:@"暂无数据"];
                        return;
                    }
                    for (NSDictionary*dict in array) {
                        MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
                        model.name=dict[@"C_NAME"];
                        model.c_id=dict[@"C_ID"];
                        
                        [saveMarketArray addObject:model];
                        [mtArray addObject:model.name];
                    }
                    if (mtArray.count <= 0) {
                        [JRToast showWithText:@"暂无渠道细分请先添加"];
                        return;
                    }
                    DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                        MyLog(@"%@    %@",title,indexStr);
                        NSInteger number=[indexStr integerValue];
                        MJKFunnelChooseModel*model=saveMarketArray[number];
                        NSString*postStr=model.c_id;
                        if (self.chooseBlock) {
                            self.chooseBlock(title, postStr);
                        }
                        
                        
                    }];
                    [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
                    
                }else{
                    [JRToast showWithText:data[@"msg"]];
                }
                
            }];
            break;}
            
        case ChooseTableViewTypeMimute:{
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41400_C_STAYTIME"];
            if (dataArray.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeMimute andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:nil andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            break;
        }
            //ChooseTableViewTypeCustomerStar
        case ChooseTableViewTypeCustomerStar:{
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41500_C_STAR"];
            if (dataArray.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeMimute andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            break;
        }
            
            
            
            
#pragma section 1
        case ChooseTableViewTypeCity:{
            //array 里面多个字典   每个字典是 name   和  cities
            NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"02cities" ofType:@"plist"]];
            if (array.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            NSMutableArray*mtArray=[array mutableCopy];
            
//            NSMutableArray *mtArray = [NSMutableArray array];
//            NSString *path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"json"];
//            // 将文件数据化
//            NSData *data = [[NSData alloc] initWithContentsOfFile:path];
//            // 对数据进行JSON格式化并返回字典形式
//            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//            NSDictionary *nameDic = dict[@"area0"];
//            NSDictionary *cityDic = dict[@"area1"];
//            [nameDic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
//
//                [cityDic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key1, NSArray *  _Nonnull obj1, BOOL * _Nonnull stop) {
//                    if ([key isEqualToString:key1]) {
//                        NSMutableDictionary *provincesDic = [NSMutableDictionary dictionary];
//                        provincesDic[@"name"] = obj;
//                        NSMutableArray *cityArr = [NSMutableArray array];
//                        for (NSArray *citiesArr in obj1) {
//                            [cityArr addObject:citiesArr[0]];
//                        }
//                        provincesDic[@"cities"] = cityArr;
//                        [mtArray addObject:provincesDic];
//                    }
//                }];
//            }];
//            NSLog(@"%@",mtArray);
//
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeAddress andmtArrayDatas:mtArray andSelectStr:nil andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                if (self.chooseBlock) {
                    self.chooseBlock(title, title);
                }


            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;}
            
            
            
            
        case ChooseTableViewTypeIndustry:{
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41500_C_INDUSTRY"];
            if (dataArray.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;}
            
            
        case ChooseTableViewTypeA80200_C_CARTYPE: {
            [self getDictDataListDatasCompliation:^(NSArray *typeArray) {
                if (typeArray.count <=0) {
                    [JRToast showWithText:@"暂无数据"];
                    return;
                }
                
                
                NSMutableArray*mtArray=[NSMutableArray array];
                NSMutableArray*postArray=[NSMutableArray array];
                for (MJKAdditionalInfoModel *model in typeArray) {
                    [mtArray addObject:model.dictLabel];
                    [postArray addObject:model.dictValue];
                }
                
                DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                    MyLog(@"%@    %@",title,indexStr);
                    NSInteger number=[indexStr integerValue];
                    NSString*postStr=postArray[number];
                    
                    if (self.chooseBlock) {
                        self.chooseBlock(title, postStr);
                    }
                    
                    
                }];
                [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
                
                
                
            }];
            
            
            break;}
        case ChooseTableViewTypeA475List: {
            [self getSetDictDataListDatasCompliation:^(NSArray *typeArray) {
                if (typeArray.count <=0) {
                    [JRToast showWithText:@"暂无数据"];
                    return;
                }
                
                
                NSMutableArray*mtArray=[NSMutableArray array];
                NSMutableArray*postArray=[NSMutableArray array];
                for (MJKCustomReturnSubModel *model in typeArray) {
                    [mtArray addObject:model.C_NAME];
                    [postArray addObject:model.C_ID];
                }
                
                DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                    MyLog(@"%@    %@",title,indexStr);
                    NSInteger number=[indexStr integerValue];
                    NSString*postStr=postArray[number];
                    
                    if (self.chooseBlock) {
                        self.chooseBlock(title, postStr);
                    }
                    
                    
                }];
                [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
                
                
                
            }];
            
            break;
            
        }
        case ChooseTableViewTypeJSSTATUS: {
            [self getDictDataListDatasCompliation:^(NSArray *typeArray) {
                if (typeArray.count <=0) {
                    [JRToast showWithText:@"暂无数据"];
                    return;
                }
                
                
                NSMutableArray*mtArray=[NSMutableArray array];
                NSMutableArray*postArray=[NSMutableArray array];
                for (MJKAdditionalInfoModel *model in typeArray) {
                    [mtArray addObject:model.dictLabel];
                    [postArray addObject:model.dictValue];
                }
                
                DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                    MyLog(@"%@    %@",title,indexStr);
                    NSInteger number=[indexStr integerValue];
                    NSString*postStr=postArray[number];
                    
                    if (self.chooseBlock) {
                        self.chooseBlock(title, postStr);
                    }
                    
                    
                }];
                [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
                
                
                
            }];
            
            
            break;}
        case ChooseTableViewTypeA802_C_TYPE:{
            [self getDictDataListDatasCompliation:^(NSArray *typeArray) {
                if (typeArray.count <=0) {
                    [JRToast showWithText:@"暂无数据"];
                    return;
                }
                
                
                NSMutableArray*mtArray=[NSMutableArray array];
                NSMutableArray*postArray=[NSMutableArray array];
                for (MJKAdditionalInfoModel *model in typeArray) {
                    [mtArray addObject:model.dictLabel];
                    [postArray addObject:model.dictValue];
                }
                
                DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                    MyLog(@"%@    %@",title,indexStr);
                    NSInteger number=[indexStr integerValue];
                    NSString*postStr=postArray[number];
                    
                    if (self.chooseBlock) {
                        self.chooseBlock(title, postStr);
                    }
                    
                    
                }];
                [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
                
                
                
            }];
            
            
            break;}
            
        case ChooseTableViewTypeA80200_C_CPTYPEHIGH: {
            [self getDictDataListDatasCompliation:^(NSArray *typeArray) {
                if (typeArray.count <=0) {
                    [JRToast showWithText:@"暂无数据"];
                    return;
                }
                
                
                NSMutableArray*mtArray=[NSMutableArray array];
                NSMutableArray*postArray=[NSMutableArray array];
                for (MJKAdditionalInfoModel *model in typeArray) {
                    [mtArray addObject:model.dictLabel];
                    [postArray addObject:model.dictValue];
                }
                
                DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                    MyLog(@"%@    %@",title,indexStr);
                    NSInteger number=[indexStr integerValue];
                    NSString*postStr=postArray[number];
                    
                    if (self.chooseBlock) {
                        self.chooseBlock(title, postStr);
                    }
                    
                    
                }];
                [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
                
                
                
            }];
            
            
            break;}
        case ChooseTableViewTypeA80200_C_DKNX: {
            [self getDictDataListDatasCompliation:^(NSArray *typeArray) {
                if (typeArray.count <=0) {
                    [JRToast showWithText:@"暂无数据"];
                    return;
                }
                
                
                NSMutableArray*mtArray=[NSMutableArray array];
                NSMutableArray*postArray=[NSMutableArray array];
                for (MJKAdditionalInfoModel *model in typeArray) {
                    [mtArray addObject:model.dictLabel];
                    [postArray addObject:model.dictValue];
                }
                
                DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                    MyLog(@"%@    %@",title,indexStr);
                    NSInteger number=[indexStr integerValue];
                    NSString*postStr=postArray[number];
                    
                    if (self.chooseBlock) {
                        self.chooseBlock(title, postStr);
                    }
                    
                    
                }];
                [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
                
                
                
            }];
            
            
            break;}
        case ChooseTableViewTypeXL: {
            [self getDictDataListDatasCompliation:^(NSArray *typeArray) {
                if (typeArray.count <=0) {
                    [JRToast showWithText:@"暂无数据"];
                    return;
                }
                
                
                NSMutableArray*mtArray=[NSMutableArray array];
                NSMutableArray*postArray=[NSMutableArray array];
                for (MJKAdditionalInfoModel *model in typeArray) {
                    [mtArray addObject:model.dictLabel];
                    [postArray addObject:model.dictValue];
                }
                
                DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                    MyLog(@"%@    %@",title,indexStr);
                    NSInteger number=[indexStr integerValue];
                    NSString*postStr=postArray[number];
                    
                    if (self.chooseBlock) {
                        self.chooseBlock(title, postStr);
                    }
                    
                    
                }];
                [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
                
                
                
            }];
            
            
            break;}
        case ChooseTableViewTypeSFZJ: {
            [self getDictDataListDatasCompliation:^(NSArray *typeArray) {
                if (typeArray.count <=0) {
                    [JRToast showWithText:@"暂无数据"];
                    return;
                }
                
                
                NSMutableArray*mtArray=[NSMutableArray array];
                NSMutableArray*postArray=[NSMutableArray array];
                for (MJKAdditionalInfoModel *model in typeArray) {
                    [mtArray addObject:model.dictLabel];
                    [postArray addObject:model.dictValue];
                }
                
                DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                    MyLog(@"%@    %@",title,indexStr);
                    NSInteger number=[indexStr integerValue];
                    NSString*postStr=postArray[number];
                    
                    if (self.chooseBlock) {
                        self.chooseBlock(title, postStr);
                    }
                    
                    
                }];
                [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
                
                
                
            }];
            
            
            break;}
        case ChooseTableViewTypeA80200_C_CPTYPE: {
            [self getDictDataListDatasCompliation:^(NSArray *typeArray) {
                if (typeArray.count <=0) {
                    [JRToast showWithText:@"暂无数据"];
                    return;
                }
                
                
                NSMutableArray*mtArray=[NSMutableArray array];
                NSMutableArray*postArray=[NSMutableArray array];
                for (MJKAdditionalInfoModel *model in typeArray) {
                    [mtArray addObject:model.dictLabel];
                    [postArray addObject:model.dictValue];
                }
                
                DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                    MyLog(@"%@    %@",title,indexStr);
                    NSInteger number=[indexStr integerValue];
                    NSString*postStr=postArray[number];
                    
                    if (self.chooseBlock) {
                        self.chooseBlock(title, postStr);
                    }
                    
                    
                }];
                [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
                
                
                
            }];
            
            
            break;}
        case ChooseTableViewTypeProvince: {
            [self getProvinceAndCityWithCompliation:^(NSArray *typeArray) {
                if (typeArray.count <=0) {
                    [JRToast showWithText:@"暂无数据"];
                    return;
                }
                
                
                NSMutableArray*mtArray=[NSMutableArray array];
                NSMutableArray*postArray=[NSMutableArray array];
                for (MJKAdditionalInfoModel *model in typeArray) {
                    [mtArray addObject:model.label];
                    [postArray addObject:model.value];
                }
                
                DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                    MyLog(@"%@    %@",title,indexStr);
                    NSInteger number=[indexStr integerValue];
                    NSString*postStr=postArray[number];

                    if (self.chooseBlock) {
                        self.chooseBlock(title, postStr);
                    }
                    
                }];
                [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
                
                
                
            }];
            
            
            break;}
        case ChooseTableViewTypeNewCity: {
            [self getProvinceAndCityWithCompliation:^(NSArray *typeArray) {
                if (typeArray.count <=0) {
                    [JRToast showWithText:@"暂无数据"];
                    return;
                }
                NSArray *cityArr = [NSArray array];
                for (MJKAdditionalInfoModel *model in typeArray) {
                    if ([self.provinceValue isEqualToString:model.value]) {
                        cityArr = model.children;
                    }
                }
                
                NSMutableArray*mtArray=[NSMutableArray array];
                NSMutableArray*postArray=[NSMutableArray array];
                for (MJKAdditionalInfoModel *model in cityArr) {
                    [mtArray addObject:model.label];
                    [postArray addObject:model.value];
                }
                
                DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                    MyLog(@"%@    %@",title,indexStr);
                    NSInteger number=[indexStr integerValue];
                    NSString*postStr=postArray[number];

                    if (self.chooseBlock) {
                        self.chooseBlock(title, postStr);
                    }
                    
                    
                }];
                [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
                
                
                
            }];
            
            
            break;}
        case ChooseTableViewTypeYearIn:{
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41500_C_SALARY"];
            if (dataArray.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;}
            
            
            
        case ChooseTableViewTypeTaskClockType:{
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A46400_C_TYPE"];
            if (dataArray.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;}
        case ChooseTableViewTypeEducation:{
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41500_C_EDUCATION"];
            if (dataArray.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;}
            
            
            
        case ChooseTableViewTypeMarriage:{
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41500_C_MARITALSTATUS"];
            if (dataArray.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;}
            
            
            
        case ChooseTableViewTypeBirthday:{
            //2017-04-10  格式  self.textStr
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeBirthday andmtArrayDatas:nil andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                if (self.chooseBlock) {
                    self.chooseBlock(title, title);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            break;}
            
            
            
        case ChooseTableViewTypeHobby:{
            
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41500_C_HOBBY"];
            if (dataArray.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;}
            
            
        case ChooseTableViewTypeAllTime:{
            //2017-04-10 HH:mm:ss  格式  self.textStr
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeDate andmtArrayDatas:nil andSelectStr:self.chooseTextField.text andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                if (self.chooseBlock) {
                    self.chooseBlock(title, title);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            break;}
            
            
            //顾客选择list
        case ChooseTableViewTypeChooseCustomer:{
            if ([self.vcName isEqualToString:@"任务"]) {
                if (![[NewUserSession instance].appcode containsObject:@"APP007_0013"] &&
                    ![[NewUserSession instance].appcode containsObject:@"APP007_0012"] &&
                    ![[NewUserSession instance].appcode containsObject:@"APP007_0011"]) {
                    [JRToast showWithText:@"暂无权限选择客户"];
                    return;
                }
            }
            MJKCustomerChooseViewController *customListVC = [[MJKCustomerChooseViewController alloc]init];
            customListVC.rootVC = [DBTools getSuperViewWithsubView:self];
            customListVC.chooseCustomerBlock = ^(CGCCustomModel *model) {
                MyLog(@"%@",model);
                NSString*showTitle=model.C_NAME;
                NSString*postStr=model.C_A41500_C_ID;
                
                NSString*phoneStr=model.C_PHONE;
                NSString*addressStr=model.C_ADDRESS;
                //名字
                NSString*newStr=[NSString stringWithFormat:@"%@,%@,%@",showTitle,phoneStr,addressStr];
                
                
                if (self.chooseBlock) {
                    self.chooseBlock(newStr, postStr);
                }
                
                if (self.backAddressBlock) {
                    self.backAddressBlock(model.C_ADDRESS);
                }
                
                
            };
            [[DBTools getSuperViewWithsubView:self].navigationController pushViewController:customListVC animated:YES];
            
            
            
            break;}
            
            
            
        case CHooseTableViewTypeTaskType:{
            
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A01200_C_TYPE"];
            if (dataArray.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;}
            
            
        case CHooseTableViewCarTypeTaskType:{
            [self getCarTypeDatasCompliation:^(NSArray *typeArray) {
                if (typeArray.count <=0) {
                    [JRToast showWithText:@"暂无数据"];
                    return;
                }
                NSMutableArray*mtArray=[NSMutableArray array];
                NSMutableArray*postArray=[NSMutableArray array];
                for (CustomerLvevelNextFollowModel*model in typeArray) {
                    [mtArray addObject:model.C_NAME];
                    [postArray addObject:model.C_ID];
                }
                DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                    MyLog(@"%@    %@",title,indexStr);
                    NSInteger number=[indexStr integerValue];
                    NSString*postStr=postArray[number];
                    
                    if (self.chooseBlock) {
                        self.chooseBlock(title, postStr);
                    }
                    
                    
                }];
                [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            }];
            
            break;}
            
            
        case CHooseTableViewTypeServicer:{
            [self getSalesListDatasCompliation:^(MJKClueListViewModel *saleDatasModel) {
                
                
                NSMutableArray*mtArray=[NSMutableArray array];
                NSMutableArray*postArray=[NSMutableArray array];
                for (MJKClueListSubModel*model in saleDatasModel.data) {
                    //                    [mtArray addObject:model.C_NAME];
                    //                    [postArray addObject:model.C_ID];
                    [mtArray addObject:model.nickName];
                    [postArray addObject:model.u051Id];
                }
                
                if (postArray.count <=0) {
                    [JRToast showWithText:@"暂无数据"];
                    return;
                }
                DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                    MyLog(@"%@    %@",title,indexStr);
                    NSInteger number=[indexStr integerValue];
                    NSString*postStr=postArray[number];
                    
                    if (self.chooseBlock) {
                        self.chooseBlock(title, postStr);
                    }
                    
                    
                }];
                [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
                
                
                
            }];
            
            
            break;}
        case ChooseTableViewTypeWWXYY:{
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A81500_C_WWXYY"];
            if (dataArray.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            
            break;}
        case ChooseTableViewTypeA81500_C_JJCD:{
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A81500_C_JJCD"];
            if (dataArray.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            
            break;}
        case ChooseTableViewTypeA81500_WXRYTYPE:{
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:self.C_TYPECODE];
            if (dataArray.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            
            break;}
        case ChooseTableViewTypeA800YJSHZH: {
            [self geta800DatasCompliation:^(NSArray *typeArray) {
                if (typeArray.count <=0) {
                    [JRToast showWithText:@"暂无数据"];
                    return;
                }
                
                
                NSMutableArray*mtArray=[NSMutableArray array];
                NSMutableArray*postArray=[NSMutableArray array];
                for (MJKAdditionalInfoModel *model in typeArray) {
                    [mtArray addObject:model.C_NAME];
                    [postArray addObject:model.C_ID];
                }
                
                DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                    MyLog(@"%@    %@",title,indexStr);
                    NSInteger number=[indexStr integerValue];
                    NSString*postStr=postArray[number];
                    
                    if (self.chooseBlock) {
                        self.chooseBlock(title, postStr);
                    }
                    
                    
                }];
                [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
                
                
                
            }];
            break;
        }
        case ChooseTableViewTypeA80000_C_TYPE:{
            [self geta800DatasCompliation:^(NSArray *typeArray) {
                if (typeArray.count <=0) {
                    [JRToast showWithText:@"暂无数据"];
                    return;
                }
                
                
                NSMutableArray*mtArray=[NSMutableArray array];
                NSMutableArray*postArray=[NSMutableArray array];
                for (MJKAdditionalInfoModel *model in typeArray) {
                    [mtArray addObject:model.C_NAME];
                    [postArray addObject:model.C_ID];
                }
                
                DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                    MyLog(@"%@    %@",title,indexStr);
                    NSInteger number=[indexStr integerValue];
                    NSString*postStr=postArray[number];
                    
                    if (self.chooseBlock) {
                        self.chooseBlock(title, postStr);
                    }
                    
                    
                }];
                [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
                
                
                
            }];
            
            
            break;}
        case ChooseTableViewTypeA81500_C_STATUS:{
            [self geta800DatasCompliation:^(NSArray *typeArray) {
                if (typeArray.count <=0) {
                    [JRToast showWithText:@"暂无数据"];
                    return;
                }
                
                
                NSMutableArray*mtArray=[NSMutableArray arrayWithObjects:@"处理中",@"不受理", nil];
                NSMutableArray*postArray=[NSMutableArray arrayWithObjects:@"A81500_C_STATUS_0001",@"A81500_C_STATUS_0002", nil];
                
                
                DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                    MyLog(@"%@    %@",title,indexStr);
                    NSInteger number=[indexStr integerValue];
                    NSString*postStr=postArray[number];
                    
                    if (self.chooseBlock) {
                        self.chooseBlock(title, postStr);
                    }
                    
                    
                }];
                [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
                
                
                
            }];
            
            
            break;}
            
        case CHooseTableViewTypeRobotTime:{
            
            
            NSArray*mtArray=[NSArray arrayWithObjects:@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"最近7天",@"今年",@"去年",@"最近30天",@"自定义", nil];
            NSArray*postArray=[NSArray arrayWithObjects:@"", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"9", @"10",@"30", @"999", nil];
            
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:[mtArray mutableCopy] andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            
            
            
            
            break;}
        case CHooseTableViewTypeRobotActiveTime:{
            
            
            NSArray*mtArray=[NSArray arrayWithObjects:@"全部",@"今天",@"本周",@"本月", nil];
            NSArray*postArray=[NSArray arrayWithObjects:@"", @"1", @"2", @"3", nil];
            
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:[mtArray mutableCopy] andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            
            
            
            
            break;}
            
            
        case CHooseTableViewTypeOrderType:{
            
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A01300_C_TYPE"];
            if (dataArray.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;}
            
        case CHooseTableViewTypeType:{
            
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A47700_C_TYPE"];
            if (dataArray.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;}
            
        case CHooseTableViewTypeApplyEnter:{
            
            
            
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A42300_C_TYPE"];
            if (dataArray.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;}
        case CHooseTableViewTypeArriveShopWay:{
            
            
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            [mtArray addObjectsFromArray:@[@"自然进店",@"预约到店",@"未到店",@"意向到店"]];
            [postArray addObjectsFromArray:@[@"C_CLUESOURCE_DD_0000",@"C_CLUESOURCE_DD_0002",@"WDD",@"YXDD"]];
            
            
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                self.chooseTextField.text=title;
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;}
            
        case CHooseTableViewTypeMumber: {
            
            
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            [mtArray addObjectsFromArray:@[@"50",@"100"]];
            [postArray addObjectsFromArray:@[@"0",@"1"]];
            
            
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                self.chooseTextField.text=title;
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;}
            //CHooseTableViewTypeArriveShop
        case CHooseTableViewTypeArriveShop:{
            
            
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            [mtArray addObjectsFromArray:@[@"到店",@"预约到店",@"到店"]];
            [postArray addObjectsFromArray:@[@"0",@"1",@"2"]];
            
            
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                self.chooseTextField.text=title;
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;}
            //CHooseTableViewTypeStatus
            
        case CHooseTableViewTypeCustomerStatus:{
            NSMutableArray *statusArr = [NSMutableArray array];
            NSMutableArray *statusCodeArr = [NSMutableArray array];
            for (MJKDataDicModel *model in[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41500_C_STATUS"] ) {
                [statusArr addObject:model.C_NAME];
                [statusCodeArr addObject:model.C_VOUCHERID];
            }
            
            if (statusCodeArr.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:statusArr andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=statusCodeArr[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;}
        case CHooseTableViewTypeListStatus:{
            NSMutableArray *statusArr = [NSMutableArray array];
            NSMutableArray *statusCodeArr = [NSMutableArray array];
            for (MJKDataDicModel *model in[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41300_C_STATUS"] ) {
                [statusArr addObject:model.C_NAME];
                [statusCodeArr addObject:model.C_VOUCHERID];
            }
            if (statusCodeArr.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:statusArr andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=statusCodeArr[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;}
        case ChooseTableViewTypeShopActivity:{
            NSMutableArray *statusArr = [NSMutableArray array];
            NSMutableArray *statusCodeArr = [NSMutableArray array];
            for (MJKDataDicModel *model in[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A49500_C_ISSTORE"] ) {
                [statusArr addObject:model.C_NAME];
                [statusCodeArr addObject:model.C_VOUCHERID];
            }
            if (statusCodeArr.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:statusArr andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=statusCodeArr[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;}
        case ChooseTableViewTypeActivityType:{
            NSMutableArray *statusArr = [NSMutableArray array];
            NSMutableArray *statusCodeArr = [NSMutableArray array];
            for (MJKDataDicModel *model in[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A49500_C_TYPE"] ) {
                [statusArr addObject:model.C_NAME];
                [statusCodeArr addObject:model.C_VOUCHERID];
            }
            if (statusCodeArr.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:statusArr andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=statusCodeArr[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;}
        case CHooseTableViewTypeFansStatus:{
            
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            [mtArray addObjectsFromArray:@[@"全部",@"绑定",@"未绑定"]];
            [postArray addObjectsFromArray:@[@"",@"A47700_C_STATUS_0000",@"A47700_C_STATUS_0001"]];
            
            
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                self.chooseTextField.text=title;
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;}
        case chooseTypeIsOutType: {
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:[@[@"是",@"否"]mutableCopy] andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=@[@"1", @"0"][number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            break;
        }
            
        case chooseTypeHouseCarSourceWay:{
            
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41300_C_CLUESOURCE"];
            if (dataArray.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;}
        case ChooseTableViewTypeProtect:{
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A71300_C_HB"];
            if (dataArray.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;
        }
        case ChooseTableViewTypeManufacturer:{
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A71300_C_CJ"];
            if (dataArray.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;
        }
        case ChooseTableViewTypeSeatCount:{
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A71300_C_ZWS"];
            if (dataArray.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;
        }
        case ChooseTableViewTypeCarStates:{
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A71300_C_STATUS"];
            if (dataArray.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;
        }
        case ChooseTableViewTypeCarInventoryType:{
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A71300_C_CKTYPE"];
            if (dataArray.count <=0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr);
                }
                
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;
        }
            //ChooseTableViewTypeCarSource
            case ChooseTableViewTypeCarSource:{
                NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A71000_C_CHANNEL"];
                if (dataArray.count <=0) {
                    [JRToast showWithText:@"暂无数据"];
                    return;
                }
                NSMutableArray*mtArray=[NSMutableArray array];
                NSMutableArray*postArray=[NSMutableArray array];
                for (MJKDataDicModel*model in dataArray) {
                    [mtArray addObject:model.C_NAME];
                    [postArray addObject:model.C_VOUCHERID];
                }
                
                DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                    MyLog(@"%@    %@",title,indexStr);
                    NSInteger number=[indexStr integerValue];
                    NSString*postStr=postArray[number];
                    
                    if (self.chooseBlock) {
                        self.chooseBlock(title, postStr);
                    }
                    
                    
                }];
                [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
                
                break;
            }
            //UserWebService-getAllStor
            case ChooseTableViewTypeCarAllStor:{
                [self getCarStorDatasCompliation:^(NSArray *typeArray) {
                    if (typeArray.count <=0) {
                        [JRToast showWithText:@"暂无数据"];
                        return;
                    }
                        NSMutableArray*mtArray=[NSMutableArray array];
                        NSMutableArray*postArray=[NSMutableArray array];
                        for (CustomerLvevelNextFollowModel*model in typeArray) {
                            [mtArray addObject:model.storeName];
                            [postArray addObject:model.storeCode];
                        }
                        DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                            MyLog(@"%@    %@",title,indexStr);
                            NSInteger number=[indexStr integerValue];
                            NSString*postStr=postArray[number];
                            
                        if (self.chooseBlock) {
                            self.chooseBlock(title, postStr);
                        }
                    }];

                    [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
                }];
                
                break;
            }
        case ChooseTableViewTypeDeploy:{
            if (self.SourceID.length <= 0) {
                [JRToast showWithText:@"请选择产品"];
                return;
            }
            [self getdeployDatasCompliation:^(NSArray *typeArray) {
                NSMutableArray*mtArray=[NSMutableArray array];
                NSMutableArray*postArray=[NSMutableArray array];
                for (MJKChooseEmployeesModel*model in typeArray) {
                    [mtArray addObject:model.C_NAME];
                    [postArray addObject:model.C_ID];
                }
                if (postArray.count <=0) {
                    [JRToast showWithText:@"暂无数据"];
                    return;
                }
                DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:self.textStr andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                    MyLog(@"%@    %@",title,indexStr);
                    NSInteger number=[indexStr integerValue];
                    NSString*postStr=postArray[number];
                    
                    if (self.chooseBlock) {
                        self.chooseBlock(title, postStr);
                    }
                }];
                
                [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            }];
            break;
        }
        case CustomerChooseTypeWithMainDataForA806: {
            if (self.C_TYPECODE.length <= 0) {
                [JRToast showWithText:@"请先选择精品类型"];
                return;
            }
            NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
            contentDic[@"C_TYPE_DD_ID"] = self.C_TYPECODE;
            contentDic[@"isTree"] = @"1";
            HttpManager *manager = [[HttpManager alloc]init];
            [manager getNewDataFromNetworkWithUrl:[NSString stringWithFormat:@"%@/api/masterdata/a800/list", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
                if ([data[@"code"] integerValue] == 200) {
                    NSArray *typeArray = [CustomerPCModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"list"]];
                    if (typeArray.count <= 0) {
                        [JRToast showWithText:@"暂无数据"];
                        return;
                    }
                    NSMutableArray *mtArray = [NSMutableArray array];
                    for (CustomerPCModel *model in typeArray) {
                        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                        dic[@"name"] = model.C_NAME;
                        NSMutableArray *childArr = [NSMutableArray array];
                        for (CustomerPCModel *subModel in model.child) {
                            [childArr addObject:subModel.C_NAME];
                        }
                        dic[@"cities"] = childArr;
                        [mtArray addObject:dic];
                        
                    }
//                    for (MJKAdditionalInfoModel *subModel in typeArray) {
//                        [titleArray addObject:subModel.C_NAME];
//                        [codeArr addObject:subModel.C_ID];
//                    }
                    DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeAddress andmtArrayDatas:mtArray andSelectStr:nil andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                        MyLog(@"%@    %@",title,indexStr);
                        NSArray *indexArr = [indexStr componentsSeparatedByString:@","];
                        CustomerPCModel *model = typeArray[[indexArr[0] integerValue]];
                        CustomerPCModel *subModel = model.child[[indexArr[1] integerValue]];
                        if (self.chooseBlock) {
                            self.chooseBlock(title, subModel.C_ID);
                        }


                    }];
                    [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
                } else {
                    [JRToast showWithText:data[@"msg"]];
                }
            }];
            
        }
            break;
            
        case chooseTypeHouseCarType:{
            //            CarBannerViewController*vc=[[CarBannerViewController alloc]init];
            //            [superVC.navigationController pushViewController:vc animated:YES];
            //            vc.SelectedCarTypeBlock = ^(NSString *carName, NSString *carID, NSString *carBannerName, NSString *carBannerID) {
            //                self.chooseTextField.text=carName;
            //                if (self.chooseBlock) {
            //                    self.chooseBlock([NSString stringWithFormat:@"%@,%@",carBannerName,carName], [NSString stringWithFormat:@"%@,%@",carBannerID,carID]);
            //                }
            //            };
            
            break;
        }
            
        case chooseTypeNil: {
            if (self.chooseBlock) {
                self.chooseBlock(nil , nil);
            }
        }
            
            
        default:
            break;
    }
    
}




#pragma mark  --Datas
//得到销售列表
-(void)getSalesListDatasCompliation:(void(^)(MJKClueListViewModel*saleDatasModel))salesDatasBlock{
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/user/list",HTTP_IP] parameters:@{@"C_LOCCODE" : [NewUserSession instance].user.C_LOCCODE} compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            MJKClueListViewModel*saleDatasModel = [MJKClueListViewModel yy_modelWithDictionary:data];
            salesDatasBlock(saleDatasModel);
            
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];
    
    
}

- (void)getCarTypeDatasCompliation:(void(^)(NSArray*typeArray))salesDatasBlock {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A70600WebService-getList"];
    [dict setObject:@{@"C_TYPE_DD_ID" : @"A70600_C_TYPE_0002",@"ISPAGE" : @"0"} forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            NSArray *typeArray = [CustomerLvevelNextFollowModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
            salesDatasBlock(typeArray);
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

- (void)getCarStorDatasCompliation:(void(^)(NSArray*typeArray))salesDatasBlock {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"UserWebService-getAllStor"];
    [dict setObject:@{} forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            NSArray *typeArray = [CustomerLvevelNextFollowModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
            salesDatasBlock(typeArray);
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}
//配置
- (void)getdeployDatasCompliation:(void(^)(NSArray*typeArray))deployDatasBlock {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A41900WebService-getAllList"];
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    if (self.SourceID.length > 0) {
        contentDic[@"C_A49600_C_ID"] = self.SourceID;
    }
    [dict setObject:contentDic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            NSArray *typeArray = [MJKChooseEmployeesModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
            deployDatasBlock(typeArray);
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

- (void)geta800DatasCompliation:(void(^)(NSArray*typeArray))deployDatasBlock {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    if (self.C_TYPECODE.length > 0) {
        contentDic[@"C_TYPE_DD_ID"] = self.C_TYPECODE;
    }
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:HTTP_SYSTEMA800List parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            NSArray *typeArray = [MJKAdditionalInfoModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"list"]];
            if (typeArray.count <= 0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            deployDatasBlock(typeArray);
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

- (void)getDictDataListDatasCompliation:(void(^)(NSArray*typeArray))deployDatasBlock {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    if (self.C_TYPECODE.length > 0) {
        contentDic[@"dictType"] = self.C_TYPECODE;
    }
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:HTTP_SYSTEMDICDATALIST parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            NSArray *typeArray = [MJKAdditionalInfoModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"list"]];
            deployDatasBlock(typeArray);
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}


- (void)getSetDictDataListDatasCompliation:(void(^)(NSArray*typeArray))deployDatasBlock {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    if (self.C_TYPECODE.length > 0) {
        contentDic[@"TYPE"] = self.C_TYPECODE;
    }
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:HTTP_A475List parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            NSArray *typeArray = [MJKCustomReturnSubModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"content"]];
            deployDatasBlock(typeArray);
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

- (void)getProvinceAndCityWithCompliation:(void(^)(NSArray*typeArray))deployDatasBlock {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    if (self.C_TYPECODE.length > 0) {
        contentDic[@"type"] = self.C_TYPECODE;
    }
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:HTTP_SYSTEMDTREELIST parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            NSArray *typeArray = [MJKAdditionalInfoModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            deployDatasBlock(typeArray);
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}



- (void)getShopWithBlock:(void(^)(NSArray*typeArray))deployDatasBlock {
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    HttpManager *manage = [[HttpManager alloc]init];
    [manage getNewDataFromNetworkWithUrl:[NSString stringWithFormat:@"%@/api/crm/a403/list", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
            NSArray *typeArray = [MJKA807MainModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            deployDatasBlock(typeArray);
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}





#pragma mark  --set
-(void)setTextStr:(NSString *)textStr{
    _textStr=textStr;
    self.chooseTextField.text=textStr;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"AddCustomerChooseTableViewCell";
    AddCustomerChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

@end
