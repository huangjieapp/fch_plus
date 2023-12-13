//
//  ServiceTaskAddViewController.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/27.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import "ServiceTaskAddViewController.h"
#import "AddCustomerInputTableViewCell.h"
#import "AddCustomerChooseTableViewCell.h"
#import "CGCNewAppointTextCell.h"
#import "CGCOrderDetialFooter.h"
#import "KSPhotoBrowser.h"
#import "CGCMoreCollection.h"
#import "DBPickerView.h"


#import "PotentailCustomerEditModel.h"


#import "CGCTemplateVC.h"

#import "MJKMarketViewController.h"
#import "MJKChooseEmployeesViewController.h"

#import "MJKTaskWorkListController.h"
#import "MJKTaskNewWorkListController.h"

#import "MJKPhotoView.h"


#define inputCell     @"AddCustomerInputTableViewCell"
#define chooseCell    @"AddCustomerChooseTableViewCell"
#define RemarkCell    @"CGCNewAppointTextCell"
@interface ServiceTaskAddViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)CGCOrderDetialFooter*footerImageView;

@property(nonatomic,assign)BOOL canSave;   //
@property(nonatomic,assign)NSInteger selectedImage;  //点击的是哪个 图片按钮    11 22 33 还有其他   0
@property(nonatomic,strong)NSMutableDictionary*saveFooterImageDataDic; //保存 3张图片的data   11  22  33  key
@property(nonatomic,strong)NSMutableArray*localDatas;
/** 任务id*/
@property (nonatomic, strong) NSString *C_A01200_ID;
/** <#备注#>*/
@property (nonatomic, strong) NSMutableDictionary *mutDic;
/** UIButton*commitButton*/
@property (nonatomic, strong) UIButton*commitButton;

/** <#注释#>*/
@property (nonatomic, strong) MJKPhotoView *tableFootPhoto;

/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *imageArr;
@end

@implementation ServiceTaskAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title=@"服务任务新增";
	self.view.backgroundColor = [UIColor whiteColor];
	self.C_A01200_ID = [DBObjectTools getServiceTaskC_id];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
	if ([self.title isEqualToString:@"新增任务"]) {
		[self getLocalDatas];
		UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
		[button setTitleNormal:@"排班列表"];
		button.titleLabel.font = [UIFont systemFontOfSize:14.f];
		[button setTitleColor:[UIColor blackColor]];
		[button addTarget:self action:@selector(taskWorkListAction)];
        if ([[NewUserSession instance].configData.IS_RWPB isEqualToString:@"1"]) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        } 
		
        
		//是否外出默认为否
		PotentailCustomerEditModel*model = self.localDatas[0][6];
        if (model.postValue.length <= 0) {
            model.postValue = @"0";
            model.nameValue = @"否";
        }
	} else {
		[self HttpGetDetail];
	}
//    [self getLocalDatas];
     [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:inputCell bundle:nil] forCellReuseIdentifier:inputCell];
    [self.tableView registerNib:[UINib nibWithNibName:chooseCell bundle:nil] forCellReuseIdentifier:chooseCell];
    [self.tableView registerNib:[UINib nibWithNibName:RemarkCell bundle:nil] forCellReuseIdentifier:RemarkCell];
    [self addCommitButton];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
	
}

