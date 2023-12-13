//
//  AddHelperViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/1/4.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "AddHelperViewController.h"
#import "MJKClueListViewModel.h"
#import "MJKMessagePushNotiViewController.h"

#import "MJKTabView.h"

#import "MJKChooseEmployeesModel.h"


#import "HelperTableViewCell.h"
#import "MJKChooseEmployeesTableViewCell.h"
#import "ShowHelpViewController.h"

@interface AddHelperViewController ()<UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MJKClueListViewModel*saleDatasModel;
@property (nonatomic, assign) BOOL isDesign;

/** is tab*/
@property (nonatomic, strong) NSString *tabStr;

/** <#备注#>*/
@property (nonatomic, strong) NSString *searchStr;
/** <#注释#>*/
@property (nonatomic, strong) NSArray *storeArray;
@end

@implementation AddHelperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self.vcName isEqualToString:@"设计师"] ? @"选择设计师" : @"选择协助人";
	self.view.backgroundColor = [UIColor whiteColor];
	[self initUI];
}

- (void)createNavi {
    DBSelf(weakSelf);
    MJKTabView *tabView = [[MJKTabView alloc]initWithFrame:CGRectMake(0, 7, 2 * 70, 30) andNameItems:@[@"本店", @"公司"]  withDefaultIndex:0  andIsSaveItem:NO andClickButtonBlock:^(NSString * _Nonnull str) {
        if ([str isEqualToString:@"本店"]) {
            weakSelf.tabStr = str;
            [weakSelf.tableView.mj_header beginRefreshing];
        } else if ([str isEqualToString:@"公司"]) {
            weakSelf.tabStr = str;
            [weakSelf.tableView.mj_header beginRefreshing];
        }
    }];
    
    if ([self.isAllHepler isEqualToString:@"是"]) {
        self.navigationItem.titleView = tabView;
    } else {
        self.title = [self.vcName isEqualToString:@"设计师"] ? @"选择设计师" : @"选择协助人";
    }
}

- (void)initUI {
	[self initSearchView];
	[self.view addSubview:self.tableView];
    self.tabStr= @"本店";
    [self createNavi];
    [self configRefresh];
}

- (void)configRefresh {
    DBSelf(weakSelf);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if ([weakSelf.tabStr isEqualToString:@"本店"]) {
            [weakSelf getSalesListDatas];
        } else {
            [weakSelf getAllShopEmployesesWithName];
        }
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)initSearchView {
	UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, 40)];
	bgView.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:bgView];
	bgView.tag = 100;
	UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(40, 5, KScreenWidth - 80, bgView.frame.size.height - 10)];
	[bgView addSubview:searchBar];
	searchBar.placeholder = @"搜索姓名";
	searchBar.delegate = self;
	UIImage* searchBarBg = [self GetImageWithColor:[UIColor clearColor] andHeight:32.0f];
	//设置背景图片
	[searchBar setBackgroundImage:searchBarBg];
	//设置背景色
	[searchBar setBackgroundColor:[UIColor clearColor]];
	//设置文本框背景
	[searchBar setSearchFieldBackgroundImage:searchBarBg forState:UIControlStateNormal];
	searchBar.layer.borderColor = [UIColor lightGrayColor].CGColor;
	searchBar.layer.borderWidth = 1.0f;
	searchBar.layer.cornerRadius = searchBar.frame.size.height / 2;
}

//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//	self.searchStr = searchBar.text;
//	[self getSalesListDatas];
//}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	self.searchStr = searchBar.text;
//    [self getSalesListDatas];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark 修改SearchBar背景色
/**
 *  生成图片
 *
 *  @param color  图片颜色
 *  @param height 图片高度
 *
 *  @return 生成的图片
 */
