//
//  MJKFlowMeterViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/29.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKFlowMeterViewController.h"
#import "CFDropDownMenuView.h"
#import "MJKAddFlowViewController.h"
#import "MJKFlowMeterDetailViewController.h"
#import "MJKDateViewPicker.h"
#import "CGCMoreCollection.h"
#import "MJKFlowMeterConductViewController.h"
#import "MJKFlowProcessViewController.h"//新版流量处理

#import "MJKFlowMeterListCollectionViewCell.h"

#import "MJKFlowMeterModel.h"
#import "MJKFlowMeterSubModel.h"
#import "MJKFlowMeterSubSecondModel.h"
#import "MJKFlowMeterDetailModel.h"
#import "MJKFlowInstrumentSubModel.h"

#import "MJKFlowInstrumentModel.h"

#import "MJKChooseEmployeesViewController.h"

@interface MJKFlowMeterViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, assign) NSInteger pagen;
@property (nonatomic, strong) MJKFlowMeterModel *meterModel;
@property (nonatomic, strong) NSString *time;//到店时间
@property (nonatomic, strong) NSString *status;//到店状态
@property (nonatomic, strong) NSString *shopArrive;//到店次数
@property (nonatomic, strong) NSArray *timeCode;//到店时间
@property (nonatomic, strong) NSArray *statusCode;//到店状态
@property (nonatomic, strong) NSArray *shopArriveCode;//到店次数
/** 本次接待*/
@property (nonatomic, strong) NSString *thisReceptionSaleID;
/** 上次接待*/
@property (nonatomic, strong) NSString *receptionSaleID;
@property (nonatomic, strong) NSString *START_TIME;
@property (nonatomic, strong) UILabel *allLabel;
@property (nonatomic, strong) UILabel *yxLabel;
@property (nonatomic, strong) UILabel *pcLabel;
@property (nonatomic, strong) UILabel *wclLabel;
@property (nonatomic, assign) BOOL isMore;
@property (nonatomic, strong) UIButton *chooseMoreButton;//多选
@property (nonatomic, strong) UIButton *cancelButton;//取消
@property (nonatomic, strong) UIButton *backButton;//返回
@property (nonatomic, strong) NSMutableArray *chooseMoreArray;
@property (nonatomic, strong) NSMutableArray *C_A41500_C_IDArray;
@property (nonatomic, strong) NSMutableArray *C_A41500_C_NAMEArray;
@property (nonatomic, strong) NSMutableArray *allModelArray;
@property (nonatomic, strong) NSMutableArray *headImageArray;
@property (nonatomic, strong) MJKFlowMeterSubSecondModel *subSecondModel;
@property (nonatomic, strong) UIButton *addButton;

/** 流量仪机器列表模型*/
@property(nonatomic,strong) MJKFlowInstrumentModel *onlineModel;
/** 位置筛选*/
@property(nonatomic,strong) NSString *posN;
/** 位置数组*/
@property(nonatomic,strong) NSMutableArray *posID;
/** TableChooseDatas*/
@property (nonatomic, strong) NSMutableArray *TableChooseDatas;
/** TableSelectedChooseDatas*/
@property (nonatomic, strong) NSMutableArray *TableSelectedChooseDatas;
/** FunnelDatas*/
@property (nonatomic, strong) NSMutableArray *FunnelDatas;
/** <#注释#>*/
@property (nonatomic, strong) NSString *isHistroy;

@end

@implementation MJKFlowMeterViewController
//tab页进入时新增
- (void)setIsAdd:(BOOL)isAdd {
	_isAdd = isAdd;
	if (isAdd == YES) {
		[self addFlowButtonAction:nil];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.isMore = NO;
	self.chooseMoreArray = [NSMutableArray array];
    self.C_A41500_C_IDArray = [NSMutableArray array];
    self.C_A41500_C_NAMEArray = [NSMutableArray array];
    self.allModelArray = [NSMutableArray array];
	self.headImageArray = [NSMutableArray array];
	UIBarButtonItem* item=[[UIBarButtonItem alloc]initWithCustomView:self.backButton];
	self.navigationItem.leftBarButtonItem=item;
	self.backButton.hidden = NO;
	self.cancelButton.hidden = YES;
	self.addButton.hidden = NO;
	[self.chooseMoreButton setTitle:@"多选" forState:UIControlStateNormal];
//	[self.collectionView.mj_header beginRefreshing];
	[self HTTPGetFlowMeterDatas];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self.collectionView reloadData];
	});
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"人脸识别";
	self.view.backgroundColor = [UIColor whiteColor];
	self.time = @"1";
	self.status = @"A46000_C_STATUS_0002";
	//此处必须要有创见一个UICollectionViewFlowLayout的对象
	UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
	//同一行相邻两个cell的最小间距
	layout.minimumInteritemSpacing = 0;
	//最小两行之间的间距
	layout.minimumLineSpacing = 0;
	CGFloat y = NavStatusHeight + 40;
	if (@available(iOS 11.0,*)) {
		self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//		y = NavStatusHeight + 40;
	} else {
		self.automaticallyAdjustsScrollViewInsets = NO;
//		y = 40;
	}
	CGRect rect = CGRectZero;
	if (self.isTab == YES) {//从tab页今入
		rect=CGRectMake(0, y, KScreenWidth, KScreenHeight - y - 40 - WD_TabBarHeight);
	} else {
		rect = CGRectMake(0, y, KScreenWidth, KScreenHeight - y);
	}
	_collectionView=[[UICollectionView alloc]initWithFrame:rect collectionViewLayout:layout];
	layout.headerReferenceSize = CGSizeMake(0, 30);
	[layout setItemSize:CGSizeMake(KScreenWidth/3, KScreenWidth/3 + 60)];
	_collectionView.backgroundColor=[UIColor whiteColor];
	_collectionView.delegate=self;
	_collectionView.dataSource=self;
	//这个是横向滑动
	//layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
	[self.view addSubview:_collectionView];
	self.shopArrive = @"";
	[self createCountLabel];
	[self getChooseDatas];
