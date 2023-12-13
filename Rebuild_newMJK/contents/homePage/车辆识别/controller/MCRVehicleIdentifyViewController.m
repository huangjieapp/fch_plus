//
//  MCRVehicleIdentifyViewController.m
//  Mcr_2
//
//  Created by Mcr on 2018/12/7.
//  Copyright © 2018 bipi. All rights reserved.
//

#import "MCRVehicleIdentifyViewController.h"
#import "MCRVehicleIdentifyCollectionViewCell.h"
#import "MCRVehicleIdentifyDetailViewController.h"

@interface MCRVehicleIdentifyViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSString *SelectType;
    NSMutableArray *StatusArr;
    NSMutableArray *StatusID;
    NSString* statuesValues;
    NSMutableArray *TimeArr;
    NSMutableArray *TimeID;
    NSString* timeValues;
    NSMutableArray *NumArr;
    NSMutableArray *NumID;
    NSString* numValues;
    NSMutableArray *SelectArr;
    NSMutableArray *SelectID;
    int currPage;
    NSMutableArray *arrayId;
    NSMutableArray *dataArr;
    NSMutableArray *deviceArray;
    NSString *total;
    
    UIButton* leftBtn;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *naviHeight;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIImageView *labBG;
@property (weak, nonatomic) IBOutlet UILabel *labCount;
@property (weak, nonatomic) IBOutlet UIView *selectBGView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** */
@property (nonatomic, strong) UILabel *countLabel;




@end

@implementation MCRVehicleIdentifyViewController

- (IBAction)timeSelect:(UIButton *)sender {
    self.collectionView.hidden=YES;
    self.statusLabel.textColor=KColorUnSelectCell;
    self.timeLabel.textColor=KColorSelectCell;
    self.numLabel.textColor=KColorUnSelectCell;
    SelectType=@"time";
    self.tableView.hidden=YES;
    self.selectBGView.hidden=YES;
    [self.tableView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tableView.hidden=NO;
        self.selectBGView.hidden=NO;
        
    });
}
- (IBAction)statusSelect:(UIButton *)sender {
    self.collectionView.hidden=YES;
    self.statusLabel.textColor=KColorSelectCell;
    self.timeLabel.textColor=KColorUnSelectCell;
    self.numLabel.textColor=KColorUnSelectCell;
    SelectType=@"status";
    self.tableView.hidden=YES;
    self.selectBGView.hidden=YES;
    [self.tableView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tableView.hidden=NO;
        self.selectBGView.hidden=NO;
        
    });
}
- (IBAction)numberLabel:(UIButton *)sender {
    self.collectionView.hidden=YES;
    self.statusLabel.textColor=KColorUnSelectCell;
    self.timeLabel.textColor=KColorUnSelectCell;
    self.numLabel.textColor=KColorSelectCell;
    SelectType=@"num";
    self.tableView.hidden=YES;
    self.selectBGView.hidden=YES;
    [self.tableView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tableView.hidden=NO;
        self.selectBGView.hidden=NO;
        
    });
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
    
    NSUserDefaults* UserDefaults=[NSUserDefaults standardUserDefaults];
    NSString *isrefersh=[UserDefaults  objectForKey:@"IS_refresh"];
    if ([isrefersh isEqualToString:@"yes"]) {
        currPage = 1;
        [dataArr removeAllObjects];
        [_pathArr removeAllObjects];
        [_ImgArr removeAllObjects];
        
        //    UIButton *btns = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame =CGRectMake(0,0, 15,35);
        UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 11 , 17)];
        leftBtn.tag = 4;
        [leftBtn setTitle:@"" forState:UIControlStateNormal];
        imgview.image =[UIImage imageNamed:@"btn-返回.png"];
        [leftBtn addSubview:imgview];
