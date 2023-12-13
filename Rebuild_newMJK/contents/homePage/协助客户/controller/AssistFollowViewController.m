//
//  AssistFollowViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/2/8.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "AssistFollowViewController.h"
#import "AddCustomerProductTableViewCell.h"
#import "AddCustomerInputTableViewCell.h"
#import "AddCustomerChooseTableViewCell.h"
#import "ZhanbaiChooseTableViewCell.h"
#import "CGCOrderDetialFooter.h"   //view
#import "CGCAlertDateView.h"
#import "KSPhotoBrowser.h"

#import "CustomerFollowModel.h"
#import "CustomerLvevelNextFollowModel.h"
#import "CustomerFollowDetailModel.h"

#import "iflyMSC/IFlyMSC.h"
#import "ISRDataHelper.h"
#import "MJKPhotoView.h"


#import "MJKVoiceCViewController.h"
#import "CustomerDetailViewController.h"

#define CELL0   @"AddCustomerInputTableViewCell"
#define CELL1   @"AddCustomerProductTableViewCell"
#define CELL2   @"AddCustomerChooseTableViewCell"
#define zhanbaiCELL    @"ZhanbaiChooseTableViewCell"
@interface AssistFollowViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,IFlySpeechRecognizerDelegate>
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)UILabel*switchLabel;


@property(nonatomic,strong)NSMutableArray<CustomerFollowModel*>*saveAllModelArray;
@property(nonatomic,assign)BOOL canSave;
@property(nonatomic,strong)NSMutableArray*saveTimeNumberArray;  //每一个类的时长

@property(nonatomic,strong)CGCOrderDetialFooter*footerImageView;   //底部的图片view
@property(nonatomic,assign)NSInteger selectedImage;  //点击的是哪个 图片按钮    11 22 33 还有其他   0
@property(nonatomic,strong)NSMutableArray*saveFooterUrlArray;//编辑界面  保存的底部的图片
@property(nonatomic,strong)NSMutableDictionary*saveFooterImageDataDic; //保存 3张图片的data   11  22  33  key
//通过跟进id  获取到的最全的数据  包含A41500id
@property(nonatomic,strong)CustomerFollowDetailModel*DatasMainModel;
@property (nonatomic, strong) NSString *nowDateStr;
/** <#注释#>*/
@property(nonatomic,strong) NSString *followId;

#pragma mark 语音
//不带界面的识别对象
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;
/** <#备注#>*/
@property (nonatomic, assign) BOOL isNORecord;
/** 录音数组*/
@property (nonatomic, strong) NSMutableArray *recordArray;
/** 语音背景*/
@property (nonatomic, strong) UIView *voiceView;
/** 语音背景*/
@property (nonatomic, strong) UIView *voiceImagge;
/** 备注长按*/
@property (nonatomic, strong) UILongPressGestureRecognizer *remarkLongGR;
/** 明日计划长按*/
@property (nonatomic, strong) UILongPressGestureRecognizer *mrLongGR;
/** 备注*/
@property (nonatomic, strong) NSString *remarkStr;
/** 明日计划*/
@property (nonatomic, strong) NSString *mrStr;
/** <#备注#>*/
@property (nonatomic, copy) void(^recordBlock)(NSString *str);
/** (MJKPhotoView *)tableFootPhoto*/
@property (nonatomic, strong) MJKPhotoView *tableFootPhoto;
/** image url array*/
@property (nonatomic, strong) NSArray *imageUrlArray;
@end

@implementation AssistFollowViewController

