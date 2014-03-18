/**
 * 图片缩放
 * @author qianjiefeng
 *
 */

@interface UIImage(Scale)
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

- (UIImage*)imageScalWithMaxWidth:(float)mw maxHeight:(float)mh;
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
@end
