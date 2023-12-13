//
//  MJKProductChooseViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/3/25.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKNewProductChooseViewController.h"

#import "MJKSaleCarSourceTableViewCell.h"
#import "MJKShoppingCartCell.h"

#import "MJKProductShowModel.h"

#import "CGCNavSearchTextView.h"
#import "VoiceView.h"

#import "CustomerLvevelNextFollowModel.h"

@interface MJKNewProductChooseViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *typeTableView;//左边选择类型tableview
@property (weak, nonatomic) IBOutlet UITableView *mainTabelView;//右边显示产品tableview
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeTopLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainTopLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchTopLayout;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayout;


@property(nonatomic,strong)CGCNavSearchTextView*CurrentTitleView;  //不做属性 警告。。
/** VoiceView*/
@property (nonatomic, strong) VoiceView *vv;

/** type array*/
@property (nonatomic, strong) NSMutableArray *typeArray;

/** pagen*/
@property (nonatomic, assign) NSInteger pagen;

/** C_TYPE_DD_ID*/
@property (nonatomic, strong) NSString *C_TYPE_DD_ID;
@property (nonatomic, strong) NSString *tempModelType;
@property (nonatomic, strong) NSString *C_PICTURE_SHOW;
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

@implementation MJKNewProductChooseViewController

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
    
//    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc]initWithCustomView:scanButton], [[UIBarButtonItem alloc]initWithCustomView:searchButton]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:searchButton];
    
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
    if (tableView == self.typeTableView) {
        return self.categoryArray.count;
    } else {
        return self.mainShowArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    if (tableView == self.typeTableView) {
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
        MJKSaleCarSourceTableViewCell *cell = [MJKSaleCarSourceTableViewCell cellWithTableView:tableView];
        cell.model = model;
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
   if (tableView == self.typeTableView) {
        return 30;
    } else {
        return 80;
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
    for (MJKProductShowModel *model in self.mainShowArray) {
        if (model.isSelected == YES) {
            if (self.chooseProductBlock) {
                self.chooseProductBlock(model);
            }
        }
    }
    [self.navigationController popViewControllerAnimated:YES];

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
