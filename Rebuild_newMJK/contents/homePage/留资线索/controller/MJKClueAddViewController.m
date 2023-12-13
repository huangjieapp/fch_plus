//
//  MJKClueAddViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/8/31.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKClueAddViewController.h"
#import "MJKPickerView.h"
#import "CGCBrokerCenterVC.h"
#import "MJKClueListViewController.h"
#import "MJKShowAreaModel.h"
#import "MJKClueHistoryListViewController.h"
//cell
#import "MJKClueDetailTableViewCell.h"
#import "MJKClueMemoInDetailTableViewCell.h"
#import "AddCustomerChooseTableViewCell.h"

#import "MJKMarketListModel.h"
#import "FMDBManager.h"

#import "MJKShowAreaViewController.h"
#import "MJKMarketViewController.h"
#import "MJKChooseEmployeesViewController.h"
#import "MJKAddressTableViewCell.h"
#import "MJKCustomerAddressTableViewCell.h"
#import "AddCustomerProductTableViewCell.h"
#import "MJKProductChooseViewController.h"

#import "MJKProductShowModel.h"

#define ADDCELL @"addCell"
#define ADDMEMOCELL @"addMemoCell"
#define ChooseCell   @"AddCustomerChooseTableViewCell"
/// 沙盒各种子文件夹路径
#define kHomePath NSHomeDirectory()
#define kDocumentPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject

