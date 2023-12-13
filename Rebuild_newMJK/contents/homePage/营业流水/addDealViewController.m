//
//  addDealViewController.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/26.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import "addDealViewController.h"
#import "CGCOrderDetialFooter.h"
#import "MJKPhotoView.h"
#import "MJKDealTableViewCell.h"

#import "KSPhotoItem.h"
#import "KSPhotoBrowser.h"

#import "MJKDealDetailModel.h"
#import "CGCNewAppointTextCell.h"

#import "CGCOrderDetailNormalCell.h"
#import "MJKMarketViewController.h"

#import "CGCOrderDetailModel.h"
#import "MJKMessagePushNotiViewController.h"
#import "CGCOrderListVC.h"

#import "AddCustomerChooseTableViewCell.h"

#import "AddCustomerInputTableViewCell.h"
#import "AddCustomerChooseTableViewCell.h"

#import "WXApi.h"

@interface addDealViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>

@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)UITextField*secondTextField;

@property(nonatomic,assign)BOOL canSave;

@property (nonatomic,strong) CGCOrderDetialFooter * tableFoot;
@property (nonatomic, assign) NSInteger indexBtn;
@property (nonatomic, strong) NSString *imgUrl1;
@property (nonatomic, strong) NSString *imgUrl2;
@property (nonatomic, strong) NSString *imgUrl3;
@property (nonatomic, strong) NSString *patchUrl;
@property (nonatomic, strong) NSString *X_PICURL;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSMutableArray *categroyArray;//类型数组
@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) NSString *categoryID;
@property (nonatomic, strong) MJKDealDetailModel*detailModel;
@property (nonatomic, strong) UIButton *pickerBtn;
@property (nonatomic, strong) NSString *timeStr;
@property (nonatomic, strong) NSString *saleID;
@property (nonatomic, strong) NSString *saleName;
/** 备注*/
@property (nonatomic, strong) NSString *x_remark;
@property (nonatomic, strong) NSString *C_PAYCHANNEL;
@property (nonatomic, strong) NSString *C_PAYCHANNELID;
@property (nonatomic, strong) NSString *C_MERCHANT_ORDER_NO;
/** (MJKPhotoView *)tableFootPhoto*/
@property (nonatomic, strong) MJKPhotoView *tableFootPhoto;
/** image url array*/
@property (nonatomic, strong) NSArray *imageUrlArray;

/** bottomView*/
@property (nonatomic, strong) UIView  *bottomView;
/** <#注释#>*/
@property (nonatomic, strong) NSString *payC_STATUS_DD_ID;
/** <#注释#>*/
@property (nonatomic, strong) NSString *money;

/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *cellArray;
/** <#注释#>*/
@property (nonatomic, strong) UIButton *completeButton;
/** <#注释#>*/
@property (nonatomic, strong) NSString *buttonTitleStr;
@end

@implementation addDealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	if (@available(iOS 11.0, *)) {
		self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}else {
		self.automaticallyAdjustsScrollViewInsets = NO;
	}
//	if ([self.vcName isEqualToString:@"新增收款"]) {
		self.title = self.vcName;
//	} else {
//		 self.title=@"新增交易";
//	}
    self.view.backgroundColor = [UIColor whiteColor];
	if ([self.vcName isEqualToString:@"编辑收款"] || [self.vcName isEqualToString:@"收款/退款详情"]) {
		[self httpGetDealDetail];
    } else {
        if ([self.type isEqualToString:@"退单"]) {
            self.categoryName = @"退订金";
            self.categoryID = @"A04200_C_TYPE_0002";
            UIButton *button = self.bottomView.subviews[0];
            [button setTitleNormal:@"退款确认"];
            UIButton *button1 = self.bottomView.subviews[1];
            [button1 setTitleNormal:@"待退款"];
        } else if ([self.type isEqualToString:@"订单收款"]) {
                self.categoryName = @"预付款";
                self.categoryID = @"A04200_C_TYPE_0007";
        } else {
            self.categoryName = @"合同款";
            self.categoryID = @"A04200_C_TYPE_0001";
            
            
        }
    }
    
	
    [self.view addSubview:self.tableView];
//    [self addBottomButton];
//    [self.view addSubview:self.completeButton];
    [self.view addSubview:self.bottomView];
    
    NSDate *Date = [NSDate date];
    NSDateFormatter *birthformatter = [[NSDateFormatter alloc] init];
    birthformatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    birthformatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    self.timeStr = [birthformatter stringFromDate:Date];
}

#pragma mark  --UI
-(void)addBottomButton{
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 50)];
    [button setBackgroundColor:KNaviColor];
    button.titleLabel.font=[UIFont systemFontOfSize:15];
    [button setTitleNormal:@"完成"];
    [button setTitleColor:[UIColor blackColor]];
    [button addTarget:self action:@selector(clickCompleteButton:)];
    if ([self.vcName isEqualToString:@"收款/退款详情"]) {
        
    } else {
       [self.view addSubview:button];
    }
    
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DBSelf(weakSelf);
    
    NSArray *btArray = [NewUserSession instance].configData.btListDd;
    NSString *cellStr = self.cellArray[indexPath.row];
    
    UITableViewCell*cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if ([cellStr isEqualToString:@"收款金额"]) {
        UILabel*titleLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 12, 90, 17)];
        titleLab.font=[UIFont systemFontOfSize:14];
        titleLab.textColor=DBColor(67, 67, 67);
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:@"收/退款金额*"];
        [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} range:NSMakeRange(6, 1)];
        titleLab.attributedText=attStr;
        [cell.contentView addSubview:titleLab];
        
        UITextField*textField= [[UITextField alloc]initWithFrame:CGRectMake(KScreenWidth-150, 0, 130, 20)];
        textField.centerY=titleLab.centerY;
        textField.placeholder=@"请输入金额";
        textField.text = self.detailModel.B_AMOUNT.length > 0 ? self.detailModel.B_AMOUNT : self.money;
		
        textField.keyboardType=UIKeyboardTypeDecimalPad;
        [textField addTarget:self action:@selector(B_AMOUNTChnage:) forControlEvents:UIControlEventEditingChanged];
		textField.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:textField];
        
        if ([self.vcName isEqualToString:@"收款/退款详情"]) {
            textField.enabled = NO;
        } else {
            textField.enabled = YES;
        }