//    [self addChooseView];
	[self setUpRefresh];
	
	
	/*
	 *这是重点 必须注册cell
	 */
	//这种是xib建的cell 需要这么注册
	UINib *cellNib=[UINib nibWithNibName:@"MJKFlowMeterListCollectionViewCell" bundle:nil];
	[_collectionView registerNib:cellNib forCellWithReuseIdentifier:@"MJKFlowMeterListCollectionViewCell"];
	
	// 注册collectionView头部的view，需要注意的是这里的view需要继承自UICollectionReusableView
	[_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
	if (self.isTab == YES) {
		[self createBottomView];
	} else {
		[self createAddButton];
		[self configNavi];
	}
	
	
}

- (void)configNavi {
	//多选
	UIButton *moreChooseButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 15)];
	self.chooseMoreButton = moreChooseButton;
	[moreChooseButton setTitle:@"多选" forState:UIControlStateNormal];
	[moreChooseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	moreChooseButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
	[moreChooseButton addTarget:self action:@selector(clickMoreChoose:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:moreChooseButton];;
	self.navigationItem.rightBarButtonItem = barButton;
	//	取消
	UIButton *cancelChooseButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 15)];
	cancelChooseButton.hidden = YES;
	self.cancelButton = cancelChooseButton;
	[cancelChooseButton setTitle:@"取消" forState:UIControlStateNormal];
	[cancelChooseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	cancelChooseButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
	[cancelChooseButton addTarget:self action:@selector(clickCancelMoreChoose:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithCustomView:cancelChooseButton];;
	self.navigationItem.leftBarButtonItem = cancelButton;
	
	UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0, 44,44)];
	self.backButton = backButton;
	backButton.hidden = YES;
	UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 11 , 17)];
	imgview.image =[UIImage imageNamed:@"btn-返回.png"];
	[backButton addSubview:imgview];
	[backButton addTarget:self action:@selector(clickBackButton:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)createAddButton {
	UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake((KScreenWidth - 50) / 2, KScreenHeight - 70, 50, 50)];
	self.addButton = addButton;
	[addButton setBackgroundImage:[UIImage imageNamed:@"addimg.png"] forState:UIControlStateNormal];
	[addButton addTarget:self action:@selector(addFlowButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:addButton];
}

- (void)createBottomView {
	UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.collectionView.frame), KScreenWidth, 40)];
	[self.view addSubview:bottomView];
	bottomView.backgroundColor = kBackgroundColor;
	
	UIButton *chooseMoreButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(bottomView.frame) - 20 - 60, 0, 60, bottomView.frame.size.height)];
	[chooseMoreButton setTitleNormal:@"多选"];
	[chooseMoreButton setTitleColor:[UIColor darkGrayColor]];
	chooseMoreButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
	[bottomView addSubview:chooseMoreButton];
	self.chooseMoreButton = chooseMoreButton;
	[chooseMoreButton addTarget:self action:@selector(clickMoreChoose:)];
	
	UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(bottomView.frame) + 20, 0, 60, bottomView.frame.size.height)];
	cancelButton.hidden = YES;
	[cancelButton setTitleColor:[UIColor darkGrayColor]];
	[cancelButton setTitleNormal:@"取消"];
	cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
	[bottomView addSubview:cancelButton];
	self.cancelButton = cancelButton;
	[cancelButton addTarget:self action:@selector(clickCancelMoreChoose:)];
}
	

- (void)createCountLabel {
	UILabel *wflLabel = [[UILabel alloc]init];
	self.wclLabel = wflLabel;
	UILabel *pcLabel = [[UILabel alloc]init];
	self.pcLabel = pcLabel;
	UILabel *yxLabel = [[UILabel alloc]init];
	self.yxLabel = yxLabel;
	UILabel *allLabel = [[UILabel alloc]init];
	self.allLabel =allLabel;
	[self.view addSubview:allLabel];
	[self.view addSubview:yxLabel];
	[self.view addSubview:pcLabel];
	[self.view addSubview:wflLabel];
}

