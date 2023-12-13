//
//  CustomerInputTableViewCell.m
//  match
//
//  Created by huangjie on 2022/7/31.
//

#import "CustomerChooseTableViewCell.h"

#import "CustomerLevelModel.h"
#import "CustomerSourceChannelModel.h"
#import "CustomerPCModel.h"
#import "MJKAdditionalInfoModel.h"
#import "ShopModel.h"

@implementation CustomerChooseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _titleLabel = [UILabel new];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(17);
            make.centerY.equalTo(self.contentView);
        }];
        _titleLabel.font = [UIFont systemFontOfSize:14.f];
        _titleLabel.textColor = [UIColor blackColor];
        
        _mustLabel = [UILabel new];
        [self.contentView addSubview:_mustLabel];
        [_mustLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right);
            make.top.equalTo(self.titleLabel);
        }];
        _mustLabel.text = @"*";
        _mustLabel.textColor = [UIColor redColor];
        _mustLabel.hidden = YES;
        
        
        
        _rightImageView = [UIImageView new];
        [self.contentView addSubview:_rightImageView];
        [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-8);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(8, 13));
        }];
        _rightImageView.image = [UIImage imageNamed:@"arrow_right2"];
        
        _chooseTextField = [UITextField new];
        [self.contentView addSubview:_chooseTextField];
        [_chooseTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right).offset(17);
            make.right.equalTo(self.rightImageView.mas_left).offset(-5);
            make.top.mas_equalTo(7);
            make.bottom.mas_equalTo(-7);
        }];
        _chooseTextField.placeholder = @"请选择";
        _chooseTextField.textColor = [UIColor darkGrayColor];
        _chooseTextField.font = [UIFont systemFontOfSize:14.f];
        _chooseTextField.textAlignment = NSTextAlignmentRight;
        _chooseTextField.inputView = [UIView new];
        
        _chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_chooseButton];
        [_chooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.chooseTextField);
        }];
        
        
        @weakify(self);
        [[_chooseButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            UIViewController *rootVC = [DBTools getSuperViewWithsubView:self];
            [rootVC.view endEditing:YES];
            [self.chooseTextField resignFirstResponder];
            switch (self.type) {
                case CustomerChooseTypeBirth:{
                    [BRDatePickerView showDatePickerWithMode:BRDatePickerModeDate title:self.titleStr selectValue:self.chooseStr resultBlock:^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
                        if (self.chooseBlock) {
                            self.chooseBlock(selectValue, selectValue);
                        }
                    }];
                }
                    
                    break;
                case CustomerChooseTypeLevel:{
                    HttpManager *manager = [[HttpManager alloc]init];
                    [manager getNewDataFromNetworkWithUrl:[NSString stringWithFormat:@"%@/api/masterdata/a411/list", HTTP_IP] parameters:@{} compliation:^(id data, NSError *error) {
                        if ([data[@"code"] integerValue] == 200) {
                            CustomerLevelModel *model = [CustomerLevelModel mj_objectWithKeyValues:data[@"data"]];
                            if (model.list.count <= 0) {
                                [JRToast showWithText:@"暂无数据"];
                                return;
                            }
                            NSMutableArray *titleArray = [NSMutableArray array];
                            NSMutableArray *codeArr = [NSMutableArray array];
                            for (CustomerLevelSubModel *subModel in model.list) {
                                [titleArray addObject:subModel.C_DAYNAME];
                                [codeArr addObject:subModel.C_VOUCHERID];
                            }
                            NSInteger index = [codeArr indexOfObject:self.chooseStr];
                            [BRStringPickerView showPickerWithTitle:self.titleStr dataSourceArr:titleArray selectIndex:index resultBlock:^(BRResultModel * _Nullable resultModel) {
                                if (self.chooseBlock) {
                                    self.chooseBlock(resultModel.value, codeArr[resultModel.index]);
                                }
                            }];
                        } else {
                            [JRToast showWithText:data[@"msg"]];
                        }
                    }];
                    
                }
                    
                    break;
                case CustomerChooseTypeSource: {
                    NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41300_C_CLUESOURCE"];
                    if (dataArray.count <= 0) {
                        [JRToast showWithText:@"暂无数据"];
                        return;
                    }
                    NSMutableArray*mtArray=[NSMutableArray array];
                    NSMutableArray*postArray=[NSMutableArray array];
                    for (MJKDataDicModel*model in dataArray) {
                        [mtArray addObject:model.C_NAME];
                        [postArray addObject:model.C_VOUCHERID];
                    }
                    NSInteger index = [postArray indexOfObject:self.chooseStr];
                    [BRStringPickerView showPickerWithTitle:self.titleStr dataSourceArr:mtArray selectIndex:index resultBlock:^(BRResultModel * _Nullable resultModel) {
                        if (self.chooseBlock) {
                            self.chooseBlock(resultModel.value, postArray[resultModel.index]);
                        }
                    }];
                }
                    break;
                case CustomerChooseTypeChannel: {
                    if (self.sourceStr.length <= 0) {
                        [JRToast showWithText:@"来源不能为空"];
                        return;
                    }
                    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
                    contentDic[@"C_TYPE_DD_ID"] = self.typeStr;
                    contentDic[@"C_CLUESOURCE_DD_ID"] = self.sourceStr;
                    HttpManager *manager = [[HttpManager alloc]init];
                    [manager getNewDataFromNetworkWithUrl:[NSString stringWithFormat:@"%@/api/masterdata/a412/list", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
                        if ([data[@"code"] integerValue] == 200) {
                            CustomerSourceChannelModel *model = [CustomerSourceChannelModel mj_objectWithKeyValues:data[@"data"]];
                            if (model.list.count <= 0) {
                                [JRToast showWithText:@"暂无数据"];
                                return;
                            }
                            NSMutableArray *titleArray = [NSMutableArray array];
                            NSMutableArray *codeArr = [NSMutableArray array];
                            for (CustomerSourceChannelSubModel *subModel in model.list) {
                                [titleArray addObject:subModel.C_NAME];
                                [codeArr addObject:subModel.C_ID];
                            }
                            NSInteger index = [codeArr indexOfObject:self.chooseStr];
                            [BRStringPickerView showPickerWithTitle:self.titleStr dataSourceArr:titleArray selectIndex:index resultBlock:^(BRResultModel * _Nullable resultModel) {
                                if (self.chooseBlock) {
                                    self.chooseBlock(resultModel.value, codeArr[resultModel.index]);
                                }
                            }];
                        } else {
                            [JRToast showWithText:data[@"msg"]];
                        }
                    }];
                    
                }
                    break;
                case CustomerChooseTypeGender: {
                    NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41500_C_SEX"];
                    if (dataArray.count <= 0) {
                        [JRToast showWithText:@"暂无数据"];
                        return;
                    }
                    NSMutableArray*mtArray=[NSMutableArray array];
                    NSMutableArray*postArray=[NSMutableArray array];
                    for (MJKDataDicModel*model in dataArray) {
                        [mtArray addObject:model.C_NAME];
                        [postArray addObject:model.C_VOUCHERID];
                    }
                    NSInteger index = [postArray indexOfObject:self.chooseStr];
                    [BRStringPickerView showPickerWithTitle:self.titleStr dataSourceArr:mtArray selectIndex:index resultBlock:^(BRResultModel * _Nullable resultModel) {
                        if (self.chooseBlock) {
                            self.chooseBlock(resultModel.value, postArray[resultModel.index]);
                        }
                    }];
                }
                    break;
                case CustomerChooseTypePC: {
                    NSMutableDictionary *contentDict = [NSMutableDictionary dictionary];
                    contentDict[@"type"] = @(2);
                    HttpManager *manager = [[HttpManager alloc]init];
                    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/masterdata/districts/getTreeList", HTTP_IP] parameters:contentDict compliation:^(id data, NSError *error) {
                        if ([data[@"code"] integerValue] == 200) {
                            NSArray *arr = [CustomerPCModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
                            if (arr.count <= 0) {
                                [JRToast showWithText:@"暂无数据"];
                                return;
                            }
                            NSMutableArray *totalArr = [NSMutableArray array];
                            for (int i = 0; i < arr.count; i++) {
                                CustomerPCModel *model = arr[i];
                                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                                dict[@"code"] = model.value;
                                dict[@"name"] = model.label;
                                NSMutableArray *cityArr = [NSMutableArray array];
                                for (int j = 0; j < model.children.count; j++) {
                                    CustomerPCSubModel *subModel = model.children[j];
                                    NSMutableDictionary *subDict = [NSMutableDictionary dictionary];
                                    subDict[@"code"] = subModel.value;
                                    subDict[@"name"] = subModel.label;
                                    [cityArr addObject:subDict];
                                }
                                dict[@"cityList"] = cityArr;
                                [totalArr addObject:dict];
                            }
                            
                            [BRAddressPickerView showAddressPickerWithMode:BRAddressPickerModeCity dataSource:totalArr selectIndexs:@[] isAutoSelect:NO resultBlock:^(BRProvinceModel * _Nullable province, BRCityModel * _Nullable city, BRAreaModel * _Nullable area) {
                                if (self.chooseBlock) {
                                    self.chooseBlock([NSString stringWithFormat:@"%@,%@", province.name, city.name], [NSString stringWithFormat:@"%@,%@", province.name, city.name]);
                                }
                            }];
                        } else {
                            [JRToast showWithText:data[@"msg"]];
                        }
                    }];
                    
                }
                    break;
                case FollowChooseTypeLevel:{
                    HttpManager *manager = [[HttpManager alloc]init];
                    [manager getNewDataFromNetworkWithUrl:[NSString stringWithFormat:@"%@/api/masterdata/a411/list", HTTP_IP] parameters:@{} compliation:^(id data, NSError *error) {
                        if ([data[@"code"] integerValue] == 200) {
                            CustomerLevelModel *model = [CustomerLevelModel mj_objectWithKeyValues:data[@"data"]];
                            if (model.list.count <= 0) {
                                [JRToast showWithText:@"暂无数据"];
                                return;
                            }
                            NSMutableArray *titleArray = [NSMutableArray array];
                            NSMutableArray *codeArr = [NSMutableArray array];
                            NSMutableArray *numberArr = [NSMutableArray array];
                            for (CustomerLevelSubModel *subModel in model.list) {
                                [titleArray addObject:subModel.C_DAYNAME];
                                [codeArr addObject:subModel.C_VOUCHERID];
                                [numberArr addObject:subModel.I_NUMBER];
                            }
                            NSInteger index = [codeArr indexOfObject:self.chooseStr];
                            [BRStringPickerView showPickerWithTitle:self.titleStr dataSourceArr:titleArray selectIndex:index resultBlock:^(BRResultModel * _Nullable resultModel) {
                                if (self.chooseNumberBlock) {
                                    self.chooseNumberBlock(resultModel.value, codeArr[resultModel.index], numberArr[resultModel.index]);
                                }
                            }];
                        } else {
                            [JRToast showWithText:data[@"msg"]];
                        }
                    }];
                
                }
                    
                    break;
                case CustomerChooseTypeTimeWithHMS:{
                    [BRDatePickerView showDatePickerWithMode:BRDatePickerModeYMDHMS title:self.titleStr selectValue:self.chooseStr resultBlock:^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
                        if (self.chooseBlock) {
                            self.chooseBlock(selectValue, selectValue);
                        }
                    }];
                }
                    
                    break;
                case CustomerChooseTypeTimeOnlyHM:{
                    [BRDatePickerView showDatePickerWithMode:BRDatePickerModeHM title:self.titleStr selectValue:self.chooseStr resultBlock:^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
                        if (self.chooseBlock) {
                            self.chooseBlock(selectValue, selectValue);
                        }
                    }];
                }
                    
                    break;
                case CustomerChooseTypeTimeWithHM:{
                    [BRDatePickerView showDatePickerWithMode:BRDatePickerModeYMDHM title:self.titleStr selectValue:self.chooseStr resultBlock:^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
                        if (self.chooseBlock) {
                            self.chooseBlock(selectValue, selectValue);
                        }
                    }];
                }
                    
                    break;
                case FollowChooseMode: {
                    NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41600_C_MODEFOLLOW"];
                    if (dataArray.count <= 0) {
                        [JRToast showWithText:@"暂无数据"];
                        return;
                    }
                    NSMutableArray*mtArray=[NSMutableArray array];
                    NSMutableArray*postArray=[NSMutableArray array];
                    for (MJKDataDicModel*model in dataArray) {
                        [mtArray addObject:model.C_NAME];
                        [postArray addObject:model.C_VOUCHERID];
                    }
                    NSInteger index = [postArray indexOfObject:self.chooseStr];
                    [BRStringPickerView showPickerWithTitle:self.titleStr dataSourceArr:mtArray selectIndex:index resultBlock:^(BRResultModel * _Nullable resultModel) {
                        if (self.chooseBlock) {
                            self.chooseBlock(resultModel.value, postArray[resultModel.index]);
                        }
                    }];
                }
                    break;
                case OrderChooseSales: {
                    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
                    contentDic[@"C_TYPE_DD_ID"] = self.typeStr;
                    HttpManager *manager = [[HttpManager alloc]init];
                    [manager getNewDataFromNetworkWithUrl:[NSString stringWithFormat:@"%@/api/masterdata/a412/list", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
                        if ([data[@"code"] integerValue] == 200) {
                            CustomerSourceChannelModel *model = [CustomerSourceChannelModel mj_objectWithKeyValues:data[@"data"]];
                            if (model.list.count <= 0) {
                                [JRToast showWithText:@"暂无数据"];
                                return;
                            }
                            NSMutableArray *titleArray = [NSMutableArray array];
                            NSMutableArray *codeArr = [NSMutableArray array];
                            for (CustomerSourceChannelSubModel *subModel in model.list) {
                                [titleArray addObject:subModel.C_NAME];
                                [codeArr addObject:subModel.C_ID];
                            }
                            NSInteger index = [codeArr indexOfObject:self.chooseStr];
                            [BRStringPickerView showPickerWithTitle:self.titleStr dataSourceArr:titleArray selectIndex:index resultBlock:^(BRResultModel * _Nullable resultModel) {
                                if (self.chooseBlock) {
                                    self.chooseBlock(resultModel.value, codeArr[resultModel.index]);
                                }
                            }];
                        } else {
                            [JRToast showWithText:data[@"msg"]];
                        }
                    }];
                    
                }
                    break;
                case CustomerChooseTypeNil: {
                    if (self.chooseBlock) {
                        self.chooseBlock(@"", @"");
                    }
                }
                    break;
                case CustomerChooseTypeStayTime: {
                    NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41400_C_STAYTIME"];
                    if (dataArray.count <= 0) {
                        [JRToast showWithText:@"暂无数据"];
                        return;
                    }
                    NSMutableArray*mtArray=[NSMutableArray array];
                    NSMutableArray*postArray=[NSMutableArray array];
                    for (MJKDataDicModel*model in dataArray) {
                        [mtArray addObject:model.C_NAME];
                        [postArray addObject:model.C_VOUCHERID];
                    }
                    NSInteger index = [postArray indexOfObject:self.chooseStr];
                    [BRStringPickerView showPickerWithTitle:self.titleStr dataSourceArr:mtArray selectIndex:index resultBlock:^(BRResultModel * _Nullable resultModel) {
                        if (self.chooseBlock) {
                            self.chooseBlock(resultModel.value, postArray[resultModel.index]);
                        }
                    }];
                }
                    break;
                case CustomerChooseTypeXS:   {
                    NSArray *mtArray = @[@"线索",@"来电"];
                    NSArray *postArray = @[@"A41300_C_TYPE_0000",@"A41300_C_TYPE_0001"];
                    
                    NSInteger index = [postArray indexOfObject:self.chooseStr];
                    [BRStringPickerView showPickerWithTitle:self.titleStr dataSourceArr:mtArray selectIndex:index resultBlock:^(BRResultModel * _Nullable resultModel) {
                        if (self.chooseBlock) {
                            self.chooseBlock(resultModel.value, postArray[resultModel.index]);
                        }
                    }];
                }
                    break;
                case CustomerChooseTypeSF:   {
                    NSArray *mtArray = @[@"是",@"否"];
                    NSArray *postArray = @[@"1",@"0"];
                    
                    NSInteger index = [postArray indexOfObject:self.chooseStr];
                    [BRStringPickerView showPickerWithTitle:self.titleStr dataSourceArr:mtArray selectIndex:index resultBlock:^(BRResultModel * _Nullable resultModel) {
                        if (self.chooseBlock) {
                            self.chooseBlock(resultModel.value, postArray[resultModel.index]);
                        }
                    }];
                }
                    break;
                case CustomerChooseTypeYW:   {
                    NSArray *mtArray = @[@"有",@"无"];
                    NSArray *postArray = @[@"1",@"0"];
                    
                    NSInteger index = [postArray indexOfObject:self.chooseStr];
                    [BRStringPickerView showPickerWithTitle:self.titleStr dataSourceArr:mtArray selectIndex:index resultBlock:^(BRResultModel * _Nullable resultModel) {
                        if (self.chooseBlock) {
                            self.chooseBlock(resultModel.value, postArray[resultModel.index]);
                        }
                    }];
                }
                    break;
                case CustomerChooseTypeDG:   {
                    NSArray *mtArray = @[@"单位",@"个人"];
                    NSArray *postArray = @[@"1",@"2"];
                    
                    NSInteger index = [postArray indexOfObject:self.chooseStr];
                    [BRStringPickerView showPickerWithTitle:self.titleStr dataSourceArr:mtArray selectIndex:index resultBlock:^(BRResultModel * _Nullable resultModel) {
                        if (self.chooseBlock) {
                            self.chooseBlock(resultModel.value, postArray[resultModel.index]);
                        }
                    }];
                }
                    break;
                case CustomerChooseTypeNW:   {
                    NSArray *mtArray = @[@"内部账号",@"外部账号"];
                    NSArray *postArray = @[@"1",@"2"];
                    
                    NSInteger index = [postArray indexOfObject:self.chooseStr];
                    [BRStringPickerView showPickerWithTitle:self.titleStr dataSourceArr:mtArray selectIndex:index resultBlock:^(BRResultModel * _Nullable resultModel) {
                        if (self.chooseBlock) {
                            self.chooseBlock(resultModel.value, postArray[resultModel.index]);
                        }
                    }];
                }
                    break;
                case CustomerChooseTypeWithTYPECODE: {
                   NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:self.typeStr];
                    if (dataArray.count <= 0) {
                        [JRToast showWithText:@"暂无数据"];
                        return;
                    }
                   NSMutableArray*mtArray=[NSMutableArray array];
                   NSMutableArray*postArray=[NSMutableArray array];
                   for (MJKDataDicModel*model in dataArray) {
                       if ([self.typeStr isEqualToString:@"A801_C_FP_TYPE"]) {
                           if ([self.sourceStr isEqualToString:@"A42000_C_PURCHASEWAY_0001"]) {//个人购车
                               if ([model.C_VOUCHERID isEqualToString:@"A801_C_FP_TYPE_0000"]) { //个人发票
                                   [mtArray addObject:model.C_NAME];
                                   [postArray addObject:model.C_VOUCHERID];
                               }
                           } else {
                               if (![model.C_VOUCHERID isEqualToString:@"A801_C_FP_TYPE_0000"]) { //不为个人发票
                                   [mtArray addObject:model.C_NAME];
                                   [postArray addObject:model.C_VOUCHERID];
                               }
                           }
                       } else {
                           [mtArray addObject:model.C_NAME];
                           [postArray addObject:model.C_VOUCHERID];
                       }
                   }
                   NSInteger index = [postArray indexOfObject:self.chooseStr];
                   [BRStringPickerView showPickerWithTitle:self.titleStr dataSourceArr:mtArray selectIndex:index resultBlock:^(BRResultModel * _Nullable resultModel) {
                       if (self.chooseBlock) {
                           self.chooseBlock(resultModel.value, postArray[resultModel.index]);
                       }
                   }];
               }
                   break;
                case CustomerChooseTypeWithMainData: {
                    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
                    contentDic[@"C_TYPE_DD_ID"] = self.typeStr;
                    HttpManager *manager = [[HttpManager alloc]init];
                    [manager getNewDataFromNetworkWithUrl:[NSString stringWithFormat:@"%@/api/masterdata/a800/list", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
                        if ([data[@"code"] integerValue] == 200) {
                            NSArray *typeArray = [MJKAdditionalInfoModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"list"]];
                            if (typeArray.count <= 0) {
                                [JRToast showWithText:[NSString stringWithFormat:@"暂无%@数据", self.titleStr]];
                                return;
                            }
                            NSMutableArray *titleArray = [NSMutableArray array];
                            NSMutableArray *codeArr = [NSMutableArray array];
                            for (MJKAdditionalInfoModel *subModel in typeArray) {
                                [titleArray addObject:subModel.C_NAME];
                                [codeArr addObject:subModel.C_ID];
                            }
                            NSInteger index = [codeArr indexOfObject:self.chooseStr];
                            [BRStringPickerView showPickerWithTitle:self.titleStr dataSourceArr:titleArray selectIndex:index resultBlock:^(BRResultModel * _Nullable resultModel) {
                                if (self.chooseBlock) {
                                    self.chooseBlock(resultModel.value, codeArr[resultModel.index]);
                                }
                            }];
                        } else {
                            [JRToast showWithText:data[@"msg"]];
                        }
                    }];
                    
                }
                    break;
                case CarSourceTableViewTypeShopL: {
                    HttpManager *manager = [[HttpManager alloc]init];
                    [manager getNewDataFromNetworkWithUrl:[NSString stringWithFormat:@"%@/api/crm/a403/list", HTTP_IP] parameters:@{} compliation:^(id data, NSError *error) {
                        if ([data[@"code"] integerValue] == 200) {
                            NSArray *arr= [ShopModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
                            if (arr.count <= 0) {
                                [JRToast showWithText:[NSString stringWithFormat:@"暂无%@数据", self.titleStr]];
                                return;
                            }
                            NSMutableArray *titleArray = [NSMutableArray array];
                            NSMutableArray *codeArr = [NSMutableArray array];
                            for (ShopModel *subModel in arr) {
                                [titleArray addObject:subModel.C_NAME];
                                [codeArr addObject:subModel.C_LOCCODE];
                            }
                            NSInteger index = [codeArr indexOfObject:self.chooseStr];
                            [BRStringPickerView showPickerWithTitle:self.titleStr dataSourceArr:titleArray selectIndex:index resultBlock:^(BRResultModel * _Nullable resultModel) {
                                if (self.chooseBlock) {
                                    self.chooseBlock(resultModel.value, codeArr[resultModel.index]);
                                }
                            }];
                        } else {
                            [JRToast showWithText:data[@"msg"]];
                        }
                    }];
                   
                }
                    break;
                default:
                    break;
            }
        }];
        
        
    }
    return self;
}

- (void)dealloc {
    MyLog(@"销毁cell----%s", __func__);
}

@end
