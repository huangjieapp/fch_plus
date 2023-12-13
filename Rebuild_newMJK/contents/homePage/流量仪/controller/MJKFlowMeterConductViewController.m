//
//  MJKFlowMeterConductViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/10/11.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKFlowMeterConductViewController.h"
#import "MJKMarketViewController.h"
#import "CGCNavSearchTextView.h"
#import "MJKPickerView.h"
#import "MJKFlowListViewController.h"
#import "MJKShopArriveViewController.h"
#import "AddOrEditlCustomerViewController.h"
#import "CGCCustomModel.h"
#import "CGCAlertDateView.h"
#import "MJKFlowMeterViewController.h"
#import "CustomerFollowAddEditViewController.h"
#import "CustomerFollowAddEditViewController.h"

#import "MJKAddFlowTableViewCell.h"
#import "MJKAddFlowShopTableViewCell.h"
#import "MJKAddFlowSubTableViewCell.h"
#import "MJKClueDetailTableViewCell.h"
#import "MJKClueMemoInDetailTableViewCell.h"
#import "MJKClueMarketTableViewCell.h"
#import "MJKFlowMeterConductTableViewCell.h"
#import "AddCustomerChooseTableViewCell.h"
#import "AddCustomerInputTableViewCell.h"
#import "KSPhotoBrowser.h"

#import "MJKFlowSalesModel.h"
#import "MJKClueListSubModel.h"
#import "MJKFlowMainSaleModel.h"
#import "MJKMarketListModel.h"
#import "MJKFlowNoFlie.h"

#define ChooseCell  @"AddCustomerChooseTableViewCell"

@interface MJKFlowMeterConductViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UISearchBarDelegate,UIAlertViewDelegate, AddOrEditlCustomerViewControllerDelegate>
@property (nonatomic, assign) BOOL isFront;
@property (nonatomic, strong) UITableView *topTableView;
@property (nonatomic, strong) UITableView *bottomTableView;
@property (nonatomic, strong) CGCNavSearchTextView *titleView;
@property (nonatomic, strong) MJKPickerView *pickerView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) MJKAddFlowShopTableViewCell *shopCell;

@property (nonatomic, strong) MJKClueListViewModel *clueListModel;
@property (nonatomic, strong) MJKMarketListModel *model;
@property (nonatomic, strong) NSString *peopleNumber;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *marketStr;
@property (nonatomic, strong) NSString *marketCode;
@property (nonatomic, strong) NSString *sourceStr;
@property (nonatomic, strong) NSString *sourceCode;
@property (nonatomic, strong) NSString *shopCode;
@property (nonatomic, strong) NSString *memoStr;
@property (nonatomic, strong) NSString *saleName;
@property (nonatomic, strong) NSString *random;
@property (nonatomic, strong) UIButton *nowButton;
@property (nonatomic, strong) NSString *c_id;//选择返回过来的c_id
@property (nonatomic, strong) NSString *C_REMARK_TYPE_DD_ID;//备注id

@property(nonatomic,strong)NSMutableArray*saveTopImageViewArr;  //保存顶部的imageView
/** 停留时间*/
@property (nonatomic, strong) NSString *stayTime;
/** 逗留时间*/
@property (nonatomic, strong) NSString *stayTimeCode;
/** 随行人员*/
@property (nonatomic, strong) NSString *entourage;
@end

