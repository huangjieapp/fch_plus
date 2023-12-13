//
//  MJKBusinessCardSetViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/27.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKBusinessCardSetViewController.h"

#import "MJKBusinessCardSetCell.h"
#import "MJKBusinessCardSetFunctionCell.h"
#import "CGCNewAppointTextCell.h"
#import "WXApi.h"
#import "MJKBusinessCardAlertView.h"

#import "MJKBusinessCardView.h"

#import "MJKBusinessConfigView.h"

@interface MJKBusinessCardSetViewController ()<UITableViewDataSource, UITableViewDelegate>
/** tableView*/
@property (nonatomic, strong) UITableView *tableView;
/** open card button*/
@property (nonatomic, strong) UIButton *openCardButton;
@property (nonatomic, strong) UIView *openCardView;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *listDataArray;
@property (nonatomic, strong) NSMutableArray *wechatSetArray;
/** <#注释#>*/
@property (nonatomic, assign) BOOL isUnlock;
/** <#注释#>*/
@property (nonatomic, strong) NSString *i_why;

/** <#注释#>*/
@property (nonatomic, strong) MJKBusinessCardView *cardView;
@end

@implementation MJKBusinessCardSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.title = @"名片信息设置";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.i_why = [NewUserSession instance].X_WHY.length > 0 ? [NewUserSession instance].X_WHY : [NSString stringWithFormat:@"您好，我是您的销售顾问%@,如若您有疑问,可随时联系我。我的电话是:%@",[NewUserSession instance].user.nickName,[NewUserSession instance].user.phonenumber];
    /*
     [_wechatSetArray addObject:[@{@"id" : @"X_WHY",@"content" : [NewUserSession instance].X_WHY.length > 0 ? [NewUserSession instance].X_WHY : [NSString stringWithFormat:@"您好，我是您的销售顾问%@,如若您有疑问,可随时联系我。我的电话是:%@",[NewUserSession instance].user.nickName,[NewUserSession instance].user.phonenumber]} mutableCopy]];
     */
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.openCardView];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    if (indexPath.row == 6) {
        MJKBusinessCardSetFunctionCell *cell = [MJKBusinessCardSetFunctionCell cellWithTableView:tableView];
        __block MJKBusinessCardSetFunctionCell *cellBlock = cell;
        cell.openSwitchAction = ^(UISwitch *openSwitch) {
//            openSwitch.on = !openSwitch.isOn;
            if (openSwitch.isOn == NO) {
                if (openSwitch.tag == 111) {
                    NSMutableDictionary *dic = weakSelf.wechatSetArray[0];
                    dic[@"content"] = @"0";
                    cellBlock.mpLabel.hidden = YES;
                } else if (openSwitch.tag == 222) {
                    NSMutableDictionary *dic = weakSelf.wechatSetArray[1];
                    dic[@"content"] = @"0";
                    cellBlock.scLabel.hidden = YES;
                } else if (openSwitch.tag == 333) {
                    NSMutableDictionary *dic = weakSelf.wechatSetArray[2];
                    dic[@"content"] = @"0";
                    cellBlock.alLabel.hidden = YES;
                } else if (openSwitch.tag == 444) {
                    NSMutableDictionary *dic = weakSelf.wechatSetArray[3];
                    dic[@"content"] = @"0";
                    cellBlock.hdLabel.hidden = YES;
                }
            } else {
                if (openSwitch.tag == 111) {
                    MJKBusinessConfigView *configView = [[NSBundle mainBundle]loadNibNamed:@"MJKBusinessConfigView" owner:nil options:nil].firstObject;
                    [weakSelf.view addSubview:configView];
                    NSMutableDictionary *dic = weakSelf.wechatSetArray[0];
                    dic[@"content"] = @"0";
                    cellBlock.mpLabel.hidden = NO;
                } else if (openSwitch.tag == 222) {
                    NSMutableDictionary *dic = weakSelf.wechatSetArray[1];
                    dic[@"content"] = @"0";
                    cellBlock.scLabel.hidden = NO;
                } else if (openSwitch.tag == 333) {
                    NSMutableDictionary *dic = weakSelf.wechatSetArray[2];
                    dic[@"content"] = @"0";
                    cellBlock.alLabel.hidden = NO;
                } else if (openSwitch.tag == 444) {
                    NSMutableDictionary *dic = weakSelf.wechatSetArray[3];
                    dic[@"content"] = @"0";
                    cellBlock.hdLabel.hidden = NO;
                }
            
//            MJKBusinessCardAlertView *alertV = [[MJKBusinessCardAlertView alloc]initAlertControllerWithTitle:@"" message:@"小程序获取访客基本信息授权方式" buttonArray:@[@"不需要",@"提示",@"强制"] colorArray:@[kBackgroundColor,[UIColor grayColor],KNaviColor] clickActionBlock:^(NSString * _Nonnull buttonTitle) {
//                NSLog(@"%@",buttonTitle);
//                if ([buttonTitle isEqualToString:@"不需要"]) {
//                    if (openSwitch.tag == 111) {
//                        NSMutableDictionary *dic = weakSelf.wechatSetArray[0];
//                        dic[@"content"] = @"1";
//                        cellBlock.mpLabel.hidden = NO;
//                        cellBlock.mpLabel.text = @"访客浏览无需授权";
//                    } else if (openSwitch.tag == 222) {
//                        cellBlock.scLabel.hidden = NO;
//                        NSMutableDictionary *dic = weakSelf.wechatSetArray[1];
//                        dic[@"content"] = @"1";
//                        cellBlock.scLabel.text = @"访客浏览无需授权";
//                    } else if (openSwitch.tag == 333) {
//                        cellBlock.alLabel.hidden = NO;
//                        NSMutableDictionary *dic = weakSelf.wechatSetArray[2];
//                        dic[@"content"] = @"1";
//                        cellBlock.alLabel.text = @"访客浏览无需授权";
//                    } else if (openSwitch.tag == 444) {
//                        cellBlock.hdLabel.hidden = NO;
//                        NSMutableDictionary *dic = weakSelf.wechatSetArray[3];
//                        dic[@"content"] = @"1";
//                        cellBlock.hdLabel.text = @"访客浏览无需授权";
//                    }
//                } else if ([buttonTitle isEqualToString:@"提示"]) {
//                    if (openSwitch.tag == 111) {
//                        cellBlock.mpLabel.hidden = NO;
//                        NSMutableDictionary *dic = weakSelf.wechatSetArray[0];
//                        dic[@"content"] = @"2";
//                        cellBlock.mpLabel.text = @"访客浏览提示授权";
//                    } else if (openSwitch.tag == 222) {
//                        cellBlock.scLabel.hidden = NO;
//                        NSMutableDictionary *dic = weakSelf.wechatSetArray[1];
//                        dic[@"content"] = @"2";
//                        cellBlock.scLabel.text = @"访客浏览提示授权";
//                    } else if (openSwitch.tag == 333) {
//                        cellBlock.alLabel.hidden = NO;
//                        NSMutableDictionary *dic = weakSelf.wechatSetArray[2];
//                        dic[@"content"] = @"2";
//                        cellBlock.alLabel.text = @"访客浏览提示授权";
//                    } else if (openSwitch.tag == 444) {
//                        cellBlock.hdLabel.hidden = NO;
//                        NSMutableDictionary *dic = weakSelf.wechatSetArray[3];
//                        dic[@"content"] = @"2";
//                        cellBlock.hdLabel.text = @"访客浏览提示授权";
//                    }
//                } else if ([buttonTitle isEqualToString:@"强制"]) {
//                    if (openSwitch.tag == 111) {
//                        cellBlock.mpLabel.hidden = NO;
//                        NSMutableDictionary *dic = weakSelf.wechatSetArray[0];
//                        dic[@"content"] = @"3";
//                        cellBlock.mpLabel.text = @"访客浏览强制授权";
//                    } else if (openSwitch.tag == 222) {
//                        cellBlock.scLabel.hidden = NO;
//                        NSMutableDictionary *dic = weakSelf.wechatSetArray[1];
//                        dic[@"content"] = @"3";
//                        cellBlock.scLabel.text = @"访客浏览强制授权";
//                    } else if (openSwitch.tag == 333) {
//                        cellBlock.alLabel.hidden = NO;
//                        NSMutableDictionary *dic = weakSelf.wechatSetArray[2];
//                        dic[@"content"] = @"3";
//                        cellBlock.alLabel.text = @"访客浏览强制授权";
//                    } else if (openSwitch.tag == 444) {
//                        cellBlock.hdLabel.hidden = NO;
//                        NSMutableDictionary *dic = weakSelf.wechatSetArray[3];
//                        dic[@"content"] = @"3";
//                        cellBlock.hdLabel.text = @"访客浏览强制授权";
//                    }
//                }
//            }];
//            alertV.closeViewActionBlock = ^{
//                if (openSwitch.tag == 111) {
//                    NSMutableDictionary *dic = weakSelf.wechatSetArray[0];
//                    if ([dic[@"content"] intValue] == 0) {
//                        openSwitch.on = NO;
//                    }
//                } else if (openSwitch.tag == 222) {
//                    NSMutableDictionary *dic = weakSelf.wechatSetArray[1];
//                    if ([dic[@"content"] intValue] == 0) {
//                        openSwitch.on = NO;
//                    }
//                } else if (openSwitch.tag == 333) {
//                    NSMutableDictionary *dic = weakSelf.wechatSetArray[2];
//                    if ([dic[@"content"] intValue] == 0) {
//                        openSwitch.on = NO;
//                    }
//                } else if (openSwitch.tag == 444) {
//                    NSMutableDictionary *dic = weakSelf.wechatSetArray[3];
//                    if ([dic[@"content"] intValue] == 0) {
//                        openSwitch.on = NO;
//                    }
//                }
//            };
//            [[UIApplication sharedApplication].keyWindow addSubview:alertV];
            }
        };
        return cell;
    } /*else if (indexPath.row == 7) {
        CGCNewAppointTextCell*cell=[CGCNewAppointTextCell cellWithTableView:tableView];
        cell.topTitleLabel.text=@"请输入名片打开的默认问候语:";
        cell.topTitleLabel.font = [UIFont systemFontOfSize:14.f];
        cell.textView.backgroundColor = kBackgroundColor;
        if (self.i_why.length > 0) {
            cell.textView.text = self.i_why;
        }
        cell.changeTextBlock = ^(NSString *textStr) {
            MyLog(@"%@",textStr);
            weakSelf.i_why = textStr;
        };
        
        return cell;
    }*/ else {
        NSMutableDictionary *dic = self.listDataArray[indexPath.row];
        MJKBusinessCardSetCell *cell = [MJKBusinessCardSetCell cellWithTableView:tableView];
        cell.contentTextField.placeholder = dic[@"placeholder"];
        if ([dic[@"content"] length] > 0) {
            cell.contentTextField.text = dic[@"content"];
        }
        if (indexPath.row <= 5 && indexPath.row > 1 ) {
            [cell.contentTextField addTarget:self action:@selector(editBegin) forControlEvents:UIControlEventEditingDidBegin];
            
            [cell.contentTextField addTarget:self action:@selector(editEnd) forControlEvents:UIControlEventEditingDidEnd];
            
        }
        cell.textChangeBlock = ^(NSString * _Nonnull str) {
            dic[@"content"] = str;
            //更新头视图名片
            if ([dic[@"id"] isEqualToString:@"C_NAME"]) {
                weakSelf.cardView.nameStr = str;
            } else if ([dic[@"id"] isEqualToString:@"C_MOBILENUMBER"]) {
                weakSelf.cardView.phoneStr = str;
            } else if ([dic[@"id"] isEqualToString:@"C_XCXPOSITION"]) {
                weakSelf.cardView.positionStr = str;
            } else if ([dic[@"id"] isEqualToString:@"storeAddress"]) {
                weakSelf.cardView.addressStr = str;
            }
        };
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 6) {
        return 120;
    }
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //480 750
    return (480 * (KScreenWidth / 750)) + (((KScreenWidth - 40) / 67 * 30) / 2);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MJKBusinessCardView *cardView = [[NSBundle mainBundle]loadNibNamed:@"MJKBusinessCardView" owner:nil options:nil].firstObject;
    self.cardView = cardView;
    return cardView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}