- (void)viewDidLoad {
	//    self.view.backgroundColor=DBColor(239, 239, 244);
	self.view.backgroundColor=[UIColor whiteColor];
	
	[super viewDidLoad];
	[self localDatas];
	self.nowDateStr = [self nowDate];
	
	if (self.Type==AssistFollowUpAdd) {
		self.title=@"协助跟进添加";
		[[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:@"isBack"];
	}else{
		
		if (self.canEdit) {
			//能编辑
			self.title=@"协助跟进编辑";
			
		}else{
			//不能编辑
			//            self.tableView.userInteractionEnabled=NO;
			self.title=@"协助跟进详情";
			
			
		}
		
		[self httpPostGetBeforeDatas];
	}
	
    self.followId = [DBObjectTools getVustomerFollowC_id];
	
	[self.view addSubview:self.tableView];
	[self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
	[self.tableView registerNib:[UINib nibWithNibName:CELL1 bundle:nil] forCellReuseIdentifier:CELL1];
	[self.tableView registerNib:[UINib nibWithNibName:CELL2 bundle:nil] forCellReuseIdentifier:CELL2];
	[self.tableView registerNib:[UINib nibWithNibName:zhanbaiCELL bundle:nil] forCellReuseIdentifier:zhanbaiCELL];
	
	
	
	if (self.Type==AssistFollowUpEdit&&!self.canEdit) {
		
	}else{
		[self addCommitButton];
	}
	
	[self startIFly];
	[self voiceBgView];
	
}
- (NSString *)nowDate {
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *str = [dateFormatter stringFromDate:nowDate];
    return str;
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
	if (@available(iOS 11.0,*)) {
		self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
	}else{
		
		
		self.automaticallyAdjustsScrollViewInsets=NO;
	}
//	if ([self.assitStr isEqualToString:@"协助"]) {
//		[[NSUserDefaults standardUserDefaults] setObject:@"协助" forKey:@"VCName"];
//	}
}

#pragma mark  --UI
-(void)addCommitButton{
	UIButton*commitButton=[[UIButton alloc]initWithFrame:CGRectMake(10, KScreenHeight-50, KScreenWidth-20, 40)];
	commitButton.layer.cornerRadius=5;
	commitButton.layer.masksToBounds=YES;
	
	commitButton.backgroundColor=KNaviColor;
	[commitButton setTitleNormal:@"提交"];
	[commitButton setTitleColor:[UIColor blackColor]];
	[commitButton addTarget:self action:@selector(clickCommitButton:)];
	[self.view addSubview:commitButton];
	
	
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//	CustomerFollowModel*model=self.saveAllModelArray[4];
//	if ([model.showStr isEqualToString:@"是"]) {
//		return self.saveAllModelArray.count-1;
//	}
	
	return self.saveAllModelArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
	if (!cell) {
		cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
	}
	
	DBSelf(weakSelf);
	CustomerFollowModel*model=self.saveAllModelArray[indexPath.row];
	
	if (indexPath.row==0) {
		//
		AddCustomerInputTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
		cell.nameTitleLabel.text=model.titleStr;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.inputRightValue.constant = 26 + 20;
		cell.followImage.hidden = NO;
		//        cell.inputTextField.userInteractionEnabled=NO;
		cell.inputTextField.text=model.showStr;
        cell.inputTextField.enabled = NO;
		
		
		
		return cell;
	}else if (indexPath.row==1){
		
		AddCustomerProductTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL1];
		[cell.scanfButton setBackgroundImage:[UIImage imageNamed:@"语音搜索大按钮"] forState:UIControlStateNormal];
		if (self.canEdit == NO && self.Type == AssistFollowUpEdit) {
			cell.textView.editable = NO;
			cell.scanfButton.enabled = NO;
		}
		//跟进内容*
		NSMutableAttributedString*firstWord=[[NSMutableAttributedString alloc]initWithString:@"跟进内容" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
		NSMutableAttributedString*secondWord=[[NSMutableAttributedString alloc]initWithString:@"*" attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
		[firstWord appendAttributedString:secondWord];
		cell.topTitleLabel.attributedText=firstWord;
		
		cell.textViewStr=model.showStr;
		
		cell.textViewChangeBlock = ^(NSString *currentStr) {
			model.showStr=currentStr;
			model.postStr=currentStr;
			
		};
		
		__weak typeof (cell)weakCell=cell;
		cell.clickSanfBlock = ^{
//			MyLog(@"点击语音按钮");
//			MJKVoiceCViewController *voiceVC = [[MJKVoiceCViewController alloc]initWithNibName:@"MJKVoiceCViewController" bundle:nil];
//			[voiceVC setBackStrBlock:^(NSString *str){
//				if (str.length>0) {
//					weakCell.textViewStr=str;
//
//
//				}
//			}];
//			[weakSelf presentViewController:voiceVC animated:YES completion:nil];
			self.recordBlock = ^(NSString *str) {
				weakCell.textViewStr = [weakCell.textViewStr stringByAppendingString:str];
				[weakSelf.tableView reloadData];
			};
			
			self.isNORecord = NO;
			self.voiceView.hidden = NO;
			self.voiceImagge.hidden = NO;
			[_iFlySpeechRecognizer startListening];
			
			
			
		};
		
		
		return cell;
	} else if (indexPath.row==2){
		AddCustomerChooseTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL2];
		cell.nameTitleLabel.text=model.titleStr;
		if (model.showStr&&![model.showStr isEqualToString:@""]) {
			cell.textStr=model.showStr;
		}else{
			cell.textStr=nil;
		}
		if (self.canEdit == NO && self.Type == AssistFollowUpEdit) {
			cell.chooseTextField.enabled = NO;
		}
		cell.Type=ChooseTableViewTypeAllTime;
		cell.chooseBlock = ^(NSString *str, NSString *postValue) {
			MyLog(@"str-- %@      post---%@",str,postValue);
            NSInteger result = [weakSelf compareDate:weakSelf.nowDateStr withDate:str];
            if (result == 1) {
                [JRToast showWithText:@"实际跟进时间不能大于今天"];
            } else {
			model.showStr=str;
			model.postStr=str;
			
			[weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
//			CustomerFollowModel*dateModel=weakSelf.saveAllModelArray[2];
//			//得到跟进的值 并刷新
//			[weakSelf getLaterTimerWithLevel:dateModel.showStr andCustomTime:model.showStr];
			
			
		};
		
		
		
		
		return cell;
		
	} else if (indexPath.row == 3) {
		AddCustomerChooseTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL2];
		cell.nameTitleLabel.text = model.titleStr;
		if (model.showStr&&![model.showStr isEqualToString:@""]) {
			cell.textStr=model.showStr;
		}else{
			cell.textStr=nil;
		}
		cell.Type = ChooseTableViewTypeStage;
		cell.chooseBlock = ^(NSString *str, NSString *postValue) {
			MyLog(@"str-- %@      post---%@",str,postValue);
			model.showStr=str;
			model.postStr=postValue;
			
			[weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
		};
		if (self.canEdit == NO  && self.Type == AssistFollowUpEdit) {
			cell.chooseTextField.enabled = NO;
		}
		return cell;
	}
	return cell;
}


-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
	DBSelf(weakSelf);
	//    if (self.footerImageView) {
	//        return self.footerImageView;
	//    }
	
	if (self.Type==AssistFollowUpAdd) {
		self.tableFootPhoto.isEdit = YES;
	} else if (self.Type==AssistFollowUpEdit)  {
		self.tableFootPhoto.isEdit = YES;
	} else {
		self.tableFootPhoto.isEdit = NO;
	}
	self.tableFootPhoto.imageURLArray = self.DatasMainModel.urlList;
	return self.tableFootPhoto;
	/*CGCOrderDetialFooter*footer=[[NSBundle mainBundle]loadNibNamed:@"CGCOrderDetialFooter" owner:nil options:nil].firstObject;
	footer.beforeImageArray=self.saveFooterUrlArray;
    if (self.Type==AssistFollowUpAdd) {
        footer.isDetail = NO;
    } else
	if (self.Type==AssistFollowUpEdit ) {
		if (self.canEdit == YES) {
			footer.isDetail = NO;
		} else {
			footer.isDetail = YES;
		}
		
	} else  {
		footer.isDetail = YES;
	}
	if (self.canEdit == NO && self.Type == AssistFollowUpEdit) {
		footer.deleteOneButton.hidden = footer.deleteSecondButton.hidden = footer.deleteThirdButton.hidden = YES;
	}
	footer.frame=CGRectMake(0, 0, KScreenWidth, 150);
	self.footerImageView=footer;
	footer.clickFirstBlock = ^(UIImage*image){
		if (!image) {
			self.selectedImage=11;
			[weakSelf TouchAddImage];
			
		}else{
			//放大图片
			KSPhotoItem *item = [KSPhotoItem itemWithSourceView:weakSelf.footerImageView.firstPicBtn.imageView image:image];
			KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:@[item] selectedIndex:0];
			[browser showFromViewController:self];
			
			
		}
		
	};
	
	footer.clickSecondBlock = ^(UIImage*image){
		if (!image) {
			self.selectedImage=22;
			[weakSelf TouchAddImage];
			
		}else{
			//放大图片
			KSPhotoItem *item = [KSPhotoItem itemWithSourceView:weakSelf.footerImageView.secondPicBtn.imageView image:image];
			KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:@[item] selectedIndex:0];
			[browser showFromViewController:self];
			
			
			
		}
		
		
		
	};
	
	footer.clickThirdBlock = ^(UIImage*image){
		if (!image) {
			self.selectedImage=33;
			[weakSelf TouchAddImage];
			
		}else{
			//放大图片
			KSPhotoItem *item = [KSPhotoItem itemWithSourceView:weakSelf.footerImageView.thirdPicBtn.imageView image:image];
			KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:@[item] selectedIndex:0];
			[browser showFromViewController:self];
			
		}
		
		
	};
	
	
	
	
	
	//删除图片
	footer.deleteFirstBlock = ^{
		[self.saveFooterImageDataDic removeObjectForKey:@"11"];
		if (self.saveFooterUrlArray.count>=1) {
			[self.saveFooterUrlArray replaceObjectAtIndex:0 withObject:@"xxx"];
		}
		
		
	};
	
	footer.deleteSecondBlock = ^{
		[self.saveFooterImageDataDic removeObjectForKey:@"22"];
		if (self.saveFooterUrlArray.count>=2) {
			[self.saveFooterUrlArray replaceObjectAtIndex:1 withObject:@"xxx"];
		}
		
	};
	
	footer.deleteThirdBlock = ^{
		[self.saveFooterImageDataDic removeObjectForKey:@"33"];
		if (self.saveFooterUrlArray.count>=3) {
			[self.saveFooterUrlArray replaceObjectAtIndex:2 withObject:@"xxx"];
		}
		
	};
	
	
	
	
	return footer;*/
	
	
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	return 150;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.row==1) {
		return 120;
	}
	return 44;
	
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self showCustomerDetail];
    }
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



#pragma mark  --touch
-(void)showCustomerDetail{
	CustomerDetailViewController*vc=[[CustomerDetailViewController alloc]init];
	//客户详情里输入框下面弹框内容，如果是协助就只有新增预约
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VCName"];
	PotentailCustomerListDetailModel*model=[[PotentailCustomerListDetailModel alloc]init];
	if (self.infoModel.C_ID.length>0) {
		model.C_A41500_C_ID=self.infoModel.C_ID;
	}else if (self.DatasMainModel.C_A41500_C_ID.length>0){
		model.C_A41500_C_ID=self.DatasMainModel.C_A41500_C_ID;
	}else{
		model.C_A41500_C_ID=@"";
	}
	
	model.C_STATUS_DD_NAME=@"反正不是战败";
	vc.mainModel=model;
	[self.navigationController pushViewController:vc animated:YES];
	
}


//-(void)touchSwitch:(UISwitch*)ThisSwitch{
//   BOOL isOn=[ThisSwitch isOn];
//    if (isOn) {
//        //开
//        self.switchLabel.text=@"是";
//    }else{
//        //关
//        self.switchLabel.text=@"否";
//    }
//
//    CustomerFollowModel*model=self.saveAllModelArray[4];
//    model.showStr=self.switchLabel.text;
//    model.postStr=self.switchLabel.text;
//
//    [self.tableView reloadData];
//
//}


-(void)clickCommitButton:(UIButton*)button{
	DBSelf(weakSelf);
	
	//判断是否能被提交
	NSString*judgeStr= [self judgeCanSave];
	if (!_canSave) {
		[JRToast showWithText:judgeStr];
		return;
	}
	
	
		//传图片 和 提交跟进 两个接口
		[weakSelf firstPostImageAndNextInsertCustomerFollow];
		
	if (self.successBlock) {
		self.successBlock();
	}
		
		
		

	
	
	
	
	
}




//传图片 和 提交跟进 两个接口
-(void)firstPostImageAndNextInsertCustomerFollow{
	DBSelf(weakSelf);
	switch (self.Type) {
		case AssistFollowUpAdd:{
			//footer 上传图片 返回地址
//			[self httpPostArrayImage:self.saveFooterImageDataDic compliete:^(NSArray *arrayImg) {
//				NSString*X_PICURLStr=[arrayImg componentsJoinedByString:@","];
				//新增潜客
				[self httpPostFollowWithPhotoStr:self.imageUrlArray success:^(id data) {
					MyLog(@"%@",data);
					[JRToast showWithText:data[@"message"]];
					if (self.completeBlock) {
						self.completeBlock();
						return ;
					}
					for (UIViewController*vc in self.navigationController.viewControllers) {
						if ([vc isKindOfClass:[self.vcSuper class]]) {
							if ([self.delegate respondsToSelector:@selector(DelegateCompletePopToDo)]) {
								[self.delegate DelegateCompletePopToDo];
							}
							[self.navigationController popToViewController:self.vcSuper animated:YES];
							
							
							return ;
						}
					}
					
					if ([self.delegate respondsToSelector:@selector(DelegateCompletePopToDo)]) {
						[self.delegate DelegateCompletePopToDo];
					}
					[self.navigationController popViewControllerAnimated:YES];
					
					
					
				}];
				
				
				
				
//			}];
			
			
			
			break;}
		case AssistFollowUpEdit:{
			//编辑潜客
//			[self httpPostArrayImage:self.saveFooterImageDataDic compliete:^(NSArray *arrayImg) {
//				[self.saveFooterUrlArray removeObject:@"xxx"];
//				[self.saveFooterUrlArray addObjectsFromArray:arrayImg];
//				NSString*X_PICURLStr=[self.saveFooterUrlArray componentsJoinedByString:@","];
				//新增潜客
				[weakSelf httpPostEditFollowWithPhotoStr:self.imageUrlArray success:^(id data) {
					MyLog(@"%@",data);
					[JRToast showWithText:data[@"data"][@"message"]];
					
					for (UIViewController*vc in self.navigationController.viewControllers) {
						if ([vc isKindOfClass:[self.vcSuper class]]) {
							if ([self.delegate respondsToSelector:@selector(DelegateCompletePopToDo)]) {
								[self.delegate DelegateCompletePopToDo];
							}
							[self.navigationController popToViewController:self.vcSuper animated:YES];
							
							return ;
						}
					}
					
					if ([self.delegate respondsToSelector:@selector(DelegateCompletePopToDo)]) {
						[self.delegate DelegateCompletePopToDo];
					}
					
					[self.navigationController popViewControllerAnimated:YES];
					
					
				}];
				
//			}];
			
			
			
			break;}
			
			
		default:
			break;
	}
	
	
	
	
	
	
}



#pragma mark  -- delegate
//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
	//    定义一个newPhoto，用来存放我们选择的图片。
	UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
	if (!newPhoto) {
		newPhoto=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
	}
	//    NSData*data=UIImagePNGRepresentation(newPhoto);
	NSData *data = UIImageJPEGRepresentation(newPhoto, 0.5);
	
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
		//        [self.self.footerImageView.secondPicBtn setImage:newPhoto forState:UIControlStateNormal];
		self.footerImageView.secondImg=newPhoto;
		if (self.saveFooterUrlArray.count>=2) {
			[self.saveFooterUrlArray replaceObjectAtIndex:1 withObject:@"xxx"];
		}
		
		
	}else if (self.selectedImage==33){
		//footer 第三张图
		[self.saveFooterImageDataDic setObject:data forKey:@"33"];
		//        [self.self.footerImageView.thirdPicBtn setImage:newPhoto forState:UIControlStateNormal];
		self.footerImageView.thirdImg=newPhoto;
		if (self.saveFooterUrlArray.count>=3) {
			[self.saveFooterUrlArray replaceObjectAtIndex:2 withObject:@"xxx"];
		}
		
	}
	
	
	
	
	[self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark  --datas
//编辑跟进
-(void)httpPostEditFollowWithPhotoStr:(NSArray*)imageArray  success:(void(^)(id data))successBlock{
	
	NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
	if (self.objectID) {
		[contentDict setObject:self.objectID forKey:@"C_ID"];
	}else{
		[JRToast showWithText:@"编辑的跟进id 居然没有？？？"];
	}
	if (!self.infoModel.C_ID||[self.infoModel.C_ID isEqualToString:@""]) {
		[JRToast showWithText:@"客户c_id 不能为空"];
		return;
	}
	[contentDict setObject:self.infoModel.C_ID forKey:@"C_A41500_C_ID"];
	
	if (self.infoModel.C_HEADIMGURL) {
		[contentDict setObject:self.infoModel.C_HEADIMGURL forKey:@"C_HEADIMGURL"];
	}
	
	[contentDict setObject:@"A41600_C_TYPE_0007" forKey:@"C_TYPE_DD_ID"];
	
//	if (X_PICURL&&![X_PICURL isEqualToString:@""]) {
//		[contentDict setObject:X_PICURL forKey:@"X_PICURL"];
//	}
	if (imageArray.count > 0) {
		contentDict[@"urlList"] = imageArray;
	}
	for (CustomerFollowModel*model in self.saveAllModelArray) {
		//这个不要
		if ([model.titleStr isEqualToString:@"是否战败"]) {
			continue;
		}
		
		[contentDict setObject:model.postStr forKey:model.keyStr];
		
		
	}
	
	HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a416/edit", HTTP_IP] parameters:contentDict compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			
			successBlock(data);
		}else{
			[JRToast showWithText:data[@"msg"]];
		}
		
		
	}];
	
	
	
	
	
}





