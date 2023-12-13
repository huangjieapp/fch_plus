//
//  MJKOrderPlanViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/24.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKOrderPlanViewController.h"
#import "MJKMarketViewController.h"
#import "ServiceTaskAddViewController.h"

#import "AddCustomerChooseTableViewCell.h"
#import "CGCNewAppointTextCell.h"
#import "CGCOrderDetialFooter.h"

#import "KSPhotoItem.h"
#import "KSPhotoBrowser.h"
#import "MJKPhotoView.h"
#import "MJKChooseEmployeesViewController.h"

@interface MJKOrderPlanViewController ()<UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
/** tableView*/
@property (nonatomic, strong) UITableView *tableView;
/** 选择的时间*/
@property (nonatomic, strong) NSString *timeStr;
@property (nonatomic, strong) NSString *startTimeStr;
/** 选择的人员id*/
@property (nonatomic, strong) NSString *saleID;
/** 选择的人员*/
@property (nonatomic, strong) NSString *saleName;
/** C_A01200_C_ID*/
@property (nonatomic, strong) NSString *C_A01200_C_ID;
/** <#备注#>*/
@property (nonatomic, strong) CGCOrderDetialFooter *tableFoot;
@property (nonatomic,copy) NSString * imgUrl1;//图片1
@property (nonatomic,copy) NSString * imgUrl2;//图片2
@property (nonatomic,copy) NSString * imgUrl3;//图片3
/** <#备注#>*/
@property (nonatomic, assign) NSInteger indexBtn;
@property (nonatomic,copy) NSString * patchUrl;//图片保存路径
/** 图片*/
@property (nonatomic, strong) NSArray *urlList;
/** (MJKPhotoView *)tableFootPhoto*/
@property (nonatomic, strong) MJKPhotoView *tableFootPhoto;
/** <#注释#>*/
@property (nonatomic, strong) NSArray *cellArray;
@end

@implementation MJKOrderPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	if (@available(iOS 11.0, *)) {
		self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}else {
		self.automaticallyAdjustsScrollViewInsets = NO;
	}
	[self initUI];
}

- (void)initUI {
	self.title = self.vcName;
	if ([self.vcName isEqualToString:@"计划"]) {
		self.saleID = self.moneyModel.C_RESPONSIBLE_ROLEID.length > 0 ? self.moneyModel.C_RESPONSIBLE_ROLEID : [NewUserSession instance].user.u051Id;
		self.saleName = self.moneyModel.C_RESPONSIBLE_ROLENAME.length > 0 ? self.moneyModel.C_RESPONSIBLE_ROLENAME : [NewUserSession instance].user.nickName;
        self.startTimeStr = self.moneyModel.D_PLANNEDSTART_TIME.length > 0 ? self.moneyModel.D_PLANNEDSTART_TIME : [DBTools getTimeFomatFromCurrentTimeStamp];
        self.timeStr = self.moneyModel.D_PLANNED_TIME.length > 0 ? self.moneyModel.D_PLANNED_TIME : [DBTools getTimeFomatFromTimeStampAddThreeTime:self.startTimeStr];
	} else if ([self.vcName isEqualToString:@"完成"]) {
		self.timeStr = self.moneyModel.D_ACTUAL_TIME.length > 0 ? self.moneyModel.D_ACTUAL_TIME : [DBTools getTimeFomatFromCurrentTimeStamp];
		self.saleID = self.moneyModel.C_COMPLETE_ROLEID.length > 0 ? self.moneyModel.C_COMPLETE_ROLEID : [NewUserSession instance].user.u051Id;
		self.saleName = self.moneyModel.C_COMPLETE_ROLENAME.length > 0 ? self.moneyModel.C_COMPLETE_ROLENAME : [NewUserSession instance].user.nickName;
	} 
	
	self.view.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:self.tableView];
	[self configButton];
}