@implementation MJKFlowMeterConductViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(closeKeyBoard:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"流量处理";
    
    [self defineBackButton];
	self.random = [self ret32bitString];
	self.view.backgroundColor = [UIColor whiteColor];
	NSArray *codeArr = [NSArray arrayWithArray:[NewUserSession instance].appcode];
	if ([codeArr containsObject:@"A41400_0010"]) {
		self.isFront = YES;
	} else {
		self.isFront = NO;
	}
	[self initUI];
    [self.topTableView registerNib:[UINib nibWithNibName:@"AddCustomerChooseTableViewCell" bundle:nil] forCellReuseIdentifier:ChooseCell];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    [button setTitle:@"预约列表" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [button addTarget:self action:@selector(yuyueList) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)initUI {
	
	if (_isFront == YES) {
		[self.view addSubview:self.topTableView];
		[self.view addSubview:self.bottomTableView];
		[self.view addSubview:self.searchBar];
		
		UIButton *submitButton = [[UIButton alloc]initWithFrame:CGRectMake(20, KScreenHeight - 45, KScreenWidth - 40, 40)];
		submitButton.backgroundColor =DBColor(246, 184, 11);
		submitButton.layer.cornerRadius = 5.0f;
		[submitButton setTitle:@"提交" forState:UIControlStateNormal];
		[submitButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:submitButton];
	} else {
		if ([self.isVip isEqualToString:@"yes"]) {
			[self.view addSubview:self.topTableView];
            
            UIButton *sureButton = [[UIButton alloc]initWithFrame:CGRectMake(20, KScreenHeight - 120, KScreenWidth-40, 50)];
            [sureButton setTitle:@"预约到店" forState:UIControlStateNormal];
            [sureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [sureButton setBackgroundColor:DBColor(246, 184, 11)];
            [sureButton addTarget:self action:@selector(sureButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:sureButton];
            sureButton.layer.cornerRadius = 3.f;
            
			UIButton *againButton = [[UIButton alloc]initWithFrame:CGRectMake(20, KScreenHeight - 60, KScreenWidth - 40, 50)];
			[againButton setTitle:@"客户到店" forState:UIControlStateNormal];
			[againButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
			[againButton setBackgroundColor:DBColor(246, 184, 11)];
			[againButton addTarget:self action:@selector(sureButtonAction:) forControlEvents:UIControlEventTouchUpInside];
			[self.view addSubview:againButton];
            againButton.layer.cornerRadius = 3.f;
		} else {
			UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
			scrollView.delegate = self;
			[self.view addSubview:scrollView];
			[scrollView addSubview:self.topTableView];
			if (self.headImageArray.count > 4) {
				CGRect frame = self.topTableView.frame;
				frame.size.height = frame.size.height + 80;
				self.topTableView.frame = frame;
			}
			NSArray *buttonTitleArray = [NSArray arrayWithObjects:@"未留档", @"新客户", @"客户到店", @"预约到店", @"重新指派", nil];
			for (int i = 0; i < buttonTitleArray.count; i++) {
				UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, self.topTableView.frame.size.height + i * 50 , KScreenWidth - 40, 40)];
				button.layer.cornerRadius = 5.0f;
				[button setTitle:buttonTitleArray[i] forState:UIControlStateNormal];
				[button setBackgroundColor:DBColor(246, 184, 11)];
				button.tag = 200 + i;
				[button addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
				[scrollView addSubview:button];
			}
			scrollView.contentSize = CGSizeMake(KScreenWidth, self.topTableView.frame.size.height + 40 * buttonTitleArray.count + 40);
		}
		
	}
	_shopCode = _marketCode = _memoStr = @"";
	_saleName = @"";
	[self HTTPGetSalesListDatas];
	[self HTTPGetMarketDatas];
//    [self getTimeNow];
    if (self.flowMeterModel.D_ARRIVAL_TIME.length > 0) {
        self.time = self.flowMeterModel.D_ARRIVAL_TIME;
    } else {
        [self getTimeNow];
    }
}

-(void)defineBackButton{
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem= [UIBarButtonItem itemWithImage:@"btn-返回" highImage:nil isLeft:YES target:self andAction:@selector(goBack)];
    self.navigationItem.leftItemsSupplementBackButton = YES;
    
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (tableView == self.topTableView) {
		return 7;
	} else {
		return self.clueListModel.data.count;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	DBSelf(weakSelf);
	if (tableView == self.topTableView) {
		if (indexPath.row == 0) {
			MJKAddFlowTableViewCell *cell = [MJKAddFlowTableViewCell cellWithTableView:tableView];
			[cell setBackTextBlock:^(NSString *str){
				weakSelf.peopleNumber = str;
			}];
			if (self.peopleNumber.length <= 0) {
				self.peopleNumber = self.chooseArray.count > 0 ? [NSString stringWithFormat:@"%ld",self.chooseArray.count]  : @"1";
			}
			cell.peopleNumberTextField.text = self.peopleNumber;
			return cell;
		} else if (indexPath.row == 2) {
            AddCustomerChooseTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:ChooseCell];
            cell.nameTitleLabel.text=@"来源渠道";
            cell.textStr=self.self.sourceStr;
            cell.Type=ChooseTableViewTypeCustomerSource;
            //            cell.arrowImage.hidden = YES;
            //            cell.chooseTextField.enabled = NO;
            cell.taglabel.hidden=YES;
            cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                MyLog(@"str-- %@      post---%@",str,postValue);
                weakSelf.sourceStr = str;
                weakSelf.sourceCode = postValue;
                
                
                [self.topTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                
            };
            
            return cell;
        } else if (indexPath.row == 3) {
            AddCustomerChooseTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:ChooseCell];
            cell.nameTitleLabel.text=@"渠道细分";
            cell.textStr=self.self.marketStr;
            cell.Type=ChooseTableViewTypeAction;
            //            cell.arrowImage.hidden = YES;
            //            cell.chooseTextField.enabled = NO;
            cell.taglabel.hidden=YES;
            cell.SourceID = self.sourceCode;
            cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                MyLog(@"str-- %@      post---%@",str,postValue);
                weakSelf.marketStr = str;
                weakSelf.marketCode = postValue;
                
                
                [self.topTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                
            };
            
            return cell;
        } else if  (indexPath.row == 1) {
            
            AddCustomerChooseTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:ChooseCell];
            cell.BottomLineView.hidden=YES;
            cell.nameTitleLabel.text=@"到店时间";
			cell.chooseTextField.enabled = NO;
			cell.arrowImage.hidden = YES;
            cell.Type=ChooseTableViewTypeAllTime;
            cell.chooseTextField.text=self.time;
            cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                MyLog(@"%@%@",str,postValue);
                self.time=postValue;
            };
            
            return cell;
            
        } else if (indexPath.row == 4)  {
			  AddCustomerChooseTableViewCell *cell = [AddCustomerChooseTableViewCell cellWithTableView:tableView];
			cell.nameTitleLabel.text=@"逗留时间";
			cell.textStr=self.stayTime;
			cell.Type=ChooseTableViewTypeMimute;
			//            cell.arrowImage.hidden = YES;
			//            cell.chooseTextField.enabled = NO;
			cell.taglabel.hidden=YES;
			cell.chooseBlock = ^(NSString *str, NSString *postValue) {
				MyLog(@"str-- %@      post---%@",str,postValue);
				weakSelf.stayTime = str;
				weakSelf.stayTimeCode = postValue;
				
				[weakSelf.topTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
				
			};
			return cell;
		  } else if (indexPath.row == 5) {
			  AddCustomerInputTableViewCell *cell = [AddCustomerInputTableViewCell cellWithTableView:tableView];
			  cell.nameTitleLabel.text = @"随行人员";
//			  cell.inputTextField.keyboardType=UIKeyboardTypeDefault;
			  cell.textStr = self.entourage;
			  cell.changeTextBlock = ^(NSString *textStr) {
				  weakSelf.entourage = textStr;
			  };
//			  cell.textBeginEditBlock = ^{
//				  CGRect viewFrame = weakSelf.view.frame;
//				  viewFrame.origin.y = -300;
//				  weakSelf.view.frame = viewFrame;
//			  };
//			  cell.textEndEditBlock = ^{
//				  CGRect viewFrame = weakSelf.view.frame;
//				  viewFrame.origin.y = 0;
//				  weakSelf.view.frame = viewFrame;
//			  };
			  return cell;
		  } else {
			MJKClueMemoInDetailTableViewCell *cell = [MJKClueMemoInDetailTableViewCell cellWithTableView:tableView];
			cell.titleLabel.text = @"到店备注";
			[cell setBackTextViewBlock:^(NSString *str){
				weakSelf.memoStr = str;
			}];
			return cell;
		}
	} else {
		MJKClueMarketTableViewCell *cell = [MJKClueMarketTableViewCell cellWithTableView:tableView];
		cell.subModel = self.clueListModel.data[indexPath.row];
		return cell;
	}
	
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (tableView == self.topTableView) {
		if (indexPath.row == 6) {
			return 44 + 66;
		} else {
			return 40;
		}
		
	} else {
		return 44;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		if (self.headImageArray.count > 4) {
			return 160;
		} else {
			return 90;
		}
	} else {
		return 20;
	}
	
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *view = [[UIView alloc]initWithFrame:self.topTableView.tableHeaderView.frame];
	view.backgroundColor = DBColor(236, 237,241);
	UILabel *label = [[UILabel alloc]init];
	label.textColor = [UIColor grayColor];
	label.font = [UIFont systemFontOfSize:12.0f];
	if (section == 0) {
		if (self.headImageArray.count > 4) {
			label.frame = CGRectMake(20, 140, 100, 20);
		} else {
			label.frame = CGRectMake(20, 70, 100, 20);
		}
		
		label.text = @"流量信息";
		
		UIView *imageV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, self.headImageArray.count > 4 ? 140 : 70)];
		imageV.backgroundColor = [UIColor whiteColor];
		[view addSubview:imageV];
		
        self.saveTopImageViewArr=[NSMutableArray array];
		for (int i = 0; i < self.headImageArray.count; i++) {
			UIImageView *imageView = [[UIImageView alloc]init];
			[imageV addSubview:imageView];
			imageView.layer.cornerRadius = 5.0f;
			imageView.layer.masksToBounds = YES;
            
            [self.saveTopImageViewArr addObject:imageView];
            imageView.tag=1000+i;
            imageView.userInteractionEnabled=YES;
            UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scaleImageV:)];
            [imageView addGestureRecognizer:tap];

			
			if (self.headImageArray.count < 5) {
				imageView.frame = CGRectMake((imageV.frame.size.width / self.headImageArray.count - 50)  / 2 + ((i > 3 ? (i - 3) : i) * (imageV.frame.size.width / self.headImageArray.count)) , (imageV.frame.size.height - 65) / 2, 50, 65);
			} else {
				imageView.frame = CGRectMake((imageV.frame.size.width / (self.headImageArray.count > 4 ? 4 : self.headImageArray.count) - 50)  / 2 + ((i > 3 ? (i - 4) : i) * (imageV.frame.size.width / (self.headImageArray.count > 4 ? 4 : self.headImageArray.count))) , (imageV.frame.size.height / 2 - 65) / 2 + ((i > 3 ? 1 : 0) * (imageV.frame.size.height / 2)), 50, 65);
			}
			
			NSString *imageStr = self.headImageArray[i];
			if (imageStr.length > 0) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:imageStr]];