- (void)taskWorkListAction {
    MJKTaskNewWorkListController *vc = [[MJKTaskNewWorkListController alloc]initWithNibName:@"MJKTaskNewWorkListController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}


#pragma mark  --UI
-(void)addCommitButton{
    UIButton*commitButton=[[UIButton alloc]initWithFrame:CGRectMake(20, KScreenHeight-50, KScreenWidth-40, 40)];
	self.commitButton = commitButton;
    commitButton.backgroundColor=KNaviColor;
    [commitButton setTitleNormal:@"提交"];
    commitButton.layer.cornerRadius = 5.f;
    [commitButton setTitleColor:[UIColor blackColor]];
    [commitButton addTarget:self action:@selector(clickCommitButton:)];
    [self.view addSubview:commitButton];
    
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return self.localDatas.count;
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray*array=self.localDatas[section];
    return array.count;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray*array=self.localDatas[indexPath.section];
    PotentailCustomerEditModel*model=array[indexPath.row];
    DBSelf(weakSelf);
    
   
    if (indexPath.row == 1) {
        CGCNewAppointTextCell*acell=[tableView dequeueReusableCellWithIdentifier:RemarkCell];
        acell.topTitleLabel.text=@"任务描述";
        acell.textView.text = model.nameValue;
		if (![self.title isEqualToString:@"新增任务"]) {
			if ([weakSelf.detailModel.C_STATUS_DD_ID isEqualToString:@"A01200_C_STATUS_0001"]) {
				acell.textView.editable = NO;
			}
		}
        //屏幕的上移问题
        acell.startInputBlock = ^{
//            [UIView animateWithDuration:0.25 animations:^{
//
//                CGRect frame = self.view.frame;
//                //frame.origin.y+
//                frame.origin.y = -260;
//
//                weakSelf.view.frame = frame;
//
//            }];
        };
        
        
        acell.changeTextBlock = ^(NSString *textStr) {
            MyLog(@"%@",textStr);
            model.postValue=textStr;
            model.nameValue=textStr;
            [weakSelf.mutDic setObject:textStr forKey:@"x_remark"];
            
            
        };
        
        
        
        return acell;

	} else if (indexPath.row == 2) {
		//期望开始时间
		AddCustomerChooseTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:chooseCell];
		cell.nameTitleLabel.text=model.locatedTitle;
		cell.chooseTextField.text = model.nameValue;
		cell.Type=ChooseTableViewTypeAllTime;
		if (![self.title isEqualToString:@"新增任务"]) {
			if ([weakSelf.detailModel.C_STATUS_DD_ID isEqualToString:@"A01200_C_STATUS_0001"]) {
				cell.chooseTextField.enabled = YES;
			}
		}
        PotentailCustomerEditModel *model1 = array[indexPath.row + 1];
		cell.chooseBlock = ^(NSString *str, NSString *postValue) {
			MyLog(@"%@,%@",str,postValue);
			model.postValue=postValue;
			model.nameValue=str;
            model1.postValue = [DBTools getTimeFomatFromTimeStampAddThreeTime:postValue];
            model1.nameValue = [DBTools getTimeFomatFromTimeStampAddThreeTime:str];
			[weakSelf.tableView reloadData];
//			[weakSelf.mutDic setObject:postValue forKey:@"arrivaTime"];
		};
		return cell;
	}
	else if (indexPath.row == 3) {
        //要求到达时间
        AddCustomerChooseTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:chooseCell];
        cell.nameTitleLabel.text=model.locatedTitle;
        cell.chooseTextField.text = model.nameValue;
        cell.Type=ChooseTableViewTypeAllTime;
		if (![self.title isEqualToString:@"新增任务"]) {
			if ([weakSelf.detailModel.C_STATUS_DD_ID isEqualToString:@"A01200_C_STATUS_0001"]) {
				cell.chooseTextField.enabled = YES;
			}
		}
//        PotentailCustomerEditModel *model1 = array[indexPath.row - 1];
        cell.chooseBlock = ^(NSString *str, NSString *postValue) {
            MyLog(@"%@,%@",str,postValue);
			PotentailCustomerEditModel*model=array[indexPath.row];
			if ([self compareDate:model.postValue withDate:postValue] == -1) {
				[JRToast showWithText:@"期望完成时间不能小于期望开始时间"];
//                postValue = str = [DBTools getTimeFomatFromCurrentTimeStamp];
                return ;
			}
            model.postValue=postValue;
            model.nameValue=str;
//            model1.postValue = [DBTools getTimeFomatFromTimeStampSubThreeTime:postValue];
//            model1.nameValue = [DBTools getTimeFomatFromTimeStampSubThreeTime:str];
            [weakSelf.tableView reloadData];
            [weakSelf.mutDic setObject:postValue forKey:@"arrivaTime"];
        };
        return cell;

    } else if (indexPath.row==4) {
            AddCustomerChooseTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:chooseCell];
            cell.nameTitleLabel.text=model.locatedTitle;
		if ([self.title isEqualToString:@"任务编辑"]) {
			cell.chooseTextField.enabled = NO;
		}
            if (model.nameValue&&![model.nameValue isEqualToString:@""]) {
                cell.chooseTextField.text=model.nameValue;
            }
            //客户姓名
                if (model.nameValue.length <= 0) {
                    cell.chooseTextField.text = self.detailModel.C_A41500_C_NAME;
                }
        cell.vcName = @"任务";
                cell.Type=ChooseTableViewTypeChooseCustomer;
                cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                    MyLog(@"%@,%@",str,postValue);
                    
                    NSArray*newArray=[str componentsSeparatedByString:@","];
                    if (newArray.count==3) {
                        model.nameValue=newArray[0];
                        model.postValue=postValue;
                        
//
//                        NSArray*mainArr=self.localDatas[0];
//                        PotentailCustomerEditModel*model2=mainArr[1];
//                        NSString*phoneStr=newArray[1];
//                        model2.nameValue=phoneStr;
//                        model2.postValue=phoneStr;
//
//
//                        PotentailCustomerEditModel*model3=mainArr[2];
//                        NSString*addressStr=newArray[2];
//                        model3.nameValue=addressStr;
//                        model3.postValue=addressStr;
						
                        
                        
                        
                        [weakSelf.tableView reloadData];
                        
                        
                    }
                    
                    
                };
		cell.backAddressBlock = ^(NSString *addressStr) {
			PotentailCustomerEditModel*model=array[5];
			model.postValue = addressStr;
			model.nameValue = addressStr;
			[tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
		};
			return cell;
            
            
        }else if (indexPath.row == 5){
			AddCustomerInputTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:inputCell];
			cell.nameTitleLabel.text=model.locatedTitle;
			if (model.nameValue&&![model.nameValue isEqualToString:@""]) {
				cell.inputTextField.text=model.nameValue;
			}
			
            cell.inputTextField.keyboardType=UIKeyboardTypeDefault;
            cell.textFieldLength=0;
            if (cell.textFieldLength) {
                MyLog(@"11");
                
            }
            cell.inputWith.constant=245;
            cell.inputTextField.placeholder=@"请输入地址";
			
			if (![self.title isEqualToString:@"新增任务"]) {
				if ([weakSelf.detailModel.C_STATUS_DD_ID isEqualToString:@"A01200_C_STATUS_0001"]) {
					cell.inputTextField.enabled = NO;
				}
			}
            cell.changeTextBlock = ^(NSString *textStr) {
                MyLog(@"%@",textStr);
                model.postValue=textStr;
                model.nameValue=textStr;
                
            };
            
            return cell;
	

    } else if (indexPath.row == 0) {
        //任务类型
        AddCustomerChooseTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:chooseCell];
        cell.nameTitleLabel.text=model.locatedTitle;
        cell.chooseTextField.text = model.nameValue;
        cell.Type=CHooseTableViewCarTypeTaskType;
		
		if (![self.title isEqualToString:@"新增任务"]) {
			if ([weakSelf.detailModel.C_STATUS_DD_ID isEqualToString:@"A01200_C_STATUS_0001"]) {
				cell.chooseTextField.enabled = YES;
			}
		}
        cell.taglabel.hidden = NO;
        cell.chooseBlock = ^(NSString *str, NSString *postValue) {
            MyLog(@"%@,%@",str,postValue);
            model.postValue=postValue;
            model.nameValue=str;
            [weakSelf.tableView reloadData];
            
        };
        return cell;

	} else if (indexPath.row == 6) {
			//是否外出
			AddCustomerChooseTableViewCell*cell=[AddCustomerChooseTableViewCell cellWithTableView:tableView];
			cell.nameTitleLabel.text=model.locatedTitle;
			cell.chooseTextField.text = model.nameValue;
			cell.Type=chooseTypeIsOutType;
		
		if (![self.title isEqualToString:@"新增任务"]) {
			if ([weakSelf.detailModel.C_STATUS_DD_ID isEqualToString:@"A01200_C_STATUS_0001"]) {
				cell.chooseTextField.enabled = YES;
			}
		}
			cell.chooseBlock = ^(NSString *str, NSString *postValue) {
				MyLog(@"%@,%@",str,postValue);
				model.postValue=postValue;
				model.nameValue=str;
				[weakSelf.tableView reloadData];
				
			};
			return cell;
	}
	
	else if (indexPath.row == 7) {
        //服务人员
        AddCustomerChooseTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:chooseCell];
