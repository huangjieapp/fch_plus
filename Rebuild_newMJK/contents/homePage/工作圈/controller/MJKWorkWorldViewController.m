//
//  MJKWorkWorldViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/11/23.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKWorkWorldViewController.h"

#import "MJKWorkWorldListCell.h"
#import "MJKWorkWorldNewListCell.h"
#import "CGCNavSearchTextView.h"
#import "VoiceView.h"

#import "MJKWorkWorldListModel.h"
#import "MJKWorkWorldObjectMapModel.h"
#import "MJKWorkWorldObjectMapContentModel.h"
#import "MJKWorkReportDetailSubModel.h"

#import "KSPhotoItem.h"
#import "KSPhotoBrowser.h"

#import "MJKAddWorkReporeViewController.h"//新增汇报
#import "MJKWorkWorldSignViewController.h"//打卡签到
#import "MJKWorkWorldPresonalViewController.h"//个人动态
#import "MJKSingleDetailViewController.h"
#import "MJKCommentsViewController.h"
#import "MJKSearchWorkViewController.h"

#import "WXApi.h"

@interface MJKWorkWorldViewController ()<UITableViewDataSource, UITableViewDelegate>

/** pagen*/
@property (nonatomic, assign) NSInteger pagen;
/** data list*/
@property (nonatomic, strong) NSArray *listArray;
/** detailStr*/
@property (nonatomic, strong) NSString *detailStr;
/** CGCNavSearchTextView*/
@property (nonatomic, strong) CGCNavSearchTextView *CurrentTitleView;
/** VoiceView*/
@property (nonatomic, strong) VoiceView *vv;
/** searchStr*/
@property (nonatomic, strong) NSString *searchStr;
@end

@implementation MJKWorkWorldViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"isRefresh"] isEqualToString:@"yes"]) {
		[self.tableView.mj_header beginRefreshing];
	}
	[[NSUserDefaults standardUserDefaults]removeObjectForKey:@"isRefresh"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	if (@available(iOS 11.0,*)) {
		self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}else{
		self.automaticallyAdjustsScrollViewInsets=NO;
	}
	self.title = @"工作圈";
	[self initUI];
	[self configRefresh];
}

- (void)initUI {
	DBSelf(weakSelf);
	self.CurrentTitleView=[[CGCNavSearchTextView alloc] initWithFrame:self.view.bounds withPlaceHolder:@"请输入手机/客户姓名/地址" withRecord:^{//点击录音
		//        MJKVoiceCViewController *voiceVC = [[MJKVoiceCViewController alloc]initWithNibName:@"MJKVoiceCViewController" bundle:nil];
		//        [voiceVC setBackStrBlock:^(NSString *str){
		//            if (str.length>0) {
		//                _CurrentTitleView.textField.text = str;
		//                self.searchStr=str;
		//                [self.tableView.mj_header beginRefreshing];
		//            }
		//        }];
		self.vv = [[VoiceView alloc]initWithFrame:self.view.frame];
		
		[self.view addSubview:self.vv];
		//        [weakSelf presentViewController:voiceVC animated:YES completion:nil];
		[weakSelf.vv start];
		weakSelf.vv.recordBlock = ^(NSString *str) {
			
			_CurrentTitleView.textField.text = str;
			self.searchStr=str;
			[self.tableView.mj_header beginRefreshing];
			
		};
		
	} withText:^{//开始编辑
		MyLog(@"编辑");
		
		
	}withEndText:^(NSString *str) {//结束编辑
		NSLog(@"%@____",str);
		if (str.length>0) {
			self.searchStr=str;
			[self.tableView.mj_header beginRefreshing];
		}else{
			self.searchStr=@"";
			[self.tableView.mj_header beginRefreshing];
		}
	}];
	
	
	
    self.navigationItem.rightBarButtonItems = @[[self createFirstBarItem], [self createSecondBarItem]];
//    self.navigationItem.rightBarButtonItem = [self createFirstBarItem];
	[self.view addSubview:self.tableView];
}

- (UIBarButtonItem *)createFirstBarItem {
	UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 44)];
	[addButton setImage:@"head+"];
	[addButton addTarget:self action:@selector(addData:)];
	return [[UIBarButtonItem alloc]initWithCustomView:addButton];
}

- (UIBarButtonItem *)createSecondBarItem {
	UIButton *searchButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 44)];
	[searchButton setImage:@"搜索按钮"];
	[searchButton addTarget:self action:@selector(searchbuttonAction:)];
	return [[UIBarButtonItem alloc]initWithCustomView:searchButton];
}

