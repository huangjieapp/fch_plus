//
//  MJKProductChooseViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/3/25.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKProductChooseViewController.h"

#import "MJKProductShowTableViewCell.h"
#import "MJKShoppingCartCell.h"

#import "MJKProductShowModel.h"

#import "CGCNavSearchTextView.h"
#import "VoiceView.h"

#import "CustomerLvevelNextFollowModel.h"

@interface MJKProductChooseViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *typeTableView;//左边选择类型tableview
@property (weak, nonatomic) IBOutlet UITableView *mainTabelView;//右边显示产品tableview
@property (weak, nonatomic) IBOutlet UITableView *shoppingCartTabelView;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (weak, nonatomic) IBOutlet UIView *shoppingCartBGView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shoppingCartTableHeighrLayout;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeTopLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainTopLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchTopLayout;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shoppingMallImageView;


@property(nonatomic,strong)CGCNavSearchTextView*CurrentTitleView;  //不做属性 警告。。
/** VoiceView*/
@property (nonatomic, strong) VoiceView *vv;

/** type array*/
@property (nonatomic, strong) NSMutableArray *typeArray;

/** pagen*/
@property (nonatomic, assign) NSInteger pagen;

/** C_TYPE_DD_ID*/
@property (nonatomic, strong) NSString *C_TYPE_DD_ID;
@property (nonatomic, strong) NSString *C_PICTURE_SHOW;
@property (nonatomic, strong) NSString *tempModelType;
/** paramDic*/
@property (nonatomic, strong) NSDictionary *paramDic;
/** mainShow*/
@property (nonatomic, strong) NSArray *mainShowArray;

/** <#注释#>*/
@property (nonatomic, assign) NSInteger indexModel;
/** <#注释#>*/
@property (nonatomic, assign) NSInteger totalMoney;
/** <#注释#>*/
@property (nonatomic, assign) BOOL isSearch;
/** <#注释#>*/
@property (nonatomic, strong) NSString *searchStr;

/** <#注释#>*/
@property (nonatomic, strong) NSArray *categoryArray;

@end

@implementation MJKProductChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.typeTableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
        self.mainTabelView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
        self.searchTableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    
    self.typeTopLayout.constant = self.mainTopLayout.constant = self.searchTopLayout.constant = SafeAreaTopHeight;
    self.bottomLayout.constant = SafeAreaBottomHeight;
    
    self.title = @"产品";
    self.totalMoney = 0;
    self.indexModel = 0;
    [self configNavi];
    [self configRefresh];
    [self getActivityCategory];
    
    if (self.productArray.count > 0) {
        NSInteger total = 0;
        NSInteger shopCount = 0;
        for (MJKProductShowModel *saveModel in self.productArray) {
            total += saveModel.B_HDJ.integerValue * saveModel.number;
            shopCount += saveModel.number;
        }
        self.totalMoneyLabel.text = [NSString stringWithFormat:@"¥ %ld",(long)total];
        
        if (total == 0) {
            self.shoppingMallImageView.image = [UIImage imageNamed:@"购物车-未选中"];
            [self.shoppingMallImageView pp_hiddenBadge];
        } else {
            self.shoppingMallImageView.image = [UIImage imageNamed:@"购物车-选中"];
            [self.shoppingMallImageView pp_moveBadgeWithX:-5 Y:5];
            [self.shoppingMallImageView pp_addBadgeWithNumber:shopCount];
        }
    }
}

- (void)configNavi {
    UIButton *scanButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [scanButton setImage:@"扫描"];
    scanButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    
    UIButton *searchButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [searchButton setImage:@"搜索按钮"];
    searchButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [searchButton addTarget:self action:@selector(searchAction:)];
    
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc]initWithCustomView:scanButton], [[UIBarButtonItem alloc]initWithCustomView:searchButton]];
    
    DBSelf(weakSelf);
    self.CurrentTitleView=[[CGCNavSearchTextView alloc] initWithFrame:self.view.bounds withPlaceHolder:@"请搜索产品名称" withRecord:^{//点击录音
        //        MJKVoiceCViewController *voiceVC = [[MJKVoiceCViewController alloc]initWithNibName:@"MJKVoiceCViewController" bundle:nil];
        //        [voiceVC setBackStrBlock:^(NSString *str){
        //            if (str.length>0) {
        //                _CurrentTitleView.textField.text = str;
        //                self.searchStr=str;
        //                [self.tableView.mj_header beginRefreshing];
        //            }
        //        }];
        weakSelf.vv = [[VoiceView alloc]initWithFrame:weakSelf.view.frame];
        
        [weakSelf.view addSubview:weakSelf.vv];
        //        [weakSelf presentViewController:voiceVC animated:YES completion:nil];
        [weakSelf.vv start];
        weakSelf.vv.recordBlock = ^(NSString *str) {
            
            _CurrentTitleView.textField.text = str;
            weakSelf.searchStr = str;
            [weakSelf.searchTableView.mj_header beginRefreshing];
            
        };
        
    } withText:^{//开始编辑
        MyLog(@"编辑");
        
        
    }withEndText:^(NSString *str) {//结束编辑
        NSLog(@"%@____",str);
        weakSelf.searchStr = str;
        [weakSelf.searchTableView.mj_header beginRefreshing];
    }];
}