//		if ([self.title isEqualToString:@"任务编辑"]) {
//			cell.chooseTextField.enabled = NO;
//		}
        cell.nameTitleLabel.text=model.locatedTitle;
        cell.chooseTextField.text = model.nameValue;
        cell.Type=chooseTypeNil;
	
		if (![self.title isEqualToString:@"新增任务"]) {
			if ([weakSelf.detailModel.C_STATUS_DD_ID isEqualToString:@"A01200_C_STATUS_0001"]) {
				cell.chooseTextField.enabled = YES;
			}
		}
        cell.chooseBlock = ^(NSString *str, NSString *postValue) {
//            MyLog(@"%@,%@",str,postValue);
			MJKChooseEmployeesViewController *vc = [[MJKChooseEmployeesViewController alloc]init];
            vc.noticeStr = @"无提示";
            if ([[NewUserSession instance].appcode containsObject:@"APP007_0010"]) {
                vc.isAllEmployees = @"是";
            }
            vc.chooseEmployeesBlock = ^(MJKClueListSubModel * _Nonnull showModel) {
                model.postValue=showModel.user_id;
                model.nameValue=showModel.user_name;
                [weakSelf.tableView reloadData];
                [weakSelf.mutDic setObject:showModel.user_id forKey:@"sale"];

            };
//            vc.backSelectParameterBlock = ^(NSString *codeStr, NSString *nameStr) {
//                model.postValue=codeStr;
//                model.nameValue=nameStr;
//                [weakSelf.tableView reloadData];
//                [weakSelf.mutDic setObject:codeStr forKey:@"sale"];
//
//            };
			[weakSelf.navigationController pushViewController:vc animated:YES];

        };
        return cell;
	} else {
		//优先等级
		AddCustomerChooseTableViewCell*cell=[AddCustomerChooseTableViewCell cellWithTableView:tableView];
		cell.nameTitleLabel.text=model.locatedTitle;
		cell.chooseTextField.text = model.nameValue;
		cell.Type=chooseTypeNil;
		if (![self.title isEqualToString:@"新增任务"]) {
			if ([weakSelf.detailModel.C_STATUS_DD_ID isEqualToString:@"A01200_C_STATUS_0001"]) {
				cell.chooseTextField.enabled = YES;
			}
		}
		cell.chooseBlock = ^(NSString *str, NSString *postValue) {
			MyLog(@"%@,%@",str,postValue);
			DBSelf(weakSelf);
			NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A01200_C_TASKSTATUS"];
			NSMutableArray*mtArray=[NSMutableArray array];
			
			NSMutableArray*postArray=[NSMutableArray array];
			for (MJKDataDicModel*model in dataArray) {
				[mtArray addObject:model.C_NAME];
				[postArray addObject:model.C_VOUCHERID];
			}
			DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray  andSelectStr:nil andTitleStr:@"优先等级" andBlock:^(NSString *title, NSString *indexStr) {
				MyLog(@"%@    %@",title,indexStr);
				model.postValue=postArray[indexStr.integerValue];
				model.nameValue=title;
				[weakSelf.tableView reloadData];
				
			}];
			[[UIApplication sharedApplication].keyWindow addSubview:pickerV];
			
		};
		return cell;
	}
	
    
