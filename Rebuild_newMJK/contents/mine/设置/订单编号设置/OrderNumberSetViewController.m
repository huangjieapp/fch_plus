//
//  OrderNumberSetViewController.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/9/22.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "OrderNumberSetViewController.h"
#import "OrderNumberSetTableViewCell.h"

#define CELL0   @"OrderNumberSetTableViewCell"

@interface OrderNumberSetViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView*tableView;

@property(nonatomic,strong)NSString*NumberPrefixStr;
@property(nonatomic,strong)NSString*NumberLengthStr;
/** 手动还是自动*/
@property(nonatomic,strong) NSString *C_ISSSDDBH_DD_ID;
/** 订单编号起始*/
@property(nonatomic,strong) NSString*I_TYPE;
/** <#注释#>*/
@property(nonatomic,strong) UISegmentedControl *control;

@end

@implementation OrderNumberSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (@available(iOS 11.0, *)) {
		self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}else {
		self.automaticallyAdjustsScrollViewInsets = NO;
	}
	
    self.title=@"订单编号设置";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
//    self.C_ISSSDDBH_DD_ID = @"A40300_C_ISSSDDBH_0000";
    UISegmentedControl *control = [[UISegmentedControl alloc]initWithItems:@[@"手动设置",@"自动设置"]];
    [control addTarget:self action:@selector(selectSegment:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:control];
    control.tintColor = KNaviColor;
    if ( [[NewUserSession instance].C_ISSSDDBH_DD_ID isEqualToString:@"A40300_C_ISSSDDBH_0000"]) {
        control.selectedSegmentIndex = 0;
        self.C_ISSSDDBH_DD_ID = @"A40300_C_ISSSDDBH_0000";
        self.tableView.hidden = YES;
    } else {
        control.selectedSegmentIndex = 1;
        self.C_ISSSDDBH_DD_ID = @"A40300_C_ISSSDDBH_0002";
        self.tableView.hidden = NO;
    }
    self.control = control;
    control.frame = CGRectMake(20, NavStatusHeight + 10, KScreenWidth - 40, 30);
    
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
    
    
    [self setUpRightNaviItem];
    
    [self httpPostGetValue];
}

- (void)selectSegment:(UISegmentedControl *)sender  {
    if (sender.selectedSegmentIndex == 0) {
        self.tableView.hidden = YES;
        self.navigationItem.rightBarButtonItem.customView.hidden = YES;
        self.C_ISSSDDBH_DD_ID = @"A40300_C_ISSSDDBH_0000";
    } else if (sender.selectedSegmentIndex == 1) {
        self.tableView.hidden = NO;
        self.navigationItem.rightBarButtonItem.customView.hidden = NO;
        self.C_ISSSDDBH_DD_ID = @"A40300_C_ISSSDDBH_0002";
    }
    [self httpPostChangeOrderNumberSet];
}

#pragma mark  --UI
-(void)setUpRightNaviItem{
    UIButton*rightButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [rightButton setTitle:@"修改" forState:UIControlStateNormal];
    [rightButton setTitle:@"完成" forState:UIControlStateSelected];
    rightButton.titleLabel.font=[UIFont systemFontOfSize:16];
    rightButton.titleLabel.textAlignment=NSTextAlignmentRight;
    [rightButton addTarget:self action:@selector(clickRightButton:)];
    
    UIBarButtonItem*rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem=rightItem;
//    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
	
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderNumberSetTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
    if (indexPath.row==0) {
		NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:@"编号前缀*"];
		[attStr setAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} range:NSMakeRange(attStr.length - 1, 1)];
        cell.titleLab.attributedText=attStr;
        cell.TextFie.text=self.NumberPrefixStr;
        cell.TextFie.keyboardType=UIKeyboardTypeDefault;
        cell.changeTextFieBlock = ^(NSString *textStr) {
            self.NumberPrefixStr=textStr;
            
        };
        
        
    }else if (indexPath.row==1) {
		NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:@"后缀长度*"];
		[attStr setAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} range:NSMakeRange(attStr.length - 1, 1)];
        cell.titleLab.attributedText=attStr;
         cell.TextFie.text=self.NumberLengthStr;
        cell.TextFie.keyboardType=UIKeyboardTypeNumberPad;
        cell.changeTextFieBlock = ^(NSString *textStr) {
            self.NumberLengthStr=textStr;
        };
        
    } else {
		NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:@"起始号*"];
		[attStr setAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} range:NSMakeRange(attStr.length - 1, 1)];
        cell.titleLab.attributedText=attStr;
        cell.TextFie.text=self.I_TYPE;
        cell.TextFie.keyboardType=UIKeyboardTypeNumberPad;
        cell.changeTextFieBlock = ^(NSString *textStr) {
            self.I_TYPE=textStr;
        };
    }
    cell.TextFie.enabled=NO;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return nil;
}

