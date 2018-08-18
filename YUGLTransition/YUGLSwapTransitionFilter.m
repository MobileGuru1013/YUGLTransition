//
//  YUGLViewControllerTransitionSwapFilter.m
//  YUGLViewControllerTransitionDemo
//
//  Created by YuAo on 1/17/14.
//  Copyright (c) 2014 YuAo. All rights reserved.
//

#import "YUGLSwapTransitionFilter.h"

NSString *const YUGLSwapTransitionFilterFragmentShaderString = SHADER_STRING
(
 precision highp float;
 
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 uniform float progress;
 
 uniform float reflection;
 uniform float perspective;
 uniform float depth;
 
 const vec4 black = vec4(0.0, 0.0, 0.0, 1.0);
 const vec2 boundMin = vec2(0.0, 0.0);
 const vec2 boundMax = vec2(1.0, 1.0);
 
 vec2 project (vec2 p) {
     return p * vec2(1.0, -1.0) + vec2(0.0, 2.01);
 }
 
 int inBounds (vec2 p) {
     if(all(lessThan(boundMin, p)) && all(lessThan(p, boundMax))){
         return 1;
     } else {
         return 0;
     }
 }
 
 vec4 bgColor (vec2 p, vec2 pfr, vec2 pto) {
     vec4 c = black;
     pfr = project(pfr);
     if (inBounds(pfr) > 0) {
         c += mix(black, texture2D(inputImageTexture, pfr), reflection * mix(0.0, 1.0, pfr.y));
     }
     pto = project(pto);
     if (inBounds(pto) > 0) {
         c += mix(black, texture2D(inputImageTexture2, pto), reflection * mix(0.0, 1.0, pto.y));
     }
     return c;
 }
 
 void main() {
     vec2 p = textureCoordinate;
     
     vec2 pfr = vec2(-1.);
     vec2 pto = vec2(-1.);
     
     float size = mix(1.0, depth, progress);
     float persp = perspective * progress;
     pfr = (p + vec2(-0.0, -0.5)) * vec2(size/(1.0-perspective*progress), size/(1.0-size*persp*p.x)) + vec2(0.0, 0.5);
     
     size = mix(1.0, depth, 1.-progress);
     persp = perspective * (1.-progress);
     pto = (p + vec2(-1.0, -0.5)) * vec2(size/(1.0-perspective*(1.0-progress)), size/(1.0-size*persp*(0.5-p.x))) + vec2(1.0, 0.5);
     
     if (progress < 0.5) {
         if (inBounds(pfr) > 0) {
             gl_FragColor = texture2D(inputImageTexture, pfr);
         }
         else if (inBounds(pto) > 0) {
             gl_FragColor = texture2D(inputImageTexture2, pto);
         }
         else {
             gl_FragColor = bgColor(p, pfr, pto);
         }
     }
     else {
         if (inBounds(pto) > 0) {
             gl_FragColor = texture2D(inputImageTexture2, pto);
         }
         else if (inBounds(pfr) > 0) {
             gl_FragColor = texture2D(inputImageTexture, pfr);
         }
         else {
             gl_FragColor = bgColor(p, pfr, pto);
         }
     }
 }
);

@interface YUGLSwapTransitionFilter ()
@property (nonatomic) GLint progressUniform;
@property (nonatomic) GLint reflectionUniform;
@property (nonatomic) GLint perspectiveUniform;
@property (nonatomic) GLint depthUniform;
@end

@implementation YUGLSwapTransitionFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:YUGLSwapTransitionFilterFragmentShaderString]))
    {
		return nil;
    }
    self.progressUniform = [filterProgram uniformIndex:@"progress"];
    self.reflectionUniform = [filterProgram uniformIndex:@"reflection"];
    self.perspectiveUniform = [filterProgram uniformIndex:@"perspective"];
    self.depthUniform = [filterProgram uniformIndex:@"depth"];
    
    self.progress = 0;
    self.reflection = 0.3;
    self.perspective = 0.4;
    self.depth = 3.0;
    
    return self;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setFloat:progress forUniform:self.progressUniform program:filterProgram];
}

- (void)setReflection:(CGFloat)reflection {
    _reflection = reflection;
    [self setFloat:reflection forUniform:self.reflectionUniform program:filterProgram];
}

- (void)setPerspective:(CGFloat)perspective {
    _perspective = perspective;
    [self setFloat:perspective forUniform:self.perspectiveUniform program:filterProgram];
}

- (void)setDepth:(CGFloat)depth{
    _depth = depth;
    [self setFloat:depth forUniform:self.depthUniform program:filterProgram];
}

@end
