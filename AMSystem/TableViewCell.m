//
//  TableViewCell.m
//  AMSystem
//
//  Created by 徐晓斐 on 14-10-14.
//  Copyright (c) 2014年 GZDEU. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib
{
    // Initialization code
}
-(void)layoutSubviews{
    // [super layoutSubviews];
    self.name.text = self.per.AReportname;
    self.right.text = self.per.normal_num;
    self.unusual.text = self.per.exception_num;
   
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
