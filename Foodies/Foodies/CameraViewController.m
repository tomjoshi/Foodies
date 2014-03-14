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

@interface CameraViewController () <DBCameraViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;
@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;
@property (weak, nonatomic) IBOutlet UIView *scrollHandle;
@property (weak, nonatomic) IBOutlet UICollectionView *albumCollectionView;
@property (nonatomic, strong) NSArray *assets;

- (void)layoutCameraView;
- (IBAction)nextTapped:(id)sender;
- (IBAction)cancelTapped:(id)sender;
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
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self layoutCameraView];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.imageView.image = self.imagePassed;
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

- (IBAction)flashTouched:(id)sender {
    UIViewController *vC = [[UIViewController alloc] init];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController pushViewController:vC animated:YES];
}

- (IBAction)useCamera:(id)sender {
//    if ([UIImagePickerController isSourceTypeAvailable:
//         UIImagePickerControllerSourceTypeCamera])
//    {
//        UIImagePickerController *imagePicker =
//        [[UIImagePickerController alloc] init];
//        imagePicker.delegate = self;
//        imagePicker.sourceType =
//        UIImagePickerControllerSourceTypeCamera;
//        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
//        imagePicker.allowsEditing = NO;
//        [self presentViewController:imagePicker
//                           animated:YES completion:nil];
//        _newMedia = YES;
//    }
    
    [self openCustomCamera:nil];
}

- (IBAction)useCameraRoll:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker
                           animated:YES completion:nil];
        _newMedia = NO;
    }
}

#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        _imageView.image = image;
        if (_newMedia)
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        // Code here to support video if enabled
    }
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

#pragma mark - DBCameraViewControllerDelegate

- (void) captureImageDidFinish:(UIImage *)image
{
    [self.imageView setImage:image];
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void) openCameraWithoutSegue
{
    DBCameraViewController *cameraController = [DBCameraViewController initWithDelegate:self];
    [cameraController setUseCameraSegue:NO];
    cameraController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cameraController];
    [nav setNavigationBarHidden:YES];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void) openCustomCamera:(id)sender
{
    CustomCamera *camera = [CustomCamera initWithFrame:[[UIScreen mainScreen] bounds]];
    [camera buildInterface];
    
    DBCameraViewController *cameraController = [[DBCameraViewController alloc] initWithDelegate:self cameraView:camera];
    [cameraController setUseCameraSegue:NO];
    cameraController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:cameraController animated:YES completion:nil];
}

#pragma mark - UICollectionView Delegate + Datasource methods + Library Assets Methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    albumThumbCollectionViewCell *cell = (albumThumbCollectionViewCell *)[self.albumCollectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    
    ALAsset *asset = self.assets[indexPath.row];
    [cell setAsset:asset];
    cell.backgroundColor = [UIColor redColor];
    
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
    [self.imageView setImage:[UIImage imageWithCGImage:[defaultRep fullScreenImage] scale:[defaultRep scale] orientation:0]];
    
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

        self.assets = [[tmpAssets reverseObjectEnumerator] allObjects];
        
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
    [self.imageView setImage:nil];
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

@end
