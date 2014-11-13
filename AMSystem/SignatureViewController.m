//
//  SignatureViewController.m
//  AMSystem
//
//  Created by 徐晓斐 on 14-9-5.
//  Copyright (c) 2014年 GZDEU. All rights reserved.
//

#import "SignatureViewController.h"
#import "AMSystemManager.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
@interface SignatureViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btn1;//签到//日记//签退
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *photoBtn;
@property (strong, nonatomic)NSMutableArray *arrImage;
@property (strong, nonatomic)NSString *adder;//用于提交时发送地址
@property (nonatomic)NSUInteger *tag;//签到类型
@property(strong,nonatomic)NSArray *fileArray;
@property(strong,nonatomic)NSString *strPath;
@property (strong,nonatomic)NSData *imagedata;
@property(strong,nonatomic)NSString *strName;

@property CLLocationManager *locationManager;//MapAPI
@property CLLocation *location;//MapAPI - 记录地理信息
@end

@implementation SignatureViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//隐藏状态栏
//-(BOOL)prefersStatusBarHidden{
//    return YES;
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.arrImage = [[NSMutableArray alloc]init];
    
    //Location API init
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;//精确到10米
    self.locationManager.distanceFilter = 1000.0f;

}
//准备显示视图
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //开始定位
    [self.locationManager startUpdatingLocation];
}
//准备关闭视图
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //关闭定位
    [self.locationManager stopUpdatingLocation];
}
//MapAPI委托方法 更新地址后回调赋值地理信息
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    self.location = [locations lastObject];
}

//签到//日记//签退
- (IBAction)btn1:(UIButton *)sender {
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//此时选中
    
    self.tag = (NSUInteger *)sender.tag;
    
    [self showInfo];//展示信息
}
//展示信息
- (void)showInfo{
    
    //反编码地理信息,取得地址信息
    CLGeocoder* geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:self.location completionHandler:^(NSArray *placemarks, NSError *error){

        if([placemarks count] > 0){
            CLPlacemark *placemark = placemarks[0];
            NSDictionary *locationInfos = placemark.addressDictionary;
            
            //绘制信息
            [self createLocationInfo:locationInfos];
        }
        
    }];
    
}

//绘制地址及时间显示
-(void)createLocationInfo:(NSDictionary *)locationInfos
{
    //绘制显示空间
    UIView *infoView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-(self.btn1.frame.size.height+70), self.view.frame.size.width, 50)];
    
    //地址
    //NSLog(@"locationInfos : %@",locationInfos);
    NSString *state = [locationInfos valueForKey:@"State"];//省
    NSString *city = [locationInfos valueForKey:@"City"];//市
    NSString *street = [locationInfos valueForKey:@"Street"];//街道
    
    NSMutableString *address = [NSMutableString stringWithCapacity:100];
    [address appendString:state];
    [address appendString:city];
    [address appendString:street];
    
    self.adder = address;//用于提交时发送
    
    infoView.backgroundColor = [UIColor whiteColor];
    UILabel *lbl_address = [[UILabel alloc]initWithFrame:CGRectMake(10, infoView.frame.size.height/2, self.view.frame.size.width, infoView.frame.size.height/2)];
    lbl_address.text = [NSString stringWithFormat:@"签到地点:%@",address];
    
    
    //签到时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    NSString *addartime = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",[dateString substringWithRange:NSMakeRange(0, 4)],[dateString substringWithRange:NSMakeRange(4, 2)],[dateString substringWithRange:NSMakeRange(6, 2)],[dateString substringWithRange:NSMakeRange(8, 2)],[dateString substringWithRange:NSMakeRange(10, 2)]];
    
    UILabel *lbl_signatureTime = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width,infoView.frame.size.height/2)];
    lbl_signatureTime.text = [NSString stringWithFormat:@"本次签到时间:%@",addartime];
    
    
    //提交按钮
    UIButton *btn_submit = [[UIButton alloc]init];
    btn_submit.frame = CGRectMake(4,self.btn1.frame.origin.y-10,self.view.frame.size.width-2*4, self.btn1.frame.size.height+10);
    [btn_submit setTitle:@"提交" forState:UIControlStateNormal];
    [btn_submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//此时选中
    [btn_submit addTarget:self action:@selector(chickUp:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //拍照背景
    UIImage *image = [UIImage imageNamed:@"u20.png"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
    
    [btn_submit setBackgroundImage:image forState:UIControlStateNormal];
    
    
    
    [infoView addSubview:lbl_address];
    [infoView addSubview:lbl_signatureTime];
    [self.btn1 removeFromSuperview];//去除原有的三个按钮
    [self.btn2 removeFromSuperview];
    [self.btn3 removeFromSuperview];
    [self.view addSubview:btn_submit];
    [self.view addSubview:infoView];
}
//调用照相机
- (IBAction)photoBtn:(UIButton *)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        //判断是否可以打开相机，模拟器此功能无法使用
        if( [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront] ){
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }else{
            imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
        imagePicker.delegate = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:imagePicker animated:YES completion:nil];
        });

    });
}
//保存照片
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //得到图片
    
    self.imagedata = UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage],0.000001);
    UIImage *img = [[UIImage alloc]initWithData:self.imagedata];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.photoBtn setBackgroundImage:img forState:UIControlStateNormal];
        [self.photoBtn setImage:nil forState:UIControlStateNormal];
        [self.arrImage addObject:self.imagedata];
        MyLog(@"%u",[self.imagedata length]/1024);
        
        [self dismissViewControllerAnimated:YES completion:nil];//关闭拍照后选择界面
    });
   // UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);//把拍照图片保存到本地
    
}

//点击Cancel按钮后执行方法
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [self dismissViewControllerAnimated:YES completion:nil];//关闭拍照界面
    
}

//提交返回
-(void)chickUp:(UIButton *)sender{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        //经纬度
        NSString *longitude = [NSString stringWithFormat:@"%f",_location.coordinate.longitude];
        NSString *latitude = [NSString stringWithFormat:@"%f",_location.coordinate.latitude];

        //接口请求KEY
        NSString *KEY = [self.SignatureDic objectForKey:@"KEY"];
        
        //签到类型
        sender.tag = (NSUInteger)self.tag;
        NSString *ROLE_CODE = [[NSString alloc]init];
        
        if (sender.tag == 0) {
            ROLE_CODE = @"A";
        }else if(sender.tag == 1){
            ROLE_CODE = @"C";
        }else if(sender.tag == 2){
            ROLE_CODE = @"B";
        }
        //返回接口返回值(NSDictionary)
        [AMSystemManager interfaceRegister:KEY userSignType:ROLE_CODE userSignAddress:self.adder userLongitude:longitude userLatitude:latitude pictureData:self.imagedata complation:^(id obj) {
            
            //MyLog(@"%@",obj);
            [self dismissViewControllerAnimated:YES completion:nil];//关闭签到界面
            
        }];
        
    });
   
}

- (IBAction)back:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
