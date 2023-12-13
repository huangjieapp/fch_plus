//
//  ProvincesAndCityViewController.m
//  match5.0
//
//  Created by huangjie on 2023/2/9.
//

#import "ProvincesAndCityViewController.h"

#import "ProvincesAndCityTableViewCell.h"

#import "ProvincesAndCityModel.h"

@interface ProvincesAndCityViewController ()<UITableViewDataSource, UITableViewDelegate>
/** <#注释#> */
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *rightTableView;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *leftArray;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *rightArray;
@end

@implementation ProvincesAndCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"省市";
    @weakify(self);
    UIButton *button = [UIButton new];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHex:@"#000000"] forState:UIControlStateNormal];
    
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        NSMutableArray *arr = [NSMutableArray array];
        for (ProvincesAndCityModel *model in self.leftArray) {
            if (model.isSelected == YES) {
                [arr addObject:model.label];
            }
        }
        
        for (ProvincesAndCityModel *model in self.rightArray) {
            if (model.isSelected == YES) {
                [arr addObject:model.label];
            }
        }
        if (self.chooseBlock) {
            self.chooseBlock(arr);
        }
        [self.navigationController popViewControllerAnimated:NO];
    }];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(NAVIHEIGHT));
        make.left.equalTo(self.view);
        make.width.mas_equalTo(150);
        make.bottom.equalTo(self.view).offset(-AdaptSafeBottomHeight);
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerClass:[ProvincesAndCityTableViewCell class] forCellReuseIdentifier:@"ProvincesAndCityTableViewCell"];
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.tableFooterView = [UIView new];
    if (@available(iOS 15.0,*)) {
        _tableView.sectionHeaderTopPadding = YES;
    }
    
    _rightTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_rightTableView];
    [_rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(NAVIHEIGHT));
        make.left.equalTo(self.tableView.mas_right);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-AdaptSafeBottomHeight);
    }];
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
    _rightTableView.backgroundColor = [UIColor clearColor];
    [_rightTableView registerClass:[ProvincesAndCityTableViewCell class] forCellReuseIdentifier:@"ProvincesAndCityTableViewCell"];
    _rightTableView.rowHeight = UITableViewAutomaticDimension;
    _rightTableView.tableFooterView = [UIView new];
    if (@available(iOS 15.0,*)) {
        _rightTableView.sectionHeaderTopPadding = YES;
    }
    
    [self getProvinceAndCity];
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];

}

- (void)backAction {
    if ([self.vcName isEqualToString:@"funnel"]) {
        if (self.backBlock) {
            self.backBlock();
        }
    }
}

- (void)getProvinceAndCity {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"type"] = @"2";
    HttpManager *manager = [[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/masterdata/districts/getTreeList",HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
            NSArray *arr = [ProvincesAndCityModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            if (arr.count > 0) {
                weakSelf.leftArray = [arr copy];
                ProvincesAndCityModel *model = arr[0];
                model.selected = YES;
                weakSelf.rightArray = [model.children copy];
                ProvincesAndCityModel *subModel = weakSelf.rightArray[0];
                subModel.selected = YES;
                
            }
            [weakSelf.tableView reloadData];
            [weakSelf.rightTableView reloadData];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
    
   
}



#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return self.leftArray.count;
    } else {
        return self.rightArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    ProvincesAndCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProvincesAndCityTableViewCell"];
    if (tableView == self.tableView)  {
        ProvincesAndCityModel *model = self.leftArray[indexPath.row];
        cell.titleLabel.text = model.label;
        cell.selectButton.selected = model.isSelected;
        cell.selectButton.tag = indexPath.row + 100;
        [[[cell.selectButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
            for (ProvincesAndCityModel *tempModel in self.leftArray) {
                tempModel.selected = NO;
                for (ProvincesAndCityModel *tempSubTmodel in tempModel.children) {
                    tempSubTmodel.selected = NO;
                }
            }
            model.selected = YES;
            weakSelf.rightArray = [model.children copy];
            ProvincesAndCityModel *subModel = weakSelf.rightArray[0];
            subModel.selected = YES;
            [tableView reloadData];
            [weakSelf.rightTableView reloadData];
        }];
    } else {
        ProvincesAndCityModel *model = self.rightArray[indexPath.row];
        cell.titleLabel.text = model.label;
        cell.selectButton.selected = model.isSelected;
        cell.selectButton.tag = indexPath.row + 200;
        [[[cell.selectButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
            for (ProvincesAndCityModel *tempModel in self.rightArray) {
                tempModel.selected = NO;
            }
            model.selected = YES;
           
            [tableView reloadData];
            [weakSelf.rightTableView reloadData];
        }];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