- (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height
{
	CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
	UIGraphicsBeginImageContext(r.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetFillColorWithColor(context, [color CGColor]);
	CGContextFillRect(context, r);
	
	UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return img;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.tabStr isEqualToString:@"本店"]) {
        return self.saleDatasModel.data.count;
    } else {
        return self.storeArray.count;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    if ([self.tabStr isEqualToString:@"本店"]) {
        MJKClueListSubModel *subModel = self.saleDatasModel.data[indexPath.row];
        HelperTableViewCell *cell = [HelperTableViewCell cellWithTableView:tableView];
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:subModel.avatar]];
        cell.nameLabel.text = subModel.nickName;
        return cell;
    } else {
        MJKChooseEmployeesModel *model = self.storeArray[indexPath.row];
        MJKChooseEmployeesTableViewCell *cell = [MJKChooseEmployeesTableViewCell cellWithTableView:tableView];
        if ([self.tabStr isEqualToString:@"公司"]) {
            if (self.searchStr.length > 0) {
                model.selected = YES;
            }
        }
        cell.model = model;
        cell.chooseEmployeesBlock = ^(MJKClueListSubModel * _Nonnull subModel) {
//            MJKClueListSubModel *subModel = self.saleDatasModel.content[indexPath.row];
            NSString *messageStr;
            if ([self.vcName isEqualToString:@"设计师"]) {
                messageStr = [NSString stringWithFormat:@"是否需要设计师%@协助",subModel.user_name];
            } else {
                if ([subModel.isDesign isEqualToString:@"true"]) {
                    if (weakSelf.C_DESIGNER_ROLEID.length > 0) {
                        if ([weakSelf.helpName isEqualToString:@"客户"]) {
                            if ([weakSelf.C_DESIGNER_ROLEID isEqualToString:subModel.user_id]) {
                                [JRToast showWithText:[NSString stringWithFormat:@"%@已是此客户设计师",subModel.user_name]];
                                return;
                            } else {
                                messageStr = [NSString stringWithFormat:@"此客户已有设计师，是否更换为%@设计师?",subModel.user_name];
                                
                            }
                            
                        } else if ([weakSelf.helpName isEqualToString:@"订单"]) {
                            if ([weakSelf.C_DESIGNER_ROLEID isEqualToString:subModel.user_id])  {
                                [JRToast showWithText:[NSString stringWithFormat:@"%@已是此订单设计师",subModel.user_name]];
                                return;
                            } else {
                                messageStr = [NSString stringWithFormat:@"此订单已有设计师，是否更换为%@设计师?",subModel.user_name];
                                
                            }
                        }
                    } else {
                        messageStr = [NSString stringWithFormat:@"是否将%@同时设置为设计师?",subModel.user_name];
                    }
                } else {
                    messageStr = [NSString stringWithFormat:@"是否需要%@协助",subModel.user_name];
                }
                
                
            }
            //    NSString *message = [NSString stringWithFormat:@"该客户是否需要%@协助",subModel.user_name];
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:messageStr preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if ([weakSelf.vcName isEqualToString:@"设计师"]) {
                    if (weakSelf.userBlock) {
                        weakSelf.userBlock(subModel.user_name, subModel.user_id);
                    }
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                } else {
                    if ([subModel.isDesign isEqualToString:@"true"]) {
                        weakSelf.isDesign = YES;
                        if (self.C_DESIGNER_ROLEID.length > 0) {
                            
                            [weakSelf HTTPAddHelper:subModel.user_id];
                        } else {
                            [weakSelf HTTPAddHelper:subModel.user_id];
                        }
                    } else {
                        [weakSelf HTTPAddHelper:subModel.user_id];
                    }
                    
                }
                
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                //        if (self.C_DESIGNER_ROLEID.length <= 0) {
                if (![weakSelf.editStr isEqualToString:@"编辑"]) {
                    if ([subModel.isDesign isEqualToString:@"true"]) {
                        weakSelf.isDesign = NO;
                        [weakSelf HTTPAddHelper:subModel.user_id];
                    }
                }
                
                
                //        }
            }];
            
            [alertVC addAction:cancelAction];
            [alertVC addAction:sureAction];
            
            [weakSelf presentViewController:alertVC animated:YES completion:nil];
        };
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tabStr isEqualToString:@"本店"]) {
        return 44;
    } else {
        MJKChooseEmployeesModel *model = self.storeArray[indexPath.row];
        return [MJKChooseEmployeesTableViewCell cellForHeight:model];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return .1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	DBSelf(weakSelf);
    if ([self.tabStr isEqualToString:@"本店"]) {
        MJKClueListSubModel *subModel = self.saleDatasModel.data[indexPath.row];
        NSString *messageStr;
        if ([self.vcName isEqualToString:@"设计师"]) {
            messageStr = [NSString stringWithFormat:@"是否需要设计师%@协助",subModel.nickName];
        } else {
            if ([subModel.isDesign isEqualToString:@"true"]) {
                if (self.C_DESIGNER_ROLEID.length > 0) {
                    if ([self.helpName isEqualToString:@"客户"]) {
                        if ([self.C_DESIGNER_ROLEID isEqualToString:subModel.u051Id]) {
                            [JRToast showWithText:[NSString stringWithFormat:@"%@已是此客户设计师",subModel.nickName]];
                            return;
                        } else {
                            messageStr = [NSString stringWithFormat:@"此客户已有设计师，是否更换为%@设计师?",subModel.nickName];
                            
                        }
                        
                    } else if ([self.helpName isEqualToString:@"订单"]) {
                        if ([self.C_DESIGNER_ROLEID isEqualToString:subModel.u051Id])  {
                            [JRToast showWithText:[NSString stringWithFormat:@"%@已是此订单设计师",subModel.nickName]];
                            return;
                        } else {
                            messageStr = [NSString stringWithFormat:@"此订单已有设计师，是否更换为%@设计师?",subModel.nickName];
                            
                        }
                    }
                } else {
                    messageStr = [NSString stringWithFormat:@"是否将%@同时设置为设计师?",subModel.nickName];
                }
            } else {
                messageStr = [NSString stringWithFormat:@"是否需要%@协助",subModel.nickName];
            }
            
            
        }
        //    NSString *message = [NSString stringWithFormat:@"该客户是否需要%@协助",subModel.user_name];
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:messageStr preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([weakSelf.vcName isEqualToString:@"设计师"]) {
                if (weakSelf.userBlock) {
                    weakSelf.userBlock(subModel.user_name, subModel.user_id);
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } else {
                if ([subModel.isDesign isEqualToString:@"true"]) {
                    weakSelf.isDesign = YES;
                    if (self.C_DESIGNER_ROLEID.length > 0) {
                        
                        [weakSelf HTTPAddHelper:subModel.user_id];
                    } else {
                        [weakSelf HTTPAddHelper:subModel.user_id];
                    }
                } else {
                    [weakSelf HTTPAddHelper:subModel.user_id];
                }
                
            }
            
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //        if (self.C_DESIGNER_ROLEID.length <= 0) {
            if (![self.editStr isEqualToString:@"编辑"]) {
                if ([subModel.isDesign isEqualToString:@"true"]) {
                    weakSelf.isDesign = NO;
                    [weakSelf HTTPAddHelper:subModel.user_id];
                }
            }
            
            
            //        }
        }];
        
        [alertVC addAction:cancelAction];
        [alertVC addAction:sureAction];
        
        [self presentViewController:alertVC animated:YES completion:nil];
    } else {
        MJKChooseEmployeesModel *model = self.storeArray[indexPath.row];
        model.selected = !model.isSelected;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
	
	
	
}

