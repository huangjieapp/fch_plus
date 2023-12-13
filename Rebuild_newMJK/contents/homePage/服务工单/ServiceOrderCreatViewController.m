//
//  ServiceOrderCreatViewController.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/31.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import "ServiceOrderCreatViewController.h"
#import "AddCustomerInputTableViewCell.h"
#import "AddCustomerChooseTableViewCell.h"
#import "CGCNewAppointTextCell.h"
#import "AddProductTableViewCell.h"
#import "CGCOrderDetialFooter.h"   //view
#import "MJKPhotoView.h"
#import "KSPhotoBrowser.h"
#import "ThreeInputView.h"

#import "PotentailCustomerEditModel.h"



#define inputCell     @"AddCustomerInputTableViewCell"
#define chooseCell    @"AddCustomerChooseTableViewCell"
#define RemarkCell    @"CGCNewAppointTextCell"
#define ProductCell   @"AddProductTableViewCell"
@interface ServiceOrderCreatViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)CGCOrderDetialFooter*footerImageView;
@property(nonatomic,strong)UILabel*priceLab;


@property(nonatomic,assign)BOOL canSave;  //能否被提交
@property(nonatomic,strong)NSMutableArray*localDatas;   //2个section Array  里面是model   4个

@property(nonatomic,strong)NSMutableArray<ProductInfoModel*>*materialInfoArray;  //材料信息
@property(nonatomic,strong)NSMutableArray<ProductInfoModel*>*otherBillArray;  //其他费用



@property(nonatomic,strong)NSMutableArray*saveFooterUrlArray;//编辑界面  保存的底部的图片
@property(nonatomic,assign)NSInteger selectedImage;  //点击的是哪个 图片按钮    11 22 33 还有其他   0
@property(nonatomic,strong)NSMutableDictionary*saveFooterImageDataDic; //保存 3张图片的data   11  22  33  key


/** (MJKPhotoView *)tableFootPhoto*/
@property (nonatomic, strong) MJKPhotoView *tableFootPhoto;
/** image url array*/
@property (nonatomic, strong) NSArray *imageUrlArray;
@end

@implementation ServiceOrderCreatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"新增工单";
     [self getLocalDatas];
      [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:inputCell bundle:nil] forCellReuseIdentifier:inputCell];
    [self.tableView registerNib:[UINib nibWithNibName:chooseCell bundle:nil] forCellReuseIdentifier:chooseCell];
    [self.tableView registerNib:[UINib nibWithNibName:RemarkCell bundle:nil] forCellReuseIdentifier:RemarkCell];
    [self.tableView registerClass:[AddProductTableViewCell class] forCellReuseIdentifier:ProductCell];
      [self addCommitButton];
    
    self.view.backgroundColor=[UIColor whiteColor];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)tableViewReload{
    //计算出来 总的费用
    CGFloat totailNumber=0.00;
    for (ProductInfoModel*oneModel in self.materialInfoArray) {
        totailNumber=totailNumber+[oneModel.B_SUBTOTAL floatValue];
    }
    
    for (ProductInfoModel*twoModel in self.otherBillArray) {
        totailNumber=totailNumber+[twoModel.B_SUBTOTAL floatValue];
    }
    
    self.priceLab.text=[NSString stringWithFormat:@"%.2f",totailNumber];
    
}