//新增跟进
-(void)httpPostFollowWithPhotoStr:(NSArray*)imageArray success:(void(^)(id data))successBlock{
	NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:HTTP_FollowInsert];
	NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
	[contentDict setObject:self.followId forKey:@"C_ID"];
	if (!self.infoModel.C_ID||[self.infoModel.C_ID isEqualToString:@""]) {
		[JRToast showWithText:@"客户c_id 不能为空"];
		return;
	}
	[contentDict setObject:self.infoModel.C_ID forKey:@"C_A41500_C_ID"];
	
	if (self.infoModel.C_HEADIMGURL) {
		[contentDict setObject:self.infoModel.C_HEADIMGURL forKey:@"C_HEADIMGURL"];
	}
//	if (X_PICURL&&![X_PICURL isEqualToString:@""]) {
//		[contentDict setObject:X_PICURL forKey:@"X_PICURL"];
//	}
	if (imageArray.count > 0) {
		contentDict[@"urlList"] = imageArray;
	}
	[contentDict setObject:@"A41600_C_TYPE_0007" forKey:@"C_TYPE_DD_ID"];
	
	
	
	for (CustomerFollowModel*model in self.saveAllModelArray) {
		//这个不要
		if ([model.titleStr isEqualToString:@"是否战败"]) {
			continue;
		}
		
		[contentDict setObject:model.postStr forKey:model.keyStr];
		
		
	}
	
	
	if (self.recordID&&![self.recordID isEqualToString:@""]) {
		[contentDict setObject:self.recordID forKey:@"C_A45000_C_ID"];
	}
	
	
	[mainDict setObject:contentDict forKey:@"content"];
	NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			
			successBlock(data);
		}else{
			[JRToast showWithText:data[@"message"]];
		}
		
		
	}];
	
	
	
	
	
}