//    if ((indexPath.section==0&&indexPath.row==1)||(indexPath.section==0&&indexPath.row==2)) {
//        AddCustomerInputTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:inputCell];
//        cell.nameTitleLabel.text=model.locatedTitle;
//        if (model.nameValue&&![model.nameValue isEqualToString:@""]) {
//            cell.inputTextField.text=model.nameValue;
//        }
//
//
//
//
//        if (indexPath.row==1) {
//            cell.inputTextField.placeholder=@"请输入电话";
//            if (model.nameValue.length <= 0) {
//                cell.inputTextField.text = self.detailModel.C_PHONE;
//            }
//            cell.inputWith.constant=100;
//            cell.textFieldLength=11;
//        cell.inputTextField.keyboardType=UIKeyboardTypeNumberPad;
//
//            UIImageView*phoneImageV=[[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth-110-20-10, 0, 20, 20)];
//            phoneImageV.centerY=cell.inputTextField.centerY;
//            phoneImageV.image=[UIImage imageNamed:@"icon_order_call_phone"];
//            [cell.contentView addSubview:phoneImageV];
//
//
//            cell.changeTextBlock = ^(NSString *textStr) {
//                MyLog(@"%@",textStr);
//                model.postValue=textStr;
//                model.nameValue=textStr;
//
//            };
//
//
//        }else{
//            cell.inputTextField.keyboardType=UIKeyboardTypeDefault;
//            cell.textFieldLength=0;
//            if (cell.textFieldLength) {
//                MyLog(@"11");
//
//            }
//            cell.inputWith.constant=245;
//            cell.inputTextField.placeholder=@"请输入地址";
//            cell.changeTextBlock = ^(NSString *textStr) {
//                MyLog(@"%@",textStr);
//                model.postValue=textStr;
//                model.nameValue=textStr;
//
//            };
//
//
//        }
//
//
//
//
//        return cell;
//    }else if (indexPath.section==1&&indexPath.row==3){
//        CGCNewAppointTextCell*cell=[tableView dequeueReusableCellWithIdentifier:RemarkCell];
//        cell.topTitleLabel.text=@"任务备注";
//
//
//        //屏幕的上移问题
//        cell.startInputBlock = ^{
//            [UIView animateWithDuration:0.25 animations:^{
//
//                CGRect frame = self.view.frame;
//                //frame.origin.y+
//                frame.origin.y = -260;
//
//                self.view.frame = frame;
//
//            }];
//        };
//
//
//        cell.changeTextBlock = ^(NSString *textStr) {
//            MyLog(@"%@",textStr);
//            model.postValue=textStr;
//            model.nameValue=textStr;
//
//
//
//        };
//
//
//
//        return cell;
//    }else{
//        AddCustomerChooseTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:chooseCell];
//        cell.nameTitleLabel.text=model.locatedTitle;
//        if (model.nameValue&&![model.nameValue isEqualToString:@""]) {
//            cell.chooseTextField.text=model.nameValue;
//        }
//        //客户姓名
//        if (indexPath.section==0&&indexPath.row==0) {
//            if (model.nameValue.length <= 0) {
//                cell.chooseTextField.text = self.detailModel.C_BUYNAME;
//            }
//            cell.Type=ChooseTableViewTypeChooseCustomer;
//            cell.chooseBlock = ^(NSString *str, NSString *postValue) {
//                MyLog(@"%@,%@",str,postValue);
//
//                NSArray*newArray=[str componentsSeparatedByString:@","];
//                if (newArray.count==3) {
//                    model.nameValue=newArray[0];
//                     model.postValue=postValue;
//
//
//                    NSArray*mainArr=self.localDatas[0];
//                    PotentailCustomerEditModel*model2=mainArr[1];
//                    NSString*phoneStr=newArray[1];
//                    model2.nameValue=phoneStr;
//                    model2.postValue=phoneStr;
//
//
//                    PotentailCustomerEditModel*model3=mainArr[2];
//                    NSString*addressStr=newArray[2];
//                    model3.nameValue=addressStr;
//                    model3.postValue=addressStr;
//
//
//
//
//                    [weakSelf.tableView reloadData];
//
//
//                }
//
//
//            };
//
//
//        }else if (indexPath.section==1&&indexPath.row==0){
//            //任务类型
//            cell.Type=CHooseTableViewTypeTaskType;
//            cell.chooseBlock = ^(NSString *str, NSString *postValue) {
//                MyLog(@"%@,%@",str,postValue);
//                model.postValue=postValue;
//                model.nameValue=str;
//                [weakSelf.tableView reloadData];
//
//            };
//
//
//
//        }else if (indexPath.section==1&&indexPath.row==1){
//            //服务人员
//            cell.Type=CHooseTableViewTypeServicer;
//            cell.chooseBlock = ^(NSString *str, NSString *postValue) {
//                MyLog(@"%@,%@",str,postValue);
//                model.postValue=postValue;
//                model.nameValue=str;
//                [weakSelf.tableView reloadData];
//
//            };
//
//
//        }else if (indexPath.section==1&&indexPath.row==2){
//            //要求到达时间
//            cell.Type=ChooseTableViewTypeAllTime;
//            cell.chooseBlock = ^(NSString *str, NSString *postValue) {
//                MyLog(@"%@,%@",str,postValue);
//                model.postValue=postValue;
//                model.nameValue=str;
//                [weakSelf.tableView reloadData];
//
//            };
//
//
//
//        }
//
//
//
//
//        return cell;
//    }
//
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView*mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    mainView.backgroundColor=[UIColor clearColor];
    
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 8, KScreenWidth/2, 14)];
    titleLabel.textColor=DBColor(160, 160, 160);
    titleLabel.font=[UIFont systemFontOfSize:14];
    [mainView addSubview:titleLabel];
    if (section==0) {
//        titleLabel.text=@"客户信息";
        titleLabel.text = @"任务信息";
    }else{
        titleLabel.text=@"服务信息";
    }
    
    return mainView;
}

