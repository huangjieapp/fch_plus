//
//  MJKAddFlowViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/8.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKAddFlowViewController.h"
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

#import "MJKAddFlowTableViewCell.h"
#import "MJKAddFlowShopTableViewCell.h"
#import "MJKAddFlowSubTableViewCell.h"
#import "MJKClueDetailTableViewCell.h"
#import "MJKClueMemoInDetailTableViewCell.h"
#import "MJKClueMarketTableViewCell.h"
#import "AddCustomerChooseTableViewCell.h"
#import "AddCustomerInputTableViewCell.h"

#import "MJKFlowSalesModel.h"
#import "MJKClueListSubModel.h"
#import "MJKFlowMainSaleModel.h"
#import "MJKMarketListModel.h"
#import "MJKFlowNoFlie.h"


#define ChooseCell   @"AddCustomerChooseTableViewCell"
@interface MJKAddFlowViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UISearchBarDelegate,UIAlertViewDelegate, AddOrEditlCustomerViewControllerDelegate> {
	BOOL isAddNew;
}
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
@property (nonatomic, strong) NSString *marketStr;//细分
@property (nonatomic, strong) NSString *marketCode;
@property (nonatomic, strong) NSString *shopCode;
@property (nonatomic, strong) NSString *sourceStr;//来源
@property (nonatomic, strong) NSString *sourceCode;
@property (nonatomic, strong) NSString *memoStr;
@property (nonatomic, strong) NSString *saleName;
@property (nonatomic, strong) NSString *random;
@property (nonatomic, strong) UIButton *nowButton;
@property (nonatomic, strong) NSString *c_id;//选择返回过来的c_id
@property (nonatomic, strong) NSString *C_REMARK_TYPE_DD_ID;//备注id
@property (nonatomic, strong) NSString *clueIdStr;
/** 逗留时间*/
@property (nonatomic, strong) NSString *stayTime;
/** 逗留时间*/
@property (nonatomic, strong) NSString *stayTimeCode;
/** 随行人员*/
@property (nonatomic, strong) NSString *entourage;
@end

@implementation MJKAddFlowViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(closeKeyBoard:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"新增流量";
	self.random = [self ret32bitString];
    self.view.backgroundColor = [UIColor whiteColor];
	NSArray *codeArr = [NSArray arrayWithArray:[NewUserSession instance].appcode];
//    if ([codeArr containsObject:@"APP002_0011"]) {
//        self.isFront = YES;
//    } else {
		self.isFront = NO;
//    }
	[self initUI];
    
    [self.topTableView registerNib:[UINib nibWithNibName:ChooseCell bundle:nil] forCellReuseIdentifier:ChooseCell];
}