//意向等级对应的潜客跟进时间
-(void)httpPostGetFollowTimeList{
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/masterdata/a411/list", HTTP_IP] parameters:@{} compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		
		if ([data[@"code"] integerValue]==200) {
			self.saveTimeNumberArray=[NSMutableArray array];
			for (NSDictionary*dict in data[@"data"][@"list"]) {
				CustomerLvevelNextFollowModel*model=[CustomerLvevelNextFollowModel yy_modelWithDictionary:dict];
				[self.saveTimeNumberArray addObject:model];
				
				
			}
			
			//这个是当前的时间
//			CustomerFollowModel*dateModel=weakSelf.saveAllModelArray[2];
//			//通过等级  计算出延迟的时间
//			[weakSelf getLaterTimerWithLevel:self.infoModel.C_LEVEL_DD_NAME andCustomTime:dateModel.showStr];
			
			
			
			
			
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



//编辑跟进的时候     通过objectID 获取数据
-(void)httpPostGetBeforeDatas{
	HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/crm/a416/info", HTTP_IP] parameters:@{@"C_A41600_C_ID":self.objectID} compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			CustomerFollowDetailModel*model=[CustomerFollowDetailModel yy_modelWithDictionary:data[@"data"]];
			self.DatasMainModel=model;
			
			//x_picurl=@“”   会给mtarray 第一个赋值 @“”
			if (model.X_PICURL&&![model.X_PICURL isEqualToString:@""]) {
				self.saveFooterUrlArray=[[model.X_PICURL componentsSeparatedByString:@","] mutableCopy];
			}
			
			
			NSArray*showArray=@[model.C_A41500_C_NAME,model.X_REMARK,model.D_FOLLOW_TIME];
			NSArray*postArray=@[model.C_A41500_C_NAME,model.X_REMARK,model.D_FOLLOW_TIME];
			
			
			for (int i=0; i<showArray.count; i++) {
				CustomerFollowModel*Mmodel=self.saveAllModelArray[i];
				Mmodel.showStr=showArray[i];
				Mmodel.postStr=postArray[i];
			}
			
			
			[self.tableView reloadData];
			
			
			
		}else{
			[JRToast showWithText:data[@"msg"]];
		}
		
	}];
	
	
}


