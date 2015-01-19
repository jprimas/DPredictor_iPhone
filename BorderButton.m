//
//  BorderButton.m
//  DPredictor
//
//  Created by Joshua Primas on 4/17/14.
//  Copyright (c) 2014 Joshua Primas. All rights reserved.
//

#import "BorderButton.h"

@interface BorderButton ()

@property (strong,nonatomic)  CALayer *highlightBackgroundLayer;

@end

@implementation BorderButton


-(id) init{
    self = [super init];
    
    if (self)
    {
        [self drawButton];
        [self drawHighlightBackgroundLayer];
        
        _highlightBackgroundLayer.hidden = YES;
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    if (self)
    {
        [self drawButton];
        [self drawHighlightBackgroundLayer];
        
        _highlightBackgroundLayer.hidden = YES;
    }
    
    return self;
}

- (void)drawButton
{
    CALayer *layer = self.layer;
    
    layer.cornerRadius = 2.0f;
    layer.borderWidth = 0;
    layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:82/255.0 blue:235/255.0 alpha:1].CGColor;
    [super setTitleColor:[UIColor colorWithRed:0/255.0 green:82/255.0 blue:235/255.0 alpha:1] forState:UIControlStateHighlighted];
    [super setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)drawHighlightBackgroundLayer
{
    if (!_highlightBackgroundLayer)
    {
        _highlightBackgroundLayer = [CALayer layer];
        
        _highlightBackgroundLayer.backgroundColor = [UIColor whiteColor].CGColor;//[UIColor colorWithRed:78/255.0 green:136/255.0 blue:241/255.0 alpha:1].CGColor;
        _highlightBackgroundLayer.cornerRadius = 2.0f;
        _highlightBackgroundLayer.borderColor =
            [UIColor colorWithRed:0/255.0 green:82/255.0 blue:235/255.0 alpha:1].CGColor;
        _highlightBackgroundLayer.borderWidth = 1;
        
        [self.layer insertSublayer:_highlightBackgroundLayer atIndex:0];
    }
}

- (void)layoutSubviews{
    _highlightBackgroundLayer.frame = self.bounds;
    
    [super layoutSubviews];
    if (self.state == UIControlStateHighlighted) {
        self.titleLabel.alpha = 1.0;
    }
}

- (void)setHighlighted:(BOOL)highlighted
{
    _highlightBackgroundLayer.hidden = !highlighted;
    
    [super setHighlighted:highlighted];
}


@end