//        UIView*bottomView=[[UIView alloc]initWithFrame:CGRectMake(25, cell.height-1, KScreenWidth-50, 1)];
//        bottomView.backgroundColor=DBColor(230, 230, 230);
//        [cell.contentView addSubview:bottomView];
        
        
	}else if ([cellStr isEqualToString:@"收款类型"]) {
        AddCustomerChooseTableViewCell*cell=[AddCustomerChooseTableViewCell cellWithTableView:tableView];
        cell.titleLeftLayout.constant = 10;
        cell.taglabel.hidden=NO;
        cell.chooseTextField.textColor = [UIColor blackColor];
        cell.nameTitleLabel.text=@"类型";
        if (self.detailModel.C_PAYCHANNELNAME.length > 0) {
            cell.textStr=self.detailModel.C_PAYCHANNELNAME;
        } else {
            cell.textStr = self.categoryName;
        }
        cell.nameTitleLabel.font = [UIFont systemFontOfSize:14.f];
        cell.Type=ChooseTableViewTypePaymentType;
        cell.chooseBlock = ^(NSString *str, NSString *postValue) {
            MyLog(@"str-- %@      post---%@",str,postValue);
            if ([postValue isEqualToString:@"A04200_C_TYPE_0002"] || [postValue isEqualToString:@"A04200_C_TYPE_0005"]) {
                UIButton *button = weakSelf.bottomView.subviews[0];
                [button setTitleNormal:@"退款确认"];
                UIButton *button1 = weakSelf.bottomView.subviews[1];
                [button1 setTitleNormal:@"待退款"];
                
            } else {
                UIButton *button = weakSelf.bottomView.subviews[0];
                [button setTitleNormal:@"收入确认"];
                UIButton *button1 = weakSelf.bottomView.subviews[1];
                [button1 setTitleNormal:@"待支付"];
            }
            
            weakSelf.categoryID = postValue;
            weakSelf.categoryName = str;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        };
        return cell;
    } else if ([cellStr isEqualToString:@"收款方式"]) {
        
        AddCustomerChooseTableViewCell*cell=[AddCustomerChooseTableViewCell cellWithTableView:tableView];
        cell.titleLeftLayout.constant = 10;
        cell.chooseTextField.textColor = [UIColor blackColor];
        cell.nameTitleLabel.text=@"收款方式";
        cell.nameTitleLabel.font = [UIFont systemFontOfSize:14.f];
        if (self.detailModel.C_PAYCHANNELNAME.length > 0) {
            cell.textStr=self.detailModel.C_PAYCHANNELNAME;
        } else {
            cell.textStr = self.C_PAYCHANNEL;
        }
        if ([btArray containsObject:@"A47500_C_DDBTX_0009"]) {
            cell.taglabel.hidden = NO;
        } else {
            cell.taglabel.hidden=YES;
        }
        cell.Type=ChooseTableViewTypePaymentMethods;
        cell.chooseBlock = ^(NSString *str, NSString *postValue) {
            MyLog(@"str-- %@      post---%@",str,postValue);
            weakSelf.C_PAYCHANNELID = postValue;
            weakSelf.C_PAYCHANNEL = str;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        };
        return cell;
        
    } else if ([cellStr isEqualToString:@"收据编号"]) {
        AddCustomerInputTableViewCell *cell = [AddCustomerInputTableViewCell cellWithTableView:tableView];
        cell.nameTitleLabel.font = [UIFont systemFontOfSize:14.f];
        cell.titleLeftLayout.constant = 10;
        cell.inputTextField.delegate=self;
        cell.inputTextField.keyboardType=UIKeyboardTypeDefault;
        cell.nameTitleLabel.text=@"收据编号";   //标题
        cell.inputTextField.textColor = [UIColor blackColor];
        if (self.detailModel.C_MERCHANT_ORDER_NO.length > 0) {
            cell.textStr= self.detailModel.C_MERCHANT_ORDER_NO;
        } else {
            cell.textStr= self.C_MERCHANT_ORDER_NO;
        }
        if ([btArray containsObject:@"A47500_C_DDBTX_0010"]) {
            cell.tagLabel.hidden = NO;
        } else {
            cell.tagLabel.hidden=YES;
        }
        cell.changeTextBlock = ^(NSString *textStr) {
            weakSelf.C_MERCHANT_ORDER_NO = textStr;
        };
        return cell;
    }
    
    else if ([cellStr isEqualToString:@"收款状态"]) {
        
        UILabel*titleLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 12, 75, 17)];
        titleLab.font=[UIFont systemFontOfSize:14];
        titleLab.textColor=DBColor(67, 67, 67);
        titleLab.text=@"收款状态";
        [cell.contentView addSubview:titleLab];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UITextField*textField= [[UITextField alloc]initWithFrame:CGRectMake(KScreenWidth-180, 0, 150, 20)];
        textField.enabled = NO;
        textField.centerY=titleLab.centerY;
