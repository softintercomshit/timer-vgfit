#import <Foundation/Foundation.h>

@interface BundleImageLoader : NSObject

+ (void)loadImageWithFilePath:(NSString *)filePath completion:(void (^)(UIImage *image))processImage;
+ (void)loadImageWithName:(NSString *)imageName completion:(void (^)(UIImage *image))processImage;

@end