//比较两个日期的大小  日期格式为2016-08-14 08：46：20
- (NSInteger)compareDate:(NSString*)aDate withDate:(NSString*)bDate
{
	NSInteger aa = 0;
	NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    dateformater.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
	[dateformater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate *dta = [[NSDate alloc] init];
	NSDate *dtb = [[NSDate alloc] init];
	
	dta = [dateformater dateFromString:aDate];
	dtb = [dateformater dateFromString:bDate];
	NSComparisonResult result = [dta compare:dtb];
	if (result==NSOrderedSame)
	{
		//        相等  aa=0
	}else if (result==NSOrderedAscending)
	{
		//bDate比aDate大
		aa=1;
	}else if (result==NSOrderedDescending)
	{
		//bDate比aDate小
		aa=-1;
		
	}
	
	return aa;
}


- (MJKPhotoView *)tableFootPhoto {
    DBSelf(weakSelf);
    if (!_tableFootPhoto) {
        _tableFootPhoto = [[MJKPhotoView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 160)];
        _tableFootPhoto.isEdit = YES;
        _tableFootPhoto.rootVC = self;
        _tableFootPhoto.imageURLArray = self.imageArr;
        _tableFootPhoto.backUrlArray = ^(NSArray *arr, NSArray *saveArr) {
            weakSelf.imageArr = [arr mutableCopy];
        };
    }
    return _tableFootPhoto;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section==1&&indexPath.row==3) {
//        return 100;
//    }else{
//        return 44;
//    }
    if (indexPath.row == 1) {
        return 100;
    } else {
        return 44;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}




#pragma mark  --click
-(void)clickCommitButton:(UIButton*)button{
    NSString*canSaveStr=[self judgeCansave];
    if (!_canSave) {
        [JRToast showWithText:canSaveStr];
        return;
    }
    
    
//    [self httpPostArrayImage:self.saveFooterImageDataDic compliete:^(NSArray *arrayImg) {
       NSString*X_PICURLStr=[self.imageArr componentsJoinedByString:@","];
    
         [self httpPostAddNewServiceTaskWithImageStr:X_PICURLStr];
        
//    }];
    
    
   
    
    
    
    
}








#pragma mark  -- delegate
//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //    定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (!newPhoto) {
        newPhoto=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    }
    NSData*data=UIImagePNGRepresentation(newPhoto);
    
    //    //吊接口  照片
    //    UITableViewCell*cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    //    UIImageView*imageView=[cell viewWithTag:111];
    //    imageView.image=newPhoto;
    
    
   if (self.selectedImage==11){
        //footer 第一张图
        [self.saveFooterImageDataDic setObject:data forKey:@"11"];
        self.footerImageView.firstImg=newPhoto;
       
        
    }else if (self.selectedImage==22){
        //footer 第二张图
        [self.saveFooterImageDataDic setObject:data forKey:@"22"];
        self.footerImageView.secondImg=newPhoto;
      
        
        
    }else if (self.selectedImage==33){
        //footer 第三张图
        [self.saveFooterImageDataDic setObject:data forKey:@"33"];
        self.footerImageView.thirdImg=newPhoto;
      
        
    }
    
    
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark  --datas
-(void)getLocalDatas{
//    NSArray*localArr0=@[@"客户姓名",@"客户电话",@"上门地址"];
//    NSArray*localValueArr0=@[self.detailModel.C_A41500_C_NAME.length > 0 ? self.detailModel.C_A41500_C_NAME :  @"",self.detailModel.C_PHONE.length > 0 ? self.detailModel.C_PHONE : @"",self.detailModel.C_ADDRESS.length > 0 ? self.detailModel.C_ADDRESS : @""];
    
//    NSArray*localPostNameArr0=@[self.detailModel.C_A41500_C_ID.length > 0 ? self.detailModel.C_A41500_C_ID :  @"",self.detailModel.C_PHONE.length > 0 ? self.detailModel.C_PHONE : @"",self.detailModel.C_ADDRESS.length > 0 ? self.detailModel.C_ADDRESS : @""];
    
//    NSArray*localKeyArr0=@[@"C_A41500_C_ID",@"C_CONTACTPHONE",@"C_ADDRESS"];
//
//    NSString*currentTimer=[DBTools getTimeFomatFromCurrentTimeStamp];
//    NSArray*localArr1=@[@"任务类型",@"服务人员",@"要求到达时间",@"任务备注"];
//    NSArray*localValueArr1=@[@"",@"",currentTimer,@""];
//    NSArray*localPostNameArr1=@[@"",@"",currentTimer,@""];
//    NSArray*localKeyArr1=@[@"C_TYPE_DD_ID",@"USER_ID",@"D_ORDER_TIME",@"X_REMARK"];
//
//    NSMutableArray*saveLocalArr0=[NSMutableArray array];
//    NSMutableArray*saveLocalArr1=[NSMutableArray array];
//    for (int i=0; i<localArr0.count; i++) {
//        PotentailCustomerEditModel*model=[[PotentailCustomerEditModel alloc]init];
//        model.locatedTitle=localArr0[i];
//        model.nameValue=localValueArr0[i];
//        model.postValue=localPostNameArr0[i];
//        model.keyValue=localKeyArr0[i];
//
//        [saveLocalArr0 addObject:model];
//    }
//
//    for (int i=0; i<localArr1.count; i++) {
//        PotentailCustomerEditModel*model=[[PotentailCustomerEditModel alloc]init];
//        model.locatedTitle=localArr1[i];
//        model.nameValue=localValueArr1[i];
//        model.postValue=localPostNameArr1[i];
//        model.keyValue=localKeyArr1[i];
//
//        [saveLocalArr1 addObject:model];
//    }
//
//
//
//
//    self.localDatas=[NSMutableArray arrayWithObjects:saveLocalArr0,saveLocalArr1, nil];
    NSString*currentTimer=[DBTools getTimeFomatFromCurrentTimeStamp];
	NSString*threeTimeAfterTimer=[DBTools getTimeFomatFromCurrentTimeStampAddThreeTime];
     NSArray*localArr0=@[@"类型",@"任务描述",@"期望开始时间", @"期望完成时间", @"客户",@"地址",@"是否外出", @"负责人",@"优先等级"];
    NSArray*localValueArr0=@[
							 self.detailModel.C_TYPE_DD_NAME.length > 0 ? self.detailModel.C_TYPE_DD_NAME : @"",self.detailModel.X_REMARK.length > 0 ? self.detailModel.X_REMARK : @"",
							 self.detailModel.D_CONFIRMED_TIME.length > 0 ? self.detailModel.D_CONFIRMED_TIME : currentTimer,
							 self.detailModel.D_ORDER_TIME.length > 0 ? self.detailModel.D_ORDER_TIME : threeTimeAfterTimer,
							 self.detailModel.C_A41500_C_NAME.length > 0 ? self.detailModel.C_A41500_C_NAME :  @"",
							 self.detailModel.C_ADDRESS.length > 0 ? self.detailModel.C_ADDRESS : @"",
							 
							 self.detailModel.I_TYPE.length > 0 ? [self.detailModel.I_TYPE isEqualToString:@"1"] ? @"是" : @"否" : @"",
							 self.detailModel.C_OWNER_ROLENAME.length > 0 ? self.detailModel.C_OWNER_ROLENAME : [NewUserSession instance].user.nickName,
							 self.detailModel.C_TASKSTATUS_DD_NAME.length > 0 ? self.detailModel.C_TASKSTATUS_DD_NAME : @""];
	NSArray*localPostNameArr0=@[self.detailModel.C_TYPE_DD_ID.length > 0 ? self.detailModel.C_TYPE_DD_ID : @"",
                                self.detailModel.X_REMARK.length > 0 ? self.detailModel.X_REMARK : @"",
								self.detailModel.D_CONFIRMED_TIME.length > 0 ? [self.detailModel.D_CONFIRMED_TIME stringByAppendingString:@":00"] : currentTimer,
								self.detailModel.D_ORDER_TIME.length > 0 ? [self.detailModel.D_ORDER_TIME stringByAppendingString:@":00"] : threeTimeAfterTimer,
								self.detailModel.C_A41500_C_ID.length > 0 ? self.detailModel.C_A41500_C_ID :  @"",
								self.detailModel.C_ADDRESS.length > 0 ? self.detailModel.C_ADDRESS : @"",
								
								self.detailModel.I_TYPE.length > 0 ? self.detailModel.I_TYPE : @"",
								self.detailModel.C_OWNER_ROLEID.length > 0 ? self.detailModel.C_OWNER_ROLEID : [NewUserSession instance].user.u051Id,
								self.detailModel.C_TASKSTATUS_DD_ID.length > 0 ? self.detailModel.C_TASKSTATUS_DD_ID : @""];
    NSArray*localKeyArr0=@[@"C_TYPE_DD_ID",@"X_REMARK",@"D_CONFIRMED_TIME", @"D_ORDER_TIME", @"C_A41500_C_ID",@"C_ADDRESS",@"I_TYPE", @"USER_ID",@"C_TASKSTATUS_DD_ID"];

    NSMutableArray*saveLocalArr0=[NSMutableArray array];
    for (int i=0; i<localArr0.count; i++) {
        PotentailCustomerEditModel*model=[[PotentailCustomerEditModel alloc]init];
        model.locatedTitle=localArr0[i];
        model.nameValue=localValueArr0[i];
        model.postValue=localPostNameArr0[i];
        model.keyValue=localKeyArr0[i];
        
        [saveLocalArr0 addObject:model];
    }
     self.localDatas=[NSMutableArray arrayWithObject:saveLocalArr0];

}

//上传多张照片  并完成
-(void)httpPostArrayImage:(NSMutableDictionary*)ImageDic compliete:(void(^)(NSArray*arrayImg))successBlock{
    NSMutableArray*ImageArray=[NSMutableArray array];
    [ImageDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [ImageArray addObject:obj];
    }];
    
    
    if (ImageArray.count<1) {
        successBlock(nil);
    }else{
        
        NSMutableArray*saveFooterImageAddress=[NSMutableArray array];
        for (NSData*imageData in ImageArray) {
            NSString*urlStr=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"ipImage"]];
            HttpManager*manager=[[HttpManager alloc]init];
            [manager postDataUpDataPhotoWithUrl:urlStr parameters:nil photo:imageData compliation:^(id data, NSError *error) {
                MyLog(@"%@",data);
                if ([data[@"code"] integerValue]==200) {
                    
                    NSString*imageStr=data[@"show_url"];
                    [saveFooterImageAddress addObject:imageStr];
                    
                    if (saveFooterImageAddress.count==ImageArray.count) {
                        successBlock(saveFooterImageAddress);
                    }
                    
                    
                    
                }else{
                    [JRToast showWithText:data[@"message"]];
                }
                
            }];
            
        }
        
        
        
    }
}