//        textField.placeholder=@"请选择";
        
        
        
        textField.textAlignment = NSTextAlignmentRight;
        
        [cell.contentView addSubview:textField];
        textField.font = [UIFont systemFontOfSize:14.f];
        
      
        textField.text= self.detailModel.C_STATUS_DD_NAME.length > 0 ? self.detailModel.C_STATUS_DD_NAME : @"待支付";
        textField.enabled = NO;
        
    } else if ([cellStr isEqualToString:@"收款时间"]) {
       
        UILabel*titleLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 12, 75, 17)];
        titleLab.font=[UIFont systemFontOfSize:14];
        titleLab.textColor=DBColor(67, 67, 67);
        titleLab.text=@"收款时间";
        [cell.contentView addSubview:titleLab];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UITextField*textField= [[UITextField alloc]initWithFrame:CGRectMake(KScreenWidth-180, 0, 150, 20)];
        textField.enabled = NO;
        textField.centerY=titleLab.centerY;
        textField.placeholder=@"请选择";
        
        
        
        textField.textAlignment = NSTextAlignmentRight;
        
        [cell.contentView addSubview:textField];
        textField.font = [UIFont systemFontOfSize:14.f];
        
        NSDate *Date = [NSDate date];
        NSDateFormatter *birthformatter = [[NSDateFormatter alloc] init];
        birthformatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        birthformatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        textField.text= self.detailModel.D_COLLECTION_TIME.length > 0 ? self.detailModel.D_COLLECTION_TIME : self.timeStr;
        textField.enabled = NO;
        
    } else if ([cellStr isEqualToString:@"收款人"]) {
        
        UILabel*titleLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 12, 75, 17)];
        titleLab.font=[UIFont systemFontOfSize:14];
        titleLab.textColor=DBColor(67, 67, 67);
        titleLab.text=@"收款人";
        [cell.contentView addSubview:titleLab];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UITextField*textField= [[UITextField alloc]initWithFrame:CGRectMake(KScreenWidth-160, 0, 130, 20)];
        textField.enabled = NO;
        textField.centerY=titleLab.centerY;
        textField.placeholder=@"请选择";
        if (self.saleName.length > 0) {
            textField.text = self.saleName;
        } else {
            textField.text = [NewUserSession instance].user.nickName;
            self.saleID = [NewUserSession instance].user.u051Id;
        }
        textField.font = [UIFont systemFontOfSize:14.f];
        
        textField.textAlignment = NSTextAlignmentRight;
        
        [cell.contentView addSubview:textField];
        
        if ([self.vcName isEqualToString:@"收款/退款详情"]) {
            textField.enabled = NO;
			textField.text = self.detailModel.C_OWNER_ROLENAME;
        } else {
//            textField.enabled = YES;
        }
    }
	
	
	else{
//        UILabel*titleLab=[[UILabel alloc]initWithFrame:CGRectMake(25, 6, 75, 17)];
//        titleLab.font=[UIFont systemFontOfSize:16];
//        titleLab.textColor=DBColor(67, 67, 67);
//        titleLab.text=@"备注";
//
//        [cell.contentView addSubview:titleLab];
//
//
//        UITextField*textField= [[UITextField alloc]initWithFrame:CGRectMake(25, titleLab.bottom+25, KScreenWidth-50 , 30)];
//        textField.borderStyle=UITextBorderStyleRoundedRect;
//        textField.placeholder=@"请填写备注";
//		if (self.secondTextField.text.length <= 0) {
//			textField.text = self.detailModel.X_REMARK;
//		}
//        self.secondTextField=textField;
//        [cell.contentView addSubview:textField];
//
//        if ([self.vcName isEqualToString:@"收款/退款详情"]) {
//            textField.enabled = NO;
//        } else {
//            textField.enabled = YES;
//        }
		
		//备注
		DBSelf(weakSelf);
		CGCNewAppointTextCell*cell=[CGCNewAppointTextCell cellWithTableView:tableView];
		cell.topTitleLabel.text=@"备注:";
        if (self.x_remark.length > 0) {
            cell.beforeText = self.x_remark;
        }
		if ([self.vcName isEqualToString:@"收款/退款详情"]) {
			cell.textView.editable = NO;
            if (self.detailModel.X_REMARK&&![self.detailModel.X_REMARK isEqualToString:@""]) {
                cell.beforeText=self.detailModel.X_REMARK;
            }
//			cell.textView.text = self.detailModel.C_OWNER_ROLENAME;
		} else {
			cell.textView.editable = YES;
		}
		
		cell.changeTextBlock = ^(NSString *textStr) {
			weakSelf.x_remark = textStr;
		};
		//屏幕的上移问题
		cell.startInputBlock = ^{
			[UIView animateWithDuration:0.25 animations:^{
				CGRect frame = weakSelf.view.frame;
				//frame.origin.y+
				frame.origin.y = -180;
				weakSelf.view.frame = frame;
			}];
		};
		cell.endBlock = ^{
			[UIView animateWithDuration:0.25 animations:^{
				CGRect frame = weakSelf.view.frame;
				frame.origin.y = 0.0;
				weakSelf.view.frame = frame;
				
			}];
		};
		return cell;
        
        
    }
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellStr = self.cellArray[indexPath.row];
    if ([cellStr isEqualToString:@"备注"]) {
        return 100;
    }else{
        return 44;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellStr = self.cellArray[indexPath.row];
    if ([self.vcName isEqualToString:@"收款/退款详情"]) {
        return;
    }
    if ([cellStr isEqualToString:@"收款时间"]) {
        [self dateSelect];
    } else if ([cellStr isEqualToString:@"收款人"]) {
        [self selectOrderManager];
    }
}



- (void)B_AMOUNTChnage:(UITextField *)tf {
    self.money = tf.text;
}

#pragma mark  --delegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[DBTools findFirstResponderBeneathView:self.view] resignFirstResponder];
    
}


#pragma mark  --click
-(void)clickCompleteButton:(UIButton*)button{
    NSString*judgeStr=[self judegeCanSave];
    if (!_canSave) {
        [JRToast showWithText:judgeStr];
        return;
    }
    
    [self httpPostAddDeal];
    
    
    
}

