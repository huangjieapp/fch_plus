//
//  ServiceTaskAddOrDetailOrEditViewController.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/27.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import "ServiceTaskDetailOrEditViewController.h"
#import "ServiceTaskDetailHeaderTableViewCell.h"
#import "AddCustomerInputTableViewCell.h"
#import "AddCustomerChooseTableViewCell.h"
#import "CGCNewAppointTextCell.h"
#import "CGCOrderDetialFooter.h"
#import "KSPhotoBrowser.h"


#import "ServiceTaskDetailModel.h"


#import "CGCTemplateVC.h"
#import "CommonCallViewController.h"
#import "SingleLocationViewController.h"

typedef NS_ENUM(NSInteger,serviceTaskType){
    serviceTaskTypeDetail=0,
    serviceTaskTypeEdit,
    
};

#define CELLHeader   @"ServiceTaskDetailHeaderTableViewCell"
#define CELLBottom   @"CGCNewAppointTextCell"
#define CELL0        @"AddCustomerInputTableViewCell"
#define CELL1        @"AddCustomerChooseTableViewCell"
@interface ServiceTaskDetailOrEditViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,assign)serviceTaskType type;    //

@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)CGCOrderDetialFooter*footerImageView;
@property(nonatomic,strong)UIButton*commitButton;   //提交的按钮

@property(nonatomic,assign)BOOL canSave;
@property(nonatomic,strong)NSArray*localTitleDatas;
@property(nonatomic,strong)ServiceTaskDetailModel*mainDatasModel;
@property(nonatomic,strong)NSMutableDictionary*postParamsDict;   //需要传到后台的数据

@property(nonatomic,assign)NSInteger selectedImage;  //点击的是哪个 图片按钮    11 22 33 还有其他   0
@property(nonatomic,strong)NSMutableArray*saveFooterUrlArray;//编辑界面  保存的底部的图片
@property(nonatomic,strong)NSMutableDictionary*saveFooterImageDataDic; //保存 3张图片的data   11  22  33  key

@end

@implementation ServiceTaskDetailOrEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [self getLocalDatas];
    [self httpPostGetDetailInfo];
  
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:CELLHeader bundle:nil] forCellReuseIdentifier:CELLHeader];
    [self.tableView registerNib:[UINib nibWithNibName:CELLBottom bundle:nil] forCellReuseIdentifier:CELLBottom];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
    [self.tableView registerNib:[UINib nibWithNibName:CELL1 bundle:nil] forCellReuseIdentifier:CELL1];
    [self addCommitButton];
    [self addRightNaviButton];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[DBTools findFirstResponderBeneathView:self.view] resignFirstResponder];
    
}

//在tableView reload的时候需要刷新
-(void)tableViewReload{
    if (self.type==serviceTaskTypeDetail) {
        self.title=@"任务详情";
        self.commitButton.hidden=YES;
        self.tableView.frame=CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        
        
    }else if (self.type==serviceTaskTypeEdit){
        self.title=@"任务编辑";
        self.commitButton.hidden=NO;
        self.tableView.frame=CGRectMake(0, 0, KScreenWidth, KScreenHeight-50);
    }

    
    
}



#pragma mark  --UI
-(void)addCommitButton{
    UIButton*commitButton=[[UIButton alloc]initWithFrame:CGRectMake(20, KScreenHeight-50, KScreenWidth-40, 40)];
    commitButton.backgroundColor=KNaviColor;
    [commitButton setTitleNormal:@"提交"];
    [commitButton setTitleColor:[UIColor blackColor]];
    [commitButton addTarget:self action:@selector(clickCommitButton:)];
    self.commitButton=commitButton;
    [self.view addSubview:commitButton];
    
    commitButton.hidden=YES;
    
}