@interface MJKClueAddViewController ()<UITableViewDataSource, UITableViewDelegate, MJKClueMemoInDetailTableViewCellDelegate,UITextViewDelegate> {
	NSString *_custName;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *bottomButton;//提交按钮
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSString *fromStr;//来源
@property (nonatomic, strong) NSString *fromCode;//来源
@property (nonatomic, strong) NSString *marketStr;//市场
@property (nonatomic, strong) NSString *marketCode;//市场

@property (nonatomic, strong) NSString *sexStr;//性别
@property (nonatomic, strong) NSString *sexCode;//性别
@property (nonatomic, strong) NSString *custName;//客户姓名
@property (nonatomic, strong) NSString *phoneNumber;//手机
@property (nonatomic, strong) NSString *product;//意向产品
@property (nonatomic, strong) NSString *saleID;//手机
@property (nonatomic, strong) NSString *saleName;//意向产品
@property (nonatomic, strong) NSString *memoStr;//线索备注
@property (nonatomic, strong) NSString *timeStr;//到店时间
@property (nonatomic, strong) NSString *weChatNum;//微信号
@property (nonatomic, strong) MJKPickerView *pickerView;
@property (nonatomic, strong) MJKMarketListModel *model;
@property (nonatomic, assign) CGRect endFrame;
@property (nonatomic, strong) NSString *addressStr;
@property (nonatomic, strong) NSString *addressStrTextField;
@property (nonatomic, strong) NSString *clueID;
/** 名单id*/
@property (nonatomic, strong) NSString *A41300ID;
/** 楼盘id、*/
@property (nonatomic, strong) NSString *C_A48200_C_ID;
/** 楼盘、*/
@property (nonatomic, strong) NSString *C_A48200_C_NAME;

/** productArray*/
@property (nonatomic, strong) NSMutableArray *productArray;
/** <#注释#>*/
@property (nonatomic, strong) NSString *clueStr;
@property (nonatomic, strong) NSString *clueCode;


@end

@implementation MJKClueAddViewController
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(closeKeyBoard:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	if (self.backViewBlock) {
		self.backViewBlock(@"addView");
	}
	[[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	if (@available(iOS 11.0,*)) {
		self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}else{
		self.automaticallyAdjustsScrollViewInsets=NO;
	}
    self.view.backgroundColor = [UIColor whiteColor];
	[self initUI];
    self.clueID = [DBObjectTools getA41300C_id];
    self.saleName = [NewUserSession instance].user.nickName;
    self.saleID = [NewUserSession instance].user.u051Id;
}

- (void)initUI{
	self.title = @"新增线索";
	self.A41300ID = [DBObjectTools getA41300C_id];
	[self.view addSubview:self.tableView];
	[self.view addSubview:self.bottomButton];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    [button setTitleNormal:@"新增历史"];
    [button setTitleColor:[UIColor blackColor]];
    button.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [button addTarget:self action:@selector(historyAddShowAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
	[self getTimeNow];
	[self getMarketDatas];
	[self.tableView registerNib:[UINib nibWithNibName:@"MJKClueDetailTableViewCell" bundle:nil]  forCellReuseIdentifier:ADDCELL];
	[self.tableView registerNib:[UINib nibWithNibName:@"MJKClueMemoInDetailTableViewCell" bundle:nil] forCellReuseIdentifier:ADDMEMOCELL];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddCustomerChooseTableViewCell" bundle:nil] forCellReuseIdentifier:ChooseCell];
	//初始化
	_custName = _phoneNumber = _fromCode = _marketCode = _sexCode = _product = _memoStr = @"";
    _clueStr = @"来电";
    _clueCode = @"A41300_C_TYPE_0001";
    
    //A41300_C_CLUESOURCE_0021
    //转介绍
    if ([self.vcName isEqualToString:@"转介绍"]) {
        _clueStr = @"线索";
        _clueCode = @"A41300_C_TYPE_0000";
        self.fromStr = @"转介绍";
        self.fromCode = @"A41300_C_CLUESOURCE_0021";
    }
    
}

//MARK:-新增历史
- (void)historyAddShowAction:(UIButton *)sender {
    MJKClueHistoryListViewController *mjkClueVC = [[MJKClueHistoryListViewController alloc]init];
    [self.navigationController pushViewController:mjkClueVC animated:YES];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return  self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *str = self.titleArray[indexPath.row];
	DBSelf(weakSelf);
    if ([str isEqualToString:@"类型"]) {
        AddCustomerChooseTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:ChooseCell];
        cell.nameTitleLabel.text=str;
        cell.BottomLineView.hidden=YES;
        cell.textStr=self.clueStr;
        cell.Type=ChooseTableViewTypecCluesType;
        cell.taglabel.hidden=NO;
        
        cell.chooseBlock = ^(NSString *str, NSString *postValue) {
            MyLog(@"str-- %@      post---%@",str,postValue);
            weakSelf.clueStr=str;
            weakSelf.clueCode=postValue;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        };
        
        return cell;
    } else  if ([str isEqualToString:@"备注"]) {
		MJKClueMemoInDetailTableViewCell *memoCell = [MJKClueMemoInDetailTableViewCell cellWithTableView:tableView];
        memoCell.titleLabel.text = @"备注";
		memoCell.memoTextView.editable = YES;
		memoCell.delegate = self;
        if(self.memoStr&&![self.memoStr isEqualToString:@""]){
            memoCell.memoTextView.text=self.memoStr;
        }
		[memoCell setBackTextViewBlock:^(NSString *str){
			weakSelf.memoStr = str;
		}];
        
        
        
        
        
        
		return memoCell;
        
    }else if ([str isEqualToString:@"来源渠道"]){
        //来源
        //A41300_C_CLUESOURCE_0021
        //转介绍
        AddCustomerChooseTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:ChooseCell];
        cell.nameTitleLabel.text=@"来源渠道";
        cell.BottomLineView.hidden=YES;
        cell.textStr=self.fromStr;
        cell.Type=ChooseTableViewTypeCustomerSource;
        cell.taglabel.hidden=NO;

        cell.chooseBlock = ^(NSString *str, NSString *postValue) {
            MyLog(@"str-- %@      post---%@",str,postValue);
            weakSelf.fromStr=str;
            weakSelf.fromCode=postValue;
            //渠道细分
          
            weakSelf.marketStr=@"";
            weakSelf.marketCode=@"";
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath,[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
			
        };
        
        return cell;
        
    }else if ([str isEqualToString:@"渠道细分"]){
        //渠道细分
         AddCustomerChooseTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:ChooseCell];
        cell.nameTitleLabel.text=@"渠道细分";
        cell.textStr=self.marketStr;
        cell.SourceID=self.fromCode;
        cell.Type=ChooseTableViewTypeAction;
        cell.taglabel.hidden=NO;
        cell.BottomLineView.hidden=YES;
        cell.chooseBlock = ^(NSString *str, NSString *postValue) {
            MyLog(@"str-- %@      post---%@",str,postValue);
            weakSelf.marketStr=str;
            weakSelf.marketCode=postValue;
           [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            
        };
        return cell;
    } else if ([str isEqualToString:@"意向产品"]) {
        DBSelf(weakSelf);
        AddCustomerProductTableViewCell *cell = [AddCustomerProductTableViewCell cellWithTableView:tableView];
        cell.topTitleLabel.text = @"产品详情";
        cell.topTitltLabelLeftLayout.constant = 10;
//        if ([[NewUserSession instance].configData.cpsrList containsObject:@"A47500_C_CPSRSZ_0000"]) {
//            cell.scanfButton.hidden = NO;
//        } else {
            cell.scanfButton.hidden = YES;
//        }
        

        if (self.product.length > 0) {
            cell.textViewStr = self.product;
        }
       
        
        cell.rootVC = self;
        if (self.productArray.count > 0) {
            cell.productArray = self.productArray;
        } else {
            cell.productArray = @[];
        }
        
//        if ([self.orderModel.C_STATUS_DD_ID isEqualToString:@"A42000_C_STATUS_0001"] || [self.orderModel.C_STATUS_DD_ID isEqualToString:@"A42000_C_STATUS_0003"]) {
//
//        } else {
            cell.clickSanfBlock = ^{
                [weakSelf scanlifeClick:nil];

            };
//        }
        
        
        
        cell.textViewChangeBlock = ^(NSString *currentStr) {
            MyLog(@"%@",currentStr);
            weakSelf.product = currentStr;
            //            model.nameValue=currentStr;
            //            model.postValue=currentStr;
//            weakSelf.orderModel.X_INTENTIONREMARK = currentStr;
            
            
        };
        
        
        
        return cell;
    }
    
    else if ([str isEqualToString:@"客户地址"]) {
		//客户地址
		/*MJKAddressTableViewCell *cell = [MJKAddressTableViewCell cellWithTableView:tableView];
		cell.titleLabel.text=@"客户地址";
		if (self.addressStr.length > 0) {
			cell.textView.alpha = 1.f;
		}
		cell.textView.text = self.addressStr;
		
		
		//        __weak __typeof (MJKAddressTableViewCell *)weakCell = cell;
		cell.changeTextBlock = ^(NSString *textStr) {
			weakSelf.addressStr = textStr;
			//            tableView.rowHeight = [weakCell cellHeight];
			//            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
			[tableView beginUpdates];
			[tableView endUpdates];
		};
		cell.selectAreaBlock = ^{
			[weakSelf addArea];
		};
		return cell;*/
        if ([NewUserSession instance].configData.IS_KHXQDZ.boolValue == NO) {
            MJKAddressTableViewCell *cell = [MJKAddressTableViewCell cellWithTableView:tableView];
            cell.titleLabel.text=@"客户地址";
            if (self.addressStr.length > 0) {
                cell.textView.alpha = 1.f;
            }
            cell.textView.text = self.addressStr;
            
            cell.changeTextBlock = ^(NSString *textStr) {
                weakSelf.addressStr = textStr;
                
                [tableView beginUpdates];
                [tableView endUpdates];
            };
            cell.selectAreaBlock = ^{
                [weakSelf addArea];
            };
            return cell;
        } else {
            
            MJKCustomerAddressTableViewCell *cell = [MJKCustomerAddressTableViewCell cellWithTableView:tableView];
            if (self.addressStr.length > 0) {
                cell.inputAddressTextView.text = self.addressStr;;
            }
            if (self.C_A48200_C_NAME.length > 0) {
                cell.chooseAddressLabel.text = self.C_A48200_C_NAME;
            }
            cell.changeTextBlock = ^(NSString *textStr) {
                weakSelf.addressStr = textStr;
                //                weakSelf.addressStr = textStr;
                
                [tableView beginUpdates];
                [tableView endUpdates];
            };
            cell.selectAreaBlock = ^{
                [weakSelf addArea];
            };
            return cell;
        }
	} else if ([str isEqualToString:@"介绍人"]) {
		//经纪人
		AddCustomerChooseTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:ChooseCell];
		cell.nameTitleLabel.text=self.titleArray[indexPath.row];
		cell.textStr=self.agentStr;
		cell.Type=chooseTypeNil;
		
		cell.taglabel.hidden=YES;
		cell.BottomLineView.hidden=YES;
		cell.chooseBlock = ^(NSString *str, NSString *postValue) {
			MyLog(@"str-- %@      post---%@",str,postValue);
			MyLog(@"%@,%@",str,postValue);
            CGCBrokerCenterVC *vc = [[CGCBrokerCenterVC alloc]init];
            vc.type = BrokerCenterMembers;
            vc.typeName = @"名单经纪人";
            if ([NewUserSession instance].configData.IS_JSRSFKFXZ.boolValue == YES) {
                vc.SEARCH_TYPE = @"1";
            }
            vc.backSelectFansBlock = ^(CGCCustomModel *model) {
                weakSelf.agentCode = model.C_ID;
                weakSelf.agentStr = model.C_NAME;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            [weakSelf.navigationController pushViewController:vc animated:YES];
			
			
		};
		return cell;
    } else if ([str isEqualToString:@"业务"]) {
        //经纪人
        AddCustomerChooseTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:ChooseCell];
        cell.nameTitleLabel.text=self.titleArray[indexPath.row];
        cell.textStr=self.saleName;
        cell.Type=chooseTypeNil;
        
        cell.taglabel.hidden=YES;
        cell.BottomLineView.hidden=YES;
        cell.chooseBlock = ^(NSString *str, NSString *postValue) {
            MyLog(@"str-- %@      post---%@",str,postValue);
            MyLog(@"%@,%@",str,postValue);
            MJKChooseEmployeesViewController *vc = [[MJKChooseEmployeesViewController alloc]init];
//            vc.vcName = @"订单";
            if ([[NewUserSession instance].appcode containsObject:@"APP001_0014"]) {
                vc.isAllEmployees = @"是";
            }
            vc.noticeStr = @"无提示";
            vc.chooseEmployeesBlock = ^(MJKClueListSubModel * _Nonnull model) {
                weakSelf.saleID = model.user_id;
                weakSelf.saleName = model.user_name;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
//            vc.backSelectParameterBlock = ^(NSString *codeStr, NSString *nameStr) {
//                weakSelf.saleID = codeStr;
//                weakSelf.saleName = nameStr;
//                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//            };
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
            
        };
        return cell;
    }
	else {
		MJKClueDetailTableViewCell *cell = [MJKClueDetailTableViewCell cellWithTableView:tableView];
		cell.vcname = @"线索";
        cell.sepLabel.hidden = YES;
        cell.titleArray = self.titleArray;
		[cell updateCell:indexPath.row andTitleArray:self.titleArray];
		if ([str isEqualToString:@"客户姓名"]) {
			cell.contentTextField.text = self.custName;
		} else if ([str isEqualToString:@"手机号码"]) {
            cell.contentTextField.placeholder = @"手机和微信至少有一项必填";
            cell.checkButton.hidden = NO;
            cell.phoneLayoutConstraint.constant = 80;
            [cell.checkButton addTarget:self action:@selector(checkPhoneAction)];
			cell.contentTextField.text = self.phoneNumber;
		} else if ([str isEqualToString:@"客户微信"]) {
			cell.contentTextField.text = self.weChatNum;
		} else if ([str isEqualToString:@"来源渠道"]) {
			cell.contentTextField.text = self.fromStr;
		} else if ([str isEqualToString:@"渠道细分"]) {
			cell.contentTextField.text = self.marketStr;
		} else if ([str isEqualToString:@"性别"]) {
			cell.contentTextField.text = self.sexStr;
        }
//        else if ([str isEqualToString:@"意向产品"]) {
//            cell.contentTextField.text = self.product;
//            [cell.contentTextField addTarget:self action:@selector(keyboardUpBegin) forControlEvents:UIControlEventEditingDidBegin];
//            [cell.contentTextField addTarget:self action:@selector(keyboardUpEnd) forControlEvents:UIControlEventEditingDidEnd];
//        }
        else if ([str isEqualToString:@"介绍人"]) {
			cell.contentTextField.text = self.agentStr;
        } else  if ([str isEqualToString:@"业务"]) {
            cell.contentTextField.text = self.saleName;
        }
		DBSelf(weakSelf);
		[cell setBackNameTextBlock:^(NSString *str){
			weakSelf.custName = str;
		}];
		[cell setBackPhoneNumberTextBlock:^(NSString *str){
			weakSelf.phoneNumber = str;
		}];
		[cell setBackProducrTextBlock:^(NSString *str){
			weakSelf.product = str;
		}];
		[cell setBackWeChatNumberBlock:^(NSString *str) {
			weakSelf.weChatNum = str;
		}];
//        if (indexPath.row == 10) {
//            cell.contentTextField.text = _timeStr;
//            cell.contentTextField.enabled = NO;
//        }
		return cell;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *str = self.titleArray[indexPath.row];
    if ([str isEqualToString:@"意向产品"]) {
        if (self.productArray.count > 0) {
            if (44 * self.productArray.count + 30 + 40 > 220) {
                return 220;
            } else {
                return 44 * self.productArray.count + 30 + 40;
            }
        }
        return 120;
    }
	if ([str isEqualToString:@"备注"]) {
		return 44 + 57;
	} else {
		if ([str isEqualToString:@"客户地址"]) {
            if ([NewUserSession instance].configData.IS_KHXQDZ.boolValue == NO) {
                CGSize size = [self.addressStr boundingRectWithSize:CGSizeMake(KScreenWidth - 100 - 75, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
                if (size.height + 15 > 44) {
                    return size.height + 15;
                }
            }else {
                NSString *str = [NSString stringWithFormat:@"%@",self.addressStr];
                NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:14.f ]};
                CGSize size = [str boundingRectWithSize:CGSizeMake(KScreenWidth-115, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
                //        if (([NewUserSession instance].IS_KHXQDZ.boolValue == YES)) {
                if (size.height + 44 + 20 > 88) {
                    return size.height + 44 + 20;
                } else {
                    return 88;
                }
            }
		}
		return 44;
	}
}

static NSString *tempStr;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *titleStr = self.titleArray[indexPath.row];
	[self.view endEditing:YES];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (![titleStr isEqualToString:@"来源渠道"] && ![titleStr isEqualToString:@"渠道细分"] && ![titleStr isEqualToString:@"性别"]) {
		return;
	}
	NSString *str = @"";

	if ([titleStr isEqualToString:@"来源渠道"]) {
//        str = @"A41300_C_CLUESOURCE";
        return;
	} else if ([titleStr isEqualToString:@"性别"]) {
		str = @"A41300_C_SEX";
	}
	if (![tempStr isEqualToString:str]) {
		self.pickerView = nil;
	}
	tempStr = str;
	
	
	NSArray <MJKDataDicModel *>*arr = [[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:str];
	if (arr.count > 0) {
		self.pickerView.hidden = NO;
	}
	if ([titleStr isEqualToString:@"渠道细分"]) {
        return;
//        self.pickerView.indexRow = indexPath.row;
//        self.pickerView.arr = self.model.content;
	} else if ([titleStr isEqualToString:@"性别"] || [titleStr isEqualToString:@"来源渠道"]) {
		self.pickerView.arr = arr;
	}
	
	DBSelf(weakSelf);
	[weakSelf.pickerView setSelectBlock:^(NSString *str, NSString *str1,NSString*otherID){
		switch (indexPath.row) {
//            case 2:
//                weakSelf.fromStr = str;
//                weakSelf.fromCode = str1;
//            break;
//            case 3:
//                weakSelf.marketStr = str;
//                weakSelf.marketCode = str1;
//                break;
			case 7:
				weakSelf.sexStr = str;
				weakSelf.sexCode = str1;
				break;
				
			default:
				break;
		}
		
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}];
	
}

- (void)scanlifeClick:(UIButton *)btn{//扫码点击
    
//    if (self.goodsView) {
//        [self.goodsView removeFromSuperview];
//        //        self.goodsView=nil;
//    }
    DBSelf(weakSelf);
    
    NSInteger index = [self.titleArray indexOfObject:@"意向产品"];
    
    MJKProductChooseViewController *vc = [[MJKProductChooseViewController alloc]initWithNibName:@"MJKProductChooseViewController" bundle:nil];
    if (self.productArray.count > 0) {
        vc.productArray = [self.productArray mutableCopy];
    }
    vc.chooseProductBlock = ^(NSArray * _Nonnull productArray) {
        weakSelf.productArray = [productArray mutableCopy];
        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//        //self.orderModel.B_MONEY
//        NSInteger total = 0;
//        for (MJKProductShowModel *model in productArray) {
//            total += model.B_HDJ.integerValue * model.number;
//        }
//        weakSelf.orderModel.B_MONEY = [NSString stringWithFormat:@"%ld",(long)total];
//        int money1=[self.orderModel.B_MONEY intValue]-[self.orderModel.B_CASHDISCOUNT intValue];
//        weakSelf.bottomView.middleLab.text=[NSString stringWithFormat:@"%d",money1];
//
//        NSInteger indexP = [self.cellArray indexOfObject:@"产品总价"];
//        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexP inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)requestPickerData:(NSString *)typecode {
	
}

#pragma mark - 获取市场活动列表
- (void)checkPhoneAction {
    if (self.phoneNumber.length <= 0) {
        [JRToast showWithText:@"请输入手机号"];
        return;
    }
    [self httpPostCheatPhoneNumberAndNeedBlock:NO success:nil];
}

-(void)httpPostCheatPhoneNumberAndNeedBlock:(BOOL)needBlock  success:(void(^)(id data))successBlock{
    NSDictionary*contentDict=@{@"C_PHONE":self.phoneNumber};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkWithUrl:[NSString stringWithFormat:@"%@/api/crm/a413/repetitioClue", HTTP_IP] parameters:contentDict compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            [JRToast showWithText:data[@"message"]];
        }
        else{
            [JRToast showWithText:data[@"message"]];
        }
        
        
    }];
}

- (void)getMarketDatas {
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
//删除线索
- (void)deleteClueDelete:(NSString *)isDelete {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"CluedisplayWebService-delete"];
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	dic[@"C_ID"] = self.A41300ID;
	dic[@"TYPE"] = isDelete;
	[dict setObject:dic forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		DBSelf(weakSelf);
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			if ([isDelete isEqualToString:@"true"]) {
				[JRToast showWithText:@"推送成功"];
			} else {
				[JRToast showWithText:@"删除成功"];
			}
			
			[weakSelf.navigationController popViewControllerAnimated:YES];
		} else {
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

- (void)addProduct:(NSString *)C_A41300_C_ID {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A47100WebService-insertByList"];
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    dic[@"C_A41300_C_ID"] = C_A41300_C_ID;
    dic[@"C_TYPE_DD_ID"] = @"A47100_C_TYPE_0002";
    NSMutableArray *a47100Forms = [NSMutableArray array];
    for (MJKProductShowModel *model in self.productArray) {
        NSMutableDictionary *productDic = [NSMutableDictionary dictionary];
        productDic[@"C_ID"] = [DBObjectTools getA47100C_id];
        productDic[@"C_A41900_C_ID"] = model.C_ID;
        productDic[@"B_PRICE"] = model.B_HDJ;
        productDic[@"I_NUMBER"] = [NSString stringWithFormat:@"%ld",(long)model.number];
        productDic[@"X_REMARK"] = model.X_REMARK;
        productDic[@"B_MONEY"] = [NSString stringWithFormat:@"%ld",(long)(model.B_HDJ.integerValue * model.number)];
        [a47100Forms addObject:productDic];
    }
    dic[@"a47100Forms"] = a47100Forms;
    
    
    
    [dict setObject:dic forKey:@"content"];
    
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    DBSelf(weakSelf);
    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        
        if ([data[@"code"] integerValue]==200) {
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

- (void)updateClueDatas {
    self.bottomButton.enabled = NO;
    NSString *addressStr;
    if (self.addressStrTextField.length > 0) {
        addressStr = self.addressStrTextField;
    } else {
        addressStr = self.addressStr;
    }
//    if (self.addressStrTextField.length > 0) {
//        self.addressStr = [NSString stringWithFormat:@"%@%@",self.addressStr,self.addressStrTextField];
//    }
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_ID"] = self.A41300ID;
    contentDic[@"C_NAME"] = _custName;
    if (_phoneNumber.length > 0) {
        contentDic[@"C_PHONE"] = _phoneNumber;
    }
    contentDic[@"C_PURPOSE"] = _product;
    contentDic[@"C_SEX_DD_ID"] = _sexCode;
    contentDic[@"C_CLUESOURCE_DD_ID"] = _fromCode;
    contentDic[@"C_A41200_C_ID"] = _marketCode;
    contentDic[@"D_SHOP_TIME"] = _timeStr;
    contentDic[@"D_LEAD_TIME"] = _timeStr;
    contentDic[@"X_REMARK"] = _memoStr;
//    contentDic[@"X_REMARK"] = _clueCode;
    if (_weChatNum.length > 0) {
        contentDic[@"C_WECHAT"] = _weChatNum;
    }
    if (addressStr.length > 0) {
        contentDic[@"C_ADDRESS"] = addressStr;
    }
    if (self.agentCode.length > 0) {
        contentDic[@"C_A47700_C_ID"] = self.agentCode;
    }
    if (self.saleID.length > 0) {
        contentDic[@"C_CLUEPROVIDER_ROLEID"] = self.saleID;
    }
    
    if (self.C_A48200_C_ID.length > 0) {
        contentDic[@"C_A48200_C_ID"] = self.C_A48200_C_ID;
    }
    if (self.clueCode.length > 0) {
        contentDic[@"C_TYPE_DD_ID"] = self.clueCode;
    }
    
	HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a413/add", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
		DBSelf(weakSelf);
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
            if (weakSelf.productArray.count > 0) {
                [weakSelf addProduct:contentDic[@"C_ID"]];
            }
			NSString *str = data[@"TYPE"];
			NSString *remarkStr = [data[@"X_REMARK"] stringByReplacingOccurrencesOfString:@"，" withString:@",\n"];
			if ([str isEqualToString:@"true"]) {
				UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:remarkStr preferredStyle:UIAlertControllerStyleAlert];
				//修改message
				NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:remarkStr];
				[alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, remarkStr.length)];
				[alertC setValue:alertControllerMessageStr forKey:@"attributedMessage"];
				
				UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
					[weakSelf deleteClueDelete:@"true"];
				}];
				
				UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
					[weakSelf deleteClueDelete:@"false"];
				}];
				
				[alertC addAction:noAction];
				[alertC addAction:yesAction];
				
				[weakSelf presentViewController:alertC animated:YES completion:nil];
			} else {
				[weakSelf.navigationController popViewControllerAnimated:YES];
			}
			
		}else{
			[JRToast showWithText:data[@"msg"]];
		}
        weakSelf.bottomButton.enabled = YES;
	}];
}

