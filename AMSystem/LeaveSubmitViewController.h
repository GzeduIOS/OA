//
//  leverlViewController.h
//  AMSystem
//
//  Created by 徐晓斐 on 14-9-22.
//  Copyright (c) 2014年 GZDEU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSYPopoverListView.h"
#import "myReachability.h"

@interface LeaveSubmitViewController : UIViewController<ZSYPopoverListDatasource,ZSYPopoverListDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UILabel *myLabel;
@property (weak, nonatomic) IBOutlet UIButton *Uploadbtn;
@property (strong, nonatomic) IBOutlet UITextView *MyTextView;
@end
