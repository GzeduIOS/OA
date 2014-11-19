//
//  AttendanceViewController.m
//  AMSystem
//
//  Created by 徐晓斐 on 14-9-17.
//  Copyright (c) 2014年 GZDEU. All rights reserved.
//

#import "AttendanceViewController.h"
#import "DetailsViewController.h"
#import "MyCell.h"
#import "PeoperData.h"
#import "MyJsonParser.h"
#import "AMSystemManager.h"
@interface AttendanceViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) NSArray *array;
@property (strong,nonatomic)NSDictionary* Dic;
@end

@implementation AttendanceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"签到情况";
    self.array = [MyJsonParser parseAttendByarr:self.AttendanceArr];
    self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];////UITableView隐藏多余的分割线
  
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    if (self.array.count == 0) {
         [self.myTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        return 1;
    }else{
        return self.array.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    static NSString *CellIdentifier = @"Cell";
    
    MyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        
        cell = [[MyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (self.array.count==0) {
        cell = [[MyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = @"暂无数据";
    }else{
        PeoperData *Data = self.array[indexPath.row];
        
        cell.perper2 = Data;

    }
    
    return cell;
 
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.array.count != 0) {
        
        PeoperData *Data = self.array[indexPath.row];
        NSString *strID = Data.attendanceId;
        DetailsViewController *detaiVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"attSugue"];
        detaiVC.STRid = strID;
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] init];
        backBarButtonItem.title = @"";
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationItem.backBarButtonItem = backBarButtonItem;
        [self.navigationController pushViewController:detaiVC animated:YES];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
- (IBAction)back:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