#pragma mark - HTTP Request
//得到销售列表
-(void)getSalesListDatas{
    NSMutableDictionary *contentDict = [NSMutableDictionary dictionary];
    contentDict[@"C_LOCCODE"] = [NewUserSession instance].user.C_LOCCODE;
    if (self.searchStr.length > 0) {
        contentDict[@"nickName"] = self.searchStr;
    }
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/user/list", HTTP_IP] parameters:contentDict compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.saleDatasModel = [MJKClueListViewModel yy_modelWithDictionary:data];
			[weakSelf.tableView reloadData];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
        [weakSelf.tableView.mj_header endRefreshing];
	}];
	
	
}

- (void)getAllShopEmployesesWithName {
    HttpManager*manager=[[HttpManager alloc]init];
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    if (self.searchStr.length > 0) {
        contentDic[@"C_NAME"] = self.searchStr;
    }
    contentDic[@"isAll"] = @"1";
    HttpManager *manage = [[HttpManager alloc]init];
    [manage getNewDataFromNetworkWithUrl:HTTP_SYSTEMUserStoreList parameters:contentDic compliation:^(id data, NSError *error) {
    
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            NSArray *arr = data[@"data"];
            if (arr.count <= 0) {
                //                [JRToast showWithText:@"无下级"];
            }
            weakSelf.storeArray = [MJKChooseEmployeesModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            [weakSelf.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    
}

- (void)HTTPAddHelper:(NSString *)user_id {
	DBSelf(weakSelf);
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A47200WebService-insert"];
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	dic[@"C_A41500_C_ID"] = self.orderID.length > 0 ? self.orderID : self.C_A41500_C_ID;
	dic[@"C_ID"] = [NSString stringWithFormat:@"A47200_%@",[self ret32bitString]];
	dic[@"C_ASSISTANT"] = user_id;
//	dic[@"C_TYPE_DD_ID"] = @"A47200_C_TYPE_0001";
	if (self.isDesign == YES) {
//        if (self.C_DESIGNER_ROLEID.length > 0) {
			dic[@"isDesign"] = @"ture";
        
//        }
	}
	[dict setObject:dic forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			if (self.isDesign == YES) {
				[weakSelf HttpAddDesignerWithAndCustomer:weakSelf.C_ID andDesigner:user_id];
			} else {
				[weakSelf.navigationController popViewControllerAnimated:YES];
			}
			
		}else{
            if ([data[@"code"] isEqualToString:@"A47200_1103"]) {
                if (self.isDesign == YES) {
                    [weakSelf HttpAddDesignerWithAndCustomer:weakSelf.C_ID andDesigner:user_id];
                } else {
                    [JRToast showWithText:data[@"message"]];
                }
            } else {
                [JRToast showWithText:data[@"message"]];
            }
           
		}
	}];
}

#pragma mark 设计师
- (void)HttpAddDesignerWithAndCustomer:(NSString *)customerID andDesigner:(NSString *)designer {
	DBSelf(weakSelf);
	NSString *actionStr;
	if (customerID.length > 0) {
		if ([customerID hasPrefix:@"A4200"]) {
			actionStr = @"A42000WebService-operationDesigner";
		} else {
			actionStr = @"CustomerWebService-operationDesigner";
		}
	}
	NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:actionStr];
	NSMutableDictionary *contentDict = [NSMutableDictionary dictionary];
	contentDict[@"C_ID"] = customerID;
	contentDict[@"C_DESIGNER_ROLEID"] = designer;
	[mainDict setObject:contentDict forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
            if ([customerID hasPrefix:@"A4200"]) {
                [MJKPushMsgHttp pushInfoWithC_A41500_C_ID:weakSelf.C_A41500_C_ID andC_ID:customerID andC_TYPE_DD_ID:@"A47500_C_DDTSDW_0001" andVC:weakSelf andYesBlock:^(NSDictionary * _Nonnull data) {
                    MJKMessagePushNotiViewController *vc = [[MJKMessagePushNotiViewController alloc]init];
                    NSMutableDictionary *contentDic = [data[@"content"] mutableCopy];
                    NSMutableArray *arr = [contentDic[@"params"] mutableCopy];
                    vc.titleNameXCX = @"专属设计师消息";
                    //                [arr replaceObjectAtIndex:arr.count - 1 withObject:weakSelf.orderModel.C_MANAGER_ROLENAME];
                    contentDic[@"params"] = arr;
                    vc.dataDic = contentDic;
                    vc.C_A41500_C_ID = weakSelf.C_A41500_C_ID;
                    vc.C_TYPE_DD_ID = @"A47500_C_DDTSDW_0001";
                    vc.C_ID = customerID;
                    vc.backActionBlock = ^{
                        for (UIViewController *vc1 in weakSelf.navigationController.viewControllers) {
                            if ([vc1 isKindOfClass:[ShowHelpViewController class]]) {
                                [weakSelf.navigationController popToViewController:vc1 animated:YES];;
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
			[JRToast showWithText:data[@"message"]];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
		
		
	}];
}

//随机32位随机数
-(NSString *)ret32bitString {
	char data[25];
	for (int x=0;x<25;data[x++] = (char)('A' + (arc4random_uniform(26))));
	return [[NSString alloc] initWithBytes:data length:25 encoding:NSUTF8StringEncoding];
}

#pragma mark - set
- (UITableView *)tableView {
	UIView *view = [self.view viewWithTag:100];
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame), KScreenWidth, KScreenHeight - NavStatusHeight - 40 - WD_TabBarHeight) style:UITableViewStyleGrouped];
		_tableView.delegate = self;
		_tableView.dataSource = self;
	}
	return _tableView;
}
@end