- (void)initUI {
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    [rightButton setTitle:@"预约列表" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [rightButton addTarget:self action:@selector(yuyueList) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = item;
	
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
		UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
		scrollView.delegate = self;
		[self.view addSubview:scrollView];
		[scrollView addSubview:self.topTableView];
        //[NSArray arrayWithObjects:@"未留档", @"新增客户", @"关联客户", @"重新指派", nil]
		NSArray *buttonTitleArray = [NSArray arrayWithObjects:@"未留档", @"新客户", @"客户到店", @"预约到店", @"重新指派", nil];
		for (int i = 0; i < buttonTitleArray.count; i++) {
			UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, self.topTableView.frame.size.height + i * 50 + 15 - 50, KScreenWidth - 40, 40)];
			button.layer.cornerRadius = 5.0f;
			[button setTitle:buttonTitleArray[i] forState:UIControlStateNormal];
			[button setBackgroundColor:DBColor(246, 184, 11)];
			button.tag = 200 + i;
			[button addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
			[scrollView addSubview:button];
		}
        scrollView.contentSize = CGSizeMake(KScreenWidth, self.topTableView.frame.size.height + 220);
	}
	_shopCode = _marketCode = _memoStr = @"";
	_saleName = @"";
	[self HTTPGetSalesListDatas];
	[self HTTPGetMarketDatas];
	[self getTimeNow];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (tableView == self.topTableView) {
        if (_isFront == YES) {
            return 6;
        } else {
            return 7;
        }
	} else {
		return self.clueListModel.data.count;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	DBSelf(weakSelf);
	if (tableView == self.topTableView) {
        if (_isFront == YES) { //前台
            if (indexPath.row == 0) {
                MJKAddFlowTableViewCell *cell = [MJKAddFlowTableViewCell cellWithTableView:tableView];
                [cell setBackTextBlock:^(NSString *str){
                    weakSelf.peopleNumber = str;
                }];
                if (self.peopleNumber.length <= 0) {
                    self.peopleNumber = @"1";
                }
                return cell;
            } else if (indexPath.row == 1) {
                MJKAddFlowShopTableViewCell *cell = [MJKAddFlowShopTableViewCell cellWithTableView:tableView];
                //第一次进入选择随机到店
                if (self.shopCode.length <= 0) {
                    self.shopCode = @"C_CLUESOURCE_DD_0000";
                }
                [cell setBackFlowShopBlock:^(NSString *str){
                    weakSelf.shopCode = str;
                    [weakSelf.topTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }];
                if ([self.shopCode isEqualToString:@"C_CLUESOURCE_DD_0000"]) {
                    [cell.randomButton setBackgroundImage:[UIImage imageNamed:@"icon_1_highlight.png"] forState:UIControlStateNormal];
                } else if ([self.shopCode isEqualToString:@"C_CLUESOURCE_DD_0002"]) {
                    [cell.orderButton setBackgroundImage:[UIImage imageNamed:@"icon_1_highlight.png"] forState:UIControlStateNormal];
//                    MJKShopArriveViewController *arrVC = [[MJKShopArriveViewController alloc]initWithNibName:@"MJKShopArriveViewController" bundle:nil];
//                    arrVC.backC_ID = ^(NSString *C_ID) {
//                        weakSelf.c_id = C_ID;
//                    };
//                    [self.navigationController pushViewController:arrVC animated:YES];
                } else if ([self.shopCode isEqualToString:@"C_CLUESOURCE_DD_0003"]){
                    [cell.invalidButton setBackgroundImage:[UIImage imageNamed:@"icon_1_highlight.png"] forState:UIControlStateNormal];
                }
                return cell;
                //|| indexPath.row == 3
            }else if (indexPath.row == 2) {
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
                cell.SourceID = self.sourceCode;
                //            cell.arrowImage.hidden = YES;
                //            cell.chooseTextField.enabled = NO;
                cell.taglabel.hidden=YES;
                cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                    MyLog(@"str-- %@      post---%@",str,postValue);
                    weakSelf.marketStr = str;
                    weakSelf.marketCode = postValue;
                    
                    
                    [self.topTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                };
                
                return cell;
            } else if  (indexPath.row == 4 ) {
                //            MJKClueDetailTableViewCell *cell = [MJKClueDetailTableViewCell cellWithTableView:tableView];
                //            [cell updateFlowCell:indexPath.row];
                //            if (indexPath.row == 2) {
                //                if (weakSelf.marketStr.length > 0) {
                //                    cell.contentTextField.text = weakSelf.marketStr;
                //                }
                //            }
                //            if (indexPath.row == 3) {
                //                cell.contentTextField.text = self.time;
                //            }
                //            return cell;
                //            if (indexPath.row == 2) {
                //                cell.contentTextField.text = self.time;
                //            }
                //            return cell;
                
                AddCustomerChooseTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:ChooseCell];
                cell.nameTitleLabel.text=@"到店时间";
                cell.textStr=self.self.time;
                cell.Type=ChooseTableViewTypeAllTime;
                cell.arrowImage.hidden = YES;
                cell.chooseTextField.enabled = NO;
                cell.taglabel.hidden=YES;
                cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                    MyLog(@"str-- %@      post---%@",str,postValue);
                    self.time=str;
                    
                    
                    [self.topTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                };
                
                return cell;
                
                
            }  else {
                MJKClueMemoInDetailTableViewCell *cell = [MJKClueMemoInDetailTableViewCell cellWithTableView:tableView];
                cell.titleLabel.text = @"到店备注";
                [cell setBackTextViewBlock:^(NSString *str){
                    weakSelf.memoStr = str;
                }];
                return cell;
            }
        } else {
            if (indexPath.row == 0) {
                MJKAddFlowTableViewCell *cell = [MJKAddFlowTableViewCell cellWithTableView:tableView];
                [cell setBackTextBlock:^(NSString *str){
                    weakSelf.peopleNumber = str;
                }];
                if (self.peopleNumber.length <= 0) {
                    self.peopleNumber = @"1";
                }
                return cell;
            } else if (indexPath.row == 1) {
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
            } else if (indexPath.row == 2) {
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
            } else if  (indexPath.row == 3 ) {
                //            MJKClueDetailTableViewCell *cell = [MJKClueDetailTableViewCell cellWithTableView:tableView];
                //            [cell updateFlowCell:indexPath.row];
                //            if (indexPath.row == 2) {
                //                if (weakSelf.marketStr.length > 0) {
                //                    cell.contentTextField.text = weakSelf.marketStr;
                //                }
                //            }
                //            if (indexPath.row == 3) {
                //                cell.contentTextField.text = self.time;
                //            }
                //            return cell;
                //            if (indexPath.row == 2) {
                //                cell.contentTextField.text = self.time;
                //            }
                //            return cell;
                
                AddCustomerChooseTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:ChooseCell];
                cell.nameTitleLabel.text=@"到店时间";
                cell.textStr=self.self.time;
                cell.Type=ChooseTableViewTypeAllTime;
                cell.arrowImage.hidden = YES;
                cell.chooseTextField.enabled = NO;
                cell.taglabel.hidden=YES;
                cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                    MyLog(@"str-- %@      post---%@",str,postValue);
                    self.time=str;
                    
                    
                    [self.topTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                };
                
                return cell;
                
                
			} else if (indexPath.row == 4) {
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
				cell.inputTextField.hidden = YES;
				cell.inputTextView.hidden = NO;
				cell.inputTextView.text = self.entourage;
				cell.changeTextBlock = ^(NSString *textStr) {
					weakSelf.entourage = textStr;
					[tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
					
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
			}
			else {
                MJKClueMemoInDetailTableViewCell *cell = [MJKClueMemoInDetailTableViewCell cellWithTableView:tableView];
                cell.titleLabel.text = @"到店备注";
                [cell setBackTextViewBlock:^(NSString *str){
                    weakSelf.memoStr = str;
                }];
                return cell;
            }
        }
		
	} else {
		MJKClueMarketTableViewCell *cell = [MJKClueMarketTableViewCell cellWithTableView:tableView];
		cell.subModel = self.clueListModel.data[indexPath.row];
		return cell;
	}
	
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (tableView == self.topTableView) {
        if (_isFront == YES) {
            if (indexPath.row == 5) {
                return 44 + 66;
            } else if (indexPath.row == 1) {
                return 88;
            } else {
                return 40;
            }
        } else {
            if (indexPath.row == 6) {
                return 44 + 66;
				
			}/* else if (indexPath.row == 5) {
				CGSize size = [self.entourage boundingRectWithSize:CGSizeMake(KScreenWidth - 130, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
				if (size.height + 10 > 44) {
					return size.height + 10;
				} else {
					return 44;
				}
			} */else {
                return 40;
            }
        }
	} else {
		return 44;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 2) {
//        self.pickerView.hidden = NO;
//        self.pickerView.arr = self.model.content;
//        DBSelf(weakSelf);
//        [self.pickerView setSelectBlock:^(NSString *str, NSString *str1,NSString*otherID){
//            weakSelf.marketStr = str;
//            weakSelf.marketCode = str1;
////            [weakSelf.topTableView reloadData];
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
	[self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[self.view endEditing:YES];
}

- (void)getTimeNow {
	NSDate *date = [NSDate date];
	NSDateFormatter *dataFormatter = [[NSDateFormatter alloc]init];
    dataFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
	dataFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
	self.time = [dataFormatter stringFromDate:date];
}

#pragma mark - 点击事件
- (void)submitAction:(UIButton *)sender {
	DBSelf(weakSelf);
	__block NSString *userId;
	[self.clueListModel.data enumerateObjectsUsingBlock:^(MJKClueListSubModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if (obj.isSelected == YES) {
			userId = obj.u051Id;
		}
	}];
	if (userId.length > 0) {
		[self HTTPInsertFlowDatas:userId complete:^(id data) {
			[[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:@"isBack"];
			[weakSelf.navigationController popViewControllerAnimated:YES];
		}];
	}
	
}

- (void)clickButtonAction:(UIButton *)sender {
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
			weakSelf.C_REMARK_TYPE_DD_ID = @"";
			if ([title isEqualToString:@"其他原因"]) {
				weakSelf.C_REMARK_TYPE_DD_ID = @"A42600_C_REXMARK_TYPE_0002";
			} else if ([title isEqualToString:@"已购买其他产品"]) {
				weakSelf.C_REMARK_TYPE_DD_ID = @"A42600_C_REXMARK_TYPE_0001";
			} else {
				weakSelf.C_REMARK_TYPE_DD_ID = @"A42600_C_REXMARK_TYPE_0000";
			}
			[self HTTPInsertFlowDatas:[NewUserSession instance].user.u051Id complete:^(id data) {
				[MJKFlowNoFlie HTTPUpdateFlowWithC_ID:/*self.c_id.length > 0 ? self.c_id : */[NSString stringWithFormat:@"A41400-%@",self.random] andRemark:dateStr andShopType:weakSelf.C_REMARK_TYPE_DD_ID andBlock:^{
					if ([self.superVC isKindOfClass:[MJKFlowMeterViewController class]]) {
						MJKFlowListViewController *vc = [[MJKFlowListViewController alloc]init];
						vc.VCName = @"返回首页";
						[weakSelf.navigationController pushViewController:vc animated:YES];
					} else {
						[[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:@"isBack"];
						[weakSelf.navigationController popViewControllerAnimated:YES];
					}
				}];
			}];
//			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//				if ([self.superVC isKindOfClass:[MJKFlowMeterViewController class]]) {
//					MJKFlowListViewController *vc = [[MJKFlowListViewController alloc]init];
//					vc.VCName = @"返回首页";
//					[weakSelf.navigationController pushViewController:vc animated:YES];
//				} else {
//					[[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:@"isBack"];
//					[weakSelf.navigationController popViewControllerAnimated:YES];
//				}
//				
//			});
		} withHight:195.0 withText:@"请填写未留档原因" withDatas:failChooseArray];
		alertDateView.textfield.placeholder = @"请选择原因类型";
		alertDateView.remarkText.placeholder = @"请填写备注";
		[self.view addSubview:alertDateView];
	} else if (sender.tag == 201) {
		//新增潜客
		DBSelf(weakSelf);
		isAddNew = YES;
		AddOrEditlCustomerViewController *addVC = [[AddOrEditlCustomerViewController alloc]init];
		addVC.Type = customerTypeExhibition;
		addVC.phoneNumber = @"1";
		addVC.delegate = self;
//		addVC.customerSource = self.shopCode;
		addVC.exhibitionMarketAction = self.marketStr;
		addVC.exhibitionMarketActionID = self.marketCode;
        addVC.exhibitionSourceAction = self.sourceStr;
        addVC.exhibitionSourceActionID = self.sourceCode;
		addVC.exhibitionC_A41400_C_ID = [NSString stringWithFormat:@"A41400-%@",self.random];
		addVC.exhibitionRemark = self.memoStr;
//		[addVC setCompleteComitBlock:^(NSString *C_A41500_C_ID){
//			[self HTTPInsertFlowDatas:[NewUserSession instance].user.u051Id complete:^(id data) {
//				[weakSelf HTTPCustomConnect:self.c_id.length > 0 ? self.c_id : [NSString stringWithFormat:@"A41400-%@",self.random] andType:@"1" andC_A41500_C_ID:C_A41500_C_ID];
//			}];
//		}];
		addVC.superVC = self.superVC;
		[weakSelf.navigationController pushViewController:addVC animated:YES];
	} else if (sender.tag == 202) {
		//老客户 再次到店
        isAddNew = NO;
        DBSelf(weakSelf);
        MJKCustomerChooseViewController *customListVC = [[MJKCustomerChooseViewController alloc]init];
        customListVC.rootVC = self;
        customListVC.chooseCustomerBlock = ^(CGCCustomModel *model) {
            [weakSelf HTTPInsertFlowDatas:[NewUserSession instance].user.u051Id complete:^(id data) {
                [weakSelf HTTPCustomConnect:[NSString stringWithFormat:@"A41400-%@",weakSelf.random] andType:@"3" andC_A41500_C_ID:model.C_A41500_C_ID];
            }];

        };

        [self.navigationController pushViewController:customListVC animated:YES];
		
    } else if (sender.tag == 203) {
        MJKShopArriveViewController *arrVC = [[MJKShopArriveViewController alloc]initWithNibName:@"MJKShopArriveViewController" bundle:nil];
        DBSelf(weakSelf);
        arrVC.backC_ID = ^(NSString *C_ID) {
            [weakSelf HTTPInsertFlowDatas:[NewUserSession instance].user.u051Id complete:^(id data) {
                [weakSelf HTTPCustomConnect:[NSString stringWithFormat:@"A41400-%@",weakSelf.random] andType:@"6" andC_A41500_C_ID:C_ID];
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
				if ([self.superVC isKindOfClass:[MJKFlowMeterViewController class]]) {
					MJKFlowListViewController *vc = [[MJKFlowListViewController alloc]init];
					vc.VCName = @"返回首页";
					[weakSelf.navigationController pushViewController:vc animated:YES];
				} else {
				for (UIViewController *controller in weakSelf.navigationController.viewControllers) {
					if ([controller isKindOfClass:[MJKFlowListViewController class]]) {
						[[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:@"isBack"];
						[weakSelf.navigationController popToViewController:controller animated:YES];
					}
				}
				}
				
			}];
			
//			[NSThread sleepForTimeInterval:.5];

		}];
		[self.navigationController pushViewController:marketVC animated:YES];
	}
}

- (void)yuyueList {
    MJKShopArriveViewController *arrVC = [[MJKShopArriveViewController alloc]initWithNibName:@"MJKShopArriveViewController" bundle:nil];
    arrVC.isLook = @"yes";
    [self.navigationController pushViewController:arrVC animated:YES];
}


#pragma mark  --delegate
-(void)DelegateForCompleteAddCustomerShowAlertVCToFollow:(CustomerDetailInfoModel *)newModel{
	DBSelf(weakSelf);
	[self HTTPInsertFlowDatas:[NewUserSession instance].user.u051Id complete:^(id data) {
		[weakSelf HTTPCustomConnect:/*weakSelf.c_id.length > 0 ? weakSelf.c_id : */[NSString stringWithFormat:@"A41400-%@",weakSelf.random] andType:@"1" andC_A41500_C_ID:newModel.C_A41500_C_ID];
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
            if ([self.superVC isKindOfClass:[MJKFlowMeterViewController class]]) {
                vc.completeBlock = ^{
                    MJKFlowListViewController *vc = [[MJKFlowListViewController alloc]init];
                    vc.VCName = @"返回首页";
                    [self.navigationController pushViewController:vc animated:YES];
                };
                
            } else {
                vc.vcSuper=self.superVC;
            }
            
            vc.followText=nil;
            [self.navigationController pushViewController:vc animated:YES];
        }];
		
		
	}];
	[alertVC addAction:cancel];
	[alertVC addAction:sure];
	[self presentViewController:alertVC animated:YES completion:nil];
	
	
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
    [dict setObject:@{@"C_ID" :  [NSString stringWithFormat:@"A41400-%@",self.random], @"I_PEPOLE_NUMBER" : self.peopleNumber, @"D_ARRIVAL_TIME" : self.time, @"USER_ID" : userid, @"C_CLUESOURCE_DD_ID" : self.shopCode, @"C_SOURCE_DD_ID" : self.sourceCode.length > 0 ? self.sourceCode : @"", @"C_A41200_C_ID" : self.marketCode, @"X_REMARK" : self.memoStr, @"C_STAYTIME_DD_ID" : self.stayTimeCode.length > 0 ? self.stayTimeCode : @"", @"C_ATTENDANT" : self.entourage.length > 0 ? self.entourage : @"" } forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			successBlock(data);
		}else{
			[JRToast showWithText:data[@"message"]];
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
			[JRToast showWithText:data[@"msg"]];
		}
	}];
}
- (void)HTTPCustomConnectAndDic:(NSDictionary *)dic {
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a414/operation", HTTP_IP] parameters:dic compliation:^(id data, NSError *error) {
        DBSelf(weakSelf);
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            //            if ([self.superVC isKindOfClass:[MJKFlowMeterViewController class]]) {
            if (isAddNew == YES) {
                
            } else {
                MJKFlowListViewController *vc = [[MJKFlowListViewController alloc]init];
                vc.VCName = @"返回首页";
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
            
            //            } else {
            //            for (UIViewController *controller in weakSelf.navigationController.viewControllers) {
            //                if ([controller isKindOfClass:[MJKFlowListViewController class]]) {
            //                    [weakSelf.navigationController popToViewController:controller animated:YES];
            //                }
            //            }
            //            }
        }else{
            [JRToast showWithText:data[@"msg"]];
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
//			if ([self.superVC isKindOfClass:[MJKFlowMeterViewController class]]) {
				if (isAddNew == YES) {
					
				} else {
					MJKFlowListViewController *vc = [[MJKFlowListViewController alloc]init];
					vc.VCName = @"返回首页";
					[weakSelf.navigationController pushViewController:vc animated:YES];
				}
				
//			} else {
//			for (UIViewController *controller in weakSelf.navigationController.viewControllers) {
//				if ([controller isKindOfClass:[MJKFlowListViewController class]]) {
//					[weakSelf.navigationController popToViewController:controller animated:YES];
//				}
//			}
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
	if (!_topTableView) {
		_topTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 44 * 5 + 88 + 110) style:UITableViewStylePlain];
		_topTableView.dataSource = self;
		_topTableView.delegate = self;
		_topTableView.bounces = NO;
	}
	return _topTableView;
}

- (UITableView *)bottomTableView {
	if (!_bottomTableView) {
		_bottomTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), KScreenWidth, KScreenHeight - self.topTableView.frame.size.height - 44 - 50) style:UITableViewStylePlain];
		_bottomTableView.dataSource = self;
		_bottomTableView.delegate = self;
		_bottomTableView.bounces = NO;
	}
	return _bottomTableView;
}

- (UISearchBar *)searchBar {
	if (!_searchBar) {
		_searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topTableView.frame), KScreenWidth, 44)];
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

@end
