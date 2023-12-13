//
//  MJKOrganizationalViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2018/12/18.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKOrganizationalViewController.h"

#import "MJKOrganizationalModel.h"

#import "MJKOrganizationalTableViewCell.h"

@interface MJKOrganizationalViewController ()<UITableViewDataSource, UITableViewDelegate>
/** tableView*/
@property (nonatomic, strong) UITableView *tableView;
/** headView*/
@property (nonatomic, strong) UIView *headView;
/** UIScrollView*/
@property (nonatomic, strong) UIScrollView *scrollView;
/** data Array*/
@property (nonatomic, strong) NSMutableArray *dataArray;
/** <#注释#>*/
@property (nonatomic, assign) NSInteger index;
/** MJKOrganizationalModel*/
@property (nonatomic, strong) MJKOrganizationalModel *perModel;
/** */
@property (nonatomic, strong) UIButton *perbButton;
/** modelArray*/
@property (nonatomic, strong) NSMutableArray *modelArray;
/** buttonArray*/
@property (nonatomic, strong) NSMutableArray *buttonArray;
/** 选中的model*/
@property (nonatomic, strong) MJKOrganizationalModel *selectModel;
@end

@implementation MJKOrganizationalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    [self initUI];
}

- (void)initUI {
    self.title = @"选择组织架构";
    self.index = 0;
    self.view.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.headView];
    [self.view addSubview:self.tableView];
    [self HTTPGroupData];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setTitleNormal:@"确定"];
    [button setTitleColor:[UIColor blackColor]];
    [button addTarget:self action:@selector(clickTrueButton:)];
    button.titleLabel.font = [UIFont systemFontOfSize:14.f];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.perModel != nil) {
        return self.perModel.xjList.count;
    } else {
        MJKOrganizationalModel *model = self.dataArray[section];
        return model.xjList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    MJKOrganizationalModel *model1;
    if (self.perModel != nil) {
        model1 = self.perModel.xjList[indexPath.row];
    } else {
        MJKOrganizationalModel *model = self.dataArray[indexPath.section];
        model1 = model.xjList[indexPath.row];
    }
    
    MJKOrganizationalTableViewCell *cell = [MJKOrganizationalTableViewCell cellWithTableView:tableView];
    cell.model = model1;
    cell.buttonBlock = ^{
        if (model1.xjList.count <= 0) {
            [JRToast showWithText:@"暂无下级"];;
        } else {
            weakSelf.perModel = model1;
            [tableView reloadData];
            CGSize size = [[NSString stringWithFormat:@"%@>",model1.C_U00100_C_NAME] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, weakSelf.headView.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(weakSelf.perbButton.frame), 0, size.width, weakSelf.headView.frame.size.height)];
            button.titleLabel.font = [UIFont systemFontOfSize:14.f];
            [button setTitleColor:[UIColor blackColor]];
            [button setTitleNormal:[NSString stringWithFormat:@"%@>",model1.C_U00100_C_NAME]];
            button.tag = weakSelf.perbButton.tag + 1;
            weakSelf.perbButton = button;
            [button addTarget:weakSelf action:@selector(clickToModel:)];
            [weakSelf.scrollView addSubview:button];
            
            weakSelf.scrollView.contentSize = CGSizeMake(button.frame.origin.x + button.frame.size.width,weakSelf.headView.frame.size.height);
            
            
            [weakSelf.modelArray addObject:model1];
            [weakSelf.buttonArray addObject:button];
        }
    };
    
    cell.selectButtonBlock = ^{
        weakSelf.selectModel = model1;
    };
    return cell;
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

#pragma mark - http
- (void)HTTPGroupData {
    DBSelf(weakSelf);
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"UserWebService-getOrganizationalList"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dict setObject:dic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.dataArray = [MJKOrganizationalModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
            [weakSelf.tableView reloadData];
            
            MJKOrganizationalModel *model = weakSelf.dataArray[0];
            CGSize size = [[NSString stringWithFormat:@"%@>",model.C_U00100_C_NAME] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, weakSelf.headView.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
            
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, size.width, weakSelf.headView.frame.size.height)];
            button.titleLabel.font = [UIFont systemFontOfSize:14.f];
            [button setTitleColor:[UIColor blackColor]];
            [button setTitleNormal:[NSString stringWithFormat:@"%@>",model.C_U00100_C_NAME]];
            [button addTarget:weakSelf action:@selector(clickToModel:)];
            button.tag = 0;
            weakSelf.perbButton = button;
            [weakSelf.scrollView addSubview:button];
            [weakSelf.modelArray addObject:model];
            [weakSelf.buttonArray addObject:button];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}
#pragma mark - 跳转到相对应地下级
- (void)clickToModel:(UIButton *)sender {
    NSInteger tag;
    self.perModel = self.modelArray[sender.tag];
    [self.tableView reloadData];
    self.perbButton = sender;
    tag = sender.tag;
    if ([sender.titleLabel.text isEqualToString:[NSString stringWithFormat:@"%@>",self.perModel.C_U00100_C_NAME]]) {
        NSArray *arr = [NSArray arrayWithArray:self.buttonArray];
        NSArray *modelArr = [NSArray arrayWithArray:self.modelArray];
        for (int i = 0; i < arr.count; i++) {
            if (arr.count > tag + 1) {
                UIButton *button = arr[tag + 1];
                MJKOrganizationalModel *model = modelArr[tag + 1];
                for (MJKOrganizationalModel *subModel in model.xjList) {
                    subModel.selected = NO;
                }
                tag = button.tag;
                [self.buttonArray removeObject:button];
                [self.modelArray removeObject:model];
                [button removeFromSuperview];
                
                
            }
        }
    }
}

#pragma mark - 确定按钮
- (void)clickTrueButton:(UIButton *)sender {
    if (self.selectOrganizationalModelBlock) {
        self.selectOrganizationalModelBlock(self.selectModel);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - set
- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, 44)];
        _headView.backgroundColor = [UIColor whiteColor];
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, self.headView.frame.size.height)];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [_headView addSubview:self.scrollView];
    }
    return _headView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headView.frame) + 10, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight - self.headView.frame.size.height - 10) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

- (NSMutableArray *)modelArray {
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}



@end