- (void)countLabel {
	//未处理
	CGRect StatusRect = [[UIApplication sharedApplication] statusBarFrame];
	CGRect NavRect = self.navigationController.navigationBar.frame;
	CGFloat height = StatusRect.size.height + NavRect.size.height + 39;
	CGRect wflRect = [[NSString stringWithFormat:@"未处理:%@",self.meterModel.wfpCount] boundingRectWithSize:CGSizeMake(1000, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue" size:12.0f],NSFontAttributeName, nil] context:nil];
	self.wclLabel.frame = CGRectMake(KScreenWidth - (wflRect.size.width + 15), height, wflRect.size.width + 15, 20);
	//批次
	CGRect pcRect = [[NSString stringWithFormat:@"批次:%@",self.meterModel.pcCount] boundingRectWithSize:CGSizeMake(1000, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue" size:12.0f],NSFontAttributeName, nil] context:nil];
	self.pcLabel.frame = CGRectMake(KScreenWidth - self.wclLabel.frame.size.width - (pcRect.size.width + 15), height, pcRect.size.width + 15, 20);
	//有效
	CGRect yxRect = [[NSString stringWithFormat:@"有效:%@",self.meterModel.yxCount] boundingRectWithSize:CGSizeMake(1000, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue" size:12.0f],NSFontAttributeName, nil] context:nil];
	self.yxLabel.frame = CGRectMake(KScreenWidth - self.wclLabel.frame.size.width - self.pcLabel.frame.size.width - (yxRect.size.width + 15), height, yxRect.size.width + 15, 20);
	
	 CGRect allRect = [[NSString stringWithFormat:@"总计:%@",self.meterModel.allCount] boundingRectWithSize:CGSizeMake(1000, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue" size:12.0f],NSFontAttributeName, nil] context:nil];
	self.allLabel.frame = CGRectMake(KScreenWidth - self.wclLabel.frame.size.width - self.pcLabel.frame.size.width - self.yxLabel.frame.size.width - (allRect.size.width + 15), height, allRect.size.width + 15, 20);
	
	self.allLabel.layer.cornerRadius =
	self.yxLabel.layer.cornerRadius =
	self.pcLabel.layer.cornerRadius =
	self.wclLabel.layer.cornerRadius = 3.0f;
	
	self.allLabel.textColor =
	self.yxLabel.textColor =
	self.pcLabel.textColor =
	self.wclLabel.textColor = [UIColor grayColor];
	
	self.allLabel.font =
	self.yxLabel.font =
	self.pcLabel.font =
	self.wclLabel.font = [UIFont systemFontOfSize:12.0f];
	
	self.allLabel.layer.borderWidth =
	self.yxLabel.layer.borderWidth =
	self.pcLabel.layer.borderWidth =
	self.wclLabel.layer.borderWidth = 1.0f;
	
	self.allLabel.layer.borderColor =
	self.yxLabel.layer.borderColor =
	self.pcLabel.layer.borderColor =
	self.wclLabel.layer.borderColor = DBColor(203, 203, 209).CGColor;
	
	self.allLabel.textAlignment =
	self.yxLabel.textAlignment =
	self.pcLabel.textAlignment =
	self.wclLabel.textAlignment = NSTextAlignmentCenter;
	
	self.allLabel.backgroundColor =
	self.yxLabel.backgroundColor =
	self.pcLabel.backgroundColor =
	self.wclLabel.backgroundColor = [UIColor whiteColor];
	
	self.allLabel.text = self.meterModel.allCount.length > 0 ? [NSString stringWithFormat:@"总计:%@",self.meterModel.allCount] : @"0";
	self.yxLabel.text = self.meterModel.yxCount.length > 0 ? [NSString stringWithFormat:@"有效:%@",self.meterModel.yxCount] : @"0";
	self.pcLabel.text = self.meterModel.pcCount.length > 0 ? [NSString stringWithFormat:@"批次:%@",self.meterModel.pcCount] : @"0";
	self.wclLabel.text = self.meterModel.wfpCount.length > 0 ? [NSString stringWithFormat:@"未处理:%@",self.meterModel.wfpCount] : @"0";
}

//一共有多少个组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
	return self.meterModel.content.count;
}
//每一组有多少个cell
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
	MJKFlowMeterSubModel *subModel = self.meterModel.content[section];
	return subModel.content.count;
}
//每一个cell是什么
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
	MJKFlowMeterSubModel *subModel = self.meterModel.content[indexPath.section];
	MJKFlowMeterSubSecondModel *subSecondModel = subModel.content[indexPath.row];
	MJKFlowMeterListCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"MJKFlowMeterListCollectionViewCell" forIndexPath:indexPath];
	cell.isMore = self.isMore;
	cell.model = subSecondModel;
	cell.backgroundColor=[UIColor whiteColor];
	self.subSecondModel = subSecondModel;
	DBSelf(weakSelf);
    cell.chooseMoreBlock = ^(MJKFlowMeterSubSecondModel *backModel) {
        if (backModel.isSelected == YES) {
            [weakSelf.allModelArray addObject:backModel];
            [weakSelf.chooseMoreArray addObject:backModel.C_ID];
//            [weakSelf.C_A41500_C_IDArray addObject:C_A41500_C_ID];
//            [weakSelf.C_A41500_C_NAMEArray addObject:C_A41500_C_NAME];
//            [weakSelf.headImageArray addObject:headImageStr];
        } else {
            NSArray *arr = [NSArray arrayWithArray:weakSelf.allModelArray];
            for (MJKFlowMeterSubSecondModel *chooseModel in arr) {
                if ([chooseModel.C_ID isEqualToString:backModel.C_ID]) {
                    [weakSelf.allModelArray removeObject:chooseModel];
                    [weakSelf.chooseMoreArray removeObject:chooseModel.C_ID];
                }
            }
//            [weakSelf.C_A41500_C_IDArray removeObject:C_A41500_C_ID];
//            [weakSelf.C_A41500_C_NAMEArray removeObject:C_A41500_C_NAME];
//            [weakSelf.headImageArray removeObject:headImageStr];
        }
		
	};
	return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
	MJKFlowMeterSubModel *subModel = self.meterModel.content[indexPath.section];
	UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
	//此处的header可能会产生复用，所以在使用之前要将其中的原有的子视图移除掉
	for (UIView* view in header.subviews) {
		[view removeFromSuperview];
	}
	header.backgroundColor = DBColor(236, 237,241);
	UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, header.frame.size.width, header.frame.size.height)];
	headerLabel.font = [UIFont systemFontOfSize:14];
	headerLabel.textColor = [UIColor grayColor];
	headerLabel.text = subModel.total;
	[header addSubview:headerLabel];
	return header;
	
}

- (void)addChooseView {
	CGRect StatusRect = [[UIApplication sharedApplication] statusBarFrame];
	CGRect NavRect = self.navigationController.navigationBar.frame;
	CFDropDownMenuView *menuView = [[CFDropDownMenuView alloc]initWithFrame:CGRectMake(0, StatusRect.size.height + NavRect.size.height, KScreenWidth - 40, 40)];
	[self.view addSubview:menuView];
	menuView.VCName = @"流量仪";
	
	menuView.dataSourceArr = self.TableChooseDatas;
    menuView.defaulTitleArray = @[[self.CREATE_TIME_TYPE isEqualToString:@"0"] ? @"全部" : @"今天", @"未处理", @"上次接待", @"位置" ];
	menuView.startY=CGRectGetMaxY(menuView.frame);
	
	DBSelf(weakSelf);
	menuView.chooseConditionBlock = ^(NSString *selectedSection, NSString *selectedRow, NSString *title) {
		weakSelf.pagen = 20;
		weakSelf.pages = 1;
		[weakSelf selectScreenDatas:selectedSection.integerValue andRow:selectedRow.integerValue andTitle:title];
	};
	
	
	FunnelShowView *funnelView = [FunnelShowView funnelShowView];
	
	funnelView.allDatas = self.FunnelDatas;
	funnelView.sureBlock = ^(NSMutableArray *array) {
		for (NSDictionary*dict in array) {
			NSString*indexStr=dict[@"index"];
			MJKFunnelChooseModel*model=dict[@"model"];
			
			if ([indexStr isEqualToString:@"0"]) {
				weakSelf.shopArrive = model.c_id;
			} else if ([indexStr isEqualToString:@"1"])  {
				weakSelf.thisReceptionSaleID = model.c_id;
            } else if ([indexStr isEqualToString:@"2"]) {
                weakSelf.isHistroy = model.c_id;
            }
		}
		[weakSelf.collectionView.mj_header beginRefreshing];
	};
	
	funnelView.resetBlock = ^{
		weakSelf.shopArrive = @"";
		weakSelf.thisReceptionSaleID = @"";
        weakSelf.isHistroy = @"";
        [weakSelf.collectionView.mj_header beginRefreshing];
	};
	
	[[UIApplication sharedApplication].keyWindow addSubview:funnelView];
	//这个是漏斗按钮
	CFRightButton*funnelButton=[[CFRightButton alloc]initWithFrame:CGRectMake(KScreenWidth-40,NavStatusHeight, 40, 40)];
	[self.view addSubview:funnelButton];
	funnelButton.clickFunnelBlock = ^(BOOL isSelected) {
		//tablieView
		[menuView hide];
		//显示 左边的view
		[funnelView show];
	};
	
	//分割线
//	UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(0, 104, KScreenWidth , 1)];
//	sepView.backgroundColor = DBColor(213, 213, 218);
//	[self.view addSubview:sepView];
}

-(void)showTimeAlertVC{
	//自定义的选择时间界面。
	DBSelf(weakSelf);
	MJKDateViewPicker * dateView=[[MJKDateViewPicker alloc] initWithFrame:self.view.bounds withStart:^{
		
	} withEnd:^{
		
	} withSure:^(NSString *start, NSString *end) {
		self.CREATE_TIME_TYPE = @"";
		weakSelf.pagen = 20;
		weakSelf.pages = 1;
		weakSelf.START_TIME = start;
		weakSelf.END_TIME = end;
		[weakSelf.collectionView.mj_header beginRefreshing];
	}];
	[[UIApplication sharedApplication].keyWindow addSubview:dateView];
}

-(void)setUpRefresh{
	self.pages = 1;
	self.pagen = 20;
	DBSelf(weakSelf);
	self.collectionView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
		weakSelf.pages = 1;
		weakSelf.pagen = 20;
		[self HTTPGetFlowMeterDatas];
	}];
	
	self.collectionView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
		weakSelf.pagen += 20;
		[self HTTPGetFlowMeterDatas];
	}];
	[self.collectionView.mj_header beginRefreshing];
}

