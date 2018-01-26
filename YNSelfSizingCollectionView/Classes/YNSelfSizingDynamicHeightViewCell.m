//
//  YNSelfSizingDynamicHeightViewCell.m
//  YNSelfSizingCollectionView
//
//  Created by wangya on 2018/1/26.
//  Copyright © 2018年 Yanni. All rights reserved.
//

#import "YNSelfSizingDynamicHeightViewCell.h"

@interface YNSelfSizingDynamicHeightViewCell()
@property (nonatomic, strong) NSLayoutConstraint *heightOrBottomLayoutConstraint;
@end

@implementation YNSelfSizingDynamicHeightViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addConstraints:({
            NSMutableArray<NSLayoutConstraint *> *constraint = [[NSMutableArray<NSLayoutConstraint *> alloc] init];
            [constraint addObject:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
            [constraint addObject:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
            constraint;
        })];
        
        [self.contentView addConstraints:({
            NSMutableArray<NSLayoutConstraint *> *constraint = [[NSMutableArray<NSLayoutConstraint *> alloc] init];
            [constraint addObject:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:frame.size.width]];
            constraint;
        })];
    }
    return self;
}

-(void)updateConstraints{
    if (self.heightOrBottomLayoutConstraint) {
        [self removeConstraint:self.heightOrBottomLayoutConstraint];
        self.heightOrBottomLayoutConstraint = nil;
    }
    if (!self.dynamicHeightAlignView) {
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:0];
        [self.contentView addConstraint:heightConstraint];
        self.heightOrBottomLayoutConstraint = heightConstraint;
    }else{
        NSLayoutConstraint *bottomLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.dynamicHeightAlignView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:self.dynamicHeightAlignOffset];
        [self.contentView addConstraint:bottomLayoutConstraint];
        self.heightOrBottomLayoutConstraint = bottomLayoutConstraint;
    }
    [super updateConstraints];
}
@end