//        _type = MDHidden;
        
        [self refersh];
    }
    //    C_A40300_C_ID=[UserDefaults objectForKey:@"C_A40300_C_ID"];
    
    [UserDefaults setObject:nil forKey:@"IS_refresh"];
    [UserDefaults synchronize];
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
	self.naviHeight.constant = NavStatusHeight;
    dataArr=[NSMutableArray new];
    deviceArray = [NSMutableArray array];
    self.title=@"车辆识别";
    currPage = 1;
    SelectArr=[NSMutableArray new];
    SelectID=[NSMutableArray new];
    _pathArr=[NSMutableArray new];
    _ImgArr = [NSMutableArray new];
    statuesValues = @"";
    timeValues = @"1";
    numValues = @"";
    _path = @"";
    _path_tag = 1;
    self.selectBGView.hidden=YES;
    self.BGView.hidden=YES;
    self.OperationView.hidden=YES;
    self.chuangjianView.hidden=YES;
    self.tableView.hidden=YES;
    
    
    TimeArr=[[NSMutableArray alloc]initWithObjects:@"全部",@"今天",@"最近7天",@"最近30天",@"本周",@"本月",@"自定义", nil];
    TimeID=[[NSMutableArray alloc]initWithObjects:@"",@"1",@"7",@"30",@"2",@"3",@"", nil];
    NumArr=[[NSMutableArray alloc]initWithObjects:@"全部",@"已预约",@"未预约", nil];
    NumID=[[NSMutableArray alloc]initWithObjects:@"",@"1",@"0", nil];
    _tableView.hidden=YES;
    DBSelf(weakSelf);
//    [self getDeviceNumBlock:^{
//        StatusArr=[NSMutableArray array];
//        StatusID=[NSMutableArray array];
//        [StatusArr addObject:@"全部"];
//        [StatusID addObject:@""];
//        for (NSDictionary *dic in deviceArray) {
//            [StatusID addObject:dic[@"C_NUMBER"]];
//            [StatusArr addObject:dic[@"X_REMARK"]];
//        }
//
        [weakSelf loadCollectionView];
//        [weakSelf refersh];
//    }];
    UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide1:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer1.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.BGView addGestureRecognizer:tapGestureRecognizer1];
    
    UITapGestureRecognizer *tapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide1:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer1.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.selectBGView addGestureRecognizer:tapGestureRecognizer2];
    
    
    
    [self datePickerAndMethod];
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        currPage = 1;
        [self refersh];
    }];
    [self.collectionView.mj_header beginRefreshing];
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}
-(void)loadMoreData

{
    
    currPage=currPage+1;
    
    [self refersh];
    
    
    
}
#pragma mark流量仪列表
-(void)refersh
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self gethttpValues];
    });
    
}