- (void)getOwnerReportList {
    [KVNProgress showWithStatus:@"正在加载中,请稍后"];
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A48600WebService-getDetails"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dict setObject:dic forKey:@"content"];
    DBSelf(weakSelf);
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            MJKAddWorkReporeViewController *vc = [[MJKAddWorkReporeViewController alloc]init];
            vc.isAddWorkWorld = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        [KVNProgress dismiss];
    }];
}

#pragma mark - add button and search button
- (void)addData:(UIButton *)sender {
	DBSelf(weakSelf);
	UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
	UIAlertAction *dayWorkAction = [UIAlertAction actionWithTitle:@"日报" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf getOwnerReportList];
        
		//新增
		
	}];
	UIAlertAction *signAction = [UIAlertAction actionWithTitle:@"打卡" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		MJKWorkWorldSignViewController *vc = [[MJKWorkWorldSignViewController alloc]init];
		[weakSelf.navigationController pushViewController:vc animated:YES];
	}];
	UIAlertAction *materialAction = [UIAlertAction actionWithTitle:@"素材" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

	}];
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		
	}];
	
	[alertC addAction:dayWorkAction];
	[alertC addAction:signAction];
//	[alertC addAction:materialAction];
	[alertC addAction:cancelAction];
	[self presentViewController:alertC animated:YES completion:nil];
}

- (void)searchbuttonAction:(UIButton *)sender {
    DBSelf(weakSelf);
    
    sender.selected = !sender.isSelected;
    [sender setImage:sender.isSelected == YES ? @"X图标" : @"搜索按钮"];
    if (sender.isSelected == YES) {
        MJKSearchWorkViewController *searchVC = [[MJKSearchWorkViewController alloc]init];
        searchVC.searchBlock = ^(NSString * _Nonnull type, NSString * _Nonnull searchText) {
            weakSelf.C_TYPE_DD_ID = type;
            weakSelf.searchStr = searchText;
            [weakSelf.tableView.mj_header beginRefreshing];
        };
        searchVC.searchBackButtonBlock = ^{
            if (weakSelf.C_TYPE_DD_ID.length <= 0) {
                [sender setImage:@"搜索按钮"];
            }
        };
        [self presentViewController:searchVC animated:YES completion:nil];
    } else {
        self.C_TYPE_DD_ID = @"";
        self.searchStr = @"";
        [self.tableView.mj_header beginRefreshing];
        
    }
}