//父类方法
- (void)dismissKeyboardView {
	
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
//    UITextField *textField = [cell.contentView viewWithTag:2000];
//    if (textField.isFirstResponder == YES) {
//        if (self.categoryID.length <= 0) {
//            self.categoryName = self.categroyArray[0][@"name"];
//            self.categoryID = self.categroyArray[0][@"categoryID"];
//        }
		
//    NSInteger index = [self.cellArray indexOfObject:@"收款类型"];
//        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
//    }
	
	
//    [textField resignFirstResponder];
//    UIView *view = [textField.inputView viewWithTag:1000];
//    [view removeFromSuperview];
    
    
    
	[super dismissKeyboardView];
//    if ([self.categoryID isEqualToString:@"A04200_C_TYPE_0002"]) {
//        self.bottomView.hidden = YES;
//        self.completeButton.hidden = NO;
//    } else {
        self.bottomView.hidden = NO;
        self.completeButton.hidden = YES;
//    }
    [self.tableView reloadData];
}
#pragma mark  --datas
- (void)httpGetDealDetail {
	DBSelf(weakSelf);
	NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:@"A04200WebService-getBeanById"];
	 NSMutableDictionary*contentDict = [NSMutableDictionary dictionary];
	contentDict[@"C_ID"] = self.model.C_A04200_C_ID;
	 [mainDict setObject:contentDict forKey:@"content"];
	NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.detailModel = [MJKDealDetailModel yy_modelWithDictionary:data];
            weakSelf.tableFootPhoto.imageURLArray = weakSelf.detailModel.urlList;
            if ([weakSelf.detailModel.C_TYPE_DD_ID isEqualToString:@"A04200_C_TYPE_0002"]) {
                weakSelf.categoryID = weakSelf.detailModel.C_TYPE_DD_ID;
                weakSelf.cellArray = nil;
            }
			[weakSelf.tableView reloadData];
			
			if ([self.vcName isEqualToString:@"编辑收款"]) {
				NSString *imageStr1;
				NSString *imageStr2;
				NSString *imageStr3;
				if (self.detailModel.urlList.count > 0) {
					if (self.detailModel.urlList.count == 1) {
						imageStr1 = self.detailModel.urlList[0];
					} else if (self.detailModel.urlList.count == 2) {
						imageStr1 = self.detailModel.urlList[0];
						imageStr2 = self.detailModel.urlList[1];
					} else {
						imageStr1 = self.detailModel.urlList[0];
						imageStr2 = self.detailModel.urlList[1];
						imageStr3 = self.detailModel.urlList[2];
					}
				}
				
				self.tableFoot.firstImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageStr1]]];
				self.tableFoot.secondImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageStr2]]];
				self.tableFoot.thirdImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageStr3]]];
			} else {
				self.tableFoot.beforeImageArray = self.detailModel.urlList;
				self.tableFoot.deleteOneButton.hidden = self.tableFoot.deleteSecondButton.hidden = self.tableFoot.deleteThirdButton.hidden = YES;
			}
           
            
            if ([weakSelf.detailModel.C_STATUS_DD_ID isEqualToString:@"A04200_C_STATUS_0000"]) {//未支付
//                [weakSelf.view addSubview:weakSelf.bottomView];
//                CGRect tableFrame = weakSelf.tableView.frame;
//                tableFrame.size.height = tableFrame.size.height - 44;
//                weakSelf.tableView.frame = tableFrame;
            } else {
                weakSelf.bottomView.hidden = YES;
                CGRect tableFrame = weakSelf.tableView.frame;
                tableFrame.size.height = tableFrame.size.height + 50;
                weakSelf.tableView.frame = tableFrame;
            }
		}else{
			[JRToast showWithText:data[@"message"]];
		}
		
	}];
}