- (void)editBegin {
    self.tableView.contentInset = UIEdgeInsetsMake(-340, 0, 0, 0);
}

- (void)editEnd {
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}
//MARK:-解除微信绑定
-(void)httpUnlockWeChat{
    DBSelf(weakSelf);
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:@"A47700WebService-updateWeChat"];
    NSDictionary*dict=@{};
    [mainDict setObject:dict forKey:@"content"];
    NSString*params=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:params parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            [NewUserSession instance].I_MP = @"0";
            weakSelf.isUnlock = YES;
            [weakSelf httpPostPersonInfo:nil];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

- (void)saveImageWithcompleteBlock:(void(^)(NSString *imageUrl))completeBlock {
    NSArray *dirArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [dirArray firstObject];
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"IDCARD%@.png",[NewUserSession instance].user.nickName]];
    NSData *imageData = UIImageJPEGRepresentation(self.presonImage, 0.1);
    [imageData writeToFile:path atomically:YES];
    [self uppicAction:imageData completeBlock:^(NSString *imageUrl) {
        if (completeBlock) {
           completeBlock(imageUrl);
        }
    }];;
}

-(void)uppicAction:(NSData *)data completeBlock:(void(^)(NSString *imageUrl))completeBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"ipImage"]];
    HttpManager *manager = [[HttpManager alloc]init];
    [manager postDataUpDataPhotoWithUrl:urlStr parameters:nil photo:data compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue] == 200) {
            NSString * imgUrl = [data objectForKey:@"url"];//回传
            if (completeBlock) {
                completeBlock(imgUrl);
            }
           
        } else {
            [JRToast showWithText:data[@"message"]];
        }
    }];
    
}

