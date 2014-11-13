//
//  MyTableViewCell.h
//  AMSystem
//
//  Created by 徐晓斐 on 14-9-19.
//  Copyright (c) 2014年 GZDEU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PeoperData.h"
@interface MyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *dypename;
@property (strong ,nonatomic)PeoperData *peoper;
@property (strong, nonatomic) IBOutlet UIButton *select;
@property (strong , nonatomic)NSMutableArray *nsArray;
@end
