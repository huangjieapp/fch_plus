//
//  ServiceOrderDetailOrEditViewController.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/11/1.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import "ServiceOrderDetailOrEditViewController.h"
#import "ServiceTaskDetailHeaderTableViewCell.h"
#import "AddCustomerInputTableViewCell.h"
#import "AddCustomerChooseTableViewCell.h"
#import "CGCNewAppointTextCell.h"
#import "CGCOrderDetialFooter.h"
#import "KSPhotoBrowser.h"
#import "AddProductTableViewCell.h"
#import "ThreeInputView.h"
#import "CustomerSignView.h"

#import "PotentailCustomerEditModel.h"
#import "ServiceOrderDetailModel.h"
#import "ServiceOrderBillModel.h"

#import "MJKPhotoView.h"



#define CELLHeader        @"ServiceTaskDetailHeaderTableViewCell"
#define CELLBottom        @"CGCNewAppointTextCell"
#define CELLInput         @"AddCustomerInputTableViewCell"
#define CELLChoose        @"AddCustomerChooseTableViewCell"
#define CELLProduct       @"AddProductTableViewCell"
@interface ServiceOrderDetailOrEditViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)CGCOrderDetialFooter*footerImageView;
@property(nonatomic,strong)UIButton*BottomButton;   //提交的按钮



@property(nonatomic,assign)BOOL isEdit;  //编辑状态 （只有OrderTypeEdit 有）
@property(nonatomic,strong)ServiceOrderDetailModel*mainDatasModel;   //所有详情数据
@property(nonatomic,strong)ServiceOrderBillModel*mainBillDatasModel;  //账单信息

@property(nonatomic,strong)NSMutableArray*localDatas;  //所有的本地数据包括提交
@property(nonatomic,assign)NSInteger selectedImage;  //点击的是哪个 图片按钮    11 22 33 还有其他   0
@property(nonatomic,strong)NSMutableArray*saveFooterUrlArray;//编辑界面  保存的底部的图片
@property(nonatomic,strong)NSMutableDictionary*saveFooterImageDataDic; //保存 3张图片的data   11  22  33  key
/** (MJKPhotoView *)tableFootPhoto*/
@property (nonatomic, strong) MJKPhotoView *tableFootPhoto;
/** image url array*/
@property (nonatomic, strong) NSArray *imageUrlArray;
@end
@implementation ServiceOrderDetailOrEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      self.title=@"工单详情";
      [self getLocalDatas];
    
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:CELLHeader bundle:nil] forCellReuseIdentifier:CELLHeader];
//    [self.tableView registerClass:[CGCNewAppointTextCell class] forCellReuseIdentifier:CELLBottom];
    [self.tableView registerNib:[UINib nibWithNibName:@"CGCNewAppointTextCell" bundle:nil] forCellReuseIdentifier:CELLBottom];
    [self.tableView registerNib:[UINib nibWithNibName:CELLInput bundle:nil] forCellReuseIdentifier:CELLInput];
    [self.tableView registerNib:[UINib nibWithNibName:CELLChoose bundle:nil] forCellReuseIdentifier:CELLChoose];
    [self.tableView registerClass:[AddProductTableViewCell class] forCellReuseIdentifier:CELLProduct];

    
    self.view.backgroundColor=[UIColor whiteColor];
    
    if (self.Type==OrderTypeUnComplete) {
         [self addRightNaviButton];
    }
   
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    
    
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark  --UI
-(void)tableViewReload{
    if (self.Type==OrderTypeUnComplete) {
        if (!self.BottomButton) {
            self.BottomButton=[[UIButton alloc]initWithFrame:CGRectMake(0, KScreenHeight-50, KScreenWidth, 50)];
            [self.BottomButton setBackgroundColor:KNaviColor];
            [self.BottomButton setTitleColor:[UIColor blackColor]];
            self.BottomButton.titleLabel.font=[UIFont systemFontOfSize:17];
            [self.view addSubview:self.BottomButton];
            
        }
        
        if (self.isEdit) {
            //提交
            [self.BottomButton setTitleNormal:@"提交"];
            [self.BottomButton removeTarget:self action:@selector(clickSignName) forControlEvents:UIControlEventTouchUpInside];
            [self.BottomButton addTarget:self action:@selector(clickUpdateButton)];
            
        }else{
            //签名
            [self.BottomButton setTitleNormal:@"签名"];
             [self.BottomButton removeTarget:self action:@selector(clickUpdateButton) forControlEvents:UIControlEventTouchUpInside];
            [self.BottomButton addTarget:self action:@selector(clickSignName)];
            
        }
        
        
        
    }else if (self.Type==OrderTypeComplete){
        //完成
        self.tableView.frame=CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        
    }
    
}