-(void)httpPostPersonInfo:(NSString *)imageUrl{
    DBSelf(weakSelf);
    NSMutableDictionary*mtDict=[DBObjectTools getAddressDicWithAction:HTTP_updatePersonInfo];
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
    [contentDict setObject:[NewUserSession instance].user.u051Id forKey:@"C_ID"];
    for (NSMutableDictionary *dic in self.listDataArray) {
        [contentDict setObject:dic[@"content"] forKey:dic[@"id"]];
    }
//    for (NSDictionary *dic in self.wechatSetArray) {
//        [contentDict setObject:dic[@"content"] forKey:dic[@"id"]];
//    }
//    if (self.i_why.length > 0) {
//        [contentDict setObject:self.i_why forKey:@"X_WHY"];
//    }
    
    [contentDict setObject:[NewUserSession instance].I_MP forKey:@"I_MP"];
    [contentDict setObject:[NewUserSession instance].I_MP forKey:@"I_MP_SQ"];
    if (imageUrl.length > 0) {
        [contentDict setObject:imageUrl forKey:@"X_PICURL"];
    }
    
    [mtDict setObject:contentDict forKey:@"content"];
    NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mtDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            //成功了   就赋值  然后刷新
            [NewUserSession instance].user.nickName=contentDict[@"C_NAME"];
            [NewUserSession instance].user.phonenumber=contentDict[@"C_MOBILENUMBER"];
            [NewUserSession instance].user.C_INTERNAL=contentDict[@"C_INTERNAL"];
            [NewUserSession instance].user.C_EXTERNAL=contentDict[@"C_EXTERNAL"];
            [NewUserSession instance].user.email=contentDict[@"C_EMAILADDRESS"];
            [NewUserSession instance].user.C_WECHAT=contentDict[@"C_WECHAT"];
            [NewUserSession instance].user.C_IDENTITYCODE=contentDict[@"C_IDENTITYCODE"];
            [NewUserSession instance].C_XCXPOSITION = contentDict[@"C_XCXPOSITION"];
            
            [NewUserSession instance].I_MP = contentDict[@"I_MP"];
            [NewUserSession instance].I_MP_SQ=contentDict[@"I_MP_SQ"];
            [NewUserSession instance].I_RMCP_SQ=contentDict[@"I_RMCP_SQ"];
            [NewUserSession instance].I_JXKL_SQ=contentDict[@"I_JXKL_SQ"];
            [NewUserSession instance].I_ZXHD_SQ=contentDict[@"I_ZXHD_SQ"];
            [NewUserSession instance].X_WHY=contentDict[@"X_WHY"];
            
            if (weakSelf.isUnlock == YES) {//解除绑定
                [weakSelf.navigationController popViewControllerAnimated:YES];
                return ;
            }
            
            WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
            launchMiniProgramReq.userName = [NewUserSession instance].C_GID;  //拉起的小程序的username
            launchMiniProgramReq.path = [NSString stringWithFormat:@"/pages/homepage/homepage?usertoken=%@&accountid=%@&phone=%@",[NewUserSession instance].accountId,[NewUserSession instance].user.u051Id, [NewUserSession instance].user.phonenumber] ;    //拉起小程序页面的可带参路径，不填默认拉起小程序首页
            launchMiniProgramReq.miniProgramType = WXMiniProgramTypeRelease; //拉起小程序的类型
            [WXApi sendReq:launchMiniProgramReq completion:nil];
        
            if (weakSelf.openBusinessCardBlock) {
                weakSelf.openBusinessCardBlock();
            }
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
            //            [self.tableView reloadData];
            
        }else{
            [JRToast showWithText:data[@"message"]];
            [self.tableView reloadData];
        }
        
        
    }];
    
    
    
}

