//
//  KeyboardToolbarView.m
//  DPredictor
//
//  Created by Joshua Primas on 4/21/14.
//  Copyright (c) 2014 Joshua Primas. All rights reserved.
//

#import "KeyboardToolbarView.h"
#import "BorderButton.h"

@implementation KeyboardToolbarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
        [self setAlpha: 1.0];
        
        self.doneButton = [[BorderButton alloc] init];
        [self.doneButton setFrame:CGRectMake(220.0f, 9.0f, 70.0f, 23.0f)];
        NSString *title = @"Done";
        [self.doneButton setTitle:title forState:UIControlStateNormal];
        
        [self addSubview:self.doneButton];
    }
    return self;
}

@end
