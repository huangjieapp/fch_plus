//
//  SetViewController.m
//  match
//
//  Created by huangjie on 2022/7/24.
//

#import "SetManagementViewController.h"

#import "SetManagementSwitchTableViewCell.h"

#import "SetManagementModel.h"
#import "MJKPushDefaultListModel.h"

@interface SetManagementViewController ()<UITableViewDataSource, UITableViewDelegate>
/** <#注释#> */
@property (nonatomic, strong) NSArray *dataArray;
/** <#注释#> */
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation SetManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAVIHEIGHT);
        make.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(-AdaptSafeBottomHeight);
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerClass:[SetManagementSwitchTableViewCell class] forCellReuseIdentifier:@"SetManagementSwitchTableViewCell"];
    _tableView.estimatedRowHeight = 300;
    if (@available(iOS 15.0,*)) {
        _tableView.sectionHeaderTopPadding = YES;
    }
    
    [self getManagementData];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SetManagementModel *model = self.dataArray[section];
    return model.defaultList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    SetManagementModel *model = self.dataArray[indexPath.section];
    SetManagementSubModel *subModel = model.defaultList[indexPath.row];
    SetManagementSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetManagementSwitchTableViewCell"];
    cell.headImageView.image = [UIImage  imageNamed:[NSString stringWithFormat:@"%@图标应用",subModel.NAME]];
    cell.titleLabel.text = subModel.NAME;
    cell.switchButton.on = [subModel.ISCHECK boolValue];
    [[[cell.switchButton rac_signalForControlEvents:UIControlEventValueChanged] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        subModel.ISCHECK = [subModel.ISCHECK isEqualToString:@"true"] ? @"false" : @"true";
        [self setManagementWith:model];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SetManagementModel *model = self.dataArray[section];
    UIView *bgView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    bgView.backgroundColor = kBackgroundColor;
    UILabel *label = [UILabel new];
    [bgView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView);
        make.left.mas_equalTo(17);
    }];
    label.font = [UIFont systemFontOfSize:14.f];
    label.textColor = [UIColor darkGrayColor];
    label.text = model.C_NAME;
    return bgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)getManagementData {
    @weakify(self);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkWithUrl:[NSString stringWithFormat:@"%@/api/system/a475/menuList", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
        @strongify(self);
        if ([data[@"code"] integerValue] == 200) {
            self.dataArray = [SetManagementModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"content"]];
            [self.tableView  reloadData];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)setManagementWith:(SetManagementModel *)model {
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
   
    contentDic = [model mj_keyValues];
    NSMutableArray *arr = [NSMutableArray array];
    for (SetManagementSubModel *subModel in model.defaultList) {
        [arr addObject:[subModel mj_keyValues]];
    };
    contentDic[@"defaultList"] = arr;
    
//
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkWithUrl:[NSString stringWithFormat:@"%@/api/system/a475/edit", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            [JRToast showWithText:@"操作成功"];
            NSMutableArray *myAppArr = [[KUSERDEFAULT objectForKey:SaveSelectedModule] mutableCopy];
            NSArray *myAppArrName = [KUSERDEFAULT objectForKey:SaveSelectedModuleName];
            
            for (SetManagementSubModel *defaultModel in model.defaultList) {
                if ([defaultModel.ISCHECK isEqualToString:@"false"]) {
                    if ([myAppArrName containsObject:defaultModel.NAME]) {
                        [myAppArr removeObject:defaultModel.NAME];
                    }
                    [KUSERDEFAULT setObject:myAppArr forKey:SaveSelectedModule];
                    if ([[NewUserSession instance].configData.app_default containsObject:defaultModel.CODE]) {
                        [[NewUserSession instance].configData.app_default removeObject:defaultModel.CODE];
                    }
                    if ([[NewUserSession instance].configData.app_base containsObject:defaultModel.CODE]) {
                        [[NewUserSession instance].configData.app_base removeObject:defaultModel.CODE];
                    }
                    if ([[NewUserSession instance].configData.app_report containsObject:defaultModel.CODE]) {
                        [[NewUserSession instance].configData.app_report removeObject:defaultModel.CODE];
                    }
                    if ([[NewUserSession instance].configData.app_mjk containsObject:defaultModel.CODE]) {
                        [[NewUserSession instance].configData.app_mjk removeObject:defaultModel.CODE];
                    }
                    if ([[NewUserSession instance].configData.app_mzg containsObject:defaultModel.CODE]) {
                        [[NewUserSession instance].configData.app_mzg removeObject:defaultModel.CODE];
                    }
                    if ([[NewUserSession instance].configData.app_jp containsObject:defaultModel.CODE]) {
                        [[NewUserSession instance].configData.app_jp removeObject:defaultModel.CODE];
                        [NewUserSession instance].isApp_jp = YES;
                    }
                } else {
                    if ([myAppArrName containsObject:defaultModel.NAME] && ![myAppArr containsObject:defaultModel.NAME]) {
                        NSInteger index = [myAppArrName indexOfObject:defaultModel.NAME];
                        [myAppArr insertObject:defaultModel.NAME atIndex:index];
                    }
                    [KUSERDEFAULT setObject:myAppArr forKey:SaveSelectedModule];
                    if (![[NewUserSession instance].configData.app_default containsObject:defaultModel.CODE]) {
                        [[NewUserSession instance].configData.app_default addObject:defaultModel.CODE];
                    }
                    if (![[NewUserSession instance].configData.app_base containsObject:defaultModel.CODE]) {
                        [[NewUserSession instance].configData.app_base addObject:defaultModel.CODE];
                    }
                    if (![[NewUserSession instance].configData.app_report containsObject:defaultModel.CODE]) {
                        [[NewUserSession instance].configData.app_report addObject:defaultModel.CODE];
                    }
                    if (![[NewUserSession instance].configData.app_mjk containsObject:defaultModel.CODE]) {
                        [[NewUserSession instance].configData.app_mjk addObject:defaultModel.CODE];
                    }
                    if (![[NewUserSession instance].configData.app_mzg containsObject:defaultModel.CODE]) {
                        [[NewUserSession instance].configData.app_mzg addObject:defaultModel.CODE];
                    }
                    if (![[NewUserSession instance].configData.app_jp containsObject:defaultModel.CODE]) {
                        [[NewUserSession instance].configData.app_jp addObject:defaultModel.CODE];
                        
                        [NewUserSession instance].isApp_jp = YES;
                    }
                }
                
            }
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
    }];
}

@end
