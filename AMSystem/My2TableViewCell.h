//
//  my2TableViewCell.h
//  AMSystem
//
//  Created by 徐晓斐 on 14-9-24.
//  Copyright (c) 2014年 GZDEU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PeoperData.h"
@interface My2TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *adrress;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *depyname;
@property (strong ,nonatomic)PeoperData *person;
@property (strong, nonatomic) IBOutlet UIImageView *MyImage;

@end
