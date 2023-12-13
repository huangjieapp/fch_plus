//
//  FunnelShowView.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/7/28.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "FunnelShowView.h"
#import "FunnelShowCell.h"
#import "CGCBrokerCenterVC.h"
#import "MJKFunnelMoreFieldTableViewCell.h"

#import "PotentailCustomerListViewController.h"
#import "MJKChooseEmployeesViewController.h"
#import "ServiceTaskViewController.h"
#import "MJKClueListSubModel.h"
#import "CGCOrderListVC.h"
#import "MJKNewProductChooseViewController.h"
#import "MJKProductShowModel.h"
#import "MJKAfterManageViewController.h"
#import "MJKRegisterManageViewController.h"
#import "ProvincesAndCityViewController.h"

#define CELL0    @"FunnelShowCell"

@interface FunnelShowView()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property(nonatomic,strong)UIView*mainView;
@property(nonatomic,strong)UITableView*tableView;
/** <#注释#>*/
@property (nonatomic, strong) NSString *jieshaorenStr;

@property (nonatomic, strong) NSString *jieshaorencode;
@property (nonatomic, strong) NSString *employeesStr;

@property (nonatomic, strong) NSString *employeesCode;
@property (nonatomic, strong) NSString *arriveTimes;
@property (nonatomic, strong) NSString *pcStr;

@property (nonatomic, strong) NSString *pcCode;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableDictionary *dic;

@end

@implementation FunnelShowView

+(instancetype)funnelShowView{
    
    FunnelShowView*view=[[FunnelShowView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    view.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.0];
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:view action:@selector(clickHiddenRightCover)];
    tap.cancelsTouchesInView=YES;
    tap.delegate=view;
    [view addGestureRecognizer:tap];
   
    
    UIView*mainView=[[UIView alloc]initWithFrame:CGRectMake(KScreenWidth, 0, KScreenWidth-100, KScreenHeight)];
    mainView.backgroundColor=[UIColor whiteColor];
    view.mainView=mainView;
    [view addSubview:mainView];
    
    
    [mainView addSubview:view.tableView];
    [view.tableView registerClass:[FunnelShowCell class] forCellReuseIdentifier:CELL0];
    
    //底部的按钮
    [view addBottomButton];
    
    
    view.hidden=YES;
    
    return view;
}


-(void)addBottomButton{
    UIView*bottomView= [[UIView alloc]initWithFrame:CGRectMake(0, self.mainView.bottom-50, self.mainView.width, 50)];
    bottomView.backgroundColor=[UIColor whiteColor];
    [self.mainView addSubview:bottomView];
    
    UIView*topLineView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, bottomView.width, 1)];
    topLineView.backgroundColor=[UIColor grayColor];
    [bottomView addSubview:topLineView];
    
    UIButton*resetButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 1, bottomView.width/2, 49)];
    [resetButton setBackgroundColor:[UIColor whiteColor]];
    [resetButton setTitle:@"重置" forState:UIControlStateNormal];
    [resetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [resetButton addTarget:self action:@selector(clickReset)];
    resetButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [bottomView addSubview:resetButton];
    
    
    UIButton*sureButton=[[UIButton alloc]initWithFrame:CGRectMake(bottomView.width/2, 1, bottomView.width/2, 49)];
    [sureButton setBackgroundColor:KNaviColor];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(clickSure)];
    sureButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [bottomView addSubview:sureButton];
    
    
    
}



-(void)show{
    self.hidden=NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.5];
        
        
        CGRect currentFrame=self.mainView.frame;
        currentFrame.origin.x=100;
        self.mainView.frame=currentFrame;
        
        
    } completion:^(BOOL finished) {
        
    }];
    
    
}

-(void)hidden{
    [UIView animateWithDuration:0.5 animations:^{
          self.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.0];
        
        CGRect currentFrame=self.mainView.frame;
        currentFrame.origin.x=KScreenWidth;
        self.mainView.frame=currentFrame;
        
        
    } completion:^(BOOL finished) {
        self.hidden=YES;
        
    }];

    
    
}



#pragma mark  --tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allDatas.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DBSelf(weakSelf);
    
//    FunnelShowCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
//    if (!cell) {
        FunnelShowCell*cell=[[FunnelShowCell alloc]init];
    __block FunnelShowCell*weakCell = cell;
    cell.rootVC = self.rootVC;