//                imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageStr]]];
			}
		}
		
		
	} else {
		label.frame = CGRectMake(20, 0, 100, 20);
		label.text = @"处理信息";
	}
	[view addSubview:label];
	return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 2) {
//        self.pickerView.hidden = NO;
//        self.pickerView.arr = self.model.content;
//        DBSelf(weakSelf);
//        [self.pickerView setSelectBlock:^(NSString *str, NSString *str1,NSString*marketC_id){
//            weakSelf.marketStr = str;
//            weakSelf.marketCode = str1;
//            //            [weakSelf.topTableView reloadData];
//            [weakSelf.topTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        }];
//    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	self.saleName = searchText;
	[self HTTPGetSalesListDatas];
}



#pragma mark - 通知方法
- (void)showKeyBoard:(NSNotification *)noti {
	//键盘弹出动画时长 NSTimeInterval == long
	NSTimeInterval duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	//键盘弹出的动画效果
	UIViewAnimationOptions option = [noti.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
	//键盘弹出后的位置
	CGRect endFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
	MJKAddFlowTableViewCell *cell = [self.topTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	CGFloat y = 0.0;
	
	if (self.isFront == YES) {
		if (endFrame.origin.y < self.searchBar.frame.origin.y + self.searchBar.frame.size.height) {
			y = endFrame.origin.y - (self.searchBar.frame.origin.y + self.searchBar.frame.size.height);
		} else {
			y = 0;
		}
	}
	
	//动画移动 输入框容器
	[UIView animateWithDuration:duration delay:0 options:option animations:^{
		self.view.frame = CGRectMake(0, y, KScreenWidth, KScreenHeight);
	} completion:^(BOOL finished) {
		
	}];
}

- (void)closeKeyBoard:(NSNotification *)noti {
	//键盘弹出动画时长 NSTimeInterval == long
	NSTimeInterval duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	//键盘弹出的动画效果
	UIViewAnimationOptions option = [noti.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
	//动画移动 输入框容器
	[UIView animateWithDuration:duration delay:0 options:option animations:^{
		self.view.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
	} completion:^(BOOL finished) {
		
	}];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//	[self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//	[self.view endEditing:YES];
}

- (void)getTimeNow {
	NSDate *date = [NSDate date];
	NSDateFormatter *dataFormatter = [[NSDateFormatter alloc]init];
    dataFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
	dataFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
	self.time = [dataFormatter stringFromDate:date];
}

#pragma mark - 点击事件
- (void)yuyueList {
    MJKShopArriveViewController *arrVC = [[MJKShopArriveViewController alloc]initWithNibName:@"MJKShopArriveViewController" bundle:nil];
    arrVC.isLook = @"yes";
    [self.navigationController pushViewController:arrVC animated:YES];
}

-(void)scaleImageV:(UITapGestureRecognizer*)tap{
    UIImageView*imageV=(UIImageView*)tap.view;
    NSInteger number=imageV.tag-1000;
    
    NSMutableArray*imageItems=[NSMutableArray array];
    for (int i=0; i<_saveTopImageViewArr.count; i++) {
        UIImageView*newImageV=_saveTopImageViewArr[i];
        KSPhotoItem *item = [KSPhotoItem itemWithSourceView:newImageV image:newImageV.image];
        [imageItems addObject:item];
        
    }
    
    
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:imageItems selectedIndex:number];
    [browser showFromViewController:self];
    
    
}




- (void)submitAction:(UIButton *)sender {
	__block NSString *userId;
	[self.clueListModel.data enumerateObjectsUsingBlock:^(MJKClueListSubModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if (obj.isSelected == YES) {
			userId = obj.u051Id;
		}
	}];
	if (userId.length > 0) {
		[self HTTPInsertFlowDatas:userId complete:^(id data) {
			[self.navigationController popViewControllerAnimated:YES];
		}];
	}
	
}

- (void)clickButtonAction:(UIButton *)sender {
//    if (self.marketCode.length <= 0) {
//        [JRToast showWithText:@"请选择市场活动"];
//        return;
//    }
	//	[self HTTPInsertFlowDatas:[NewUserSession instance].user.u051Id];
	self.nowButton = sender;
	if (sender.tag == 200) {
		//未留档
		DBSelf(weakSelf);
		NSMutableArray*failChooseArray=[NSMutableArray array];
		for (MJKDataDicModel *model in[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A42600_C_REXMARK_TYPE"] ) {
			[failChooseArray addObject:model.C_NAME];
		}
		CGCAlertDateView *alertDateView = [[CGCAlertDateView alloc]initWithFrame:self.view.frame withSelClick:^{
			
		} withSureClick:^(NSString *title, NSString *dateStr) {
			NSLog(@"%@",title);
            if (title.length<1||dateStr.length<1) {
                [JRToast showWithText:@"未留档原因和未留档备注为必填项"];
                return ;
            }
            
            
			weakSelf.C_REMARK_TYPE_DD_ID = @"";
            
#warning 牛逼
			if ([title isEqualToString:@"其他原因"]) {
				weakSelf.C_REMARK_TYPE_DD_ID = @"A42600_C_REXMARK_TYPE_0002";
			} else if ([title isEqualToString:@"已购买其他产品"]) {
				weakSelf.C_REMARK_TYPE_DD_ID = @"A42600_C_REXMARK_TYPE_0001";
			} else {
				weakSelf.C_REMARK_TYPE_DD_ID = @"A42600_C_REXMARK_TYPE_0000";
			}
			[self HTTPInsertFlowDatas:[NewUserSession instance].user.u051Id complete:^(id data) {
				[MJKFlowNoFlie HTTPUpdateFlowWithC_ID:/*self.c_id.length > 0 ? self.c_id : */[NSString stringWithFormat:@"A41400-%@",self.random] andRemark:dateStr andShopType:weakSelf.C_REMARK_TYPE_DD_ID andBlock:^{
					MJKFlowListViewController *vc = [[MJKFlowListViewController alloc]init];
					vc.VCName = @"返回首页";
					[weakSelf.navigationController pushViewController:vc animated:YES];
				}];
			}];
//			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//				MJKFlowListViewController *vc = [[MJKFlowListViewController alloc]init];
//				vc.VCName = @"返回首页";
//				[weakSelf.navigationController pushViewController:vc animated:YES];
//			});
		} withHight:195.0 withText:@"请填写未留档原因" withDatas:failChooseArray];
		alertDateView.textfield.placeholder = @"请选择原因类型";
		alertDateView.remarkText.placeholder = @"请填写备注";
		[self.view addSubview:alertDateView];
	} else if (sender.tag == 201) {
		//新增潜客
		DBSelf(weakSelf);
		AddOrEditlCustomerViewController *addVC = [[AddOrEditlCustomerViewController alloc]init];
		addVC.Type = customerTypeExhibition;
		addVC.delegate = self;
		addVC.superVC = self;
		//		addVC.customerSource = self.shopCode;
		addVC.exhibitionMarketAction = self.marketStr;
		addVC.exhibitionMarketActionID = self.marketCode;
        addVC.exhibitionSourceAction = self.sourceStr;
        addVC.exhibitionSourceActionID = self.sourceCode;
		addVC.exhibitionC_A41400_C_ID = [NSString stringWithFormat:@"A41400-%@",self.random];
        //        self.flowMeterModel.C_HEADPIC;
        addVC.portraitAddress =self.headImageArray[0];
		addVC.exhibitionRemark = self.memoStr;
//		[addVC setCompleteComitBlock:^(NSString *C_ID, CustomerDetailInfoModel *newModel) {
////			[self HTTPInsertFlowDatas:[NewUserSession instance].user.u051Id complete:^(id data) {
//				[weakSelf HTTPCustomConnect:self.c_id.length > 0 ? self.c_id : [NSString stringWithFormat:@"A41400-%@",self.random] andType:@"1" andC_A41500_C_ID:C_ID];
////			}];
//		}];
		
		[weakSelf.navigationController pushViewController:addVC animated:YES];
	} else if (sender.tag == 202) {
		//老客户
		DBSelf(weakSelf);
        MJKCustomerChooseViewController *customListVC = [[MJKCustomerChooseViewController alloc]init];
		customListVC.rootVC = self;
		customListVC.chooseCustomerBlock = ^(CGCCustomModel *model) {
			[weakSelf HTTPInsertFlowDatas:[NewUserSession instance].user.u051Id complete:^(id data) {
				[weakSelf HTTPCustomConnect:[NSString stringWithFormat:@"A41400-%@",self.random] andType:@"3" andC_A41500_C_ID:model.C_A41500_C_ID];
			}];
			
		};
		[self.navigationController pushViewController:customListVC animated:YES];
    } else if (sender.tag == 203) {
        //老客户预约
        
        MJKShopArriveViewController *arrVC = [[MJKShopArriveViewController alloc]initWithNibName:@"MJKShopArriveViewController" bundle:nil];
        DBSelf(weakSelf);
        arrVC.backC_ID = ^(NSString *C_ID) {
            [weakSelf HTTPInsertFlowDatas:[NewUserSession instance].user.u051Id complete:^(id data) {
                [weakSelf HTTPCustomConnect:[NSString stringWithFormat:@"A41400-%@",self.random] andType:@"6" andC_A41500_C_ID:C_ID];
            }];
            
        };
        [self.navigationController pushViewController:arrVC animated:YES];
    } else {
		//重新指派
		DBSelf(weakSelf);
		MJKMarketViewController *marketVC = [[MJKMarketViewController alloc]init];
		marketVC.vcName = @"全部员工";
//		marketVC.clueListModel = self.clueListModel;
		marketVC.C_ID = [NSString stringWithFormat:@"A41400-%@",self.random];
		marketVC.rootViewController = self;
		[marketVC setBackSelectParameterBlock:^(NSString *userId, NSString *name){
			[weakSelf HTTPInsertFlowDatas:[NewUserSession instance].user.u051Id complete:^(id data) {
				[MJKFlowNoFlie updateAssignFlow:nil andSale:userId andC_ID:[NSString stringWithFormat:@"A41400-%@",weakSelf.random]];
				MJKFlowListViewController *vc = [[MJKFlowListViewController alloc]init];
				vc.VCName = @"返回首页";
				[weakSelf.navigationController pushViewController:vc animated:YES];
				
			}];
			
			//			[NSThread sleepForTimeInterval:.5];
			
		}];
		[self.navigationController pushViewController:marketVC animated:YES];
	}
}

//确定按钮
- (void)sureButtonAction:(UIButton *)sender {
	DBSelf(weakSelf);
//	if (self.marketCode.length <= 0) {
//		[JRToast showWithText:@"请选择市场活动"];
//		return;
//	}
		//留的
    
        if ([sender.titleLabel.text isEqualToString:@"预约到店"]) {
            MJKShopArriveViewController *arrVC = [[MJKShopArriveViewController alloc]initWithNibName:@"MJKShopArriveViewController" bundle:nil];
            
            arrVC.backC_ID = ^(NSString *C_ID) {
                [self HTTPInsertFlowDatas:[NewUserSession instance].user.u051Id complete:^(id data) {
                     NSString*currentID=data[@"C_ID"];
                    [weakSelf HTTPCustomConnect:currentID andType:@"6" andC_A41500_C_ID:C_ID];
//                [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
            };
            [weakSelf.navigationController pushViewController:arrVC animated:YES];
        } else {
            [self HTTPInsertFlowDatas:[NewUserSession instance].user.u051Id complete:^(id data) {
                NSString*currentID=data[@"C_ID"];
            [weakSelf HTTPCustomConnect:currentID andType:@"2" andC_A41500_C_ID:weakSelf.flowMeterModel.C_A41500_C_ID];
            }];
        }
		
}

#pragma mark  --delegate
-(void)DelegateForCompleteAddCustomerShowAlertVCToFollow:(CustomerDetailInfoModel *)newModel{
	DBSelf(weakSelf);
	[self HTTPInsertFlowDatas:[NewUserSession instance].user.u051Id complete:^(id data) {
		[weakSelf HTTPCustomConnect:/*self.c_id.length > 0 ? self.c_id : */[NSString stringWithFormat:@"A41400-%@",self.random] andType:@"1" andC_A41500_C_ID:newModel.C_A41500_C_ID];
	}];
	UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:@"提示" message:@"是否为新客户添加跟进" preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction*cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		MJKFlowListViewController *vc = [[MJKFlowListViewController alloc]init];
		vc.VCName = @"返回首页";
		[self.navigationController pushViewController:vc animated:YES];
	}];
	UIAlertAction*sure=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [DBObjectTools httpPostGetCustomerDetailInfoWithC_ID:newModel.C_A41500_C_ID andCompleteBlock:^(CustomerDetailInfoModel *customerDetailModel) {
            CustomerFollowAddEditViewController*vc=[[CustomerFollowAddEditViewController alloc]init];
            vc.Type=CustomerFollowUpAdd;
            customerDetailModel.C_A41500_C_ID=customerDetailModel.C_ID;
            vc.infoModel=customerDetailModel;
            vc.vcSuper=self.rootViewController;
            vc.followText=nil;
            vc.completeBlock = ^{
                MJKFlowListViewController *vc = [[MJKFlowListViewController alloc]init];
                vc.VCName = @"返回首页";
                [self.navigationController pushViewController:vc animated:YES];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }];
		
		
	}];
	[alertVC addAction:cancel];
	[alertVC addAction:sure];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self presentViewController:alertVC animated:YES completion:nil];
    });
    
	
	
	
}

