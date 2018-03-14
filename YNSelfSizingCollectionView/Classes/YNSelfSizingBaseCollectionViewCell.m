//
//  YNSelfSizingBaseCollectionViewCell.m
//  YNSelfSizingCollectionView
//
//  Created by wangya on 2018/1/29.
//  Copyright © 2018年 Yanni. All rights reserved.
//

#import "YNSelfSizingBaseCollectionViewCell.h"

@interface YNSelfSizingBaseCollectionViewCell()
@property (nonatomic, copy) NSArray *contentViewConstraints;
@end

@implementation YNSelfSizingBaseCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        self.contentView.clipsToBounds = YES;
        // left
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        [self addConstraint:left];
        
        // top
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        [self addConstraint:top];
    }
    return self;
}

-(void)addSubview:(UIView *)view{
    [super addSubview:view];
    NSAssert(self.contentView == view, @"must add subviews to self.contentView");
}

-(void)updateConstraints{
    if (self.contentViewConstraints) {
        [self.contentView removeConstraints:self.contentViewConstraints];
        self.contentViewConstraints = nil;
    }
    NSArray *contentViewConstraints = [self generateConstraints];
    [self.contentView addConstraints:contentViewConstraints];
    self.contentViewConstraints = contentViewConstraints;
    [super updateConstraints];
}

#pragma private

-(NSArray*)generateConstraints{
    NSMutableArray *array = [NSMutableArray array];
    switch ([self type]) {
        case YNSelfSizingBaseCollectionViewCellTypeFixedWidthAndHeight:{
            NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:[self fixedWidth]];
            [array addObject:width];
            NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:[self fixedHeight]];
            [array addObject:height];
            break;
        }
        case YNSelfSizingBaseCollectionViewCellTypeFixedWidth:{
            // width
            NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:[self fixedWidth]];
            [array addObject:width];
            
            if (![self alignView]) {
                NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:0];
                [array addObject:height];
            }else{
                NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:[self alignView] attribute:NSLayoutAttributeBottom multiplier:1.0 constant:[self alignOffset]];
                [array addObject:bottom];
            }
            break;
        }
        case YNSelfSizingBaseCollectionViewCellTypeFixedHeight:{
            // height
            NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:[self fixedHeight]];
            [array addObject:height];
            
            if (![self alignView]) {
                NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:0];
                [array addObject:width];
            }else{
                NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:[self alignView] attribute:NSLayoutAttributeRight multiplier:1.0 constant:[self alignOffset]];
                [array addObject:right];
            }
            break;
        }
        default:{
            NSAssert(NO, @"type invalid");
            break;
        }
    }
    return array;
}


#pragma public

-(YNSelfSizingBaseCollectionViewCellType) type{
    return YNSelfSizingBaseCollectionViewCellTypeFixedWidthAndHeight;
}

-(CGFloat)fixedWidth{
    return 0;
}

-(CGFloat)fixedHeight{
    return 0;
}

-(UIView*)alignView{
    return nil;
}

-(CGFloat)alignOffset{
    return 0;
}

@end

