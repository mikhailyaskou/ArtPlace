//
//  YMAPinAnnotationDetailed.h
//  ArtPlace
//
//  Created by Mikhail Yaskou on 11.08.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface YMAPinAnnotationDetailed : MKPointAnnotation

@property (strong, nonatomic) NSString *detailedInformation;

@end
