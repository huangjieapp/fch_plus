//
//  MJKPKSetViewController.m
//  Rebuild_newMJK
//
//  Created by mac on 2018/5/14.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKPKSetViewController.h"
#import "MJKPKAddAndDetailViewController.h"

#import "MJKSettingHeadView.h"
#import "MJKPKModel.h"
#import "MJKPKSetTableViewCell.h"

@interface MJKPKSetViewController ()<UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UILabel *yearMonthLabel;
@property (nonatomic, strong) MJKSettingHeadView *headerView;
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIButton *addButton;
@end

@implementation MJKPKSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableview];
    [self.view addSubview:self.addButton];
    [self initPanGR];
//    [self getListDatas];
    [self setRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableview.mj_header beginRefreshing];
}

- (void)setRefresh {
    DBSelf(weakSelf);
    self.tableview.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getListDatas];
    }];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKPKModel *model = self.dataArray[indexPath.row];
    MJKPKSetTableViewCell *cell = [MJKPKSetTableViewCell cellWithTableView:tableView];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:model.C_HEADIMGURL_SHOW]];
    cell.nameLabel.text = model.C_NAME;
    cell.peopleNumber.text = model.PEOPLENUMBER;
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    MJKPKModel *model = self.dataArray[indexPath.row];
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        UIAlertController *alertV = [UIAlertController alertControllerWithTitle:@"是否确认删除" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *trueAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf deletePKGroup:model.C_ID];
        }];
        UIAlertAction *falseAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertV addAction:falseAction];
        [alertV addAction:trueAction];
        [weakSelf presentViewController:alertV animated:YES completion:nil];
    }];
    deleteAction.backgroundColor = KNaviColor;
    return @[deleteAction];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKPKModel *model = self.dataArray[indexPath.row];
    MJKPKAddAndDetailViewController *vc = [[MJKPKAddAndDetailViewController alloc]init];
    vc.C_ID = model.C_ID;
    vc.dateStr = self.yearMonthLabel.text;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 左右筛选日期

- (void)initPanGR {
//    UISwipeGestureRecognizer *leftSwipeGR = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(changeData:)];
//    leftSwipeGR.delegate = self;
//    leftSwipeGR.direction = UISwipeGestureRecognizerDirectionLeft;
//    [self.view addGestureRecognizer:leftSwipeGR];
//    UISwipeGestureRecognizer *rightSwipeGR = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(changeData:)];
//    rightSwipeGR.delegate = self;
//    rightSwipeGR.direction = UISwipeGestureRecognizerDirectionRight;
//    [self.view addGestureRecognizer:rightSwipeGR];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(80, NavStatusHeight, KScreenWidth - 160, 30)];
    //    bgView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:bgView];
    
    
    UILabel *yearMonthLabel = [[UILabel alloc]initWithFrame:CGRectMake((bgView.frame.size.width-100) / 2, 0, 100, 30)];
    //    yearMonthLabel.backgroundColor = [UIColor redColor];
    self.yearMonthLabel = yearMonthLabel;
    yearMonthLabel.tag = 2018;
    [bgView addSubview:yearMonthLabel];
    yearMonthLabel.text = [self nowYearMonth];
    yearMonthLabel.font = [UIFont systemFontOfSize:14.f];
    yearMonthLabel.textAlignment = NSTextAlignmentCenter;
    yearMonthLabel.textColor = DBColor(142, 142, 142);
    
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(yearMonthLabel.frame) - 20, 0, 20, 30)];
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(yearMonthLabel.frame), 0, 20, 30)];
    [leftButton setTitle:@"<" forState:UIControlStateNormal];
    [leftButton setTitleColor:DBColor(142, 142, 142) forState:UIControlStateNormal];
    [rightButton setTitle:@">" forState:UIControlStateNormal];
    [rightButton setTitleColor:DBColor(142, 142, 142) forState:UIControlStateNormal];
    [bgView addSubview:leftButton];
    [bgView addSubview:rightButton];
    [leftButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)buttonClick:(UIButton *)sender {
    NSString *yearMonth = self.yearMonthLabel.text;
    NSString *year = [yearMonth substringToIndex:4];
    NSString *month = [yearMonth substringWithRange:NSMakeRange(5, 2)];
    if ([sender.titleLabel.text isEqualToString:@"<"]) {
        month = [NSString stringWithFormat:@"%02d",month.intValue-1];
        if (month.intValue < 1) {
            month = @"12";
            year = [NSString stringWithFormat:@"%d",year.intValue-1];
        }
    } else {
        month = [NSString stringWithFormat:@"%02d",month.intValue+1];
        if (month.intValue > 12) {
            month = @"01";
            year = [NSString stringWithFormat:@"%d",year.intValue+1];
        }
    }
    self.yearMonthLabel.text = [NSString stringWithFormat:@"%@-%@",year,month];
//    [self getListDatas];
    [self.tableview.mj_header beginRefreshing];
    
    NSString *nowYearMonth = [self nowYearMonth];
    NSString *nowYear = [nowYearMonth substringToIndex:4];
    NSString *nowMonth = [nowYearMonth substringWithRange:NSMakeRange(5, 2)];
    if (nowMonth.intValue > month.intValue && nowYear.intValue >= year.intValue) {
        self.navigationItem.rightBarButtonItem.customView.hidden = YES;
    } else {
        self.navigationItem.rightBarButtonItem.customView.hidden = NO;
    }
}