-(void)addRightNaviButton{
    UIBarButtonItem*rightItem=[[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(clickEidtButton)];
    rightItem.tintColor=[UIColor blackColor];
    self.navigationItem.rightBarButtonItem=rightItem;
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.localTitleDatas.count;
}


//只能修改 电话  地址   备注  图片
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DBSelf(weakSelf);
    NSString*titleName=self.localTitleDatas[indexPath.row];
    
    
    if (indexPath.row==0) {
        //头像
        ServiceTaskDetailHeaderTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELLHeader];
        if (self.mainDatasModel.C_HEADIMGURL&&![self.mainDatasModel.C_HEADIMGURL isEqualToString:@""]) {
            cell.headLab.hidden=YES;
            [cell.headImageV sd_setImageWithURL:[NSURL URLWithString:self.mainDatasModel.C_HEADIMGURL] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
            
        }else{
            cell.headLab.hidden=NO;
            NSString*showStr=[self.mainDatasModel.C_A41500_C_NAME substringToIndex:1];
            if (showStr) {
                 cell.headLab.text=showStr;
            }
           
            
        }
        
        
        cell.nameLab.text=self.mainDatasModel.C_A41500_C_NAME;
        
        cell.clickTopThreeButtonBlock = ^(NSInteger index) {
            MyLog(@"%lu",index);
            if (index==0) {
                NSInteger index=indexPath.section*100+indexPath.row;
                [weakSelf selectTelephone:index];
                
            }else if (index==1){
                //                [JRToast showWithText:@"短信"];
                CGCTemplateVC*vc=[[CGCTemplateVC alloc]init];
                vc.templateType=CGCTemplateMessage;
                vc.titStr=self.mainDatasModel.C_A41500_C_NAME;
                vc.customPhoneArr=[@[self.mainDatasModel.C_CONTACTPHONE] mutableCopy];
                vc.cusDetailModel.C_ID=self.mainDatasModel.C_A41500_C_ID;
                vc.cusDetailModel.C_HEADIMGURL=self.mainDatasModel.C_HEADIMGURL;
                vc.cusDetailModel.C_NAME=self.mainDatasModel.C_A41500_C_NAME;
//                vc.cusDetailModel.C_LEVEL_DD_NAME=self.detailInfoModel.C_LEVEL_DD_NAME;
//                vc.cusDetailModel.C_LEVEL_DD_ID=self.detailInfoModel.C_LEVEL_DD_ID;
                [self.navigationController pushViewController:vc animated:YES];
                
                
                
                
            }else if (index==2){
                //                 [JRToast showWithText:@"微信"];
                CGCTemplateVC*vc=[[CGCTemplateVC alloc]init];
                vc.templateType=CGCTemplateWeiXin;
                vc.titStr=self.mainDatasModel.C_A41500_C_NAME;
                vc.customIDArr=[@[self.mainDatasModel.C_CONTACTPHONE] mutableCopy];
                vc.cusDetailModel.C_ID=self.mainDatasModel.C_A41500_C_ID;
                vc.cusDetailModel.C_HEADIMGURL=self.mainDatasModel.C_HEADIMGURL;
                vc.cusDetailModel.C_NAME=self.mainDatasModel.C_A41500_C_NAME;
//                vc.cusDetailModel.C_LEVEL_DD_NAME=self.detailInfoModel.C_LEVEL_DD_NAME;
//                vc.cusDetailModel.C_LEVEL_DD_ID=self.detailInfoModel.C_LEVEL_DD_ID;
                [self.navigationController pushViewController:vc animated:YES];
                
                
            }
        };
        

        
       
        
        return cell;
    }else if (indexPath.row==2||indexPath.row==3){
        //输入
        AddCustomerInputTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
        cell.nameTitleLabel.text=titleName;
        if (self.type==serviceTaskTypeDetail) {
//            cell.userInteractionEnabled=NO;
			cell.inputTextField.enabled = NO;
        }else if (self.type==serviceTaskTypeEdit){
            cell.userInteractionEnabled=YES;
			
        }
        
        
        
        if (indexPath.row==2) {
            cell.inputWith.constant=100;
            cell.inputRight.constant=10;
            cell.textFieldLength=11;
            cell.inputTextField.keyboardType=UIKeyboardTypeNumberPad;
            
            UIImageView*phoneImageV=[cell viewWithTag:250];
            if (!phoneImageV) {
                phoneImageV=[[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth-110-20-10, 0, 20, 20)];
                phoneImageV.centerY=cell.inputTextField.centerY;
                phoneImageV.image=[UIImage imageNamed:@"icon_order_call_phone"];
                phoneImageV.tag=250;
                [cell.contentView addSubview:phoneImageV];

            }
            
            cell.inputTextField.text=self.mainDatasModel.C_CONTACTPHONE;
            
            
            
            cell.changeTextBlock = ^(NSString *textStr) {
                MyLog(@"%@",textStr);
                [self.postParamsDict setObject:textStr forKey:@"C_CONTACTPHONE"];
                
                
            };
            
            
        }else{
            cell.inputTextField.keyboardType=UIKeyboardTypeDefault;
            cell.inputWith.constant=225;
            cell.inputRight.constant=45;
            cell.textFieldLength=0;
            
            
            cell.inputTextField.text=self.mainDatasModel.C_ADDRESS;
           

            
            cell.changeTextBlock = ^(NSString *textStr) {
                MyLog(@"%@",textStr);
                [self.postParamsDict setObject:textStr forKey:@"C_ADDRESS"];
                
                
                
            };
            UIButton*button=[cell.contentView viewWithTag:200];
            if (!button) {
                button=[[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth-35, 0, 25, 25)];
                button.centerY=cell.contentView.centerY;
                button.tag=200;
                [button setBackgroundImage:[UIImage imageNamed:@"icon_service_task_map"] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(clickLocalButton) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:button];
                
                
            }
			
            
            
            
        }

        
        
        
        return cell;
        
        
    }else if (indexPath.row==8){
        //备注
        CGCNewAppointTextCell*cell=[tableView dequeueReusableCellWithIdentifier:CELLBottom];
        cell.topTitleLabel.text=titleName;
        if (self.type==serviceTaskTypeDetail) {
            cell.userInteractionEnabled=NO;
        }else if (self.type==serviceTaskTypeEdit){
            cell.userInteractionEnabled=YES;
        }
        
        cell.beforeText=self.mainDatasModel.X_REMARK;
        
        cell.changeTextBlock = ^(NSString *textStr) {
            MyLog(@"%@",textStr);
            [self.postParamsDict setObject:textStr forKey:@"X_REMARK"];
            
            
        };
        
        
        
        
        //屏幕的上移问题
        cell.startInputBlock = ^{
            [UIView animateWithDuration:0.25 animations:^{
                
                CGRect frame = self.view.frame;
                //frame.origin.y+
                frame.origin.y = -260;
                
                self.view.frame = frame;
                
            }];
        };
        
        cell.endBlock = ^{
            [UIView animateWithDuration:0.25 animations:^{
                
                CGRect frame = self.view.frame;
                
                frame.origin.y = 0.0;
                
                self.view.frame = frame;
                
            }];
            
            
        };

        
        
        return cell;
        
        
    }else{
        AddCustomerChooseTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL1];
        cell.nameTitleLabel.text=titleName;
        cell.userInteractionEnabled=NO;
        
        if (indexPath.row==1) {
            //任务类型
            cell.chooseTextField.text=self.mainDatasModel.C_TYPE_DD_NAME;
            
        }else if (indexPath.row==4){
            //服务人员
             cell.chooseTextField.text=self.mainDatasModel.C_OWNER_ROLENAME;
            
            
        }else if (indexPath.row==5){
            //状态
             cell.chooseTextField.text=self.mainDatasModel.C_STATUS_DD_NAME;
            
        }else if (indexPath.row==6){
            //要求到达时间
             cell.chooseTextField.text=self.mainDatasModel.D_ORDER_TIME;
            
        }else if (indexPath.row==7){
            //签到时间
             cell.chooseTextField.text=self.mainDatasModel.D_SIGNTIME_TIME;
            
        }
        
        

        
        
        return cell;
        
    }
    
    
    
}

