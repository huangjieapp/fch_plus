//
//  MJKAddMessageViewController.m
//  Rebuild_newMJK
//
//  Created by mac on 2018/6/19.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKAddMessageViewController.h"

#import "AddCustomerInputTableViewCell.h"
#import "CGCNewAppointTextCell.h"


#define CELL0    @"AddCustomerInputTableViewCell"
#define CELL1    @"CGCNewAppointTextCell"

@interface MJKAddMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)NSString*titleStr;
@property(nonatomic,strong)NSString*contentStr;
@property(nonatomic,assign)BOOL canSave;

@end

@implementation MJKAddMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"新增话术模板";
    [self setupNavi];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
    [self.tableView registerNib:[UINib nibWithNibName:CELL1 bundle:nil] forCellReuseIdentifier:CELL1];
    
    
}

#pragma mark  --UI
-(void)setupNavi{
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(ClickComplete)];
	item.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem=item;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        AddCustomerInputTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
        cell.nameTitleLabel.text=@"标题";
        cell.changeTextBlock = ^(NSString *textStr) {
            MyLog(@"%@",textStr);
            self.titleStr=textStr;
            
        };
        
        return cell;
    }else{
        CGCNewAppointTextCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL1];
        cell.topTitleLabel.text=@"内容";
        cell.changeTextBlock = ^(NSString *textStr) {
            MyLog(@"%@",textStr);
            self.contentStr=textStr;
        };
        
        return cell;
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 44;
    }else{
        return 150;
        
    }
    
}



#pragma mark  --touch
-(void)ClickComplete{
    NSString*judgeStr=[self judgeSave];
    if (!_canSave) {
        [JRToast showWithText:judgeStr];
        return;
    }
    
    
    [self HTTPAddMineMessageRequest];
    
    
}

#pragma mark -- 添加我的常用模板
-(void)HTTPAddMineMessageRequest
{
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_CGC_saveBeanId];
    
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
//    [dic setObject:@"" forKey:@"C_ID"];
    if (self.titleStr.length > 0) {
        [dic setObject:self.titleStr forKey:@"C_NAME"];
    }
    if (self.contentStr.length > 0) {
        [dic setObject:self.contentStr forKey:@"X_PICCONTENT"];
    }
//    [dic setObject:@"" forKey:@"X_PICCONTENT"];
//    [dic setObject:@"" forKey:@"X_NAME"];
    [dict setObject:dic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    
    
    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        
        if ([data[@"code"] integerValue]==200) {
            if (self.backAdd) {
                self.backAdd();
            }
            [self.navigationController popViewControllerAnimated:YES];
//            [self HTTPGetTemplateListWithType:0];
            
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
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.estimatedRowHeight=0;
        _tableView.estimatedSectionHeaderHeight=0;
        _tableView.estimatedSectionFooterHeight=0;
    }
    
    return _tableView;
}


#pragma mark  --funcation
-(NSString*)judgeSave{
    _canSave=YES;
    if (self.titleStr.length<1) {
        _canSave=NO;
        return @"标题不能为空";
    }else if (self.contentStr.length<1){
        _canSave=NO;
        return @"内容不能为空";
    }
    
    
    
    return nil;
}


#pragma mark  隐藏键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
}

//touch began
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
}


- (UIView*)findFirstResponderBeneathView:(UIView*)view
{
    // Search recursively for first responder
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] )
            return childView;
        UIView *result = [self findFirstResponderBeneathView:childView];
        if ( result )
            return result;
    }
    return nil;
}

@end

