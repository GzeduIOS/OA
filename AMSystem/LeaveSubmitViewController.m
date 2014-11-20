//
//  leverlViewController.m
//  AMSystem
//
//  Created by 徐晓斐 on 14-9-22.
//  Copyright (c) 2014年 GZDEU. All rights reserved.
//

#import "LeaveSubmitViewController.h"
#import "AMSystemManager.h"
#import "JCDatePicker.h"
@interface LeaveSubmitViewController ()<UITextFieldDelegate,JCDatePickerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{
    BOOL _blockUserInteraction;
}
@property(nonatomic)NSUInteger *selectedIndexPath;
@property(nonatomic,strong)NSArray *array;
@property(nonatomic,strong)NSDateFormatter *dateFormatter;
@property(nonatomic ,strong)UIButton *button;
@end

@implementation LeaveSubmitViewController{
    
    JCDatePicker *datePicker;
    UIButton *activedButton;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"请假申请";
    self.MyTextView.delegate = self;
    NSDate *now = [NSDate date];
     self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [self.dateFormatter stringFromDate:now];
    [self.btn2 setTitle:[NSString stringWithFormat:@"%@-%@-%@ %@:%@",[dateString substringWithRange:NSMakeRange(0, 4)],[dateString substringWithRange:NSMakeRange(5, 2)],[dateString substringWithRange:NSMakeRange(8, 2)],[dateString substringWithRange:NSMakeRange(11, 2)],[dateString substringWithRange:NSMakeRange(14, 2)]] forState:UIControlStateNormal];
    [self.btn3 setTitle:[NSString stringWithFormat:@"%@-%@-%@ %@:%@",[dateString substringWithRange:NSMakeRange(0, 4)],[dateString substringWithRange:NSMakeRange(5, 2)],[dateString substringWithRange:NSMakeRange(8, 2)],[dateString substringWithRange:NSMakeRange(11, 2)],[dateString substringWithRange:NSMakeRange(14, 2)]] forState:UIControlStateNormal];
    
    self.array = [[NSArray alloc]initWithObjects:@"调休",@"事假",@"病假",@"年假", nil ];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setLocale:[NSLocale systemLocale]];//[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    datePicker = [[JCDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-20, 180)];
    datePicker.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame));
    [self.view addSubview:datePicker];
    datePicker.delegate = self;
    datePicker.font = [UIFont systemFontOfSize:10];
    datePicker.date = [NSDate date];
    datePicker.dateFormat = JCDateFormatFull;
    datePicker.hidden = YES;
   

}
- (void)datePicker:(JCDatePicker *)datePicker dateDidChange:(NSDate *)date
{
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    [activedButton setTitle:dateString forState:UIControlStateNormal];
    NSString *dateStr = self.btn2.titleLabel.text;
    NSDate *date2 = [self.dateFormatter dateFromString:dateStr];
    NSString *dateStr2 = self.btn3.titleLabel.text;
    NSDate *date3 = [self.dateFormatter dateFromString:dateStr2];
    NSTimeInterval time=[date3 timeIntervalSinceDate:date2];
   
    int days = ((int)time)/(3600*24);
    int hours = ((int)time)%(3600*24)/3600;
  
    //int minute = ((int)time)%(3600*24)/60/60;
    
    if (days <=0 && hours <= 0)
        self.myLabel.text=@"0天0小时";
    else
        self.myLabel.text=[[NSString alloc] initWithFormat:@"%i天%i小时",days,hours];

}

#pragma mark - UIPickerView Delegate

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 20;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 50;
}
#pragma mark - UIPickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 3;
}


//点击View的其他区域隐藏软键盘。
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.MyTextView resignFirstResponder];
    
}

//假别
- (IBAction)btn1:(UIButton *)sender {
    
    ZSYPopoverListView *listView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    listView.titleName.text = @"Choose";
    listView.datasource = self;
    listView.delegate = self;
    [listView show];
    
}

////从-到
- (IBAction)btn3:(UIButton *)sender {
    NSString *dateString = sender.titleLabel.text;
    [sender setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    NSDate *date = [self.dateFormatter dateFromString:dateString];
    [datePicker setDate:date];
    datePicker.hidden = NO;//
    if(activedButton) {
        [activedButton setTintColor:[UIColor colorWithWhite:0.3 alpha:1]];
    }
    self.Uploadbtn.hidden = YES;
    [sender setTintColor:[UIColor colorWithRed:0 green:0.4 blue:1 alpha:1]];
    activedButton = sender;
   
    self.button = [[UIButton alloc]initWithFrame:CGRectMake(10,self.view.bounds.size.height-60, 300, 40)];

    [self.button setTitle:@"确定" forState:UIControlStateNormal];
    [self.button setBackgroundColor:[UIColor blueColor]];
    [self.button addTarget:self action:@selector(selectUP:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
}
-(void)selectUP:(UIButton *)sender{
    datePicker.hidden = YES;
    self.Uploadbtn.hidden = NO;
    self.button.hidden = YES;
}
//提交
- (IBAction)UploadData:(UIButton *)sender {
    myReachability *R = [[myReachability alloc]init];
    [R myreachability:self.view];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *CODE = [[NSString alloc]init];
    if ([self.btn1.titleLabel.text isEqualToString:@"调休"]) {
        CODE = @"REST";
    }else if([self.btn1.titleLabel.text isEqualToString:@"事假"]){
        CODE = @"AFFAIR";
    }else if([self.btn1.titleLabel.text isEqualToString:@"病假"]){
        CODE = @"ILL";
    }else if([self.btn1.titleLabel.text isEqualToString:@"年假"]){
        CODE = @"YEAR_REST";
    }
    
    [AMSystemManager interfaceLeaveApply:[userDefaults stringForKey:@"KEY"] beginTime:self.btn2.titleLabel.text endTime:self.btn3.titleLabel.text applyType:CODE applyReason:self.MyTextView.text complation:^(id obj) {
        //提示语
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    }];

}
// 单选框
- (NSInteger)popoverListView:(ZSYPopoverListView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
// 单选框
- (UITableViewCell *)popoverListView:(ZSYPopoverListView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusablePopoverCellWithIdentifier:identifier];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if ( self.selectedIndexPath /*&& NSOrderedSame == [self.selectedIndexPath compare:indexPath]*/)
    {
        cell.imageView.image = [UIImage imageNamed:@"fs_main_login_selected.png"];
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"fs_main_login_normal.png"];
        
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.array[indexPath.row]];
    return cell;
}
// 单选框
- (void)popoverListView:(ZSYPopoverListView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"fs_main_login_normal.png"];
 //   NSLog(@"deselect:%@", self.array[indexPath.row]);
}
// 单选框
- (void)popoverListView:(ZSYPopoverListView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//   self.selectedIndexPath = indexPath;
    UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"fs_main_login_selected.png"];
   // NSLog(@"select:%@", self.array[indexPath.row]);
    [self.btn1 setTitle:self.array[indexPath.row] forState:UIControlStateNormal];
}


@end