-(void)httpPostAddDeal{
	NSString *urlStr;
	if ([self.vcName isEqualToString:@"收款/退款"]) {
		urlStr = HTTP_CGC_A04200WebServiceinsert;
	} else {
//        urlStr = HTTP_ChangePayRecord;
        if ([self.payC_STATUS_DD_ID isEqualToString:@"A04200_C_STATUS_0001"]) {
            urlStr = @"A04200WebService-updateStatus";
        } else {
            if (![self.buttonTitleStr isEqualToString:@"待退款"]) {
                [self sendWX:self.model.C_A04200_C_ID];
                return;
            }
            
        }
	}
	NSDate *date = [NSDate date];
	NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
	formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:urlStr];
	
    NSMutableDictionary*contentDict;
	if ([self.vcName isEqualToString:@"收款/退款"]) {
        contentDict = [NSMutableDictionary dictionary];
        if (self.C_MERCHANT_ORDER_NO.length > 0) {
            contentDict[@"C_MERCHANT_ORDER_NO"] = self.C_MERCHANT_ORDER_NO;
        }
        if (self.C_PAYCHANNELID.length > 0) {
            contentDict[@"C_PAYCHANNEL"] = self.C_PAYCHANNELID;
        }
        contentDict[@"C_A04200_C_ID"] = [DBObjectTools getDealC_id];
        if (self.money.length > 0) {
            contentDict[@"B_AMOUNT"] = self.money;
        }
        if (self.x_remark.length > 0) {
            contentDict[@"X_REMARK"] = self.x_remark;
        }
//        if (self.imageArray.count > 0) {
//            contentDict[@"urlList"] = self.imageArray;
//        }
		if (self.imageUrlArray.count > 0) {
			contentDict[@"urlList"] = self.imageUrlArray;
		}
		//        if (self.timeStr.length > 0) {
            contentDict[@"D_COLLECTION_TIME"] = self.timeStr.length > 0 ? self.timeStr : [formatter stringFromDate:date];
//        }
        if (self.saleID.length > 0) {
            contentDict[@"C_OWNER_ROLEID"] = self.saleID;
        }
        if (self.categoryID.length > 0) {
            contentDict[@"C_TYPE_DD_ID"] = self.categoryID;
        }
		
		if (self.C_ORDER_ID.length > 0) {
			[contentDict setObject:self.C_ORDER_ID forKey:@"C_ORDER_ID"];
		}
        if (self.payC_STATUS_DD_ID.length > 0) {
            [contentDict setObject:self.payC_STATUS_DD_ID forKey:@"C_STATUS_DD_ID"];
        }
	} else {
        contentDict = [NSMutableDictionary dictionary];
        contentDict[@"C_ID"] = self.detailModel.C_ID;
	}
	
	
    DBSelf(weakSelf);
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
//              [JRToast showWithText:data[@"message"]];
            if (weakSelf.reloadBlock) {
                weakSelf.reloadBlock();
            }
            
            if ([weakSelf.vcName isEqualToString:@"收款/退款"]) {
                if (![self.buttonTitleStr isEqualToString:@"待退款"]) {
                    if ([weakSelf.payC_STATUS_DD_ID isEqualToString:@"A04200_C_STATUS_0000"]) {
                        [weakSelf sendWX:contentDict[@"C_A04200_C_ID"]];
                    }
                }
            }
            
            
            //self.categoryID = @"A04200_C_TYPE_0002"
            if ([weakSelf.categoryID isEqualToString:@"A04200_C_TYPE_0002"]) {
                if ([[NewUserSession instance].configData.khtsList containsObject:@"A47500_C_DDTSDW_0011"]) {
                    [MJKPushMsgHttp pushInfoWithC_A41500_C_ID:weakSelf.orderDetailModel.C_A41500_C_ID andC_ID:weakSelf.orderDetailModel.C_ID andC_TYPE_DD_ID:@"A47500_C_DDTSDW_0011" andVC:self andYesBlock:^(NSDictionary * _Nonnull data) {
                        MJKMessagePushNotiViewController *vc = [[MJKMessagePushNotiViewController alloc]init];
                        vc.dataDic = data[@"content"];
                        vc.titleNameXCX = @"退单确认消息";
                        vc.C_A41500_C_ID = weakSelf.orderDetailModel.C_A41500_C_ID;
                        vc.C_TYPE_DD_ID = @"A47500_C_DDTSDW_0011";
                        vc.C_ID = weakSelf.orderDetailModel.C_ID;
                        vc.backActionBlock = ^{
                            for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                                if ([vc isKindOfClass:[CGCOrderListVC class]]) {
                                    [weakSelf.navigationController popToViewController:vc animated:YES];
                                }
                            }
                        };
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    } andNoBlock:^{
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }];
                } else {
                [weakSelf.navigationController popViewControllerAnimated:YES];
                }
            } else if ([weakSelf.categoryID isEqualToString:@"A04200_C_TYPE_0001"]) {
                //self.payC_STATUS_DD_ID = @"A04200_C_STATUS_0001";
                if ([self.payC_STATUS_DD_ID isEqualToString:@"A04200_C_STATUS_0001"]) {
                    if ([[NewUserSession instance].configData.khtsList containsObject:@"A47500_C_DDTSDW_0008"]) {
                        [MJKPushMsgHttp pushInfoWithC_A41500_C_ID:weakSelf.orderDetailModel.C_A41500_C_ID andC_ID:weakSelf.model.C_A04200_C_ID.length > 0 ? weakSelf.model.C_A04200_C_ID : contentDict[@"C_A04200_C_ID"] andC_TYPE_DD_ID:@"A47500_C_DDTSDW_0008" andVC:self andYesBlock:^(NSDictionary * _Nonnull data) {
                            
                            
                            MJKMessagePushNotiViewController *vc = [[MJKMessagePushNotiViewController alloc]init];
                            vc.dataDic = data[@"content"];
                            vc.titleNameXCX = @"收款确认消息";
                            vc.C_A41500_C_ID = weakSelf.orderDetailModel.C_A41500_C_ID;
                            vc.C_TYPE_DD_ID = @"A47500_C_DDTSDW_0008";
                            vc.C_ID = weakSelf.orderDetailModel.C_ID;
                            vc.backActionBlock = ^{
                                for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                                    if ([vc isKindOfClass:[CGCOrderListVC class]]) {
                                        [weakSelf.navigationController popToViewController:vc animated:YES];
                                    }
                                }
                            };
                            [weakSelf.navigationController pushViewController:vc animated:YES];
                        } andNoBlock:^{
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        }];
                    } else {
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }
                }else {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
            } else {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
        
    }];
    
    
}

- (void)sendWX:(NSString *)C_A04200_C_ID {
        WXMiniProgramObject *object = [WXMiniProgramObject object];
        object.webpageUrl = @"http://www.qq.com";
        object.userName = [NewUserSession instance].C_GID;
        NSString *str = [NSString stringWithFormat:@"/pages/bill/bill?a420id=%@&accountid=%@&shareopenid=%@",C_A04200_C_ID,[NewUserSession instance].user.u051Id,[NewUserSession instance].user.C_OPENID];
        object.path = str;
//    object.miniprogramType =
        UIImage *image = [UIImage imageNamed:@"支付功能_03"];
        object.hdImageData = UIImagePNGRepresentation(image);
        object.withShareTicket = NO;
        object.miniProgramType = WXMiniProgramTypeRelease;
//        object.miniProgramType = WXMiniProgramTypeTest;
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = @"账单";
        //                message.description = @"小程序描述";
        message.thumbData = nil;  //兼容旧版本节点的图片，小于32KB，新版本优先
        //使用WXMiniProgramObject的hdImageData属性
        message.mediaObject = object;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneSession;  //目前只支持会话
        [WXApi sendReq:req completion:nil];
}

#pragma mark - 时间选择
- (void)dateSelect{//预计交付时间选择
    
    [self datePickerAndMethod];
}