-(void)gethttpValues
{
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A49100WebService-getList"];
    NSMutableDictionary *dic1=[NSMutableDictionary new];
    //    [dic1 setObject:@"" forKey:@"SEARCH_NAMEORCONTACT"];

    [dic1 setObject:[NSString stringWithFormat:@"%d",currPage] forKey:@"currPage"];
    [dic1 setObject:@"30" forKey:@"pageSize"];
    //    [dic1 setObject:@"" forKey:@"LEAD_TIME_TYPE"]; //下发时间
    if (self.chaungjianStartime.text.length > 0) {
        [dic1 setObject:self.chaungjianStartime.text forKey:@"ARRIVAL_START_TIME"]; //开始
    }
    if (self.chaungjianEndTime.text.length > 0) {
        [dic1 setObject:self.chaungjianEndTime.text forKey:@"ARRIVAL_END_TIME"]; //jieshu
    }
    if (timeValues.length > 0) {
        [dic1 setObject:timeValues forKey:@"ARRIVAL_TIME_TYPE"];
    }

    if (statuesValues.length > 0) {
        [dic1 setObject:statuesValues forKey:@"C_NUMBER"];
    }
    if (numValues.length > 0) {
        [dic1 setObject:numValues forKey:@"I_TYPE"];
    }


    [dict setObject:dic1 forKey:@"content"];
    
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            if(currPage==1){
                [dataArr removeAllObjects];
                [arrayId removeAllObjects];
                total=nil;
            }
            if ([data objectForKey:@"countNumber"] == 0) {
                self.labCount.text=[NSString stringWithFormat:@"总计:0"];
//                self.countLabel.text = [NSString stringWithFormat:@"总计:0"];
            }else{
                self.labCount.text=[NSString stringWithFormat:@"总计:%@",[data objectForKey:@"countNumber"]];
//                self.countLabel.text = [NSString stringWithFormat:@"总计:%@",[data objectForKey:@"countNumber"]];
            }
            
            NSMutableArray *itemsArray=[[NSMutableArray alloc]init];
            
            itemsArray=[data objectForKey:@"content"];
            
            for (NSMutableDictionary *contentDic in itemsArray) {
                
                NSString *str=[contentDic objectForKey:@"total"];
                //防止出现两个相同的section
                if ([str isEqualToString:total]) {
                    NSMutableDictionary *dic=dataArr[dataArr.count-1];
                    NSMutableArray *arr=[dic objectForKey:@"content"];
                    NSArray *contentArr=[contentDic objectForKey:@"content"];
                    for (NSDictionary *content in contentArr) {
                        [arr addObject:content];
                    }
                }else
                {//使原来是数据变为可变的数据
                    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
                    NSMutableArray *arr1=[contentDic objectForKey:@"content"];
                    NSMutableArray *ARRAY=[NSMutableArray new];
                    for (int i=0; i<arr1.count; i++) {
                        NSMutableDictionary *dic11=[[NSMutableDictionary alloc]initWithDictionary:arr1[i]];
                        [ARRAY addObject:dic11];
                        [dic11 setObject:@"NO" forKey:@"Flag"];
                    }
                    [dic setObject:ARRAY forKey:@"content"];
                    [dic setObject:str forKey:@"total"];
                    [dataArr addObject:dic];
                }
                total=str;
            }
            [weakSelf.collectionView reloadData];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
    }];


}


-(void)loadCollectionView{
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.headerReferenceSize = CGSizeMake(0, 30);
    [layout setItemSize:CGSizeMake(KScreenWidth/2, 150)];
    
    //(SCREENWIDTH-20)/2+40
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, NavStatusHeight + 36, KScreenWidth, KScreenHeight-100) collectionViewLayout:layout];
    
    //    _collectionView.collectionViewLayout = layout;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerNib:[UINib nibWithNibName:@"MCRVehicleIdentifyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
    
    UIImageView *labBG = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth-60, NavStatusHeight + 36, 60, 17)];
    labBG.image = [UIImage imageNamed:@"总计-bg"];
    [self.view addSubview:labBG];

    UILabel *labCount = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth-60, NavStatusHeight + 36, 60, 17)];
    labCount.font = [UIFont systemFontOfSize:11];
    labCount.textAlignment = NSTextAlignmentCenter;
    labCount.textColor = [UIColor colorWithRed:0.447 green:0.447 blue:0.447 alpha:1];
    self.countLabel = labCount;
//    [self.view addSubview:labCount];
//
//
//    self.labBGYX = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth-180, 99, 60, 17)];
//    self.labBGYX.image = [UIImage imageNamed:@"总计-bg"];
//    [self.view addSubview:self.labBGYX];
//
//    self.labCountYX = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth-180, 99, 60, 17)];
//    self.labCountYX.font = [UIFont systemFontOfSize:11];
//    self.labCountYX.textAlignment = NSTextAlignmentCenter;
//    self.labCountYX.textColor = [UIColor colorWithRed:0.447 green:0.447 blue:0.447 alpha:1];
//    [self.view addSubview:self.labCountYX];
//
//    self.labBGPC = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth-120, 99, 60, 17)];
//    self.labBGPC.image = [UIImage imageNamed:@"总计-bg"];
//    [self.view addSubview:self.labBGPC];
//
//    self.labCountPC = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth-120, 99, 60, 17)];
//    self.labCountPC.font = [UIFont systemFontOfSize:11];
//    self.labCountPC.textAlignment = NSTextAlignmentCenter;
//    self.labCountPC.textColor = [UIColor colorWithRed:0.447 green:0.447 blue:0.447 alpha:1];
//    [self.view addSubview:self.labCountPC];
//
//    self.labBGCL = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth-60, 99, 60, 17)];
//    self.labBGCL.image = [UIImage imageNamed:@"总计-bg"];
//    [self.view addSubview:self.labBGCL];
//
//    self.labCountCL = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth-60, 99, 60, 17)];
//    self.labCountCL.font = [UIFont systemFontOfSize:11];
//    self.labCountCL.textAlignment = NSTextAlignmentCenter;
//    self.labCountCL.textColor = [UIColor colorWithRed:0.447 green:0.447 blue:0.447 alpha:1];
//    [self.view addSubview:self.labCountCL];
    
    
//    UIButton* btnAdd = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth/2-20, KScreenHeight-70, 50, 50)];
//    [btnAdd setBackgroundImage:[UIImage imageNamed:@"addimg"] forState:UIControlStateNormal];
//    [btnAdd addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btnAdd];
    
    //    _BGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)] ;
    //    [_BGView setBackgroundColor:[UIColor blackColor]];
    //    _BGView.alpha = 0.5;
    //    _BGView.hidden = YES;