//    }
    NSDictionary*dict=self.allDatas[indexPath.row];
    if (!dict) {
        return cell;
    }
    NSString*title=dict[@"title"];
    NSArray*content=dict[@"content"];
    cell.titleStr=title;
    if ([title isEqualToString:@"到店"] || [title isEqualToString:@"搜索"] || [title isEqualToString:@"客户"] || [title isEqualToString:@"车架号"] || [title isEqualToString:@"车源编号"] || [title isEqualToString:@"客户姓名"] || [title isEqualToString:@"手机号"] || [title isEqualToString:@"车架号全号"] || [title isEqualToString:@"发动机号"] || [title isEqualToString:@"开票名称"]  || [title isEqualToString:@"审批状态"]) {
        MJKFunnelMoreFieldTableViewCell *cell = [MJKFunnelMoreFieldTableViewCell cellWithTableView:tableView];
        cell.titleLabel.text = title;
        if ([title isEqualToString:@"到店"]) {
            cell.rightTFLayout.constant = 80;
            cell.bottomTitle.hidden = NO;
        }
        if ([title isEqualToString:@"搜索"] || [title isEqualToString:@"客户"]) {
            cell.inputTextField.placeholder = @"搜索姓名、电话、地址、标识";
            cell.inputTextField.keyboardType = UIKeyboardTypeDefault;
        }
        if ([title isEqualToString:@"车架号"]) {
            cell.inputTextField.placeholder = @"搜索车架号";
            cell.inputTextField.keyboardType = UIKeyboardTypeDefault;
        }
        
        if ([title isEqualToString:@"车源编号"]) {
            cell.inputTextField.placeholder = @"搜索车源编号";
            cell.inputTextField.keyboardType = UIKeyboardTypeDefault;
        }
        if ([title isEqualToString:@"客户姓名"] || [title isEqualToString:@"手机号"] || [title isEqualToString:@"车架号全号"] || [title isEqualToString:@"发动机号"] || [title isEqualToString:@"开票名称"]  || [title isEqualToString:@"审批状态"]) {
            cell.inputTextField.placeholder = [NSString stringWithFormat:@"搜索%@", title];
            cell.inputTextField.keyboardType = UIKeyboardTypeDefault;
            
        }
        cell.textChangeBlock = ^(NSString * _Nonnull str) {
            if ([title isEqualToString:@"客户"] ) {
                weakSelf.jieshaorencode = @"customer";
            } else if ([title isEqualToString:@"车架号"]) {
                weakSelf.jieshaorencode = @"vin";
            } else if ([title isEqualToString:@"车源编号"]) {
                weakSelf.jieshaorencode = @"car";
            } else if ([title isEqualToString:@"手机号"]) {
                weakSelf.jieshaorencode = @"phone";
            } else if ([title isEqualToString:@"车架号全号"]) {
                weakSelf.jieshaorencode = @"vinall";
            } else if ([title isEqualToString:@"客户姓名"]) {
                weakSelf.jieshaorencode = @"name";
            } else if ([title isEqualToString:@"发动机号"]) {
                weakSelf.jieshaorencode = @"fdj";
            } else if ([title isEqualToString:@"开票名称"]) {
                weakSelf.jieshaorencode = @"kpmc";
            } else if ([title isEqualToString:@"审批状态"]) {
                weakSelf.jieshaorencode = @"spzt";
            }
            weakSelf.arriveTimes = str;
//            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return cell;
    }
    
    if ([title isEqualToString:@"品牌车型"]) {
        cell.allDataArray = @[];
        [cell.moreButton setTitleNormal:@"请选择>>"];
        if (self.jieshaorenStr.length > 0) {
            [cell.moreButton setTitleNormal:[NSString stringWithFormat:@"%@>>",self.jieshaorenStr]];
        }
        cell.gotoBlock = ^{
            [weakSelf hidden];
            MJKNewProductChooseViewController *vc = [[MJKNewProductChooseViewController alloc]init];
            //            if (self.yx_productArray.count > 0) {
            //                vc.productArray = [self.yx_productArray mutableCopy];
            //            }
            vc.chooseProductBlock = ^(MJKProductShowModel * _Nonnull productModel) {
                [weakSelf show];
                [weakCell.moreButton setTitleNormal:[NSString stringWithFormat:@"%@ %@>>",productModel.C_TYPE_DD_NAME,productModel.C_NAME]];
                if (weakSelf.chooseProductBlock) {
                    weakSelf.chooseProductBlock(productModel);
                }
//                
            };
            
            [self.rootVC.navigationController pushViewController:vc animated:YES];
        };
    } else if ([title isEqualToString:@"介绍人"]) {
        cell.allDataArray = @[];
        [cell.moreButton setTitleNormal:@"请选择>>"];
        if (self.jieshaorenStr.length > 0) {
            [cell.moreButton setTitleNormal:[NSString stringWithFormat:@"%@>>",self.jieshaorenStr]];
        } 
        cell.gotoBlock = ^{
            [weakSelf hidden];
            CGCBrokerCenterVC *vc = [[CGCBrokerCenterVC alloc]init];
            vc.type = BrokerCenterMembers;
            vc.typeName = @"名单经纪人";
            if ([NewUserSession instance].configData.IS_JSRSFKFXZ.boolValue == YES) {
                vc.SEARCH_TYPE = @"1";
            }
            vc.backSelectFansBlock = ^(CGCCustomModel *model) {
                [weakSelf show];
                [KUSERDEFAULT setObject:@"no" forKey:@"refresh"];
                weakSelf.jieshaorencode = model.C_ID;
                weakSelf.jieshaorenStr = model.C_NAME;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            [weakSelf.rootVC.navigationController pushViewController:vc animated:YES];
        };
    } else if ([title isEqualToString:@"省市"]) {
        cell.allDataArray = @[];
        [cell.moreButton setTitleNormal:@"请选择>>"];
        if (self.pcStr.length > 0) {
            [cell.moreButton setTitleNormal:[NSString stringWithFormat:@"%@>>",self.pcStr]];
        }
        cell.gotoBlock = ^{
            [weakSelf hidden];
            ProvincesAndCityViewController *vc = [ProvincesAndCityViewController new];
            vc.vcName = @"funnel";
            vc.backBlock = ^{
                [weakSelf show];
            };
            vc.chooseBlock = ^(NSArray * _Nonnull pAcArray) {
                weakSelf.pcStr = [pAcArray componentsJoinedByString:@","];
                weakSelf.pcCode = [pAcArray componentsJoinedByString:@","];
                [tableView reloadData];

                [weakSelf show];
            };
            [weakSelf.rootVC.navigationController pushViewController:vc animated:YES];
        };
    } else if ([title isEqualToString:@"创建人"] || [title isEqualToString:@"负责人"] || [title isEqualToString:@"协助人"] || [title isEqualToString:@"协助发起人"] || [title isEqualToString:@"业务"] || [title isEqualToString:@"设计师"] || [title isEqualToString:@"项目经理"] || [title isEqualToString:@"下单员"] || [title isEqualToString:@"送货人"] || [title isEqualToString:@"安装技师"] || [title isEqualToString:@"收货人"] || [title isEqualToString:@"验收人"] || [title isEqualToString:@"前负责人"] || [title isEqualToString:@"责任人"] || [title isEqualToString:@"上牌落户员"]) {
        cell.allDataArray = content;
        [cell.moreButton setTitleNormal:@"更多>>"];
        [self.dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:title]) {
                [cell.moreButton setTitleNormal:[NSString stringWithFormat:@"%@>>",obj[@"name"]]];
            }
        }];