-(void)localDatas{
#pragma 提交的时候  是否战败 这个字段不传。  但是要判断是否需要战败
	self.followText=self.followText?self.followText:@"";
	
	//    NSMutableAttributedString*firstWord=[[NSMutableAttributedString alloc]initWithString:@"跟进内容" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
	//    NSMutableAttributedString*secondWord=[[NSMutableAttributedString alloc]initWithString:@"*" attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
	//    [firstWord appendAttributedString:secondWord];
	
	NSArray*titleArray=@[@"客户姓名",@"跟进内容",@"实际跟进时间",@"客户阶段"];
	NSArray*showArray=@[self.infoModel.C_NAME?self.infoModel.C_NAME:@"",self.followText,[DBTools getTimeFomatFromCurrentTimeStamp],self.infoModel.C_STAGE_DD_NAME.length > 0 ? self.infoModel.C_STAGE_DD_NAME : @""];
	NSArray*postArray=@[self.infoModel.C_NAME?self.infoModel.C_NAME:@"",self.followText,showArray[2],self.infoModel.C_STAGE_DD_ID.length > 0 ? self.infoModel.C_STAGE_DD_ID : @""];
	NSArray*keyArray=@[@"C_A41500_C_NAME",@"X_REMARK",@"D_FOLLOW_TIME",@"C_STAGE_DD_ID"];
	for (int i=0; i<titleArray.count; i++) {
		CustomerFollowModel*model=[[CustomerFollowModel alloc]init];
		model.titleStr=titleArray[i];
		model.showStr=showArray[i];
		model.postStr=postArray[i];
		model.keyStr=keyArray[i];
		
		[self.saveAllModelArray addObject:model];
	}
	
	
	if (self.Type==AssistFollowUpAdd) {
		//给下次跟进赋值   再刷新
		[self httpPostGetFollowTimeList];
		
	}
	
	
	
	
	
	
	
	
	
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
		_tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight-50 - NavStatusHeight - WD_TabBarHeight) style:UITableViewStyleGrouped];
		_tableView.delegate=self;
		_tableView.dataSource=self;
		_tableView.backgroundColor=[UIColor whiteColor];
		if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
			[_tableView setSeparatorInset:UIEdgeInsetsZero];
		}
		
		if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
			[_tableView setLayoutMargins:UIEdgeInsetsZero];
		}
		
		_tableView.estimatedRowHeight=0;
		_tableView.estimatedSectionHeaderHeight=0;
		_tableView.estimatedSectionFooterHeight=0;
	}
	
	return _tableView;
}