//时间控件
- (void)datePickerAndMethod
{
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=self.view.bounds;
    [btn addTarget:self action:@selector(dissmissPicker) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor=CGCBGCOLOR;
    self.pickerBtn=btn;
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight-200, KScreenWidth, 200)];
    view.backgroundColor=[UIColor whiteColor];
    
    UIButton * doneBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame=CGRectMake(KScreenWidth-60, 0, 60, 40);
    [doneBtn addTarget:self action:@selector(dissmissPicker) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setTitleNormal:@"完成"];
    [doneBtn setTitleColor:[UIColor blackColor]];
    [view addSubview:doneBtn];
    
    UIButton * canelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    canelBtn.frame=CGRectMake(0, 0, 60, 40);
    [canelBtn addTarget:self action:@selector(dissmissPicker) forControlEvents:UIControlEventTouchUpInside];
    [canelBtn setTitleNormal:@"取消"];
    [canelBtn setTitleColor:[UIColor blackColor]];
    [view addSubview:canelBtn];
    
    UIDatePicker *Picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, KScreenWidth, 160)];
    Picker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_cn"];
    if (@available(iOS 13.4, *)) {
        Picker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    } else {
        // Fallback on earlier versions
    }
    Picker.datePickerMode = UIDatePickerModeDateAndTime;
    Picker.tag=100;
    
    NSDate *Date = [NSDate date];
//    NSDateFormatter *birthformatter = [[NSDateFormatter alloc] init];
//    birthformatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    self.timeStr = [birthformatter stringFromDate:Date];
    
    //    self.orderModel.D_START_TIME=[birthformatter stringFromDate:Date];
    [Picker setDate:Date animated:YES];
    [Picker addTarget:self action:@selector(showDate:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:Picker];
    [btn addSubview:view];
    [self.view addSubview:btn];
}
- (void)showDate:(UIDatePicker *)datePicker
{
    if (datePicker.tag==100) {
        
        NSDate *date = datePicker.date;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *outputString = [formatter stringFromDate:date];
        self.timeStr = outputString;
//                self.orderModel.D_START_TIME=outputString;
        
        NSInteger index = [self.cellArray indexOfObject:@"收款时间"];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    
}

- (void)dissmissPicker{
    [self.pickerBtn removeFromSuperview];
}


#pragma mark - view
- (void)selectOrderManager {
    DBSelf(weakSelf);
//    [self endEditing:YES];
//    if (self.backViewBlock) {
//        self.backViewBlock(@"返回");
//    }
    MJKMarketViewController *vc = [[MJKMarketViewController alloc]init];
    vc.vcName = @"订单";
    vc.backSelectParameterBlock = ^(NSString *codeStr, NSString *nameStr) {
        weakSelf.saleID = codeStr;
        weakSelf.saleName = nameStr;
        NSInteger index = [self.cellArray indexOfObject:@"收款人"];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)pickerView {
	UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - 150, KScreenWidth, 150)];
	view.tag = 1000;
	UIPickerView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 150)];
	pickerView.delegate = self;
	pickerView.dataSource = self;
	[view addSubview:pickerView];
    for (NSDictionary *dic in self.categroyArray) {
        if ([dic[@"categoryID"] isEqualToString:self.categoryID]) {
            NSInteger index = [self.categroyArray indexOfObject:dic];
            [pickerView selectRow:index inComponent:0 animated:YES];
        }
    }
	return view;
}

#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return self.categroyArray.count;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.categroyArray[row][@"name"];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	self.categoryName = self.categroyArray[row][@"name"];
	self.categoryID = self.categroyArray[row][@"categoryID"];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UITextField *textField =[cell.contentView viewWithTag:2000];
    textField.text = self.categoryName;
    
//    self.categoryID = @"A04200_C_TYPE_0002";
    self.cellArray = nil;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.categoryName.length <= 0) {
        self.categoryName = self.categroyArray[0][@"name"];
        self.categoryID = self.categroyArray[0][@"categoryID"];
        //    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        //    UITextField *textField =[cell.contentView viewWithTag:2000];
        textField.text = self.categoryName;
    }
    
}

#pragma mark  --set
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight-50 - NavStatusHeight) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
//        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor=[UIColor whiteColor];
        _tableView.estimatedRowHeight=0;
        _tableView.estimatedSectionHeaderHeight=0;
        _tableView.estimatedSectionFooterHeight=0;
		_tableView.tableFooterView = self.tableFootPhoto;
    }
    return _tableView;
}

- (NSMutableArray *)cellArray {
    if (!_cellArray) {
        if ([self.categoryID isEqualToString:@"A04200_C_TYPE_0002"]) {
            _cellArray = [NSMutableArray arrayWithObjects:@"收款金额",@"收款类型",@"收款方式",@"收据编号",@"收款时间",@"收款人",@"备注", nil];
        } else {
            _cellArray = [NSMutableArray arrayWithObjects:@"收款金额",@"收款类型",@"收款方式",@"收据编号",@"收款时间",@"收款人",@"收款状态",@"备注", nil];
        }
        
        
    }
    return _cellArray;
}

- (UIButton *)completeButton {
    if (!_completeButton) {
        _completeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, KScreenHeight - SafeAreaBottomHeight - 50, KScreenWidth, 50)];
        [_completeButton setBackgroundColor:KNaviColor];
        _completeButton.titleLabel.font=[UIFont systemFontOfSize:15];
        [_completeButton setTitleNormal:@"完成"];
        [_completeButton setTitleColor:[UIColor blackColor]];
        [_completeButton addTarget:self action:@selector(clickCompleteButton:)];
        _completeButton.hidden = YES;
    }
    return _completeButton;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - SafeAreaBottomHeight - 44, KScreenWidth, 44)];
        _bottomView.backgroundColor = kBackgroundColor;
        
        for (int i = 0; i < 2; i++) {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i * (KScreenWidth / 2), 0, KScreenWidth / 2, 44)];
            if (i == 1) {
                [button setBackgroundColor:KNaviColor];
            }
            [button setTitleColor:[UIColor blackColor]];
            [button setTitleNormal:@[@"收入确认",@"待支付"][i]];
            button.titleLabel.font = [UIFont systemFontOfSize:14.f];
            [button addTarget:self action:@selector(payStatusAction:)];
            [_bottomView addSubview:button];
        }
        
    
    }
    return _bottomView;
}