//cell的点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
	if (self.isMore == YES) {
		return;
	}
	//cell被电击后移动的动画
//	[collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionTop];
//    if (![[NewUserSession instance].appcode containsObject:@"APP010_0014"]) {
//        [JRToast showWithText:@"账号无权限"];
//        return;
//    }
    
    MJKFlowMeterSubModel *subModel = self.meterModel.content[indexPath.section];
    MJKFlowMeterSubSecondModel *subSecondModel = subModel.content[indexPath.row];
    
    MJKFlowProcessViewController *vc = [[MJKFlowProcessViewController alloc]init];
    if (self.superVC != nil) {
        vc.superVC = self.superVC;
    } else {
        vc.superVC = self;
    }
    vc.X_REMARK = subSecondModel.X_REMARK;
    vc.vcName = @"人脸";
    if ([subSecondModel.C_ARRIVAL_DD_ID isEqualToString:@"A46000_C_STATUS_0004"] || [subSecondModel.C_ARRIVAL_DD_ID isEqualToString:@"A46000_C_STATUS_0003"] || [subSecondModel.C_ARRIVAL_DD_ID isEqualToString:@"A46000_C_STATUS_0001"] || [subSecondModel.C_ARRIVAL_DD_ID isEqualToString:@"A46000_C_STATUS_0000"]) {
        vc.model = subSecondModel;
        vc.type = MJKFlowProcessOneImage;
        vc.vcName = @"详情";
        vc.clueName = @"已处理流量详情";
    }  else if ([subSecondModel.C_ARRIVAL_DD_ID isEqualToString:@"A46000_C_STATUS_0002"]) {
        vc.model = subSecondModel;
        vc.type = MJKFlowProcessOneImage;
    } else {
        vc.model = subSecondModel;
        vc.type = MJKFlowProcessOneImage;
        vc.vcName = @"详情";
        vc.clueName = @"已处理流量详情";
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 点击事件
- (void)addFlowButtonAction:(UIButton *)sender {
//    MJKAddFlowViewController *vc = [[MJKAddFlowViewController alloc]init];
//    vc.superVC = self;
//    [self.navigationController pushViewController:vc animated:YES];
    MJKFlowProcessViewController *vc = [[MJKFlowProcessViewController alloc]init];
    vc.type = MJKFlowProcessOneImage;
    vc.clueName = @"新增";
    if (self.superVC != nil) {
        vc.superVC = self.superVC;
    } else {
        vc.superVC = self;
    }
    vc.vcName = @"人脸";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selectScreenDatas:(NSInteger)section andRow:(NSInteger)row andTitle:(NSString *)title {
	if (section == 0) {
		if ([title isEqualToString:@"自定义"]) {
			self.time = @"";
			[self showTimeAlertVC];
//			return;
		} else {
			self.time = self.TableSelectedChooseDatas[section][row];
			self.CREATE_TIME_TYPE = @"";
			[self.collectionView.mj_header beginRefreshing];
		}
		
	} else if (section == 1) {
		self.status = self.TableSelectedChooseDatas[section][row];
		[self.collectionView.mj_header beginRefreshing];
	} else if (section == 2) {
		self.receptionSaleID = self.TableSelectedChooseDatas[section][row];
		self.saleCode = @"";
		[self.collectionView.mj_header beginRefreshing];
    } else {
        self.posN = self.TableSelectedChooseDatas[section][row];
		[self.collectionView.mj_header beginRefreshing];
    }
	
}

- (void)clickMoreChoose:(UIButton *)sender {
	self.isMore = YES;
	self.addButton.hidden = YES;
	UIBarButtonItem* item=[[UIBarButtonItem alloc]initWithCustomView:self.cancelButton];
	if (self.isTab == YES) {
		self.cancelButton.hidden = NO;
	} else {
		self.navigationItem.leftBarButtonItem=item;
	}
	[self.collectionView reloadData];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self.collectionView reloadData];
	});
	if ([sender.titleLabel.text isEqualToString:@"批量操作"]) {
        
		if (self.allModelArray.count <= 0) {
			[JRToast showWithText:@"请选择"];
			return;
		}
		DBSelf(weakSelf);
		CGCMoreCollection *moreView = [[CGCMoreCollection alloc]initWithFrame:self.view.frame withPicArr:@[@"icon-取消订单.png",@"员工.png", @"流量处理.png",@"重新指派"] withTitleArr:@[@"无效", @"员工", @"流量处理", @"流量指派"] withTitle:@"更多" withSelectIndex:^(NSInteger index, NSString *title) {
			if ([title isEqualToString:@"流量处理"]) {
                if (![[NewUserSession instance].appcode containsObject:@"APP010_0012"]) {
                    [JRToast showWithText:@"账号无权限"];
                    return;
                }
                /*
                 MJKFlowMeterSubModel *subModel = self.meterModel.content[indexPath.section];
                 MJKFlowMeterSubSecondModel *subSecondModel = subModel.content[indexPath.row];
                 */
                NSMutableArray *idArray = [NSMutableArray array];
                NSString *timeStr;
//                for (MJKFlowMeterSubModel *subModel in self.meterModel.content) {
////                    MJKFlowMeterSubSecondModel *subSecondModel = subModel.content.lastObject;
//                    for (MJKFlowMeterSubSecondModel *subSecondModel in subModel.content) {
//                        if (subSecondModel.isSelected == YES) {
//                            timeStr = subSecondModel.D_ARRIVAL_TIME;
//                            [idArray addObject:subSecondModel.C_ID];
//                        }
//                    }
//                }
                MJKFlowProcessViewController *vc = [[MJKFlowProcessViewController alloc]init];
                NSArray *arr = [NSArray arrayWithArray:[weakSelf.allModelArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    MJKFlowMeterSubSecondModel *model1 = obj1;
                    MJKFlowMeterSubSecondModel *model2 = obj2;
                    //入职时间
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
                    
                    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
                    
                    NSDate *date1= [dateFormatter dateFromString:model1.D_ARRIVAL_TIME];
                    NSDate *date2= [dateFormatter dateFromString:model2.D_ARRIVAL_TIME];
                    
                    if (date1 != [date1 earlierDate: date2]) { //不使用intValue比较无效
                        
                        return NSOrderedDescending;//降序
                        
                    }else if (date1 != [date1 laterDate: date2]) {
                        return NSOrderedAscending;//升序
                        
                    }else{
                        return NSOrderedSame;//相等
                    }
                }]];
                for (MJKFlowMeterSubSecondModel *chooseModel in arr) {
                    [weakSelf.headImageArray addObject:chooseModel.C_HEADPIC];
                    [weakSelf.C_A41500_C_IDArray addObject:chooseModel.C_A41500_C_ID];
                    [weakSelf.C_A41500_C_NAMEArray addObject:chooseModel.C_A41500_C_NAME];
                    timeStr = chooseModel.D_ARRIVAL_TIME;
                    [idArray addObject:chooseModel.C_ID];
                }
                NSString *idStr = [idArray componentsJoinedByString:@","];
                vc.headImageArray = weakSelf.headImageArray;
                vc.C_A41500_C_IDArray = weakSelf.C_A41500_C_IDArray;
                vc.C_A41500_C_NAMEArray = weakSelf.C_A41500_C_NAMEArray;
                vc.idArr = idArray;
                vc.type = MJKFlowProcessMoreImage;
                vc.idStr = idStr;
                vc.vcName = @"人脸";
                if (weakSelf.superVC != nil) {
                    vc.superVC = weakSelf.superVC;
                } else {
                    vc.superVC = weakSelf;
                }
                MJKFlowMeterSubSecondModel *flowMeterModel = [[MJKFlowMeterSubSecondModel alloc]init];
                flowMeterModel.D_ARRIVAL_TIME = timeStr;
                vc.model = flowMeterModel;
                [self.navigationController pushViewController:vc animated:YES];
//                MJKFlowMeterConductViewController *vc = [[MJKFlowMeterConductViewController alloc]init];
//                vc.rootViewController = self;
//                NSString *str = [self.chooseMoreArray componentsJoinedByString:@","];
//
//                vc.meterID = str;
//                MJKFlowMeterDetailModel *flowMeterModel = [[MJKFlowMeterDetailModel alloc]init];
//                flowMeterModel.C_HEADPIC = weakSelf.subSecondModel.C_HEADPIC;
//                flowMeterModel.D_ARRIVAL_TIME = timeStr;
//                vc.headImageArray = weakSelf.headImageArray;
//                vc.flowMeterModel = flowMeterModel;
//                vc.chooseArray = weakSelf.chooseMoreArray;
//                [weakSelf.navigationController pushViewController:vc animated:YES];
            } else if ([title isEqualToString:@"流量指派"]) {
                //APP010_0013
                if (![[NewUserSession instance].appcode containsObject:@"crm:a460:plzp"]) {
                    [JRToast showWithText:@"账号无权限"];
                    return;
                }
                NSMutableArray *idArray = [NSMutableArray array];
                NSString *timeStr;
                for (MJKFlowMeterSubModel *subModel in self.meterModel.content) {
                    //                    MJKFlowMeterSubSecondModel *subSecondModel = subModel.content.lastObject;
                    for (MJKFlowMeterSubSecondModel *subSecondModel in subModel.content) {
                        if (subSecondModel.isSelected == YES) {
                            timeStr = subSecondModel.D_ARRIVAL_TIME;
                            [idArray addObject:subSecondModel.C_ID];
                        }
                    }
                }
                NSString *idStr = [idArray componentsJoinedByString:@","];
                
                MJKChooseEmployeesViewController *vc = [[MJKChooseEmployeesViewController alloc]init];
                //APP010_0015
                if ([[NewUserSession instance].appcode containsObject:@"APP010_0015"]) {
                    vc.isAllEmployees = @"是";
                }
                vc.noticeStr = @"无提示";
                vc.chooseEmployeesBlock = ^(MJKClueListSubModel * _Nonnull model) {
                    [weakSelf HTTPInsertFlowDatasWithModel:idStr andCount:[NSString stringWithFormat:@"%ld",idArray.count] andTime:timeStr Complete:^(id data) {
                        [weakSelf HTTPCustomConnect:data[@"C_ID"] andUserID:model.user_id andSuccessBlock:^{
                           [weakSelf HTTPGetFlowMeterDatas];
                        }];
                    }];
                };
                [weakSelf.navigationController pushViewController:vc animated:YES];
                
                
            } else {
				if ([title isEqualToString:@"无效"]) {
					if (![[NewUserSession instance].appcode containsObject:@"crm:a460:plwx"]) {
						[JRToast showWithText:@"账号无权限"];
						return;
					}
				} else if ([title isEqualToString:@"员工"]) {
					if (![[NewUserSession instance].appcode containsObject:@"crm:a460:plyg"]) {
						[JRToast showWithText:@"账号无权限"];
						return;
					}
				} else if ([title isEqualToString:@"黑名单"]) {
//                    if (![[NewUserSession instance].appcode containsObject:@"APP010_0010"]) {
//                        [JRToast showWithText:@"账号无权限"];
//                        return;
//                    }
				} else {
					return;
				}
				[weakSelf alertView:title];
			}
		}];