//        if (self.employeesStr.length > 0) {
//            [cell.moreButton setTitle:[NSString stringWithFormat:@"%@>>",self.employeesStr]];
//        }
        cell.chooseNormalButtonBlock = ^{
//            weakSelf.employeesCode = @"";
//            weakSelf.employeesStr = @"";
            [weakSelf.dic removeObjectForKey:title];
        };
        __block FunnelShowCell *weakCell = cell;
        cell.gotoBlock = ^{
            [weakSelf hidden];
            MJKChooseEmployeesViewController *vc = [[MJKChooseEmployeesViewController alloc]init];
            vc.rootVC = weakSelf.rootVC;
            vc.isAllEmployees = @"是";
            vc.noticeStr = @"无提示";
            vc.chooseEmployeesBlock = ^(MJKClueListSubModel * _Nonnull model) {
                [weakSelf show];
                weakCell.buttonNoSelected = NO;
//                weakSelf.employeesCode = model.user_id;
//                weakSelf.employeesStr = model.user_name;
                if (([title isEqualToString:@"责任人"] && [self.rootVC isKindOfClass:[MJKAfterManageViewController class]]) || ([title isEqualToString:@"创建人"] && [self.rootVC isKindOfClass:[MJKAfterManageViewController class]]) || ([title isEqualToString:@"上牌落户员"] && [self.rootVC isKindOfClass:[MJKRegisterManageViewController class]])) {
                    
                    [weakSelf.dic setObject:@{@"name" : model.user_name, @"code" : model.u051Id} forKey:title];
                } else {
                    [weakSelf.dic setObject:@{@"name" : model.user_name, @"code" : model.user_id} forKey:title];
                }
                
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            [weakSelf.rootVC.navigationController pushViewController:vc animated:YES];
        };
        
    }
    
    else {
        cell.allDataArray=content;
    }
    
    
    //选择时间特有的
    cell.customTimeBlock = ^{
        if (self.viewCustomTimeBlock) {
//             [self hidden];
            self.viewCustomTimeBlock(indexPath.row);
        }
        
    };
    cell.indexTimeBlock  = ^{
        if (self.indexTimeBlock) {
            [self hidden];
            self.indexTimeBlock();
        }
        
    };
    cell.TimeBlock= ^{
        if (self.TimeBlock) {
            [self hidden];
            self.TimeBlock();
        }
        
    };
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary*dict=self.allDatas[indexPath.row];
    NSString*title=dict[@"title"];
    NSArray*content=dict[@"content"];
    if ([title isEqualToString:@"品牌车型"] || [title isEqualToString:@"介绍人"] || [title isEqualToString:@"省市"] || [title isEqualToString:@"到店"] || [title isEqualToString:@"搜索"] || [title isEqualToString:@"客户"]  || [title isEqualToString:@"车架号"] || [title isEqualToString:@"车源编号"] || [title isEqualToString:@"客户姓名"] || [title isEqualToString:@"手机号"] || [title isEqualToString:@"车架号全号"] || [title isEqualToString:@"发动机号"] || [title isEqualToString:@"开票名称"] || [title isEqualToString:@"审批状态"]) {
        return 44;
    }
     return  [FunnelShowCell cellHeightWithArray:content];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 50;
    }
    
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