- (void)openBusinessAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"开通名片"] || [sender.titleLabel.text isEqualToString:@"保存名片"]) {
        [NewUserSession instance].I_MP = @"1";
        NSDictionary *dic;
        dic = self.wechatSetArray[0];
//        if ([dic[@"content"] isEqualToString:@"0"]) {
//            [JRToast showWithText:@"请开启名片"];
//            return;
//        }
        dic = self.listDataArray[0];
        if ([dic[@"content"] length] <= 0) {
            [JRToast showWithText:@"请输入姓名"];
            return;
        }
        dic = self.listDataArray[1];
        if ([dic[@"content"] length] <= 0) {
            [JRToast showWithText:@"请输入电话"];
            return;
        }
        dic = self.listDataArray[2];
        if ([dic[@"content"] length] <= 0) {
            [JRToast showWithText:@"请输入职位"];
            return;
        }
        dic = self.listDataArray[3];
        if ([dic[@"content"] length] <= 0) {
            [JRToast showWithText:@"请输入地址"];
            return;
        }
        dic = self.listDataArray[4];
        if ([dic[@"content"] length] <= 0) {
            [JRToast showWithText:@"请输入微信"];
            return;
        }
//        dic = self.listDataArray[5];
//        if ([dic[@"content"] length] <= 0) {
//            [JRToast showWithText:@"请输入邮箱"];
//            return;
//        }
    } else {
        NSMutableDictionary *dic = self.wechatSetArray[0];
        dic[@"content"] = @"0";
        [self httpUnlockWeChat];
        return;
    }
    
    DBSelf(weakSelf);
    if (self.presonImage != nil) {
        [self saveImageWithcompleteBlock:^(NSString *imageUrl) {
            
            [weakSelf httpPostPersonInfo:imageUrl];
        }];
    } else {
        [weakSelf httpPostPersonInfo:nil];
    }
    
}

