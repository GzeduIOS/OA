//
//  MyCell.m
//  AMSystem
//
//  Created by 徐晓斐 on 14-9-17.
//  Copyright (c) 2014年 GZDEU. All rights reserved.
//

#import "MyCell.h"

@implementation MyCell

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
-(void)layoutSubviews{
 
    [super layoutSubviews];
    
    self.name.text = self.perper2.attname;
    self.addr.text = self.perper2.signaddres;
    self.time.text = self.perper2.signdate;
    self.type.text = self.perper2.signtype;
    self.name2.text = self.perper2.deptname;
    self.image.image = self.perper2.pic;
    

    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