#pragma mark  --delegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:self.mainView]) {
        return NO;
    }
    return YES;
}

#pragma mark -- touch
-(void)clickHiddenRightCover{
    MyLog(@"xx");
    
    [self hidden];
    
}


-(void)clickReset{

    int index = 0;
    for (NSDictionary*dict in self.allDatas) {
        NSString*title=dict[@"title"];
        NSArray*content=dict[@"content"];
        if ([title isEqualToString:@"到店"] || [title isEqualToString:@"搜索"] || [title isEqualToString:@"客户"]  || [title isEqualToString:@"车架号"]  || [title isEqualToString:@"车源编号"] || [title isEqualToString:@"客户姓名"] || [title isEqualToString:@"手机号"] || [title isEqualToString:@"车架号全号"] || [title isEqualToString:@"发动机号"] || [title isEqualToString:@"开票名称"] || [title isEqualToString:@"审批状态"]) {
            index += 1;
            if ([title isEqualToString:@"客户"]  || [title isEqualToString:@"车架号"]  || [title isEqualToString:@"车源编号"] || [title isEqualToString:@"客户姓名"] || [title isEqualToString:@"手机号"] || [title isEqualToString:@"车架号全号"] || [title isEqualToString:@"发动机号"] || [title isEqualToString:@"开票名称"]  || [title isEqualToString:@"审批状态"]) {
                self.jieshaorencode = @"";
            }
        } else {
            for (MJKFunnelChooseModel*model in content) {
                model.isSelected=NO;
                
            }
            
            if ([title isEqualToString:@"创建人"] || [title isEqualToString:@"负责人"] || [title isEqualToString:@"协助人"] || [title isEqualToString:@"协助发起人"] || [title isEqualToString:@"业务"] || [title isEqualToString:@"设计师"] || [title isEqualToString:@"项目经理"] || [title isEqualToString:@"下单员"] || [title isEqualToString:@"送货人"] || [title isEqualToString:@"安装技师"] || [title isEqualToString:@"收货人"] || [title isEqualToString:@"验收人"] || [title isEqualToString:@"前负责人"]) {
                [self.dic removeObjectForKey:title];
            }
            if ([title isEqualToString:@"介绍人"]) {
                self.jieshaorenStr = self.jieshaorencode = @"";
            }
            if ([title isEqualToString:@"省市"]) {
                self.pcStr = self.pcCode = @"";
            }
            
            FunnelShowCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            [cell.moreButton setTitleNormal:@"更多>>"];
            index += 1;
            
        }
        
        
    }
    
    
 
    
#warning ???  注掉？
    if (self.resetBlock) {
        self.resetBlock();
    }
    
    [self.tableView reloadData];
    
//       [self clickSure];
    [self hidden];
}