#pragma mark - 数据请求
//销售顾问
- (void)HTTPGetSalesListDatas {
	HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/user/list",HTTP_IP] parameters:@{@"C_NAME" : self.saleName, @"C_LOCCODE" : [NewUserSession instance].user.C_LOCCODE} compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.clueListModel = [MJKClueListViewModel yy_modelWithDictionary:data];
			[weakSelf.bottomTableView reloadData];
		}else{
			[JRToast showWithText:data[@"msg"]];
		}
	}];
}

- (void)HTTPInsertFlowDatas:(NSString *)userid complete:(void(^)(id data))successBlock {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_flowInsert];
	[dict setObject:@{@"C_ID" : [NSString stringWithFormat:@"A41400-%@",self.random], @"I_PEPOLE_NUMBER" : self.peopleNumber, @"D_ARRIVAL_TIME" : self.time, @"USER_ID" : userid, @"C_CLUESOURCE_DD_ID" : self.shopCode, @"C_A41200_C_ID" : self.marketCode.length > 0 ? self.marketCode : @"", @"C_SOURCE_DD_ID" : self.sourceCode.length > 0 ? self.sourceCode : @"", @"X_REMARK" : self.memoStr, @"C_A46000_C_ID" : self.meterID.length > 0 ? self.meterID : self.flowMeterModel.C_ID, @"C_STAYTIME_DD_ID" : self.stayTimeCode.length > 0 ? self.stayTimeCode : @"", @"C_ATTENDANT" : self.entourage.length > 0 ? self.entourage : @"" } forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			successBlock(data);
		}else{
		}
	}];
}

