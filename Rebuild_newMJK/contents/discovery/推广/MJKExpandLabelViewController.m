//
//  MJKExpandLabelViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/12.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKExpandLabelViewController.h"

#import "CGCExpandLabelModel.h"
#import "CGCExpandLabeSublModel.h"

#import "CGCExpandLabelCell.h"

@interface MJKExpandLabelViewController ()<UITableViewDataSource, UITableViewDelegate>
/** tableView*/
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *labelArray;

/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *selectedArray;
@end

@implementation MJKExpandLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.title = @"素材标签";
    UIButton *sureButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    [sureButton setTitleNormal:@"确定"];
    [sureButton setTitleColor:[UIColor blackColor]];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [sureButton addTarget:self action:@selector(sureButtonAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:sureButton];
    [self.view addSubview:self.tableView];
    [self httpPostLabelCategroy];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.labelArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    CGCExpandLabelCell *cell = [CGCExpandLabelCell cellWithTableView:tableView];
    if (indexPath.section == 0) {
        cell.isButtonSelected = NO;
        cell.labelArray = self.selectedArray;
    } else {
        CGCExpandLabelModel *model = self.labelArray[indexPath.section - 1];
        NSArray *labelArray = model.content;
        cell.isButtonSelected = YES;
        cell.labelArray = labelArray;
        cell.selectLabelBlock = ^(CGCExpandLabeSublModel * _Nonnull subModel) {
            if (subModel.isSelected == YES) {
                [weakSelf.selectedArray addObject:subModel];
            } else {
                if ([weakSelf.selectedArray containsObject:subModel]) {
                    [weakSelf.selectedArray removeObject:subModel];
                }
            }
            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        };
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [CGCExpandLabelCell cellHeight:self.selectedArray];
    } else {
        CGCExpandLabelModel *model = self.labelArray[indexPath.section - 1];
        NSArray *labelArray = model.content;
        return [CGCExpandLabelCell cellHeight:labelArray];
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    bgView.backgroundColor = kBackgroundColor;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, KScreenWidth - 30, 30)];
    if (section == 0) {
        label.text = @"已选中标签";
    } else {
        CGCExpandLabelModel *model = self.labelArray[section - 1];
        label.text = model.name;
    }
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontOfSize:14.f];
    [bgView addSubview:label];
    return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

#pragma mark 确定按钮
- (void)sureButtonAction:(UIButton *)sender {
    NSMutableArray *arrID = [NSMutableArray array];
    NSMutableArray *arrName = [NSMutableArray array];
    for (CGCExpandLabeSublModel *subModel in self.selectedArray) {
        [arrID addObject:subModel.labelId];
        [arrName addObject:subModel.name];
    }
    NSString *idStr = [arrID componentsJoinedByString:@","];
    NSString *nameStr = [arrName componentsJoinedByString:@","];
    if (self.selectLabelBackBlock) {
        self.selectLabelBackBlock(idStr, nameStr);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 接口
-(void)httpPostLabelCategroy {
    DBSelf(weakSelf);
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:@"A48200WebService-getLabelList"];
    [mainDict setObject:@{} forKey:@"content"];
    NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.labelArray = [CGCExpandLabelModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
            
            [weakSelf httpPostMaterial];
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

-(void)httpPostMaterial {
    DBSelf(weakSelf);
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:@"A48200WebService-getClassificationList"];
    NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            
            CGCExpandLabelModel *model = [[CGCExpandLabelModel alloc]init];
            model.labelId = @"";
            model.name = @"副栏";
            model.content = [NSMutableArray array];
            NSArray *arrID= [NSArray arrayWithObjects:@"typeOneId",@"typeTwoId",@"typeThreeId",@"typeFourId",@"typeFiveId", nil];
            NSArray *arrName = [NSArray arrayWithObjects:@"typeOneName",@"typeTwoName",@"typeThreeName",@"typeFourName",@"typeFiveName", nil];
            
            for (int i = 0; i < arrID.count; i++) {
                CGCExpandLabeSublModel *subModel = [[CGCExpandLabeSublModel alloc]init];
                subModel.labelId = data[arrID[i]];
                subModel.name = data[arrName[i]];
                [model.content addObject:subModel];
             }
            
            [weakSelf.labelArray addObject:model];
            [weakSelf.tableView reloadData];
//            weakSelf.labelArray CGCExpandLabelModel *model
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

- (NSMutableArray *)selectedArray {
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}

@end
