//
//  CGCIntegralStoreVC.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/5/9.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "CGCIntegralStoreVC.h"
#import "CollectionViewCell.h"
#import "CGCIntegralModel.h"

#import "CGCIntegralDetailVC.h"

@interface CGCIntegralStoreVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *btnArr;

@property (nonatomic, strong) UIView *perSelectView;

@property (nonatomic, strong) UIButton *selBtn;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger pages;

@property (nonatomic, copy) NSString *selType;
@end

@implementation CGCIntegralStoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pages=1;
    self.selType=@"1";
    self.title=@"积分商城";
    [self initUI];
//    [self httpRequestList];
    [self.view addSubview:self.collectionView];
   
    
    DBSelf(weakSelf);
    self.collectionView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pages=1;
        [weakSelf httpRequestList];
        
    }];
    
    self.collectionView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pages++;
        [weakSelf httpRequestList];
    }];
    // Do any additional setup after loading the view.
}



- (void)initUI {
     self.view.backgroundColor=CGCTABBGColor;
    UIView *tabView = [[UIView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KScreenWidth, 44)];
    tabView.backgroundColor=[UIColor whiteColor];
  
    for (int i = 0; i < 2; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth / 2 * i, 0, KScreenWidth / 2, 44)];
        [button setTitle:@[@"仅我能兑换",@"全部"][i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        button.tag = 100 + i;
        [button addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [tabView addSubview:button];
        [self.btnArr addObject:button];
        
        if (i == 1) {
            UIView *selectView = [[UIView alloc]initWithFrame:CGRectMake(KScreenWidth / 2 * i, tabView.frame.size.height - 2, button.frame.size.width, 2)];
            selectView.backgroundColor = [UIColor blackColor];
            selectView.tag = button.tag + 1;
            [tabView addSubview:selectView];
            self.perSelectView=selectView;
            [self selectButtonAction:button];
        }
        
        
    }
    
//    [self.view addSubview:tabView];
    
    
}

//一共有多少个组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//每一组有多少个cell
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArray.count;
   
}
//每一个cell是什么
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"collViewHeadSeecond" forIndexPath:indexPath];
    
    CGCIntegralModel *model=self.dataArray[indexPath.row];
    [cell reloadCellWithModel:model];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CGCIntegralModel *model=self.dataArray[indexPath.row];
    CGCIntegralDetailVC *dvc=[[CGCIntegralDetailVC alloc] init];
    dvc.sid=model.sid;
    [self.navigationController pushViewController:dvc animated:NO];
}


- (void)httpRequestList{
    
//    [KVNProgress show];
    NSMutableDictionary * dict=[NSMutableDictionary dictionary];
    [dict setObject:self.selType forKey:@"searchpara"];
//    [dict setObject:@"ios" forKey:@"app"];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)self.pages]  forKey:@"page"];
    [dict setObject:@"0" forKey:@"searchstatus"];
//    [dict setObject:[NewUserSession instance].TOKEN forKey:@"usertoken"];
    [[POPRequestManger defaultManger] requestWithMethod:POST url:HTTP_integralList dict:dict target:self finished:^(id responsed) {
//        [KVNProgress dismiss];
        if ([responsed[@"code"] intValue]==200) {
            for (NSDictionary * dict in responsed[@"list"]) {
                CGCIntegralModel * model=[CGCIntegralModel yy_modelWithJSON:dict];
                [self.dataArray addObject:model];
            }
        }else{
            [KVNProgress showErrorWithStatus:responsed[@"message"]];
        }
       
        
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    } failed:^(id error) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        [KVNProgress showErrorWithStatus:@"网络连接失败"];
    }];
    
    
}


#pragma mark - 点击事件
- (void)selectButtonAction:(UIButton *)sender {
    
    if ([sender.titleLabel.text isEqualToString:@"全部"]) {
        self.selType=@"0";
    }
    if ([sender.titleLabel.text isEqualToString:@"仅我能兑换"]) {
        self.selType=@"1";
    }
    self.perSelectView.centerX =sender.centerX ;
    [self.selBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sender setTitleColor:KNaviColor forState:UIControlStateNormal];
    self.selBtn=sender;
    [self.dataArray removeAllObjects];
    self.pages=1;
    [self httpRequestList];
    
   
    
}

#pragma mark -- lazyLoading

-(UICollectionView *)collectionView{
    
    if (_collectionView==nil) {
        UICollectionViewFlowLayout * layout=[[UICollectionViewFlowLayout alloc] init];
        CGFloat  hcoll=(KScreenWidth-30)/2;
        layout.itemSize=CGSizeMake(hcoll,hcoll+70 );
        layout.minimumInteritemSpacing=5;
        layout.scrollDirection=UICollectionViewScrollDirectionVertical;
        layout.sectionInset=UIEdgeInsetsMake(10, 10, 10, 10);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) collectionViewLayout:layout];
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
        _collectionView.backgroundColor=CGCTABBGColor;
        [_collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"collViewHeadSeecond"];
    }
   
    
    return _collectionView;
}

- (NSMutableArray *)btnArr{
    
    if (_btnArr==nil) {
        _btnArr=[NSMutableArray array];
    }
    
    return _btnArr;
}

-(NSMutableArray *)dataArray{
    
    if (_dataArray==nil) {
        _dataArray=[NSMutableArray array];
    }
    
    return _dataArray;
    
}


@end
