//
//  CGCAdressBookVC.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/15.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CGCAdressBookVC.h"

#import "CGCAdressBookCell.h"
#import "CGCAdressBookModel.h"
#import "CGCAdressBookDetailModel.h"

#import "CGCPersonInfoVC.h"


@interface CGCAdressBookVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (assign) NSInteger currPage;

@property (nonatomic, copy) NSString *SEARCH_NAMEORCONTACT;

@end

@implementation CGCAdressBookVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"通讯录";
    self.currPage=1;
    [self HTTPrequestAdressBookList];
    [self setupSearchBar];
    [self.view addSubview:self.tableView];
//    DBSelf(weakSelf);
//    
//    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        self.currPage=1;
//        [weakSelf HTTPrequestAdressBookList];
//        
//    }];
//    self.tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        self.currPage++;
//        [weakSelf HTTPrequestAdressBookList];
//        
//        
//    }];

    // Do any additional setup after loading the view.
}




#pragma mark -- 创建searchBar
- (void)setupSearchBar{
    /**配置Search相关控件*/
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    searchBar.placeholder=@"搜索姓名/手机号";
    self.tableView.tableHeaderView = searchBar;
    
  
    /**searchBar的delegate看需求进行配置*/
    searchBar.delegate = self;
    
   
}
#pragma mark --- searchBarDelegate
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

     if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
         [[UIApplication sharedApplication].keyWindow endEditing:YES];
     }
    return YES;
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
       return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
   
    self.SEARCH_NAMEORCONTACT=searchBar.text;
    [self HTTPrequestAdressBookList];
    return  YES;
}

#pragma mark -- tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    CGCAdressBookModel * model=self.dataArray[section];
    return model.array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CGCAdressBookDetailModel * model=[self.dataArray[indexPath.section] array][indexPath.row];

    CGCAdressBookCell * cell=[CGCAdressBookCell cellWithTableView:tableView];
    [cell reloadCell:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  CGCAdressBookDetailModel * model=[self.dataArray[indexPath.section] array][indexPath.row];
    CGCPersonInfoVC * vc=[[CGCPersonInfoVC alloc] init];
    vc.C_ID=model.C_ID;
    [self.navigationController pushViewController:vc animated:YES];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{


    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGCAdressBookModel *model=self.dataArray[section];
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 20)];
    view.backgroundColor=DBColor(245, 245, 245);
    UILabel * lab=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 20)];
    lab.textAlignment=NSTextAlignmentLeft;
    lab.text=model.total;
    [view addSubview:lab];
    
    return view;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    return 20.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
    
}


////返回每个索引的内容
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    CGCAdressBookModel *model=self.dataArray[section];
//    return model.total;
//}
//返回索引数组
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSMutableArray * arr=[NSMutableArray array];
    for (CGCAdressBookModel *model in self.dataArray) {
        [arr addObject:model.total];
    }
    
    return arr;
}
//响应点击索引时的委托方法
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    
    NSInteger count=0;
    
    for (CGCAdressBookModel *model in self.dataArray) {
        
        if ([[model.total uppercaseString] hasPrefix:title]) {
            return count;
        }
        
        count++;
    }
    
    
    
    return 0;
}


#pragma mark -- HTTPRequest

- (void)HTTPrequestAdressBookList{

    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_CGC_getCommunicationList];
    
    NSMutableDictionary *dic=[NSMutableDictionary new];
    [dic setObject:@(self.currPage) forKey:@"currPage"];
    [dic setObject:@"10" forKey:@"pageSize"];
    self.SEARCH_NAMEORCONTACT.length>0?[dic setObject:self.SEARCH_NAMEORCONTACT forKey:@"SEARCH_NAMEORCONTACT"]:0;
    [dict setObject:dic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    
    
    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        [self.view addSubview:self.tableView];
        if ([data[@"code"] integerValue]==200) {
//            if (self.currPage==1) {
//                [self.dataArray removeAllObjects];
//            }
            for (NSDictionary * dic in data[@"content"]) {
                CGCAdressBookModel * model=[CGCAdressBookModel yy_modelWithDictionary:dic];
                
                [self.dataArray addObject:model];
            }
            
            
//            [JRToast showWithText:data[@"message"]];
            
        }else{
//             self.currPage>1?self.currPage--:0;
            [JRToast showWithText:data[@"message"]];
        }
        
        [self.tableView reloadData];
//        [self.tableView.mj_header endRefreshing];
//        [self.tableView.mj_footer endRefreshing];
    }];



}

#pragma mark -- set

- (UITableView *)tableView{

    if (_tableView==nil) {
        _tableView=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.sectionIndexBackgroundColor=[UIColor clearColor];
        _tableView.sectionIndexColor=[UIColor lightGrayColor];
    }
    
    return _tableView;
}

- (NSMutableArray *)dataArray{
    if (_dataArray==nil) {
        _dataArray=[[NSMutableArray alloc] init];
        
    }
    return _dataArray;
}

@end
