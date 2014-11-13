//
//  MyTableViewCell.m
//  AMSystem
//
//  Created by 徐晓斐 on 14-9-19.
//  Copyright (c) 2014年 GZDEU. All rights reserved.
//

#import "MyTableViewCell.h"
//#import "LeaveAndApproveViewController.h"
@implementation MyTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)awakeFromNib
{
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.name.text = self.peoper.name;
    self.time.text = [NSString stringWithFormat:@"%@至%@",[self.peoper.applyBeginDate substringToIndex:10],[self.peoper.applyEndDate substringToIndex:10]];
    self.type.text = self.peoper.applyType;
    self.dypename.text = self.peoper.deptName; 
}
@end
