/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Create a fireworks simulation using particles, respond to user actions
 */

#import "AppController.h"

@implementation AppController

- (void)awakeFromNib {
	//Create the root layer
	rootLayer = [CALayer layer];
	
	//Set the root layer's attributes
	rootLayer.bounds = CGRectMake(0, 0, 640, 480);
	CGColorRef color = CGColorCreateGenericRGB(0.0, 0.0, 0.0, 1);
	rootLayer.backgroundColor = color;
	CGColorRelease(color);
	
	//Load the spark image for the particle
    NSImage *image = [NSImage imageNamed:@"tspark"];
    CGImageRef img = [image CGImageForProposedRect:nil context:nil hints:nil];

    mortor = [CAEmitterLayer layer];
	mortor.emitterPosition = CGPointMake(320, 0);
	mortor.renderMode = kCAEmitterLayerAdditive;
	
	//Invisible particle representing the rocket before the explosion
	CAEmitterCell *rocket = [CAEmitterCell emitterCell];
	rocket.emissionLongitude = M_PI / 2;
	rocket.emissionLatitude = 0;
	rocket.lifetime = 1.6;
	rocket.birthRate = 1;
	rocket.velocity = 400;
	rocket.velocityRange = 100;
	rocket.yAcceleration = -250;
	rocket.emissionRange = M_PI / 4;
	color = CGColorCreateGenericRGB(0.5, 0.5, 0.5, 0.5);
	rocket.color = color;
	CGColorRelease(color);
	rocket.redRange = 0.5;
	rocket.greenRange = 0.5;
	rocket.blueRange = 0.5;
	
	//Name the cell so that it can be animated later using keypath
	rocket.name = @"rocket";
	
	//Flare particles emitted from the rocket as it flys
	CAEmitterCell *flare = [CAEmitterCell emitterCell];
	flare.contents = (__bridge id)img;
	flare.emissionLongitude = (4 * M_PI) / 2;
	flare.scale = 0.4;
	flare.velocity = 100;
	flare.birthRate = 45;
	flare.lifetime = 1.5;
	flare.yAcceleration = -350;
	flare.emissionRange = M_PI / 7;
	flare.alphaSpeed = -0.7;
	flare.scaleSpeed = -0.1;
	flare.scaleRange = 0.1;
	flare.beginTime = 0.01;
	flare.duration = 0.7;
	
	//The particles that make up the explosion
	CAEmitterCell *firework = [CAEmitterCell emitterCell];
	firework.contents = (__bridge id)img;
	firework.birthRate = 9999;
	firework.scale = 0.6;
	firework.velocity = 130;
	firework.lifetime = 2;
	firework.alphaSpeed = -0.2;
	firework.yAcceleration = -80;
	firework.beginTime = 1.5;
	firework.duration = 0.1;
	firework.emissionRange = 2 * M_PI;
	firework.scaleSpeed = -0.1;
	firework.spin = 2;
	
	//Name the cell so that it can be animated later using keypath
	firework.name = @"firework";
	
	//preSpark is an invisible particle used to later emit the spark
	CAEmitterCell *preSpark = [CAEmitterCell emitterCell];
	preSpark.birthRate = 80;
	preSpark.velocity = firework.velocity * 0.70;
	preSpark.lifetime = 1.7;
	preSpark.yAcceleration = firework.yAcceleration * 0.85;
	preSpark.beginTime = firework.beginTime - 0.2;
	preSpark.emissionRange = firework.emissionRange;
	preSpark.greenSpeed = 100;
	preSpark.blueSpeed = 100;
	preSpark.redSpeed = 100;
	
	//Name the cell so that it can be animated later using keypath
	preSpark.name = @"preSpark";
	
	//The 'sparkle' at the end of a firework
	CAEmitterCell *spark = [CAEmitterCell emitterCell];
	spark.contents = (__bridge id)img;
	spark.lifetime = 0.05;
	spark.yAcceleration = -250;
	spark.beginTime = 0.8;
	spark.scale = 0.4;
	spark.birthRate = 10;
	
	preSpark.emitterCells = @[spark];
	rocket.emitterCells = @[flare, firework, preSpark];
	mortor.emitterCells = @[rocket];
	[rootLayer addSublayer:mortor];
	
	//Set the view's layer to the base layer
	theView.layer = rootLayer;
	[theView setWantsLayer:YES];
	
	//Force the view to update
	[theView setNeedsDisplay:YES];
}

// Update particle properites based on the slider values
- (IBAction)slidersMoved:(id)sender {
	[mortor setValue:[NSNumber numberWithFloat:rocketRange.floatValue * M_PI / 4] 
		  forKeyPath:@"emitterCells.rocket.emissionRange"]; 
	
	[mortor setValue:@(rocketVelocity.floatValue)
		  forKeyPath:@"emitterCells.rocket.velocity"];
	
	[mortor setValue:@(rocketVelocityRange.floatValue)
		  forKeyPath:@"emitterCells.rocket.velocityRange"];
	
	[mortor setValue:@(-1 * rocketGravity.floatValue)
		  forKeyPath:@"emitterCells.rocket.yAcceleration"];
	
	[mortor setValue:[NSNumber numberWithFloat:fireworkRange.floatValue * M_PI / 4]
		  forKeyPath:@"emitterCells.rocket.emitterCells.firework.emissionRange"]; 
	
	[mortor setValue:@(fireworkVelocity.floatValue)
		  forKeyPath:@"emitterCells.rocket.emitterCells.firework.velocity"];
	
	[mortor setValue:@(fireworkVelocityRange.floatValue)
		  forKeyPath:@"emitterCells.rocket.emitterCells.firework.velocityRange"];
	
	[mortor setValue:@(-1 * fireworkGravity.floatValue)
		  forKeyPath:@"emitterCells.rocket.emitterCells.firework.yAcceleration"];
	
	[mortor setValue:[NSNumber numberWithFloat:fireworkVelocity.floatValue * 0.70]
		  forKeyPath:@"emitterCells.rocket.emitterCells.preSpark.velocity"];
	
	[mortor setValue:[NSNumber numberWithFloat:fireworkGravity.floatValue * -0.85]
		  forKeyPath:@"emitterCells.rocket.emitterCells.preSpark.yAcceleration"];
	
	[mortor setValue:[NSNumber numberWithFloat:fireworkRange.floatValue * M_PI / 4]
		  forKeyPath:@"emitterCells.rocket.emitterCells.preSpark.emissionRange"];
	
	mortor.speed = animationSpeed.floatValue / 100.0;
}

// Reset the slider positions to the default values
- (IBAction)resetSliders:(id)sender {
	rocketRange.intValue = 1;
	rocketVelocity.intValue = 400;
	rocketVelocityRange.intValue = 100;
	rocketGravity.intValue = 250;
	
	fireworkRange.intValue = 8;
	fireworkVelocity.intValue = 130;
	fireworkVelocityRange.intValue = 0;
	fireworkGravity.intValue = 80;
	
	animationSpeed.intValue = 100;
	
	[self slidersMoved:self]; 
}

@end
