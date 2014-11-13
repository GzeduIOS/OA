//
//  AQueryViewController.h
//  AMSystem
//
//  Created by 徐晓斐 on 14-9-5.
//  Copyright (c) 2014年 GZDEU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VRGCalendarView.h"
@interface AQueryViewController : UIViewController<VRGCalendarViewDelegate>
@property (nonatomic,strong)NSString *key;
@end