- (void)changeData:(UISwipeGestureRecognizer *)swipe {
    NSString *yearMonth = self.yearMonthLabel.text;
    NSString *year = [yearMonth substringToIndex:4];
    NSString *month = [yearMonth substringWithRange:NSMakeRange(5, 2)];
    if (swipe.direction ==  UISwipeGestureRecognizerDirectionLeft) {
        month = [NSString stringWithFormat:@"%02d",month.intValue+1];
        if (month.intValue > 12) {
            month = @"01";
            year = [NSString stringWithFormat:@"%d",year.intValue+1];
        }
        
        NSLog(@"右 %@   %@", year,month );
    } else if (swipe.direction ==  UISwipeGestureRecognizerDirectionRight) {
        month = [NSString stringWithFormat:@"%02d",month.intValue-1];
        if (month.intValue < 1) {
            month = @"12";
            year = [NSString stringWithFormat:@"%d",year.intValue-1];
        }
        NSLog(@"左 %@   %@", year,month);
    }
    self.yearMonthLabel.text = [NSString stringWithFormat:@"%@-%@",year,month];
//    [self getListDatas];
    [self.tableview.mj_header beginRefreshing];
    
    NSString *nowYearMonth = [self nowYearMonth];
    NSString *nowYear = [nowYearMonth substringToIndex:4];
    NSString *nowMonth = [nowYearMonth substringWithRange:NSMakeRange(5, 2)];
    if (nowMonth.intValue > month.intValue && nowYear.intValue >= year.intValue) {
        self.navigationItem.rightBarButtonItem.customView.hidden = YES;
    } else {
        self.navigationItem.rightBarButtonItem.customView.hidden = NO;
    }
    
    
}

- (NSString *)nowYearMonth {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    dateFormatter.dateFormat = @"yyyy-MM";
    return [dateFormatter stringFromDate:date];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // 点击的view的类名
    //    NSLog(@"%@", NSStringFromClass([touch.view class]));
    // 点击了tableViewCell，view的类名为UITableViewCellContentView，则不接收Touch点击事件
    //    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
    //        return NO;
    //    }
    NSLog(@"%@",NSStringFromClass([touch.view class]));
    return  YES;
}

#pragma mark - http request
-(void)getListDatas{
    DBSelf(weakSelf);
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:@"A48100WebService-getAllList"];
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
    contentDict[@"C_YEARMONTH"] = self.yearMonthLabel.text;
    
    contentDict[@"C_TYPE_DD_ID"] = @"A48100_C_TYPE_0000";
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
            if (weakSelf.dataArray.count > 0) {
                [weakSelf.dataArray removeAllObjects];
            }
            NSArray *arr = data[@"content"];
            for (NSDictionary *dic in arr) {
                MJKPKModel *model = [MJKPKModel yy_modelWithDictionary:dic];
                [weakSelf.dataArray addObject:model];
            }
            [weakSelf.tableview reloadData];
            [weakSelf.tableview.mj_header endRefreshing];
        }else{
            [JRToast showWithText:data[@"message"]];
            [weakSelf.tableview.mj_header endRefreshing];
        }
    }];
    
    
}

-(void)deletePKGroup:(NSString *)c_id{
    DBSelf(weakSelf);
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:@"A48100WebService-delete"];
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
    contentDict[@"C_ID"] = c_id;
    
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
            [weakSelf getListDatas];
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
    
    
}

- (void)addButtonAction:(UIButton *)sender {
    MJKPKAddAndDetailViewController *vc = [[MJKPKAddAndDetailViewController alloc]init];
    vc.dateStr = self.yearMonthLabel.text;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (MJKSettingHeadView *)headerView {
    if (!_headerView) {
        _headerView = [[MJKSettingHeadView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, 30)];
        _headerView.headTitleArray = @[@"组名", @"人数"];
    }
    return _headerView;
}

- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), KScreenWidth, KScreenHeight - NavStatusHeight - self.headerView.frame.size.height - WD_TabBarHeight)];
        _tableview.dataSource = self;
        _tableview.delegate = self;
        _tableview.tableFooterView = [[UIView alloc]init];
    }
    return _tableview;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [[UIButton alloc]initWithFrame:CGRectMake((KScreenWidth - 50) / 2, KScreenHeight - 80, 50, 50)];
//        _addButton.layer.masksToBounds = YES;
//        _addButton.layer.cornerRadius = 25.f;
        [_addButton setBackgroundImage:[UIImage imageNamed:@"addimg.png"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

@end
