//
//  MJKOnlineHallDetailViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/18.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKOnlineHallDetailViewController.h"

#import "MJKOnlineHallTableViewCell.h"
#import "MJKOnlineHallPhotoTableViewCell.h"
#import "MJKClueMemoInDetailTableViewCell.h"

#import "MJKFlowInstrumentModel.h"

@interface MJKOnlineHallDetailViewController ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
	NSData *_imageData;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MJKFlowInstrumentSubModel *onlineModel;
@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, strong) UIButton *deleteButton;

@property(nonatomic,strong) UIImagePickerController *imagePicker; //声明全局的UIImagePickerController
@property (nonatomic, assign) BOOL isEdit;
@end

@implementation MJKOnlineHallDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isAdd == YES) {
        self.title = @"直播信息新增";
    } else {
        self.title = @"直播信息详情";
    }
    
	[self.view addSubview:self.tableView];
	[self.view addSubview:self.deleteButton];
	if (self.isAdd == YES) {
		CGRect frame = self.tableView.frame;
		frame.size.height = KScreenHeight - 64;
		self.tableView.frame = frame;
		self.onlineModel = [[MJKFlowInstrumentSubModel alloc]init];
		[self.deleteButton setTitle:@"提交" forState:UIControlStateNormal];
	} else {
		UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
		self.editButton = button;
		[button setTitle:@"修改" forState:UIControlStateNormal];
		[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
		[button addTarget:self action:@selector(clickEidtButton:) forControlEvents:UIControlEventTouchUpInside];
		UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:button];;
		self.navigationItem.rightBarButtonItem = barButton;
		[self HTTPGetOnlineHallDatas];
	}
	
	
	
	
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.isEdit == YES || self.isAdd == YES) {
		return 5;
	} else {
		if (self.onlineModel.C_PICURL.length > 0 || self.onlineModel.C_LIVEURL.length > 0) {
			return 5;
		} else {
			return 4;
		}
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	DBSelf(weakSelf);
	if (indexPath.row == 4) {
		MJKOnlineHallPhotoTableViewCell *cell = [MJKOnlineHallPhotoTableViewCell cellWithTableView:tableView];
//        [cell.imageButton.imageView sd_setImageWithURL:[NSURL URLWithString:self.onlineModel.C_PICURL]];
        [cell.imageButton setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.onlineModel.C_PICURL]]] forState:UIControlStateNormal];
		if (self.isEdit == YES || self.isAdd == YES) {
			if (self.onlineModel.C_PICURL.length > 0) {
				
			} else {
				[cell.imageButton setBackgroundImage:[UIImage imageNamed:@"7_03.png"] forState:UIControlStateNormal];
			}
			
			[cell setBackClickImageButtonBlock:^{
				[weakSelf headClick];
			}];
		}
		return cell;
	} else {
		MJKOnlineHallTableViewCell *cell = [MJKOnlineHallTableViewCell cellWithTableView:tableView];
		if (self.isEdit == YES || self.isAdd == YES) {
			[cell updataChangeCellTitle:@[@"设备位置", @"设备序列号", @"通道号", @"备注"][indexPath.row] andModel:self.onlineModel andRow:indexPath.row];
			[cell setBackChangeTextBlock:^(NSString *str){
				switch (indexPath.row) {
					case 0:
						self.onlineModel.C_POSITION = str;
						break;
					case 1:
                        self.onlineModel.C_NUMBER = str;
						break;
					case 2:
                        self.onlineModel.C_CHANNEL_NUMBER = str;
						break;
//                    case 3:
//                        self.onlineModel.C_A68000_C_NAME = str;
//                        break;
//                    case 4:
//                        self.onlineModel.X_REMARK = str;
//                        break;
					default:
						break;
				}
			}];
            if (indexPath.row == 3) {
                DBSelf(weakSelf);
                MJKClueMemoInDetailTableViewCell *memoCell = [MJKClueMemoInDetailTableViewCell cellWithTableView:tableView];
                memoCell.memoTextView.editable = YES;
//                memoCell.delegate = self;
                memoCell.titleLabel.text = @"备注";
                if(weakSelf.onlineModel.X_REMARK.length > 0){
                    memoCell.memoTextView.text=weakSelf.onlineModel.X_REMARK;
                }
                [memoCell setBackTextViewBlock:^(NSString *str){
                    weakSelf.onlineModel.X_REMARK = str;
                }];
                return memoCell;
            }
		} else {
			[cell updataDetailTitle:@[@"设备位置", @"设备序列号", @"通道号", @"备注"][indexPath.row] andModel:self.onlineModel andRow:indexPath.row];
            if (indexPath.row == 3) {
                DBSelf(weakSelf);
                MJKClueMemoInDetailTableViewCell *memoCell = [MJKClueMemoInDetailTableViewCell cellWithTableView:tableView];
                memoCell.memoTextView.editable = NO;
                memoCell.titleLabel.text = @"备注";
                //                memoCell.delegate = self;
                if(weakSelf.onlineModel.X_REMARK.length > 0){
                    memoCell.memoTextView.text=weakSelf.onlineModel.X_REMARK;
                }
                [memoCell setBackTextViewBlock:^(NSString *str){
                    weakSelf.onlineModel.X_REMARK = str;
                }];
                return memoCell;
            }
		}
		
		return cell;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.isEdit == YES || self.isAdd == YES) {
		if (indexPath.row == 4) {
			return 100;
        } else if (indexPath.row == 3 ) {
            return 100;
        } else {
			return 44;
		}
	} else {
		if (self.onlineModel.C_PICURL.length > 0) {
			if (indexPath.row == 4) {
				return 100;
			}
		}
        if (indexPath.row == 3) {
            return 100;
        }
		return 44;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return .1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self.view endEditing:YES];
}

