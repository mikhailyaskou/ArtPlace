//
//  ViewController.m
//  ArtPlace
//
//  Created by Mikhail Yaskou on 11.08.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMAArtPlaceVC.h"
#import "YMAPinAnnotationDetailed.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

static NSString *const YMAJsonKeyData = @"data";
static NSString *const YMAReuseIdentifier = @"pinLocation";
static NSString *const YMANoDetailsError = @"Sorry, there no details info";
static NSString *const YMAAlertTitle = @"Details";
static NSString *const YMAOkTitle = @"OK";
static NSString *const YMAJsonFileName = @"PublicArt";
static NSString *const YMAJsonFileNameExtension = @"json";
static const NSInteger YMAJsonLatitude = 18;
static const NSInteger YMAJsonLongitude = 19;
static const NSInteger YMAJsonTitle = 11;
static const NSInteger YMAJsonSubtitle = 15;
static const NSInteger YMAJsonDetailInfo1 = 8;
static const NSInteger YMAJsonDetailInfo2 = 10;
static const NSInteger YMAJsonDetailInfo3 = 16;

@interface YMAArtPlaceVC () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSArray *artDataArray;

@end

@implementation YMAArtPlaceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [CLLocationManager new];
    //request permission
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
       [self.locationManager requestAlwaysAuthorization];
    }
    //read file
    NSString *filePath = [[NSBundle mainBundle] pathForResource:YMAJsonFileName ofType:YMAJsonFileNameExtension];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *fllInfo = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    self.artDataArray = fllInfo[YMAJsonKeyData];
    //place pins
    for (int i = 0; i< self.artDataArray.count; i++){
        YMAPinAnnotationDetailed *myAnnotation = [YMAPinAnnotationDetailed new];
        myAnnotation.coordinate = CLLocationCoordinate2DMake([self.artDataArray[i][YMAJsonLatitude] doubleValue], [self.artDataArray[i][YMAJsonLongitude] doubleValue]);
        myAnnotation.title = [NSString stringWithFormat:@"%@", self.artDataArray[i][YMAJsonTitle]];
        myAnnotation.subtitle = [NSString stringWithFormat:@"%@", self.artDataArray[i][YMAJsonSubtitle]];
        myAnnotation.detailedInformation = [NSString stringWithFormat:@"%@, %@, %@, %@, %@, ", self.artDataArray[i][YMAJsonDetailInfo1], self.artDataArray[i][YMAJsonDetailInfo2], self.artDataArray[i][YMAJsonTitle], self.artDataArray[i][YMAJsonSubtitle], self.artDataArray[i][YMAJsonDetailInfo3]];
        [self.mapView addAnnotation:myAnnotation];
    }
}

#pragma mark - Actions

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    NSString *message;
    if ([view.annotation isMemberOfClass:[YMAPinAnnotationDetailed class]]){
        YMAPinAnnotationDetailed *annotation = view.annotation;
        message = view.annotation.detailedInformation;
    }
    else {
        message = YMANoDetailsError;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:YMAAlertTitle
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:YMAOkTitle style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)mapTypeTapped:(id)sender {
    self.mapView.mapType = [sender tag];
}

- (IBAction)findMeTapped:(id)sender {
    [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation {
    MKPinAnnotationView *newAnnotation =
        [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:YMAReuseIdentifier];
    newAnnotation.canShowCallout = YES;
    newAnnotation.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return newAnnotation;
}

@end
