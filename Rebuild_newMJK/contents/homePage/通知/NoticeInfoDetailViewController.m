//
//  NoticeInfoDetailViewController.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/22.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "NoticeInfoDetailViewController.h"
#import "NoticeDetailTableViewCell.h"
#import "NoticeInfoModel.h"

#import "DBWebViewController.h"

#define CELL0   @"NoticeDetailTableViewCell"

@interface NoticeInfoDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,assign)NSInteger pagen;
@property(nonatomic,assign)NSInteger pages;

@end

@implementation NoticeInfoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"公司公告";
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
    
    
    if (self.type==noticeTypeManager) {
        [self setupRefresh];
    }
    
}



#pragma mark  --UI
-(void)setupRefresh{
    self.pagen=10;
    self.pages=1;
    
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pages=1;
        [self httpPostGetInfo];
    }];
    
    self.tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pages++;
         [self httpPostGetInfo];
        
    }];
    
    [self.tableView.mj_header beginRefreshing];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allDatas.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeDetailTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
    NoticeInfoModel*model=self.allDatas[indexPath.row];
    [cell getValue:model];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NoticeInfoModel*model=self.allDatas[indexPath.row];
    DBWebViewController*vc=[[DBWebViewController alloc]init];
    NSString*address=[NSString stringWithFormat:@"%@%@",HTTP_CompanyNotice,model.C_JUMP_URL];
    vc.urlStr=address;
    vc.title=model.C_TITLE;
    [self.navigationController pushViewController:vc animated:YES];

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


#pragma mark  --datas
-(void)httpPostGetInfo{

    NSMutableDictionary*mainDic=[DBObjectTools getAddressDicWithAction:HTTP_NOticeInfo];
    NSDictionary*dict=@{@"TYPE":@"1",@"pageSize":@(_pagen),@"currPage":@(_pages)};
    [mainDic setObject:dict forKey:@"content"];
    NSString*params=[DBObjectTools getPostStringAddressWithMainDict:mainDic withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:params parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            if (self.pages==1) {
                self.allDatas=[NSMutableArray array];
            }
            
            NSArray*array=data[@"content"];
            for (NSDictionary*dict in array) {
                NoticeInfoModel*model=[NoticeInfoModel yy_modelWithDictionary:dict];
                [self.allDatas addObject:model];
                
            }
            
            [self.tableView reloadData];
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
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

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}

@end