- (void)getTimeNow {
	NSDate *date = [NSDate date];
	NSDateFormatter *dataFormatter = [[NSDateFormatter alloc]init];
    dataFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
	dataFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
	self.timeStr = [dataFormatter stringFromDate:date];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self.view endEditing:YES];
}

#pragma mark - 键盘通知
//- (void)showKeyBoard:(NSNotification *)noti {
//    //键盘弹出动画时长 NSTimeInterval == long
//    NSTimeInterval duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    //键盘弹出的动画效果
//    UIViewAnimationOptions option = [noti.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
//    //键盘弹出后的位置
//    self.endFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    
//    //动画移动 输入框容器
//    [UIView animateWithDuration:duration delay:0 options:option animations:^{
////        self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - endFrame.size.height);
//    } completion:^(BOOL finished) {
//        
//    }];
//
//
//}
//
//- (void)scrollLastCell {
//    //动画移动 输入框容器
////    [UIView animateWithDuration:duration delay:0 options:option animations:^{
//        self.tableView.frame = CGRectMake(0, - self.endFrame.size.height, KScreenWidth, KScreenHeight );
////    } completion:^(BOOL finished) {
////        
////    }];
//}
//
//- (void)closeKeyBoard:(NSNotification *)noti {
//    //键盘弹出动画时长 NSTimeInterval == long
//    NSTimeInterval duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    //键盘弹出的动画效果
//    UIViewAnimationOptions option = [noti.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
//    
//    [UIView animateWithDuration:duration delay:0 options:option animations:^{
//        self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 50);
//    } completion:^(BOOL finished) {
//        
//    }];
//}