-(void)addRightNaviButton{
    UIBarButtonItem*rightItem=[[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(clickEidtButton)];
    rightItem.tintColor=[UIColor blackColor];
    self.navigationItem.rightBarButtonItem=rightItem;
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.localDatas.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray*array=self.localDatas[section];
    return array.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray*array=self.localDatas[indexPath.section];
    PotentailCustomerEditModel*model=array[indexPath.row];
    DBSelf(weakSelf);
    //头像
    if (indexPath.section==0&&indexPath.row==0) {
        ServiceTaskDetailHeaderTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELLHeader];
        cell.button0.hidden=YES;
        cell.button1.hidden=YES;
        cell.button2.hidden=YES;
        cell.nameLab.text=self.mainDatasModel.C_A41500_C_NAME;
        NSString*firstStr;
        if (self.mainDatasModel.C_A41500_C_NAME&&![self.mainDatasModel.C_A41500_C_NAME isEqualToString:@""]) {
            firstStr=[self.mainDatasModel.C_A41500_C_NAME substringToIndex:1];
        }
        if (self.mainDatasModel.C_HEADIMGURL&&![self.mainDatasModel.C_HEADIMGURL isEqualToString:@""]) {
            cell.headLab.hidden=YES;
            [cell.headImageV sd_setImageWithURL:[NSURL URLWithString:self.mainDatasModel.C_HEADIMGURL] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
        }else{
            cell.headLab.hidden=NO;
            cell.headLab.text=firstStr;
        }
        
        
        
        return cell;
    }
    
    //输入
    if ((indexPath.section==0&&indexPath.row==2)||(indexPath.section==0&&indexPath.row==3)||(indexPath.section==0&&indexPath.row==5)) {
        AddCustomerInputTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELLInput];
        if (self.Type==OrderTypeUnComplete&&self.isEdit==YES) {
            cell.userInteractionEnabled=YES;
        }else{
            cell.userInteractionEnabled=NO;
        }
        cell.nameTitleLabel.text=model.locatedTitle;
        cell.inputTextField.text=model.nameValue;
        if (indexPath.row==2) {
            cell.userInteractionEnabled=NO;
            //客户手机
            cell.inputTextField.placeholder=@"请输入客户手机号";
            cell.textFieldLength=11;
            cell.inputTextField.keyboardType=UIKeyboardTypePhonePad;
            cell.changeTextBlock = ^(NSString *textStr) {
                MyLog(@"%@",textStr);
                model.postValue=textStr;
                model.nameValue=textStr;
                
            };
            
        }else if (indexPath.row==3){
            //地址
            cell.inputTextField.placeholder=@"请输入上门地址";
            cell.textFieldLength=0;
            cell.inputTextField.keyboardType=UIKeyboardTypeDefault;
            cell.changeTextBlock = ^(NSString *textStr) {
                MyLog(@"%@",textStr);
                model.postValue=textStr;
                model.nameValue=textStr;
                
            };

            
        }else if (indexPath.row==5){
            //工单总额
            cell.inputTextField.userInteractionEnabled=NO;
            
        }
        
        
        
        
        
        return cell;
    }
    
    
    //选择
    if ((indexPath.section==0&&indexPath.row==1)||(indexPath.section==0&&indexPath.row==4)||(indexPath.section==0&&indexPath.row==5)||(indexPath.section==0&&indexPath.row==6)||(indexPath.section==0&&indexPath.row==7)||(indexPath.section==0&&indexPath.row==8)) {
        AddCustomerChooseTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELLChoose];
        if (self.Type==OrderTypeUnComplete&&self.isEdit==YES) {
            cell.userInteractionEnabled=YES;
        }else{
            cell.userInteractionEnabled=NO;
        }
        
        cell.nameTitleLabel.text=model.locatedTitle;
        cell.chooseTextField.text=model.nameValue;
        cell.userInteractionEnabled=NO;

        if (indexPath.row==1) {
            //工单类型
            cell.Type=CHooseTableViewTypeOrderType;
            cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                MyLog(@"%@,%@",str,postValue);
                model.postValue=postValue;
                model.nameValue=str;
                [weakSelf.tableView reloadData];
                
            };
      
        }else if (indexPath.row==4){
            //服务人员
            cell.Type=CHooseTableViewTypeServicer;
            cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                MyLog(@"%@,%@",str,postValue);
                model.postValue=postValue;
                model.nameValue=str;
                [weakSelf.tableView reloadData];
                
            };
          
        }else if (indexPath.row==6){
            //状态
            cell.userInteractionEnabled=NO;
            
            
        }else if (indexPath.row==7){
            //开始时间
            cell.userInteractionEnabled=NO;
        }else if (indexPath.row==8){
            //完成时间
            cell.userInteractionEnabled=NO;
            
        }
        
        
        
        
        return cell;
    }
    
    
    
    //工单描述
    if (indexPath.section==0&&indexPath.row==9) {
        CGCNewAppointTextCell*cell=[tableView dequeueReusableCellWithIdentifier:CELLBottom];
        if (self.Type==OrderTypeUnComplete&&self.isEdit==YES) {
            cell.userInteractionEnabled=YES;
        }else{
            cell.userInteractionEnabled=NO;
        }
        
        cell.topTitleLabel.text=model.locatedTitle;
        cell.textView.text=model.nameValue;
        
        //屏幕的上移问题
        cell.startInputBlock = ^{
            [UIView animateWithDuration:0.25 animations:^{
                
                CGRect frame = self.view.frame;
                //frame.origin.y+
                frame.origin.y = -260;
                
                self.view.frame = frame;
                
            }];
        };
        
        
        cell.changeTextBlock = ^(NSString *textStr) {
            MyLog(@"%@",textStr);
            model.postValue=textStr;
            model.nameValue=textStr;
            
            
            
        };

        
        return cell;
    }
    
    
    
    
    //产品订单
    if (indexPath.section==1||indexPath.section==2) {
        AddProductTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELLProduct];
        if (self.Type==OrderTypeUnComplete&&self.isEdit==YES) {
            cell.userInteractionEnabled=YES;
        }else{
            cell.userInteractionEnabled=NO;
        }
        
        
        if (indexPath.section==1) {
            //材料信息
            NSMutableArray*DatasArray=[self.mainBillDatasModel.pjContent mutableCopy];
            cell.titleStr=@"材料信息";
            cell.datasArray=DatasArray;
            
            cell.clickAddInfoButtonBlock = ^(NSString *titleStr) {
                MyLog(@"%@",titleStr);
                ThreeInputView*inputView=[ThreeInputView showThreeInputViewAndSuccess:^(NSString *firstText, NSString *secondText, NSString *thirdText) {
                    ProductInfoModel*model=[[ProductInfoModel alloc]init];
                    model.B_PRICE=secondText;
                    model.C_NAME=firstText;
                    model.I_NUMBER=thirdText;
                    model.TYPE=@"0";
                    model.B_SUBTOTAL=[NSString stringWithFormat:@"%.2f",[model.B_PRICE floatValue]*[model.I_NUMBER floatValue]];
                    model.C_ID=[DBObjectTools getProductC_id];
                    [DatasArray addObject:model];
                    //再次赋值替换掉
                    self.mainBillDatasModel.pjContent=DatasArray;
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
                    //                [self.tableView reloadData];
                    
                    
                } andCancel:^{
                    
                    
                }];
                [[UIApplication sharedApplication].keyWindow addSubview:inputView];
                
                
            };
            
            
            cell.DeleteOneInfoBlock = ^(NSInteger row) {
                MyLog(@"%ld",(long)row);
                UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:@"提示" message:@"是否删除该条信息" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction*cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                UIAlertAction*sure=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [DatasArray removeObjectAtIndex:row];
                    //再次赋值替换掉
                    self.mainBillDatasModel.pjContent=DatasArray;
                    [self.tableView reloadData];
                    
                }];
                [alertVC addAction:cancel];
                [alertVC addAction:sure];
                [self presentViewController:alertVC animated:YES completion:nil];
                
                
                
            };

            
            
            
        }else if (indexPath.section==2){
            //其他费用
             NSMutableArray*DatasArray=[self.mainBillDatasModel.qtContent mutableCopy];
            
            cell.titleStr=@"其他费用";
            cell.datasArray=DatasArray;
            
            cell.clickAddInfoButtonBlock = ^(NSString *titleStr) {
                MyLog(@"%@",titleStr);
                ThreeInputView*inputView=[ThreeInputView showThreeInputViewAndSuccess:^(NSString *firstText, NSString *secondText, NSString *thirdText) {
                    ProductInfoModel*model=[[ProductInfoModel alloc]init];
                    model.B_PRICE=secondText;
                    model.C_NAME=firstText;
                    model.I_NUMBER=thirdText;
                    model.TYPE=@"0";
                    model.B_SUBTOTAL=[NSString stringWithFormat:@"%.2f",[model.B_PRICE floatValue]*[model.I_NUMBER floatValue]];
                    model.C_ID=[DBObjectTools getProductC_id];
                    [DatasArray addObject:model];
                    //再次赋值替换掉
                    self.mainBillDatasModel.qtContent=DatasArray;
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
                    //                [self.tableView reloadData];
                    
                    
                } andCancel:^{
                    
                    
                }];
                [[UIApplication sharedApplication].keyWindow addSubview:inputView];
                
                
            };
            
            
            cell.DeleteOneInfoBlock = ^(NSInteger row) {
                MyLog(@"%ld",(long)row);
                UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:@"提示" message:@"是否删除该条信息" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction*cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                UIAlertAction*sure=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [DatasArray removeObjectAtIndex:row];
                    //再次赋值替换掉
                    self.mainBillDatasModel.qtContent=DatasArray;
                    [self.tableView reloadData];
                    
                }];
                [alertVC addAction:cancel];
                [alertVC addAction:sure];
                [self presentViewController:alertVC animated:YES completion:nil];
                
                
                
            };
            

            
            
        }
        
        
        
        
        
        
        return cell;
    }
    
    
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&indexPath.row==0) {
        
        return 70;
    }else if (indexPath.section==0&&indexPath.row==9){
        return 90;
       
    }else if (indexPath.section==1){
        return [AddProductTableViewCell getCellHeight:[self.mainBillDatasModel.pjContent mutableCopy]];
    }
    
    else if (indexPath.section==2){
        return [AddProductTableViewCell getCellHeight:[self.mainBillDatasModel.qtContent mutableCopy]];
    }else{
        return 44;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
		if (self.isEdit == NO) {
			if (self.mainDatasModel.urlList.count > 0) {
				return 150;
			} else {
				return .1f;
			}
		} else {
			return 150;
		}
		
		
		
    }else if (section==2&&self.Type==OrderTypeComplete){
        return KScreenWidth+20;
    }
    
    return 0.01;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    [self tableViewReload];
    
    return nil;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
     DBSelf(weakSelf);
    if (section==0) {
		if (self.isEdit == NO) {
			if (self.mainDatasModel.urlList.count > 0) {
				self.tableFootPhoto.imageURLArray = self.mainDatasModel.urlList;
				
				return self.tableFootPhoto;
			}
		} else {
			return self.tableFootPhoto;
		}
		
		
		
       /* if (!self.footerImageView) {
            CGCOrderDetialFooter*footer=[[NSBundle mainBundle]loadNibNamed:@"CGCOrderDetialFooter" owner:nil options:nil].firstObject;
            footer.tag=1111;
            footer.frame=CGRectMake(0, 0, KScreenWidth, 150);
            self.footerImageView=footer;
            
            
        }
        
        if (self.Type==OrderTypeUnComplete&&self.isEdit==YES) {
            self.footerImageView.userInteractionEnabled=YES;
        }else{
            self.footerImageView.userInteractionEnabled=NO;
        }
        
#warning 安全起见   反正 没有前面的数据
        self.footerImageView.beforeImageArray=self.saveFooterUrlArray;
        
        
        
        self.footerImageView.clickFirstBlock = ^(UIImage*image){
            if (image) {
                //有图片那就放大
                MyLog(@"放大");
                
                KSPhotoItem *item = [KSPhotoItem itemWithSourceView:weakSelf.footerImageView.firstPicBtn.imageView image:image];
                KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:@[item] selectedIndex:0];
                //                browser.delegate = self;
                //                browser.dismissalStyle = _dismissalStyle;
                //                browser.backgroundStyle = _backgroundStyle;
                //                browser.loadingStyle = _loadingStyle;
                //                browser.pageindicatorStyle = _pageindicatorStyle;
                //                browser.bounces = _bounces;
                [browser showFromViewController:weakSelf];
                
                
                
                
            }else{
                //选择图片
                weakSelf.selectedImage=11;
                [weakSelf TouchAddImage];
                
            }
            
        };
        
        self.footerImageView.clickSecondBlock = ^(UIImage*image){
            if (image) {
                //有图片那就放大
                MyLog(@"放大");
                KSPhotoItem *item = [KSPhotoItem itemWithSourceView:weakSelf.footerImageView.secondPicBtn.imageView image:image];
                KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:@[item] selectedIndex:0];
                [browser showFromViewController:weakSelf];
                
                
            }else{
                //选择图片
                weakSelf.selectedImage=22;
                [weakSelf TouchAddImage];
                
            }
            
            
            
        };
        
        self.footerImageView.clickThirdBlock = ^(UIImage*image){
            if (image) {
                //有图片那就放大
                MyLog(@"放大");
                KSPhotoItem *item = [KSPhotoItem itemWithSourceView:weakSelf.footerImageView.thirdPicBtn.imageView image:image];
                KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:@[item] selectedIndex:0];
                [browser showFromViewController:weakSelf];
                
                
            }else{
                //选择图片
                weakSelf.selectedImage=33;
                [weakSelf TouchAddImage];
                
                
            }
            
        };
        
        
        
        
        //删除图片
        self.footerImageView.deleteFirstBlock = ^{
            [weakSelf.saveFooterImageDataDic removeObjectForKey:@"11"];
            if (self.saveFooterUrlArray.count>=1) {
                [weakSelf.saveFooterUrlArray replaceObjectAtIndex:0 withObject:@"xxx"];
            }
            
            
        };
        
        self.footerImageView.deleteSecondBlock = ^{
            [weakSelf.saveFooterImageDataDic removeObjectForKey:@"22"];
            if (self.saveFooterUrlArray.count>=2) {
                [weakSelf.saveFooterUrlArray replaceObjectAtIndex:1 withObject:@"xxx"];
            }
            
        };
        
        self.footerImageView.deleteThirdBlock = ^{
            [weakSelf.saveFooterImageDataDic removeObjectForKey:@"33"];
            if (self.saveFooterUrlArray.count>=3) {
                [weakSelf.saveFooterUrlArray replaceObjectAtIndex:2 withObject:@"xxx"];
            }
            
        };
        
        
        
        
        
        
        return self.footerImageView;*/

        
    }
    
    
    if (section==2&&self.Type==OrderTypeComplete) {
        UIView*mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenWidth+20)];
        mainView.backgroundColor=DBColor(247, 247, 247);
        
        UILabel*topLab=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, KScreenWidth/2, 20)];
        topLab.font=[UIFont systemFontOfSize:14];
        topLab.text=@"客户签名";
        topLab.textColor=DBColor(153, 153, 153);
        [mainView addSubview:topLab];
        
        UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 20, KScreenWidth, KScreenWidth)];
        imageView.backgroundColor=[UIColor whiteColor];
        [mainView addSubview:imageView];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.mainDatasModel.C_SIGPICTURE] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        
        return mainView;
    }
    
    
    
    return nil;
}

