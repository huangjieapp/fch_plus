//
//  MJKOrderFllowViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/1/18.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKOrderFllowViewController.h"
#import "AddCustomerProductTableViewCell.h"
#import "AddCustomerInputTableViewCell.h"
#import "AddCustomerChooseTableViewCell.h"
#import "ZhanbaiChooseTableViewCell.h"
#import "CGCOrderDetialFooter.h"   //view
#import "MJKPhotoView.h"
#import "CGCAlertDateView.h"
#import "KSPhotoBrowser.h"

#import "CustomerFollowModel.h"
#import "CustomerLvevelNextFollowModel.h"
#import "CustomerFollowDetailModel.h"

#import "CustomerDetailInfoModel.h"

#import "VideoAndImageModel.h"

#import "iflyMSC/IFlyMSC.h"
#import "ISRDataHelper.h"

#import "VoiceView.h"


#import "MJKVoiceCViewController.h"
#import "CustomerDetailViewController.h"
#import "OrderDetailViewController.h"

#define CELL0   @"AddCustomerInputTableViewCell"
#define CELL1   @"AddCustomerProductTableViewCell"
#define CELL2   @"AddCustomerChooseTableViewCell"
#define zhanbaiCELL    @"ZhanbaiChooseTableViewCell"

@interface MJKOrderFllowViewController ()<UITableViewDataSource, UITableViewDelegate,IFlySpeechRecognizerDelegate>
@property (nonatomic, strong) UITableView *tableView;
//@property(nonatomic,strong)UITableView*tableView;
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

@property (nonatomic, strong) NSString *nextTime;
@property (nonatomic, strong) NSString *nowDateStr;
@property (nonatomic, strong) NSMutableArray *imageArr;
@property (nonatomic, strong) NSString *followId;

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
/** <#备注#>*/
@property (nonatomic, strong) VoiceView *vv;
/** (MJKPhotoView *)tableFootPhoto*/
@property (nonatomic, strong) MJKPhotoView *tableFootPhoto;
/** image url array*/
@property (nonatomic, strong) NSMutableArray *imageUrlArray;
@end