- (void)keyboardUpBegin {
    DBSelf(weakSelf);
    CGRect rect = self.tableView.frame;
    rect.origin.y = -50;
    [UIView animateWithDuration:.3f animations:^{
        weakSelf.tableView.frame = rect;
    }];
    
}


- (void)keyboardUpEnd {
    DBSelf(weakSelf);
    CGRect rect = self.tableView.frame;
    rect.origin.y = NavStatusHeight;
    [UIView animateWithDuration:.3f animations:^{
        weakSelf.tableView.frame = rect;
    }];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    DBSelf(weakSelf);
    CGRect rect = self.tableView.frame;
    rect.origin.y = -50;
    [UIView animateWithDuration:.3f animations:^{
        weakSelf.tableView.frame = rect;
    }];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    DBSelf(weakSelf);
    CGRect rect = self.tableView.frame;
    rect.origin.y = NavStatusHeight;
    [UIView animateWithDuration:.3f animations:^{
        weakSelf.tableView.frame = rect;
    }];
}

- (void)addArea {
    DBSelf(weakSelf);
    MJKShowAreaViewController *vc = [[MJKShowAreaViewController alloc]init];
    vc.selectAddressBlock = ^(MJKShowAreaModel *model) {
        weakSelf.C_A48200_C_ID = model.C_ID;
        NSString *chooseAreaStr = [model.C_NAMEANDADDRESS substringToIndex:model.C_NAMEANDADDRESS.length - model.C_ADDRESS.length];
        weakSelf.C_A48200_C_NAME =  chooseAreaStr;
        weakSelf.addressStr = model.C_ADDRESS;
		[weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)changeText:(UITextField *)textField {
    self.addressStrTextField = textField.text;
}
- (void)beginText:(UITextField *)textField {
	 MJKClueDetailTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
	cell.contentTextField.textColor = [UIColor clearColor];
}
- (void)endText:(UITextField *)textField {
	if (self.addressStr.length <= 0) {
		MJKClueDetailTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
		cell.contentTextField.hidden = [UIColor blackColor];
	}
}



- (void)submit:(UIButton *)sender {
	if (_custName.length <= 0) {
		[JRToast showWithText:@"客户姓名不能为空"];
		return;
	}
	if (_phoneNumber.length <= 0 && _weChatNum.length <= 0) {
		[JRToast showWithText:@"手机和微信必填一项"];
		return;
	}
	if (_phoneNumber.length > 0) {
		if (_phoneNumber.length != 11) {
			[JRToast showWithText:@"手机号不正确"];
			return;
		}
	}
//	if (_phoneNumber.length <= 0) {
//		[JRToast showWithText:@"手机不能为空"];
//		return;
//	}
	
	if (_fromStr.length <= 0) {
		[JRToast showWithText:@"来源渠道不能为空"];
		return;
	}
    if (_marketStr.length <= 0) {
        [JRToast showWithText:@"渠道细分不能为空"];
        return;
    }
	[self updateClueDatas];
//	[self httpPostCheatPhoneNumber];
//
	
}

-(void)httpPostCheatPhoneNumber{
	HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkWithUrl:[NSString stringWithFormat:@"%@/api/crm/a413/repetitioClue", HTTP_IP] parameters:@{@"C_PHONE" : self.phoneNumber} compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			NSString *flag = data[@"FLAG"];
			if ([flag isEqualToString:@"true"]) {
				[self updateClueDatas];
			} else {
				[JRToast showWithText:data[@"msg"]];
			}
		}else{
			[JRToast showWithText:@"网络不给力..."];
		}
		
		
	}];
}