- (void)configRefresh {
    DBSelf(weakSelf);
    self.pagen = 20;
    
    self.mainTabelView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pagen = 20;
        [weakSelf HTTPGetProductList];
    }];
    self.mainTabelView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pagen += 20;
        [weakSelf HTTPGetProductList];
    }];
    
    self.searchTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pagen = 20;
        [weakSelf HTTPGetProductList];
    }];
    self.searchTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pagen += 20;
        [weakSelf HTTPGetProductList];
    }];
}

#pragma mark 搜索按钮
- (void)searchAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.searchTableView.hidden = !sender.isSelected;
    self.isSearch = sender.isSelected;
    [self.searchTableView.mj_header beginRefreshing];
    if (sender.isSelected == YES) {
        [sender setImage:@"X图标"];
        self.navigationItem.titleView = self.CurrentTitleView;
    } else {
        [sender setImage:@"搜索按钮"];
        self.navigationItem.titleView = nil;
        self.title = @"产品";
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.shoppingCartTabelView) {
        return self.productArray.count;
    } else if (tableView == self.typeTableView) {
        return self.categoryArray.count;
    } else {
        return self.mainShowArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    if (tableView == self.shoppingCartTabelView) {
        MJKProductShowModel *model = self.productArray[indexPath.row];
        MJKShoppingCartCell *cell = [MJKShoppingCartCell cellWithTableView:tableView];
        cell.model = model;
        cell.updateBlock = ^{
            [tableView beginUpdates];
            [tableView endUpdates];
        };
        cell.addOrSubProductActionBlock = ^(NSString * _Nonnull typeStr) {
            if ([typeStr isEqualToString:@"+"]) {
                model.number += 1;
            } else {
                model.number -= 1;
            }
            NSInteger total = 0;
            NSInteger shopCount = 0;
            for (MJKProductShowModel *saveModel in weakSelf.productArray) {
                total += saveModel.B_HDJ.integerValue * saveModel.number;
                shopCount += saveModel.number;
            }
            weakSelf.totalMoneyLabel.text = [NSString stringWithFormat:@"¥ %ld",(long)total];
            
            if (total == 0) {
                weakSelf.shoppingMallImageView.image = [UIImage imageNamed:@"购物车-未选中"];
                [weakSelf.shoppingMallImageView pp_hiddenBadge];
            } else {
                weakSelf.shoppingMallImageView.image = [UIImage imageNamed:@"购物车-选中"];
                [weakSelf.shoppingMallImageView pp_moveBadgeWithX:-5 Y:5];
                [weakSelf.shoppingMallImageView pp_addBadgeWithNumber:shopCount];
            }
            
            if (model.number == 0) {
                [weakSelf.productArray removeObject:model];
                weakSelf.shoppingCartTableHeighrLayout.constant = weakSelf.productArray.count * 60 + 40;
                [weakSelf.shoppingCartTabelView reloadData];
            } else {
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            [weakSelf.mainTabelView reloadData];
        };
        
        cell.priceChangeBlock = ^{
            NSInteger total = 0;
            for (MJKProductShowModel *saveModel in weakSelf.productArray) {
                total += saveModel.B_HDJ.integerValue * saveModel.number;
            }
            weakSelf.totalMoneyLabel.text = [NSString stringWithFormat:@"¥ %ld",(long)total];
        };
        return cell;
    } else if (tableView == self.typeTableView) {
        CustomerLvevelNextFollowModel *model = self.categoryArray[indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"typeCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"typeCell"];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:12.f];
        cell.backgroundColor = [UIColor colorWithHex:@"#efeff4"];
        cell.textLabel.text = model.C_NAME;
        return cell;
    } else {
        MJKProductShowModel *model = self.mainShowArray[indexPath.row];
        MJKProductShowTableViewCell *cell = [MJKProductShowTableViewCell cellWithTableView:tableView];
        cell.model = model;
        if (self.productArray.count > 0) {
            cell.productArray = self.productArray;
        }
        cell.addOrSubProductActionBlock = ^(NSString * _Nonnull typeStr) {
            if ([typeStr isEqualToString:@"+"]) {
                if (weakSelf.productArray.count > 0) {
                    //把所有ID取出来转成字符串，然后判断转成的ID字符串是否包含当前ID，包含就+1不包含就add
                    NSMutableArray *cidArray = [NSMutableArray array];
                    for (MJKProductShowModel *saveModel in weakSelf.productArray) {
                        [cidArray addObject:saveModel.C_ID];
                    }
                    NSString *cidStr = [cidArray componentsJoinedByString:@","];
                    if ([cidStr rangeOfString:model.C_ID].location == NSNotFound) {
                        model.number = 1;
                        [weakSelf.productArray addObject:[model copy]];
                    } else {
                        for (MJKProductShowModel *saveModel in weakSelf.productArray) {
                            if ([saveModel.C_ID isEqualToString:model.C_ID]) {
                                saveModel.number += 1;
                            }
                        }
                    }

                } else {
                    model.number = 1;
                    [weakSelf.productArray addObject:[model copy]];
                }
            } else {
                //把所有ID取出来转成字符串，然后判断转成的ID字符串是否包含当前ID，包含就+1不包含就add
                NSMutableArray *cidArray = [NSMutableArray array];
                for (MJKProductShowModel *saveModel in weakSelf.productArray) {
                    [cidArray addObject:saveModel.C_ID];
                }
                NSString *cidStr = [cidArray componentsJoinedByString:@","];
                if ([cidStr rangeOfString:model.C_ID].location != NSNotFound) {
                    NSArray *tempArr = [NSArray arrayWithArray:weakSelf.productArray];
                    for (MJKProductShowModel *saveModel in tempArr) {
                        if ([saveModel.C_ID isEqualToString:model.C_ID]) {
                            saveModel.number -= 1;
                            if (saveModel.number == 0) {
                                [weakSelf.productArray removeObject:saveModel];
                            }
                        }
                    }
                }
                
            }
            
            NSInteger total = 0;
            NSInteger shopCount = 0;
            for (MJKProductShowModel *saveModel in weakSelf.productArray) {
                total += saveModel.B_HDJ.integerValue * saveModel.number;
                shopCount += saveModel.number;
            }
            weakSelf.totalMoneyLabel.text = [NSString stringWithFormat:@"¥ %ld",(long)total];
            
            if (total == 0) {
                weakSelf.shoppingMallImageView.image = [UIImage imageNamed:@"购物车-未选中"];
                [weakSelf.shoppingMallImageView pp_hiddenBadge];
            } else {
                weakSelf.shoppingMallImageView.image = [UIImage imageNamed:@"购物车-选中"];
                [weakSelf.shoppingMallImageView pp_moveBadgeWithX:-5 Y:5];
                [weakSelf.shoppingMallImageView pp_addBadgeWithNumber:shopCount];
            }
            
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.typeTableView) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        if (self.categoryArray.count > 0) {
            CustomerLvevelNextFollowModel *model = self.categoryArray[indexPath.row];
            self.C_TYPE_DD_ID = model.C_ID;
            self.C_PICTURE_SHOW = model.C_PICTURE_SHOW;
        }
        [self.mainTabelView.mj_header beginRefreshing];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.shoppingCartTabelView) {
        MJKProductShowModel *model = self.productArray[indexPath.row];
        CGSize size = [model.C_NAME boundingRectWithSize:CGSizeMake(KScreenWidth - 238, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10.f]} context:nil].size;
        if (40 + size.height > 70) {
            
            return 40 + size.height + 10;
        } else {
            return 80;
        }
    } else if (tableView == self.typeTableView) {
        return 30;
    } else {
        return 80;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.shoppingCartTabelView) {
        return 30;
    }
    return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.shoppingCartTabelView) {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
        bgView.backgroundColor = [UIColor whiteColor];
        
        UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 150, 30)];
        headLabel.textColor = [UIColor grayColor];
        headLabel.font = [UIFont systemFontOfSize:14.f];
        headLabel.text = @"已选产品";
        [bgView addSubview:headLabel];
        
        UIButton *footButton = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth - 10 - 60, 0, 60, 30)];
        [footButton setTitleNormal:@"清空"];
        [footButton setTitleColor:[UIColor grayColor]];
        [footButton setContentMode:UIViewContentModeRight];
        footButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [footButton addTarget:self action:@selector(clearAction:)];
        [bgView addSubview:footButton];
        
        return bgView;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [super keyboardWillHide:notification];
    if (self.searchTableView.hidden == YES) {
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    self.view.frame = frame;
    }
}

