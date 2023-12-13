//
//  DGJRegisterViewController.m
//  mcr_manageShop
//
//  Created by 黄佳峰 on 2017/9/11.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "DGJRegisterViewController.h"
#import "DGJRegisterTableViewCell.h"
#import "AddCustomerChooseTableViewCell.h"


#define CELL0   @"DGJRegisterTableViewCell"
#define CELL1   @"AddCustomerChooseTableViewCell"

@interface DGJRegisterViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView*tableView;

@property(nonatomic,strong)NSMutableArray*locateDatas;
@property(nonatomic,strong)NSString*saveChoosedType;
@property(nonatomic,assign)BOOL canSave;

@end

@implementation DGJRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
    [self.tableView registerNib:[UINib nibWithNibName:CELL1 bundle:nil] forCellReuseIdentifier:CELL1];
    self.title=@"申请入驻";
    [self addRightItem];
	
   [self setContentUs];
}

- (void)setContentUs {
	UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, KScreenHeight - 60 - SafeAreaBottomHeight, KScreenWidth, 60)];
	label.text = @"联系我们 (021)55698681\n工作时间 周一至周五(09:00-18:00)";
	[label setNumberOfLines:3];
	label.textAlignment = NSTextAlignmentCenter;
	label.font = [UIFont systemFontOfSize:14.f];
	label.textColor = [UIColor blackColor];
	[self.view addSubview:label];
}

-(void)addRightItem{

    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [button setBackgroundImage:[UIImage imageNamed:@"icon_dismiss"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickDismiss)];
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem=item;
    
    
}

#pragma mark  --UI
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.locateDatas.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DGJRegisterTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.nameLabel.text=self.locateDatas[indexPath.row];
    cell.inputTextField.keyboardType=UIKeyboardTypeDefault;
    cell.showTagLabel.hidden=NO;
    
    
    if (indexPath.row==1) {
        AddCustomerChooseTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL1];
        cell.taglabel.hidden=NO;
        cell.nameTitleLabel.text=self.locateDatas[indexPath.row];
        cell.nameTitleLabel.font=[UIFont systemFontOfSize:17];
        cell.nameTitleLabel.textColor=[UIColor blackColor];
        
        cell.chooseTextField.placeholder=@"请选择";
        cell.Type=CHooseTableViewTypeApplyEnter;
        cell.chooseBlock = ^(NSString *str, NSString *postValue) {
            MyLog(@"%@,%@",str,postValue);
            self.saveChoosedType=postValue;
            
        };
        
        return cell;
    }
    
    
    
    
    
    if (indexPath.row==4||indexPath.row==5) {
        cell.showTagLabel.hidden=YES;
    }else{
        cell.showTagLabel.hidden=NO;
    }
    
    
    if (indexPath.row==3) {
        //电话
        cell.inputTextField.keyboardType=UIKeyboardTypePhonePad;
    }
    
    
    return cell;
}


-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView*mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 60)];
    mainView.backgroundColor=[UIColor clearColor];
    
    UIButton*commitButton=[[UIButton alloc]initWithFrame:CGRectMake(15, 20, KScreenWidth-30, 40)];
    [commitButton setTitleNormal:@"提交"];
    [commitButton setTitleColor:[UIColor blackColor]];
    [commitButton setBackgroundColor:KNaviColor];
    [commitButton addTarget:self action:@selector(clickCommit)];
    
    [mainView addSubview:commitButton];
    
    
    return mainView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 20;
    }else{
        return 0.001;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 60;
    }else{
        return 0.001;
    }

    
}

#pragma mark  -- delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [[DBTools findFirstResponderBeneathView:self.view] resignFirstResponder];
    
}


#pragma mark  --click
-(void)clickCommit{
    MyLog(@"1");
    
   NSString*errorStr=[self judgeCanSave];
    if (!_canSave) {
        [JRToast showWithText:errorStr];
        return;
    }
    
    //吊接口 提交
    [self getDatasCommit];
    
    
    
}

-(void)clickDismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



#pragma mark  --datas
-(void)getDatasCommit{
     [[DBTools findFirstResponderBeneathView:self.view] resignFirstResponder];
    
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
    for (int i=0; i<self.locateDatas.count; i++) {
        NSString*currentStr;
        if (i==1) {
            AddCustomerChooseTableViewCell*cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            currentStr=cell.chooseTextField.text;
        }else{
            DGJRegisterTableViewCell*cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            currentStr=cell.inputTextField.text;
        }
        
        
        if (i==0&&currentStr&&![currentStr isEqualToString:@""]) {
            [contentDict setObject:currentStr forKey:@"C_NAME"];
            
        }else if (i==1&&currentStr&&![currentStr isEqualToString:@""]&&self.saveChoosedType){
             [contentDict setObject:self.saveChoosedType forKey:@"C_TYPE_DD_ID"];
            
        }else if (i==2&&currentStr&&![currentStr isEqualToString:@""]){
             [contentDict setObject:currentStr forKey:@"C_LINKMAN"];
            
        }else if (i==3&&currentStr&&![currentStr isEqualToString:@""]){
            [contentDict setObject:currentStr forKey:@"C_CONTACT"];
            
        }else if (i==4&&currentStr&&![currentStr isEqualToString:@""]){
            [contentDict setObject:currentStr forKey:@"C_EMAIL"];
            
        }else if (i==5&&currentStr&&![currentStr isEqualToString:@""]){
            [contentDict setObject:currentStr forKey:@"X_REMARK"];
            
        }
        
        
        
        
    }
    
    
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/system/a423/add", HTTP_IP] parameters:contentDict compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            [JRToast showWithText:data[@"msg"]];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [JRToast showWithText:data[@"msg"]];
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
        _tableView=[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.estimatedRowHeight=0;
        _tableView.estimatedSectionHeaderHeight=0;
        _tableView.estimatedSectionFooterHeight=0;
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
    }
    
    return _tableView;
    
}

-(NSMutableArray *)locateDatas{
    if (!_locateDatas) {
        _locateDatas=[NSMutableArray array];
        NSArray*array=@[@"商家名称",@"服务类型",@"商家联系人",@"手机号",@"地址",@"备注"];
        [_locateDatas addObjectsFromArray:array];
        
    }
    return _locateDatas;
}


#pragma mark  -- funcation
-(NSString*)judgeCanSave{
    _canSave=YES;
    
    for (int i=0; i<self.locateDatas.count-1; i++) {
        NSString*currentStr;
        if (i==1) {
            AddCustomerChooseTableViewCell*cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            currentStr=cell.chooseTextField.text;
        }else{
            DGJRegisterTableViewCell*cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            currentStr=cell.inputTextField.text;
        }
        
       
        if (i==0&&currentStr.length<1) {
            _canSave=NO;
            return @"商家名称不能为空";
        }else if (i==1&&currentStr.length<1){
            _canSave=NO;
            return @"服务类型不能为空";
        }else if (i==2&&currentStr.length<1){
            _canSave=NO;
            return @"商家联系人不能为空";
        }else if (i==3&&currentStr.length!=11){
            _canSave=NO;
            return @"手机号不正确";
        }

    }
    
     return @"...";
}


@end