#pragma mark - config refresh
- (void)configRefresh {
	DBSelf(weakSelf);
	self.pagen = 20;
	self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
		weakSelf.pagen = 20;
		[weakSelf httpGetWorkList];
	}];
	
	self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
		weakSelf.pagen += 20;
		[weakSelf httpGetWorkList];
	}];
	[self.tableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	DBSelf(weakSelf);
	MJKWorkWorldListModel *model = self.listArray[indexPath.row];
	MJKWorkWorldNewListCell *cell = [MJKWorkWorldNewListCell cellWithTableView:tableView];
	cell.model = model;
    cell.detailStr = model.detailStr;
    cell.newShareButtonActionBlock = ^{
       if ([model.C_TYPE_DD_ID isEqualToString:@"A49000_C_TYPE_0005"]) {
           WXMiniProgramObject *object = [WXMiniProgramObject object];
           object.webpageUrl = @"http://www.qq.com";
           object.userName = [NewUserSession instance].C_GID;
//           NSString *str = [NSString stringWithFormat:@"/pages//ticket/ticket?C_ID=%@",model.C_OBJECTID];
          
              object.path = [NSString stringWithFormat:@"/pages//ticket/ticket?C_ID=%@",model.C_OBJECTID] ;    //拉起小程序页面的可带参路径，不填默认拉起小程序首页
          
           UIImage *image = [UIImage imageNamed:@"支付功能_03"];
           object.hdImageData = UIImagePNGRepresentation(image);
           object.withShareTicket = NO;
           object.miniProgramType = WXMiniProgramTypeRelease;
           //        object.miniProgramType = WXMiniProgramTypeTest;
           WXMediaMessage *message = [WXMediaMessage message];
           if ([model.C_TYPE_DD_ID isEqualToString:@"A49000_C_TYPE_0005"]) {
               message.title = @"罚单";
           } else {
               message.title = @"打卡";
           }
           //                message.description = @"小程序描述";
           message.thumbData = nil;  //兼容旧版本节点的图片，小于32KB，新版本优先
           //使用WXMiniProgramObject的hdImageData属性
           message.mediaObject = object;
           
           SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
           req.bText = NO;
           req.message = message;
           req.scene = WXSceneSession;  //目前只支持会话
           [WXApi sendReq:req completion:nil];
       } else {
           SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
           req.bText = YES;
           req.text = model.X_REMARK;
           req.scene = WXSceneSession;
           [WXApi sendReq:req completion:nil];
       }
    };
    cell.clickEditButtonBlock = ^{
        MJKAddWorkReporeViewController *vc = [[MJKAddWorkReporeViewController alloc]init];
        vc.isAddWorkWorld = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
//    cell.detailStr = self.detailStr;
    cell.clickBigImgeBlock = ^(UIImageView * _Nonnull imageView) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSString *imageStr in model.urlList) {
            UIImageView *showImageView = [[UIImageView alloc]init];
            [showImageView sd_setImageWithURL:[NSURL URLWithString:imageStr]];
            KSPhotoItem * item=[KSPhotoItem itemWithSourceView:imageView image:showImageView.image];
            [arr addObject:item];
        }
        KSPhotoBrowser * browser=[KSPhotoBrowser browserWithPhotoItems:arr selectedIndex:imageView.tag - 1000];
        [browser showFromViewController:weakSelf];
    };
    if (![self.name isEqualToString:@"个人动态"]) {
       
        cell.clickShowAllTextBlock = ^(BOOL isSelected) {
            model.objectMap.selected = isSelected;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        };
        cell.clickDetailWorkReportBlock = ^(NSIndexPath * _Nonnull reportIndexPath) {
            MJKWorkWorldObjectMapContentModel *contentModel = model.objectMap.content[reportIndexPath.row];
            [weakSelf httpWorkReportDetailWithC_TYPE_DD_ID:contentModel.C_TYPE_DD_ID andX_OBJECTIDS:contentModel.X_OBJECTIDS andC_ID:model.objectMap.C_ID andCompleteBlock:^(NSString *str) {
                if (contentModel.X_REMARK.length > 0) {
                    weakSelf.detailStr = [NSString stringWithFormat:@"(%@)\n%@", contentModel.X_REMARK, str];
                    
                } else {
                    if (str.length > 0) {
                        weakSelf.detailStr = str;
                    } else {
                        weakSelf.detailStr = @"";
                    }
                    
                    if (contentModel.X_REMARK.length <= 0 && str.length <= 0) {
                        weakSelf.detailStr = @"";
                    }
                }
                model.detailStr = weakSelf.detailStr;
                
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
        };
        cell.clickGotoPresonalBlock = ^{
            MJKWorkWorldPresonalViewController *vc = [[MJKWorkWorldPresonalViewController alloc]init];
            vc.userid = model.USER_ID;
            vc.createTime = model.D_CREATE_TIME;
            vc.C_TYPE_DD_ID = model.C_TYPE_DD_ID;
            vc.headImage = model.C_HEADIMGURL;
            vc.userName = model.USER_NAME;
            
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        
    }
    
    cell.signDetailBlock = ^{
        MJKSingleDetailViewController *vc = [[MJKSingleDetailViewController alloc]init];
        vc.C_ID = model.C_OBJECTID;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    cell.commentButtonBlock = ^{
        MJKCommentsViewController *vc = [[MJKCommentsViewController alloc]init];
        if ([model.C_TYPE_DD_ID isEqualToString:@"A49000_C_TYPE_0000"]) {//日报
            vc.C_OBJECTID = model.C_OBJECTID;
        } else {
            vc.C_OBJECTID = model.C_ID;
        }
        vc.typeStr = @"评论";
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    cell.giveLikeButtonBlock = ^{
        if ([model.fabulous_flag isEqualToString:@"1"]) {
             if ([model.C_TYPE_DD_ID isEqualToString:@"A49000_C_TYPE_0000"]) {//日报
                [weakSelf httpCancelPraiseAction:model.C_OBJECTID];
             } else {
                 [weakSelf httpCancelPraiseAction:model.C_ID];
             }
        } else {
             if ([model.C_TYPE_DD_ID isEqualToString:@"A49000_C_TYPE_0000"]) {//日报
                [weakSelf httpPraiseAction:model.C_OBJECTID];
             } else {
                 [weakSelf httpPraiseAction:model.C_ID];
             }
        }
    };
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MJKWorkWorldListModel *model = self.listArray[indexPath.row];
    CGSize size = CGSizeZero;
//    if (self.detailStr.length > 0) {
//        size = [self.detailStr boundingRectWithSize:CGSizeMake(KScreenWidth - 70, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
//    } else {
//        size = CGSizeZero;
//    }
    if (model.detailStr.length > 0) {
        size = [model.detailStr boundingRectWithSize:CGSizeMake(KScreenWidth - 70, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
    } else {
        size = CGSizeZero;
    }
    
    return [MJKWorkWorldNewListCell heightForCell:model] + size.height;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	return nil;
}

#pragma mark - http data list
#pragma mark 点赞
- (void)httpPraiseAction:(NSString *)C_OBJECT_ID {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A46500WebService-insertFabulous"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"C_OBJECT_ID"] = C_OBJECT_ID;
    dic[@"C_ID"] = [DBObjectTools getWorkReportA61200];
    [dict setObject:dic forKey:@"content"];
    DBSelf(weakSelf);
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            [weakSelf httpGetWorkList];
            [JRToast showWithText:@"点赞成功"];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

#pragma mark 取消点赞
- (void)httpCancelPraiseAction:(NSString *)C_OBJECT_ID {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A46500WebService-deleteFabulous"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"C_OBJECT_ID"] = C_OBJECT_ID;
    [dict setObject:dic forKey:@"content"];
    DBSelf(weakSelf);
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            [weakSelf httpGetWorkList];
            [JRToast showWithText:@"点赞取消"];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}
- (void)httpGetWorkList {
	DBSelf(weakSelf);
	NSMutableDictionary *mainDic = [DBObjectTools getAddressDicWithAction:@"A49000WebService-getList"];
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	dic[@"currPage"] = @"1";
	dic[@"pageSize"] = @(self.pagen);
    if (self.userID.length > 0) {
        dic[@"USER_ID"] = self.userID;
    }
    if (self.C_TYPE_DD_ID.length > 0) {
        dic[@"C_TYPE_DD_ID"] = self.C_TYPE_DD_ID;
    }
    if (self.searchStr.length > 0) {
        dic[@"X_REMARK"] = self.searchStr;
    }
//    self.searchStr.length > 0 ? dic[@"USER_ID"] = self.searchStr : nil;
    
	[mainDic setObject:dic forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mainDic withtype:@"1"];
	
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.listArray = [MJKWorkWorldListModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
			[weakSelf.tableView reloadData];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
		[weakSelf.tableView.mj_header endRefreshing];
		[weakSelf.tableView.mj_footer endRefreshing];
		
	}];
	
}

#pragma mark workReport detail
- (void)httpWorkReportDetailWithC_TYPE_DD_ID:(NSString *)C_TYPE_DD_ID andX_OBJECTIDS:(NSString *)X_OBJECTIDS andC_ID:(NSString *)C_ID andCompleteBlock:(void(^)(NSString *str))successBlock {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A48600WebService-getObjectList"];
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	dic[@"C_TYPE_DD_ID"] = C_TYPE_DD_ID;
	dic[@"X_OBJECTIDS"] = X_OBJECTIDS;
	dic[@"C_ID"] = C_ID;
	[dict setObject:dic forKey:@"content"];
	DBSelf(weakSelf);
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			MJKWorkReportDetailSubModel *contents = [MJKWorkReportDetailSubModel mj_objectWithKeyValues:data];
			NSMutableArray *array = [NSMutableArray array];
			for (NSDictionary *dic in contents.content) {
				[array addObject:dic[@"X_REMARK"]];
			}
			NSString *detailStr = [array componentsJoinedByString:@"\n"];
//            [weakSelf.tableView reloadData];
            if (successBlock) {
                successBlock(detailStr);
            }
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

#pragma mark - set
- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - SafeAreaBottomHeight - NavStatusHeight - WD_TabBarHeight) style:UITableViewStyleGrouped];
		_tableView.dataSource = self;
		_tableView.delegate = self;
		_tableView.estimatedRowHeight = 0;
		_tableView.estimatedSectionFooterHeight = 0;
		_tableView.estimatedSectionHeaderHeight = 0;
		_tableView.tableFooterView = [[UIView alloc]init];
	}
	return _tableView;
}

@end
