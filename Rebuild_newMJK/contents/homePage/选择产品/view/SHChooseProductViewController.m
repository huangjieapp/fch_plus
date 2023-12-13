//
//  SHChooseProductViewController.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/14.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "SHChooseProductViewController.h"
#import "SHChooseProductTableViewCell.h"
#import "ChooseProductHeader.h"



#define CELL0    @"SHChooseProductTableViewCell"
#define HEADER   @"ChooseProductHeader"
@interface SHChooseProductViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)NSMutableArray*allDatas;
@end

@implementation SHChooseProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"产品列表";
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
    [self.tableView registerNib:[UINib nibWithNibName:HEADER bundle:nil] forHeaderFooterViewReuseIdentifier:HEADER];
    [self makeUI];

    
}

#pragma mark--UI
-(void)makeUI{
    UIButton*sanfButton=[[UIButton alloc]initWithFrame:CGRectMake(20, KScreenHeight-200+20, KScreenWidth-40, 40)];
    sanfButton.backgroundColor=KNaviColor;
    [sanfButton setTitle:@"扫描二维码"];
    [sanfButton addTarget:self action:@selector(clickSanf)];
    [self.view addSubview:sanfButton];
    
    
    UIButton*manualInput=[[UIButton alloc]initWithFrame:CGRectMake(20, sanfButton.bottom+20, KScreenWidth-40, 40)];
    manualInput.backgroundColor=KNaviColor;
    [manualInput setTitle:@"手动输入"];
    [manualInput addTarget:self action:@selector(clickManual)];
    [self.view addSubview:manualInput];
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SHChooseProductTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
    
    return cell;
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ChooseProductHeader*header=[self.tableView dequeueReusableHeaderFooterViewWithIdentifier:HEADER];
    
    return header;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0){
    UITableViewRowAction*action0=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
       
        
    }];
    UITableViewRowAction*action1=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"修改数量" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
    }];
    
    return @[action0,action1];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 40;
    }
    
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}



#pragma mark  --click
-(void)clickSanf{
    MyLog(@"扫描");
    
}
-(void)clickManual{
    MyLog(@"手动输入");
    UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:@"提示" message:@"请输入意向产品编号码" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        
        
    }];
    
    UIAlertAction*cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction*sure=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField*textField=alertVC.textFields.firstObject;
        if (textField.text.length<1) {
            [JRToast showWithText:@"请输入产品编号码"];
            return ;
        }else{
            [self addProductWith:textField.text];
            
        }
        
    }];
   
    [alertVC addAction:cancel];
    [alertVC addAction:sure];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

#pragma mark  --getDatas
-(void)addProductWith:(NSString*)productID{
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
   NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:HTTP_AddProduct];
    NSDictionary*dict=@{@"C_VOUCHERID":productID};
    [mainDict setObject:dict forKey:@"content"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:urlStr parameters:mainDict compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        
        
        
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
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-200) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}

//-(NSMutableArray *)allDatas{
//    
//    
//}

@end