#pragma mark  --funcation
-(NSString*)judegeCanSave{
    _canSave=YES;
    if (self.money.length<1) {
        _canSave=NO;
        return @"金额不能为空";
    }/*else if (self.imageArray.count <= 0){
        _canSave=NO;
        return @"图片不能为空";
    }*/
//    if (self.categoryID.length <= 0 && self.detailModel.C_TYPE_DD_ID.length <= 0) {
//        _canSave = NO;
//        return @"请选择类型";
//    }
    NSArray *btArray = [NewUserSession instance].configData.btListDd;
    if ([btArray containsObject:@"A47500_C_DDBTX_0009"]) {
        if (self.C_PAYCHANNEL.length <= 0) {
            _canSave=NO;
            return @"请选择收款方式";
        }
    }
    if ([btArray containsObject:@"A47500_C_DDBTX_0010"]) {
        if (self.C_MERCHANT_ORDER_NO.length <= 0) {
            _canSave=NO;
            return @"请输入收据编号";
        }
    }
    if ([btArray containsObject:@"A47500_C_DDBTX_0015"]) {
        if (self.imageUrlArray.count <= 0) {
            _canSave=NO;
            return @"请选择图片";
        }
    }
    return @"";
}
//MARK:-跟新付款收款状态
- (void)payStatusAction:(UIButton *)sender {
    self.buttonTitleStr = sender.titleLabel.text;
    if ([self.vcName isEqualToString:@"收款/退款"]) {
        NSString*judgeStr=[self judegeCanSave];
        if (!_canSave) {
            [JRToast showWithText:judgeStr];
            return;
        }
    }
    if ([sender.titleLabel.text isEqualToString:@"收入确认"] || [sender.titleLabel.text isEqualToString:@"退款确认"]) {
        self.payC_STATUS_DD_ID = @"A04200_C_STATUS_0001";
    } else {
        self.payC_STATUS_DD_ID = @"A04200_C_STATUS_0000";
    }
    
    [self httpPostAddDeal];
}

- (void)showBigImage:(UIImage *)image withBtn:(UIButton *)btn{
	
	KSPhotoItem * item=[KSPhotoItem itemWithSourceView:btn.imageView image:image];
	KSPhotoBrowser * browser=[KSPhotoBrowser browserWithPhotoItems:@[item] selectedIndex:0];
	
	
	[browser showFromViewController:self];
}

- (MJKPhotoView *)tableFootPhoto {
	DBSelf(weakSelf);
	if (!_tableFootPhoto) {
		_tableFootPhoto = [[MJKPhotoView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 150)];
		if ([self.vcName isEqualToString:@"收款/退款详情"]) {
			_tableFootPhoto.isEdit = NO;
		} else {
			_tableFootPhoto.isEdit = YES;
            NSArray *btArray = [NewUserSession instance].configData.btListDd;
            if ([btArray containsObject:@"A47500_C_DDBTX_0015"]) {
                _tableFootPhoto.mustStr = @"*";
            }
		}
		_tableFootPhoto.isCamera = NO;
		_tableFootPhoto.rootVC = self;
		_tableFootPhoto.backUrlArray = ^(NSArray *arr, NSArray *saveArr) {
			weakSelf.imageUrlArray = arr;
		};
	}
	return _tableFootPhoto;
}

- (CGCOrderDetialFooter *)tableFoot{
	
	if (_tableFoot==nil) {
		
		_tableFoot=[[[NSBundle mainBundle] loadNibNamed:@"CGCOrderDetialFooter" owner:self options:0] lastObject];
        if ([self.vcName isEqualToString:@"收款/退款详情"]) {
            _tableFoot.firstPicBtn.enabled = _tableFoot.secondPicBtn.enabled = _tableFoot.thirdPicBtn.enabled = NO;
        }
		
		DBSelf(weakSelf);
		_tableFoot.clickFirstBlock = ^(UIImage *image) {
			if (image) {
				
				[weakSelf showBigImage:image withBtn:weakSelf.tableFoot.firstPicBtn];
				return ;
			}
			[weakSelf picBtnClick:weakSelf.tableFoot.firstPicBtn];
			
		};
		_tableFoot.clickSecondBlock = ^(UIImage *image) {
			if (image) {
				
				[weakSelf showBigImage:image withBtn:weakSelf.tableFoot.secondPicBtn];
				return ;
			}
			[weakSelf picBtnClick:weakSelf.tableFoot.secondPicBtn];
		};
		_tableFoot.clickThirdBlock = ^(UIImage *image) {
			if (image) {
				
				[weakSelf showBigImage:image withBtn:weakSelf.tableFoot.thirdPicBtn];
				return ;
			}
			[weakSelf picBtnClick:weakSelf.tableFoot.thirdPicBtn];
		};
		
		_tableFoot.deleteFirstBlock = ^{
			
			weakSelf.imgUrl1=@"";
			[weakSelf getAllImagePic];
		};
		_tableFoot.deleteSecondBlock = ^{
			weakSelf.imgUrl2=@"";
			[weakSelf getAllImagePic];
		};
		_tableFoot.deleteThirdBlock = ^{
			weakSelf.imgUrl3=@"";
			[weakSelf getAllImagePic];
		};
		
		
	}
	return _tableFoot;
}

#pragma mark --- touch


- (void)picBtnClick:(UIButton *)btn{//图片上传选择
	
	self.indexBtn=btn.tag;
	UIAlertController * alertVC=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
	UIAlertAction*cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		
	}];
	
	
	
	UIAlertAction*sanfdal=[UIAlertAction actionWithTitle:@"相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		
		
		UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
		imagePicker.delegate = self;
		imagePicker.allowsEditing = NO;
		imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		[self presentViewController:imagePicker animated:YES completion:nil];
		
	}];
	UIAlertAction*manual=[UIAlertAction actionWithTitle:@"拍照上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		
		
		UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
		if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
		{
			UIImagePickerController *picker = [[UIImagePickerController alloc] init];
			picker.delegate = self;
			//设置拍照后的图片可被编辑
			picker.allowsEditing = NO;
			picker.sourceType = sourceType;
			[self presentViewController:picker animated:YES completion:nil];
			
		}else
		{
			NSLog(@"模拟其中无法打开照相机,请在真机中使用");
		}
		
		
	}];
	
	[alertVC addAction:sanfdal];
	[alertVC addAction:manual];
	[alertVC addAction:cancel];
	[self presentViewController:alertVC animated:YES completion:nil];
	
	
	
	
}

