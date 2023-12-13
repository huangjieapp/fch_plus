//
//  MJKBatchToTaskTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/5/15.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKBatchToTaskTableViewCell.h"
#import "DBPickerView.h"

#import "MJKClueListViewModel.h"
#import "ServiceTaskDetailModel.h"

#import "MJKChooseEmployeesViewController.h"

@interface MJKBatchToTaskTableViewCell ()<UITextFieldDelegate>
@property(nonatomic,assign)ChooseBatchType Type;
@end

@implementation MJKBatchToTaskTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textFieldSale.delegate = self.textFieldType.delegate = self.textFieldStartTime.delegate = self.textFieldEndTime.delegate = self;
}

- (void)setModel:(ServiceTaskDetailModel *)model {
    _model = model;
    self.titleLabel.text = model.C_NAME;
    self.textFieldType.text = model.C_TYPE_DD_NAME;
    if (model.D_CONFIRMED_TIME.length > 0) {
        self.textFieldStartTime.text = [model.D_CONFIRMED_TIME substringToIndex:16];
    }
    if (model.D_ORDER_TIME.length > 0) {
        
        self.textFieldEndTime.text = [model.D_ORDER_TIME substringToIndex:16];
    }
    self.textFieldSale.text = model.USER_NAME;
}

- (IBAction)deleteButtonAction:(UIButton *)sender {
    if (self.deleteButtonActionBlock) {
        self.deleteButtonActionBlock();
    }
}

#pragma mark  --delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.textFieldType) {
        self.Type = ChooseTableViewTaskType;
    } else if (textField == self.textFieldSale) {
        self.Type = ChooseTableViewSale;
    } else {
        self.Type = ChooseTableTypeDateToMimute;
    }
    [self clickTextField:textField];
    
    return NO;
}

#pragma mark  --click
-(void)clickTextField:(UITextField *)tf{
    DBSelf(weakSelf);
    switch (self.Type) {
        case ChooseTableTypeDateToMimute:{
            //2017-04-10 HH:mm:ss  格式  self.textStr
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeDate andmtArrayDatas:nil andSelectStr:@"" andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                if (weakSelf.chooseBlock) {
                    weakSelf.chooseBlock(title, title, tf);
                }
                if (tf == weakSelf.textFieldStartTime) {
                    weakSelf.textFieldStartTime.text = title;
                } else if (tf == weakSelf.textFieldEndTime) {
                    weakSelf.textFieldEndTime.text = title;
                }
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            break;
            
        }
        case ChooseTableViewSale:{

                
                MJKChooseEmployeesViewController *vc = [[MJKChooseEmployeesViewController alloc]init];
            if ([[NewUserSession instance].appcode containsObject:@"APP007_0010"]) {
                vc.isAllEmployees = @"是";
            }
            vc.noticeStr = @"无提示";
                vc.chooseEmployeesBlock = ^(MJKClueListSubModel * _Nonnull model) {
                    if (weakSelf.chooseBlock) {
                        weakSelf.chooseBlock(model.user_name, model.user_id, tf);
                    }
                    if (tf == weakSelf.textFieldSale) {
                        weakSelf.textFieldSale.text =  model.user_name;
                    }
                };
                [weakSelf.rootVC.navigationController pushViewController:vc animated:YES];
                
            
            
            break;}
        case ChooseTableViewTaskType:{
            
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A01200_C_TYPE"];
            NSMutableArray*mtArray=[NSMutableArray array];
            NSMutableArray*postArray=[NSMutableArray array];
            for (MJKDataDicModel*model in dataArray) {
                [mtArray addObject:model.C_NAME];
                [postArray addObject:model.C_VOUCHERID];
            }
            
            DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:@"" andTitleStr:@"" andBlock:^(NSString *title, NSString *indexStr) {
                MyLog(@"%@    %@",title,indexStr);
                NSInteger number=[indexStr integerValue];
                NSString*postStr=postArray[number];
                
                if (self.chooseBlock) {
                    self.chooseBlock(title, postStr, tf);
                }
                if (tf == weakSelf.textFieldType) {
                    weakSelf.textFieldType.text = title;
                }
                
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            
            break;}
        default:
            break;
    }
    
}

#pragma mark  --Datas

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKBatchToTaskTableViewCell";
    MJKBatchToTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
    }
    return cell;
    
}

@end