static CGCOrderDetialFooter * extracted(ServiceTaskDetailOrEditViewController *object) {
	return object.footerImageView;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
     DBSelf(weakSelf);
    // 刷新
    [self tableViewReload];
   

    if (!self.footerImageView) {
        CGCOrderDetialFooter*footer=[[NSBundle mainBundle]loadNibNamed:@"CGCOrderDetialFooter" owner:nil options:nil].firstObject;
        footer.tag=1111;
        footer.frame=CGRectMake(0, 0, KScreenWidth, 150);
        self.footerImageView=footer;

        
    }
    
	if (self.type==serviceTaskTypeDetail) {
		self.footerImageView.isDetail = YES;
	} else if (self.type==serviceTaskTypeEdit) {
		self.footerImageView.isDetail = NO;
	}
    self.footerImageView.beforeImageArray=self.saveFooterUrlArray;
    if (self.type==serviceTaskTypeDetail) {
//        self.footerImageView.userInteractionEnabled=NO;
		self.footerImageView.deleteOneButton.hidden = self.footerImageView.deleteSecondButton.hidden = self.footerImageView.deleteThirdButton.hidden = YES;
		
    }else if (self.type==serviceTaskTypeEdit){
//        self.footerImageView.userInteractionEnabled=YES;
    }

    
    
    
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
    
	extracted(self).clickThirdBlock = ^(UIImage*image){
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
    
    
    
    
    
    
    return self.footerImageView;

    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&indexPath.row==0) {
        
        return 70;
    }else if (indexPath.section==0&&indexPath.row==8){
        return 100;
    }
    
    
    else{
        return 44;
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 150;
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



#pragma mark  --click
-(void)clickCommitButton:(UIButton*)button{
    NSString*judgeStr=[self judgeCanSave];
    if (!_canSave) {
        [JRToast showWithText:judgeStr];
        return;
    }
    
    
    
    //图片这里
 [self httpPostArrayImage:self.saveFooterImageDataDic compliete:^(NSArray *arrayImg) {
       [self.saveFooterUrlArray removeObject:@"xxx"];
      [self.saveFooterUrlArray addObjectsFromArray:arrayImg];
     NSString*X_PICURLStr=[self.saveFooterUrlArray componentsJoinedByString:@","];
     if (X_PICURLStr&&![X_PICURLStr isEqualToString:@""]) {
         [self.postParamsDict setObject:X_PICURLStr forKey:@"X_PICURL"];
     }
     
     
     [self httpPostChangeServiceTaskWithImgStr:X_PICURLStr];
     
     
 }];
    
    
    
}

-(void)clickEidtButton{
    self.type=serviceTaskTypeEdit;
    self.navigationItem.rightBarButtonItem=nil;
    [self.tableView reloadData];
    
    AddCustomerInputTableViewCell*cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    [cell.inputTextField becomeFirstResponder];
    
    
}

-(void)clickLocalButton{
    //点击定位的按钮
    MyLog(@"%@,%@",self.mainDatasModel.B_SIGN_LON,self.mainDatasModel.B_SIGN_LAT);
    CLLocationCoordinate2D PubCoordinate = CLLocationCoordinate2DMake([self.mainDatasModel.B_CUSTOMER_LAT floatValue], [self.mainDatasModel.B_CUSTOMER_LON floatValue]);
//    PubCoordinate.latitude=[self.mainDatasModel.B_SIGN_LAT integerValue];
//    PubCoordinate.longitude=[self.mainDatasModel.B_SIGN_LON integerValue];
	
    SingleLocationViewController*vc=[[SingleLocationViewController alloc]init];
    vc.locateType=LocatedTypeShowMap;
    vc.PubCoordinate=PubCoordinate;
	vc.addressStr = self.mainDatasModel.C_ADDRESS;
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark  --datas
-(void)httpPostGetDetailInfo{
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:HTTP_ServiceTaskDetail];
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
    [contentDict setObject:self.C_ID forKey:@"C_ID"];
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            self.mainDatasModel=[ServiceTaskDetailModel yy_modelWithDictionary:data];
            NSString*x_pic=self.mainDatasModel.X_PICURL;
            if (x_pic&&![x_pic isEqualToString:@""]) {
                NSArray*array=[x_pic componentsSeparatedByString:@","];
                if (array.count>=1) {
                    [self.saveFooterUrlArray addObjectsFromArray:array];
                }

            }
            
            
            [self.tableView reloadData];
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
        
    }];
    
    
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




-(void)httpPostChangeServiceTaskWithImgStr:(NSString*)x_picStr{
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:HTTP_ChangeServiceTask];
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
    [contentDict setObject:self.mainDatasModel.C_ID forKey:@"C_ID"];
    [self.postParamsDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj) {
            [contentDict setObject:obj forKey:key];
            
        }
        
    }];
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
        
    }];
    
    
    
}