- (void)HTTPGetMarketDatas {
	HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/masterdata/a412/list", HTTP_IP] parameters:@{@"C_TYPE_DD_ID":@"A41200_C_TYPE_0000"} compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.model = [MJKMarketListModel yy_modelWithDictionary:data[@"data"]];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

- (void)HTTPCustomConnect:(NSString *)C_ID andType:(NSString *)type andC_A41500_C_ID:(NSString *)C_A41500_C_ID {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"C_ID"] = C_ID;
    dic[@"TYPE"] = type;
    if ([type isEqualToString:@"6"]) {
        dic[@"C_A41600_C_ID"] = C_A41500_C_ID;
    } else {
        dic[@"C_A41500_C_ID"] = C_A41500_C_ID;
    }
	HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a414/operation", HTTP_IP] parameters:dic compliation:^(id data, NSError *error) {
		DBSelf(weakSelf);
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			if (self.nowButton.tag != 201) {
				MJKFlowListViewController *vc =
				[[MJKFlowListViewController alloc]init];
				vc.VCName = @"返回首页";
				[weakSelf.navigationController pushViewController:vc animated:YES];
			}
			
//			for (UIViewController *controller in weakSelf.navigationController.viewControllers) {
//				if ([controller isKindOfClass:[MJKFlowListViewController class]]) {
//					[weakSelf.navigationController popToViewController:controller animated:YES];
//				}
//			}
		}else{
			[JRToast showWithText:data[@"msg"]];
		}
	}];
}