@implementation MJKOrderFllowViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	if (@available(iOS 11.0, *)) {
		self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}else {
		self.automaticallyAdjustsScrollViewInsets = NO;
	}
	//    self.view.backgroundColor=DBColor(239, 239, 244);
	self.view.backgroundColor=[UIColor whiteColor];
	[self localDatas];
	self.nowDateStr = [self nowDate];
	
	
	if ([self.isDetail isEqualToString:@"编辑"]) {
		self.title = @"订单跟进编辑";
		[self httpPostGetBeforeDatas];
	} else if ([self.isDetail isEqualToString:@"详情"]) {
		self.title = @"订单跟进详情";
		[self httpPostGetBeforeDatas];
	} else {
		self.title=@"订单跟进添加";
        [self getLaterTimer];
	}
	
    self.followId = [DBObjectTools getVustomerFollowC_id];
	
	[self.view addSubview:self.tableView];
	[self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
	[self.tableView registerNib:[UINib nibWithNibName:CELL1 bundle:nil] forCellReuseIdentifier:CELL1];
	[self.tableView registerNib:[UINib nibWithNibName:CELL2 bundle:nil] forCellReuseIdentifier:CELL2];
	[self.tableView registerNib:[UINib nibWithNibName:zhanbaiCELL bundle:nil] forCellReuseIdentifier:zhanbaiCELL];
	
	[self addCommitButton];
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
	if (self.canEdit != NO) {
		[self.view addSubview:commitButton];
	}
	
	
	
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	
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
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.inputRightValue.constant = 26 + 20;
		cell.followImage.hidden = NO;
		cell.nameTitleLabel.text=model.titleStr;
//		if ([self.isDetail isEqualToString:@"详情"]) {
//			cell.inputTextField.enabled = NO;
//		}
		
		//        cell.inputTextField.userInteractionEnabled=NO;
		cell.inputTextField.text=model.showStr;
        cell.inputTextField.enabled = NO;
		
		
		
		
		return cell;
	}else if (indexPath.row==1){
		
		AddCustomerProductTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL1];
		[cell.scanfButton setBackgroundImage:[UIImage imageNamed:@"语音搜索大按钮"] forState:UIControlStateNormal];
		if ([self.isDetail isEqualToString:@"详情"]) {
			cell.textView.editable = NO;
			cell.scanfButton.hidden = YES;
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
			
			self.vv = [[VoiceView alloc]initWithFrame:self.view.frame];
			//	[[UIApplication sharedApplication].keyWindow addSubview:self.vv];
			[self.view addSubview:self.vv];
			self.vv.recordBlock = ^(NSString *str) {
				weakCell.textViewStr = [weakCell.textViewStr stringByAppendingString:str];
				[weakSelf.tableView reloadData];
			};
//
//			self.isNORecord = NO;
//			self.voiceView.hidden = NO;
//			self.voiceImagge.hidden = NO;
//			[_iFlySpeechRecognizer startListening];
			
			[self.vv start];
		};
		
		
		return cell;
	}else if (indexPath.row==2){
		AddCustomerChooseTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL2];
		if ([self.isDetail isEqualToString:@"详情"]) {
			cell.chooseTextField.enabled = NO;
		}
		cell.nameTitleLabel.text=model.titleStr;
		if (model.showStr&&![model.showStr isEqualToString:@""]) {
			cell.textStr=model.showStr;
		}else{
			cell.textStr=nil;
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
			
			//得到跟进的值 并刷新
			
			
			
		};
		
		
		
		
		return cell;
		
	}else if (indexPath.row==3){
		
		AddCustomerChooseTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL2];
		cell.nameTitleLabel.text=model.titleStr;
		if ([self.isDetail isEqualToString:@"详情"]) {
			cell.chooseTextField.enabled = NO;
		}
		if (model.showStr&&![model.showStr isEqualToString:@""]) {
			cell.textStr=model.showStr;
		}else{
			cell.textStr=nil;
		}
		
		cell.Type=ChooseTableViewTypeAllTime;
		cell.chooseBlock = ^(NSString *str, NSString *postValue) {
			MyLog(@"str-- %@      post---%@",str,postValue);
			
			CustomerFollowModel*dateModel=weakSelf.saveAllModelArray[2];
			NSInteger result1 = [weakSelf compareDate:model.showStr withDate:str];
			NSInteger result = [weakSelf compareDate:dateModel.showStr withDate:str];
			if (result == -1 || result1 == 1) {
				[JRToast showWithText:@"下次跟进时间不在有效范围内"];
			} else {
				model.showStr=str;
				model.postStr=str;
				
				[weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
			}
			
		};
		
		
		
		return cell;
		
	}
	return cell;
}


-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
	DBSelf(weakSelf);
	//    if (self.footerImageView) {
	//        return self.footerImageView;
	//    }
	if ([self.isDetail isEqualToString:@"详情"])  {
		self.tableFootPhoto.isEdit = NO;
	}
    if (self.DatasMainModel.fileList.count > 0) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dic in self.DatasMainModel.fileList) {
            [arr addObject:dic[@"url"]];
        }
        self.tableFootPhoto.imageURLArray = arr;
    }