- (void)keyboardWillShow:(NSNotification *)notification {
    [super keyboardWillShow:notification];
    if (self.searchTableView.hidden == YES) {
        CGRect frame = self.view.frame;
        frame.origin.y = -300;
        self.view.frame = frame;
    }
}

//MARK:-点击购物车图标弹出tableview
- (IBAction)tapShoppingMallImage:(UITapGestureRecognizer *)sender {
    self.shoppingCartTabelView.hidden = !self.shoppingCartTabelView.isHidden;
    self.shoppingCartBGView.hidden = self.shoppingCartTabelView.isHidden;
    if (self.productArray.count * 60 + 60 > 260) {
        self.shoppingCartTableHeighrLayout.constant = 280;
    } else {
        self.shoppingCartTableHeighrLayout.constant = self.productArray.count * 80 + 60;
    }
    [self.shoppingCartTabelView reloadData];
}

//MARK:点击背景购物车图标弹出的tableview
- (IBAction)hiddenShoppingCart:(UITapGestureRecognizer *)sender {
    self.shoppingCartTabelView.hidden = YES;
    self.shoppingCartBGView.hidden = YES;
    [self.shoppingCartTabelView reloadData];
}

//MARK:清空购物车
- (void)clearAction:(UIButton *)sender {
    [self.productArray removeAllObjects];
    [self.shoppingCartTabelView reloadData];
    [self.mainTabelView reloadData];
    self.shoppingCartTabelView.hidden = YES;
    self.shoppingCartBGView.hidden = YES;
    [self.shoppingMallImageView pp_hiddenBadge];
    self.shoppingMallImageView.image = [UIImage imageNamed:@"购物车-未选中"];
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"¥ 0"];
}