#pragma mark - 照片等功能
- (void)getPhoto {
	
}

#pragma mark - 点击事件
- (void)clickEidtButton:(UIButton *)sender {
	if ([sender.titleLabel.text isEqualToString:@"修改"]) {
        self.title = @"直播信息修改";
		self.isEdit = YES;
		self.editButton.hidden = YES;
		[self.deleteButton setTitle:@"提交" forState:UIControlStateNormal];
		[self.deleteButton setBackgroundColor:[UIColor orangeColor]];
		[self.tableView reloadData];
	}
}

- (void)deleteButtonAction:(UIButton *)sender {
	if ([sender.titleLabel.text isEqualToString:@"删除"]) {
		[self HTTPDeleteOnlineHallDatas];
	} else {
//		MJKOnlineHallPhotoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
        self.title = @"直播信息详情";
		if (_imageData.length > 0) {
			[self postImageToJiekouWith:_imageData];
		} else {
			if (self.onlineModel.C_PICURL.length > 0) {
				self.onlineModel.C_PICURL = [self.onlineModel.C_PICURL substringFromIndex:38];
			}
			[self HTTPUpdataOnlineHallDatas];
		}
	}
}

#pragma mark -头像UIImageview的点击事件-
- (void)headClick {
	// 判断系统是否支持相机
	UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
	imagePickerController.delegate = self; //设置代理
	imagePickerController.allowsEditing = NO;
	
	//自定义消息框
	UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
	UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		[self presentViewController:imagePickerController animated:YES completion:nil];
	}];
	UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		//拍照
		imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
		[self presentViewController:imagePickerController animated:YES completion:nil];
	}];
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		
	}];
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		[alertView addAction:cameraAction];
	}
	[alertView addAction:photoAction];
	[alertView addAction:cancelAction];
	[self presentViewController:alertView animated:YES completion:nil];
	
}

#pragma mark -实现图片选择器代理-
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissViewControllerAnimated:YES completion:^{}];
	UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage]; //通过key值获取到图片
    if (!image) {
        image=[info objectForKey:UIImagePickerControllerEditedImage];
    }
    
//    CGSize imagesize = image.size;
//    imagesize.height =500;
//    imagesize.width =500;
//    image = [self imageWithImage:image scaledToSize:imagesize];
	NSData *imageData = UIImageJPEGRepresentation(image,0.5);
	_imageData = imageData;
	image= [UIImage imageWithData:imageData];
	MJKOnlineHallPhotoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
	[cell.imageButton setBackgroundImage:image forState:UIControlStateNormal];  //给UIimageView赋值已经选择的相片
	[self saveimg:image];
	
}