-(void)getLocalDatas{
    self.localTitleDatas=@[@"头像",@"任务类型",@"客户电话",@"上门地址",@"服务人员",@"状态",@"要求到达时间",@"签到时间",@"任务备注"];
  
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
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
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


-(NSMutableDictionary *)postParamsDict{
    if (!_postParamsDict) {
        _postParamsDict=[NSMutableDictionary dictionary];
    }
    return _postParamsDict;
    
}


#pragma mark  --funcation
//电话
- (void)telephoneCall:(NSInteger)index{
    long section=index/100;
    int row=index%100;
    
//    if (self.allListDatas.count<section||[[self.allListDatas[section] content] count]<row) {
//        [JRToast showWithText:@"section row 错误"];
//        return;
//    }
    
    
//    PotentailCustomerListModel*model=self.allListDatas[section];
//    PotentailCustomerListDetailModel*detailModel=model.content[row];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:self.mainDatasModel.C_CONTACTPHONE]]];
}


//座机
- (void)landLineCall:(NSInteger)index{
    
    long section=index/100;
    int row=index%100;
//    if (self.allListDatas.count<section||[[self.allListDatas[section] content] count]<row) {
//        [JRToast showWithText:@"section row 错误"];
//        return;
//    }
//    PotentailCustomerListModel*model=self.allListDatas[section];
//    PotentailCustomerListDetailModel*detailModel=model.content[row];
    
    
    CommonCallViewController *myView=[[CommonCallViewController alloc]initWithNibName:@"CommonCallViewController" bundle:nil];
    myView.typeStr=@"用座机拨打";
    myView.nameStr=self.mainDatasModel.C_A41500_C_NAME;
    myView.callStr=self.mainDatasModel.C_CONTACTPHONE;
    [self.navigationController pushViewController:myView animated:YES];
    
}

//回呼
- (void)callBack:(NSInteger)index{
    long section=index/100;
    int row=index%100;
//    if (self.allListDatas.count<section||[[self.allListDatas[section] content] count]<row) {
//        [JRToast showWithText:@"section row 错误"];
//        return;
//    }
//    PotentailCustomerListModel*model=self.allListDatas[section];
//    PotentailCustomerListDetailModel*detailModel=model.content[row];
    
    CommonCallViewController *myView=[[CommonCallViewController alloc]initWithNibName:@"CommonCallViewController" bundle:nil];
    myView.typeStr=@"回呼到手机";
    myView.nameStr=self.mainDatasModel.C_A41500_C_NAME;
    myView.callStr=self.mainDatasModel.C_CONTACTPHONE;
    [self.navigationController pushViewController:myView animated:YES];
    
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[DBTools findFirstResponderBeneathView:self.view] resignFirstResponder];
}


-(NSString*)judgeCanSave{
    _canSave=YES;
    NSString*phoneStr=self.postParamsDict[@"C_CONTACTPHONE"];
    NSString*AddressStr=self.postParamsDict[@"C_ADDRESS"];
    if (!phoneStr&&!AddressStr) {
        return @"";
    }
    
    
    
    
    
    if (phoneStr.length==11) {
        
        
    }else{
        _canSave=NO;
        return @"电话号码必须是11位数字";
    }
    
    
    if (AddressStr.length>1) {
        
        
    }else{
        _canSave=NO;
        return @"地址不能为空";
    }
    
    return @"";
    
}


@end
