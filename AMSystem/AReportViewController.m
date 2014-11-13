//
//  AReportViewController.m
//  AMSystem
//
//  Created by 徐晓斐 on 14-9-5.
//  Copyright (c) 2014年 GZDEU. All rights reserved.
//

#import "AReportViewController.h"
#import "TableViewCell.h"
#import "AQueryViewController.h"
#import "AMSystemManager.h"
#import "MyJsonParser.h"
#import "PeoperData.h"
#import "JCDatePicker.h"
@interface AReportViewController ()
@property (strong, nonatomic) IBOutlet UITableView *areportTableview;
@property (weak, nonatomic) IBOutlet UITextField *myTextField;
@property (weak, nonatomic) IBOutlet UIButton *starDate;
@property (weak, nonatomic) IBOutlet UIButton *endDate;
@property (strong ,nonatomic)NSArray *array;
@property (strong, nonatomic) IBOutlet UIButton *searchBtn;
@property (strong, nonatomic) IBOutlet UIView *myTopView;
@property (strong,nonatomic)NSDateFormatter *dateFormatter;
@property (strong,nonatomic)UIButton *button;
@end

@implementation AReportViewController{
    
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
//点击Enter的时候隐藏软键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.myTextField resignFirstResponder];
    return NO;
}
//点击取消（Cancel）或那个小差号的时候隐藏。注意这里如return YES则无法隐藏
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    [self.myTextField resignFirstResponder];
    return NO;
}
//点击View的其他区域隐藏软键盘。
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.myTextField resignFirstResponder];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDate *now = [NSDate date];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [self.dateFormatter stringFromDate:now];
    [self.starDate setTitle:[NSString stringWithFormat:@"%@-%@-01 %@:%@",[dateString substringWithRange:NSMakeRange(0, 4)],[dateString substringWithRange:NSMakeRange(5, 2)],[dateString substringWithRange:NSMakeRange(11, 2)],[dateString substringWithRange:NSMakeRange(14, 2)]] forState:UIControlStateNormal];
    [self.endDate setTitle:[NSString stringWithFormat:@"%@-%@-%@ %@:%@",[dateString substringWithRange:NSMakeRange(0, 4)],[dateString substringWithRange:NSMakeRange(5, 2)],[dateString substringWithRange:NSMakeRange(8, 2)],[dateString substringWithRange:NSMakeRange(11, 2)],[dateString substringWithRange:NSMakeRange(14, 2)]] forState:UIControlStateNormal];    UIImage *image = [UIImage imageNamed:@"form.png"];
    
    
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
    [self.myTextField setBackground:image];
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];

    NSString *str2 = [NSString stringWithFormat:@"%@%@%@",[self.endDate.titleLabel.text substringToIndex:4],[self.endDate.titleLabel.text substringWithRange:NSMakeRange(5, 2)],[self.endDate.titleLabel.text substringWithRange:NSMakeRange(8, 2)]];
    NSString *str3 = [NSString stringWithFormat:@"%@%@01",[self.starDate.titleLabel.text substringToIndex:4],[self.starDate.titleLabel.text substringWithRange:NSMakeRange(5, 2)]];
    [AMSystemManager interfaceAttendanceReportInfos:[userdefaults stringForKey:@"KEY"] beginDate:str3 endDate:str2 complation:^(id obj) {
            
            self.array = [MyJsonParser parseAReportByarr:obj];
            [self tableviewUP];
        
    }];
    
}

-(void)tableviewUP{
    //tableview
    self.areportTableview = [[UITableView alloc]init];
    self.areportTableview.frame = CGRectMake(-12, 232, 334, self.view.bounds.size.height-232);
    self.areportTableview.delegate = self;
    self.areportTableview.dataSource = self;
    [self.areportTableview registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell3"];
    self.areportTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];////UITableView隐藏多余的分割线
     //[self.areportTableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];//UITableView隐藏所有的分割线
    [self.view addSubview: self.areportTableview];
    
}
- (IBAction)search:(UIButton *)sender {
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!self.array.count) {
        
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        return 1;
        
    }else{
        return self.array.count;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell3";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (!self.array.count) {
        cell = [[TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = @"暂无数据...";
    }else{
        PeoperData *p = self.array[indexPath.row];
        cell.per = p;
    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.array.count) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        AQueryViewController *AQueryView = [[self storyboard] instantiateViewControllerWithIdentifier:@"AQuery Identity"];
        
        [self presentViewController:AQueryView animated:YES completion:nil];
    }
}
- (NSInteger) tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//从——到
- (IBAction)startBtn:(UIButton *)sender {
    self.areportTableview.hidden = YES;
    NSString *dateString = sender.titleLabel.text;
    [sender setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    NSDate *date = [self.dateFormatter dateFromString:dateString];
    [datePicker setDate:date];
    datePicker.hidden = NO;//
    if(activedButton) {
        [activedButton setTintColor:[UIColor colorWithWhite:0.3 alpha:1]];
    }
    [sender setTintColor:[UIColor colorWithRed:0 green:0.4 blue:1 alpha:1]];
    activedButton = sender;
    self.button = [[UIButton alloc]initWithFrame:CGRectMake(10,self.view.bounds.size.height-60, 300, 40)];
   
    [self.button setTitle:@"确定" forState:UIControlStateNormal];
    [self.button setBackgroundColor:[UIColor blueColor]];
    [self.button addTarget:self action:@selector(selectUP:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
}
-(void)selectUP:(UIButton *)sender{
   ;
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];

    NSString *str2 = [NSString stringWithFormat:@"%@%@%@",[self.endDate.titleLabel.text substringToIndex:4],[self.endDate.titleLabel.text substringWithRange:NSMakeRange(5, 2)],[self.endDate.titleLabel.text substringWithRange:NSMakeRange(8, 2)]];
    NSString *str3 = [NSString stringWithFormat:@"%@%@%@",[self.starDate.titleLabel.text substringToIndex:4],[self.starDate.titleLabel.text substringWithRange:NSMakeRange(5, 2)],[self.starDate.titleLabel.text substringWithRange:NSMakeRange(8, 2)]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [AMSystemManager interfaceAttendanceReportInfos:[userdefaults stringForKey:@"KEY"] beginDate:str3 endDate:str2 complation:^(id obj) {
            MyLog(@"%@",obj);
            
            self.array = [MyJsonParser parseAReportByarr:obj];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self tableviewUP];
                datePicker.hidden = YES;
                self.areportTableview.hidden = NO;
                self.button.hidden = YES;
            });
            
        }];

    });
    
}
- (void)viewWillAppear:(BOOL)animated
{
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setLocale:[NSLocale systemLocale]];//[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    datePicker = [[JCDatePicker alloc] initWithFrame:CGRectMake(10, self.myTopView.bounds.size.height+25, self.view.frame.size.width-20,self.view.frame.size.height-180)];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