-(void)httpPostAddNewServiceTaskWithImageStr:(NSString*)X_PICURLStr{
	NSString *actionStr = [self.title isEqualToString:@"新增任务"] ? HTTP_SEviceAdd : HTTP_ChangeServiceTask;
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:actionStr];
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
	if ([self.title isEqualToString:@"新增任务"]) {
		[contentDict setObject:self.C_A01200_ID forKey:@"C_ID"];
	} else {
		[contentDict setObject:self.detailModel.C_ID forKey:@"C_ID"];
	}
    if (X_PICURLStr&&![X_PICURLStr isEqualToString:@""]) {
        [contentDict setObject:X_PICURLStr forKey:@"X_PICURL"];
    }
    NSArray*local0Arr=self.localDatas[0];
    [local0Arr enumerateObjectsUsingBlock:^(PotentailCustomerEditModel*model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (model.postValue&&model.keyValue&&![model.postValue isEqualToString:@""]) {
			if ([self.title isEqualToString:@"新增任务"]) {
					[contentDict setObject:model.postValue forKey:model.keyValue];
				
			} else {
					[contentDict setObject:model.postValue forKey:model.keyValue];
			}
        }
    }];
    
//    NSArray*local1Arr=self.localDatas[1];
//    [local1Arr enumerateObjectsUsingBlock:^(PotentailCustomerEditModel*model, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (model.postValue&&model.keyValue&&![model.postValue isEqualToString:@""]) {
//            [contentDict setObject:model.postValue forKey:model.keyValue];
//        }
//
//
//    }];
	
	if ([self.title isEqualToString:@"任务编辑"]) {
		[contentDict removeObjectForKey:@"C_A41500_C_ID"];
		[contentDict removeObjectForKey:@"USER_ID"];
		contentDict[@"X_PICURL"] = @"";
		contentDict[@"X_TASKCONTENT"] = @"";
//        contentDict[@"C_CONTACTPHONE"] = @"";
		
	} else {
		if (self.C_ID.length > 0) {
			contentDict[@"C_A42000_C_ID"] = self.C_ID;
		}
	}
    DBSelf(weakSelf);
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
             [JRToast showWithText:data[@"message"]];
            if (weakSelf.reloadBlock) {
                weakSelf.reloadBlock();
            }
			if ([weakSelf.vcStr isEqualToString:@"order"]) {
				[weakSelf.mutDic setObject:weakSelf.C_A01200_ID forKey:@"C_A01200_ID"];
				if (weakSelf.backC_A01200_C_IDBlock) {
					weakSelf.backC_A01200_C_IDBlock(weakSelf.mutDic);
				}
			} else {
				if (![self.title isEqualToString:@"新增任务"]) {
                    
					PotentailCustomerEditModel *model = self.localDatas[0][7];
                    if (![self.detailModel.C_OWNER_ROLEID isEqualToString:model.postValue]) {
                        //编辑负责人相当于重新指派
                        [HttpWebObject AssignServiceTaskToSaleWithSalerID:model.postValue andServiceIDS:weakSelf.detailModel.C_ID success:nil];
                    }
					
				}
				[self.navigationController popViewControllerAnimated:YES];
			}
			
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
        
    }];
    
    
    
    
}