//		[self.view addSubview:moreView];
		[[UIApplication sharedApplication].keyWindow addSubview:moreView];
	}
	[sender setTitle:@"批量操作" forState:UIControlStateNormal];
	self.cancelButton.hidden = NO;
	
}

- (void)alertView:(NSString *)title {
	
	DBSelf(weakSelf);
	UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"是否将此流量转为%@",title] preferredStyle:UIAlertControllerStyleAlert];
	
	UIAlertAction *trueAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		if ([title isEqualToString:@"无效"]) {
			[weakSelf HTTPUpdataFlowMeterData:@"0"];
		} else if ([title isEqualToString:@"员工"]) {
			[weakSelf HTTPUpdataFlowMeterData:@"1"];
		} else if ([title isEqualToString:@"黑名单"]) {
			[weakSelf HTTPUpdataFlowMeterData:@"2"];
		}
	}];
	
	UIAlertAction *falseAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		
	}];
	[alertView addAction:falseAction];
	[alertView addAction:trueAction];
	
	[self presentViewController:alertView animated:YES completion:nil];
}

- (void)clickCancelMoreChoose:(UIButton *)sender {
	sender.hidden = YES;
	self.addButton.hidden = NO;
	[self.chooseMoreButton setTitle:@"多选" forState:UIControlStateNormal];
	self.isMore = NO;
	[self.collectionView reloadData];
	[self.headImageArray removeAllObjects];
	[self.chooseMoreArray removeAllObjects];
    [self.allModelArray removeAllObjects];
    [self.C_A41500_C_IDArray removeAllObjects];
    [self.C_A41500_C_NAMEArray removeAllObjects];
	for (MJKFlowMeterSubModel *subModel in self.meterModel.content) {
		for (MJKFlowMeterSubSecondModel *model in subModel.content) {
			model.selected = NO;
		}
	}
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self.collectionView reloadData];
	});
	
	UIBarButtonItem* item=[[UIBarButtonItem alloc]initWithCustomView:self.backButton];
	self.navigationItem.leftBarButtonItem=item;
	if (self.isTab == YES) {
		self.cancelButton.hidden = YES;
	}
	self.backButton.hidden = NO;
}