- (MJKPhotoView *)tableFootPhoto {
	DBSelf(weakSelf);
	if (!_tableFootPhoto) {
		_tableFootPhoto = [[MJKPhotoView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 150)];
		_tableFootPhoto.isEdit = NO;
		_tableFootPhoto.isCamera = NO;
		_tableFootPhoto.rootVC = self;
		_tableFootPhoto.backUrlArray = ^(NSArray *arr, NSArray *saveArr) {
			weakSelf.imageUrlArray = arr;
		};
	}
	return _tableFootPhoto;
}

#pragma mark  --click
//提交修改
-(void)clickUpdateButton{
    //提交
//    [self httpPostArrayImage:self.saveFooterImageDataDic compliete:^(NSArray *arrayImg) {
//        [self.saveFooterUrlArray removeObject:@"xxx"];
//        [self.saveFooterUrlArray addObjectsFromArray:arrayImg];
//        NSString*X_PICURLStr=[self.saveFooterUrlArray componentsJoinedByString:@","];
//
        [self httpPostUpdateOrderDetailWithImageStr:self.imageUrlArray andSignImageStr:nil andIsSign:NO andComplete:^(id data) {
            [JRToast showWithText:data[@"message"]];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
//    }];

    
    
}

//签名
-(void)clickSignName{

    CustomerSignView*signView=[CustomerSignView signViewShowSuccess:^(UIImage *image) {
        MyLog(@"%@",image);
        NSData*data=UIImagePNGRepresentation(image);
        //上传图片
        [self HttpPostOneImageToJiekouWith:data success:^(NSString *imageStr) {
                //上传图片2
            [self httpPostUpdateOrderDetailWithImageStr:self.mainDatasModel.urlList andSignImageStr:imageStr andIsSign:YES andComplete:^(id data) {
                //完成订单
                [self httpPostCompleteSignOrderSuccess:^(id data) {
                    [JRToast showWithText:data[@"message"]];
                    [self.navigationController popViewControllerAnimated:YES];
  
                }];
                
            }];
            
            
        }];
        
        
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:signView];
    
    
}

-(void)clickEidtButton{
    self.isEdit=YES;
	self.tableFootPhoto.isEdit = YES;
    self.navigationItem.rightBarButtonItem=nil;
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        AddCustomerInputTableViewCell*cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        [cell.inputTextField becomeFirstResponder];
        
    });
    
    
    
}


#pragma mark  --delegate
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
        //        [self.self.footerImageView.firstPicBtn setImage:newPhoto forState:UIControlStateNormal];
        self.footerImageView.firstImg=newPhoto;
        if (self.saveFooterUrlArray.count>=1) {
            [self.saveFooterUrlArray replaceObjectAtIndex:0 withObject:@"xxx"];
        }
        
        
    }else if (self.selectedImage==22){
        //footer 第二张图
        [self.saveFooterImageDataDic setObject:data forKey:@"22"];
        //         [self.self.footerImageView.secondPicBtn setImage:newPhoto forState:UIControlStateNormal];
        self.footerImageView.secondImg=newPhoto;
        if (self.saveFooterUrlArray.count>=2) {
            [self.saveFooterUrlArray replaceObjectAtIndex:1 withObject:@"xxx"];
        }
        
        
    }else if (self.selectedImage==33){
        //footer 第三张图
        [self.saveFooterImageDataDic setObject:data forKey:@"33"];
        //         [self.self.footerImageView.thirdPicBtn setImage:newPhoto forState:UIControlStateNormal];
        self.footerImageView.thirdImg=newPhoto;
        if (self.saveFooterUrlArray.count>=3) {
            [self.saveFooterUrlArray replaceObjectAtIndex:2 withObject:@"xxx"];
        }
        
    }
    
    
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  --datas
-(void)getLocalDatas{
    [self httpPostGetDetailInfoWithSuccess:^(id data) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            ServiceOrderDetailModel*model=[ServiceOrderDetailModel yy_modelWithDictionary:data];
            self.mainDatasModel=model;
            if (self.mainDatasModel.X_PICURL&&![self.mainDatasModel.X_PICURL isEqualToString:@""]) {
                NSArray*array=[self.mainDatasModel.X_PICURL componentsSeparatedByString:@","];
                [self.saveFooterUrlArray addObjectsFromArray:array];
            }
            
            
            [self httpPostGetOrderBillDetailSuccess:^(id data) {
                 MyLog(@"%@",data);
                if ([data[@"code"] integerValue]==200) {
                    self.mainBillDatasModel=[ServiceOrderBillModel yy_modelWithDictionary:data[@"content"]];
                
                    
                    //本地数据 自带一个 reload
                    [self localData];
                    
                
                }else{
                    [JRToast showWithText:data[@"message"]];
                }
                
                
                
            }];
            
            
           
        }else{
            
        }
        
        
        
        
        
        
    }];
    
   
    
}