//MARK:-UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.cellArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	DBSelf(weakSelf);
    NSString *cellStr = self.cellArray[indexPath.row];
	AddCustomerChooseTableViewCell *cell  = [AddCustomerChooseTableViewCell cellWithTableView:tableView];
    if ([cellStr isEqualToString:@"计划开始时间"]) {
        cell.nameTitleLabel.text = cellStr;
        cell.Type = ChooseTableViewTypeAllTime;
        cell.isTitle = YES;
        cell.textStr = self.startTimeStr;
        cell.chooseBlock = ^(NSString *str, NSString *postValue) {
            weakSelf.startTimeStr = postValue;
            weakSelf.timeStr = [DBTools getTimeFomatFromTimeStampAddThreeTime:weakSelf.startTimeStr];
            NSInteger index = [weakSelf.cellArray indexOfObject:@"计划完成时间"];
            [tableView reloadRowsAtIndexPaths:@[indexPath,[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        };
    }
	if ([cellStr isEqualToString:@"计划完成时间"] || [cellStr isEqualToString:@"实际完成时间"]) {
		cell.nameTitleLabel.text = cellStr;
		cell.Type = ChooseTableViewTypeAllTime;
		cell.isTitle = YES;
		cell.textStr = self.timeStr;
		cell.chooseBlock = ^(NSString *str, NSString *postValue) {
			weakSelf.timeStr = postValue;
			[tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
		};
	} else if ([cellStr isEqualToString:@"负责人"] || [cellStr isEqualToString:@"完成人"]) {
		cell.nameTitleLabel.text = cellStr;
		cell.Type = chooseTypeNil;
		cell.textStr = self.saleName;
		cell.chooseBlock = ^(NSString *str, NSString *postValue) {
			[weakSelf selectFlowSale];
		};
		
	} else if ([cellStr isEqualToString:@"备注"]) {
		CGCNewAppointTextCell*cell=[CGCNewAppointTextCell cellWithTableView:tableView];
		cell.topTitleLabel.text=@"备注";
		cell.textView.text = self.remarkStr;
		cell.changeTextBlock = ^(NSString *textStr) {
			weakSelf.remarkStr = textStr;
		};
		
		
		
//		//屏幕的上移问题
//		cell.startInputBlock = ^{
//			[UIView animateWithDuration:0.25 animations:^{
//
//				CGRect frame = self.view.frame;
//				//frame.origin.y+
//				frame.origin.y = -260;
//
//				self.view.frame = frame;
//
//			}];
//		};
//
//		cell.endBlock = ^{
//			[UIView animateWithDuration:0.25 animations:^{
//
//				CGRect frame = self.view.frame;
//
//				frame.origin.y = 0.0;
//
//				self.view.frame = frame;
//
//			}];
//
//
//		};
		return cell;
	}
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellStr = self.cellArray[indexPath.row];
	if ([cellStr isEqualToString:@"备注"]) {
		return 120;
	}
	return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
	bgView.backgroundColor = kBackgroundColor;
	UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth - 20, 30)];
	if ([self.vcName isEqualToString:@"计划"]) {
		label.text = @"计划信息";
	} else {
		label.text = @"完成信息";
	}
	label.textColor = [UIColor darkGrayColor];
	label.font = [UIFont systemFontOfSize:14.f];
	[bgView addSubview:label];
	return bgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	if ([self.vcName isEqualToString:@"计划"]) {
		return .1;
	} else {
		return 150;
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	if ([self.vcName isEqualToString:@"计划"]) {
		return nil;
	} else {
		return self.tableFootPhoto;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 30;
}

//MARK-config button
- (void)configButton {
	CGFloat submitY = [self.vcName isEqualToString:@"计划"] ? KScreenHeight - 120 : KScreenHeight - 60;
	UIButton *submitButton = [[UIButton alloc]initWithFrame:CGRectMake(10, submitY, KScreenWidth - 20, 50)];
	submitButton.backgroundColor = KNaviColor;
	[submitButton setTitleNormal:@"提交"];
	[submitButton setTitleColor:[UIColor blackColor]];
	[self.view addSubview:submitButton];
	submitButton.layer.cornerRadius = 5.f;
	[submitButton addTarget:self action:@selector(submitButtonAction)];
	
	UIButton *taskButton = [[UIButton alloc]initWithFrame:CGRectMake(10, KScreenHeight - 60, KScreenWidth - 20, 50)];
	[taskButton setTitleColor:[UIColor blackColor]];
	[taskButton setTitleNormal:@"转任务"];
	taskButton.backgroundColor = KNaviColor;
	taskButton.layer.cornerRadius = 5.f;
	[taskButton addTarget:self action:@selector(taskButtonAction)];
	if ([self.vcName isEqualToString:@"计划"]) {
		[self.view addSubview:taskButton];
	}
	
}

- (void)submitButtonAction {
	DBSelf(weakSelf);
	[self HTTPGetOrderTrajectoryListSuccessBlock:^{
		[weakSelf.navigationController popViewControllerAnimated:YES];
	}];
}

- (void)taskButtonAction {
	DBSelf(weakSelf);
	ServiceTaskAddViewController *vc = [[ServiceTaskAddViewController alloc]init];
	vc.C_ID = self.detailModel.C_ID;
	vc.detailModel = [[ServiceTaskDetailModel alloc]init];
	vc.detailModel.C_A41500_C_ID = self.detailModel.C_A41500_C_ID;
	vc.detailModel.C_A41500_C_NAME = self.detailModel.C_A41500_C_NAME;
	vc.detailModel.C_ADDRESS = self.detailModel.C_ADDRESS;
	vc.detailModel.X_REMARK = self.remarkStr;
	vc.detailModel.C_OWNER_ROLEID = self.saleID;
	vc.detailModel.C_OWNER_ROLENAME = self.saleName;
	vc.detailModel.D_ORDER_TIME = self.timeStr;
	vc.detailModel.C_TYPE_DD_ID = self.moneyModel.C_TYPE_DD_ID;
	vc.detailModel.C_TYPE_DD_NAME = self.moneyModel.C_TYPE_DD_NAME;
	vc.detailModel.I_TYPE = self.moneyModel.I_RWTYPE;
	vc.title = @"新增任务";
	vc.vcStr = @"order";
	vc.backC_A01200_C_IDBlock = ^(NSDictionary *C_A01200_C_IDDic) {
		weakSelf.C_A01200_C_ID = C_A01200_C_IDDic[@"C_A01200_ID"];
		if ([C_A01200_C_IDDic[@"sale"] length] > 0) {
			weakSelf.saleID = C_A01200_C_IDDic[@"sale"];
		}
		if ([C_A01200_C_IDDic[@"x_remark"] length] > 0) {
			weakSelf.remarkStr = C_A01200_C_IDDic[@"x_remark"];
		}
		if ([C_A01200_C_IDDic[@"arrivaTime"] length] > 0) {
			weakSelf.timeStr = C_A01200_C_IDDic[@"arrivaTime"];
		}
		[weakSelf HTTPGetOrderTrajectoryListSuccessBlock:^{
//			[weakSelf.navigationController popViewControllerAnimated:YES];
			[weakSelf.navigationController popToViewController:self.rootVC animated:YES];
		}];
	};
	[self.navigationController pushViewController:vc animated:YES];
}

- (void)selectFlowSale {
	[self.view endEditing:YES];
    DBSelf(weakSelf);
	MJKChooseEmployeesViewController *vc = [[MJKChooseEmployeesViewController alloc]init];
    if ([[NewUserSession instance].appcode containsObject:@"APP005_0036"]) {
        vc.isAllEmployees = @"是";
    }
    vc.noticeStr = @"无提示";
    vc.chooseEmployeesBlock = ^(MJKClueListSubModel * _Nonnull model) {
		weakSelf.saleID = model.user_id;
		weakSelf.saleName = model.user_name;
		[weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
	};
	[self.navigationController pushViewController:vc animated:YES];
}

//MARK:-http
- (void)HTTPGetOrderTrajectoryListSuccessBlock:(void(^)(void))completeBlock{
	DBSelf(weakSelf);
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A47300WebService-operationBean"];
	
	NSMutableDictionary *dic=[NSMutableDictionary new];
	dic[@"C_ID"] = self.trajectoryID;
	
	if ([self.vcName isEqualToString:@"计划"]) {
		dic[@"TYPE"] = @"0";
		dic[@"C_RESPONSIBLE_ROLEID"] = self.saleID;
		dic[@"X_PLANNEDREMARK"] = self.remarkStr;
		dic[@"D_PLANNED_TIME"] = self.timeStr;
        dic[@"D_PLANNEDSTART_TIME"] = self.startTimeStr;
		if (self.C_A01200_C_ID) {
			dic[@"C_A01200_C_ID"] = self.C_A01200_C_ID;
		}
		
	} else {
		dic[@"TYPE"] = @"1";
		dic[@"C_COMPLETE_ROLEID"] = self.saleID;
		dic[@"X_REMARK"] = self.remarkStr;
		dic[@"D_ACTUAL_TIME"] = self.timeStr;
		if (self.urlList.count > 0) {
			dic[@"urlList"] = self.urlList;
		}
	}
	
	[dict setObject:dic forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
	
	HttpManager*manager=[[HttpManager alloc]init];
	
	[manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		if ([data[@"code"] integerValue]==200) {
			[JRToast showWithText:data[@"message"]];
//			[weakSelf.navigationController popViewControllerAnimated:YES];
			if (completeBlock) {
				completeBlock();
			}
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

//MARK:-set
- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - WD_TabBarHeight- SafeAreaBottomHeight) style:UITableViewStylePlain];
		_tableView.dataSource = self;
		_tableView.delegate = self;
		_tableView.estimatedRowHeight = 0;
		_tableView.estimatedSectionFooterHeight = 0;
		_tableView.estimatedSectionHeaderHeight = 0;
		_tableView.tableFooterView = [[UIView alloc]init];
		_tableView.bounces = NO;
	}
	return _tableView;
}

- (MJKPhotoView *)tableFootPhoto {
	DBSelf(weakSelf);
	if (!_tableFootPhoto) {
		_tableFootPhoto = [[MJKPhotoView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 150)];
		_tableFootPhoto.isEdit = YES;
		_tableFootPhoto.rootVC = self;
//		_tableFootPhoto.imageURLArray = self.orderModel.urlList;
		_tableFootPhoto.backUrlArray = ^(NSArray *arr, NSArray *saveArr) {
			weakSelf.urlList = arr;
		};
	}
	return _tableFootPhoto;
}

- (CGCOrderDetialFooter *)tableFoot{
	
	if (_tableFoot==nil) {
		
		_tableFoot=[[[NSBundle mainBundle] loadNibNamed:@"CGCOrderDetialFooter" owner:self options:0] lastObject];
		
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

- (void)showBigImage:(UIImage *)image withBtn:(UIButton *)btn{
	
	KSPhotoItem * item=[KSPhotoItem itemWithSourceView:btn.imageView image:image];
	KSPhotoBrowser * browser=[KSPhotoBrowser browserWithPhotoItems:@[item] selectedIndex:0];
	
	
	[browser showFromViewController:self];
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
//	self.orderModel.urlList = imgURLArr;
	self.urlList = imgURLArr;
	
}

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
////对图片尺寸进行压缩--
//-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
//{
//    // Create a graphics image context
//    UIGraphicsBeginImageContext(newSize);
//
//    // Tell the old image to draw in this new context, with the desired
//    // new size
//    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
//
//    // Get the new image from the context
//    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
//
//    // End the context
//    UIGraphicsEndImageContext();
//
//    // Return the new image.
//    return newImage;
//}
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

-(void)update{
	
	//    NSThread *thread=[[NSThread alloc]initWithTarget:self selector:@selector(uppicAction) object:nil];
	//    [thread start];
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

- (NSArray *)cellArray {
    if (!_cellArray) {
        if ([self.vcName isEqualToString:@"计划"]) {
            _cellArray = @[@"计划开始时间",@"计划完成时间",@"负责人",@"备注"];
        } else {
            _cellArray = @[@"实际完成时间",@"完成人",@"备注"];
        }
    }
    return _cellArray;
}

@end