- (void)clickBackButton:(UIButton *)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 筛选的数据
-(void)getChooseDatas{
	DBSelf(weakSelf);
		[weakSelf getSalesListDatas:^(MJKClueListViewModel *clueModel) {
			//到店时间
            
            NSArray * arrivalShopTimeArr=@[@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"今年",@"去年",@"最近7天",@"最近30天",@"自定义"];
            NSArray * arrivalShopTimeCodeArr=@[@"", @"1", @"2", @"3", @"4", @"5", @"6", @"9", @"10", @"7",@"30",@"999"];
			
			//状态
			NSMutableArray*statusSataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A46000_C_STATUS"];
			NSMutableArray*statusArray=[NSMutableArray array];
			NSMutableArray*statusCodeArray=[NSMutableArray array];
			[statusArray addObject:@"全部"];
			[statusCodeArray addObject:@""];
			for (MJKDataDicModel*model in statusSataArray) {
				[statusArray addObject:model.C_NAME];
				[statusCodeArray addObject:model.C_VOUCHERID];
			}
			//上次接待
			NSMutableArray *receptionNameArr = [NSMutableArray array];
			NSMutableArray *receptionNameCodeArr = [NSMutableArray array];
			[receptionNameArr addObject:@"全部"];
			[receptionNameCodeArr addObject:@""];
			for (MJKClueListSubModel *model in clueModel.data) {
				[receptionNameArr addObject:model.nickName];
				[receptionNameCodeArr addObject:model.u051Id];
			}
			
			//位置
			NSMutableArray *posNameArr = [NSMutableArray array];
			NSMutableArray *posNameCodeArr = [NSMutableArray array];
			[posNameArr addObject:@"全部"];
			[posNameCodeArr addObject:@""];
			for (int i = 0; i < weakSelf.onlineModel.content.count; i++) {
				MJKFlowInstrumentSubModel *subModel = weakSelf.onlineModel.content[i];
				[posNameArr addObject:subModel.X_REMARK];
				[posNameCodeArr addObject:subModel.C_NAME];
			}
			
			//总的 筛选tableView 的数据
			NSMutableArray*totailTableDatas=[NSMutableArray arrayWithObjects:arrivalShopTimeArr,statusArray,receptionNameArr,posNameArr, nil];
			weakSelf.TableChooseDatas=totailTableDatas;
			NSMutableArray*totailTAbleSelected=[NSMutableArray arrayWithObjects:arrivalShopTimeCodeArr,statusCodeArray,receptionNameCodeArr,posNameCodeArr, nil];
			weakSelf.TableSelectedChooseDatas=totailTAbleSelected;
			
			//漏斗
			//到店次数
			NSString*Str0=@"到店次数";
			NSMutableArray*mtArr0=[NSMutableArray array];
			NSArray *timesShopArr = [NSArray arrayWithObjects:@"全部",@"首次",@"多次", nil];
			NSArray *timesShopCodeArr = [NSArray arrayWithObjects:@"0", @"1", @"2", nil];
			for (int i = 0; i < timesShopArr.count; i++) {
				MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
				funnelModel.name=timesShopArr[i];
				funnelModel.c_id=timesShopCodeArr[i];
				[mtArr0 addObject:funnelModel];
			}
			NSDictionary*dic0=@{@"title":Str0,@"content":mtArr0};
			
			//本次接待员工
			NSString*Str1=@"本次接待员工";
			NSMutableArray*mtArr1=[NSMutableArray array];
			MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
			funnelModel.name=@"全部";
			funnelModel.c_id=@"";
			[mtArr1 addObject:funnelModel];
			for (MJKClueListSubModel *model in clueModel.data) {
				MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
				funnelModel.name=model.nickName;
				funnelModel.c_id=model.u051Id;
				[mtArr1 addObject:funnelModel];
			}
			
			NSDictionary*dic1=@{@"title":Str1,@"content":mtArr1};
            
            NSString*historyStr0=@"是否去过其他门店";
            NSMutableArray*historymtArr0=[NSMutableArray array];
            NSArray *historyArr = [NSArray arrayWithObjects:@"全部",@"是",@"否", nil];
            NSArray *historyCodeArr = [NSArray arrayWithObjects:@"", @"1", @"0", nil];
            for (int i = 0; i < historyArr.count; i++) {
                MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
                funnelModel.name=historyArr[i];
                funnelModel.c_id=historyCodeArr[i];
                [historymtArr0 addObject:funnelModel];
            }
            NSDictionary*historydic0=@{@"title":historyStr0,@"content":historymtArr0};
			
			NSMutableArray*funnelTotailArr=[NSMutableArray arrayWithObjects:dic0,dic1,historydic0, nil];
			self.FunnelDatas = funnelTotailArr;
			[weakSelf addChooseView];
		
		}];
	
	
}

