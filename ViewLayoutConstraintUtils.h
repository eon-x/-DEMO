//
//  ViewLayoutConstraintMacro.h
//  IDOVFPDetail
//
//  Created by Marc Zhao on 2018/8/27.
//  Copyright © 2018年 hedongyang. All rights reserved.
//




#pragma mark - Constraints
#define PREPCONSTRAINTS(VIEW) [VIEW setTranslatesAutoresizingMaskIntoConstraints:NO]
#define CONSTRAIN(PARENT, VIEW, FORMAT) [PARENT addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:(FORMAT) options:0 metrics:nil views:NSDictionaryOfVariableBindings(VIEW)]]
#define CONSTRAIN_VIEWS(PARENT, FORMAT, VIEWBINDINGS) [PARENT addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:(FORMAT) options:0 metrics:nil views:VIEWBINDINGS]]
#define CONSTRAINTS(FORMAT, VIEWBINDINGS) [NSLayoutConstraint constraintsWithVisualFormat:(FORMAT) options:0 metrics:nil views:VIEWBINDINGS]

// Stretch across axis
#define STRETCH_VIEW_H(PARENT, VIEW) CONSTRAIN(PARENT, VIEW, @"H:|["#VIEW"(>=0)]|")
#define STRETCH_VIEW_V(PARENT, VIEW) CONSTRAIN(PARENT, VIEW, @"V:|["#VIEW"(>=0)]|")
#define STRETCH_VIEW(PARENT, VIEW) {STRETCH_VIEW_H(PARENT, VIEW); STRETCH_VIEW_V(PARENT, VIEW);}

// Center along axis
#define CENTER_VIEW_H(PARENT, VIEW) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]]
#define CENTER_VIEW_V(PARENT, VIEW) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]]
#define CENTER_VIEW(PARENT, VIEW) {CENTER_VIEW_H(PARENT, VIEW); CENTER_VIEW_V(PARENT, VIEW);}

// Align to parent
#define ALIGN_VIEW_LEFT(PARENT, VIEW) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f]]
#define ALIGN_VIEW_RIGHT(PARENT, VIEW) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f]]
#define ALIGN_VIEW_TOP(PARENT, VIEW) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]]
#define ALIGN_VIEW_BOTTOM(PARENT, VIEW) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f]]
#define ALIGN_VIEW_LEFT_CONSTANT(PARENT, VIEW, CONSTANT) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeLeft multiplier:1.0f constant:CONSTANT]]
#define ALIGN_VIEW_RIGHT_CONSTANT(PARENT, VIEW, CONSTANT) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeRight multiplier:1.0f constant:CONSTANT]]
#define ALIGN_VIEW_TOP_CONSTANT(PARENT, VIEW, CONSTANT) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeTop multiplier:1.0f constant:CONSTANT]]
#define ALIGN_VIEW_BOTTOM_CONSTANT(PARENT, VIEW, CONSTANT) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeBottom multiplier:1.0f constant:CONSTANT]]


// Set Size
#define CONSTRAIN_WIDTH(VIEW, WIDTH) [VIEW addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:WIDTH]];
#define CONSTRAIN_HEIGHT(VIEW, HEIGHT) [VIEW addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:HEIGHT]];
#define CONSTRAIN_SIZE(VIEW, HEIGHT, WIDTH) {CONSTRAIN_WIDTH(VIEW, WIDTH); CONSTRAIN_HEIGHT(VIEW, HEIGHT);}

// Set Aspect
#define CONSTRAIN_ASPECT(VIEW, ASPECT) [VIEW addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:VIEW attribute:NSLayoutAttributeHeight multiplier:(ASPECT) constant:0.0f]]