//	self.tableFootPhoto.imageURLArray = self.DatasMainModel.urlList;
	return self.tableFootPhoto;
	
	/*CGCOrderDetialFooter*footer=[[NSBundle mainBundle]loadNibNamed:@"CGCOrderDetialFooter" owner:nil options:nil].firstObject;
	footer.beforeImageArray=self.saveFooterUrlArray;
	
	footer.frame=CGRectMake(0, 0, KScreenWidth, 150);
	self.footerImageView=footer;
	if ([self.isDetail isEqualToString:@"详情"]) {
        footer.isDetail = YES;
		footer.firstPicBtn.enabled = footer.secondPicBtn.enabled  = footer.thirdPicBtn.enabled = YES;
        footer.deleteOneButton.hidden = footer.deleteThirdButton.hidden = footer.deleteSecondButton.hidden = YES;
	}
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
	return 160;
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
		_tableFootPhoto = [[MJKPhotoView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 160)];
		_tableFootPhoto.isEdit = YES;
        if ([self.isDetail isEqualToString:@"详情"]) {
            _tableFootPhoto.isEdit = NO;
        }
		_tableFootPhoto.isCamera = NO;
		_tableFootPhoto.rootVC = self;
		_tableFootPhoto.backUrlArray = ^(NSArray *arr, NSArray *saveArr) {
            [weakSelf.imageUrlArray removeAllObjects];
            for (int i = 0; i < arr.count; i++) {
                VideoAndImageModel *model = [[VideoAndImageModel alloc]init];
                model.url = arr[i];
                model.saveUrl = saveArr[i];
                [weakSelf.imageUrlArray addObject:model];
            }

		};
	}
	return _tableFootPhoto;
}



#pragma mark  --touch
-(void)showCustomerDetail{
//	OrderDetailViewController*vc=[[OrderDetailViewController alloc]init];
	//客户详情里输入框下面弹框内容，如果是协助就只有新增预约
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VCName"];
    PotentailCustomerListDetailModel*model=[[PotentailCustomerListDetailModel alloc]init];
	CustomerDetailViewController *vc = [[CustomerDetailViewController alloc]init];
//	if (self.infoModel.C_ID.length>0) {
//        model.C_A41500_C_ID=self.infoModel.C_ID;
//	}else if (self.DatasMainModel.C_A41500_C_ID.length>0){
        model.C_A41500_C_ID=self.DatasMainModel.C_A41500_C_ID;
//	}else{
//		model.C_A41500_C_ID=@"";
//	}
	
    model.C_STATUS_DD_NAME=@"反正不是战败";
    vc.mainModel=model;
//    vc.orderId = self.detailModel.C_ID;
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
	if ([self.isDetail isEqualToString:@"编辑"]) {
		[self httpPostEditFollowWithPhotoStr:self.imageUrlArray success:^(id data) {
			[weakSelf.navigationController popViewControllerAnimated:YES];
		}];
	} else {
		[self httpPostFollowWithPhotoStr:self.imageUrlArray success:^(id data) {
			if (weakSelf.backSubmitBlock) {
				weakSelf.backSubmitBlock();
			}
			[weakSelf.navigationController popViewControllerAnimated:YES];
		}];
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
	NSData*data=UIImageJPEGRepresentation(newPhoto, 0.5);
	
	//    //吊接口  照片
	//    UITableViewCell*cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	//    UIImageView*imageView=[cell viewWithTag:111];
	//    imageView.image=newPhoto;
	
	[self uppicAction:data];
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
	
	NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:@"ReservationWebService-updateOrderFollow"];
	NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
	if (self.objectID.length > 0) {
		[contentDict setObject:self.objectID forKey:@"C_ID"];
	}else{
		[JRToast showWithText:@"编辑的跟进id 居然没有？？？"];
		return;
	}
	if (self.detailModel.C_A41500_C_ID.length > 0) {
		[contentDict setObject:self.detailModel.C_A41500_C_ID forKey:@"C_A41500_C_ID"];
	} else {
		[JRToast showWithText:@"客户c_id 不能为空"];
		return;
	}
	
	if (self.orderID.length > 0) {
		[contentDict setObject:self.orderID forKey:@"C_A42000_C_ID"];
	}
//	[contentDict setObject:self.detailModel.C_A41500_C_ID forKey:@"C_A41500_C_ID"];
	
	if (self.detailModel.C_HEADIMGURL.length > 0) {
		[contentDict setObject:self.detailModel.C_HEADIMGURL forKey:@"C_HEADIMGURL"];
	}
	
	
//    if (self.imageArr.count > 0) {
////        NSString *imageStr = [self.imageArr componentsJoinedByString:@","];
//		[self.saveFooterUrlArray addObjectsFromArray:self.imageArr];
//        contentDict[@"urlList"] = self.saveFooterUrlArray;
//	} else {
//		if (self.saveFooterUrlArray.count > 0) {
//			[self.saveFooterUrlArray removeObject:@"xxx"];
//			contentDict[@"urlList"] = self.saveFooterUrlArray;
//
//		}
//	}
	if (imageArray.count > 0) {
		contentDict[@"urlList"] = imageArray;
	}
	
//	if (X_PICURL.length > 0) {
//		[contentDict setObject:X_PICURL forKey:@"X_PICURL"];
//	}
	
	for (CustomerFollowModel*model in self.saveAllModelArray) {
		//这个不要
		if ([model.titleStr isEqualToString:@"是否战败"]) {
			continue;
		}
		
		[contentDict setObject:model.postStr forKey:model.keyStr];
		
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





//新增跟进
-(void)httpPostFollowWithPhotoStr:(NSArray*)imageArray success:(void(^)(id data))successBlock{
	NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
	[contentDict setObject:self.followId forKey:@"C_ID"];
	if (self.detailModel.C_A41500_C_ID.length <= 0) {
		[JRToast showWithText:@"客户c_id 不能为空"];
		return;
	}
	[contentDict setObject:self.detailModel.C_A41500_C_ID forKey:@"C_A41500_C_ID"];
	
	for (int i = 1; i < self.saveAllModelArray.count; i++) {
		CustomerFollowModel*model = self.saveAllModelArray[i];
		contentDict[model.keyStr] = model.showStr;
	}
	contentDict[@"C_A42000_C_ID"] = self.detailModel.C_ID;
//	if (self.imageArr.count > 0) {
////		NSString *imageStr = [self.imageArr componentsJoinedByString:@","];
//		contentDict[@"urlList"] = self.imageArr;
//	}
//	if (imageArray.count > 0) {
//		contentDict[@"urlList"] = imageArray;
//	}
    if (imageArray.count > 0) {
        NSMutableArray *arr = [NSMutableArray array];
        for (VideoAndImageModel *model in imageArray) {
            [arr addObject:[model mj_keyValues]];
        }
        [contentDict setObject:arr forKey:@"fileList"];
    } else {
        [contentDict setObject:@[] forKey:@"fileList"];
    }
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postNewDataFromNetworkWithUrl:HTTP_AddOrderFollow parameters:contentDict compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			
			successBlock(data);
		}else{
			[JRToast showWithText:data[@"message"]];
		}
		
		
	}];
}




//上传多张照片  并完成

-(void)uppicAction:(NSData *)data{
	DBSelf(weakSelf);
	NSString *urlStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"ipImage"]];
	HttpManager *manager = [[HttpManager alloc]init];
	[manager postDataUpDataPhotoWithUrl:urlStr parameters:nil photo:data compliation:^(id data, NSError *error) {
		if ([data[@"code"] integerValue] == 200) {
			NSString * imgUrl = [data objectForKey:@"url"];//回传
			[weakSelf.imageArr addObject:imgUrl];
			
		} else {
			[JRToast showWithText:data[@"message"]];
		}
	}];
	
}

//编辑跟进的时候     通过objectID 获取数据
-(void)httpPostGetBeforeDatas{
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_ID"] = self.objectID;
	HttpManager*manager=[[HttpManager alloc]init];
	[manager getNewDataFromNetworkWithUrl:HTTP_FollowInfo parameters:contentDic compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			CustomerFollowDetailModel*model=[CustomerFollowDetailModel yy_modelWithDictionary:data[@"data"]];
			self.DatasMainModel=model;
			
			//x_picurl=@“”   会给mtarray 第一个赋值 @“”
//			if (model.urlList.count > 0) {
//				[self.saveFooterUrlArray addObjectsFromArray:model.urlList];
//			}
            if (model.fileList.count > 0) {
                NSMutableArray *arr = [NSMutableArray array];
                for (NSDictionary *dic in model.fileList) {
                    [arr addObject:dic[@"url"]];
                }
                [self.saveFooterUrlArray addObjectsFromArray:arr];
            }
			
            NSArray*showArray=@[model.C_A41500_C_NAME.length > 0 ? model.C_A41500_C_NAME : @"",
                                model.X_REMARK.length > 0 ? model.X_REMARK : @"",
                                model.D_FOLLOW_TIME.length > 0 ? model.D_FOLLOW_TIME : @"",
                                model.D_NEXTFOLLOW_TIME.length > 0 ? model.D_NEXTFOLLOW_TIME : @""];
			NSArray*postArray=@[model.C_A41500_C_NAME.length > 0 ? model.C_A41500_C_NAME : @"",
                                model.X_REMARK.length > 0 ? model.X_REMARK : @"",
                                model.D_FOLLOW_TIME.length > 0 ? model.D_FOLLOW_TIME : @"",
                                model.D_NEXTFOLLOW_TIME.length > 0 ? model.D_NEXTFOLLOW_TIME : @""];
			
			
			for (int i=0; i<showArray.count; i++) {
				CustomerFollowModel*Mmodel=self.saveAllModelArray[i];
				Mmodel.showStr=showArray[i];
				Mmodel.postStr=postArray[i];
			}
			
			
			[self.tableView reloadData];
			
			
			
		}else{
			[JRToast showWithText:data[@"message"]];
		}
		
	}];
	
	
}


-(void)localDatas{
	
	NSArray*titleArray=@[@"客户姓名",@"跟进内容",@"实际跟进时间",@"下次跟进时间"];
	NSArray*showArray=@[self.detailModel.C_A41500_C_NAME?self.detailModel.C_A41500_C_NAME:@"",self.followText.length > 0 ? self.followText : @"",[DBTools getTimeFomatFromCurrentTimeStamp],@""];
	NSArray*postArray=@[self.detailModel.C_A41500_C_NAME?self.detailModel.C_A41500_C_NAME:@"",@"",showArray[3],@""];
	NSArray*keyArray=@[@"C_A41500_C_NAME",@"X_REMARK",@"D_FOLLOW_TIME",@"D_NEXTFOLLOW_TIME"];
	for (int i=0; i<titleArray.count; i++) {
		CustomerFollowModel*model=[[CustomerFollowModel alloc]init];
		model.titleStr=titleArray[i];
		model.showStr=showArray[i];
		model.postStr=postArray[i];
		model.keyStr=keyArray[i];
		
		[self.saveAllModelArray addObject:model];
	}
}

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

- (NSMutableArray *)imageArr {
	if (!_imageArr) {
		_imageArr = [NSMutableArray array];
	}
	return _imageArr;
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
//赋值并刷新     计算  下次跟进的时间。
-(void)getLaterTimer {
	
	NSMutableDictionary *dic=[NSMutableDictionary new];
	dic[@"TYPE"] = @"0";
	
	
	HttpManager*manager=[[HttpManager alloc]init];
	
	DBSelf(weakSelf);
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/a475/list", HTTP_IP] parameters:dic compliation:^(id data, NSError *error) {
		[self.view addSubview:self.tableView];
		if ([data[@"code"] integerValue]==200) {
			NSDictionary*dict=[data copy];
			for (NSDictionary * div in dict[@"data"][@"content"]) {
				if ([div[@"C_NAME"] isEqualToString:self.detailModel.C_STATUS_DD_NAME]) {
				CustomerFollowModel*followModel=weakSelf.saveAllModelArray[3];
					NSInteger number = [div[@"I_NUMBER"] integerValue];
					NSString *lastTime=[DBTools TimeCurrentTime:weakSelf.nowDateStr andlaterDay:number];
					followModel.showStr=lastTime;
					followModel.postStr=lastTime;
					NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
					[weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                } 
			}
			
		}else{
			
			[JRToast showWithText:data[@"msg"]];
		}
	}];
}

- (void)dateChange {
	
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

- (NSMutableArray *)imageUrlArray {
    if (!_imageUrlArray) {
        _imageUrlArray = [NSMutableArray array];
    }
    return _imageUrlArray;
}

@end