#pragma mark  -- 得到员工列表
-(void)getSalesListDatas:(void(^)(MJKClueListViewModel *model))complete{
    NSMutableDictionary *contentDict = [NSMutableDictionary dictionary];
    contentDict[@"C_LOCCODE"] = [NewUserSession instance].user.C_LOCCODE;
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/user/list", HTTP_IP] parameters:contentDict compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			MJKClueListViewModel* saleDatasModel = [MJKClueListViewModel yy_modelWithDictionary:data];
			if (complete) {
				complete(saleDatasModel);
			}
		}else{
			[JRToast showWithText:data[@"msg"]];
		}
	}];
	
	
}

#pragma mark  -- 新增流量
- (void)HTTPInsertFlowDatasWithModel:(NSString *)idStr andCount:(NSString *)numStr andTime:(NSString *)timeStr Complete:(void(^)(id data))successBlock {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_flowInsert];
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
    contentDict[@"I_PEPOLE_NUMBER"] = numStr;
    contentDict[@"C_A46000_C_ID"] = idStr;
    contentDict[@"D_ARRIVAL_TIME"] = timeStr;
    contentDict[@"C_ID"] = [DBObjectTools getA41400C_id];
    [dict setObject:contentDict forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            successBlock(data);
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

//@"流量指派"

- (void)HTTPCustomConnect:(NSString *)C_ID andUserID:(NSString *)userID andSuccessBlock:(void(^)(void))completeBlock {
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_ID"] = C_ID;
    contentDic[@"TYPE"] = @"4";
    contentDic[@"USER_ID"] = userID;
    
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:contentDic withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a414/operation", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
        //        DBSelf(weakSelf);
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            if (completeBlock) {
                completeBlock();
            }
            
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

#pragma mark - HTTP request


- (void)HTTPGetFlowMeterDatas {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_GetFlowMeter];
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	[dic setObject:[NSString stringWithFormat:@"%ld",self.pages] forKey:@"currPage"];
	[dic setObject:[NSString stringWithFormat:@"%ld",self.pagen] forKey:@"pageSize"];
	if (self.CREATE_TIME_TYPE.length > 0) {
		self.time = @"";
		if ([self.CREATE_TIME_TYPE isEqualToString:@"0"]) {
			[dic setObject:@"" forKey:@"ARRIVAL_TIME_TYPE"];
		} else {
			[dic setObject:self.CREATE_TIME_TYPE forKey:@"ARRIVAL_TIME_TYPE"];
		}
	}
	if (![self.time isEqualToString:@"999"] && self.time.length > 0) {
		[dic setObject:self.time forKey:@"ARRIVAL_TIME_TYPE"];
	}
	
	[dic setObject:self.status forKey:@"C_ARRIVAL_DD_ID"];
	if (self.START_TIME.length > 0) {
		[dic setObject:self.START_TIME forKey:@"START_TIME"];
	}
	if (self.END_TIME.length > 0 ) {
		[dic setObject:self.END_TIME forKey:@"END_TIME"];
	}
    if (self.posN.length > 0) {
        dic[@"C_DEVICEID"] = self.posN;
    }
	if (self.saleCode.length > 0) {
		[dic setObject:self.saleCode forKey:@"C_SALEID"];
	}
	if (self.receptionSaleID.length > 0) {
		[dic setObject:self.receptionSaleID forKey:@"C_SALEID"];
	}
	if (self.thisReceptionSaleID.length > 0) {
		[dic setObject:self.thisReceptionSaleID forKey:@"USERID"];
	}
    if (self.isHistroy.length > 0) {
        [dic setObject:self.isHistroy forKey:@"guijiflag"];
    }
	[dic setObject:self.shopArrive.length > 0 ? self.shopArrive : @"0" forKey:@"I_ARRIVAL"];
	[dict setObject:dic forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.meterModel = [MJKFlowMeterModel yy_modelWithDictionary:data];
			weakSelf.START_TIME = weakSelf.END_TIME = @"";
			[weakSelf countLabel];
			[weakSelf.collectionView reloadData];
			
		}else{
			[JRToast showWithText:data[@"message"]];
		}
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
	}];
}