#pragma mark - http get data
//  获取分类列表
- (void)getActivityCategory {
    DBSelf(weakSelf);
    
    NSDictionary*contentDic=[NSMutableDictionary dictionary];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:HTTP_SYSTEMD706PPLIST parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.categoryArray = [CustomerLvevelNextFollowModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"list"]];
            [weakSelf.typeTableView reloadData];
            //默认选择中第一行
            [weakSelf.typeTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            [weakSelf tableView:weakSelf.typeTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
    }];
    
}

- (void)HTTPGetProductList {//获取订单列表
    DBSelf(weakSelf);
    
    NSMutableDictionary *contentDic=[NSMutableDictionary new];
    
    HttpManager*manager=[[HttpManager alloc]init];
    contentDic[@"C_TYPE_DD_ID"] = self.C_TYPE_DD_ID;
    [manager getNewDataFromNetworkNOHUDWithUrl:HTTP_SYSTEMD496PPLIST parameters:contentDic compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
            weakSelf.mainShowArray = [MJKProductShowModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"list"]];
            for (MJKProductShowModel *model in weakSelf.mainShowArray) {
                model.X_FMPICURL = weakSelf.C_PICTURE_SHOW;
            }
            if (self.isSearch == YES) {
                [weakSelf.searchTableView reloadData];
            } else {
                [weakSelf.mainTabelView reloadData];
            }
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
        [weakSelf.mainTabelView.mj_header endRefreshing];
        [weakSelf.mainTabelView.mj_footer endRefreshing];
        [weakSelf.searchTableView.mj_header endRefreshing];
        [weakSelf.searchTableView.mj_footer endRefreshing];
    }];
    
}

- (IBAction)commitButtonAction:(UIButton *)sender {
//    if (self.productArray.count > 0) {
        if (self.chooseProductBlock) {
            self.chooseProductBlock(self.productArray);
        }
    [self.navigationController popViewControllerAnimated:YES];
//    } else {
//        [JRToast showWithText:@"请选择产品"];
//    }
}

#pragma mark - set
- (NSMutableArray *)typeArray {
    if (!_typeArray) {
        _typeArray = [NSMutableArray array];
        for (MJKDataDicModel*model in [[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A49600_C_TYPE"]) {
            [_typeArray addObject:@{@"C_TYPE_DD_ID" : model.C_VOUCHERID, @"C_NAME" : model.C_NAME}];
        }
    }
    return _typeArray;
}

- (NSMutableArray *)productArray {
    if (!_productArray) {
        _productArray = [NSMutableArray array];
        
    }
    return _productArray;
}


@end