//    [self.view addSubview:_BGView];
//    [self.view addSubview:_OperationView];
    
    
}
#pragma mark---------CollectionViewDataSouce AND delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return dataArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSMutableDictionary *dic1=dataArr[section];
    NSMutableArray *arr=[dic1 objectForKey:@"content"];
    
    return arr.count;
}
//创建头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                            withReuseIdentifier:@"UICollectionViewHeader"
                                                                                   forIndexPath:indexPath];
    headView.backgroundColor = [UIColor whiteColor];
    //此处的header可能会产生复用，所以在使用之前要将其中的原有的子视图移除掉
    for (UIView* view in headView.subviews) {
        [view removeFromSuperview];
    }
    
    
    UIImageView* imgs1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    imgs1.backgroundColor = [UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:1];
    [headView addSubview:imgs1];
    
    UILabel* labApply = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth, 30)];
    //    if (indexPath.section == 0) {
    NSMutableDictionary *dic1=dataArr[indexPath.section];
    NSString *nian=[dic1 objectForKey:@"total"];
    
    labApply.text = nian;
    //    }else{
    //        ProductListTotalData* totalData = [_childrenArr objectAtIndex:indexPath.section-1];
    //        labApply.text = totalData.SectionName;
    //    }
    
    labApply.font = [UIFont systemFontOfSize:14];
    labApply.textColor = [UIColor grayColor];
    [headView addSubview:labApply];
    
    
    
    return headView;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    注册头视图
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader"];
    
    
    MCRVehicleIdentifyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    NSMutableDictionary *dic1=dataArr[indexPath.section];
    NSMutableArray *arr=[dic1 objectForKey:@"content"];
    NSMutableDictionary *dic=arr[indexPath.row];
    [cell.imgPhoto sd_setImageWithURL:[NSURL URLWithString:dic[@"C_PICURL"]]];
    cell.vehicleLabel.text = [NSString stringWithFormat:@"%@ %@",dic[@"C_LICENSENUMBER"], dic[@"C_NAME"]];
    cell.labTime.text = dic[@"D_ARRIVAL_TIME"];
    cell.labState.text = [dic[@"I_TYPE"] isEqualToString:@"0"] ? @"未预约" : @"已预约";
    return cell;
}
-(void)btnWXZClick:(UIButton*)btn{
    
//
//    NSLog(@"%@",[[btn superview]class]);
//    MCRVehicleIdentifyCollectionViewCell *cell = (MCRVehicleIdentifyCollectionViewCell *)btn.superview;
//    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
//    NSMutableDictionary *dic1=dataArr[indexPath.section];
//    NSMutableArray *arr=[dic1 objectForKey:@"content"];
//    NSMutableDictionary *dic=arr[indexPath.row];
//    if (_pathArr.count<4) {
//        if (cell.chooseImg.tag == 0) {
//            cell.chooseImg.tag = 1;
//            [cell.chooseImg setImage:[UIImage imageNamed:@"选中"]];
//            [_pathArr addObject:[dic objectForKey:@"C_ID"]];
//            [_ImgArr addObject:[dic objectForKey:@"C_HEADPIC"]];
//
//        }else {
//            cell.chooseImg.tag = 0;
//            [cell.chooseImg setImage:[UIImage imageNamed:@"未选中"]];
//            [_pathArr removeObject:[dic objectForKey:@"C_ID"]];
//            [_ImgArr removeObject:[dic objectForKey:@"C_HEADPIC"]];
//        }
//
//    }else{
//        UIAlertView *myView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"只能选4条哦" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [myView show];
//
//    }
//
//    NSLog(@"%@",_pathArr);
    
    //    [_collectionView reloadData];
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *dic1=dataArr[indexPath.section];
    NSMutableArray *arr=[dic1 objectForKey:@"content"];
    NSMutableDictionary *dic=arr[indexPath.row];
    MCRVehicleIdentifyDetailViewController *vc = [[MCRVehicleIdentifyDetailViewController alloc]initWithNibName:@"MCRVehicleIdentifyDetailViewController" bundle:nil];
    vc.dic = dic;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


-(void)keyboardHide1:(UITapGestureRecognizer*)tap{
    
    self.tableView.hidden=YES;
    self.selectBGView.hidden=YES;
    self.chuangjianView.hidden=YES;
    self.BGView.hidden=YES;
    self.OperationView.hidden=YES;
    self.tableView.hidden=YES;
    self.collectionView.hidden = NO;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UITableViewCell *tableviewCell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
    if (!tableviewCell) {
        tableviewCell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
    }
    tableviewCell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if ([SelectType isEqualToString:@"status"]) {
        NSString *str=StatusArr[indexPath.row];
        tableviewCell.textLabel.text=str;
        if ([self.statusLabel.text isEqualToString:str]) {
            tableviewCell.textLabel.textColor=KColorSelectCell;
        }else if ([self.statusLabel.text isEqualToString:@"位置"]&&indexPath.row==0){
            tableviewCell.textLabel.textColor=KColorSelectCell;
        }else
        {
            tableviewCell.textLabel.textColor=KColorUnSelectCell;
        }
    }else if([SelectType isEqualToString:@"time"]){
        
        NSString *str=TimeArr[indexPath.row];
        tableviewCell.textLabel.text=str;
        if ([self.timeLabel.text isEqualToString:str]) {
            tableviewCell.textLabel.textColor=KColorSelectCell;
        }else if ([self.timeLabel.text isEqualToString:@"进出时间"]&&indexPath.row==0){
            tableviewCell.textLabel.textColor=KColorSelectCell;
        }else
        {
            tableviewCell.textLabel.textColor=KColorUnSelectCell;
        }
        
        
    }else if([SelectType isEqualToString:@"num"]){
        NSString *str=NumArr[indexPath.row];
        tableviewCell.textLabel.text=str;
        if ([self.numLabel.text isEqualToString:str]) {
            tableviewCell.textLabel.textColor=KColorSelectCell;
        }else if ([self.numLabel.text isEqualToString:@"是否预约"]&&indexPath.row==0){
            tableviewCell.textLabel.textColor=KColorSelectCell;
        }else
        {
            tableviewCell.textLabel.textColor=KColorUnSelectCell;
        }
    }
    
    tableviewCell.textLabel.font=[UIFont systemFontOfSize:14.0];
    return tableviewCell;
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([SelectType isEqualToString:@"status"]) {
        return StatusArr.count;
        
    }else if([SelectType isEqualToString:@"time"]){
        return TimeArr.count;
        
    }else if([SelectType isEqualToString:@"num"]){
        return NumArr.count;
        
    }else
    {
        return 0;
    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableView.hidden=YES;
    
    if ([SelectType isEqualToString:@"status"]) {
        
        NSString *str=StatusArr[indexPath.row];
        self.tableView.hidden=YES;
        self.selectBGView.hidden=YES;
        statuesValues=[StatusID objectAtIndex:indexPath.row];
        if ([str isEqualToString:@"全部"]) {
            self.statusLabel.text=@"位置";
        }else
        {
            self.statusLabel.text=str;
        }
        currPage=1;
        [self refersh];
    }else if ([SelectType isEqualToString:@"num"]){
        
        NSString *str=NumArr[indexPath.row];
        if ([str isEqualToString:@"全部"]) {
            self.numLabel.text=@"是否预约";
        }else
        {
            self.numLabel.text=str;
        }
        self.tableView.hidden=YES;
        self.selectBGView.hidden=YES;
        numValues=[NumID objectAtIndex:indexPath.row];
        currPage=1;
        [self refersh];
        
    }else if ([SelectType isEqualToString:@"time"]){
        
        
        NSString *str=TimeArr[indexPath.row];
        if ([str isEqualToString:@"全部"]) {
            self.timeLabel.text=@"进出时间";
        }else
        {
            self.timeLabel.text=str;
        }
        //            self.TableView.hidden=YES;
        //            self.SelectBGView.hidden=YES;
        //            timeValues=[TimeID objectAtIndex:indexPath.row];
        //            currPage=1;
        //            [self refersh];
        
        if ([str isEqualToString:@"自定义"]) {
            self.chuangjianView.hidden=NO;
            self.selectBGView.hidden=NO;
            timeValues = @"";
			
        }else{
			
			self.chaungjianEndTime.text = self.chaungjianStartime.text = @"";
            self.tableView.hidden=YES;
            self.selectBGView.hidden=YES;
            timeValues=[TimeID objectAtIndex:indexPath.row];
            currPage=1;
            [self refersh];
        }
        
    }
    self.collectionView.hidden = NO;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 45.0;
    
    
}


- (IBAction)SelectButton1:(id)sender {
    if ([_SelectImageView1.image isEqual:[UIImage imageNamed:@"未选中"]]) {
        
        _SelectImageView1.image=[UIImage imageNamed:@"选中"];
        
        [SelectArr addObject:@"张继科"];
    }else
    {
        _SelectImageView1.image=[UIImage imageNamed:@"未选中"];
        [SelectArr removeObject:@"张继科"];
        
        
    }
    
    
}
- (IBAction)SelectButton2:(id)sender {
    if ([_SelectImageView2.image isEqual:[UIImage imageNamed:@"未选中"]]) {
        _SelectImageView2.image=[UIImage imageNamed:@"选中"];
        [SelectArr addObject:@"傅园慧"];
        
    }else
    {
        _SelectImageView2.image=[UIImage imageNamed:@"未选中"];
        [SelectArr removeObject:@"傅园慧"];
        
        
    }
}
- (IBAction)SelectButton3:(id)sender {
    if ([_SelectImageView3.image isEqual:[UIImage imageNamed:@"未选中"]]) {
        [SelectArr addObject:@"张怡宁"];
        
        _SelectImageView3.image=[UIImage imageNamed:@"选中"];
        
    }else
    {
        _SelectImageView3.image=[UIImage imageNamed:@"未选中"];
        [SelectArr removeObject:@"张怡宁"];
        
        
    }
}
- (IBAction)SelectButton4:(id)sender {
    if ([_SelectImageView4.image isEqual:[UIImage imageNamed:@"未选中"]]) {
        _SelectImageView4.image=[UIImage imageNamed:@"选中"];
        [SelectArr addObject:@"张继科"];
        
        
    }else
    {
        _SelectImageView4.image=[UIImage imageNamed:@"未选中"];
        [SelectArr removeObject:@"张继科"];
        
        
    }
}


-(void)recordOperate
{//流量仪记录操作
    
    
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A46000WebService-operationBean"];
    
    NSMutableDictionary *dic1=[NSMutableDictionary new];
    NSString* strID = [_pathArr componentsJoinedByString:@","];
    [dic1 setObject:strID forKey:@"C_ID"];
    [dic1 setObject:_Arrival_type forKey:@"ARRIVAL_TYPE"];
    
    [dict setObject:dic1 forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
           
        }else{
            
        }
    }];
    
    
//    NSString *str=[dic JSONString];
//    NSString *respone=[HttpPost getPost:str];
//    if (![respone isEqualToString:@""])
//    {
//        
//        NSDictionary* dataDic = [respone objectFromJSONString];
//        
//        NSString *errcode = [dataDic objectForKey:@"code"];
//        
//        if ([errcode isEqualToString:@"200"]) {
//            
//            [_pathArr removeAllObjects];
//            [self gethttpValues];
//        }
//        
//        else
//        {
//            [KVNProgress showErrorWithStatus:[dataDic objectForKey:@"message"]];
//            
//        }
//        
//    }else{
//        
//        [KVNProgress showErrorWithStatus:[MyUtil getMessage]];
//        
//    }
    
    
}