#pragma mark  --UI
-(void)addCommitButton{
    UIButton*commitButton=[[UIButton alloc]initWithFrame:CGRectMake(0, KScreenHeight-50, 80, 50)];
    [commitButton setTitleNormal:@"提交"];
    [commitButton setTitleColor:[UIColor blackColor]];
    commitButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [commitButton addTarget:self action:@selector(clickCommit)];
    [self.view addSubview:commitButton];
    
    UIView*BGView=[[UIView alloc]initWithFrame:CGRectMake(80, KScreenHeight-50, KScreenWidth-80, 50)];
    BGView.backgroundColor=KNaviColor;
    [self.view addSubview:BGView];
    
    
    UILabel*titleLab=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 50, 20)];
    titleLab.centerY=BGView.height/2;
    titleLab.font=[UIFont systemFontOfSize:17];
    titleLab.textColor=[UIColor whiteColor];
    titleLab.text=@"总价";
    [BGView addSubview:titleLab];
    
    UILabel*priceLab=[[UILabel alloc]initWithFrame:CGRectMake(90, 0, BGView.width-90-10, 20)];
    priceLab.centerY=BGView.height/2;
    priceLab.textAlignment=NSTextAlignmentRight;
    priceLab.textColor=[UIColor whiteColor];
    priceLab.font=[UIFont systemFontOfSize:17];
    priceLab.text=@"00.00";
    self.priceLab=priceLab;
    [BGView addSubview:priceLab];
    
    
    
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
    
    //输入
    if ((indexPath.section==0&&indexPath.row==0)||(indexPath.section==0&&indexPath.row==1)||(indexPath.section==0&&indexPath.row==2)) {
        AddCustomerInputTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:inputCell];
        cell.inputTextField.keyboardType=UIKeyboardTypeDefault;
        cell.inputWith.constant=245;
        cell.nameTitleLabel.text=model.locatedTitle;
        cell.inputTextField.text=model.nameValue;
        if (indexPath.row==0) {
            cell.userInteractionEnabled=NO;
        }else if (indexPath.row==1){
            cell.userInteractionEnabled=NO;
            cell.inputTextField.placeholder=@"请输入电话";
            cell.inputWith.constant=100;
            cell.textFieldLength=11;
            cell.inputTextField.keyboardType=UIKeyboardTypeNumberPad;
            
            UIImageView*phoneImageV=[[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth-110-20-10, 0, 20, 20)];
            phoneImageV.centerY=cell.inputTextField.centerY;
            phoneImageV.image=[UIImage imageNamed:@"icon_order_call_phone"];
            [cell.contentView addSubview:phoneImageV];

            cell.changeTextBlock = ^(NSString *textStr) {
                MyLog(@"%@",textStr);
                model.postValue=textStr;
                model.nameValue=textStr;
                
            };

            
            
        }else if (indexPath.row==2){
            cell.userInteractionEnabled=YES;
            cell.changeTextBlock = ^(NSString *textStr) {
                MyLog(@"%@",textStr);
                model.nameValue=textStr;
                model.postValue=textStr;
                
            };
            
        }
        
        
        
        
        
        return cell;
        //选择
    }else if ((indexPath.section==1&&indexPath.row==0)||(indexPath.section==1&&indexPath.row==1)||(indexPath.section==1&&indexPath.row==2)||(indexPath.section==1&&indexPath.row==3)){
        AddCustomerChooseTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:chooseCell];
        cell.nameTitleLabel.text=model.locatedTitle;
        if (model.nameValue&&![model.nameValue isEqualToString:@""]) {
            cell.chooseTextField.text=model.nameValue;
        }

        
        if (indexPath.row==0) {
            //工单类型
            cell.Type=CHooseTableViewTypeOrderType;
            cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                MyLog(@"%@,%@",str,postValue);
                model.postValue=postValue;
                model.nameValue=str;
                [weakSelf.tableView reloadData];
                
            };

            
        }else if (indexPath.row==1){
            //服务人员
            cell.Type=CHooseTableViewTypeServicer;
            cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                MyLog(@"%@,%@",str,postValue);
                model.postValue=postValue;
                model.nameValue=str;
                [weakSelf.tableView reloadData];
                
            };

            
        }else if (indexPath.row==2){
            //要求到达时间
            cell.Type=ChooseTableViewTypeAllTime;
			cell.isTitle = YES;
            cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                MyLog(@"%@,%@",str,postValue);
                model.postValue=postValue;
                model.nameValue=str;
                [weakSelf.tableView reloadData];
                
            };

            
            
        }else if (indexPath.row==3){
            //开始时间
            cell.Type=ChooseTableViewTypeAllTime;
			cell.isTitle = YES;
            cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                MyLog(@"%@,%@",str,postValue);
                model.postValue=postValue;
                model.nameValue=str;
                [weakSelf.tableView reloadData];
                
            };

            
            
        }
        
        
        
        
        return cell;
        //备注
    }else if (indexPath.section==1&&indexPath.row==4){
        CGCNewAppointTextCell*cell=[tableView dequeueReusableCellWithIdentifier:RemarkCell];
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
        //列表
    }else if (indexPath.section==2&&indexPath.row==0){
        AddProductTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:ProductCell];
        cell.titleStr=@"材料信息";
        cell.datasArray=self.materialInfoArray;
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
                [self.materialInfoArray addObject:model];
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
                [self.materialInfoArray removeObjectAtIndex:row];
                [self.tableView reloadData];

            }];
            [alertVC addAction:cancel];
            [alertVC addAction:sure];
            [self presentViewController:alertVC animated:YES completion:nil];
            
            
            
        };
        
        
        
        return cell;

        //列表
    }else{
        //section 3
        AddProductTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:ProductCell];
        cell.titleStr=@"其他费用";
        cell.datasArray=self.otherBillArray;
        cell.clickAddInfoButtonBlock = ^(NSString *titleStr) {
              MyLog(@"%@",titleStr);
            ThreeInputView*inputView=[ThreeInputView showThreeInputViewAndSuccess:^(NSString *firstText, NSString *secondText, NSString *thirdText) {
                ProductInfoModel*model=[[ProductInfoModel alloc]init];
                model.B_PRICE=secondText;
                model.C_NAME=firstText;
                model.I_NUMBER=thirdText;
                model.TYPE=@"2";
                model.B_SUBTOTAL=[NSString stringWithFormat:@"%.2f",[model.B_PRICE floatValue]*[model.I_NUMBER floatValue]];
                model.C_ID=[DBObjectTools getProductC_id];
                [self.otherBillArray addObject:model];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationFade];
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
                [self.otherBillArray removeObjectAtIndex:row];
                [self.tableView reloadData];
                
            }];
            [alertVC addAction:cancel];
            [alertVC addAction:sure];
            [self presentViewController:alertVC animated:YES completion:nil];
            
            
            
        };

        
        
        
        return cell;

        
    }
    
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1&&indexPath.row==4) {
        
        return 100;
    }else if (indexPath.section==2){
        return [AddProductTableViewCell getCellHeight:self.materialInfoArray];
    }else if (indexPath.section==3){
        return [AddProductTableViewCell getCellHeight:self.otherBillArray];
    }else{
        return 44;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0||section==1) {
        return 30;
    }else{
        return 0.01;
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==1) {
        return 150;
    }else{
        return 0.01;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0||section==1) {
        UIView*mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
        mainView.backgroundColor=[UIColor clearColor];
        
        UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 8, KScreenWidth/2, 14)];
        titleLabel.textColor=[UIColor blackColor];
        [mainView addSubview:titleLabel];
        if (section==0) {
            titleLabel.text=@"客户信息";
        }else if(section==1){
            titleLabel.text=@"工单信息";
        }
        
        return mainView;

    }
    return nil;
}