-(NSMutableArray<CustomerFollowModel *> *)saveAllModelArray{
	if (!_saveAllModelArray) {
		_saveAllModelArray=[NSMutableArray array];
	}
	return _saveAllModelArray;
	
}

-(NSMutableDictionary *)saveFooterImageDataDic{
	if (!_saveFooterImageDataDic) {
		_saveFooterImageDataDic=[NSMutableDictionary dictionary];
	}
	return _saveFooterImageDataDic;
}


-(NSMutableArray *)saveFooterUrlArray{
	if (!_saveFooterUrlArray) {
		_saveFooterUrlArray=[NSMutableArray array];
	}
	return _saveFooterUrlArray;
}


#pragma mark  --funcation

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

//赋值并刷新    通过登记 来计算  下次跟进的时间。
-(void)getLaterTimerWithLevel:(NSString*)customLV andCustomTime:(NSString*)currentTime{
	DBSelf(weakSelf);
	for (CustomerLvevelNextFollowModel*TimerModel in self.saveTimeNumberArray) {
		
		if ([TimerModel.C_NAME isEqualToString:customLV]) {
			
			CustomerFollowModel*followModel=weakSelf.saveAllModelArray[5];
			
			
			NSInteger number=[TimerModel.I_NUMBER integerValue];
			NSString*lastTimer=[DBTools TimeCurrentTime:currentTime andlaterDay:number];
			
			
			//完成了之后 需要赋值给localDatas  再刷新
			followModel.showStr=lastTimer;
			followModel.postStr=lastTimer;
			[weakSelf.tableView reloadData];
			
			
			
		}
		
		
	}
	
}


