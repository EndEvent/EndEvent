//
//  ZYZMyCollectionCell.m
//  美食菜谱
//
//  Created by Jarvan on 15/12/24.
//  Copyright (c) 2015年 Jarvan. All rights reserved.
//

#import "ZYZMyCollectionCell.h"


@interface ZYZMyCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *caipinImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *myDetailLabel;
@end


@implementation ZYZMyCollectionCell

- (void)setCellWithModel:(ZYZCollectModel *)model{
    
    self.bgImageView.layer.cornerRadius = 8.0;
    self.bgImageView.clipsToBounds = YES;

    [self.caipinImageView sd_setImageWithURL:[NSURL URLWithString:model.thumb_2] placeholderImage:[UIImage imageNamed:@"placeholder-iPad"]];
    self.caipinImageView.layer.cornerRadius = 8.0;
    self.caipinImageView.clipsToBounds = YES;
    
    self.titleLabel.text = model.title;
    self.myDetailLabel.text = model.yingyang;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