-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    //刷新数据
    [self tableViewReload];
    
    
    
    if (section==1) {
        DBSelf(weakSelf);
		return self.tableFootPhoto;
        /*if (!self.footerImageView) {
            CGCOrderDetialFooter*footer=[[NSBundle mainBundle]loadNibNamed:@"CGCOrderDetialFooter" owner:nil options:nil].firstObject;
            footer.tag=1111;
            footer.frame=CGRectMake(0, 0, KScreenWidth, 150);
            self.footerImageView=footer;
            
            
        }
        
        
#warning 安全起见   反正 没有前面的数据
//        self.footerImageView.beforeImageArray=self.saveFooterUrlArray;
        
        
        
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
    
    
    return nil;
    
    
    
}

- (MJKPhotoView *)tableFootPhoto {
	DBSelf(weakSelf);
	if (!_tableFootPhoto) {
		_tableFootPhoto = [[MJKPhotoView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 150)];
		_tableFootPhoto.isEdit = YES;
		_tableFootPhoto.isCamera = NO;
		_tableFootPhoto.rootVC = self;
		_tableFootPhoto.backUrlArray = ^(NSArray *arr, NSArray *saveArr) {
			weakSelf.imageUrlArray = arr;
		};
	}
	return _tableFootPhoto;
}


#pragma mark  --click
-(void)clickCommit{
    //提交
//      [self httpPostArrayImage:self.saveFooterImageDataDic compliete:^(NSArray *arrayImg) {
//          [self.saveFooterUrlArray removeObject:@"xxx"];
//          [self.saveFooterUrlArray addObjectsFromArray:arrayImg];
//          NSString*X_PICURLStr=[self.saveFooterUrlArray componentsJoinedByString:@","];
	
          [self httpPostCreatWorkOrderWithImageStr:self.imageUrlArray];
          
//      }];
	
    
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
    NSArray*localArr0=@[@"姓名",@"手机",@"上门地址"];
    NSArray*localValueArr0=@[self.serviceTaskDatas.C_A41500_C_NAME,self.serviceTaskDatas.C_CONTACTPHONE,self.serviceTaskDatas.C_ADDRESS];
    NSArray*localPostNameArr0=@[self.serviceTaskDatas.C_A41500_C_ID,self.serviceTaskDatas.C_CONTACTPHONE,self.serviceTaskDatas.C_ADDRESS];
    NSArray*localKeyArr0=@[@"",@"",@"C_ADDRESS"];

    
    NSArray*localArr1=@[@"工单类型",@"服务人员",@"要求到达时间",@"开始时间",@"服务内容"];
    NSArray*localValueArr1=@[self.serviceTaskDatas.C_TYPE_DD_NAME,[NewUserSession instance].user.nickName,self.serviceTaskDatas.D_ORDER_TIME,self.serviceTaskDatas.D_SIGNTIME_TIME,@""];
    NSArray*localPostNameArr1=@[self.serviceTaskDatas.C_TYPE_DD_ID,[NewUserSession instance].user.u051Id,self.serviceTaskDatas.D_ORDER_TIME,self.serviceTaskDatas.D_SIGNTIME_TIME,@""];
    NSArray*localKeyArr1=@[@"C_TYPE_DD_ID",@"USER_ID",@"D_ORDER_TIME",@"D_START_TIME",@"X_WORKCONTENT"];

 
    NSMutableArray*saveLocalArr0=[NSMutableArray array];
    NSMutableArray*saveLocalArr1=[NSMutableArray array];
    for (int i=0; i<localArr0.count; i++) {
        PotentailCustomerEditModel*model=[[PotentailCustomerEditModel alloc]init];
        model.locatedTitle=localArr0[i];
        model.nameValue=localValueArr0[i];
        model.postValue=localPostNameArr0[i];
        model.keyValue=localKeyArr0[i];
        
        [saveLocalArr0 addObject:model];
    }
    
    for (int i=0; i<localArr1.count; i++) {
        PotentailCustomerEditModel*model=[[PotentailCustomerEditModel alloc]init];
        model.locatedTitle=localArr1[i];
        model.nameValue=localValueArr1[i];
        model.postValue=localPostNameArr1[i];
        model.keyValue=localKeyArr1[i];
        
        [saveLocalArr1 addObject:model];
    }

     PotentailCustomerEditModel*model=[[PotentailCustomerEditModel alloc]init];
    NSMutableArray*saveLocalArr2=[NSMutableArray arrayWithObject:model];
    NSMutableArray*saveLocalArr3=[NSMutableArray arrayWithObject:model];

    self.localDatas=[NSMutableArray arrayWithObjects:saveLocalArr0,saveLocalArr1,saveLocalArr2,saveLocalArr3, nil];
    
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




-(void)httpPostCreatWorkOrderWithImageStr:(NSArray*)imageArr{
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:HTTP_CreatServiceOrder];
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
//    if (imageStr&&![imageStr isEqualToString:@""]) {
//        [contentDict setObject:imageStr forKey:@"X_PICURL"];
//    }
	if (imageArr.count > 0) {
		contentDict[@"urlList"] = imageArr;
	}
    [contentDict setObject:[DBObjectTools getServiceOrderC_id] forKey:@"C_ID"];
    [contentDict setObject:self.serviceTaskDatas.C_ID forKey:@"C_A01200_C_ID"];
    [contentDict setObject:self.serviceTaskDatas.C_A41500_C_ID forKey:@"C_A41500_C_ID"];
    [contentDict setObject:self.serviceTaskDatas.C_A42000_C_ID forKey:@"C_A42000_C_ID"];
    NSMutableArray*a04400Forms=[NSMutableArray array];
    for (ProductInfoModel*model0 in self.materialInfoArray) {
        NSDictionary*dict=[model0 yy_modelToJSONObject];
        [a04400Forms addObject:dict];
    }
    for (ProductInfoModel*model2 in self.otherBillArray) {
        NSDictionary*dict=[model2 yy_modelToJSONObject];
        [a04400Forms addObject:dict];
    }
    if (a04400Forms.count>=1) {
        [contentDict setObject:a04400Forms forKey:@"a04400Forms"];
    }

    
    
    NSMutableArray*saveLocalArr0=self.localDatas[0];
    for (PotentailCustomerEditModel*model in saveLocalArr0) {
        if (model.postValue&&![model.postValue isEqualToString:@""]&&model.keyValue&&![model.keyValue isEqualToString:@""]) {
            [contentDict setObject:model.postValue forKey:model.keyValue];
        }
        
    }
    
    NSMutableArray*saveLocalArr1=self.localDatas[1];
    for (PotentailCustomerEditModel*model2 in saveLocalArr1) {
        if (model2.postValue&&![model2.postValue isEqualToString:@""]&&model2.keyValue&&![model2.keyValue isEqualToString:@""]) {
            [contentDict setObject:model2.postValue forKey:model2.keyValue];
        }
        
    }
    
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
             [JRToast showWithText:data[@"message"]];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            [JRToast showWithText:data[@"message"]];
        }
        
        
    }];
    
    
    
};


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


-(NSMutableArray *)materialInfoArray{
    if (!_materialInfoArray) {
        _materialInfoArray=[NSMutableArray array];
    }
    return _materialInfoArray;
}

-(NSMutableArray *)otherBillArray{
    if (!_otherBillArray) {
        _otherBillArray=[NSMutableArray array];
    }
    return _otherBillArray;
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