#pragma mark 详情
- (void)HttpGetDetail {
	DBSelf(weakSelf);
	NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:HTTP_ServiceTaskDetail];
	NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
	[contentDict setObject:self.C_ID forKey:@"C_ID"];
	[mainDict setObject:contentDict forKey:@"content"];
	NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.detailModel=[ServiceTaskDetailModel yy_modelWithDictionary:data];
			[weakSelf getLocalDatas];
			weakSelf.commitButton.hidden = NO;
			if (![self.title isEqualToString:@"新增任务"]) {
				if ([weakSelf.detailModel.C_STATUS_DD_ID isEqualToString:@"A01200_C_STATUS_0001"]) {
					weakSelf.commitButton.hidden = YES;
					CGRect tableviewFrame = self.tableView.frame;
					tableviewFrame = CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight);
					self.tableView.frame = tableviewFrame;
				}
				
			}
			[weakSelf.tableView reloadData];
			
		}else{
			[JRToast showWithText:data[@"message"]];
		}
		
		
	}];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark  --set
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight-NavStatusHeight-WD_TabBarHeight - SafeAreaTopHeight) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.estimatedRowHeight=0;
        _tableView.estimatedSectionHeaderHeight=0;
        _tableView.estimatedSectionFooterHeight=0;
        _tableView.tableFooterView = self.tableFootPhoto;
    }
    
    return _tableView;
}