#pragma mark - set
- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - 50 - WD_TabBarHeight - NavStatusHeight - SafeAreaBottomHeight) style:UITableViewStylePlain];
		_tableView.dataSource = self;
		_tableView.delegate = self;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
	}
	return _tableView;
}

- (UIButton *)bottomButton {
	if (!_bottomButton) {
		_bottomButton = [[UIButton alloc]initWithFrame:CGRectMake(5, KScreenHeight - 45 - SafeAreaBottomHeight, KScreenWidth - 10, 50 - 10)];
		_bottomButton.layer.cornerRadius = 5.0f;
		[_bottomButton setTitle:@"提交" forState:UIControlStateNormal];
		_bottomButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
		[_bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[_bottomButton setBackgroundColor:DBColor(251, 193, 61)];
		[_bottomButton addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _bottomButton;
}

- (NSMutableArray *)productArray {
    if (!_productArray) {
        _productArray = [NSMutableArray array];
    }
    return _productArray;
}

- (NSArray *)titleArray {
	if (!_titleArray) {
		
		
		_titleArray  = [NSArray arrayWithObjects:@"类型",@"客户姓名", @"手机号码", @"客户微信", @"意向产品",@"客户地址", @"来源渠道", @"渠道细分", @"性别",@"介绍人",@"业务", @"备注", nil];
	}
	return _titleArray;
}

- (MJKPickerView *)pickerView {
	if (!_pickerView) {
		_pickerView = [[MJKPickerView alloc]initWithFrame:self.view.frame];
		[self.view addSubview:_pickerView];
	}
	return _pickerView;
}

@end
