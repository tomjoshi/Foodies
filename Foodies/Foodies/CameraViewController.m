//
//  CameraViewController.m
//  Foodies
//
//  Created by Lucas Chwe on 2/25/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "CameraViewController.h"
#import <DBCameraViewController.h>
#import "CustomCamera.h"
#import "albumThumbCollectionViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <ALAssetsLibrary+CustomPhotoAlbum.h>
#import "PostFormTableViewController.h"
#import "NSMutableDictionary+ImageMetadata.h"
#import "ALAsset+Date.h"
#import <CoreLocation/CoreLocation.h>
#import <ImageIO/CGImageProperties.h>

@interface CameraViewController () <DBCameraViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;
@property (weak, nonatomic) IBOutlet UIView *scrollHandle;
@property (weak, nonatomic) IBOutlet UICollectionView *albumCollectionView;
@property (weak, nonatomic) IBOutlet UIView *previewView;
@property (strong, nonatomic) ALAsset *previewImageAsset;
@property (nonatomic, strong) NSArray *assets;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) NSInteger imageCounter;
@property (nonatomic) NSInteger amountOfAssets;

- (void)layoutCameraView;
- (IBAction)nextTapped:(id)sender;
- (IBAction)cancelTapped:(id)sender;
- (ALAssetsLibrary *)defaultAssetsLibrary;

@end

@implementation CameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self layoutCameraView];
    [self getCameraStarted];
}

- (void)getCameraStarted
{
    //Capture Session
    AVCaptureSession *session = [[AVCaptureSession alloc]init];
    session.sessionPreset = AVCaptureSessionPresetPhoto;
    
    //Add device
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //Input
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    if (!input)
    {
        NSLog(@"No Input");
    }
    
    [session addInput:input];
    
    //Output
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    [session addOutput:output];
    output.videoSettings =
    @{(NSString *)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA)};
    
    //Preview Layer
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    UIView *myView = self.previewView;
    previewLayer.frame = myView.bounds;
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [myView.layer addSublayer:previewLayer];
    
    //Start capture session
    [session startRunning];    
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.previewImageAsset) {
        NSLog(@"album image picked");
        [self.previewImageView setImage:[UIImage imageWithCGImage:[[self.previewImageAsset defaultRepresentation] fullScreenImage] scale:[[self.previewImageAsset defaultRepresentation] scale] orientation:0]];
    } else if (self.imagePassed) {
        NSLog(@"new image");
        [self.previewImageView setImage:self.imagePassed];
        self.imagePassed = nil;
        
        // find current location
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        self.imageCounter = 0;
        [self.locationManager startUpdatingLocation];
    } else {
        [self loadAlbum];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutCameraView
{
    [self loadAlbum];
    
    self.albumCollectionView.delegate = self;
    self.albumCollectionView.dataSource = self;
    self.mainScrollView.delegate = self;
    
    CGFloat screenWidth = self.view.bounds.size.width;
    CGFloat screenHeight = self.view.bounds.size.height;
    CGFloat tabBarHeight = [[[super tabBarController] tabBar] frame].size.height;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.mainScrollView setFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [self.mainScrollView setContentSize:CGSizeMake(screenWidth, screenHeight+screenWidth)];
    
    [self.albumCollectionView setFrame:CGRectMake(0, screenWidth+64+40, screenWidth, screenHeight-(screenWidth+64+40))];
    
    UIEdgeInsets albumInset = UIEdgeInsetsMake(self.albumCollectionView.contentInset.top, 0, tabBarHeight, 0);
    [self.albumCollectionView setContentInset:albumInset];
    
}

-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UICollectionView Delegate + Datasource methods + Library Assets Methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    albumThumbCollectionViewCell *cell = (albumThumbCollectionViewCell *)[self.albumCollectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    
    ALAsset *asset = self.assets[indexPath.row];
    [cell setAsset:asset];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.assets count];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ALAsset *asset = self.assets[indexPath.row];
    ALAssetRepresentation *defaultRep = [asset defaultRepresentation];
    [self.previewImageView setImage:[UIImage imageWithCGImage:[defaultRep fullScreenImage] scale:[defaultRep scale] orientation:0]];
    self.previewImageAsset = asset;
    
    [UIView animateWithDuration:.3 animations:^{
        [self.mainScrollView setContentOffset:CGPointZero];
    } completion:^(BOOL finished) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }];
}

- (void)loadAlbum
{
    _assets = [@[] mutableCopy];
    __block NSMutableArray *tmpAssets = [@[] mutableCopy];
    ALAssetsLibrary *assetsLibrary = [self defaultAssetsLibrary];
    
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if(result)
            {
                [tmpAssets addObject:result];
            }
        }];
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
        self.assets = [tmpAssets sortedArrayUsingDescriptors:@[sort]];
        [self.albumCollectionView reloadData];
        
    } failureBlock:^(NSError *error) {
        NSLog(@"Error loading images %@", error);
    }];
}

#pragma mark - IBActions methods

- (IBAction)nextTapped:(id)sender {
    
}

- (IBAction)cancelTapped:(id)sender {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.previewImageView setImage:nil];
    self.previewImageAsset = nil;
}

- (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

#pragma mark - UIScrollView Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat screenWidth = self.view.bounds.size.width;
    CGFloat screenHeight = self.view.bounds.size.height;
    
    [self.albumCollectionView setFrame:CGRectMake(0, screenWidth+64+40, screenWidth, screenHeight-(screenWidth+64+40)+self.mainScrollView.contentOffset.y)];
    
}

#pragma mark - Navigation Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PostFormTableViewController *segueVC = segue.destinationViewController;
    segueVC.assetPassed = self.previewImageAsset;
}

#pragma mark - Controller Methods
- (void)clearPreviewImageAsset
{
    self.previewImageAsset = nil;
}

#pragma mark - CLLocation Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [self.locationManager stopUpdatingLocation];
    
    // create metadata dictionary
    NSMutableDictionary *metadata = [[NSMutableDictionary alloc] init];
    [metadata setLocation:newLocation];
    [metadata setImageOrientation:self.previewImageView.image.imageOrientation];
    [metadata setDateOriginal:[NSDate date]];
    
    if (self.imageCounter == 0) {
    // add to asset library
    ALAssetsLibrary *assetsLibrary = [self defaultAssetsLibrary];
    [assetsLibrary writeImageToSavedPhotosAlbum:[self.previewImageView.image CGImage] metadata:metadata completionBlock:^(NSURL *assetURL, NSError *error) {
        NSLog(@"image saved");
        [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            NSLog(@"asset found");
            self.previewImageAsset = asset;
            self.assets = [@[asset] arrayByAddingObjectsFromArray:self.assets];
            [self.albumCollectionView reloadData];
        } failureBlock:^(NSError *error) {
            NSLog(@"failed to retrieve asset");
        }];
        
    }];
        self.imageCounter += 1;
    }
}

@end