//随机32位随机数
-(NSString *)ret32bitString {
	char data[32];
	for (int x=0;x<32;data[x++] = (char)('A' + (arc4random_uniform(26))));
	return [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
}

#pragma mark - set
- (UITableView *)topTableView {
	CGFloat height;
	if (@available(iOS 11.0,*)) {
		height = 70;
	} else {
		height = 44;
	}
	if (!_topTableView) {
		_topTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 44 * 8 + 20+height) style:UITableViewStylePlain];
		_topTableView.dataSource = self;
		_topTableView.delegate = self;
		_topTableView.bounces = NO;
	}
	return _topTableView;
}

- (UITableView *)bottomTableView {
	if (!_bottomTableView) {
		_bottomTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.topTableView.frame.size.height + 44, KScreenWidth, KScreenHeight - self.topTableView.frame.size.height - 44 - 50) style:UITableViewStylePlain];
		_bottomTableView.dataSource = self;
		_bottomTableView.delegate = self;
		_bottomTableView.bounces = NO;
	}
	return _bottomTableView;
}

- (UISearchBar *)searchBar {
	if (!_searchBar) {
		_searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, self.topTableView.frame.size.height, KScreenWidth, 44)];
		_searchBar.placeholder = @"搜索";
		_searchBar.delegate = self;
	}
	return _searchBar;
}

- (MJKPickerView *)pickerView {
	if (!_pickerView) {
		_pickerView = [[MJKPickerView alloc]initWithFrame:self.view.frame];
		[self.view addSubview:_pickerView];
	}
	return _pickerView;
}


#pragma mark   --funcation
-(void)goBack{
    if (self.popVC) {
        [self.navigationController popToViewController:self.popVC animated:NO];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