-(void)getAllImagePic{
	
	NSMutableArray * imgURLArr=[NSMutableArray array];
	if (self.imgUrl1.length>0) {
		[imgURLArr addObject:self.imgUrl1];
	}
	if (self.imgUrl2.length>0) {
		[imgURLArr addObject:self.imgUrl2];
	}
	if (self.imgUrl3.length>0) {
		[imgURLArr addObject:self.imgUrl3];
	}
	self.imageArray = imgURLArr;
	self.X_PICURL=[imgURLArr componentsJoinedByString:@","];
}

#pragma mark -- 上传图片相关

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	
	NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
	
	
	//当选择的类型是图片
	if ([type isEqualToString:@"public.image"])
	{
		//先把图片转成NSData
		UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
		if (!image) {
			image=[info objectForKey:UIImagePickerControllerEditedImage];
		}
		//设置image的尺寸
		//        CGSize imagesize = image.size;
		//        imagesize.height =500;
		//        imagesize.width =500;
		//        //对图片大小进行压缩--
		//        image = [self imageWithImage:image scaledToSize:imagesize];
		NSData *imageData = UIImageJPEGRepresentation(image,0.5);
		image= [UIImage imageWithData:imageData];
		
		
		[self saveimg:image];
		[self uppicAction:imageData];
		
	}else{
		UIImage * image=[info objectForKey:UIImagePickerControllerEditedImage];
		if (!image) {
			image=[info objectForKey:UIImagePickerControllerOriginalImage];
		}
		//设置image的尺寸
		//        CGSize imagesize = image.size;
		//        imagesize.height =626;
		//        imagesize.width =413;
		//        //对图片大小进行压缩--
		//        image = [self imageWithImage:image scaledToSize:imagesize];
		NSData *imageData = UIImageJPEGRepresentation(image,0.5);
		image= [UIImage imageWithData:imageData];
		
		
		
		[self saveimg:image];
		[self uppicAction:imageData];
		
	}
	[picker dismissViewControllerAnimated:YES completion:nil];
	
	
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	NSLog(@"您取消了选择图片");
	[picker dismissViewControllerAnimated:YES completion:nil];
}
//储存图像到本地
- (void)saveimg:(UIImage *) img
{
	NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
	[formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss:SSS"];
	NSString *date =  [formatter stringFromDate:[NSDate date]];
	
	NSString *imgname =  [NSString stringWithFormat:@"/image%@.png",date];
	imgname = [imgname stringByReplacingOccurrencesOfString:@" " withString:@""];
	imgname = [imgname stringByReplacingOccurrencesOfString:@":" withString:@""];
	
	//这里将图片放在沙盒的documents文件夹中
	NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	//文件管理器
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	//把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
	[fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
	NSData *dataObj = UIImageJPEGRepresentation(img, 1.0);
	[fileManager createFileAtPath:[DocumentsPath stringByAppendingString:imgname] contents:dataObj attributes:nil];
	//得到选择后沙盒中图片的完整路径
	self.patchUrl = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,imgname];
	
	
	
}
-(void)uppicAction:(NSData *)data{
	
	
	
	//    NSData *data=[NSData dataWithContentsOfFile:self.patchUrl];
	NSString *urlStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"ipImage"]];
	HttpManager *manager = [[HttpManager alloc]init];
	[manager postDataUpDataPhotoWithUrl:urlStr parameters:nil photo:data compliation:^(id data, NSError *error) {
		if ([data[@"code"] integerValue] == 200) {
			NSString * imgUrl = [data objectForKey:@"url"];//回传
			[self setPicBtn:imgUrl];
			
		} else {
			[JRToast showWithText:data[@"message"]];
		}
	}];
	
}

- (void)setPicBtn:(NSString *)imgUrl{
	
	
	if (self.indexBtn==111) {
		[self.tableFoot.firstPicBtn setImage:[[UIImage imageWithContentsOfFile:self.patchUrl]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
		self.imgUrl1=imgUrl;
		self.tableFoot.firstImg=self.tableFoot.firstPicBtn.imageView.image;
		
	}
	
	if (self.indexBtn==222) {
		[self.tableFoot.secondPicBtn setImage:[[UIImage imageWithContentsOfFile:self.patchUrl]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
		self.imgUrl2=imgUrl;
		self.tableFoot.secondImg=self.tableFoot.secondPicBtn.imageView.image;
	}
	
	if (self.indexBtn==333) {
		
		[self.tableFoot.thirdPicBtn setImage:[[UIImage imageWithContentsOfFile:self.patchUrl] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
		self.imgUrl3=imgUrl;
		self.tableFoot.thirdImg=self.tableFoot.thirdPicBtn.imageView.image;
		
	}
	
	
	[self getAllImagePic];
	
	
}

- (NSMutableArray *)categroyArray {
	if (!_categroyArray) {
		_categroyArray = [NSMutableArray array];
        NSDictionary *dic1;
        if ([self.type isEqualToString:@"订单收款"]) {
            dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"A04200_C_TYPE_0007", @"categoryID", @"预付款", @"name", nil];
        } else {
            dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"A04200_C_TYPE_0001", @"categoryID", @"合同款", @"name", nil];
        }
        
		NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys: @"A04200_C_TYPE_0000", @"categoryID", @"订金", @"name", nil];
		NSDictionary *dic3 = [NSDictionary dictionaryWithObjectsAndKeys: @"A04200_C_TYPE_0002", @"categoryID", @"退款", @"name", nil];
		[_categroyArray addObject:dic1];
		[_categroyArray addObject:dic2];
		[_categroyArray addObject:dic3];
	}
	return _categroyArray;
}

@end
