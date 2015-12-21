//
//  ZYZTopTableViewCell.m
//  美食菜谱
//
//  Created by Jarvan on 15/12/21.
//  Copyright (c) 2015年 Jarvan. All rights reserved.
//

#import "ZYZTopTableViewCell.h"

@interface ZYZTopTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *caipinImgeView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ZYZTopTableViewCell

- (void)setCellWithModel:(ZYZTopModel *)model{
    self.bgImageView.layer.cornerRadius = 8.0;
    [self.caipinImgeView sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"placeholder_Phone"]];
    self.caipinImgeView.layer.cornerRadius = 8.0;
    self.caipinImgeView.clipsToBounds = YES;
    self.titleLabel.text = model.title;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