- (void)HTTPUpdataFlowMeterData:(NSString *)type {
	NSMutableArray *idArray = [NSMutableArray array];
	for (MJKFlowMeterSubModel *model in self.meterModel.content) {
		for (MJKFlowMeterSubSecondModel *subModel in model.content) {
			if (subModel.isSelected == YES) {
				[idArray addObject:subModel.C_ID];
			}
		}
	}
	NSString *idStr = [idArray componentsJoinedByString:@","];
	//self.subSecondModel.C_ID
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_UpdataFlowMeter];
	[dict setObject:@{@"C_ID" : idStr, @"ARRIVAL_TYPE" : type} forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			[JRToast showWithText:data[@"message"]];
			[weakSelf.collectionView.mj_header beginRefreshing];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

- (NSArray *)timeCode {
	if (!_timeCode) {
		_timeCode = [NSArray arrayWithObjects:@"", @"1", @"7", @"30", @"2", @"3", @"999", nil];
	}
	return _timeCode;
}

- (NSArray *)statusCode {
	if (!_statusCode) {
		_statusCode = [NSArray arrayWithObjects:@"", @"4", @"3", @"2", @"1", @"0", nil];
	}
	return _statusCode;
}

- (NSArray *)shopArriveCode {
	if (!_shopArriveCode) {
		_shopArriveCode = [NSArray arrayWithObjects:@"0", @"1", @"2", nil];
	}
	return _shopArriveCode;
}

//- (NSMutableArray *)chooseMoreArray {
//	if (!_chooseMoreArray) {
//		_chooseMoreArray = [NSMutableArray array];
//	}
//	return _chooseMoreArray;
//}

@end