//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
	// Create a graphics image context
	UIGraphicsBeginImageContext(newSize);
	
	// Tell the old image to draw in this new context, with the desired
	// new size
	[image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
	
	// Get the new image from the context
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	
	// End the context
	UIGraphicsEndImageContext();
	
	// Return the new image.
	return newImage;
}

#pragma mark - HTTP request
- (void)HTTPGetOnlineHallDatas {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_detailOnlineHall];
	[dict setObject:@{@"C_ID" : self.model.C_ID} forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.onlineModel = [MJKFlowInstrumentSubModel yy_modelWithDictionary:data];
			[weakSelf.tableView reloadData];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

- (void)HTTPDeleteOnlineHallDatas {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_deleteFlowSet];
	[dict setObject:@{@"C_ID" : self.onlineModel.C_ID} forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			[weakSelf.navigationController popViewControllerAnimated:YES];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

- (void)HTTPUpdataOnlineHallDatas {
	NSString *str;
	if (self.isAdd == YES) {
		str = HTTP_insertFlowSet;
	} else if (self.isEdit == YES) {
		str = HTTP_updataFlowSet;
	} else {
		str = HTTP_deleteFlowSet;
	}
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:str];
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"3" forKey:@"TYPE"];
	if (self.isAdd == YES) {
		
	} else {
		[dic setObject:self.onlineModel.C_ID forKey:@"C_ID"];
	}
	if (self.onlineModel.C_NUMBER.length > 0) {
		[dic setObject:self.onlineModel.C_NUMBER forKey:@"C_NUMBER"];
	}
	if (self.onlineModel.C_POSITION.length > 0) {
		[dic setObject:self.onlineModel.C_POSITION forKey:@"C_POSITION"];
	}
	if (self.onlineModel.C_CHANNEL_NUMBER.length > 0) {
		[dic setObject:self.onlineModel.C_CHANNEL_NUMBER forKey:@"C_CHANNEL_NUMBER"];
	}
	if (self.onlineModel.X_REMARK.length > 0) {
		[dic setObject:self.onlineModel.X_REMARK forKey:@"X_REMARK"];
	}
	if (self.onlineModel.C_PICURL.length > 0) {
		[dic setObject:self.onlineModel.C_PICURL forKey:@"C_PICURL"];
	}
	[dict setObject:dic forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			if (weakSelf.isEdit != YES) {
				[weakSelf.navigationController popViewControllerAnimated:YES];
			} else {
				weakSelf.isEdit = NO;
				weakSelf.editButton.hidden = NO;
				
				[weakSelf.deleteButton setTitle:@"删除" forState:UIControlStateNormal];
				[weakSelf.deleteButton setBackgroundColor:[UIColor redColor]];
				[self HTTPGetOnlineHallDatas];
			}
			
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

- (void)postImageToJiekouWith:(NSData *)data {
	DBSelf(weakSelf);
	NSString *urlStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"ipImage"]];
	HttpManager *manager = [[HttpManager alloc]init];
	[manager postDataUpDataPhotoWithUrl:urlStr parameters:nil photo:data compliation:^(id data, NSError *error) {
		if ([data[@"code"] integerValue] == 200) {
			weakSelf.onlineModel.C_PICURL = data[@"url"];
			[weakSelf HTTPUpdataOnlineHallDatas];
		} else {
			[JRToast showWithText:data[@"message"]];
		}
	}];
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
}

#pragma mark - set
- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - 50) style:UITableViewStyleGrouped];
		_tableView.delegate = self;
		_tableView.dataSource = self;
	}
	return _tableView;
}

- (UIButton *)deleteButton {
	if (!_deleteButton) {
		_deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(15, KScreenHeight - 45, KScreenWidth - 30, 40)];
		[_deleteButton setBackgroundColor:[UIColor redColor]];
		[_deleteButton setTitle:@"删除本机" forState:UIControlStateNormal];
		_deleteButton.layer.cornerRadius = 5.0f;
		[_deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _deleteButton;
}

@end