- (NSMutableArray *)imageArr {
    if (!_imageArr) {
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}


-(NSMutableDictionary *)saveFooterImageDataDic{
    if (!_saveFooterImageDataDic) {
        _saveFooterImageDataDic=[NSMutableDictionary dictionary];
    }
    return _saveFooterImageDataDic;
}


#pragma mark  --funcation
-(NSString*)judgeCansave{
    _canSave=YES;
    NSMutableArray*localArr=self.localDatas[0];
//    PotentailCustomerEditModel*model01=localArr[2];
//    if (!model01.postValue||[model01.postValue isEqualToString:@""]) {
//        _canSave=NO;
//        return @"请选择客户姓名";
//
//    }
//    PotentailCustomerEditModel*model01=localArr[1];
//    if (!model01.postValue||model01.postValue.length!=11) {
//        _canSave=NO;
//        return @"请正确输入客户电话";
//
//    }
//    PotentailCustomerEditModel*model03=localArr[3];
//    if (!model03.postValue||model03.postValue.length<1) {
//        _canSave=NO;
//        return @"请输入上门地址";
//        
//    }
	
    PotentailCustomerEditModel*model04=localArr[0];
    if (!model04.postValue||model04.postValue.length<1) {
        _canSave=NO;
        return @"请选择任务类型";

    }

	PotentailCustomerEditModel*model05=localArr[7];
	if (!model05.postValue||model05.postValue.length<1) {
		_canSave=NO;
		return @"请选择负责人";
		
	}
    
    
    
//    NSMutableArray*otherArr=self.localDatas[1];
//    PotentailCustomerEditModel*model10=otherArr[0];
//    if (!model10.postValue||[model10.postValue isEqualToString:@""]) {
//        _canSave=NO;
//        return @"请选择任务类型";
//
//    }
//
//    PotentailCustomerEditModel*model11=otherArr[1];
//    if (!model11.postValue||[model11.postValue isEqualToString:@""]) {
//        _canSave=NO;
//        return @"请选择服务人员";
//
//    }
//
//    PotentailCustomerEditModel*model12=otherArr[2];
//    if (!model12.postValue||[model12.postValue isEqualToString:@""]) {
//        _canSave=NO;
//        return @"请选择要求到达的时间";
//
//    }
//
	
    return @"";
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[DBTools findFirstResponderBeneathView:self.view] resignFirstResponder];
}

-(void)keyBoardWillHidden:(NSNotification*)notif{
    [UIView animateWithDuration:0.25 animations:^{
        
        CGRect frame = self.view.frame;
        
        frame.origin.y = 0.0;
        
        self.view.frame = frame;
        
    }];
    
}
//开始编辑时 视图上移 如果输入框不被键盘遮挡则不上移。

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[textField convertRect:textField.bounds toView:self.view];
    
    CGFloat aa = KScreenHeight - (rect.origin.y + rect.size.height + 216 +50+30+50);
    //    +self.view.frame.origin.y
    CGFloat rects=aa;
    
    NSLog(@"aa%f",rects);
    
    if (rects <= 0) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            CGRect frame = self.view.frame;
            //frame.origin.y+
            frame.origin.y = rects;
            
            self.view.frame = frame;
            
        }];
        
    }
    
    return YES;
    
}

- (NSMutableDictionary *)mutDic {
	if (!_mutDic) {
		_mutDic = [NSMutableDictionary dictionary];
	}
	return _mutDic;
}


@end
