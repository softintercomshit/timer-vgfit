#import "BundleImageLoader.h"

@implementation BundleImageLoader

+ (void)loadImageWithFilePath:(NSString *)filePath completion:(void (^)(UIImage *image))processImage {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        UIImage *loadedImage = [UIImage imageWithContentsOfFile:filePath];
        dispatch_async(dispatch_get_main_queue(), ^{
            processImage(loadedImage);
        });
    });
}

+ (void)loadImageWithName:(NSString *)imageName completion:(void (^)(UIImage *image))processImage {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        UIImage *loadedImage = [UIImage imageNamed:imageName];
        dispatch_async(dispatch_get_main_queue(), ^{
            processImage(loadedImage);
        });
    });
}

@end
