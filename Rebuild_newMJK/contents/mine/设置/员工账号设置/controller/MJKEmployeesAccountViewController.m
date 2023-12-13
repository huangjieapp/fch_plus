//
//  MJKEmployeesAccountViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2018/12/17.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKEmployeesAccountViewController.h"
#import "MJKAddAndEditEmployeesAccountViewController.h"
#import "MJKMarketViewController.h"
#import "MJKSettingHeadView.h"
#import "MJKEmployeesAccountCell.h"
#import "MJKEmployeesAccountModel.h"
#import "CGCNavSearchTextView.h"
#import "MJKVoiceCViewController.h"
#import "VoiceView.h"

@interface MJKEmployeesAccountViewController ()<UITableViewDataSource, UITableViewDelegate>
/** tableView*/
@property (nonatomic, strong) UITableView *tableView;
/** MJKSettingHeadView*/
@property (nonatomic, strong) MJKSettingHeadView *headView;

/** account count view*/
@property (nonatomic, strong) UILabel *countLabel;
/** pages*/
@property (nonatomic, assign) NSInteger pagen;
/** daraArray*/
@property (nonatomic, strong) NSArray *dataArray;
/** CGCNavSearchTextView*/
@property (nonatomic, strong) CGCNavSearchTextView *CurrentTitleView;
/** searchStr*/
@property (nonatomic, strong) NSString *searchStr;
/** <#注释#>*/
@property (nonatomic, strong) VoiceView *vv;
@end

@implementation MJKEmployeesAccountViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"refresh"] isEqualToString:@"yes"]) {
        [self.tableView.mj_header beginRefreshing];
    }
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"refresh"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initRefresh];
    [self configSearch];
}

- (void)initUI {
    self.title = @"员工账号设置";
    MJKSettingHeadView *headView = [[MJKSettingHeadView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, 30)];
    self.headView = headView;
    headView.headTitleArray = @[@"名称",@"账号",@"组织架构"];
    [self.view addSubview:headView];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth - 92, CGRectGetMaxY(headView.frame), 90, 20)];
    imageView.image = [UIImage imageNamed:@"all_bg"];
    UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 20)];
    countLabel.textColor = [UIColor grayColor];
    countLabel.font = [UIFont systemFontOfSize:14.f];
    countLabel.text = @"总计:0";
    countLabel.textAlignment = NSTextAlignmentCenter;
    [imageView addSubview:countLabel];
    self.countLabel = countLabel;
    
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    [self.view addSubview:self.tableView];
    [self.view addSubview:imageView];
    UIButton *rightButtonItem = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightButtonItem setTitleNormal:@"+"];
//    rightButtonItem.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    rightButtonItem.titleLabel.font = [UIFont systemFontOfSize:30.f];
    [rightButtonItem setTitleColor:[UIColor blackColor]];
    [rightButtonItem addTarget:self action:@selector(addAccountAction:)];
    
    UIButton *searcgButtonItem = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [searcgButtonItem setImage:@"搜索按钮"];
    searcgButtonItem.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 0, -30);
    [searcgButtonItem setTitleColor:[UIColor blackColor]];
    [searcgButtonItem addTarget:self action:@selector(addAccountAction:)];
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc]initWithCustomView:rightButtonItem],[[UIBarButtonItem alloc]initWithCustomView:searcgButtonItem]];//搜索按钮
    
    
}

- (void)configSearch {
    DBSelf(weakSelf);
    self.CurrentTitleView=[[CGCNavSearchTextView alloc] initWithFrame:self.view.bounds withPlaceHolder:@"请输入姓名/账号" withRecord:^{//点击录音
                MJKVoiceCViewController *voiceVC = [[MJKVoiceCViewController alloc]initWithNibName:@"MJKVoiceCViewController" bundle:nil];
                [voiceVC setBackStrBlock:^(NSString *str){
                    if (str.length>0) {
                        _CurrentTitleView.textField.text = str;
                        self.searchStr=str;
                        [self.tableView.mj_header beginRefreshing];
                    }
                }];
        self.vv = [[VoiceView alloc]initWithFrame:self.view.frame];

        [self.view addSubview:self.vv];
        //        [weakSelf presentViewController:voiceVC animated:YES completion:nil];
        [weakSelf.vv start];
        weakSelf.vv.recordBlock = ^(NSString *str) {

            _CurrentTitleView.textField.text = str;
            self.searchStr=str;
            [self.tableView.mj_header beginRefreshing];

        };
        
    } withText:^{//开始编辑
        MyLog(@"编辑");
        
        
    }withEndText:^(NSString *str) {//结束编辑
        NSLog(@"%@____",str);
        if (str.length>0) {
            self.searchStr=str;
            [self.tableView.mj_header beginRefreshing];
        }else{
            self.searchStr=@"";
            [self.tableView.mj_header beginRefreshing];
        }
    }];
}