#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight - 60) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIButton *)openCardButton {
    if (!_openCardButton) {
        _openCardButton = [[UIButton alloc]initWithFrame:CGRectMake(5, KScreenHeight - SafeAreaBottomHeight - 55, KScreenWidth - 10, 50)];
        [_openCardButton setTitleNormal:@"开通名片"];
        [_openCardButton setTitleColor:[UIColor blackColor]];
        [_openCardButton setBackgroundColor:KNaviColor];
        _openCardButton.layer.cornerRadius = 5.f;
        [_openCardButton addTarget:self action:@selector(openBusinessAction:)];
    }
    return _openCardButton;
}

- (UIView *)openCardView {
    if (!_openCardView) {
        _openCardView = [[UIView alloc]initWithFrame:CGRectMake(5, KScreenHeight - SafeAreaBottomHeight - 55, KScreenWidth - 10, 50)];
        _openCardView.layer.cornerRadius = 5.f;
        _openCardView.layer.masksToBounds = YES;
        if ([NewUserSession instance].I_MP.integerValue == 0) {
            UIButton *openCardButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,_openCardView.frame.size.width, _openCardView.frame.size.height)];
            [openCardButton setTitleNormal:@"开通名片"];
            [openCardButton setTitleColor:[UIColor blackColor]];
            [openCardButton setBackgroundColor:KNaviColor];
            openCardButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
//            openCardButton.layer.cornerRadius = 5.f;
            [openCardButton addTarget:self action:@selector(openBusinessAction:)];
            [_openCardView addSubview:openCardButton];
        } else {
            for (int i = 0; i < 2; i++) {
                UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i * (_openCardView.frame.size.width / 2), 0, _openCardView.frame.size.width / 2, _openCardView.frame.size.height)];
                [button setTitleColor:[UIColor blackColor]];
                button.titleLabel.font = [UIFont systemFontOfSize:14.f];
                if (i == 0) {
                    [button setBackgroundColor:kBackgroundColor];
                    [button setTitleNormal:@"解除绑定"];
                } else {
                    [button setBackgroundColor:KNaviColor];
                    [button setTitleNormal:@"保存名片"];
                }
                [button addTarget:self action:@selector(openBusinessAction:)];
                [_openCardView addSubview:button];
            }
            
        }
    }
    return _openCardView;
}