-(void)localData{
    NSArray*localArr0=@[@"姓名栏---",@"工单类型",@"客户手机",@"上门地址",@"服务人员",@"工单总额",@"状态",@"开始时间",@"完成时间",@"工单描述"];
    NSArray*localValueArr0=@[self.mainDatasModel.C_A41500_C_NAME,
                             self.mainDatasModel.C_TYPE_DD_NAME,
                             self.mainDatasModel.C_CONTACTPHONE,
                             self.mainDatasModel.C_ADDRESS,
                             self.mainDatasModel.C_OWNER_ROLENAME,
                             
                             self.mainBillDatasModel.allTotal,
                             self.mainDatasModel.C_STATUS_DD_NAME,
                             self.mainDatasModel.D_START_TIME,
                             self.mainDatasModel.D_END_TIME,
                             self.mainDatasModel.X_WORKCONTENT];
    
    NSArray*localPostNameArr0=@[self.mainDatasModel.C_A41500_C_ID,
                                self.mainDatasModel.C_TYPE_DD_ID,
                                self.mainDatasModel.C_CONTACTPHONE,
                                self.mainDatasModel.C_ADDRESS,
                                self.mainDatasModel.C_OWNER_ROLEID,
                                
                                self.mainBillDatasModel.allTotal,
                                self.mainDatasModel.C_STATUS_DD_ID,
                                self.mainDatasModel.D_START_TIME,
                                self.mainDatasModel.D_END_TIME,
                                self.mainDatasModel.X_WORKCONTENT];
    NSArray*localKeyArr0=@[@"",@"",@"",@"C_ADDRESS",@"",@"",@"",@"",@"",@"X_WORKCONTENT"];

    
      NSMutableArray*saveLocalArr0=[NSMutableArray array];
    for (int i=0; i<localArr0.count; i++) {
        PotentailCustomerEditModel*model=[[PotentailCustomerEditModel alloc]init];
        model.locatedTitle=localArr0[i];
        model.nameValue=localValueArr0[i];
        model.postValue=localPostNameArr0[i];
        model.keyValue=localKeyArr0[i];
        
        [saveLocalArr0 addObject:model];
    }

    
    
    
    
    
    
    PotentailCustomerEditModel*model=[[PotentailCustomerEditModel alloc]init];
    NSMutableArray*saveLocalArr1=[NSMutableArray arrayWithObject:model];
    NSMutableArray*saveLocalArr2=[NSMutableArray arrayWithObject:model];
    
      self.localDatas=[NSMutableArray arrayWithObjects:saveLocalArr0,saveLocalArr1,saveLocalArr2, nil];

    [self.tableView reloadData];
}