- (void)initRefresh {
    DBSelf(weakSelf);
    self.pagen = 40;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pagen = 40;
        [weakSelf HTTPDatas];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pagen += 40;
        [weakSelf HTTPDatas];
    }];
    
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark 新增账号
- (void)addAccountAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"+"]) {
        MJKAddAndEditEmployeesAccountViewController *vc = [[MJKAddAndEditEmployeesAccountViewController alloc]init];
        vc.type = EmployeesAccountAdd;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        sender.selected = !sender.isSelected;
        if (sender.isSelected == YES) {
            [sender setImage:@"X图标"];
            self.navigationItem.titleView = self.CurrentTitleView;
        } else {
            self.CurrentTitleView.textField.text = @"";
            self.searchStr=@"";
            [sender setImage:@"搜索按钮"];
            self.navigationItem.titleView = nil;
            [self.tableView.mj_header beginRefreshing];
        }
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKEmployeesAccountModel *model = self.dataArray[indexPath.row];
    MJKEmployeesAccountCell *cell = [MJKEmployeesAccountCell cellWithTableView:tableView];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKEmployeesAccountModel *model = self.dataArray[indexPath.row];
    MJKAddAndEditEmployeesAccountViewController *vc = [[MJKAddAndEditEmployeesAccountViewController alloc]init];
    vc.userid = model.C_ID;
    vc.type = EmployeesAccountEdit;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
     MJKEmployeesAccountModel *model = self.dataArray[indexPath.row];
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        if (model.objectCountRemark_flag.boolValue == YES) {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:model.objectCountRemark preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                MJKMarketViewController *vc = [[MJKMarketViewController alloc]init];
                vc.backSelectParameterBlock = ^(NSString *codeStr, NSString *nameStr) {
                    [weakSelf HTTPaAssignAccount:model.C_ID andNewC_ID:codeStr andCompleteBlock:^{
                        [weakSelf HTTPDeleteAccount:model.C_ID andCompleteBlock:^{
                            [JRToast showWithText:@"删除并指派成功"];
                            [weakSelf HTTPDatas];
                        }];
                    }];
                    
                };
                [weakSelf.navigationController pushViewController:vc animated:YES];
                
            }];
            
            UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf HTTPDeleteAccount:model.C_ID andCompleteBlock:^{
                    [weakSelf HTTPDatas];
                }];
            }];
            
            [alertC addAction:noAction];
            [alertC addAction:yesAction];
            
            [weakSelf presentViewController:alertC animated:YES completion:nil];
        } else {
            [weakSelf HTTPDeleteAccount:model.C_ID andCompleteBlock:^{
                [JRToast showWithText:@"删除成功"];
                [weakSelf HTTPDatas];
            }];
        }
        
    }];
    deleteAction.backgroundColor = KNaviColor;
    return @[deleteAction];
}

#pragma mark - http 配置项列表
- (void)HTTPDatas {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"UserWebService-getList"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"currPage"] = @"1";
    dic[@"pageSize"] = [NSString stringWithFormat:@"%ld",self.pagen];
    if (self.searchStr.length > 0) {
        //SEARCH_NAMEORCONTACT
        dic[@"SEARCH_NAMEORCONTACT"] = self.searchStr;
    }
    [dict setObject:dic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.dataArray = [MJKEmployeesAccountModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
            weakSelf.countLabel.text = [NSString stringWithFormat:@"总计:%@",data[@"countNumber"]];
            [weakSelf.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

//UserWebService-deleteAccount
- (void)HTTPDeleteAccount:(NSString *)C_ID andCompleteBlock:(void(^)(void))completeBlock {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"UserWebService-deleteAccount"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"C_ID"] = C_ID;
    [dict setObject:dic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            if (completeBlock) {
                completeBlock();
            }
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}
//UserWebService-assignByUserid
- (void)HTTPaAssignAccount:(NSString *)C_ID andNewC_ID:(NSString *)newC_ID andCompleteBlock:(void(^)(void))completeBlock {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"UserWebService-assignByUserid"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"C_ID"] = C_ID;
     dic[@"USER_ID"] = newC_ID;
    [dict setObject:dic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            if (completeBlock) {
                completeBlock();
            }
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headView.frame), KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight - self.headView.frame.size.height) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}



@end