-(NSString*)judgeCanSave{
	_canSave=YES;
	
	CustomerFollowModel*model=self.saveAllModelArray[1];
	if (!model.showStr||[model.showStr isEqualToString:@""]) {
		_canSave=NO;
		return @"跟进内容不能为空";
		
	}
	
	
	//    PotentailCustomerEditModel*model;
	//    model=self.localDatas[0][0];
	//    if (!model.nameValue||[model.nameValue isEqualToString:@""]) {
	//        _canSave=NO;
	//        return @"请输入姓名";
	//    }
	//
	//
	//    model=self.localDatas[0][3];
	//    if (!model.nameValue||[model.nameValue isEqualToString:@""]||model.nameValue.length!=11) {
	//        _canSave=NO;
	//        return @"请输入11位手机号码";
	//    }
	//
	//    model=self.localDatas[0][4];
	//    if (!model.nameValue||[model.nameValue isEqualToString:@""]) {
	//        _canSave=NO;
	//        return @"请选择客户等级";
	//    }
	
	
	
	return @"";
}




- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
	[[self findFirstResponderBeneathView:self.view] resignFirstResponder];
}

//touch began
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
	[[self findFirstResponderBeneathView:self.view] resignFirstResponder];
}


- (UIView*)findFirstResponderBeneathView:(UIView*)view
{
	// Search recursively for first responder
	for ( UIView *childView in view.subviews ) {
		if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] )
			return childView;
		UIView *result = [self findFirstResponderBeneathView:childView];
		if ( result )
			return result;
	}
	return nil;
}

