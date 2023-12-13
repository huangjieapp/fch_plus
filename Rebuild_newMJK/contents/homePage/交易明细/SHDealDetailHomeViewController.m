//
//  SHDealDetailHomeViewController.m
//  Mcr_2
//
//  Created by 黄佳峰 on 2017/6/15.
//  Copyright © 2017年 bipi. All rights reserved.
//

#import "SHDealDetailHomeViewController.h"
#import "SHFirstDealDetailHeaderView.h"
#import "SHFirstDealDetailTableViewCell.h"
#import "SHFirstDealModel.h"


#import "SHDealDetailViewController.h"


#define CELLHEADER   @"SHFirstDealDetailHeaderView"
#define CELL0        @"SHFirstDealDetailTableViewCell"

@interface SHDealDetailHomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*tableView;


@property(nonatomic,assign)NSInteger pagen;
@property(nonatomic,assign)NSInteger pages;
@property(nonatomic,strong)SHFirstDealModel*mainModel;  // 自己的mdel
@property(nonatomic,strong)NSMutableArray*mainModelArray;  //存放了 content 中的内容

@end

@implementation SHDealDetailHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title=@"交易明细";
    [self.view addSubview:self.tableView];
    [self addRefresh];
    
    [self.tableView registerNib:[UINib nibWithNibName:CELLHEADER bundle:nil] forHeaderFooterViewReuseIdentifier:CELLHEADER];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
    
    
    [self addRightBarButton];
}

#pragma mark  --UI
-(void)addRightBarButton{
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 25)];
    [button setTitle:@"报表"];
    [button addTarget:self action:@selector(clickRightButton)];
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem=item;
    
}


-(void)addRefresh{
    _pages=1;
    _pagen=10;
    DBSelf(weakSelf);
    MJRefreshNormalHeader*header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pages=1;
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
//    if (self.mainModelArray.count>0) {
//        return 1;
//    }else{
//        return 0;
//    }
    
    
    if (self.mainModel) {
         return 1;
    }else{
        return 0;
    }
   
   
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mainModelArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SHFirstDealDetailTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];

    cell.selectionStyle=NO;
    
    SHFirstDealSubModel*partModel=self.mainModelArray[indexPath.row];
    
    
    
   
    cell.model=partModel;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    SHDealDetailViewController*vc=[[SHDealDetailViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
//    self.mainModel[@"content"][0]  [@"content"] [indexPath.row]  最后是个3key的字典
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SHFirstDealDetailHeaderView*view=[tableView dequeueReusableHeaderFooterViewWithIdentifier:CELLHEADER];
    view.model=self.mainModel;
    
    
    view.backgroundColor=[UIColor whiteColor];
    UIImage*whiteImage=[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)];
    view.backgroundView=[[UIImageView alloc]initWithImage:whiteImage];
    return view;
    
}





-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 140;
}


#pragma mark  --touch
-(void)clickRightButton{
    MyLog(@"xx");
    SHDealDetailViewController*vc=[[SHDealDetailViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

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

    
    
     NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_month_DealDetail];
    NSDictionary*contentDict=@{@"user_id":[UserSession instance].user_id,@"currPage":@(self.pages),@"pageSize":@(self.pagen)};
    [dict setObject:contentDict forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    NSString*xx=[encodeUrlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            SHFirstDealModel*mainModel=[SHFirstDealModel yy_modelWithDictionary:data];
            self.mainModel=mainModel;
            
            if (self.pages==1) {
                [self.mainModelArray removeAllObjects];
                
                if ([data[@"content"] count]>0) {
                    [self.mainModelArray addObjectsFromArray:self.mainModel.content];
                }
              
                
            }else{
                if ([data[@"content"] count]>0) {
                    [self.mainModelArray addObjectsFromArray:self.mainModel.content];
                }

                
              
            }
            
            
            [self.tableView reloadData];
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

        
    }];
    
    
}

#pragma mark  -- set
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
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