-(void)httpPostGetDetailInfoWithSuccess:(void(^)(id data))completeBlock{
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:HTTP_ServiceOrderDetail];
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
    [contentDict setObject:self.pubModel.C_ID forKey:@"C_ID"];
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
        completeBlock(data);
        
    }];
    
    
    
}


//得到所有的 费用详情
-(void)httpPostGetOrderBillDetailSuccess:(void(^)(id data))completeBlock{
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:HTTP_OrderBillDetail];
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
    [contentDict setObject:self.pubModel.C_ID forKey:@"C_A01300_C_ID"];
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
       
        completeBlock(data);
        
    }];

    
    
}


//上传图片
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


//上传一张照片
-(void)HttpPostOneImageToJiekouWith:(NSData*)data success:(void(^)(NSString*imageStr))successBlock{
    NSString*urlStr=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"ipImage"]];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataUpDataPhotoWithUrl:urlStr parameters:nil photo:data compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            
            NSString*imageStr=data[@"show_url"];
            successBlock(imageStr);
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
        
        
    }];
    
    
    
    
}


//修改数据
-(void)httpPostUpdateOrderDetailWithImageStr:(NSArray*)imageArr andSignImageStr:(NSString*)signImage andIsSign:(BOOL)isSign andComplete:(void(^)(id data))completeBlock{
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:HTTP_OrderUpdate];
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
     [contentDict setObject:self.pubModel.C_ID forKey:@"C_ID"];
	if (imageArr.count > 0) {
		contentDict[@"urlList"] = imageArr;
	}
    if (isSign) {
        [contentDict setObject:signImage forKey:@"C_SIGPICTURE"];
        
        
        
    }else{
        
//        if (imageStr&&![imageStr isEqualToString:@""]) {
//            [contentDict setObject:imageStr forKey:@"X_PICURL"];
//        }
		
		
        NSMutableArray*a04400Forms=[NSMutableArray array];
        for (ProductInfoModel*model0 in self.mainBillDatasModel.pjContent) {
            NSMutableDictionary*dict=[model0 yy_modelToJSONObject];
            [dict removeObjectForKey:@"C_A01300_C_ID"];
            [dict removeObjectForKey:@"C_TYPE_DD_ID"];
            [dict removeObjectForKey:@"C_TYPE_DD_NAME"];
            [dict setObject:@"0" forKey:@"TYPE"];
            [a04400Forms addObject:dict];
        }
        for (ProductInfoModel*model2 in self.mainBillDatasModel.qtContent) {
            NSMutableDictionary*dict=[model2 yy_modelToJSONObject];
            [dict removeObjectForKey:@"C_A01300_C_ID"];
            [dict removeObjectForKey:@"C_TYPE_DD_ID"];
            [dict removeObjectForKey:@"C_TYPE_DD_NAME"];
            [dict setObject:@"2" forKey:@"TYPE"];
            [a04400Forms addObject:dict];
        }
        if (a04400Forms.count>=1) {
            [contentDict setObject:a04400Forms forKey:@"a04400Forms"];
        }
        
        
        
        
        
        NSMutableArray*saveLocalArr0=self.localDatas[0];
        for (PotentailCustomerEditModel*model in saveLocalArr0) {
            if (model.keyValue&&![model.keyValue isEqualToString:@""]&&model.postValue&&![model.postValue isEqualToString:@""]) {
                [contentDict setObject:model.postValue forKey:model.keyValue];
                
            }
        }

        
    }
    
    
    
    
    
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            
            completeBlock(data);
           
            
        }else{
            
            [JRToast showWithText:data[@"message"]];
        }

        
    }];

    
    
}


 //完成订单
-(void)httpPostCompleteSignOrderSuccess:(void(^)(id data))completeBlock{
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:HTTP_CompleteOrder];
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
    [contentDict setObject:self.pubModel.C_ID forKey:@"C_ID"];
    [contentDict setObject:@"1" forKey:@"STATUS_TYPE"];
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            
            completeBlock(data);
            
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

#pragma mark  -- set
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-50) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.estimatedRowHeight=0;
        _tableView.estimatedSectionHeaderHeight=0;
        _tableView.estimatedSectionFooterHeight=0;
    }
    return _tableView;
    
}

-(NSMutableArray *)saveFooterUrlArray{
    if (!_saveFooterUrlArray) {
        _saveFooterUrlArray=[NSMutableArray array];
    }
    return _saveFooterUrlArray;
}

-(NSMutableDictionary *)saveFooterImageDataDic{
    if (!_saveFooterImageDataDic) {
        _saveFooterImageDataDic=[NSMutableDictionary dictionary];
    }
    return _saveFooterImageDataDic;
}

#pragma mark  --funcation
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

@end