#pragma mark - 语音
- (void)startIFly {
	//创建语音识别对象
	_iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
	//设置识别参数
	//设置为听写模式
	[_iFlySpeechRecognizer setParameter: @"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];
	//asr_audio_path 是录音文件名，设置value为nil或者为空取消保存，默认保存目录在Library/cache下。
	[_iFlySpeechRecognizer setParameter:@"iat.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
	_iFlySpeechRecognizer.delegate =self;
}

/*
 //需要实现IFlyRecognizerViewDelegate识别协议
 @interface IATViewController : UIViewController<IFlySpeechRecognizerDelegate>
 //不带界面的识别对象
 @property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;
 @end
 */


//IFlySpeechRecognizerDelegate协议实现
//识别结果返回代理
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast{
	NSLog(@"===========%@",results);
	NSMutableString *resultString = [[NSMutableString alloc] init];
	NSDictionary *dic = results[0];
	for (NSString *key in dic) {
		[resultString appendFormat:@"%@",key];
	}
	NSString * str =  [ISRDataHelper stringFromJson:resultString];
	NSLog(@"===========%@",str);
	[self.recordArray addObject:str];
	if (isLast) {
		//		 if (self.isNORecord == YES) {
		NSString *str1 = [self.recordArray componentsJoinedByString:@""];
		NSLog(@"++++++++++++%@",str1);
		if (self.recordBlock) {
			self.recordBlock(str1);
		}
		[self.recordArray removeAllObjects];
		self.isNORecord = YES;
		self.voiceView.hidden = YES;
		self.voiceImagge.hidden = YES;
		[_iFlySpeechRecognizer stopListening];
		
		//		 }
	}
}
//识别会话结束返回代理
- (void)onCompleted: (IFlySpeechError *) error{
	
}
//停止录音回调
- (void) onEndOfSpeech{
	//	 if (self.isNORecord == NO) {
	//		 [_iFlySpeechRecognizer startListening];
	//	 } else {
	//		 [_iFlySpeechRecognizer stopListening];
	//	 }
}
//开始录音回调
- (void) onBeginOfSpeech{
	
}
//音量回调函数
- (void) onVolumeChanged: (int)volume{
	
}
//会话取消回调
- (void) onCancel{
	
}

- (void)voiceBgView {
	UIView *voiceView = [[UIView alloc]initWithFrame:self.view.frame];
	self.voiceView = voiceView;
	voiceView.hidden = YES;
	voiceView.backgroundColor = [UIColor blackColor];
	voiceView.alpha = .5f;
	[[UIApplication sharedApplication].keyWindow addSubview:voiceView];
	UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake((KScreenWidth - 100) / 2, (KScreenHeight - 130) / 2, 130, 130)];
	bgView.hidden = YES;
	self.voiceImagge = bgView;
	UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
	imageView.image = [UIImage imageNamed:@"语音搜索大按钮"];
	[bgView addSubview:imageView];
	UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), 100, 30)];
	label.text = @"我们正在倾听你的对话...";
	label.font = [UIFont systemFontOfSize:14.f];
	label.textColor = [UIColor whiteColor];
	[bgView addSubview:label];
	[[UIApplication sharedApplication].keyWindow addSubview:bgView];
}

- (NSMutableArray *)recordArray {
	if (!_recordArray) {
		_recordArray = [NSMutableArray array];
	}
	return _recordArray;
}

@end
