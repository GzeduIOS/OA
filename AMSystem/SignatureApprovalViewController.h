//
//  SignatureApprovalViewController.h
//  AMSystem
//
//  Created by 徐晓斐 on 14-9-24.
//  Copyright (c) 2014年 GZDEU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myReachability.h"
@interface SignatureApprovalViewController : UIViewController<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    //数据部分
    NSArray *notApproveDataAry;
    NSArray *approvedDataAry;
    
}
@property (weak, nonatomic) IBOutlet UILabel *TintLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (weak, nonatomic) IBOutlet UIProgressView *Progress;

@property NSDictionary *userInfoDictionary;
@property NSString *segueId;
@property NSString *viewTitle;
@end
