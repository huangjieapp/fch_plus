//
//  MJKWordsArtTemplateViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/20.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKWordsArtTemplateViewController.h"

#import "MJKMessageMapViewController.h"

#import "MJKWordsArtTemplateModel.h"

#import "MJKWordsArtTemplateCell.h"

@interface MJKWordsArtTemplateViewController ()<UITableViewDataSource, UITableViewDelegate>
/** <#注释#>*/
@property (nonatomic, strong) UITableView *tableView;
/** sure button*/
@property (nonatomic, strong) UIButton *sureButton;
/** list data*/
@property (nonatomic, strong) NSArray *listDataArray;
/** <#注释#>*/
@property (nonatomic, strong) MJKWordsArtTemplateModel *preModel;
@end

@implementation MJKWordsArtTemplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.title = @"选择话术模板";
    self.view.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.sureButton];
    [self HTTPListdData];
    
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    MJKWordsArtTemplateModel *model = self.listDataArray[indexPath.row];
    MJKWordsArtTemplateCell *cell = [MJKWordsArtTemplateCell cellWithTableView:tableView];
    cell.model = model;
    cell.selectModelBlock = ^{
        weakSelf.preModel.selected = NO;
        weakSelf.preModel = model;
        [tableView reloadData];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MJKWordsArtTemplateModel *model = self.listDataArray[indexPath.row];
    CGSize size = [[model.nlpEventName stringByAppendingString:@" 话术模板"] boundingRectWithSize:CGSizeMake(KScreenWidth - 50, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
    if (size.height + 20 > 50) {
        return size.height + 20;
    } else {
        return 50;
    }
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
    MJKWordsArtTemplateModel *model = self.listDataArray[indexPath.row];
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        MJKMessageMapViewController *vc = [[MJKMessageMapViewController alloc]init];
        vc.titleName = model.nlpEventName;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    editAction.backgroundColor = KNaviColor;
    return @[editAction];
}


- (void)HTTPListdData {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A70100WebService-listEventByThemeId"];
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    
    [dict setObject:dic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    
    DBSelf(weakSelf);
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
            weakSelf.listDataArray = [MJKWordsArtTemplateModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            [weakSelf.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
    
}

#pragma mark - 确定按钮
- (void)sureButtonAction:(UIButton *)sender {
    for (MJKWordsArtTemplateModel *model in self.listDataArray) {
        if (model.isSelected == YES) {
            if (self.selectBackBlock) {
                self.selectBackBlock(model.nlpEventId, model.nlpEventName,model.nlpThemeId);
            }
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight - 50) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), KScreenWidth, 54)];
        [_sureButton setTitleNormal:@"确定"];
        [_sureButton setTitleColor:[UIColor blackColor]];
        [_sureButton setBackgroundColor:KNaviColor];
        [_sureButton addTarget:self action:@selector(sureButtonAction:)];
    }
    return _sureButton;
}
@end