- (IBAction)chaungjianCancel:(id)sender{
    self.selectBGView.hidden=YES;
    self.chuangjianView.hidden=YES;
    self.BGView.hidden=YES;
}
- (IBAction)chaungjianSure:(id)sender{
    self.chuangjianView.hidden=YES;
    self.BGView.hidden=YES;
    self.selectBGView.hidden=YES;
    currPage=1;
    [self refersh];
    
}

//时间控件
- (void)datePickerAndMethod
{
//    UIDatePicker *Picker = [[UIDatePicker alloc] init];
    
    
    
    UIDatePicker *Picker3 = [[UIDatePicker alloc] init];
//    Picker3.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_cn"];
    Picker3.datePickerMode = UIDatePickerModeDateAndTime;
    Picker3.tag=104;
    
    NSDate *Date3 = [NSDate date];
    NSDateFormatter *birthformatter3 = [[NSDateFormatter alloc] init];
    birthformatter3.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    birthformatter3.dateFormat = @"yyyy-MM-dd HH:mm";
    //    self.starTimeTextfiles.text =[birthformatter stringFromDate:Date1];
    [Picker3 setDate:Date3 animated:YES];
    [Picker3 addTarget:self action:@selector(showDate:) forControlEvents:UIControlEventValueChanged];
    self.chaungjianStartime.inputView = Picker3;
    
    UIDatePicker *Picker4 = [[UIDatePicker alloc] init];
//    Picker4.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_cn"];
    Picker4.datePickerMode = UIDatePickerModeDateAndTime;
    Picker4.tag=105;
    
    NSDate *Date4 = [NSDate date];
    NSDateFormatter *birthformatter4 = [[NSDateFormatter alloc] init];
    birthformatter3.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    birthformatter4.dateFormat = @"yyyy-MM-dd HH:mm";
    //    self.endTimeTextfiled.text =[birthformatter stringFromDate:Date2];
    [Picker4 setDate:Date4 animated:YES];
    [Picker4 addTarget:self action:@selector(showDate:) forControlEvents:UIControlEventValueChanged];
    self.chaungjianEndTime.inputView = Picker4;
    
    
}
- (void)showDate:(UIDatePicker *)datePicker
{
    if (datePicker.tag==104) {
        
        NSDate *date = datePicker.date;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        NSString *outputString = [formatter stringFromDate:date];
        self.chaungjianStartime.text = outputString;
    }
    
    else if (datePicker.tag==105) {
        
        NSDate *date = datePicker.date;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        NSString *outputString = [formatter stringFromDate:date];
        self.chaungjianEndTime.text = outputString;
    }
    
    
}

//-(void)goback:(UIButton *)btn{
//
//}

-(void)cancelBtn:(UIButton*)btn{
    if (btn.tag == 3) {
        [_pathArr removeAllObjects];
        [_ImgArr removeAllObjects];
        
        //    UIButton *btns = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame =CGRectMake(0,0, 15,35);
        UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 11 , 17)];
        leftBtn.tag = 4;
        [leftBtn setTitle:@"" forState:UIControlStateNormal];
        imgview.image =[UIImage imageNamed:@"btn-返回.png"];
        [leftBtn addSubview:imgview];
        //    [btns addTarget: self action: @selector(goback:) forControlEvents: UIControlEventTouchUpInside];
        //    UIBarButtonItem* item=[[UIBarButtonItem alloc]initWithCustomView:btns];
        //    self.navigationItem.leftBarButtonItem=item;
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    [_collectionView reloadData];
}

@end
