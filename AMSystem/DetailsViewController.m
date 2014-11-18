//
//  DetailsViewController.m
//  AMSystem
//
//  Created by 徐晓斐 on 14-9-17.
//  Copyright (c) 2014年 GZDEU. All rights reserved.
//

#import "DetailsViewController.h"
#import "AMSystemManager.h"
@interface DetailsViewController ()
@end

@implementation DetailsViewController

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
    self.title = @"考勤详情";
     self.userdefaults = [NSUserDefaults standardUserDefaults];
    [AMSystemManager interfaceAttendanceDetail:[self.userdefaults stringForKey:@"KEY"] userId:self.STRid complation:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (![obj[@"data"][@"SIGN_DATE"] isEqual:[NSNull null]]) {
                self.timeLabel.text = obj[@"data"][@"SIGN_DATE"];
                
            }else{
                MyLog(@"1");
            }
            if (![obj[@"data"][@"SIGN_ADDRESS"] isEqual:[NSNull null]]) {
                self.addrlabel.text = obj[@"data"][@"SIGN_ADDRESS"];
                
            }else{
                MyLog(@"2");
            }
            if (![obj[@"data"][@"SIGN_TYPE"] isEqual:[NSNull null]]) {
                self.typeLabel.text = obj[@"data"][@"SIGN_TYPE"];
                
            }else{
                MyLog(@"3");
            }
            if (![obj[@"data"][@"AUDIT_STATUS"] isEqual:[NSNull null]]) {
                if ([@"O"isEqualToString:obj[@"data"][@"AUDIT_STATUS"]]) {
                    self.statusLabel.text = @"异常";
                }else{
                    self.statusLabel.text = @"正常";
                }
                
            }
            if (![obj[@"data"][@"PIC"] isEqual:[NSNull null]]) {
                NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:obj[@"data"][@"PIC"]]];
                self.photoimage.image = [UIImage imageWithData:data];
            }else{
               self.photoimage.image = [UIImage imageNamed:@""];
            }

        });
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