-(void)clickSure{
    NSMutableArray*saveChoose=[NSMutableArray array];
   
    for (int i=0; i<self.allDatas.count; i++) {
        NSDictionary*dict=self.allDatas[i];
        NSString *title = dict[@"title"];
        NSArray*content=dict[@"content"];
        if ([title isEqualToString:@"创建人"] || [title isEqualToString:@"负责人"] || [title isEqualToString:@"协助人"] || [title isEqualToString:@"协助发起人"] || [title isEqualToString:@"业务"] || [title isEqualToString:@"设计师"] || [title isEqualToString:@"项目经理"] || [title isEqualToString:@"下单员"] || [title isEqualToString:@"送货人"] || [title isEqualToString:@"安装技师"] || [title isEqualToString:@"收货人"] || [title isEqualToString:@"验收人"] || [title isEqualToString:@"前负责人"]) {
            NSArray *arr = self.dic.allKeys;
            if (self.dic == nil || arr.count <= 0) {
                for (MJKFunnelChooseModel*model in content) {
                    if (model.isSelected) {
                        //model 和   i   就很有用了。  还有  allDatas
                        NSString*index=[NSString stringWithFormat:@"%d",i];
                        NSDictionary*dict=@{@"model":model,@"index":index};
                        [saveChoose addObject:dict];
                        
                    }
                    
                    
                }
            } else {
            [self.dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([key isEqualToString:title]) {
                    for (MJKFunnelChooseModel*model in content) {
                        model.isSelected = NO;
                    }
                    MJKFunnelChooseModel*model = [[MJKFunnelChooseModel alloc]init];
                    model.name = obj[@"name"];
                    model.c_id = obj[@"code"];
                    NSString*index=[NSString stringWithFormat:@"%d",i];
                    NSDictionary*dict=@{@"model":model,@"index":index};
                    [saveChoose addObject:dict];
                } else {
                    for (MJKFunnelChooseModel*model in content) {
                        if (model.isSelected) {
                            //model 和   i   就很有用了。  还有  allDatas
                            NSString*index=[NSString stringWithFormat:@"%d",i];
                            NSDictionary*dict=@{@"model":model,@"index":index};
                            [saveChoose addObject:dict];
                            
                        }
                        
                        
                    }
                }
            }];
            }
            
        } else {
            for (MJKFunnelChooseModel*model in content) {
                if (model.isSelected) {
                    //model 和   i   就很有用了。  还有  allDatas
                    NSString*index=[NSString stringWithFormat:@"%d",i];
                    NSDictionary*dict=@{@"model":model,@"index":index};
                    [saveChoose addObject:dict];
                    
                }
                
                
            }
        }
        
        
    }
    
    
    if (self.jieshaorenAndLastTimeBlock) {
        self.jieshaorenAndLastTimeBlock(self.jieshaorencode, self.arriveTimes);
    }
    
    if (self.pcBlock) {
        self.pcBlock(self.pcStr, self.pcCode);
    }
    if (self.sureBlock) {
        self.sureBlock(saveChoose);
    }
    
    
    [self hidden];
    
}



#pragma mark  --set
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.mainView.width, self.mainView.height-50) style:UITableViewStyleGrouped];
        _tableView.backgroundColor=[UIColor whiteColor];
        _tableView.estimatedRowHeight=0;
        _tableView.estimatedSectionHeaderHeight=0;
        _tableView.estimatedSectionFooterHeight=0;
        _tableView.delegate=self;
        _tableView.dataSource=self;
        
    }
    return _tableView;
}


-(void)setAllDatas:(NSMutableArray *)allDatas{
    _allDatas=allDatas;

    [self.tableView reloadData];

    
}


#pragma mark  --funcation
//取消选中第几个section  第几个row
-(void)unselectedDetailRow:(NSIndexPath*)indexPath{
    NSInteger section=indexPath.section;
    NSInteger row=indexPath.row;
    NSDictionary*dict=self.allDatas[section];
    NSArray*array=dict[@"content"];
    for (int i=0; i<array.count; i++) {
         MJKFunnelChooseModel*model=array[i];
        if (i==row) {
            model.isSelected=NO;
        }
        
    }
    
    
    [self.tableView reloadData];

    
}

- (NSMutableDictionary *)dic {
    if (!_dic) {
        _dic = [NSMutableDictionary dictionary];
    }
    return _dic;
}


@end