- (NSMutableArray *)listDataArray {
    if (!_listDataArray) {
        _listDataArray = [NSMutableArray array];
        [_listDataArray addObject:[@{@"id" : @"C_NAME",@"placeholder" : @"请输入姓名",@"content" : [NewUserSession instance].user.nickName.length > 0 ? [NewUserSession instance].user.nickName : @""} mutableCopy]];
        [_listDataArray addObject:[@{@"id" : @"C_MOBILENUMBER",@"placeholder" : @"请输入电话",@"content" : [NewUserSession instance].user.phonenumber.length > 0 ? [NewUserSession instance].user.phonenumber : @""} mutableCopy]];
        [_listDataArray addObject:[@{@"id" : @"C_XCXPOSITION",@"placeholder" : @"请输入职位",@"content" : [NewUserSession instance].C_XCXPOSITION.length > 0 ? [NewUserSession instance].C_XCXPOSITION : @""} mutableCopy]];
        [_listDataArray addObject:[@{@"id" : @"storeAddress",@"placeholder" : @"请输入地址",@"content" : [NewUserSession instance].storeAddress.length > 0 ? [NewUserSession instance].storeAddress : @""} mutableCopy]];
        [_listDataArray addObject:[@{@"id" : @"C_WECHAT",@"placeholder" : @"请输入微信",@"content" : [NewUserSession instance].user.C_WECHAT.length > 0 ? [NewUserSession instance].user.C_WECHAT : @""} mutableCopy]];
        [_listDataArray addObject:[@{@"id" : @"C_EMAILADDRESS",@"placeholder" : @"请输入邮箱",@"content" : [NewUserSession instance].user.email.length > 0 ? [NewUserSession instance].user.email : @""} mutableCopy]];
    }
    return _listDataArray;
}

//- (NSMutableArray *)wechatSetArray {
//    if (!_wechatSetArray) {
//        _wechatSetArray = [NSMutableArray array];
//        [_wechatSetArray addObject:[@{@"id" : @"I_MP_SQ",@"content" : ![[NewUserSession instance].I_MP_SQ isEqualToString:@"0"] ? [NewUserSession instance].I_MP_SQ : @"0"} mutableCopy]];
//        [_wechatSetArray addObject:[@{@"id" : @"I_RMCP_SQ",@"content" : ![[NewUserSession instance].I_RMCP_SQ isEqualToString:@"0"] ? [NewUserSession instance].I_RMCP_SQ :  @"0"} mutableCopy]];
//        [_wechatSetArray addObject:[@{@"id" : @"I_JXKL_SQ",@"content" : ![[NewUserSession instance].I_JXKL_SQ isEqualToString:@"0"] ? [NewUserSession instance].I_JXKL_SQ :  @"0"} mutableCopy]];
//        [_wechatSetArray addObject:[@{@"id" : @"I_ZXHD_SQ",@"content" : ![[NewUserSession instance].I_ZXHD_SQ isEqualToString:@"0"] ? [NewUserSession instance].I_ZXHD_SQ :  @"0"} mutableCopy]];
//        
//    }
//    return _wechatSetArray;
//}

@end