#pragma mark  --click
-(void)clickRightButton:(UIButton*)sender{
    sender.selected=!sender.selected;
    
    OrderNumberSetTableViewCell*FirstCell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    OrderNumberSetTableViewCell*secondCell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    OrderNumberSetTableViewCell*thridCell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    if (sender.selected) {
        //点击之后是 选中状态    那么跳编辑   cell 0 成为第一响应
        FirstCell.TextFie.enabled=YES;
        [FirstCell.TextFie becomeFirstResponder];
        secondCell.TextFie.enabled=YES;
        thridCell.TextFie.enabled = YES;
        
        
    }else{
		if (self.NumberPrefixStr.length <= 0) {
			[JRToast showWithText:@"请输入前缀"];
			return;
		}
		if (self.NumberLengthStr.length <= 0) {
			[JRToast showWithText:@"请输入后缀长度"];
			return;
		}
		if (self.I_TYPE.length <= 0) {
			[JRToast showWithText:@"请输入起始号"];
			return;
		}
        //完成  吊接口
        FirstCell.TextFie.enabled=NO;
        [FirstCell.TextFie resignFirstResponder];
        secondCell.TextFie.enabled=NO;
        [secondCell.TextFie resignFirstResponder];
        thridCell.TextFie.enabled = NO;
        [thridCell.TextFie resignFirstResponder];
        [self httpPostChangeOrderNumberSet];
        
    }
    
    
}


#pragma mark  --getDatas
-(void)httpPostGetValue{
    NSMutableDictionary*mtDict=[DBObjectTools getAddressDicWithAction:HTTP_ShowOrderNumberSet];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mtDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            self.NumberPrefixStr=data[@"C_ABBREVIATION"];
            self.NumberLengthStr=data[@"I_STORENUMBER"];
            self.I_TYPE = data[@"I_TYPE"];
            [NewUserSession instance].C_ISSSDDBH_DD_ID = data[@"C_ISSSDDBH_DD_ID"];
            [self.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
    }];
    
    
    
    
}



-(void)httpPostChangeOrderNumberSet{
    NSMutableDictionary*mtDict=[DBObjectTools getAddressDicWithAction:HTTP_ChangeOrderPrefixSet];
    NSMutableDictionary*contentDict = [NSMutableDictionary dictionary];
    if (self.NumberPrefixStr.length > 0) {
        contentDict[@"C_ABBREVIATION"] = self.NumberPrefixStr;
    }
    if (self.NumberLengthStr.length > 0) {
        contentDict[@"I_STORENUMBER"] = self.NumberLengthStr;
    }
    
    if (self.C_ISSSDDBH_DD_ID.length > 0) {
        contentDict[@"C_ISSSDDBH_DD_ID"] = self.C_ISSSDDBH_DD_ID;
    }
    
    if (self.I_TYPE.length > 0) {
        contentDict[@"I_TYPE"] = self.I_TYPE;
    }
//    NSDictionary*contentDict=@{@"C_ABBREVIATION":self.NumberPrefixStr,@"I_STORENUMBER":self.NumberLengthStr};
    [mtDict setObject:contentDict forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mtDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            
//            [JRToast showWithText:data[@"message"]];
            [self httpPostGetValue];
//            [self.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
    }];

    
    
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

#pragma mark  --set
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight + 10 + 10 + 30, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.estimatedRowHeight=0;
        _tableView.estimatedSectionHeaderHeight=0;
        _tableView.estimatedSectionFooterHeight=0;
    }
    return _tableView;
}


@end
