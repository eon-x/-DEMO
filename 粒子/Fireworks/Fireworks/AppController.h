/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Create a fireworks simulation using particles, respond to user actions
 */

@import Cocoa;
@import QuartzCore;

@interface AppController : NSObject {
	IBOutlet NSView *theView;
	CALayer *rootLayer;
	CAEmitterLayer *mortor;
	IBOutlet NSSlider *rocketRange;
	IBOutlet NSSlider *fireworkRange;
	IBOutlet NSSlider *fireworkVelocity;
	IBOutlet NSSlider *fireworkVelocityRange;
	IBOutlet NSSlider *rocketVelocity;
	IBOutlet NSSlider *rocketVelocityRange;
	IBOutlet NSSlider *fireworkGravity;
	IBOutlet NSSlider *rocketGravity;
	IBOutlet NSSlider *animationSpeed;
}

@end
