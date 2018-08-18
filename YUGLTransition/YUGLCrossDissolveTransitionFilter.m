//
//  YUGLViewControllerTransitionCrossDissolveFilter.m
//  YUGLViewControllerTransitionDemo
//
//  Created by YuAo on 1/17/14.
//  Copyright (c) 2014 YuAo. All rights reserved.
//

#import "YUGLCrossDissolveTransitionFilter.h"

@implementation YUGLCrossDissolveTransitionFilter

- (CGFloat)progress {
    return self.mix;
}

- (void)setProgress:(CGFloat)progress {
    self.mix = progress;
}

@end
