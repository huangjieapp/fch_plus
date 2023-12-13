//
//  SHDealDetailViewController.m
//  Mcr_2
//
//  Created by 黄佳峰 on 2017/6/15.
//  Copyright © 2017年 bipi. All rights reserved.
//

#import "SHDealDetailViewController.h"
#import "SHDealDetailHeaderView.h"
#import "DealDetailTableViewCell.h"



#define CELLHEADER   @"SHDealDetailHeaderView"
#define CELL0        @"DealDetailTableViewCell"


@interface SHDealDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView*tableView;

@property(nonatomic,assign)NSInteger pagen;
@property(nonatomic,assign)NSInteger pages;
@property(nonatomic,strong)NSMutableArray*mainModelArray;

@end

@implementation SHDealDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title=@"交易明细";
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:CELLHEADER bundle:nil] forHeaderFooterViewReuseIdentifier:CELLHEADER];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
    
    [self addRefresh];
    
    
    
    
}

#pragma mark  --UI

-(void)addAlertVC{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"本次输入可能造成与当前明细不再匹配" preferredStyle:UIAlertControllerStyleAlert];
    //增加确定按钮；
    
    UIAlertAction*sure=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //获取第1个输入框；
        UITextField *userNameTextField = alertController.textFields.firstObject;
        
        //获取第2个输入框；
        UITextField *passwordTextField = alertController.textFields[1];
        UITextField *third = alertController.textFields[2];
        UITextField *four = alertController.textFields.lastObject;
        
        
        if (userNameTextField.text.length<3) {
            [JRToast showWithText:@"不合格啊"];
            [self presentViewController:alertController animated:YES completion:nil];
        }else{
            [JRToast showWithText:@"成功"];
        }
        
        
        //        NSLog(@"用户名 = %@，密码 = %@",userNameTextField.text,passwordTextField.text);
        
    }];
    [alertController addAction:sure];
    
    
    //增加取消按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    //定义第一个输入框；
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"收款总额";

    }];
    //定义第二个输入框；
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"收款笔数";
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder=@"关账说明";
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder=@"关账人";
    }];
    
    
    [self presentViewController:alertController animated:true completion:nil];
    
    
}




-(void)addRefresh{
    self.pagen=30;
    self.pages=0;
    
    __weak typeof(self)weakSelf=self;
    MJRefreshNormalHeader*header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pages=0;
        [weakSelf getMainDatas];
        
    }];
    self.tableView.mj_header=header;
    
    
    MJRefreshBackNormalFooter*footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _pages++;
        [weakSelf getMainDatas];
        
    }];
    self.tableView.mj_footer=footer;
    
    [self.tableView.mj_header beginRefreshing];
    
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DealDetailTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
    cell.selectionStyle=NO;
    return cell;
    
    return nil;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SHDealDetailHeaderView*view=[tableView dequeueReusableHeaderFooterViewWithIdentifier:CELLHEADER];
    
    view.clickChangeBlock=^(){
        
        [self addAlertVC];
    };
    
    
    view.clickAddBlock=^(){
        
        
    };
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 145;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark  --getDatas
-(void)getMainDatas{
    NSArray*array=@[@"",@"",@"",@"",@""];
    [self.mainModelArray addObjectsFromArray:array];
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
}


#pragma mark --set
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}


-(NSMutableArray *)mainModelArray{
    if (!_mainModelArray) {
        _mainModelArray=[NSMutableArray array];
    }
    
    return _mainModelArray;
}

@end
