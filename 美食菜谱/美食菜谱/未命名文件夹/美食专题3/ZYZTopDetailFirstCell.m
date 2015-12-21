//
//  ZYZTopDetailFirstCell.m
//  美食菜谱
//
//  Created by Jarvan on 15/12/21.
//  Copyright (c) 2015年 Jarvan. All rights reserved.
//

#import "ZYZTopDetailFirstCell.h"

@interface ZYZTopDetailFirstCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *caipinImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *myTextView;
@end

@implementation ZYZTopDetailFirstCell

- (void)setCellWithModel:(ZYZTopDetailModel *)model{
    
    self.bgImageView.layer.cornerRadius = 8.0;
    [self.caipinImageView sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"placeholder_Phone"]];
    self.caipinImageView.layer.cornerRadius = 8.0;
    self.caipinImageView.clipsToBounds = YES;
    self.titleLabel.text = model.title;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.myTextView.text = model.jianjie;
    self.myTextView.font = [UIFont systemFontOfSize:14];
    self.myTextView.layer.cornerRadius = 8.0;
    // 禁止textview弹出键盘
    self.myTextView.editable = NO;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
